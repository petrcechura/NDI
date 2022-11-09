library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    generic (
        bit_size : integer := 16
    );
end entity;

architecture rtl of test is
    component SPI_Interface is
        generic (
            bit_size : integer := bit_size
        );
    
        port (
            CS_b, SCLK, MOSI : in std_logic;
            MISO : out std_logic;
            wr_data : in std_logic;
            data_out : out std_logic_vector (bit_size-1 downto 0);
            data_in : in std_logic_vector (bit_size-1 downto 0);
            clk : in std_logic;
            rst : in std_logic;
            frame_start, frame_stop, frame_error : out std_logic
        );
    end component;

    signal SCLK, MOSI, MISO, wr_data, clk, rst : std_logic := '0';
    signal CS_b : std_logic := '1';
    signal data_in, data_out : std_logic_vector(bit_size-1 downto 0);
    constant clk_period : time := 20 ns;
    constant SCLK_period : time := 10 us;
    signal frame_start, frame_stop, frame_error : std_logic := '0';
    signal sent_bits : unsigned(bit_size-1 downto 0) := "1111000011110000";

    procedure send_bits (signal bits : in unsigned(bit_size-1 downto 0);
                         signal mosi_s : out std_logic ) is
    begin
        for i in bits'length-1 downto 0 loop
            wait until rising_edge(sclk);
            mosi_s <= bits(i);
        end loop;
        wait until rising_edge(sclk);
    end procedure;
        
begin

    uut: SPI_interface
        generic map (
            bit_size => bit_size
        )
        port map (
            clk   => clk,
            CS_b => CS_b,
            wr_data => wr_data,
            SCLK => SCLK,
            MOSI => MOSI,
            MISO => MISO,
            data_in => data_in,
            data_out => data_out,
            rst => rst,
            frame_start => frame_start,
            frame_stop => frame_stop,
            frame_error => frame_error
        );


    clk_process: process
    begin
        for i in 0 to 100000 loop
            clk <= '1';
            wait for clk_period/2;
            clk <= '0';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    SCLK_process: process
    begin
        wait for clk_period*10;
        for i in 0 to 100 loop
            SCLK <= '1';
            wait for SCLK_period/2;
            SCLK <= '0';
            wait for SCLK_period/2;
        end loop;
        wait;
    end process;

    main_process: process
    begin
        --reset
        wait for clk_period;
        rst <= '1';
        wait until rising_edge(sclk);
        rst <= '0';
        wait for 2*sclk_period;
        wait until rising_edge(sclk);
        --nastaveni zapisu dat
        CS_b <= '0';

        --data - "0101 0101 1100 0011"
        send_bits(sent_bits, MOSI);
        
        --zruseni zapisu
        CS_b <= '1';

        --nastaveni zapisu
        wait until rising_edge(sclk);
        CS_b <= '0';

        --data - "0101 0101 1100 0011 1" chyba
        send_bits(sent_bits, MOSI);
        wait until rising_edge(sclk);
        MOSI <= '1';
        
        --zruseni zapisu
        wait until rising_edge(sclk);
        CS_b <= '1';
        wait;
    end process;
end architecture;
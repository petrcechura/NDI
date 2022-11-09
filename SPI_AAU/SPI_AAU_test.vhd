library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test is
    generic (
        bit_size : integer := 16
    );
end entity;

architecture rtl of test is
    component SPI_AAU is
        generic (
            bit_size : integer := 16
        );
    
        port (
            clk   : in std_logic;
            reset : in std_logic;
            SCLK, MOSI, CS_b : in std_logic;
            MISO : out std_logic
        );
    end component;

    signal SCLK, MOSI, MISO, CS_b, clk, reset : std_logic := '0';

    constant clk_period : time := 20 ns;
    constant SCLK_period : time := 10 us;

    signal sent_bits : unsigned(bit_size-1 downto 0) := "0000000000001010";

    procedure send_bits (signal bits : in unsigned(bit_size-1 downto 0);
                         signal mosi_s : out std_logic ) is
    begin
        for i in bits'length-1 downto 0 loop
            wait until rising_edge(SCLK);
            mosi_s <= bits(i);
        end loop;
        wait until rising_edge(SCLK);
    end procedure;
        
begin

    uut: SPI_AAU
        generic map (
            bit_size => bit_size
        )
        port map (
            MOSI => MOSI,
            MISO => MISO,
            SCLK => SCLK,
            CS_b => CS_b,
            reset => reset,
            clk => clk
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
        for i in 0 to 150 loop
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
        CS_b <= '1';
        wait for clk_period;
        reset <= '1';
        wait until rising_edge(sclk);
        reset <= '0';
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

        --data - "0101 0101 1100 0011" chyba
        send_bits(sent_bits, MOSI);
        --wait until rising_edge(sclk);
        --MOSI <= '1';
        
        --zruseni zapisu
        --wait until rising_edge(sclk);
        CS_b <= '1';


        
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

        --data - "0101 0101 1100 0011" chyba
        send_bits(sent_bits, MOSI);
        --wait until rising_edge(sclk);
        --MOSI <= '1';
        
        --zruseni zapisu
        --wait until rising_edge(sclk);
        CS_b <= '1';

        wait;
    end process;
end architecture;
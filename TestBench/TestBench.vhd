library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
    use work.Ver_pkg.all;

entity TestBench is
    generic (
        bit_size : integer := 16
    );
end entity;


architecture rtl of TestBench is

    constant clk_period : time := 10 ns;

    --to toggle clk signal
    signal clk_en : std_logic := '0';

    --between TestBench and SPI_AAU
    signal rst : std_logic := '0';
    signal clk : std_logic := '0';

    --between BFM and TestBench
    signal bfm_com : t_bfm_com := (frame => (others => '0'),
                                   fr_size => 16,
                                   start => '0',
                                   reset => '0');
    signal bfm_results : t_bfm_rep := (result => (others => '0'),
                                       start => '0',
                                       done => '0');
    signal test_end : std_logic := '0';

    --between SPI_AAU and BFM
    signal s_mosi, s_miso, s_sclk, s_cs_b : std_logic;

    --in process
    signal frame1 : signed(16-1 downto 0) := (others => '0');
    signal frame2 : signed(16-1 downto 0) := (others => '0');

    signal fr1_size, fr2_size : integer;
    signal delay : time := 200 us;



begin

    BFM_I: entity work.BFM(rtl)
        port map (
            --to testbench
            bfm_com => bfm_com,
            bfm_rep => bfm_results,
            test_end => test_end,
            --to SPI_AAU
            mosi => s_mosi,
            miso => s_miso,
            sclk => s_sclk,
            cs_b => s_cs_b

        );

    DUT_I: entity work.SPI_AAU(rtl)
        port map (
            clk => clk,
            reset => bfm_com.reset,
            MOSI => s_mosi,
            MISO => s_miso,
            SCLK => s_sclk,
            CS_b => s_cs_b
         );

    

    TESTCASE_P: process
    begin
        clk_en <= '1';
        bfm_com.reset <= '1';
        wait for 10 us;
        bfm_com.reset <= '0';

        frame1 <= "1000000000000001";
        frame2 <= "0010000000000100";
        fr1_size <= 16;
        fr2_size <= 16;

        SendPacket(bfm_com, bfm_results,
                   frame1, frame2,
                   fr1_size, fr2_size,
                   delay);

        
        test_end <= '1';
        clk_en <= '0';
        wait;
    end process;


    BFM_clk_P: process
    begin
        wait until(clk_en);
        while(clk_en = '1') loop
            clk <= '1';
            wait for clk_period/2;
            clk <= '0';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

end architecture;
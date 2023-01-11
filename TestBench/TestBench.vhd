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

    --to toggle clk signal
    signal clk_en : std_logic := '0';

    --between TestBench and SPI_AAU
    signal rst : std_logic := '0';
    signal clk : std_logic := '0';

    --between BFM and TestBench
    signal bfm_com : t_bfm_com := (frame => (others => '0'),
                                   fr_size => 16,
                                   start => '0',
                                   reset => '0',
                                   sclk_period => 10 us);
    signal bfm_results : t_bfm_rep := (result => (others => '0'),
                                       start => '0',
                                       done => '0');
    signal test_end : std_logic := '0';

    --between SPI_AAU and BFM
    signal s_mosi, s_miso, s_sclk, s_cs_b : std_logic;



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
        variable frame1 : signed(16-1 downto 0) := "0001110000111110"; -- 28.2421875
        variable frame2 : signed(16-1 downto 0) := "1111100111000011"; -- -6.23828125
        variable frame3 : signed(16-1 downto 0) := "0000001100011100"; -- 3.109375
        variable fr1_size : integer := 16;
        variable fr2_size : integer := 16;
        variable fr3_size : integer := 16;
        variable delay : time := 900 us;
    begin
        clk_en <= '1';

        --TEST č. 1 - odeslani spravneho packetu 
        report "-------TEST NO. 1-------";
        SendRightPacket(bfm_com, bfm_results,
                   frame1, frame2,
                   fr1_size, fr2_size,
                   delay);

        --TEST č. 2 - odeslani packetu se zpozdenym druhym ramcem (a naslednou opravou)
        delay := 1100 us;
        report "-------TEST NO. 2-------";
        SendWrongPacket(bfm_com, bfm_results,
                        frame1, frame2, frame3,
                        fr1_size, fr2_size, fr3_size,
                        delay);

        --TEST č. 3 - odeslani packetu s moc dlouhym prvnim ramcem (a naslednou opravou)
        delay := 500 us;
        report "-------TEST NO. 3-------";
        fr1_size := 19;
        fr2_size := 16;
        SendWrongPacket(bfm_com, bfm_results,
                        frame1, frame2, frame3,
                        fr1_size, fr2_size, fr3_size,
                        delay);
        
        --TEST č. 4 - odeslani packetu s moc dlouhym druhym ramcem (a naslednou opravou)
        report "-------TEST NO. 4-------";
        fr1_size := 16;
        fr2_size := 19;
        SendWrongPacket(bfm_com, bfm_results,
                        frame1, frame2, frame3,
                        fr1_size, fr2_size, fr3_size,
                        delay);

        --TEST č. 5 - odeslani packetu s moc kratkym prvnim ramcem (a naslednou opravou)
        report "-------TEST NO. 5-------";
        fr1_size := 12;
        fr2_size := 16;
        SendWrongPacket(bfm_com, bfm_results,
                        frame1, frame2, frame3,
                        fr1_size, fr2_size, fr3_size,
                        delay);

        --TEST č. 6 - odeslani packetu s moc kratkym druhym ramcem (a naslednou opravou)
        report "-------TEST NO. 6-------";
        fr1_size := 16;
        fr2_size := 12;
        SendWrongPacket(bfm_com, bfm_results,
                        frame1, frame2, frame3,
                        fr1_size, fr2_size, fr3_size,
                        delay);

        --TEST č. 7 - odeslani spravneho packetu s hodnotami pro zaokrouhleni nahoru
        report "-------TEST NO. 7-------";
        fr1_size := 16;
        fr2_size := 16;
        frame1 := "0000111011110010"; -- 14.9453125
        frame2 := "0111111111111001"; -- 127.97265625
        SendRightPacket(bfm_com, bfm_results,
                   frame1, frame2,
                   fr1_size, fr2_size,
                   delay);

        --TEST č. 8 - odeslani spravneho packetu s hodnotami pro zaokrouhleni dolu (scitani)
        report "-------TEST NO. 8-------";
        frame1 := "1000001001111010"; -- -125.5234375
        frame2 := "1000111111111100"; -- -112.015625
        SendRightPacket(bfm_com, bfm_results,
                   frame1, frame2,
                   fr1_size, fr2_size,
                   delay);

        --TEST č. 9 - odeslani spravneho packetu s hodnotami pro zaokrouhleni dolu (nasobeni)
        report "-------TEST NO. 9-------";
        frame1 := "0000111011110010"; -- 14.9453125
        frame2 := "1110011111111001"; -- -24.02734375
        SendRightPacket(bfm_com, bfm_results,
                   frame1, frame2,
                   fr1_size, fr2_size,
                   delay);

        test_end <= '1';
        clk_en <= '0';
        
        wait;
    end process;


    BFM_clk_P: process
        constant clk_period : time := 20 ns; -- 50 MHz
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
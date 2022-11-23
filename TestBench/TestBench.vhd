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
    signal bfm_com : t_bfm_com;
    signal bfm_results : t_bfm_rep;
    signal test_end : std_logic := '0';

    --between SPI_AAU and BFM
    signal s_mosi, s_miso, s_sclk, s_cs_b : std_logic;

    --in process
    signal frame1 : signed(frame_size+3 downto 0) := (others => '0');
    signal frame2 : signed(frame_size+3 downto 0) := (others => '0');



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
            reset => rst,
            MOSI => s_mosi,
            MISO => s_miso,
            SCLK => s_sclk,
            CS_b => s_cs_b
         );

    

    TESTCASE_P: process
    begin
        clk_en <= '1';

        frame1 <= "00001111000011110000";
        frame2 <= "00001111000011110000";

        report "Starting test no. 1";
        --test odeslani spravneho packetu
        SendPacket("00001111000011110000", --1st frame
                   "00001111000011110000", --2nd frame
                   16, --size of 1st frame
                   16, --size of 2nd frame
                   500 us, --delay
                   rst,
                   bfm_com); --(don't change)
        GetPacket(bfm_results);

        report "Starting test no. 2";
        --test odeslani nespravneho packetu (chybny pocet bitu v prvnim framu)
        SendPacket("00001111000011110000",
                   "00001111000011110000",
                   18,
                   16,
                   500 us,
                   rst,
                   bfm_com); --(don't change)
        GetPacket(bfm_results);


        report "Starting test no. 3";
        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu)
        SendPacket("00001111000011110000",
                   "00001111000011110000",
                   16,
                   18,
                   500 us,
                   rst,
                   bfm_com); --(don't change)
        GetPacket(bfm_results);


        report "Starting test no. 4";
        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu) s naslednou opravou



        report "Starting test no. 5";
        --test odeslani packetu s prilis velkym zpozdenim
        SendPacket("00001111000011110000",
                   "00001111000011110000",
                   16,
                   16,
                   5000 us,
                   rst,
                   bfm_com); --(don't change)
        GetPacket(bfm_results);



        report "Starting test no. 6";
        --test odeslani packetu s pretecenim
        SendPacket("00001111000011110000",
                   "00001111000011110000",
                   16,
                   16,
                   500 us,
                   rst,
                   bfm_com); --(don't change)
        GetPacket(bfm_results);

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
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

    --between TestBench and BFM_clk
    signal clk_en : std_logic := '0';

    --between TestBench and SPI_AAU
    signal rst : std_logic := '0';

    --between BFM_clk and SPI_AAU
    signal clk : std_logic := '0';

    --between BFM and TestBench
    signal bfm_com : t_bfm_com;
    signal bfm_results : t_bfm_rep;

    --between SPI_AAU and BFM
    signal s_mosi, s_miso, s_sclk, s_cs_b : std_logic;



begin

    BFM_I: entity work.BFM(rtl)
        port map (
            --to testbench
            bfm_com => bfm_com,
            bfm_rep => bfm_results,
            --to SPI_AAU
            mosi => s_mosi,
            miso => s_miso,
            sclk => s_sclk,
            cs_b => s_cs_b

        );

    BFM_clk_I: entity work.BFM_clk(rtl)
        port map (
            clk_en => clk_en,
            clk_out => clk
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
        --test odeslani spravneho packetu
        SendPacket("0000111100001111", --1st frame
                   "0000111100001111", --2nd frame
                   16, --size of 1st frame
                   16, --size of 2nd frame
                   500 us, --delay
                   bfm_com, --(don't change)
                   bfm_results); --(don't change)
        GetPacket(bfm_results.add_res,
                  bfm_results.mul_res);

        --test odeslani nespravneho packetu (chybny pocet bitu v prvnim framu)
        SendPacket("000011110000111101",
                   "0000111100001111",
                   18,
                   16,
                   500 us,
                   bfm_com,
                   bfm_results);
        GetPacket(bfm_results.add_res,
                  bfm_results.mul_res);
        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu)
        SendPacket("0000111100001111",
                   "000011110000111101",
                   16,
                   18,
                   500 us,
                   bfm_com,
                   bfm_results);
        GetPacket(bfm_results.add_res,
                   bfm_results.mul_res);
        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu) s naslednou opravou

        --test odeslani packetu s prilis velkym zpozdenim
        SendPacket("0000111100001111",
                   "0000111100001111",
                   16,
                   16,
                   5000 us,
                   bfm_com,
                   bfm_results);
        GetPacket(bfm_results.add_res,
                   bfm_results.mul_res);
        --test odeslani packetu s pretecenim
        SendPacket("1111111111110101",
                   "1111111111101010",
                   16,
                   16,
                   500 us,
                   bfm_com,
                   bfm_results);
        GetPacket(bfm_results.add_res,
                   bfm_results.mul_res);
    end process;

end architecture;
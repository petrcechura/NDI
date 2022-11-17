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

    signal clk_en : std_logic := '0';
    signal rst : std_logic := '0';
    signal clk : std_logic := '0';

    signal bfm_com : t_bfm_com;
    signal bfm_results : t_bfm_rep;



begin

    BFM_I: entity work.BFM(rtl)
        port map (

        );

    BFM_clk_I entity work.BFM_clk(rtl)
        port map (
            clk_en => clk_en,
            clk_out => clk;
        );

    

    TESTCASE_P: process
    begin
        
        --test odeslani spravneho packetu
        SendPacket("0000111100001111",
                   "0000111100001111",
                   16,
                   16,
                   500 us,
                   bfm_com,
                   bfm_rep);
        wait until rising_edge(bfm_rep);

        --test odeslani nespravneho packetu (chybny pocet bitu v prvnim framu)

        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu)

        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu) s naslednou opravou

        --test odeslani packetu s prilis velkym zpozdenim

        --test odeslani packetu s pretecenim
    end process;

end architecture;
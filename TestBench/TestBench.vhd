library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestBench is
    generic (
        bit_size : integer := 16
    );
end entity;


architecture rtl of TestBench is

    constant clk_period : time := 10 ns;

    signal clk_en : std_logic := '0';
    signal rst : std_logic := '0';
    signal clk : std_logic;

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

        --test odeslani nespravneho packetu (chybny pocet bitu v prvnim framu)

        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu)

        --test odeslani nespravneho packetu (chybny pocet bitu ve druhem framu) s naslednou opravou

        --test odeslani packetu s prilis velkym zpozdenim

        --test odeslani packetu s pretecenim
    end process;

end architecture;
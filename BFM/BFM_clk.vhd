library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity BFM_clk is

    port (
        clk_en   : in std_logic;
        clk_out : out std_logic
    );
end entity;

architecture rtl of BFM_clk is
        constant clk_period : time := 10 ns;
begin

        process
        begin
            while clk_en='1' loop
                clk_out <= '1';
                wait for clk_period/2;
                clk_out <= '0';
                wait for clk_period/2;
            end loop;
        end process;

end architecture;
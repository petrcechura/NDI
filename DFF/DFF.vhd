library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DFF is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        data_in : in std_logic;
        data_out : out std_logic
    );
end entity;


architecture rtl of DFF is
    signal data_reg : std_logic := '0';
begin

    process (clk, reset)
    begin
        if reset = '1' then
            data_reg <= '0';
            data_out <= '0';
        elsif rising_edge(clk) then
            data_reg <= data_in;
            data_out <= data_reg;
        end if;
    end process;
    

end architecture;
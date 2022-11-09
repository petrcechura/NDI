library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ris_fall_detector is
    port (
        clk   : in std_logic;
        data_in : in std_logic;
        ris_out, fall_out : out std_logic;
        rst : in std_logic
    );
end entity;

architecture rtl of Ris_fall_detector is
    signal d_out : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                d_out <= '0';
            else
                d_out <= data_in;
            end if;
        end if;
    end process;

    ris_out <= '1' when data_in='1' and d_out='0' else '0';
    fall_out <= '1' when data_in='0' and d_out='1' else '0';

end architecture;
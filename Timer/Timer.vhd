library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic (
        constant time_val : integer := 1; --in ms
        constant frequency : integer := 50 --in MHz
    );
    port (
        clk   : in std_logic;
        reset : in std_logic;
        timer_start : in std_logic;
        timer_stop : out std_logic
    );
end entity;

architecture rtl of Timer is
    constant max_cycles_of_clock : integer := 50000;
    signal time_value_s : unsigned(15 downto 0) := (others => '0');
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if timer_start='1' then
                time_value_s <= time_value_s + 1;
            else
                time_value_s <= (others => '0');
            end if;

            if time_value_s>max_cycles_of_clock then
                timer_stop <= '1';
            else
                timer_stop <= '0';
            end if;
        end if;
    end process;

end architecture;
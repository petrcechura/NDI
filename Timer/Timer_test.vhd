library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end entity;


architecture rtl of test is
    signal timer_start, timer_stop, clk, reset : std_logic;
    constant clk_period : time := 20 ns;
    constant time_val : integer := 1;
begin

    TIMER_I: entity work.Timer(rtl)
        generic map (
            time_val => time_val,
            frequency => 50
        )
        port map (
            timer_start => timer_start,
            timer_stop => timer_stop,
            clk => clk,
            reset => reset
        );

        process
        begin
            timer_start <= '1';
            for i in 0 to 60000 loop
                clk <= '1';
                wait for clk_period/2;
                clk <= '0';
                wait for clk_period/2;
            end loop;
            wait;
        end process;

end architecture;
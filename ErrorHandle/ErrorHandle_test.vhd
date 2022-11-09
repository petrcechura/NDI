library ieee;
use ieee.std_logic_1164.all;

entity test is
end entity;


architecture rtl of test is
    signal clk : std_logic;
    signal reset : std_logic;
    signal CS_b_ris : std_logic;
    signal CS_b_fall : std_logic;
    signal SCLK_ris : std_logic;
    signal SCLK_fall : std_logic;
    signal frame_start : std_logic;
    signal frame_stop : std_logic;
    signal frame_error : std_logic;
    constant clk_period : time := 10 ns;
begin

    uut: entity work.ErrorHandle(rtl)
        port map (
        clk => clk,
        reset =>reset,
        CS_b_ris => CS_b_ris,
        CS_b_fall => CS_b_fall,
        SCLK_ris => SCLK_ris,
        SCLK_fall => SCLK_fall,
        frame_start => frame_start,
        frame_stop => frame_stop,
        frame_error => frame_error
        );
    
        clk_process: process
        begin
            for i in 0 to 255 loop
                clk <= '1';
                wait for clk_period/2;
                clk <= '0';
                wait for clk_period/2;
            end loop;
            wait;
        end process;

        main : process (all)
        begin
            wait for 5*clk_period;
            CS_b_fall <= '1';
            wait until rising_edge(clk);
            CS_b_fall <= '0';

            wait until rising_edge(clk);
            SCLK_fall <= '1';
        end process;

end architecture;
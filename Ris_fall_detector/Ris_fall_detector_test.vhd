library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end entity;

architecture rtl of test is
    component Ris_fall_detector is
        port (
            clk   : in std_logic;
            data_in : in std_logic;
            ris_out : out std_logic;
            fall_out : out std_logic;
            rst : in std_logic
        );
    end component;

    signal clk, rst : std_logic := '0';
    signal data_in, ris_out, fall_out : std_logic := '0';
    constant clk_period : time := 10 ns;
begin

    uut: Ris_fall_detector
        port map (
            clk   => clk,
            data_in => data_in,
            ris_out => ris_out,
            fall_out => fall_out,
            rst => rst
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

    process
    begin
        wait for clk_period*2;
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        wait for clk_period*2;
        wait until rising_edge(clk);
        data_in <= '1';
        wait for clk_period*2;
        wait until rising_edge(clk);
        data_in <= '0';
        wait;
    end process;

end architecture;
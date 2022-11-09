library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    generic (
        t_size : integer := 8
    );
end entity;

architecture rtl of test is

    signal enable : std_logic := '0';
    signal clk : std_logic;
    signal data_in : std_logic_vector(t_size-1 downto 0) := (others => '0');
    signal load : std_logic := '0';
    signal data_out : std_logic := '0';
    constant clk_period : time := 10 ns;
begin

    serialiser: entity work.serialiser(rtl)
        port map (
            enable => enable,
            clk => clk,
            data_in => data_in,
            load => load,
            data_out => data_out
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
        enable <= '1';
        load <= '1';
        data_in <= "11001101";
        wait until rising_edge(clk);
        load <= '0';
        wait for clk_period * 10;
        load <= '1';
        data_in <= "11111111";
        wait for clk_period * 5;
        load <= '0';
        wait;
    end process;

end architecture;
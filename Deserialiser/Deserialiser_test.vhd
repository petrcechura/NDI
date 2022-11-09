library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    generic (
        t_size : integer := 8
    );
end entity;

architecture rtl of test is
    component Deserialiser is
        generic (
            size : integer := t_size
        );
        port (
            clk   : in std_logic;
            data_in : in std_logic;
            enable : in std_logic;
            data_out : out std_logic_vector (size-1 downto 0);
            rst : in std_logic
        );
    end component;

    signal clk : std_logic;
    signal rst : std_logic := '0';
    signal data_in : std_logic := '0';
    signal enable : std_logic := '0';
    signal data_out : std_logic_vector (t_size-1 downto 0) := (others => '0');
    constant clk_period : time := 10 ns;
begin

    uut: Deserialiser
        port map (
            clk   => clk,
            data_in => data_in,
            enable => enable,
            data_out => data_out,
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
        enable <= '0';
        wait for clk_period * 2;
        data_in <= '1';
        wait for clk_period * 3;
        enable <= '1';
        wait for clk_period*8;
        wait;
    end process;

end architecture;
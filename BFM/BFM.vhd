library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
    port (
        sclk : out std_logic;
        mosi : out std_logic;
        miso : in std_logic_vector(19 downto 0);
        cs_b : out std_logic;
        bfm_com : in std_logic_vector(3 downto 0); --replace with type from pkg
        bfm_rep : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of test is

    signal frame : unsigned(15 downto 0) := (others => '0') ;
    constant clk_period : time := 20 ns;
    constant SCLK_period : time := 10 us;

    procedure SendFrame (signal frame : in unsigned(15 downto 0);
                         signal output : out std_logic) is
    begin
        cs_b <= '0';
        sclk <= '0';
        wait for SCLK_period/2;

        for i in 0 downto 15 loop
            sclk <= '1';
            output <= frame(i);
            wait for SCLK_period/2;
            sclk <= '0';
            wait for SCLK_period/2;
        end loop;
    end procedure;
begin

    process (bfm_com)
    begin
        if bfm_com="0001" then

        elsif bfm_com="0010" then

        elsif bfm_com="0100" then

        elsif bfm_com="1000" then

        end if;
    end process;

end architecture;
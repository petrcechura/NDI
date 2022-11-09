library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestCase is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        bfm_com : out std_logic_vector(3 downto 0);
        bfm_rep : in std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of TestCase is

begin

    

end architecture;
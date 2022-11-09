library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestBench is
    generic (
        bit_size : integer := 16
    );

    port (
        clk   : in std_logic;
        reset : in std_logic;
        packet : in std_logic_vector((bit_size-1)*2 downto 0);
        frame : in std_logic_vector(bit_size-1 downto 0);
        result : out std_logic_vector(bit_size-1 downto 0);
        error : out std_logic -- je-li 1, nastal error
    );
end entity;
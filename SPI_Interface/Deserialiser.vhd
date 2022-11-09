
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Deserialiser is
    generic (
        size : integer := 8
    );

    port (
        clk   : in std_logic;
        data_in : in std_logic;
        enable : in std_logic;
        data_out : out std_logic_vector (size-1 downto 0);
        rst : in std_logic
    );
end entity;

architecture rtl of Deserialiser is
    signal data_sig : unsigned(size-1 downto 0) := (others => '0');

begin

    process (clk, enable)
    begin
        if rising_edge(clk) then
            if enable='1' then
                for i in 0 to size-2 loop
                    data_sig(i+1) <= data_sig(i);
                end loop;
                data_sig(0) <= data_in;
            end if;
        end if;
    end process;

    data_out <= std_logic_vector(data_sig);

end architecture;

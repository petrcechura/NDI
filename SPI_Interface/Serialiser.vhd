library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Serialiser is
    generic (
        size : integer := 8
    );
    port (
        clk   : in std_logic;
        data_in : in std_logic_vector(size-1 downto 0);
        enable : in std_logic;
        load : in std_logic;
        data_out : out std_logic;
        rst : in std_logic
    );
end entity;

architecture rtl of Serialiser is
    signal data_sig : std_logic_vector(size-1 downto 0) := (others => '0');
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                data_sig <= data_in;
            elsif enable = '1' then
                for i in 0 to size - 2 loop
                    data_sig(i+1) <= data_sig(i);
                end loop;
                data_sig(0) <= '0';
            end if;
        end if;
    end process;

    data_out <= data_sig(size-1);



end architecture;
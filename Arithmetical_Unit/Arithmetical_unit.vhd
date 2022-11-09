library ieee;

use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Arithmetical_unit is
    generic (
        bit_size : integer := 16
    );

    port (
        clk   : in std_logic;
        reset : in std_logic;
        data_fr1, data_fr2 : in std_logic_vector(bit_size-1 downto 0);
        we_data_fr1, we_data_fr2 : in std_logic;
        add_res, mul_res : out std_logic_vector(bit_size-1 downto 0)
    );
end entity;

architecture rtl of Arithmetical_unit is
    signal data_fr1_reg, data_fr2_reg : unsigned(bit_size-1 downto 0);
    signal mul_res_sig, add_res_sig : unsigned(bit_size-1 downto 0);
    
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset='1' then
                data_fr1_reg <= (others => '0');
                data_fr2_reg <= (others => '0');
            
            --pri enablu uloz do registru data pro operace
            elsif we_data_fr1='1' then
                data_fr1_reg <= unsigned(data_fr1);
            elsif we_data_fr2='1' then
                data_fr2_reg <= unsigned(data_fr2);
            else
                data_fr1_reg <= data_fr1_reg;
                data_fr2_reg <= data_fr2_reg;
            end if;
        end if;
    end process;

    --OSETRIT PRETECENI!!!
    --
    --

    process (data_fr1_reg, data_fr2_reg)
    begin
        add_res_sig <= data_fr1_reg + data_fr2_reg;
        mul_res_sig <= (others => '1'); --PREDELAT!!!
    end process;

    add_res <= std_logic_vector(add_res_sig);
    mul_res <= std_logic_vector(mul_res_sig);

end architecture;
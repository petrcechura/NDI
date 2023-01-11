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
        data_fr : in std_logic_vector(bit_size-1 downto 0);
        we_data_fr1, we_data_fr2 : in std_logic;
        add_res, mul_res : out std_logic_vector(bit_size-1 downto 0)
    );
end entity;

architecture rtl of Arithmetical_unit is
    signal data_fr1_reg, data_fr2_reg : signed(bit_size-1 downto 0);
    signal mul_res_sig : signed(bit_size*2-1 downto 0); --cisla, se kterymi se pracuje; potreba osekat a zaokrouhlit
    signal add_res_sig : signed(bit_size downto 0);
    signal add_res_final, mul_res_final : signed(bit_size-1 downto 0); --finalni cisla
    
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset='1' then
                data_fr1_reg <= (others => '0');
                data_fr2_reg <= (others => '0');
            
            --pri enablu uloz do registru data pro operace
            elsif we_data_fr1='1' then
                data_fr1_reg <= signed(data_fr);
            elsif we_data_fr2='1' then
                data_fr2_reg <= signed(data_fr);
            else
                data_fr1_reg <= data_fr1_reg;
                data_fr2_reg <= data_fr2_reg;
            end if;

            add_res <= std_logic_vector(add_res_final);
            mul_res <= std_logic_vector(mul_res_final);
        end if;
    end process;

    process (data_fr1_reg, data_fr2_reg)
    begin
        add_res_sig <= resize(data_fr1_reg, data_fr1_reg'length+1) + data_fr2_reg;
        mul_res_sig <= data_fr1_reg * data_fr2_reg;
    end process;

    process (add_res_sig) --zaokrouhleni scitani
    begin
        if add_res_sig>32767 then
            add_res_final <= "0111111111111111"; --max cislo
        elsif add_res_sig<-32768 then
            add_res_final <= "1000000000000000"; --min cislo
        else
            add_res_final <= add_res_sig(add_res_sig'length-2 downto 0);
        end if;
    end process;

    process (mul_res_sig, data_fr1_reg, data_fr2_reg) --zaokrouhleni nasobeni
    begin
        if data_fr1_reg(15)=data_fr2_reg(15) then --pokud jsou obe cisla kladna nebo zaporna
            if mul_res_sig(31 downto 23) /= "000000000" then
                mul_res_final <= "0111111111111111";
            else
                mul_res_final <= mul_res_sig(23 downto 8);
            end if;

        else --jedno je kladne, druhe zaporne
            if mul_res_sig(31 downto 23) /= "111111111" then
                mul_res_final <= "1000000000000000";
            else
                mul_res_final <= mul_res_sig(23 downto 8);
            end if;
        end if;
    end process;

end architecture;
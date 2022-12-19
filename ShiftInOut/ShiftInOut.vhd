library ieee;
use ieee.std_logic_1164.all;

entity ShiftInOut is
    port (
        CS_b_ris, CS_b_fall, SCLK_ris, SCLK_fall : in std_logic;
        MISO_en, MOSI_en : out std_logic;
        clk : in std_logic;
        rst : in std_logic
    );
end entity;

architecture rtl of ShiftInOut is

    signal write_enable_sig : std_logic := '0';

begin

    process (clk)
    begin
        if rising_edge(clk) then
            --reset; zapis neni mozny
            if rst='1' then
                write_enable_sig <= '0';
                MISO_en <= '0';
                MOSI_en <= '0'; 
            else
                
                if CS_b_ris='1' then --zakazani zapisu pri CS_b log. 1
                    write_enable_sig <='0';
                elsif CS_b_fall='1' then --povoleni zapisu pri CS_b log. 0
                   write_enable_sig <= '1';
                else
                   write_enable_sig <= write_enable_sig;
                end if;

                if write_enable_sig='1' and CS_b_ris = '0' then  --je-li zapis povoleny, prepinej mezi enably podle SCLK  
                    if SCLK_ris='1' then
                        MISO_en <= '1'; --pri nabezne sclk povol serializer
                        MOSI_en <= '0';
                    elsif SCLK_fall='1' then
                       MOSI_en <= '1'; --pri sestupne sclk povol deserializer
                       MISO_en <= '0';
                    else
                        MISO_en <= '0';
                        MOSI_en <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;
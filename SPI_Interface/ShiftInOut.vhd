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

    signal write_enable_sig : std_logic := '1';
    signal miso_en_sig, mosi_en_sig : std_logic := '0';

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                write_enable_sig <= '0';
                miso_en_sig <= '0';
                mosi_en_sig <= '0';
                MISO_en <= '0';
                MOSI_en <= '0'; 
            else
                if CS_b_ris='1' then
                    write_enable_sig <='1';
                elsif CS_b_fall='1' then
                   write_enable_sig <= '0';
                else
                   write_enable_sig <= write_enable_sig;
                end if;

                if write_enable_sig='1' then    
                    if SCLK_ris='1' then
                        miso_en_sig <= '1';
                    elsif SCLK_fall='1' then
                       mosi_en_sig <= '1';
                   else
                       miso_en_sig <= miso_en_sig;
                       mosi_en_sig <= mosi_en_sig;
                   end if;
                end if;
            end if;
        end if;
    end process;

    MISO_en <= miso_en_sig;
    MOSI_en <= mosi_en_sig;
end architecture;
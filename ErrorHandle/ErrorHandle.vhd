library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ErrorHandle is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        CS_b_ris, CS_b_fall : in std_logic;
        SCLK_ris, SCLK_fall : in std_logic;
        frame_start, frame_stop, frame_error : out std_logic
    );
end entity;

architecture rtl of ErrorHandle is
    signal SCLK_ris_am_q, SCLK_fall_am_q : unsigned(4 downto 0) := (others => '0');
    signal write_enable : std_logic := '0';
    signal overflow : std_logic := '0';
    constant frame_size : integer := 16;
begin
    --sekvencni cast
    process (clk)
    begin
        if rising_edge(clk) then
            if reset='1' then
                SCLK_fall_am_q <= (others => '0');
                SCLK_ris_am_q <= (others => '0');
            -- zaznam erroru pouze pri CS_b = '0'
            else
                if CS_b_fall='1' then
                    write_enable <= '1';

                    frame_start <= '1';
                    frame_stop <= '0';
                    frame_error <= '0';
                elsif CS_b_ris='1' then
                    write_enable <= '0';
                    SCLK_fall_am_q <= (others => '0');
                    SCLK_ris_am_q <= (others => '0');

                    frame_start <= '0';
                    frame_stop <= '1';
                    frame_error <= '0' when SCLK_ris_am_q = frame_size and SCLK_fall_am_q = frame_size+1
                                       else '1';
                else
                    write_enable <= write_enable;

                    frame_start <= '0';
                    frame_stop <= '0';
                    frame_error <= '0';
                end if;
                --pocitani nabeznych a sestupnych hran
                if write_enable='1' and CS_b_ris = '0' then
                    if SCLK_ris='1' then
                        SCLK_ris_am_q <= SCLK_ris_am_q + 1;
                        if SCLK_ris_am_q>frame_size then -- je-li bitu nespravny pocet, vyhod chybu
                            frame_stop <= '0';
                            frame_error <= '1';
                        end if;
                    elsif SCLK_fall='1' then
                        SCLK_fall_am_q <= SCLK_fall_am_q + 1;
                        if SCLK_fall_am_q>frame_size+1 then -- je-li bitu nespravny pocet, vyhod chybu
                            frame_stop <= '0';
                            frame_error <= '1';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture;
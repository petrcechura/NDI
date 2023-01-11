library ieee;
use ieee.std_logic_1164.all;

entity PKT_FSM is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        frame_start, frame_stop, frame_error : in std_logic;
        we_data_fr1, we_data_fr2 : out std_logic; --urceni, do ktereho framu zapisujeme
        wr_data : out std_logic; --povoleni zapisu do serialiseru
        timer_start : out std_logic; 
        timer_get : in std_logic;
        --data_erase : out std_logic; --vymazani dat ze serialiseru (a AU) pri erroru
        mul_res_en : out std_logic
    );
end entity;

architecture rtl of PKT_FSM is
    type t_state is (S_awaiting_fr1, S_awaiting_fr2, S_getting_fr1, S_getting_fr2);
    signal fsm_state : t_state := S_awaiting_fr1;
    signal state_number : std_logic_vector(3 downto 0) := (others => '0'); 
begin

    process (clk, reset)
    begin
        if reset = '1' then
            fsm_state <= S_awaiting_fr1;  
        elsif rising_edge(clk) then
            case fsm_state is --pri nabezne hrane rozhodni o dalsim stavu

                when S_awaiting_fr1 =>
                    we_data_fr1 <= '0';
                    we_data_fr2 <= '0';
                    wr_data <= '0';
                    timer_start <= '0';

                    mul_res_en <= '0';

                    if frame_start='1' then --zacal-li prenos, prijimej data
                        fsm_state <= S_getting_fr1;
                        wr_data <= '1';
                    else
                        fsm_state <= S_awaiting_fr1;
                    end if;

                when S_getting_fr1 =>
                    we_data_fr1 <= '0';
                    we_data_fr2 <= '0';
                    wr_data <= '0';
                    timer_start <= '0';

                    mul_res_en <= '0';

                    if frame_error='1' then
                        --data_erase <= '1'; --doslo-li k chybe, vymaz data v deserialiseru
                        fsm_state <= S_awaiting_fr1;
                    elsif frame_stop='1' then
                        we_data_fr1 <= '1'; --bezchybny prenos posli do AU
                        fsm_state <= S_awaiting_fr2;
                        mul_res_en <= '1';
                        wr_data <= '1';
                    else
                        fsm_state <= S_getting_fr1;
                    end if;
                when S_awaiting_fr2 =>
                    we_data_fr1 <= '0';
                    we_data_fr2 <= '0';
                    wr_data <= '0';
                    timer_start <= '1'; --timer se nacita, dokud je toto v '1' (funguje jako enable)

                    mul_res_en <= '1';

                    if timer_get='1' then --pretece-li timer, vrat se do stavu 1
                        fsm_state <= S_awaiting_fr1;
                    elsif frame_start='1' then
                        fsm_state <= S_getting_fr2;
                        --wr_data <= '1';
                    end if;
                when S_getting_fr2 =>
                    we_data_fr1 <= '0';
                    we_data_fr2 <= '0';
                    wr_data <= '0';
                    timer_start <= '0';

                    mul_res_en <= '0';
                    
                    if frame_error='1' then
                        --data_erase <= '1';
                        fsm_state <= S_awaiting_fr2;
                    elsif frame_stop='1' then
                        we_data_fr2 <= '1'; --bezchybny prenos posli do AU
                        fsm_state <= S_awaiting_fr1;
                        --wr_data <= '1';
                    else
                        fsm_state <= S_getting_fr2;
                    end if;
            end case;
        end if;
    end process;

    state_number <= "1000" when fsm_state=S_awaiting_fr1
               else "0100" when fsm_state=S_getting_fr1
               else "0010" when fsm_state=S_awaiting_fr2
               else "0001" when fsm_state=S_getting_fr2
               else "0000";

end architecture;
library ieee;
use ieee.std_logic_1164.all;


entity test is
end entity;


architecture rtl of test is

    signal clk : std_logic;
    signal reset : std_logic;
    signal frame_start : std_logic;
    signal frame_stop : std_logic;
    signal frame_error : std_logic;
    signal data_out : std_logic_vector(15 downto 0);
    signal wr_data : std_logic;
    signal data_in : std_logic_vector(15 downto 0);
    signal we_data_fr1 : std_logic;
    signal we_data_fr2 : std_logic;
    signal data_fr1 : std_logic_vector(15 downto 0);
    signal data_fr2 : std_logic_vector(15 downto 0);
    signal add_res : std_logic_vector(15 downto 0);
    signal mul_res : std_logic_vector(15 downto 0);
    signal data_erase : std_logic;

 

    constant clk_period : time := 20 ns;
begin

    PKT_Control_I: entity work.PKT_Control(rtl)
            port map (
                clk  => clk,
                reset => reset,
                frame_start =>frame_start, 
                frame_stop =>frame_stop,
                frame_error=> frame_error,
                data_out=> data_out,
                wr_data => wr_data,
                data_in => data_in,
                we_data_fr1 =>we_data_fr1,
                we_data_fr2 => we_data_fr2,
                data_fr1 =>data_fr1,
                data_fr2 => data_fr2,
                add_res =>add_res,
                mul_res=> mul_res,
                data_erase=> data_erase
            );
    
    clk_process: process
        begin
            for i in 0 to 255 loop
                clk <= '1';
                wait for clk_period/2;
                clk <= '0';
                wait for clk_period/2;
            end loop;
            wait;
        end process;

    MAIN: process
    begin
        reset <= '1';
        wait for 2*clk_period;
        reset <= '0';
        wait for 2*clk_period;
        frame_start <= '1';
        wait for 3*clk_period;
        frame_start <= '0';
        wait for 5*clk_period;
        frame_stop <= '1';
        wait for 2*clk_period;
        frame_stop <= '0';

        wait for 2*clk_period;
        frame_start <= '1';
        wait for 3*clk_period;
        frame_start <= '0';
        wait for 5*clk_period;
        frame_stop <= '1';
        wait for 2*clk_period;
        frame_stop <= '0';
        wait;
    end process;


end architecture;
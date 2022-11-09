library ieee;
use ieee.std_logic_1164.all;

entity test is
end entity;

architecture rtl of test is
    component ShiftInOut is
        port (
            CS_b_ris, CS_b_fall, SCLK_ris, SCLK_fall : in std_logic;
            MISO_en, MOSI_en : out std_logic;
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    signal CS_b_ris, CS_b_fall, SCLK_ris, SCLK_fall : std_logic := '0';
    signal MISO_en, MOSI_en : std_logic := '0';
    signal clk, rst :  std_logic := '0';
    constant clk_period : time := 10 ns;

begin
    shift_in_out: ShiftInOut
        port map (
            CS_b_ris => CS_b_ris,
            CS_b_fall => CS_b_fall,
            SCLK_fall => SCLK_fall,
            SCLK_ris => SCLK_ris,
            MISO_en => MISO_en,
            MOSI_en => MOSI_en,
            rst => rst,
            clk => clk
        );
    
    clk_process: process
    begin
        for i in 0 to 100 loop
            clk <= '1';
            wait for clk_period/2;
            clk <= '0';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    main: process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        CS_b_ris <= '1';
        wait for clk_period;
        CS_b_ris <= '0';
        wait for clk_period;
        CS_b_fall <= '1';
        wait for clk_period;
        CS_b_fall <= '0';
        wait for clk_period*3;

        SCLK_ris <= '1';
        wait for clk_period;
        SCLK_ris <= '0';
        wait for clk_period*4;
        SCLK_fall <= '1';
        wait for clk_period;
        SCLK_fall <= '0';
        wait for clk_period*3;
        wait;
    end process;
    
end architecture;
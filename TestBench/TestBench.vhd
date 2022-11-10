library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestBench is
    generic (
        bit_size : integer := 16
    );
end entity;


architecture rtl of TestBench is

    constant clk_period : time := 10 ns;

    procedure SendRightPacket (<params>) is
    begin
        
    end procedure;

    procedure SendPacketOfWrongSize (<params>) is
    begin
        
    end procedure;

    procedure SendDelayedPacket (constant delay : time) is

    begin
        
    end procedure;
        
    

begin

    BFM_I: entity work.BFM(rtl)
        port map (
            
        );
    
    TESTCASE_I: entity work.TestBench(rtl)
        port map (
            
        );

    BFM_clk_I entity work.BFM_clk(rtl)
        port map (
            
        );

    process
    begin
        
    end process;




end architecture;
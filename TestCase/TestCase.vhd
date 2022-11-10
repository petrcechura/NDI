library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TestCase is
    port (
        bfm_com : out std_logic_vector(3 downto 0);
        --command 0001 = 
        --command 0010 = 
        --command 0100 = 
        --command 1000 = 
        bfm_rep : in std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of TestCase is
    
    procedure SendPacket (signal frame1 : std_logic_vector(19 downto 0);
                          signal frame2 : std_logic_vector(19 downto 0);
                          constant fr1_size : integer;
                          constant fr2_size : integer;
                          constant delay : time) is
    begin
        
    end procedure;
begin

    process(bfm_com) 
    begin
        
    end process;

end architecture;
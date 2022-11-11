library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package Ver_pkg is
    constant frame_size : integer := 16;
    constant am_of_commands : integer := 4;
    type t_testbench_to_bfm is record
        command : std_logic_vector(am_of_commands-1 downto 0);
        frame1 : std_logic_vector (frame_size-1 downto 0);
        frame2 : std_logic_vector (frame_size-1 downto 0);
        delay : time;
    end record;
    
    type t_bfm_to_dut is record
        miso : std_logic;
        mosi : std_logic;
        sclk : std_logic;
        cs_b : std_logic;
    end record;

    procedure SendPacket (signal frame1 : std_logic_vector(19 downto 0);
                          signal frame2 : std_logic_vector(19 downto 0);
                          constant fr1_size : integer;
                          constant fr2_size : integer;
                          constant delay : time);

    procedure SendRightPacket (signal frane1) is
    begin
                                
    end procedure;
                        
    procedure SendPacketOfWrongSize (<params>) is
    begin
                                
    end procedure;
                        
    procedure SendDelayedPacket (constant delay : time) is
    begin
                                
    end procedure;
        
end package;
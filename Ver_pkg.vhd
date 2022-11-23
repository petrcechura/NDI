library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package Ver_pkg is
    constant frame_size : integer := 16;
    type t_bfm_com is record --PREDELAT tak, aby obsahoval jeden frame
        frame : std_logic_vector(frame_size+3 downto 0); --frame size is 20
        fr_size : integer;
        start : std_logic;
    end record;
    
    type t_bfm_rep is record
        result : std_logic_vector(frame_size-1 downto 0);
        done : std_logic; --signal goes '1' after all results are obtained
    end record;

    procedure SendPacket (constant frame1 : in signed(frame_size+3 downto 0);
                          constant frame2 : in signed(frame_size+3 downto 0);
                          constant fr1_size : in integer;
                          constant fr2_size : in integer;
                          constant delay : in time;
                          signal reset : out std_logic;
                          signal to_bfm : out t_bfm_com);

    procedure GetPacket (signal from_bfm : in t_bfm_rep);

    procedure SendFrame();

    procedure SendRightPacket(); --test no. 1

    procedure SendDelayedPacket(); --test no. 2

    procedure SendWrongPacket(); --test no. 3

    procedure SendCorrectedPacket(); --test no. 4

    procedure SendOverflowPacket(); --test no. 5

    procedure SendRoundingPacket(); --test no. 6
        
        
end package;

package body Ver_pkg is

    procedure SendPacket (constant frame1 : in signed(frame_size+3 downto 0);
                          constant frame2 : in signed(frame_size+3 downto 0);
                          constant fr1_size : in integer;
                          constant fr2_size : in integer;
                          constant delay : in time;
                          signal reset : out std_logic;
                          signal to_bfm : out t_bfm_com) is
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

    end procedure;

    procedure GetPacket (signal from_bfm : in t_bfm_rep) is
    begin
        wait until rising_edge(from_bfm.done);

        report "add result: " & to_string(from_bfm.add_res) &
             ", mul result: " & to_string(from_bfm.mul_res);
    end procedure;

    procedure SendRightPacket () is
    begin
        --reset <= '1';
        wait for 10 ns;
        --reset <= '0';
        wait for 10 ns;


        wait for 200 us;


    end procedure;
        
end package body;
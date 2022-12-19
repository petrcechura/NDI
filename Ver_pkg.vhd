library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package Ver_pkg is
    constant frame_size : integer := 16;
    type t_bfm_com is record --PREDELAT tak, aby obsahoval jeden frame
        frame : signed(16-1 downto 0); --frame size is 20
        fr_size : integer;
        start : std_logic;
        reset : std_logic;
    end record;
    
    type t_bfm_rep is record
        result : std_logic_vector(16-1 downto 0);
        start : std_logic;
        done : std_logic; --signal goes '1' after all results are obtained
    end record;

    procedure SendPacket (  signal p_bfm_com : out t_bfm_com;
                            signal p_bfm_rep : in t_bfm_rep;
                            signal frame1, frame2 : in signed(16-1 downto 0);
                            signal fr1_size, fr2_size : in integer;
                            signal delay : in time);

    procedure SendFrame(    signal frame : in signed(16-1 downto 0);
                            signal fr_size : in integer;
                            signal p_bfm_com : out t_bfm_com;
                            signal p_bfm_rep : in t_bfm_rep);
        
        
end package;

package body Ver_pkg is

    procedure SendPacket (signal p_bfm_com : out t_bfm_com;
                          signal p_bfm_rep : in t_bfm_rep;
                          signal frame1, frame2 : in signed(16-1 downto 0);
                          signal fr1_size, fr2_size : in integer;
                          signal delay : in time) is

    begin

        p_bfm_com.start <= '0';

        p_bfm_com.reset <= '1';
        wait for 10 ns;
        p_bfm_com.reset <= '0';
        wait for 10 ns;
        
        report "Sending 1st frame: " & to_string(frame1);
        SendFrame(frame1, fr1_size, p_bfm_com, p_bfm_rep);  --SEND 1ST FRAME
        report "1st frame sent.";
        wait for delay;                                     --DELAY
        report "Sending 2nd frame: " & to_string(frame2);
        SendFrame(frame2, fr2_size, p_bfm_com, p_bfm_rep);  --SEND 2ND FRAME
        report "2nd frame sent.";

        wait for 100 us;

        report "Getting results...";
        SendFrame(frame1, fr1_size, p_bfm_com, p_bfm_rep);  --GET 1ST FRAME
        report "Add result: " & to_string(p_bfm_rep.result);
        wait for delay;                                     --DELAY

        SendFrame(frame2, fr2_size, p_bfm_com, p_bfm_rep);  --GET 2ND FRAME
        report "Mul result: " & to_string(p_bfm_rep.result);

        wait for 200 us;


    end procedure;

    procedure SendFrame (signal frame : in signed(16-1 downto 0);
                         signal fr_size : in integer;
                         signal p_bfm_com : out t_bfm_com;
                         signal p_bfm_rep : in t_bfm_rep) is
    begin
        p_bfm_com.frame <= frame;
        p_bfm_com.fr_size <= fr_size;
        p_bfm_com.start <= '1';
        wait until rising_edge(p_bfm_rep.done);
        p_bfm_com.start <= '0';
    end procedure;
        
end package body;
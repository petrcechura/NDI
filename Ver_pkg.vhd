library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package Ver_pkg is
    constant frame_size : integer := 16;
    type t_bfm_com is record
        frame : signed(16-1 downto 0); 
        fr_size : integer;
        start : std_logic;
        reset : std_logic;
        sclk_period : time;
    end record;
    
    type t_bfm_rep is record
        result : std_logic_vector(16-1 downto 0);
        start : std_logic;
        done : std_logic; --signal goes '1' after all results are obtained
    end record;

    procedure SendRightPacket (  signal p_bfm_com : out t_bfm_com;
                            signal p_bfm_rep : in t_bfm_rep;
                            variable frame1, frame2 : in signed(16-1 downto 0);
                            variable fr1_size, fr2_size : in integer;
                            variable delay : in time);

    procedure SendWrongPacket ( signal p_bfm_com : out t_bfm_com;
                                signal p_bfm_rep : in t_bfm_rep;
                                variable frame1, frame2, frame3 : in signed(16-1 downto 0);
                                variable fr1_size, fr2_size, fr3_size : in integer;
                                variable delay : in time);

    procedure SendFrame(    variable frame : in signed(16-1 downto 0);
                            variable fr_size : in integer;
                            signal p_bfm_com : out t_bfm_com;
                            signal p_bfm_rep : in t_bfm_rep);
        
        
end package;

package body Ver_pkg is

    procedure SendRightPacket (signal p_bfm_com : out t_bfm_com;
                          signal p_bfm_rep : in t_bfm_rep;
                          variable frame1, frame2 : in signed(16-1 downto 0);
                          variable fr1_size, fr2_size : in integer;
                          variable delay : in time) is
    
        variable emp_frame : signed(16-1 downto 0) := (others => '0') ;
        variable emp_frame_size : integer := 16;
    begin 

        p_bfm_com.start <= '0';

        p_bfm_com.reset <= '1';
        wait for 10 ns;
        p_bfm_com.reset <= '0';
        wait for 10 ns;
        
        report " Sending 1st frame: " & to_string(frame1);
        SendFrame(frame1, fr1_size, p_bfm_com, p_bfm_rep);  --SEND 1ST FRAME
        wait for delay;
        report "Delay for " & to_string(delay);                                     --DELAY
        report "Sending 2nd frame: " & to_string(frame2);
        SendFrame(frame2, fr2_size, p_bfm_com, p_bfm_rep);  --SEND 2ND FRAME

        wait for 100 us;

        report "Getting results...";
        SendFrame(emp_frame, emp_frame_size, p_bfm_com, p_bfm_rep);  --GET 1ST FRAME
        report "Add result: " & to_string(p_bfm_rep.result);
        wait for 100 us;                                     --DELAY

        SendFrame(emp_frame, emp_frame_size, p_bfm_com, p_bfm_rep);  --GET 2ND FRAME
        report "Mul result: " & to_string(p_bfm_rep.result);

        wait for 200 us;

    end procedure;

    procedure SendWrongPacket (signal p_bfm_com : out t_bfm_com;
                          signal p_bfm_rep : in t_bfm_rep;
                          variable frame1, frame2, frame3 : in signed(16-1 downto 0);
                          variable fr1_size, fr2_size, fr3_size : in integer;
                          variable delay : in time) is
    
        variable emp_frame : signed(16-1 downto 0) := (others => '0') ;
        variable emp_frame_size : integer := 16;
    begin 

        p_bfm_com.start <= '0';

        p_bfm_com.reset <= '1';
        wait for 10 ns;
        p_bfm_com.reset <= '0';
        wait for 10 ns;
        
        report " Sending 1st frame: " & to_string(frame1);
        SendFrame(frame1, fr1_size, p_bfm_com, p_bfm_rep);  --SEND 1ST FRAME
        wait for delay;
        report "Delay for " & to_string(delay);             --DELAY
        report "Sending 2nd frame: " & to_string(frame2);
        SendFrame(frame2, fr2_size, p_bfm_com, p_bfm_rep);  --SEND 2ND FRAME
        wait for 100 us;
        report "Delay for 100 us";             --DELAY
        report "Sending 3th frame: " & to_string(frame3);
        SendFrame(frame3, fr3_size, p_bfm_com, p_bfm_rep);  --SEND 3TH FRAME

        wait for 100 us;

        report "Getting results...";
        SendFrame(emp_frame, emp_frame_size, p_bfm_com, p_bfm_rep);  --GET 1ST FRAME
        report "Add result: " & to_string(p_bfm_rep.result);
        wait for 100 us;                                     --DELAY

        SendFrame(emp_frame, emp_frame_size, p_bfm_com, p_bfm_rep);  --GET 2ND FRAME
        report "Mul result: " & to_string(p_bfm_rep.result);

        wait for 200 us;

    end procedure;

    procedure SendFrame (variable frame : in signed(16-1 downto 0);
                         variable fr_size : in integer;
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
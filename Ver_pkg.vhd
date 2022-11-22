library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package Ver_pkg is
    constant frame_size : integer := 16;
    constant am_of_commands : integer := 4;
    type t_bfm_com is record
        frame1 : std_logic_vector(frame_size+3 downto 0);
        frame2 : std_logic_vector(frame_size+3 downto 0);
        fr1_size : integer;
        fr2_size : integer;
        delay : time;
    end record;
    
    type t_bfm_rep is record
        add_res : std_logic_vector(frame_size-1 downto 0);
        mul_res : std_logic_vector(frame_size-1 downto 0);
        done : std_logic; --signal goes '1' after all results are obtained
    end record;

    procedure SendPacket (signal frame1 : in std_logic_vector(frame_size+3 downto 0);
                          signal frame2 : in std_logic_vector(frame_size+3 downto 0);
                          constant fr1_size : in integer;
                          constant fr2_size : in integer;
                          constant delay : in time;
                          signal reset : in std_logic;
                          signal to_bfm : out t_bfm_com;
                          signal from_bfm : in t_bfm_rep);

    procedure GetPacket (signal add_res : out std_logic_vector(frame_size downto 0);
                         signal mul_res : out std_logic_vector(frame_size downto 0));
        
end package;

package body Ver_pkg is
    

    procedure SendPacket (signal frame1 : in std_logic_vector(frame_size+3 downto 0);
                          signal frame2 : in std_logic_vector(frame_size+3 downto 0);
                          constant fr1_size : in integer;
                          constant fr2_size : in integer;
                          constant delay : in time;
                          signal reset : out std_logic;
                          signal to_bfm : out t_bfm_com;
                          signal from_bfm : in t_bfm_rep) is
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;

        to_bfm.frame1 <= frame1;
        to_bfm.frame2 <= frame2;
        to_bfm.fr1_size <= fr1_size;
        to_bfm.fr2_size <= fr2_size;
        to_bfm.delay <= delay;

    end procedure;

    procedure GetPacket (signal add_res : out std_logic_vector(frame_size downto 0);
                         signal mul_res : out std_logic_vector(frame_size downto 0);
                         signal from_bfm : in t_bfm_rep) is
    begin
        wait until rising_edge(from_bfm.done);

        add_res <= from_bfm.add_res;
        mul_res <= from_bfm.mul_res;

        report "add result: " & to_string(add_res) & ", mul result: " & to_string(mul_res);
    end procedure;
        
end package body;
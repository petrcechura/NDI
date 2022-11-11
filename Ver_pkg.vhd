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

    procedure SendPacket (signal frame1 : std_logic_vector(19 downto 0);
                          signal frame2 : std_logic_vector(19 downto 0);
                          constant fr1_size : integer;
                          constant fr2_size : integer;
                          constant delay : time);
        
end package;
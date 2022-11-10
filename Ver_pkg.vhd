

constant frame_size : integer := 16;
constant am_of_commands : integer := 4;

type t_testcase_to_bfm is record
    command : std_logic_vector(am_of_commands-1 downto 0);
    frame1 : std_logic_vector (frame_size-1 downto 0);
    frame2 : std_logic_vector (frame_size-1 downto 0);
    delay : time;
end type;

type t_bfm_to_dut is record
    miso : std_logic;
    mosi : std_logic;
    sclk : std_logic;
    cs_b : std_logic;
end type;
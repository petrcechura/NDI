library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
    use work.Ver_pkg.all;


entity test is
    port (
        --mezi DUT a BFM
        sclk : out std_logic;
        mosi : out std_logic;
        miso : in std_logic;
        cs_b : out std_logic;
        --mezi Testbench a BFM
        bfm_com : in t_bfm_com;
        bfm_rep : out t_bfm_rep
    );
end entity;

architecture rtl of test is

    signal frame : unsigned(15 downto 0) := (others => '0') ;
    constant clk_period : time := 20 ns;
    constant SCLK_period : time := 10 us;

    procedure SendAndGetFrame (signal p_sent_frame : in std_logic_vector(frame_size+3 downto 0);
                               signal p_miso : in std_logic;
                               signal p_got_frame : out std_logic_vector(frame_size+3 downto 0);
                               signal p_mosi : out std_logic;
                               signal p_cs_b : out std_logic;
                               signal p_sclk : out std_logic) is 
    begin
        p_cs_b <= '0';
        p_sclk <= '0';
        wait for SCLK_period/2;

        for i in 0 downto frame_size-1 loop
            p_sclk <= '1';
            p_mosi <= p_sent_frame(i);
            wait for SCLK_period/2;
            p_sclk <= '0';
            p_got_frame(i) <= miso;
            wait for SCLK_period/2;
        end loop;
    end procedure;

begin

    process (bfm_com)
    begin
        SendAndGetFrame(bfm_com.frame1, miso, bfm_rep.add_res, mosi, cs_b, sclk);
        cs_b <= '1';
        wait for bfm_com.delay;
        SendAndGetFrame(bfm_com.frame2, miso, bfm_rep.mul_res, mosi, cs_b, sclk);
        cs_b <= '1';
        bfm_rep.done <= '1';
        wait;
    end process;

end architecture;
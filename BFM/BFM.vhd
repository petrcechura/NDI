library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
    use work.Ver_pkg.all;


entity BFM is
    port (
        --mezi DUT a BFM
        sclk : out std_logic;
        mosi : out std_logic;
        miso : in std_logic;
        cs_b : out std_logic;
        --mezi Testbench a BFM
        bfm_com : in t_bfm_com;
        bfm_rep : out t_bfm_rep;
        test_end : in std_logic
    );
end entity;

architecture rtl of BFM is

    signal frame : unsigned(15 downto 0) := (others => '0') ;
    constant clk_period : time := 20 ns;
    constant SCLK_period : time := 10 us;

begin

    process
    begin
        while(test_end = 0) loop
            wait until rising_edge(bfm_com.start);
            cs_b <= '0';
            sclk <= '0';
            bfm_rep.done <= '0';

            wait for SCLK_period/2;

            for i in 0 downto bfm_com.fr_size-1 loop
                sclk <= '1';
                mosi <= bfm_com.frame(i);
                wait for SCLK_period/2;
                sclk <= '0';
                bfm_rep.result(i) <= miso;
                wait for SCLK_period/2;
            end loop;
            bfm_rep.done <= '1';
        end loop;
        wait;
    end process;

end architecture;
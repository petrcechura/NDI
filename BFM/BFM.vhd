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

begin

    process
    begin
        sclk <= '0';
        mosi <= '0';
        cs_b <= '1';
        while(test_end = '0') loop
            wait until rising_edge(bfm_com.start);
            cs_b <= '0';
            sclk <= '1';
            bfm_rep.done <= '0';
            wait for bfm_com.sclk_period/2;
            for i in bfm_com.fr_size-1 downto 0 loop
                sclk <= '0';
                if i <= 15 then 
                    bfm_rep.result(i) <= miso;

                    if bfm_com.bit_order = '1' then --for test no. 6
                        report "recieved bit: " & to_string(bfm_rep.result(i));
                    end if;

                end if;
                wait for bfm_com.sclk_period/2;
                sclk <= '1';
                if i<= 15 then 
                    mosi <= bfm_com.frame(i);

                    if bfm_com.bit_order = '1' then --for test no. 6
                        report "sent bit: " & to_string(bfm_com.frame(i));
                    end if;

                else
                    mosi <= '0';
                end if;
                wait for bfm_com.sclk_period/2;
            end loop;
            sclk <= '0';
            wait for bfm_com.sclk_period/2;
            mosi <= '0';
            cs_b <= '1';
            bfm_rep.done <= '1';
        end loop;
        wait;
    end process;

end architecture;
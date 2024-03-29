library ieee;
use ieee.std_logic_1164.all;


entity PKT_Control is
    generic (
        bit_size : integer := 16
    );

    port (
        clk   : in std_logic;
        reset : in std_logic;
        frame_start, frame_stop, frame_error : in std_logic;
        data_out : in std_logic_vector(bit_size-1 downto 0);
        wr_data : out std_logic;
        data_in : out std_logic_vector(bit_size-1 downto 0);
        we_data_fr1, we_data_fr2 : out std_logic;
        data_fr : out std_logic_vector(bit_size-1 downto 0);
        add_res, mul_res : in std_logic_vector(bit_size-1 downto 0)
        --data_erase : out std_logic
    );
end entity;

architecture rtl of PKT_Control is

    component PKT_FSM is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            frame_start, frame_stop, frame_error : in std_logic;
            we_data_fr1, we_data_fr2 : out std_logic; --urceni, do ktereho framu zapisujeme
            wr_data : out std_logic; --povoleni zapisu do serialiseru
            timer_start : out std_logic; 
            timer_get : in std_logic;
            mul_res_en : out std_logic
        );
    end component;

    component Timer is
        generic (
            constant time_val : integer := 1; --in ms
            constant frequency : integer := 50 --in MHz
        );
        port (
            clk   : in std_logic;
            reset : in std_logic;
            timer_start : in std_logic;
            timer_stop : out std_logic
        );
    end component;

    signal timer_start, timer_stop : std_logic;
    signal mul_res_en : std_logic;
begin

    TIMER_I: Timer
        generic map (
            time_val => 1, --in ms
            frequency => 50 --in MHz
        )
        port map (
            clk => clk,
            reset => reset,
            timer_start => timer_start,
            timer_stop => timer_stop
            
        );

    PKT_FSM_I: PKT_FSM
        port map (
                clk   => clk,
                reset => reset,
                frame_start => frame_start,
                frame_stop => frame_stop,
                frame_error => frame_error,
                we_data_fr1 => we_data_fr1,
                we_data_fr2 => we_data_fr2, --urceni, do ktereho framu zapisujeme
                wr_data  =>  wr_data, --povoleni zapisu do serialiseru
                timer_start  => timer_start,
                timer_get => timer_stop,
                mul_res_en => mul_res_en
        );

        data_fr <= data_out; --data z deserialiseru do arith. jednotky

        data_in <= mul_res when mul_res_en='1' else add_res;



end architecture;
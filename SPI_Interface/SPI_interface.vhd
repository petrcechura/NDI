library ieee;
use ieee.std_logic_1164.all;

entity SPI_Interface is
    generic (
        bit_size : integer := 16
    );

    port (
        CS_b, SCLK, MOSI : in std_logic;
        MISO : out std_logic;
        wr_data : in std_logic;
        data_out : out std_logic_vector (bit_size-1 downto 0);
        data_in : in std_logic_vector (bit_size-1 downto 0);
        clk : in std_logic;
        rst : in std_logic;

        frame_start, frame_stop, frame_error : out std_logic
    );
end entity;

architecture rtl of SPI_Interface is
    signal CS_b_ris_edge_sig, CS_b_fall_edge_sig, SCLK_ris_edge_sig, SCLK_fall_edge_sig : std_logic := '0';
    signal serialiser_enable, deserialiser_enable : std_logic := '0';

    component Deserialiser is
        generic (
            size : integer := bit_size
        );
    
        port (
            clk   : in std_logic;
            data_in : in std_logic;
            enable : in std_logic;
            data_out : out std_logic_vector (size-1 downto 0);
            rst : in std_logic
        );
    end component;

    component Serialiser is
        generic (
            size : integer := bit_size
        );
        port (
            clk   : in std_logic;
            data_in : in std_logic_vector(size-1 downto 0);
            enable : in std_logic;
            load : in std_logic;
            data_out : out std_logic;
            rst : in std_logic
        );
    end component;

    component ShiftInOut is
        port (
            CS_b_ris, CS_b_fall, SCLK_ris, SCLK_fall : in std_logic;
            MISO_en, MOSI_en : out std_logic;
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    component Ris_fall_detector is
        port (
            clk   : in std_logic;
            data_in : in std_logic;
            ris_out, fall_out : out std_logic;
            rst : in std_logic
        );
    end component;

    component ErrorHandle is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            CS_b_ris, CS_b_fall : in std_logic;
            SCLK_ris, SCLK_fall : in std_logic;
            frame_start, frame_stop, frame_error : out std_logic
        );
    end component;

    
begin

    CS_B_EDGE_DET_I: Ris_fall_detector
        port map (
            clk => clk,
            data_in => CS_b,
            ris_out => CS_b_ris_edge_sig,
            fall_out => CS_b_fall_edge_sig,
            rst => rst
        );

    SCLK_EDGE_DET_I: Ris_fall_detector
        port map (
            clk => clk,
            data_in => SCLK,
            ris_out => SCLK_ris_edge_sig,
            fall_out => SCLK_fall_edge_sig,
            rst => rst
        );

    SHIFT_IN_OUT_I: ShiftInOut
        port map (
            CS_b_ris => CS_b_ris_edge_sig,
            CS_b_fall => CS_b_fall_edge_sig,
            SCLK_ris => SCLK_ris_edge_sig,
            SCLK_fall => SCLK_fall_edge_sig,
            MOSI_en => deserialiser_enable,
            MISO_en => serialiser_enable,
            clk => clk,
            rst => rst
        );

    DESERIALISER_I: Deserialiser
        port map (
            data_in => MOSI,
            clk => clk,
            enable => deserialiser_enable,
            data_out => data_out,
            rst => rst
        );

    SERIALISER_I: Serialiser
        port map (
            data_in => data_in,
            load => wr_data,
            enable => serialiser_enable,
            clk => clk,
            data_out => MISO,
            rst => rst
        );

    ERRORHANDLE_I: ErrorHandle
        port map (
            clk   => clk,
            reset => rst,
            CS_b_ris => CS_b_ris_edge_sig,
            CS_b_fall => CS_b_fall_edge_sig,
            SCLK_ris => SCLK_ris_edge_sig,
            SCLK_fall => SCLK_fall_edge_sig,
            frame_start => frame_start,
            frame_stop => frame_stop,
            frame_error => frame_error
        );

end architecture;
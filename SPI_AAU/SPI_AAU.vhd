library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_AAU is
    generic (
        bit_size : integer := 16
    );

    port (
        clk   : in std_logic;
        reset : in std_logic;
        SCLK, MOSI, CS_b : in std_logic;
        MISO : out std_logic
    );
end entity;

architecture rtl of SPI_AAU is

        type t_SPI_IF_out is record
            fr_start : std_logic;
            fr_end : std_logic;
            fr_error : std_logic;

            data_out : std_logic_vector (bit_size-1 downto 0);
            data_in : std_logic_vector (bit_size-1 downto 0);
            wr_data : std_logic;
        end record;

        type t_PKT_C_out is record
            we_data_fr1 : std_logic;
            we_data_fr2 : std_logic;
            data_fr : std_logic_vector(bit_size-1 downto 0);
            add_res : std_logic_vector(bit_size-1 downto 0);
            mul_res : std_logic_vector(bit_size-1 downto 0);
        end record;

        signal SPI_IF_OUT : t_SPI_IF_out;
        signal PKT_C_OUT : t_PKT_C_out; 


begin

    SPI_INTERFACE_I: entity work.SPI_Interface(rtl)
        port map (
            CS_b => CS_b,
            SCLK => SCLK,
            MOSI => MOSI,
            MISO => MISO,
            wr_data => SPI_IF_out.wr_data,
            data_out => SPI_IF_OUT.data_out,
            data_in => SPI_IF_OUT.data_in,
            clk => clk,
            rst => reset,
            frame_start => SPI_IF_OUT.fr_start,
            frame_stop => SPI_IF_OUT.fr_end,
            frame_error => SPI_IF_OUT.fr_error
        );

    PKT_CONTROL_I: entity work.PKT_Control(rtl)
        port map (
            clk => clk,
            reset => reset,
            frame_start => SPI_IF_OUT.fr_start,
            frame_stop => SPI_IF_out.fr_end,
            frame_error => SPI_IF_OUT.fr_error,
            data_out => SPI_IF_OUT.data_out,
            wr_data => SPI_IF_OUT.wr_data,
            data_in => SPI_IF_OUT.data_in,
            we_data_fr1 => PKT_C_OUT.we_data_fr1,
            we_data_fr2 => PKT_C_OUT.we_data_fr2,
            data_fr => PKT_C_OUT.data_fr,
            add_res => PKT_C_OUT.add_res,
            mul_res => PKT_C_OUT.mul_res
        );

    ARITHMETICAL_UNIT_I: entity work.Arithmetical_unit(rtl)
        port map (
            clk => clk,
            reset => reset,
            data_fr => PKT_C_OUT.data_fr,
            we_data_fr1 => PKT_C_OUT.we_data_fr1,
            we_data_fr2 => PKT_C_OUT.we_data_fr2,
            add_res => PKT_C_OUT.add_res,
            mul_res => PKT_C_OUT.mul_res
        );

end architecture;
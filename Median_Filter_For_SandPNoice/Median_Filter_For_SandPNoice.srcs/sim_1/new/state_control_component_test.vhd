

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_control_component_test is
--  Port ( );
end state_control_component_test;

architecture Behavioral of state_control_component_test is

component state_control_component is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
          
           start_operation_in : in STD_LOGIC;
           finished_operation_out : out STD_LOGIC := '0';
           
           start_padding_out : out STD_LOGIC := '0';
           start_convolution_out : out STD_LOGIC := '0';
           
           start_comm_out : out STD_LOGIC := '0';
           select_comm_op_out : out STD_LOGIC := '0';
           
           padding_completion_in : in STD_LOGIC;
           convolution_done_in : in STD_LOGIC;
           communication_done_in : in STD_LOGIC;
           
           enable_mux_padding_out : out STD_LOGIC := '0';
           enable_mux_convolution_out : out STD_LOGIC := '0';
           enable_mux_communication_out : out STD_LOGIC := '0';
           
           convolution_led_out : out STD_LOGIC := '0';
           padding_led_out : out STD_LOGIC := '0';
           
           receiving_led_out : out STD_LOGIC := '0';
           sending_led_out : out STD_LOGIC := '0');
end component;

signal clk : STD_LOGIC := '0';
signal rst_n : STD_LOGIC;
signal padding_completion_in : STD_LOGIC;
signal convolution_done_in : STD_LOGIC;
signal communication_done_in : STD_LOGIC;
signal start_operation_in : STD_LOGIC;
signal finished_operation_out : STD_LOGIC;
signal enable_mux_padding_out : STD_LOGIC;
signal enable_mux_convolution_out : STD_LOGIC;
signal enable_mux_communication_out : STD_LOGIC;
signal start_padding_out : STD_LOGIC;
signal start_convolution_out : STD_LOGIC;
signal start_comm_out : STD_LOGIC;
signal select_comm_op_out : STD_LOGIC;
signal convolution_led_out : STD_LOGIC;
signal padding_led_out : STD_LOGIC;
signal receiving_led_out : STD_LOGIC;
signal sending_led_out : STD_LOGIC;


begin

uut1 : state_control_component
    port map(clk => clk,
             rst_n => rst_n,
             padding_completion_in => padding_completion_in,
             convolution_done_in => convolution_done_in,
             communication_done_in => communication_done_in,
             start_operation_in => start_operation_in,
             finished_operation_out => finished_operation_out,
             enable_mux_padding_out => enable_mux_padding_out,
             enable_mux_convolution_out => enable_mux_convolution_out,
             enable_mux_communication_out => enable_mux_communication_out,
             start_padding_out => start_padding_out,
             start_convolution_out => start_convolution_out,
             start_comm_out => start_comm_out,
             select_comm_op_out => select_comm_op_out,
             receiving_led_out => receiving_led_out,
             convolution_led_out => convolution_led_out,
             padding_led_out => padding_led_out,
             sending_led_out => sending_led_out);


clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n <= '0';
        wait for 20ns;
        padding_completion_in <= '0';
        convolution_done_in <= '0';
        communication_done_in <= '0';
        start_operation_in <= '0';
        wait for 5ns;
        rst_n <= '1';
        
        assert (start_padding_out <= '0' and start_convolution_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolution_out <= '0' and
        enable_mux_communication_out <= '0')
            report "Control output error (Idle output)"
            severity WARNING;
        start_operation_in <= '1';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolution_out <= '0' and
        start_comm_out <= '1' and select_comm_op_out <= '1' and
        enable_mux_padding_out <= '0' and enable_mux_convolution_out <= '0' and
        enable_mux_communication_out <= '1')
            report "Control output error (Idle output with start signal)"
            severity WARNING;
        start_operation_in <= '0';
        wait for 50ns;
        communication_done_in <= '1';
        wait for 10ns;
        communication_done_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '1' and start_convolution_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '1' and enable_mux_convolution_out <= '0' and
        enable_mux_communication_out <= '0')
            report "Control output error (Data_Receive output with comm_done signal)"
            severity WARNING;
        wait for 40ns;
        padding_completion_in <= '1';
        wait for 10ns;
        padding_completion_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolution_out <= '1' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolution_out <= '1' and
        enable_mux_communication_out <= '0')
            report "Control output error (Padding output with padding done signal)"
            severity WARNING;
        wait for 40ns;
        convolution_done_in <= '1';
        wait for 20ns;
        assert (start_padding_out <= '0' and start_convolution_out <= '0' and
        start_comm_out <= '1' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolution_out <= '0' and
        enable_mux_communication_out <= '1')
            report "Control output error (Convolving output with convolve_done signal)"
            severity WARNING;
        wait for 40ns;
        communication_done_in <= '1';
        wait for 10ns;
        communication_done_in <= '0';
        wait for 10ns;
        assert (start_padding_out <= '0' and start_convolution_out <= '0' and
        start_comm_out <= '0' and select_comm_op_out <= '0' and
        enable_mux_padding_out <= '0' and enable_mux_convolution_out <= '0' and
        enable_mux_communication_out <= '0')
            report "Control output error (Data_Sending output with comm_done signal)"
            severity WARNING;
        wait;
    end process;

end Behavioral;

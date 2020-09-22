
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity state_control_component is
    Port ( clk                     : in STD_LOGIC;
           rst_n                   : in STD_LOGIC;
           
           start_operation_in             : in STD_LOGIC;
           finished_operation_out         : out STD_LOGIC := '0';
           
           start_padding_out       : out STD_LOGIC := '0';
           start_convolution_out      : out STD_LOGIC := '0';
           
           start_comm_out          : out STD_LOGIC := '0';
           select_comm_op_out      : out STD_LOGIC := '0';
           
           padding_completion_in         : in STD_LOGIC;
           convolution_done_in        : in STD_LOGIC;
           communication_done_in            : in STD_LOGIC;
                     
           enable_mux_padding_out  : out STD_LOGIC := '0';
           enable_mux_convolution_out : out STD_LOGIC := '0';
           enable_mux_communication_out     : out STD_LOGIC := '0';
                      
           convolution_led_out        : out STD_LOGIC := '0';
           padding_led_out         : out STD_LOGIC := '0';
           idel_led_out:  out STD_LOGIC := '0';
           receiving_led_out       : out STD_LOGIC := '0';
           sending_led_out         : out STD_LOGIC := '0');

end state_control_component;

architecture Behavioral of state_control_component is


type state is (Idle, Receiving_Data, Padding, Convolution, Sending_Data, Completed);
signal op_state : state;

begin
    fsm : process (clk, rst_n)
        begin
            if ( rst_n = '0' ) then
                op_state <= Idle;
                finished_operation_out <= '0';
                start_padding_out <= '0';
                start_convolution_out <= '0';
                start_comm_out <= '0';
                select_comm_op_out <= '0';
                receiving_led_out <= '0';
                convolution_led_out  <= '0';
                idel_led_out <= '0';
                padding_led_out  <= '0';
                sending_led_out <= '0';
            
            elsif ( clk'event and clk = '1' ) then
                case op_state is
                    
                    when Idle =>
                        finished_operation_out <= '0';
                        start_padding_out <= '0';
                        start_convolution_out <= '0';
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        enable_mux_padding_out <= '0';
                        enable_mux_convolution_out <= '0';
                        enable_mux_communication_out <= '0';
                        receiving_led_out <= '0';
                        convolution_led_out  <= '0';
                        idel_led_out <= '1';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';
                        if ( start_operation_in = '1' ) then
                            
                            op_state <= Receiving_Data;
                            start_comm_out <= '1';
                            select_comm_op_out <= '1';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolution_out <= '0';
                            enable_mux_communication_out <= '1';
                            receiving_led_out <= '0';
                            convolution_led_out  <= '0';
                            padding_led_out  <= '0';
                            sending_led_out <= '0';
                        end if;
                    
                    when Receiving_Data =>
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        idel_led_out <= '0';
                        receiving_led_out <= '1';
                        convolution_led_out  <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';  
                        if (communication_done_in = '1') then
                            
                            op_state <= Padding;
                            start_padding_out <= '1';
                            enable_mux_padding_out <= '1';
                            enable_mux_convolution_out <= '0';
                            enable_mux_communication_out <= '0';
                            receiving_led_out <= '1';
                            convolution_led_out  <= '0';
                            padding_led_out  <= '0';
                            sending_led_out <= '0';                                                           
                        end if;
                    
                    when Padding =>
                        start_padding_out <= '0';
                        receiving_led_out <= '0';
                        idel_led_out <= '0';
                        convolution_led_out  <= '0';
                        padding_led_out  <= '1';
                        sending_led_out <= '0';
                        if ( padding_completion_in = '1' ) then
                            
                            op_state <= Convolution;
                            start_convolution_out <= '1';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolution_out <= '1';
                            enable_mux_communication_out <= '0';
                            receiving_led_out <= '1';
                            convolution_led_out  <= '0';
                            padding_led_out  <= '1';
                            sending_led_out <= '0';  
                        end if;
                    
                    when Convolution =>
                        receiving_led_out <= '0';
                        convolution_led_out  <= '1';
                        idel_led_out <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';
                        if ( convolution_done_in = '1' ) then
                            
                            start_convolution_out <= '0';
                            op_state <= Sending_Data;
                            start_comm_out <= '1';
                            select_comm_op_out <= '0';
                            enable_mux_padding_out <= '0';
                            enable_mux_convolution_out <= '0';
                            enable_mux_communication_out <= '1';
                            receiving_led_out <= '1';
                            convolution_led_out  <= '1';
                            padding_led_out  <= '1';
                            sending_led_out <= '0';                             
                        end if;
                    
                    when Sending_Data =>
                        start_comm_out <= '0';
                        select_comm_op_out <= '0';
                        idel_led_out <= '0';
                        receiving_led_out <= '0';
                        convolution_led_out  <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '1';
                        if (communication_done_in = '1') then
                            op_state <= Completed;
                            enable_mux_padding_out <= '0';
                            enable_mux_convolution_out <= '0';
                            enable_mux_communication_out <= '0';
                            receiving_led_out <= '1';
                            convolution_led_out  <= '1';
                            padding_led_out  <= '1';
                            sending_led_out <= '1';
                        end if;
                    
                    when Completed =>
                        finished_operation_out <= '1';
                        receiving_led_out <= '0';
                        convolution_led_out  <= '0';
                        idel_led_out <= '0';
                        padding_led_out  <= '0';
                        sending_led_out <= '0';
                        op_state <= Idle;
                    
                    when others =>
                        op_state <= Idle;
                
                end case;
            end if;
        end process fsm;
end Behavioral;


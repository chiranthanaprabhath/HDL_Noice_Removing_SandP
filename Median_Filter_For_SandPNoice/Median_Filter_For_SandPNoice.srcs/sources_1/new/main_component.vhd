
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main_component is
    Port ( clk                    : in STD_LOGIC;
           main_rst_n             : in STD_LOGIC;
           start_in               : in STD_LOGIC;
           rx                     : in STD_LOGIC;
           tx                     : out STD_LOGIC;
           finished_out           : out STD_LOGIC;
           main_idel_led_out  : out STD_LOGIC;
           main_convolve_led_out  : out STD_LOGIC;
           main_padding_led_out   : out STD_LOGIC;
           main_receiving_led_out : out STD_LOGIC;
           main_sending_led_out   : out STD_LOGIC);
end main_component;

architecture Behavioral of main_component is

component padding_component is
    Generic (addr_length_g         : Integer := 14;
             data_size_g           : Integer := 8;
             input_image_length_g  : Integer := 100;
             output_image_length_g : Integer := 102);
             
    Port ( clk            : in STD_LOGIC;
           rst_n          : in STD_LOGIC;
           start_in       : in STD_LOGIC;
           finished_out   : out STD_LOGIC;
           ioi_wea_out    : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           ioi_addra_out  : out STD_LOGIC_VECTOR(addr_length_g -1 DOWNTO 0);
           ioi_douta_in   : in STD_LOGIC_VECTOR(data_size_g -1 DOWNTO 0);
           padi_wea_out   : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           padi_addra_out : out STD_LOGIC_VECTOR(addr_length_g -1 DOWNTO 0);
           padi_dina_out  : out STD_LOGIC_VECTOR(data_size_g -1 DOWNTO 0));
end component;

component convolution_component is
    Generic (addr_bit_size  : INTEGER := 14;
             data_bit_size  : INTEGER := 8);             
    
    Port ( data_a_in      : in STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0);
           data_a_out     : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0);
           clk            : in STD_LOGIC;
           read_addr_out  : out STD_LOGIC_VECTOR(addr_bit_size-1 DOWNTO 0);  
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size-1 DOWNTO 0); 
           write_en_a_out : out STD_LOGIC_VECTOR(0 DOWNTO 0); 
           write_en_p_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           paddone_in     : in STD_LOGIC;
           conv_finished   : out STD_LOGIC;
           rst_n          : in STD_LOGIC );  
end component;

component io_ram is
    Port ( clka  : IN STD_LOGIC;
           wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
           dina  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component padd_ram is
  port (clka  : IN STD_LOGIC;
        wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        dina  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;


component state_control_component is
    Port ( clk                     : in STD_LOGIC;
           rst_n                   : in STD_LOGIC;
           padding_completion_in         : in STD_LOGIC;
           convolution_done_in        : in STD_LOGIC;
           communication_done_in            : in STD_LOGIC;
           start_operation_in             : in STD_LOGIC;
           finished_operation_out         : out STD_LOGIC;
           enable_mux_padding_out  : out STD_LOGIC;
           enable_mux_convolution_out : out STD_LOGIC;
           enable_mux_communication_out     : out STD_LOGIC;
           start_padding_out       : out STD_LOGIC;
           start_convolution_out      : out STD_LOGIC;
           start_comm_out          : out STD_LOGIC;
           select_comm_op_out      : out STD_LOGIC;
           convolution_led_out        : out STD_LOGIC;
           padding_led_out         : out STD_LOGIC;
           idel_led_out : out STD_LOGIC;
           receiving_led_out       : out STD_LOGIC;
           sending_led_out       : out STD_LOGIC);
end component;

component signal_selection_component is
    Generic (addr_length_g : Integer := 14;
             data_size_g   : Integer := 8);
             
    Port ( padding_en_in       : in STD_LOGIC;
           convolution_en_in      : in STD_LOGIC;
           communication_en_in          : in STD_LOGIC;
           ioi_wea_pu_in       : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in    : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_comm_in     : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_pu_in     : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_convu_in  : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_addra_comm_in   : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_convu_in   : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           ioi_dina_comm_in    : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padding_wea_pu_in      : in STD_LOGIC_VECTOR (0 downto 0);
           padding_wea_convolution_in   : in STD_LOGIC_VECTOR (0 downto 0);
           padding_address_pu_in    : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           padding_addr_convolution_in : in STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_wea_out         : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out       : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0);
           ioi_dina_out        : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           padding_wea_out        : out STD_LOGIC_VECTOR (0 downto 0);
           padding_address_out      : out STD_LOGIC_VECTOR (addr_length_g -1 downto 0));
end component;

component uart_commi_component is
    Generic (mem_addr_size_g   : integer := 14;
             pixel_data_size_g : integer := 8;
             base_val          : integer := 0);

    Port ( clk                    : in STD_LOGIC;
           rst_n                  : in STD_LOGIC;
           start_operation_in            : in STD_LOGIC;
           finished_operation_out        : out STD_LOGIC;
           send_receive_select_in     : in STD_LOGIC;
           ioi_addra_out          : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0);
           ioi_dina_out           : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_douta_in           : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_wea_out            : out STD_LOGIC_VECTOR (0 downto 0);
           uart_interrupt_in      : in STD_LOGIC;
           uart_s_axi_awaddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_awvalid_out : out STD_LOGIC;
           uart_s_axi_awready_in  : in STD_LOGIC;
           uart_s_axi_wdata_out   : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_wstrb_out   : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_wvalid_out  : out STD_LOGIC;
           uart_s_axi_wready_in   : in STD_LOGIC;
           uart_s_axi_bresp_in    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_bvalid_in   : in STD_LOGIC;
           uart_s_axi_bready_out  : out STD_LOGIC;
           uart_s_axi_araddr_out  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_arvalid_out : out STD_LOGIC;
           uart_s_axi_arready_in  : in STD_LOGIC;
           uart_s_axi_rdata_in    : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_rresp_in    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_rvalid_in   : in STD_LOGIC;
           uart_s_axi_rready_out  : out STD_LOGIC);
end component;

component uartlite is
    Port (s_axi_aclk    : IN STD_LOGIC;
          s_axi_aresetn : IN STD_LOGIC;
          interrupt     : OUT STD_LOGIC;
          s_axi_awaddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_awvalid : IN STD_LOGIC;
          s_axi_awready : OUT STD_LOGIC;
          s_axi_wdata   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_wstrb   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_wvalid  : IN STD_LOGIC;
          s_axi_wready  : OUT STD_LOGIC;
          s_axi_bresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_bvalid  : OUT STD_LOGIC;
          s_axi_bready  : IN STD_LOGIC;
          s_axi_araddr  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          s_axi_arvalid : IN STD_LOGIC;
          s_axi_arready : OUT STD_LOGIC;
          s_axi_rdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
          s_axi_rresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          s_axi_rvalid  : OUT STD_LOGIC;
          s_axi_rready  : IN STD_LOGIC;
          rx            : IN STD_LOGIC;
          tx            : OUT STD_LOGIC);
end component;


signal start_padding_cu_to_pu : STD_LOGIC;
signal start_convolve_cu_to_convu : STD_LOGIC;
signal start_comm_cu_to_comm : STD_LOGIC;
signal select_comm_op_cu_to_comm : STD_LOGIC;
signal finished_pu_to_cu : STD_LOGIC;
signal finished_convu_to_cu : STD_LOGIC;
signal finished_comm_to_cu : STD_LOGIC;
signal enable_mux_padding_cu_to_mux : STD_LOGIC;
signal enable_mux_convolve_cu_to_mux : STD_LOGIC;
signal enable_mux_comm_cu_to_mux : STD_LOGIC;
signal wea_to_ioi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_ioi : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal dina_to_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wea_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_padi : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal dina_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal web_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addrb_to_padi : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal dinb_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal doutb_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal ioi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_pu_to_mux : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal ioi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_convu_to_mux : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal ioi_wea_comm_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_comm_to_mux : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal ioi_dina_convu_to_mux : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal ioi_dina_comm_to_mux : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal padi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_pu_to_mux : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal padi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_convu_to_mux : STD_LOGIC_VECTOR (13 DOWNTO 0);
signal interrupt_auu_to_comm : STD_LOGIC;
signal s_axi_awaddr_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_awvalid_comm_to_auu : STD_LOGIC;
signal s_axi_awready_auu_to_comm : STD_LOGIC;
signal s_axi_wdata_comm_to_auu : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_wstrb_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_wvalid_comm_to_auu : STD_LOGIC;
signal s_axi_wready_auu_to_comm : STD_LOGIC;
signal s_axi_bresp_auu_to_comm : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_bvalid_auu_to_comm : STD_LOGIC;
signal s_axi_bready_comm_to_auu : STD_LOGIC;
signal s_axi_araddr_comm_to_auu : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal s_axi_arvalid_comm_to_auu : STD_LOGIC;
signal s_axi_arready_auu_to_comm : STD_LOGIC;
signal s_axi_rdata_auu_to_comm : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axi_rresp_auu_to_comm : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal s_axi_rvalid_auu_to_comm : STD_LOGIC;
signal s_axi_rready_comm_to_auu : STD_LOGIC;

begin

padding_unit_main : padding_component
    port map (clk            => clk,
              rst_n          => main_rst_n,
              start_in       =>  start_padding_cu_to_pu,
              finished_out   => finished_pu_to_cu,
              ioi_wea_out    => ioi_wea_pu_to_mux,
              ioi_addra_out  => ioi_addra_pu_to_mux,
              ioi_douta_in   => douta_from_ioi,
              padi_wea_out   => padi_wea_pu_to_mux,
              padi_addra_out => padi_addra_pu_to_mux,
              padi_dina_out  => dina_to_padi);

convolution_component_main : convolution_component
    port map(data_a_in      => douta_from_padi,
             clk            => clk,
             rst_n          => main_rst_n,
             paddone_in     => start_convolve_cu_to_convu,
             data_a_out     => ioi_dina_convu_to_mux,
             write_en_a_out => ioi_wea_convu_to_mux,
             write_en_p_out => padi_wea_convu_to_mux,
             read_addr_out  => padi_addra_convu_to_mux,
             write_addr_out => ioi_addra_convu_to_mux,
             conv_finished   => finished_convu_to_cu);

io_ram_main : io_ram
    port map (clka  => clk,
              wea   => wea_to_ioi,
              addra => addra_to_ioi,
              dina  => dina_to_ioi,
              douta => douta_from_ioi);

padd_ram_main : padd_ram
  port map (clka  => clk,
            wea   => wea_to_padi,
            addra => addra_to_padi,
            dina  => dina_to_padi,
            douta => douta_from_padi);

state_control_component_main : state_control_component
    port map(clk                     => clk,
             rst_n                   => main_rst_n,
             padding_completion_in         => finished_pu_to_cu,
             convolution_done_in        => finished_convu_to_cu,
             communication_done_in            => finished_comm_to_cu,
             start_operation_in             => start_in,
             finished_operation_out         => finished_out,
             enable_mux_padding_out  => enable_mux_padding_cu_to_mux,
             enable_mux_convolution_out => enable_mux_convolve_cu_to_mux,
             enable_mux_communication_out     => enable_mux_comm_cu_to_mux,
             start_padding_out       => start_padding_cu_to_pu,
             start_convolution_out      => start_convolve_cu_to_convu,
             start_comm_out          => start_comm_cu_to_comm,
             select_comm_op_out      => select_comm_op_cu_to_comm,
             convolution_led_out        => main_convolve_led_out,
             padding_led_out         => main_padding_led_out,
             receiving_led_out       => main_receiving_led_out,
             idel_led_out=>main_idel_led_out,
             sending_led_out         => main_sending_led_out);

signal_selection_component_main : signal_selection_component
    port map (padding_en_in       => enable_mux_padding_cu_to_mux,
              convolution_en_in      => enable_mux_convolve_cu_to_mux,
              communication_en_in          => enable_mux_comm_cu_to_mux,
              ioi_wea_pu_in       => ioi_wea_pu_to_mux,
              ioi_wea_convu_in    => ioi_wea_convu_to_mux,
              ioi_wea_comm_in     => ioi_wea_comm_to_mux,
              ioi_addra_pu_in     => ioi_addra_pu_to_mux,
              ioi_addra_convu_in  => ioi_addra_convu_to_mux,
              ioi_addra_comm_in   => ioi_addra_comm_to_mux,
              ioi_dina_convu_in   => ioi_dina_convu_to_mux,
              ioi_dina_comm_in    => ioi_dina_comm_to_mux,
              padding_wea_pu_in      => padi_wea_pu_to_mux,
              padding_wea_convolution_in   => padi_wea_convu_to_mux,
              padding_address_pu_in    => padi_addra_pu_to_mux,
              padding_addr_convolution_in => padi_addra_convu_to_mux,
              ioi_wea_out         => wea_to_ioi,
              ioi_addra_out       => addra_to_ioi,
              ioi_dina_out        => dina_to_ioi,
              padding_wea_out        => wea_to_padi,
              padding_address_out      => addra_to_padi);

uart_commi_component_main : uart_commi_component
    port map (clk                    => clk,
              rst_n                  => main_rst_n,
              start_operation_in            => start_comm_cu_to_comm,
              finished_operation_out        => finished_comm_to_cu,
              send_receive_select_in     => select_comm_op_cu_to_comm,
              ioi_addra_out          => ioi_addra_comm_to_mux,
              ioi_douta_in           => douta_from_ioi,
              ioi_dina_out           => ioi_dina_comm_to_mux,
              ioi_wea_out            => ioi_wea_comm_to_mux,
              uart_interrupt_in      => interrupt_auu_to_comm,
              uart_s_axi_awaddr_out  => s_axi_awaddr_comm_to_auu,
              uart_s_axi_awvalid_out => s_axi_awvalid_comm_to_auu,
              uart_s_axi_awready_in  => s_axi_awready_auu_to_comm,
              uart_s_axi_wdata_out   => s_axi_wdata_comm_to_auu,
              uart_s_axi_wstrb_out   => s_axi_wstrb_comm_to_auu,
              uart_s_axi_wvalid_out  => s_axi_wvalid_comm_to_auu,
              uart_s_axi_wready_in   => s_axi_wready_auu_to_comm,
              uart_s_axi_bresp_in    => s_axi_bresp_auu_to_comm,
              uart_s_axi_bvalid_in   => s_axi_bvalid_auu_to_comm,
              uart_s_axi_bready_out  => s_axi_bready_comm_to_auu,
              uart_s_axi_araddr_out  => s_axi_araddr_comm_to_auu,
              uart_s_axi_arvalid_out => s_axi_arvalid_comm_to_auu,
              uart_s_axi_arready_in  => s_axi_arready_auu_to_comm,
              uart_s_axi_rdata_in    => s_axi_rdata_auu_to_comm,
              uart_s_axi_rresp_in    => s_axi_rresp_auu_to_comm,
              uart_s_axi_rvalid_in   => s_axi_rvalid_auu_to_comm,
              uart_s_axi_rready_out  => s_axi_rready_comm_to_auu);

uartlite_main : uartlite
    port map (s_axi_aclk    => clk,
              s_axi_aresetn => main_rst_n,
              interrupt     => interrupt_auu_to_comm,
              s_axi_awaddr  => s_axi_awaddr_comm_to_auu,
              s_axi_awvalid => s_axi_awvalid_comm_to_auu,
              s_axi_awready => s_axi_awready_auu_to_comm,
              s_axi_wdata   => s_axi_wdata_comm_to_auu,
              s_axi_wstrb   => s_axi_wstrb_comm_to_auu,
              s_axi_wvalid  => s_axi_wvalid_comm_to_auu,
              s_axi_wready  => s_axi_wready_auu_to_comm,
              s_axi_bresp   => s_axi_bresp_auu_to_comm,
              s_axi_bvalid  => s_axi_bvalid_auu_to_comm,
              s_axi_bready  => s_axi_bready_comm_to_auu,
              s_axi_araddr  => s_axi_araddr_comm_to_auu,
              s_axi_arvalid => s_axi_arvalid_comm_to_auu,
              s_axi_arready => s_axi_arready_auu_to_comm,
              s_axi_rdata   => s_axi_rdata_auu_to_comm,
              s_axi_rresp   => s_axi_rresp_auu_to_comm,
              s_axi_rvalid  => s_axi_rvalid_auu_to_comm,
              s_axi_rready  => s_axi_rready_comm_to_auu,
              rx            => rx,
              tx            => tx);

end Behavioral;

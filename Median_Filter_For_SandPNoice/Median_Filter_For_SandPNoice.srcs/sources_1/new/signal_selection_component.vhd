
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity signal_selection_component is
    Generic (address_length_g : Integer := 14; 
             data_size_g   : Integer := 8); 
             
    Port ( 
           padding_en_in       : in STD_LOGIC;       
           convolution_en_in      : in STD_LOGIC; 
           communication_en_in          : in STD_LOGIC;
           
           ioi_wea_pu_in       : in STD_LOGIC_VECTOR (0 downto 0);         
           ioi_wea_convu_in    : in STD_LOGIC_VECTOR (0 downto 0);      
           ioi_wea_comm_in     : in STD_LOGIC_VECTOR (0 downto 0);
                
           padding_wea_pu_in     : in STD_LOGIC_VECTOR (0 downto 0);
           padding_wea_convolution_in   : in STD_LOGIC_VECTOR (0 downto 0);
           padding_address_pu_in    : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           padding_addr_convolution_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
 
           ioi_addra_pu_in     : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_addra_convu_in  : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_addra_comm_in   : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_dina_convu_in   : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           ioi_dina_comm_in    : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           
           ioi_wea_out         : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out       : out STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_dina_out        : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           
           padding_wea_out        : out STD_LOGIC_VECTOR (0 downto 0);
           padding_address_out      : out STD_LOGIC_VECTOR (address_length_g -1 downto 0));

end signal_selection_component;

architecture Behavioral of signal_selection_component is

begin
    multiplex : process (padding_en_in, convolution_en_in, communication_en_in, ioi_wea_pu_in,
    ioi_addra_comm_in, ioi_dina_convu_in, ioi_dina_comm_in, padding_wea_pu_in,
    ioi_wea_convu_in, ioi_wea_comm_in, ioi_addra_pu_in, ioi_addra_convu_in,
    padding_wea_convolution_in, padding_address_pu_in, padding_addr_convolution_in)
        
        begin
            if (padding_en_in = '1' and convolution_en_in = '0' and communication_en_in = '0') then
                -- if enable data from padding unit
                ioi_wea_out    <= ioi_wea_pu_in;
                ioi_addra_out  <= ioi_addra_pu_in;
                ioi_dina_out   <= std_logic_vector(to_unsigned(0, data_size_g));
                padding_wea_out   <= padding_wea_pu_in;
                padding_address_out <= padding_address_pu_in;
            elsif (padding_en_in = '0' and convolution_en_in = '1' and communication_en_in = '0') then
                -- if enable data from convolution unit
                ioi_wea_out    <= ioi_wea_convu_in;
                ioi_addra_out  <= ioi_addra_convu_in;
                ioi_dina_out   <= ioi_dina_convu_in;
                padding_wea_out   <= padding_wea_convolution_in;
                padding_address_out <= padding_addr_convolution_in;
            elsif (padding_en_in = '0' and convolution_en_in = '0' and communication_en_in = '1') then
                -- if enable data from uart communication unit
                ioi_wea_out    <= ioi_wea_comm_in;
                ioi_addra_out  <= ioi_addra_comm_in;
                ioi_dina_out   <= ioi_dina_comm_in;
                padding_wea_out   <= "0";
                padding_address_out <= std_logic_vector(to_unsigned(0, address_length_g));
            else
                --when unintentional inputs
                ioi_wea_out    <= "0";
                ioi_addra_out  <= std_logic_vector(to_unsigned(0, address_length_g));
                ioi_dina_out   <= std_logic_vector(to_unsigned(0, data_size_g));
                padding_wea_out   <= "0";
                padding_address_out <= std_logic_vector(to_unsigned(0, address_length_g));
            end if;
        end process multiplex;
end Behavioral;

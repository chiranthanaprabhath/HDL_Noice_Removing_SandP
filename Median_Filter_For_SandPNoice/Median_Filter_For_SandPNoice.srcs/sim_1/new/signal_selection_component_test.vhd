

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signal_selection_component_test is
--  Port ( );
end signal_selection_component_test;

architecture Behavioral of signal_selection_component_test is

component signal_selection_component is
Generic (   address_length_g : Integer := 14;
             data_size_g : Integer := 8);
             
    Port ( padding_en_in : in STD_LOGIC;
           convolution_en_in : in STD_LOGIC;
           communication_en_in : in STD_LOGIC;
           
           ioi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_comm_in : in STD_LOGIC_VECTOR (0 downto 0);
           
           padding_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padding_wea_convolution_in : in STD_LOGIC_VECTOR (0 downto 0);
           padding_address_pu_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           padding_addr_convolution_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           
           ioi_addra_pu_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_addra_convu_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_addra_comm_in : in STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_dina_convu_in : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           ioi_dina_comm_in : in STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out : out STD_LOGIC_VECTOR (address_length_g -1 downto 0);
           ioi_dina_out : out STD_LOGIC_VECTOR (data_size_g -1 downto 0);
           
           padding_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           padding_address_out : out STD_LOGIC_VECTOR (address_length_g -1 downto 0));
end component;

signal padding_en_in : STD_LOGIC;
signal convolution_en_in : STD_LOGIC;
signal communication_en_in : STD_LOGIC;
signal ioi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_comm_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_pu_in : STD_LOGIC_VECTOR (13 downto 0);
signal ioi_addra_convu_in : STD_LOGIC_VECTOR (13 downto 0);
signal ioi_addra_comm_in : STD_LOGIC_VECTOR (13 downto 0);
signal ioi_dina_convu_in : STD_LOGIC_VECTOR (7 downto 0);
signal ioi_dina_comm_in : STD_LOGIC_VECTOR (7 downto 0);
signal padding_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padding_wea_convolution_in : STD_LOGIC_VECTOR (0 downto 0);
signal padding_address_pu_in : STD_LOGIC_VECTOR (13 downto 0);
signal padding_addr_convolution_in : STD_LOGIC_VECTOR (13 downto 0);
signal ioi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_out : STD_LOGIC_VECTOR (13 downto 0);
signal ioi_dina_out : STD_LOGIC_VECTOR (7 downto 0);
signal padding_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal padding_address_out : STD_LOGIC_VECTOR (13 downto 0);

begin

uut1 : signal_selection_component
    port map (padding_en_in => padding_en_in,
              convolution_en_in => convolution_en_in,
              communication_en_in => communication_en_in,
              
              ioi_wea_pu_in => ioi_wea_pu_in,
              ioi_wea_convu_in => ioi_wea_convu_in,
              ioi_wea_comm_in => ioi_wea_comm_in,
              ioi_addra_pu_in => ioi_addra_pu_in,
              ioi_addra_convu_in => ioi_addra_convu_in,
              ioi_addra_comm_in => ioi_addra_comm_in,
              ioi_dina_convu_in => ioi_dina_convu_in,
              ioi_dina_comm_in => ioi_dina_comm_in,
              padding_wea_pu_in => padding_wea_pu_in,
              padding_wea_convolution_in => padding_wea_convolution_in,
              padding_address_pu_in => padding_address_pu_in,
              padding_addr_convolution_in => padding_addr_convolution_in,
              ioi_wea_out => ioi_wea_out,
              ioi_addra_out => ioi_addra_out,
              ioi_dina_out => ioi_dina_out,
              padding_wea_out => padding_wea_out,
              padding_address_out => padding_address_out);

stimuli : process
    begin
        padding_en_in <= '0';
        convolution_en_in <= '0';
        communication_en_in <= '0';
        ioi_wea_pu_in <= "1";
        ioi_wea_convu_in <= "0";
        ioi_wea_comm_in <= "1";
        ioi_addra_pu_in <= "00110001000100";
        ioi_addra_convu_in <= "01110000010010";
        ioi_addra_comm_in <= "00000000000011";
        ioi_dina_convu_in <= "10101010";
        ioi_dina_comm_in <= "10111011";
        padding_wea_pu_in <= "0";
        padding_wea_convolution_in <= "1";
        padding_address_pu_in <= "00000011001001";
        padding_addr_convolution_in <= "00010000110010";
        wait for 10ns;


        padding_en_in <= '0';
        convolution_en_in <= '1';
        communication_en_in <= '0';
        wait for 10ns;

        padding_en_in <= '0';
        convolution_en_in <= '0';
        communication_en_in <= '1';
        
        wait for 10ns;
        padding_en_in <= '1';
        convolution_en_in <= '0';
        communication_en_in <= '0';
        wait for 10ns;

        padding_en_in <= '1';
        convolution_en_in <= '1';
        communication_en_in <= '0';
        wait for 10ns;

        padding_en_in <= '1';
        convolution_en_in <= '1';
        communication_en_in <= '1';
        wait for 10ns;
        
        padding_en_in <= '0';
        convolution_en_in <= '0';
        communication_en_in <= '0';
        wait for 10ns;

    end process;

end Behavioral;

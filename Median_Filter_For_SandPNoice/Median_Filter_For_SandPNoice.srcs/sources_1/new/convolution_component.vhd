
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity convolution_component is
Generic (addr_bit_size : INTEGER := 14; 
             data_bit_size : INTEGER := 8);
             
    Port ( clk  : in STD_LOGIC;
           rst_n :in STD_LOGIC; 
           data_a_in : in STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0);
           data_a_out : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           read_addr_out : out STD_LOGIC_VECTOR(addr_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, addr_bit_size)); 
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, addr_bit_size));
           write_en_a_out : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
           write_en_p_out : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
           paddone_in : in STD_LOGIC;
           conv_finished : out STD_LOGIC := '0');  
end convolution_component;

architecture Behavioral of convolution_component is


component kernel_component is
Generic (addr_bit_size : INTEGER := 14;  
             data_bit_size : INTEGER := 8;
             input_image_length_g : Integer := 100; 
             output_image_length_g : Integer := 102); 
             
    Port ( clk  : in STD_LOGIC; -- clock
           rst_n :in STD_LOGIC; 
           data_a_in : in STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0);
           
           dataout0 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout1 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout2 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout3 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout4 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout5 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout6 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout7 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));
           dataout8 : out STD_LOGIC_VECTOR(data_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, data_bit_size));

           read_addr_out : out STD_LOGIC_VECTOR(addr_bit_size-1 DOWNTO 0) := std_logic_vector(to_unsigned(0, addr_bit_size));
           padde_ena : out STD_LOGIC_VECTOR(0 DOWNTO 0):="0";
           paddone_in : in STD_LOGIC;
           kerneldone_out : out STD_LOGIC := '0'); 
end component;

component sort_component is
Generic (addr_length_g : Integer := 14;
             data_size_g : Integer := 8; 
             base_val_g : Integer := 0; 
             input_image_length_g : Integer := 100; 
             output_image_length_g : Integer := 102);
             
port(      
              clk      : in STD_LOGIC;
              rst_n     : in std_logic:='0';
              sort_ena     : in std_logic;
			  Mat0      : in std_logic_vector(7 downto 0);
			  Mat1      : in std_logic_vector(7 downto 0);
			  Mat2      : in std_logic_vector(7 downto 0);
			  Mat3      : in std_logic_vector(7 downto 0);
			  Mat4      : in std_logic_vector(7 downto 0);
			  Mat5      : in std_logic_vector(7 downto 0);
			  Mat6      : in std_logic_vector(7 downto 0);
			  Mat7      : in std_logic_vector(7 downto 0);
			  Mat8      : in std_logic_vector(7 downto 0);
			  sortdone_ena : out STD_LOGIC_VECTOR(0 DOWNTO 0):="0";
			  sortAlldone : out std_logic:='0';
			  addres : out STD_LOGIC_VECTOR(addr_length_g -1 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, addr_length_g));
			  out_pixel : out std_logic_vector(7 downto 0):=(others=>'0'));
end component;


signal dataout0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout6 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal dataout8 : STD_LOGIC_VECTOR(7 DOWNTO 0);


signal kernel_in :STD_LOGIC;
signal kerneldone_out: STD_LOGIC;
signal alldone_out  : STD_LOGIC;

begin

kernal_component_1 : kernel_component
    port map (clk => clk,
              rst_n => rst_n,
              data_a_in =>  data_a_in,
              dataout0=>dataout0,
              dataout1=>dataout1,
              dataout2=>dataout2,
              dataout3=>dataout3,
              dataout4=>dataout4,
              dataout5=>dataout5,
              dataout6=>dataout6,
              dataout7=>dataout7,
              dataout8=>dataout8,
              read_addr_out => read_addr_out,
              padde_ena=>write_en_p_out,
              paddone_in => paddone_in,
              kerneldone_out => kerneldone_out);

sort_component_1 : sort_component
   port map (
                clk => clk,
              rst_n => rst_n,
              sort_ena =>kerneldone_out,
              Mat0 =>  dataout0 ,
              Mat1 =>dataout1 ,
              Mat2 => dataout2 ,
              Mat3 => dataout3,
              Mat4 => dataout4,
              Mat5 => dataout5,
              Mat6 => dataout6 ,
              Mat7 => dataout7,
              Mat8 => dataout8 ,
              sortdone_ena=>write_en_a_out,
              sortAlldone=>conv_finished,
              addres=>write_addr_out,
              out_pixel=>data_a_out
              );
end Behavioral;
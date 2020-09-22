
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity sort_component is
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
			  
			  
end sort_component;

architecture Behavioral of sort_component is
type matrix is array (0 to 8)    of  std_logic_vector (7 downto 0);
signal mat_temp    : matrix := (others    => "00000000");

begin

          mat_temp(0) <= Mat0;
		  mat_temp(1) <= Mat1;
		  mat_temp(2) <= Mat2;
		  mat_temp(3) <= Mat3;
		  mat_temp(4) <= Mat4;
		  mat_temp(5) <= Mat5;
		  mat_temp(6) <= Mat6;
		  mat_temp(7) <= Mat7;
		  mat_temp(8) <= Mat8;
process(sort_ena, mat_temp,rst_n,clk)
		 variable temp_mat    : matrix := (others    => "00000000");
		 variable temp      : std_logic_vector(7 downto 0):=(others =>'0');
		 variable count : integer := 0;
		 variable waitkey : integer := 1;
		 variable ioi_base : unsigned (addr_length_g -1 downto 0):= "00000000000000";
		begin
        if(rst_n='0')then
        	temp_mat  := (others =>"00000000");
			temp      := (others =>'0');
			sortdone_ena<="0";
			sortAlldone<='0';
			count:=0;
			waitkey:=1;
			addres<="00000000000000";
			out_pixel <= "00000000";
			out_pixel <= (others =>'1');
		elsif (clk 'event and clk = '1') then
              if(sort_ena='1')then
                    if(waitkey=1)then
                        sortdone_ena<="0";
                        temp_mat :=  mat_temp;
                        loop1:for i in 0 to 8 loop
                        loop2:   for j in 0 to 7 loop
                                      if(temp_mat(j+1) > temp_mat(j)) then             
                                         temp        := temp_mat(j);
                                         temp_mat(j) := temp_mat(j+1);
                                         temp_mat(j+1) := temp;               
                                      else
                                        NULL;
                                    end if;	
                                    end loop loop2;
                                end loop loop1;
                                
                        out_pixel <=  temp_mat(4);
                        sortdone_ena<="1";
                        count:=count+1;
                        waitkey:=0;
                        addres<=STD_LOGIC_VECTOR(ioi_base+count);
                    else
                        waitkey:=0;
                        sortdone_ena<="0"; 
                    end if;
              elsif(sort_ena='0')then
                  waitkey:=1;
                  sortdone_ena<="0";
              else
                  waitkey:=0;
                  sortdone_ena<="0";
              end if;
            if(count=input_image_length_g*input_image_length_g) then
              sortAlldone<='1';
            end if; 
        end if;
	end process;
end Behavioral;


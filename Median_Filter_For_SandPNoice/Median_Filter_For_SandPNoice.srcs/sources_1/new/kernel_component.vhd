
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity kernel_component is
Generic (addr_bit_size : INTEGER := 14;  
             data_bit_size : INTEGER := 8;
             input_image_length_g : Integer := 100; 
             output_image_length_g : Integer := 102);   
    Port ( clk  : in STD_LOGIC; 
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
end kernel_component;

architecture Behavioral of kernel_component is
begin
process ( clk, rst_n )

        constant read_wait : integer := 6;
        variable count : integer := 0;
        variable alldone : integer := 0;
        variable newcount : integer := 0;
        variable countinput : integer := 0;
        variable index : integer := 0;
        variable modval : integer := 0;
        variable wait_to_read : integer := read_wait;
        variable padding_value : unsigned (addr_bit_size -1 downto 0):= "00000000000000";
        begin

            if ( rst_n = '0' ) then
                modval := 0;
                alldone:=0;
                count:=0;
                index:=0;
                countinput:=0;
                padde_ena<="0";
                wait_to_read := read_wait;
            elsif (clk 'event and clk = '1') then
                if (paddone_in = '1') then
                    if(alldone<input_image_length_g*input_image_length_g) then
                        if(countinput<9)then
                            kerneldone_out <= '0';
                            case countinput IS
                                when 0 =>
                                    index:=index+newcount;
                                when 1 =>
                                    index:=index+newcount+1;
                                when 2 =>
                                    index:=index+newcount+2;
                                when 3 =>
                                    index:=index+newcount+output_image_length_g;
                                when 4 =>
                                    index:=index+newcount+output_image_length_g+1;
                                when 5 =>
                                    index:=index+newcount+output_image_length_g+2;
                                when 6 =>
                                    index:=index+newcount+output_image_length_g*2;
                                when 7 =>
                                    index:=index+newcount+output_image_length_g*2+1;
                                when 8 =>
                                    index:=index+newcount+output_image_length_g*2+2;
                                when others =>
                             end case;
                                if (wait_to_read = read_wait) then
                                    padde_ena<="0";
                                    read_addr_out <= STD_LOGIC_VECTOR(padding_value +index);
                                    wait_to_read := wait_to_read - 1;
                                elsif (wait_to_read = 0) then
                                    case countinput IS
                                        when 0 =>
                                             dataout0<=data_a_in;
                                        when 1 =>
                                             dataout1<=data_a_in;
                                        when 2 =>
                                             dataout2<=data_a_in;
                                        when 3 =>
                                             dataout3<=data_a_in;
                                        when 4 =>
                                             dataout4<=data_a_in;
                                        when 5 =>
                                             dataout5<=data_a_in;
                                        when 6 =>
                                             dataout6<=data_a_in;
                                        when 7 =>
                                             dataout7<=data_a_in;
                                        when 8 =>
                                             dataout8<=data_a_in;
                                        when others =>
                                 end case;
                                    countinput:=countinput+1;
                                    wait_to_read := read_wait;
                                else
                                    --keep reducing wait to read counter.
                                    wait_to_read := wait_to_read - 1;
                                end if;
                                index:=0;                 
                        elsif countinput=9 then
                            newcount:=newcount+1;
                            count:=count+1;
                            alldone:=alldone+1;
                            kerneldone_out <= '1';
                            countinput:=0; 
                            if(count=input_image_length_g)then
                                newcount:=newcount+2;
                                count:=0;
                            end if;
                        else
                            kerneldone_out <= '0';
                        end if;
                      end if;
                    else
                       kerneldone_out <= '0';
                    end if;
                end if;
    end process;
end Behavioral;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;

entity padding_component is
    Generic (addr_length_g         : Integer := 14; 
             data_size_g           : Integer := 8; 
             base_val_g            : Integer := 0; 
             input_image_length_g  : Integer := 100; 
             output_image_length_g : Integer := 102); 
             
    Port ( clk            : in STD_LOGIC;
           rst_n          : in STD_LOGIC;
           start_in       : in STD_LOGIC;
           finished_out   : out STD_LOGIC := '0';
           
           ioi_wea_out    : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
           ioi_addra_out  : out STD_LOGIC_VECTOR(addr_length_g -1 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, addr_length_g));
           ioi_douta_in   : in STD_LOGIC_VECTOR(data_size_g -1 DOWNTO 0);
           
           padi_wea_out   : out STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
           padi_addra_out : out STD_LOGIC_VECTOR(addr_length_g -1 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, addr_length_g));
           padi_dina_out  : out STD_LOGIC_VECTOR(data_size_g -1 DOWNTO 0) := std_logic_vector(to_unsigned(base_val_g, data_size_g)));

end padding_component;

architecture Behavioral of padding_component is


begin
process ( clk,rst_n )
        constant read_wait : integer := 6;
        constant write_wait : integer := 3;
        variable count : integer := 0;
        variable countinput : integer := 0;
        variable countplusone : integer := 1;
        variable wait_to_read : integer := read_wait;
        variable wait_after_write : integer := write_wait;
        variable started : STD_LOGIC := '0';
        variable ioi_base : unsigned (addr_length_g -1 downto 0):= "00000000000000";
        variable input_value : STD_LOGIC_VECTOR (data_size_g -1 downto 0) := "00000000";
        variable padding_value : unsigned (addr_length_g -1 downto 0):= "00000000000000";
        variable padding_val : STD_LOGIC_VECTOR (data_size_g -1 downto 0) := "00000000";
        begin
            if ( rst_n = '0' ) then
                count:=0;
                countplusone:=1;
                countinput:=0;
                wait_to_read := read_wait;
                wait_after_write := write_wait;
                started := '0';
                ioi_base := "00000000000000";
                padding_value:="00000000000000";
                input_value := "00000000";
                padding_val := "00000000";
                ioi_wea_out  <= "0";
                finished_out <= '0';
            elsif (clk 'event and clk = '1') then
                if (start_in = '1' and started = '0') then
                    started := '1';
                    ioi_wea_out  <= "0";
                    finished_out <= '0';
                elsif (started = '1') then              
                    if(count<output_image_length_g or count mod output_image_length_g=0 or countplusone mod output_image_length_g=0 or count>=output_image_length_g*output_image_length_g-output_image_length_g ) then
                        padi_addra_out <=STD_LOGIC_VECTOR(padding_value+count);
                        padi_dina_out <=padding_val;
                        if (wait_after_write = write_wait) then
                                    padi_wea_out<="1";
                                    wait_after_write := wait_after_write - 1;
                                elsif (wait_after_write = 0) then
                                    count:=count+1;
                                    countplusone:=countplusone+1;
                                    if(count=output_image_length_g*output_image_length_g)then
                                        finished_out<='1';
                                    end if;
                                    wait_after_write := write_wait;
                                else
                                    wait_after_write := wait_after_write - 1;
                                    if (wait_after_write = 0) then
                                        padi_wea_out <= "0";
                                    end if;
                                end if;
                    else
                        if (wait_to_read = read_wait) then
                                    ioi_addra_out <= STD_LOGIC_VECTOR(ioi_base +countinput);
                                    wait_to_read := wait_to_read - 1;
                                elsif (wait_to_read = 0) then
                                    padi_addra_out<=STD_LOGIC_VECTOR(padding_value+count);
                                    input_value:=ioi_douta_in;
                                    padi_dina_out<=input_value;
                                    if (wait_after_write = write_wait) then
                                        padi_wea_out<="1";
                                        wait_after_write := wait_after_write - 1;
                                    elsif (wait_after_write = 0) then
                                        countinput:=countinput+1;
                                        count:=count+1;
                                        countplusone:=countplusone+1;
                                        wait_after_write := write_wait;
                                        wait_to_read := read_wait;
                                    else
                                        wait_after_write := wait_after_write - 1;
                                        if (wait_after_write = 0) then
                                            padi_wea_out <= "0";
                                        end if;
                                    end if;
                                else
                                    wait_to_read := wait_to_read - 1;
                                end if;
                      
                    end if;
                end if;
            end if;
    end process;


end Behavioral;

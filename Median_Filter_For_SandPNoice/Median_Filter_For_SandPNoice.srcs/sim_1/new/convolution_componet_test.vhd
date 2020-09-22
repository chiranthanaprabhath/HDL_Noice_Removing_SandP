----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 01:16:17 PM
-- Design Name: 
-- Module Name: convolution_componet_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity convolution_componet_test is
--  Port ( );
end convolution_componet_test;

architecture Behavioral of convolution_componet_test is
component convolution_component is
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
end component;

component padd_ram is
    Port ( clka : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

signal data_a_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clk: STD_LOGIC :='0';
signal paddone: STD_LOGIC;
signal data_a_out: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal write_en_a_out: STD_LOGIC_VECTOR ( 0 downto 0) := "0";
signal wea_to_padded: STD_LOGIC_VECTOR ( 0 downto 0);
signal read_addr_out : STD_LOGIC_VECTOR(13 DOWNTO 0);
signal write_addr_out : STD_LOGIC_VECTOR(13 DOWNTO 0);
signal conv_finished : STD_LOGIC;
signal rst_n : STD_LOGIC;

begin

uut1 : convolution_component
    port map(
             clk=>clk,
             rst_n=>rst_n,
             data_a_in=>data_a_in,
             
             read_addr_out=>read_addr_out,
             data_a_out=>data_a_out,
             write_en_a_out=>write_en_a_out,
             
             write_addr_out =>write_addr_out,
             write_en_p_out => wea_to_padded,
             paddone_in=>paddone,
             conv_finished=>conv_finished);

uut_3 : padd_ram
  port map (clka => clk,
            wea => wea_to_padded,
            addra => read_addr_out,
            dina => "00000000",
            douta => data_a_in);

clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n <= '0';
        rst_n <= '1';
        paddone <= '0';
        wea_to_padded <= "0";
        wait for 15ns;
        paddone <= '1';
        wait for 15ns;  -- time taken to finish the convolution
        
        wait;
    end process;

dump_to_text : process (clk)
    variable out_value : line;
    file convolved_ram : text is out "convolved_ram.txt";
    begin
        if ( clk 'event and clk = '1' ) then
            if ( write_en_a_out = "1" ) then
                write(out_value, to_integer(unsigned(write_addr_out)), left, 3);
                write(out_value, string'(","));
                write(out_value, to_integer(unsigned(data_a_out)), left, 3);
                writeline(convolved_ram, out_value);
            end if;
            if ( conv_finished = '1' ) then
                file_close(convolved_ram);
            end if;
        end if;
    end process;
end Behavioral;
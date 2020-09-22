----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 12:00:56 PM
-- Design Name: 
-- Module Name: padding_component_test - Behavioral
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

entity padding_component_test is
--  Port ( );
end padding_component_test;

architecture Behavioral of padding_component_test is

component padding_component is
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
end component;

component io_ram is
    Port ( clka : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component padd_ram is
  port (clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

signal clk : STD_LOGIC := '0';
signal rst_n  : STD_LOGIC;
signal start_in : STD_LOGIC;
signal finished_out : STD_LOGIC;
signal ioi_wea_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal ioi_addra_out : STD_LOGIC_VECTOR(13 DOWNTO 0);
signal dont_care : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ioi_douta_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_wea_out : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal padi_addra_out : STD_LOGIC_VECTOR(13 DOWNTO 0);
signal padi_dina_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal padi_douta : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

uut_1 : padding_component
    port map (clk => clk,
              rst_n  => rst_n ,
              start_in =>  start_in,
              finished_out => finished_out,
              ioi_wea_out => ioi_wea_out,
              ioi_addra_out => ioi_addra_out,
              ioi_douta_in => ioi_douta_in,
              padi_wea_out => padi_wea_out,
              padi_addra_out => padi_addra_out,
              padi_dina_out => padi_dina_out
              );

uut_2 : io_ram
    port map (clka => clk,
              wea => ioi_wea_out,
              addra => ioi_addra_out,
              dina => dont_care,
              douta => ioi_douta_in);

uut_3 : padd_ram
  port map (clka => clk,
            wea => padi_wea_out,
            addra => padi_addra_out,
            dina => padi_dina_out,
            douta => padi_douta);

clk <= not clk after 5ns;

stimuli : process
    begin
        rst_n  <= '0';
        start_in <= '0';
        wait for 5ns;
        rst_n  <= '1';
        wait for 10ns;
        start_in <= '1';
        wait for 10ns;
        start_in <= '0';
        wait;
    end process;

dump_to_text : process (clk)
    variable out_value : line;
    file padded_ram : text is out "padded_ram.txt";
    begin
        if ( clk 'event and clk = '1' ) then
            if ( padi_wea_out = "1" ) then
                write(out_value, to_integer(unsigned(padi_addra_out)), left, 3);
                write(out_value, string'(","));
                write(out_value, to_integer(unsigned(padi_dina_out)), left, 3);
                writeline(padded_ram, out_value);
            end if;
            if ( finished_out = '1' ) then
                file_close(padded_ram);
            end if;
        end if;
    end process;

end Behavioral;

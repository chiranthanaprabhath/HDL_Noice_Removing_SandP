----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2020 12:50:22 AM
-- Design Name: 
-- Module Name: sort_componet_test - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sort_componet_test is
--Port ( );
end sort_componet_test;

architecture Behavioral of sort_componet_test is

component sort_component is
Generic (addr_length_g : Integer := 12;
             data_size_g : Integer := 8; 
             base_val_g : Integer := 0; 
             input_image_length_g : Integer := 60; 
             output_image_length_g : Integer := 62);
             
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

signal clk : STD_LOGIC := '0';
signal rst_n : STD_LOGIC;
signal sortAlldone : STD_LOGIC;
signal sortdone_ena: STD_LOGIC_VECTOR(0 DOWNTO 0):="0";
signal Mat0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat6 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Mat8 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal out_pixel : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal addres : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal sort_ena:STD_LOGIC := '1';

begin
uut_1 : sort_component
    port map (
              clk=> clk,
              rst_n => rst_n,
              sort_ena=>sort_ena,
              Mat0 =>  Mat0,
              Mat1 =>Mat1,
              Mat2 => Mat2,
              Mat3 => Mat3,
              Mat4 => Mat4,
              Mat5 => Mat5,
              Mat6 => Mat6,
              Mat7 => Mat7,
              Mat8 => Mat8,
              sortdone_ena=>sortdone_ena,
              addres=>addres,
              sortAlldone=>sortAlldone,
                out_pixel => out_pixel
              );
clk <= not clk after 5ns;
stimuli : process
    begin
        rst_n <= '1';
        sort_ena<='1';
        Mat0 <= "11000001";
        Mat1 <= "00010010";
        Mat2 <= "00000100";
        Mat3 <= "00001000";
        Mat4 <= "00000111";
        Mat5 <= "00000011";
        Mat6 <= "01000001";
        Mat7 <= "00010001";
        Mat8 <= "10000001";
        wait for 5ns;
        rst_n <= '0';
        wait for 10ns;
        rst_n <= '1';
         
        Mat0 <= "11000001";
        Mat1 <= "00010010";
        Mat2 <= "00000100";
        Mat3 <= "00001000";
        Mat4 <= "00000111";
        Mat5 <= "00000011";
        Mat6 <= "01000001";
        Mat7 <= "11010001";
        Mat8 <= "10000001";
        wait;
    end process;


end Behavioral;

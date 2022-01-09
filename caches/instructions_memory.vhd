library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity instructionMemory is generic (n : integer := 16 ; m : integer := 20);
	port(
		clk           : in std_logic;
		address       : in  std_logic_vector(2*n-1 downto 0);       -- pc is 32 bit , we care about first 20 bits, then all bits excepts the first 20 bits must be zero else OUT_OF_RANGE INDEXING will happen.
		dataout       : out std_logic_vector(2*n-1 downto 0);
		PCStationary  : out std_logic_vector(2*n-1 downto 0);
		PCEX1,PCEX2   : out std_logic_vector(2*n-1 downto 0)
		);
end entity instructionMemory;

architecture instructionMemoryArch of instructionMemory is

	type memory_type is array(0 to ((2 ** m)-1)) of std_logic_vector(n-1 downto 0);
	signal memory : memory_type ;
	
	begin
		-- process(clk) is
		-- 	begin
		-- 		if rising_edge(clk) then  
		-- 			if write_enable = '1' then
		-- 				memory(to_integer(unsigned(address))) <= datain(2*n-1 downto n);
		-- 				memory(to_integer(unsigned(address+1))) <= datain(n-1 downto 0);
		-- 			end if;
		-- 		end if;
		-- end process;
		dataout(2*n-1 downto n) <= memory(to_integer(unsigned(address)));
		dataout(n-1 downto 0) <= memory(to_integer(unsigned(address+1)));
		PCStationary <= memory(0) & memory(1);
		PCEX1 <= memory(2) & memory(3);
		PCEX2 <= memory(4) & memory(5);
end instructionMemoryArch;


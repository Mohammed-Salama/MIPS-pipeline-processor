library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataMemory is generic (n : integer := 16 ; m : integer := 20);
	port(
		-- clk             : in std_logic;
		write_enable    : in std_logic;
		is32            : in std_logic;
		address         : in  std_logic_vector(m-1 downto 0);
		datain1         : in  std_logic_vector(n-1 downto 0);
		datain2         : in  std_logic_vector(n-1 downto 0);
		dataout1        : out std_logic_vector(n-1 downto 0);
		dataout2        : out std_logic_vector(n-1 downto 0));
end entity dataMemory;

architecture dataMemoryArch of dataMemory is

	type memory_type is array(0 to ((2 ** m)-1)) of std_logic_vector(n-1 downto 0);
	signal memory : memory_type ;
	
	begin
		process(datain1, datain2,write_enable, is32 ) is
			begin
				if write_enable = '1' then
					memory(to_integer(unsigned(address))) <= datain1;
					if is32 ='1' then
						memory(to_integer(unsigned(address))-1) <= datain2;
					end if;
				end if;
		end process;
		dataout1 <= memory(to_integer(unsigned(address)));
		--dataout2 <= memory(to_integer(unsigned(address))-1);
end dataMemoryArch;

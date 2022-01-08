Library ieee;
use ieee.std_logic_1164.all;

ENTITY StackReg IS
GENERIC(n: integer := 32);
PORT(
clk, rst,enable: IN std_logic;
d: IN std_logic_vector(n-1 downto 0);
q: OUT std_logic_vector(n-1 downto 0)
);
END StackReg;

ARCHITECTURE StackRegArch OF StackReg IS
BEGIN
PROCESS(clk,rst)
BEGIN
	IF (rst = '1') THEN
		q(n-1 downto 20) <= (OTHERS => '0');
		q(19 downto 0) <= (OTHERS => '1');
	ELSIF rising_edge(clk) and enable = '1' THEN
		q <= d;
	END IF;
END PROCESS;
END StackRegArch;
Library ieee;
use ieee.std_logic_1164.all;

ENTITY Reg IS
GENERIC(n: integer := 16);
PORT(
clk, rst,enable: IN std_logic;
d: IN std_logic_vector(n-1 downto 0);
q: OUT std_logic_vector(n-1 downto 0)
);
END Reg;

ARCHITECTURE RegArch OF Reg IS
BEGIN
PROCESS(clk,rst)
BEGIN
	IF (rst = '1') THEN
		q <= (OTHERS => '0');
	ELSIF rising_edge(clk) and enable = '1' THEN
		q <= d;
	END IF;
END PROCESS;
END RegArch;
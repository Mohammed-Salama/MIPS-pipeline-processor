LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_unit IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR (5 DOWNTO 0); -- 5 = imm 4,3 = set  2,1,0 = op
        controls : OUT STD_LOGIC_VECTOR (22 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE CU_Arc OF control_unit IS
BEGIN
    PROCESS (opcode)
    BEGIN
        IF opcode(5) = '1' THEN
            controls(0) <= '1';
        ELSE
            controls(0) <= '0';
        END IF;
        IF opcode(4 DOWNTO 0) = "00000" THEN
            controls(22 DOWNTO 1) <= "0000000000000000000000";
        ELSIF opcode(4 DOWNTO 0) = "00001" THEN
            controls(22 DOWNTO 1) <= "0000000000000000000000";
        ELSIF opcode(4 DOWNTO 0) = "00010" THEN
            controls(22 DOWNTO 1) <= "0000000000001101110000";
        ELSIF opcode(4 DOWNTO 0) = "00011" THEN
            controls(22 DOWNTO 1) <= "0000000000000101101100";
        ELSIF opcode(4 DOWNTO 0) = "00100" THEN
            controls(22 DOWNTO 1) <= "0000000000000101000100";
        ELSIF opcode(4 DOWNTO 0) = "00101" THEN
            controls(22 DOWNTO 1) <= "0000000000010000000000";
        ELSIF opcode(4 DOWNTO 0) = "00110" THEN
            controls(22 DOWNTO 1) <= "0000000000100000000100";
        ELSIF opcode(4 DOWNTO 0) = "01000" THEN
            controls(22 DOWNTO 1) <= "0000000000000001001100";
        ELSIF opcode(4 DOWNTO 0) = "01001" THEN
            controls(22 DOWNTO 1) <= "0000000000000101010100";
        ELSIF opcode(4 DOWNTO 0) = "01010" THEN
            controls(22 DOWNTO 1) <= "0000000000000101011100";
        ELSIF opcode(4 DOWNTO 0) = "01011" THEN
            controls(22 DOWNTO 1) <= "0000000000000101100100";
        ELSIF opcode(4 DOWNTO 0) = "01100" THEN
            controls(22 DOWNTO 1) <= "0000000000000101010100";
        ELSIF opcode(4 DOWNTO 0) = "10000" THEN
            controls(22 DOWNTO 1) <= "0000000011000000000010";
        ELSIF opcode(4 DOWNTO 0) = "10001" THEN
            controls(22 DOWNTO 1) <= "0000000010000000000101";
        ELSIF opcode(4 DOWNTO 0) = "10010" THEN
            controls(22 DOWNTO 1) <= "0000000000000011001100";
        ELSIF opcode(4 DOWNTO 0) = "10011" THEN
            controls(22 DOWNTO 1) <= "0000000000000001010101";
        ELSIF opcode(4 DOWNTO 0) = "10100" THEN
            controls(22 DOWNTO 1) <= "0000000000000001010010";
        ELSIF opcode(4 DOWNTO 0) = "11000" THEN
            controls(22 DOWNTO 1) <= "0000000100000000000000";
        ELSIF opcode(4 DOWNTO 0) = "11001" THEN
            controls(22 DOWNTO 1) <= "0000001000000000000000";
        ELSIF opcode(4 DOWNTO 0) = "11010" THEN
            controls(22 DOWNTO 1) <= "0000010000000000000000";
        ELSIF opcode(4 DOWNTO 0) = "11011" THEN
            controls(22 DOWNTO 1) <= "0000100000000000000000";
        ELSIF opcode(4 DOWNTO 0) = "11100" THEN
            controls(22 DOWNTO 1) <= "0001000011000000000010";
        ELSIF opcode(4 DOWNTO 0) = "11101" THEN
            controls(22 DOWNTO 1) <= "0010000010000000000001";
        ELSIF opcode(4 DOWNTO 0) = "11110" THEN
            controls(22 DOWNTO 1) <= "1000000011000000000010";
        ELSIF opcode(4 DOWNTO 0) = "11111" THEN
            controls(22 DOWNTO 1) <= "0100000010000000000001";
        ELSE
            controls(22 DOWNTO 1) <= "0000000000000000000000";
        END IF;
    END PROCESS;
END ARCHITECTURE;

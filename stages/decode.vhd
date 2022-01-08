LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decode_stage IS
    PORT (
        clk : IN STD_LOGIC;
        write_enable : IN STD_LOGIC;
        write_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        signals : OUT STD_LOGIC_VECTOR (22 DOWNTO 0);
        rsrc1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        rsrc2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        IMM : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        Rdst : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rsrc1_Index, Rsrc2_Index: out std_logic_vector(2 downto 0)
    );
END ENTITY;

ARCHITECTURE DS_Arc OF decode_stage IS
BEGIN
    Rsrc1_Index <= instruction (22 DOWNTO 20);
    Rsrc2_Index <= instruction (19 DOWNTO 17);
    IMM <= instruction(15 DOWNTO 0);
    Rdst <= instruction(25 DOWNTO 23);
    RegFile : ENTITY work.RegisterFile
        PORT MAP(
            clk,
            instruction (22 DOWNTO 20),
            instruction (19 DOWNTO 17),
            data_in,
            write_enable,
            write_address,
            rsrc1,
            rsrc2
        );
    ControlUnit: ENTITY work.control_unit 
        PORT MAP(
            instruction(31 downto 26),
            signals
        );
END ARCHITECTURE;
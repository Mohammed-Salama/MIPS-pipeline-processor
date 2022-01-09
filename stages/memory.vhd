LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.NUMERIC_STD.ALL;
USE work.constants.ALL;

ENTITY Memory IS
    PORT (
        clk: In std_logic;
        FSP_UPPER : IN STD_LOGIC_VECTOR(HALF_SP_REG_SIZE - 1 DOWNTO 0); --new line
        ALUResult : IN STD_LOGIC_VECTOR(REG_SIZE - 1 DOWNTO 0);
        Rsrc2 : IN STD_LOGIC_VECTOR(REG_SIZE - 1 DOWNTO 0);
        InPort : IN STD_LOGIC_VECTOR(REG_SIZE - 1 DOWNTO 0);
        FSP_LOWER : IN STD_LOGIC_VECTOR(HALF_SP_REG_SIZE - 1 DOWNTO 0); --final stack pointer
        Rdst : IN STD_LOGIC_VECTOR(REG_INDEX_SIZE - 1 DOWNTO 0);
        -- Signals
        RTI, RET, CALL : IN STD_LOGIC;
        Stack : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        InEn, WBEn, MemW, memR : IN STD_LOGIC;
        --Output
        dataOut : OUT STD_LOGIC_VECTOR(MEM_WIDTH - 1 DOWNTO 0);
        ALUResultOut : OUT STD_LOGIC_VECTOR(ALU_RESULT_LEN - 1 DOWNTO 0);
        InPortOut : OUT STD_LOGIC_VECTOR(REG_SIZE - 1 DOWNTO 0);
        RdstOut : OUT STD_LOGIC_VECTOR(REG_INDEX_SIZE - 1 DOWNTO 0);
        memROut : OUT STD_LOGIC;
        --Output Signals
        InEnOut, WBEnOut : OUT STD_LOGIC
    );
END ENTITY;
ARCHITECTURE MemoryArch OF Memory IS
    SIGNAL MemoryAdress : STD_LOGIC_VECTOR(MEMOROY_ADRESS_LEN - 1 DOWNTO 0);
    SIGNAL dataout2temp : STD_LOGIC_VECTOR(MEM_WIDTH - 1 DOWNTO 0);
    signal is32: std_logic;
BEGIN
    Mem : ENTITY work.dataMemory PORT MAP(clk,MemW, is32, MemoryAdress, Rsrc2, Rsrc2, dataOut, dataout2temp);

    MemoryAdress <= "0000" & ALUResult WHEN Stack(1) = '0'
        ELSE
        FSP_UPPER (3 DOWNTO 0) & FSP_LOWER;

    is32 <= RTI or RET or CALL;
    ALUResultOut <= ALUResult;
    --Signals passed     
    InEnOut <= InEn;
    WBEnOut <= WBEn;
    memROut <= memR;
    RdstOut <= Rdst;
    InPortOut <= InPort;
END MemoryArch;
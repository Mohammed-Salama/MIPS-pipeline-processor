library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Execute is
    port(
        Rdst   : in std_logic_vector(REG_INDEX_SIZE-1 downto 0); 
        Rsrc1, Rsrc2 : in std_logic_vector(REG_SIZE-1 downto 0);
        IMM: in std_logic_vector(IMM_SIZE-1 downto 0);
        -- Signals
        INT, RTI, RET, CALL, JMP, JC, JN, JZ: in std_logic;
        Stack: in std_logic_vector (1 downto 0);
        InEn, OutEn, Carry, FlagEn, LDM, ALUEn: in std_logic;
        ALUOP: in std_logic_vector(OPCODE_LEN - 1 downto 0);
        WBEn, MemW, memR, IMMS: in std_logic;
        --Output
        ALUResult: out std_logic_vector(ALU_RESULT_LEN-1 downto 0);
        Rsrc2Out : out std_logic_vector(REG_SIZE-1 downto 0);
        RdstOut: out std_logic_vector(REG_INDEX_SIZE-1 downto 0);
        --Output Signals
        RTIOut, RETOut, CALLOut: out std_logic;
        StackOut: out std_logic_vector (1 downto 0);
        InEnOut, WBEnOut, MemWOut, memROut: out std_logic
    );
end entity;


architecture ExecuteArch of Execute is
signal ALUIn1, ALUIn2: std_logic_vector(REG_SIZE-1 downto 0);
signal ALUFlags: std_logic_vector(FLAG_REG_SIZE-1 downto 0);
signal ALUResultTemp : std_logic_vector(ALU_RESULT_LEN-1 downto 0);
begin 

    ALU : entity work.Alu port map (ALUOP,ALUIn1,ALUIn2,ALUResultTemp,ALUFlags);
    ALUIn1 <=   
		Rsrc1 when LDM = '0'
        else    IMM;
    ALUIn2 <=   
		Rsrc2 when IMMS = '0'
        else    IMM;              
    Rsrc2Out <= Rsrc2;
    RdstOut <= Rdst;

    ALUResult <= ALUResultTemp;
    --Signals passed 
    RTIOut     <=  RTI  ;          
    RETOut     <=  RET  ;   
    CALLOut    <=  CALL ;   
    StackOut   <=  Stack;      
    InEnOut    <=  InEn ; 
    WBEnOut    <=  WBEn ; 
    MemWOut    <=  MemW ;     
    memROut    <=  memR ; 
end ExecuteArch;

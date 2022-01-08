library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Execute is
    port(
        rst : in std_logic;
        sp_in : in std_logic_vector (31 downto 0);
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
        InEnOut, WBEnOut, MemWOut, memROut: out std_logic;
        --Extras
        ALUFlags: inout std_logic_vector(FLAG_REG_SIZE-1 downto 0);
        fsp_upper : out std_logic_vector (15 downto 0);
        fsp_lower : out std_logic_vector (15 downto 0);
        sp_out : out std_logic_vector (31 downto 0)
    );
end entity;


architecture ExecuteArch of Execute is
signal ALUIn1, ALUIn2: std_logic_vector(REG_SIZE-1 downto 0);
--signal ALUFlags: std_logic_vector(FLAG_REG_SIZE-1 downto 0);
signal ALUResultTemp : std_logic_vector(ALU_RESULT_LEN-1 downto 0);
signal SP_Operations : std_logic_vector(ALU_RESULT_LEN-1 downto 0);
signal SP_Real : std_logic_vector(ALU_RESULT_LEN-1 downto 0);
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
    
    sp_real <= std_logic_vector(unsigned (sp_in) - 1) when Stack(0) = '1' and CALL = '0'
    else std_logic_vector(unsigned (sp_in) - 2) when Stack(0) = '1' and CALL = '0'
    else std_logic_vector(unsigned (sp_in) + 1) when Stack(0) = '0' and CALL = '0'
    else std_logic_vector(unsigned (sp_in) + 2) when Stack(0) = '0' and CALL = '1'
    else sp_in;

    SP_Operations <= sp_real when Stack (0) = '0'
    else sp_in;

    sp_out <= 
        "00000000000011111111111111111111" when rst = '1'
        else sp_real;
    fsp_upper <= 
        "0000000000001111" when rst = '1'
        else SP_Operations(31 downto 16);
    fsp_upper <= 
        "1111111111111111" when rst = '1'
        else SP_Operations(15 downto 0);

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

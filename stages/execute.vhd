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
        sp_out : out std_logic_vector (31 downto 0);
        --FU
        FU_Rsrc1_en,FU_Rsrc2_en: in std_logic;
        FU_Rsrc1_MOrW,FU_Rsrc2_MOrW: in std_logic;
        EM_ALUResult: in std_logic_vector (15 downto 0);
        MW_DataIn: in std_logic_vector (15 downto 0)
    );
end entity;


architecture ExecuteArch of Execute is
signal ALUIn1, ALUIn2: std_logic_vector(REG_SIZE-1 downto 0);
--signal ALUFlags: std_logic_vector(FLAG_REG_SIZE-1 downto 0);
signal ALUResultTemp : std_logic_vector(ALU_RESULT_LEN-1 downto 0);
signal SP_Operations : std_logic_vector(31 downto 0);
signal SP_Real : std_logic_vector(31 downto 0);
begin 

    ALU : entity work.Alu port map (ALUOP,ALUIn1,ALUIn2,ALUResultTemp,ALUFlags);

    ALUIn1 <=   
		        Rsrc1   when LDM = '0' and FU_Rsrc1_en = '0'
        else    IMM     when LDM = '1' and FU_Rsrc1_en = '0'
        else    EM_ALUResult when FU_Rsrc1_MOrW = '1'
        else    MW_DataIn;

    ALUIn2 <=
		        Rsrc2   when IMMS = '0' and FU_Rsrc2_en = '0'
        else    IMM     when IMMS = '1' and FU_Rsrc2_en = '0'
        else    EM_ALUResult when FU_Rsrc2_MOrW = '1'
        else    MW_DataIn;   


        
                   
    Rsrc2Out <= Rsrc2;
    RdstOut <= Rdst;
    
    sp_real <= std_logic_vector(unsigned (sp_in) - 1) when Stack(0) = '1' and (CALL = '0' and INT = '0')
    else std_logic_vector(unsigned (sp_in) - 2) when Stack(0) = '1' and (CALL = '1' or INT = '1')
    else std_logic_vector(unsigned (sp_in) + 1) when Stack(0) = '0' and (RET = '0' and RTI = '0')
    else std_logic_vector(unsigned (sp_in) + 2) when Stack(0) = '0' and (RET = '1' or RTI = '1')
    else sp_in;

    SP_Operations <= sp_real when Stack (0) = '0'
    else sp_in;

    sp_out <= sp_real;


    fsp_upper <=  SP_Operations(31 downto 16);
    fsp_lower <=  SP_Operations(15 downto 0);

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

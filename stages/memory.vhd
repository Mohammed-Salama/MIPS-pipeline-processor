library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Memory is
    port(
        ALUResult: in std_logic_vector(REG_SIZE-1 downto 0);
        Rsrc2 : in std_logic_vector(REG_SIZE-1 downto 0);
        InPort: in std_logic_vector(REG_SIZE-1 downto 0);
        FSP: in std_logic_vector(SP_REG_SIZE-1 downto 0); --final stack pointer
        Rdst   : in std_logic_vector(REG_INDEX_SIZE-1 downto 0); 
        -- Signals
        RTI, RET, CALL: in std_logic;
        Stack: in std_logic_vector (1 downto 0);
        InEn, WBEn, MemW, memR: in std_logic;
        --Output
        dataOut: out std_logic_vector(MEM_WIDTH-1 downto 0);
        ALUResultOut: out std_logic_vector(ALU_RESULT_LEN-1 downto 0);
        InPortOut: out std_logic_vector(REG_SIZE-1 downto 0);
        RdstOut: out std_logic_vector(REG_INDEX_SIZE-1 downto 0);
        memROut: out std_logic;
        --Output Signals
        InEnOut, WBEnOut: out std_logic
    );
end entity;


architecture MemoryArch of Memory is
signal MemoryAdress: std_logic_vector(MEMOROY_ADRESS_LEN-1 downto 0);
signal dataout2temp : std_logic_vector(MEM_WIDTH-1 downto 0);
begin 
Mem : entity work.dataMemory port map(MemW,Stack(1),MemoryAdress,Rsrc2,Rsrc2,dataOut,dataout2temp );

    MemoryAdress <= "0000" & ALUResult when Stack(1) = '0'
            else "0000" & FSP;
	
    ALUResultOut <= ALUResult;
    --Signals passed     
    InEnOut    <=  InEn ; 
    WBEnOut    <=  WBEn ; 
    memROut     <= memR;
end MemoryArch;

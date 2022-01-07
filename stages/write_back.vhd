library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity WriteBack is
    port(
        Rdst   : in std_logic_vector(REG_INDEX_SIZE-1 downto 0); 
        dataOut: in std_logic_vector(MEM_WIDTH-1 downto 0);
        InPort: in std_logic_vector(REG_SIZE-1 downto 0);
        ALUResult: in std_logic_vector(ALU_RESULT_LEN-1 downto 0);
        InEn, WBEn, memR: in std_logic;
        --output
        WBEnOut: out std_logic;
        RdstOut: out std_logic_vector(REG_INDEX_SIZE-1 downto 0);
        RegisterDataIn: out std_logic_vector(REG_SIZE-1 downto 0);
    );
end entity;


architecture WriteBackArch of WriteBack is
begin 
    RdstOut <= Rdst;
    WBEnOut <= WBEn;
    RegisterDataIn<=    InPort when InEn = '1'
            else        dataOut when memR = '1'
            else        ALUResult;
end WriteBackArch;

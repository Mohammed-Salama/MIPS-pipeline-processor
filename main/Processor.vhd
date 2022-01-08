library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Main is
    port(
        clk, rst: in std_logic;
        In_Port: in std_logic_vector(15 downto 0);
        Out_Port: out std_logic_vector(15 downto 0)
    );
end entity;


architecture MainkArch of Main is
--Fetch Stage 
signal F_PC: std_logic_vector(PC_SIZE-1 downto 0);
signal F_instruction: std_logic_vector(PC_SIZE-1 downto 0);    

--FD Buffer
signal FD_instruction : std_logic_vector(PC_SIZE-1 downto 0);    

--Decode Stage
signal D_ControlSignals: std_logic_vector (22 DOWNTO 0);
signal D_Rsrc1,D_Rsrc2: std_logic_vector (15 downto 0);
signal D_Rdst: std_logic_vector (2 downto 0);
signal D_IMM: std_logic_vector (15 downto 0);
signal D_Rsrc1_Index, D_Rsrc2_Index: std_logic_vector (2 downto 0);

--DE Buffer
signal DE_Input: std_logic_vector(79 downto 0);
signal De_Output: std_logic_vector(79 downto 0);

--Execute
signal E_ALUResult: std_logic_vector(ALU_RESULT_LEN-1 downto 0);
signal E_Rsrc2Out :  std_logic_vector(REG_SIZE-1 downto 0);
signal E_RdstOut:  std_logic_vector(REG_INDEX_SIZE-1 downto 0);
signal E_ControlOUt : std_logic_vector (8 downto 0);

--EM Buffer
signal EM_Input: std_logic_vector (91 downto 0);
signal EM_Output: std_logic_vector(91 downto 0);

--Memory Stage
signal M_OUT: std_logic_vector ( 53 downto 0);


--MW Buffer
signal MW_Input: std_logic_vector (53 downto 0);
signal MW_Output: std_logic_vector(53 downto 0);


--Write Back Stage
signal  WB_WBEnOut: std_logic;
signal  WB_RdstOut: std_logic_vector(REG_INDEX_SIZE-1 downto 0);
signal  WB_RegisterDataIn: std_logic_vector(REG_SIZE-1 downto 0);


--Flag Register 
signal Flags_From_ALU: std_logic_vector(2 downto 0);
signal Flags:std_logic_vector(2 downto 0);


--Stack Poiter
signal SP_From_EX: std_logic_vector (31 downto 0);
signal REAL_SP: std_logic_vector (31 downto 0);


--Forward Unit
signal FU_Rsrc1_en,FU_Rsrc2_en: std_logic;
signal FU_Rsrc1_MOrW,FU_Rsrc2_MOrW: std_logic;

--TEMP
signal Buffers_enable,BUffers_Flush:std_logic;
signal FSP_LOWER: std_logic_vector (15 downto 0);
signal FSP_UPPER: std_logic_vector (15 downto 0); --new line

begin 

FlagRegisterModel : entity work.Reg GENERIC MAP (3) Port map(clk,rst,De_Output(60),Flags_From_ALU,Flags);
StackPointerModel : entity work.StackReg  Port map(clk,rst,De_Output(65),SP_From_EX,REAL_SP);
ForwardUnitModel: entity work.ForwardUnit port map(
    De_Output(79 downto 77), De_Output(76 downto 74),
    EM_Output(43 downto 41),MW_Output(5 downto 3),
    EM_Output(34),MW_Output(0),
    FU_Rsrc1_en,FU_Rsrc2_en,
    FU_Rsrc1_MOrW,FU_Rsrc2_MOrW
);


FetchStage:     entity work.Fetch port map(clk,rst,F_PC,F_instruction);
FD_Buffer:      entity work.PipelineBuffer GENERIC MAP (32) port map(clk,Buffers_enable,BUffers_Flush,F_instruction,FD_instruction);
DecodeStage:    entity work.decode_stage port map(clk,WB_WBEnOut, WB_RdstOut, WB_RegisterDataIn, FD_instruction,D_ControlSignals,D_Rsrc1,D_Rsrc2,D_IMM,D_Rdst,D_Rsrc1_Index,D_Rsrc2_Index);   
DE_Buffer:      entity work.PipelineBuffer GENERIC MAP (80) port map(clk,Buffers_enable,BUffers_Flush,DE_Input,De_Output);
ExecuteStage:   entity work.Execute port map(
                        rst,
                        REAL_SP,
                        De_Output(34 downto 32) , De_Output(31 downto 16), De_Output(15 downto 0),De_Output(50 downto 35),
                        De_Output(73),De_Output(72),De_Output(71),De_Output(70),De_Output(69),De_Output(68),De_Output(67),De_Output(66),
                        De_Output(65 downto 64),
                        De_Output(63),De_Output(62),De_Output(61),De_Output(60),De_Output(59),De_Output(58),
                    --                                               FlagEn
                        De_Output(57 downto 55),
                        De_Output(54),De_Output(53),De_Output(52),De_Output(51),
                        --Output
                        E_ALUResult,E_Rsrc2Out,E_RdstOut,
                        --Output Signals
                        E_ControlOUt(8),E_ControlOUt(7),E_ControlOUt(6),
                        E_ControlOUt(5 downto 4),
                        E_ControlOUt(3),E_ControlOUt(2),E_ControlOUt(1),E_ControlOUt(0),
                        Flags_From_ALU,
                        FSP_UPPER,
                        FSP_LOWER,
                        SP_From_EX,
                        --FU
                        FU_Rsrc1_en,FU_Rsrc2_en,
                        FU_Rsrc1_MOrW,FU_Rsrc2_MOrW,
                        EM_Output(75 downto 60),
                        WB_RegisterDataIn
);

EM_Buffer:      entity work.PipelineBuffer GENERIC MAP (92) port map(clk,Buffers_enable,BUffers_Flush,EM_Input,EM_Output);

MemoryStage:    entity work.Memory port map(
    EM_Output (91 downto 76),    --new line
    EM_Output(75 downto 60), EM_Output(59 downto 44), EM_Output(31 downto 16), EM_Output(15 downto 0), EM_Output(43 downto 41), 
    EM_Output(40), EM_Output(39), EM_Output(38), 
    EM_Output(37 downto 36),
    EM_Output(35), EM_Output(34), EM_Output(33), EM_Output(32),
    M_OUT(53 downto 38), M_OUT(37 downto 22), M_OUT(21 downto 6), 
    M_OUT(5 downto 3), 
    M_OUT(2), M_OUT(1), M_OUT(0)
);


MW_Buffer:      entity work.PipelineBuffer GENERIC MAP (54) port map(clk,Buffers_enable,BUffers_Flush,MW_Input,MW_Output);

WriteBackStage: entity work.WriteBack port map(
    MW_Output(5 downto 3), MW_Output(53 downto 38), MW_Output(21 downto 6), MW_Output(37 downto 22),
    MW_Output(1), MW_Output(0), MW_Output(2),
    WB_WBEnOut, WB_RdstOut, WB_RegisterDataIn
);




DE_Input <= D_Rsrc1_Index & D_Rsrc1_Index & D_ControlSignals & D_IMM & D_Rdst & D_Rsrc1 & D_Rsrc2;
--             79-77         76-74          73-51            50-35      34-32    31-16      15 -0

EM_Input <= FSP_UPPER & --new line 91 76
            E_ALUResult & E_Rsrc2Out & E_RdstOut & --75 60    59 44   43 41
            E_ControlOUt(8) & E_ControlOUt(7) & E_ControlOUt(6) & 
            E_ControlOUt(5 downto 4) & 
            E_ControlOUt(3) & E_ControlOUt(2) & E_ControlOUt(1) & E_ControlOUt(0) & 
        --                       wb
            In_Port & FSP_LOWER;


MW_Input <= M_OUT;
Out_Port <= De_Output(31 downto 16) when De_Output(62) = '1';

Buffers_enable<='1';
BUffers_Flush<='0';
FSP_LOWER <= (Others => '0');
FSP_UPPER <= (Others => '0');

end MainkArch;

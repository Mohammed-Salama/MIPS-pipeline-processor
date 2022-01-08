library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Fetch is
    port(
        clk, rst : in std_logic ;                                                  -- clk
        out_pc : out std_logic_vector(PC_SIZE-1 downto 0);
        memory_out : inout std_logic_vector(PC_SIZE-1 downto 0);       -- fetched from memory
        jmp : in std_logic;
        jc : in std_logic;
        jn : in std_logic;
        jz : in std_logic;
        ALUFlags: in std_logic_vector(FLAG_REG_SIZE-1 downto 0);
        branch_pc_before_extend  : in std_logic_vector (REG_SIZE-1 downto 0)
        -- inst_mem_input_data   : in std_logic_vector(2*MEM_WIDTH-1 downto 0);   -- input to instuction memory 
        -- inst_mem_write_enable : in std_logic                                -- to write on instruction memory
    );
end entity;


architecture FetchArch of Fetch is

signal pc : std_logic_vector(PC_SIZE-1 downto 0) := (others =>'0'); -- pc is starting at address zero ?
signal PCReset : std_logic_vector(PC_SIZE-1 downto 0);

begin
    instMem : entity work.instructionMemory PORT MAP (clk,pc,memory_out,PCReset);
    process (clk) is
        variable temp_pc : std_logic_vector(PC_SIZE-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                out_pc <= PCReset;
		        pc <= PCReset;
            else 
                if memory_out(31) = '1' then                      -- has immediate value
                    temp_pc := pc + 2;
                elsif memory_out(31 downto 26) = HLT_OPCODE then
                    temp_pc := pc;                                 -- freeze pc
                elsif jmp = '1' or (jz = '1' and ALUFlags(ZERO_FLAG_INDEX) = '1') or (jc = '1' and ALUFlags(CARRY_FLAG_INDEX) = '1') or (jn = '1' and ALUFlags(NEG_FLAG_INDEX) = '1') then
                    temp_pc :=  x"0000" & branch_pc_before_extend;             
                else
                    temp_pc := pc + 1;                          
                end if;

                pc <= temp_pc;
                out_pc <= temp_pc;

            end if;
        end if;
    end process;

end FetchArch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity Fetch is
    port(
        out_pc : out std_logic_vector(PC_SIZE-1 downto 0);
        memory_out : inout std_logic_vector(PC_SIZE-1 downto 0);               -- fetched from memory
        inst_mem_input_data   : in std_logic_vector(2*MEM_WIDTH-1 downto 0);   -- input to instuction memory 
        inst_mem_write_enable : in std_logic;                                -- to write on instruction memory
        clk : in std_logic                                                   -- clk
    );
end entity;


architecture FetchArch of Fetch is
 
component instructionMemory is generic (n : integer := 16 ; m : integer := 20);
port(
		clk           : in std_logic;
		write_enable  : in std_logic;
		address       : in  std_logic_vector(2*n-1 downto 0);         -- pc is 32 bit , we care about first 20 bits, then all bits excepts the first 20 bits must be zero else OUT_OF_RANGE INDEXING will happen.
		datain        : in  std_logic_vector(2*n-1 downto 0);
		dataout       : out std_logic_vector(2*n-1 downto 0));
end component;

signal pc : std_logic_vector(PC_SIZE-1 downto 0) := (others =>'0'); -- pc is starting at address zero ?

begin
    instMem : instructionMemory PORT MAP (clk,inst_mem_write_enable,pc,inst_mem_input_data,memory_out);

    process (clk) is
        variable temp_pc : std_logic_vector(PC_SIZE-1 downto 0);
    begin
        if rising_edge(clk) then


            if memory_out(31) = '1' then                      -- has immediate value
                temp_pc := pc + 2;
            elsif memory_out(31 downto 26) = HLT_OPCODE then
                temp_pc := pc;                                 -- freeze pc
            else
                temp_pc := pc + 1;                          
            end if;

            pc <= temp_pc;
            out_pc <= temp_pc;
            -- TODO : handle jump and call instrucitons


        end if;
    end process;

end FetchArch;


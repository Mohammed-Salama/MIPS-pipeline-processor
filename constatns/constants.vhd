LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

package Constants is


    --Projects constants
    CONSTANT REG_SIZE : integer :=16;
    CONSTANT PC_SIZE  : integer :=32;
    CONSTANT MEM_WIDTH : integer := 16;


    
    -- INSTRUCTION OPCODES:       OPCODE = IMMEDIATE BIT + 5 BITS  
    
    CONSTANT HLT_OPCODE : std_logic_vector(5 downto 0) := "000001" ;


    --Flag register constants
    CONSTANT FLAG_REG_SIZE    :  integer  :=3;
    CONSTANT ZERO_FLAG_INDEX  :  integer  :=0;
    CONSTANT CARRY_FLAG_INDEX :  integer  :=1;
    CONSTANT NEG_FLAG_INDEX   :  integer  :=2;

    -- ALU opcodes and constants
    CONSTANT OPCODE_LEN: integer                      := 3;
    CONSTANT INC_OPCODE: std_logic_vector(2 downto 0) := "000";
    CONSTANT MOV_OPCODE: std_logic_vector(2 downto 0) := "001";
    CONSTANT ADD_OPCODE: std_logic_vector(2 downto 0) := "010";
    CONSTANT SUB_OPCODE: std_logic_vector(2 downto 0) := "011";
    CONSTANT AND_OPCODE: std_logic_vector(2 downto 0) := "100";
    CONSTANT NOT_OPCODE: std_logic_vector(2 downto 0) := "101";
    CONSTANT SETC_OPCODE:std_logic_vector(2 downto 0) := "110";




  end package Constants;
  
  package body Constants is
  end package body Constants;
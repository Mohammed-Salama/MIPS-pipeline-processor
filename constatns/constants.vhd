LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

package Constants is


    --Projects constants
    CONSTANT REG_SIZE : integer :=16;
    CONSTANT PC_SIZE  : integer :=32;
    CONSTANT MEM_WIDTH : integer := 16;
    CONSTANT PIPELINE_BUFF_SIZE : integer := 64;
    CONSTANT REG_INDEX_SIZE : integer := 3;                    -- register file registers
    CONSTANT IMM_SIZE: integer := 16;


    
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
    CONSTANT ALU_RESULT_LEN: integer                  := 16;


    -- pipeline buffer indecies:
      -- signals form CU ONE BIT:
        CONSTANT int_idx          : integer :=  0;
        CONSTANT rti_idx          : integer :=  1;
        CONSTANT ret_idx          : integer :=  2;
        CONSTANT call_idx         : integer :=  3;
        CONSTANT jmp_idx          : integer :=  4;
        CONSTANT jc_idx           : integer :=  5;
        CONSTANT jn_idx           : integer :=  6;
        CONSTANT jz_idx           : integer :=  7;
        CONSTANT stack1_idx       : integer :=  8;
        CONSTANT stack0_idx       : integer :=  9;
        CONSTANT inEn_idx         :  integer:=  10;
        CONSTANT outEn_idx        : integer :=  11;
        CONSTANT carry_idx        : integer :=  12;
        CONSTANT flagEn_idx       : integer :=  13;
        CONSTANT ldm_idx	        : integer :=  14;
        CONSTANT aluop2_idx       : integer :=  15;
        CONSTANT aluop1_idx       : integer :=  16;
        CONSTANT aluop0_idx       : integer :=  17;
        CONSTANT wbEn_idx         : integer :=  18;
        CONSTANT memw_idx         : integer :=  19;
        CONSTANT memr_idx         : integer :=  20; 
        CONSTANT imm_idx          : integer :=  21;
        CONSTANT aluEn_idx        : integer :=  22;
     
        -- IMM VALUE START AT INDEX 23 AND TAKE UP IMM_SIZE = 16:
        CONSTANT imm_start_index  : integer := 23;                                        -- from 23 to 38
      
        -- RSRC1 INDEX STARTS AT INDEX 39 AND TAKE UP REG_INDEX_SIZE = 3
        CONSTANT rsrc1_start_index : integer := imm_start_index + IMM_SIZE;                -- from 39 to 41
      
        -- RSRC2 INDEX STARTS AT INDEX 42 AND TAKE UP REG_INDEX_SIZE = 3
        CONSTANT rsrc2_start_index : integer := rsrc1_start_index + REG_INDEX_SIZE;         -- from 42 to 44
      
        -- RSRC1 VALUE STARTS AT INDEX 45 AND TAKES UP REG_SIZE = 16
        CONSTANT rsrc1_data_start_index : integer := rsrc2_start_index + REG_INDEX_SIZE;   -- from 45 to 60
      
        -- RSRC2 VALUE STARTS AT INDEX 61 AND TAKES UP REG_SIZE = 16 
        CONSTANT rsrc2_data_start_index : integer := rsrc1_data_start_index + REG_SIZE;    -- from 61 to 76
      
        -- PC VALUE STARTS AT INDEX 77 AND TAKES UP PC_SIZE = 32 
        CONSTANT pc_value_start_index  : integer := rsrc2_data_start_index + REG_SIZE;     -- from 77 to 108

        -- IN REG VALUE STARTS AT INDEX 109 AND TAKES UP REG_SIZE = 16
        CONSTANT in_value_start_index : integer := pc_value_start_index + PC_SIZE;         -- from 109 to 124





  end package Constants;
  
  package body Constants is
  end package body Constants;

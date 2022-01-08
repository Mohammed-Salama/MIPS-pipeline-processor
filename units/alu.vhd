library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;


-- Assumption : if the instruction needs single operand (rsrc1) will be used.

entity Alu is
    port(
        alu_enable : in std_logic;
        opcode : in std_logic_vector(OPCODE_LEN-1 downto 0);
        rsrc1  : in std_logic_vector(REG_SIZE-1 downto 0);
        rsrc2  : in std_logic_vector(REG_SIZE-1 downto 0);
        result : inout std_logic_vector(REG_SIZE-1 downto 0);
        flags  : inout std_logic_vector(FLAG_REG_SIZE-1 downto 0)
    );
end entity;



architecture AluArch of Alu is

    signal tmp: std_logic_vector (REG_SIZE downto 0);  -- tmp size should be REG_SIZE+1 to store addition/subtraction results.

begin

    process(rsrc1,rsrc2,opcode,alu_enable)
    begin
            if alu_enable = '1' then
                case(opcode) is
                when ADD_OPCODE => 
                    result <= rsrc1 + rsrc2 ; 
                when SUB_OPCODE => 
                    result <= rsrc1 - rsrc2 ;
                when AND_OPCODE => 
                    result <= rsrc1 and rsrc2;
                when INC_OPCODE =>
                    result <= rsrc1 + 1;
                when NOT_OPCODE =>
                    result <= not rsrc1;
                when MOV_OPCODE =>
                    result <= rsrc1;
                when others => 
                    result <= (Others=>'0'); 
                end case;
            end if;
    end process;

    -- SETTING CARRY FLAG
    tmp  <= ('0' & rsrc1) + ('0'&rsrc2);
    flags(CARRY_FLAG_INDEX) <= '1' when ( alu_enable = '1' and ((opcode=ADD_OPCODE and tmp(REG_SIZE)='1') or (opcode=SETC_OPCODE) or (opcode=INC_OPCODE and rsrc1=x"ffff") or (rsrc1<rsrc2 and opcode=SUB_OPCODE)) )else 
                               '0' when ( alu_enable = '1' and (opcode = ADD_OPCODE or opcode = INC_OPCODE or opcode = SUB_OPCODE)) else flags(CARRY_FLAG_INDEX);

    -- SETTING ZERO FLAG
    flags(ZERO_FLAG_INDEX) <= flags(ZERO_FLAG_INDEX) when (alu_enable ='0' or (opcode  = SETC_OPCODE) )else '1' when (result = x"0000") else '0';

    -- SETTING NEG FLAG
    flags(NEG_FLAG_INDEX) <= flags(NEG_FLAG_INDEX) when  (alu_enable ='0' or (opcode  = SETC_OPCODE))else '1' when (result(REG_SIZE-1)= '1') else '0';

end AluArch;
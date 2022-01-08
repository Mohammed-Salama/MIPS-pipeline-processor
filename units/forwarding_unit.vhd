library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;


-- Assumption : if the instruction needs single operand (rsrc1) will be used.

entity ForwardUnit is
    port(
        DE_Rsrc1,DE_Rsrc2: in std_logic_vector(2 downto 0);
        EM_Rdst, MW_Rdst: in std_logic_vector(2 downto 0);
        EM_WB, MW_WB: in std_logic;
        Rsrc1_en,Rsrc2_en: out std_logic;
        Rsrc1_MOrW, Rsrc2_MOrW: out std_logic
    );
end entity;

architecture ForwardUnitArch of ForwardUnit is

begin
    Rsrc1_en <= '1' when ( (EM_Rdst = DE_Rsrc1 and EM_WB = '1') or (MW_Rdst = DE_Rsrc1 and MW_WB = '1') )
    else '0';

    Rsrc2_en <= '1' when ( (EM_Rdst = DE_Rsrc2 and EM_WB = '1') or (MW_Rdst = DE_Rsrc2 and MW_WB = '1') )
    else '0';

    Rsrc1_MOrW <= '1' when (EM_Rdst = DE_Rsrc1 and EM_WB = '1') 
    else '0';

    Rsrc2_MOrW <= '1' when (EM_Rdst = DE_Rsrc2 and EM_WB = '1') 
    else '0';


end ForwardUnitArch;
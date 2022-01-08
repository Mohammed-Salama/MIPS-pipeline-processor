LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;


entity RegisterFile is
    port(
        clk : in std_logic;
        rsrc1 : in std_logic_vector(2 downto 0);
        rsrc2 : in std_logic_vector(2 downto 0);
        data_in : in std_logic_vector(15 downto 0);
        write_enable  : in std_logic;
        write_address : in std_logic_vector(2 downto 0);
        rsrc1_out : out std_logic_vector(15 downto 0);
        rsrc2_out : out std_logic_vector(15 downto 0)
    );
end entity;



architecture RegisterFileArch of RegisterFile is
    type regFileType is array(0 to 7) of std_logic_vector(15 downto 0);
    signal regFile : regFileType;
    begin

    process(clk) is
    begin
    
    if falling_edge(clk) then
        if write_enable = '1' then
        regFile(to_integer(unsigned((write_address)))) <= data_in;
        end if;
    end if;

    rsrc1_out <= regFile(to_integer(unsigned((rsrc1))));
    rsrc2_out <= regFile(to_integer(unsigned((rsrc2))));

    end process;
    
end RegisterFileArch;


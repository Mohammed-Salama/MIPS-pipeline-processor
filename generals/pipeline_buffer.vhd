library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
use work.constants.all;

entity PipelineBuffer  is generic (n : integer := 128 );
    port(
        clk : in std_logic;
        enable : in std_logic;
        flush : in std_logic;
        in_port : in std_logic_vector(n-1 downto 0);
        out_port : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture PipelineBufferArch of PipelineBuffer is
    begin
        process(clk) is
        variable buff : std_logic_vector( n-1 downto 0);
        begin
            if rising_edge(clk) then
                if (flush = '1') then
                    buff := (others =>'0');
                elsif(enable = '1') then
                    buff := in_port;
                end if;
                out_port <= buff;
            end if;
        end process;
end PipelineBufferArch;
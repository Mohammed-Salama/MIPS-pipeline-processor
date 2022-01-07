ENTITY testbench IS
END testbench;

ARCHITECTURE testbenchArch OF testbench IS
BEGIN
    PROCESS
    BEGIN
        testa <= '0';
        testb <= '0';
        WAIT FOR 10 ns;
        ASSERT(testz = ?0?) REPORT ?z IS NOT 0 FOR 00?
        SEVERITY ERROR;
        WAIT;
    END PROCESS;
    uut : and2 PORT MAP(
        a => testa, b =>
        testb, z => testz);

END testbenchArch
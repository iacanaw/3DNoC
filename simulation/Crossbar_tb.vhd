--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Crossbar Testbench                                                --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Jul 7th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Jul 7th, 2015                                       --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;

entity Crossbar_tb is
end Crossbar_tb;

architecture Crossbar_tb of Crossbar_tb is

    signal table       :   Array1D_ports(0 to PORTS-1) := (OTHERS=>(OTHERS=>'0'));
    signal data_in     :   Array1D_data(0 to PORTS-1) := (OTHERS=>(OTHERS=>'0'));
    signal control_in  :   Array1D_control(0 to PORTS-1) := (OTHERS=>(OTHERS=>'0'));
    signal data_out    :   Array1D_data(0 to PORTS-1);
    signal control_out :   Array1D_control(0 to PORTS-1);

begin
    
    -- LOCAL SENDING TO EAST
    table(LOCAL)(EAST) <= '1' after 15 ns, '0' after 35 ns;
    data_in(LOCAL)     <= x"1234" after 15 ns,  x"0000" after 35 ns;
    control_in(LOCAL)  <= "111" after 15 ns, "000" after 35 ns;
    control_in(EAST)   <= "111" after 15 ns, "000" after 35 ns;
    
    -- UP SENDING TO DOWN
    table(UP)(DOWN) <= '1' after 45 ns, '0' after 65 ns;
    data_in(UP)     <= x"1234" after 45 ns, x"0000" after 65 ns;
    control_in(UP)  <= "111" after 45 ns, "000" after 65 ns;
    control_in(DOWN)   <= "111" after 45 ns, "000" after 65 ns;

    -- WEST SENDING TO SOUTH AND SOUTH TO NORTH
    table(WEST)(SOUTH) <= '1' after 75 ns, '0' after 95 ns;
    data_in(WEST)     <= x"1234" after 75 ns,  x"0000" after 95 ns;
    control_in(WEST)  <= "111" after 75 ns, "000" after 95 ns;
    control_in(SOUTH)   <= "111" after 75 ns, "000" after 95 ns;
    
    table(SOUTH)(NORTH) <= '1' after 75 ns, '0' after 95 ns;
    data_in(SOUTH)     <= x"1234" after 75 ns,  x"0000" after 95 ns;
    --control_in(SOUTH)  <= "111" after 75 ns, "000" after 95 ns; -- same as the line 43
    control_in(NORTH)   <= "111" after 75 ns, "000" after 95 ns;
    
    CROSSBAR: entity work.Crossbar 
    port map(
        table       =>  table,
        data_in     =>  data_in,
        control_in  =>  control_in,
        data_out    =>  data_out,
        control_out =>  control_out
    );

end architecture;
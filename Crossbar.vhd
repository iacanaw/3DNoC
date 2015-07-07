--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Crossbar                                                          --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Jul 6th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Jul 6th, 2015                                       --
--------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;

entity Crossbar is
    port(   
        table       :   in Array1D_ports(0 to PORTS-1);
        data_in     :   in Array1D_data(0 to PORTS-1);
        control_in  :   in Array1D_control(0 to PORTS-1);
        data_out    :   out Array1D_data(0 to PORTS-1);
        control_out :   out Array1D_control(0 to PORTS-1)
    );
end Crossbar;

architecture full of Crossbar is
begin
--------------------------------------------------------------------------------------
-- LOCAL PORT
--------------------------------------------------------------------------------------
    data_out(LOCAL) <= data_in(EAST) when table(EAST)(LOCAL) = '1' else
                    data_in(SOUTH) when table(SOUTH)(LOCAL) = '1' else
                    data_in(WEST) when table(WEST)(LOCAL) = '1' else
                    data_in(NORTH) when table(NORTH)(LOCAL) = '1' else
                    data_in(UP) when table(UP)(LOCAL) = '1' else
                    data_in(DOWN); --when table(DOWN)(LOCAL) = '1'
                    
    control_out(LOCAL)(EOP) <= control_in(EAST)(EOP) when table(EAST)(LOCAL) = '1' else
                     control_in(SOUTH)(EOP) when table(SOUTH)(LOCAL) = '1' else
                     control_in(WEST)(EOP) when table(WEST)(LOCAL) = '1' else
                     control_in(NORTH)(EOP) when table(NORTH)(LOCAL) = '1' else
                     control_in(UP)(EOP) when table(UP)(LOCAL) = '1' else
                     control_in(DOWN)(EOP) when table(DOWN)(LOCAL) = '1' else
                     '0';
    
    control_out(LOCAL)(RX) <= control_in(EAST)(TX) when table(EAST)(LOCAL) = '1' else
                     control_in(SOUTH)(TX) when table(SOUTH)(LOCAL) = '1' else
                     control_in(WEST)(TX) when table(WEST)(LOCAL) = '1' else
                     control_in(NORTH)(TX) when table(NORTH)(LOCAL) = '1' else
                     control_in(UP)(TX) when table(UP)(LOCAL) = '1' else
                     control_in(DOWN)(TX) when table(DOWN)(LOCAL) = '1' else
                     '0';
    
    control_out(LOCAL)(STALL_GO) <= control_in(EAST)(STALL_GO) when table(LOCAL)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when table(LOCAL)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when table(LOCAL)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when table(LOCAL)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when table(LOCAL)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when table(LOCAL)(DOWN) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- EAST PORT
--------------------------------------------------------------------------------------
    data_out(EAST) <= data_in(SOUTH) when table(SOUTH)(EAST) = '1' else
                     data_in(WEST) when table(WEST)(EAST) = '1' else
                     data_in(NORTH) when table(NORTH)(EAST) = '1' else
                     data_in(UP) when table(UP)(EAST) = '1' else
                     data_in(DOWN) when table(DOWN)(EAST) = '1' else
                     data_in(LOCAL); --when table(LOCAL)(EAST) = '1'
                    
    control_out(EAST)(EOP) <= control_in(SOUTH)(EOP) when table(SOUTH)(EAST) = '1' else
                     control_in(WEST)(EOP) when table(WEST)(EAST) = '1' else
                     control_in(NORTH)(EOP) when table(NORTH)(EAST) = '1' else
                     control_in(UP)(EOP) when table(UP)(EAST) = '1' else
                     control_in(DOWN)(EOP) when table(DOWN)(EAST) = '1' else
                     control_in(LOCAL)(EOP) when table(LOCAL)(EAST) = '1' else
                     '0';
    
    control_out(EAST)(RX) <= control_in(SOUTH)(TX) when table(SOUTH)(EAST) = '1' else
                     control_in(WEST)(TX) when table(WEST)(EAST) = '1' else
                     control_in(NORTH)(TX) when table(NORTH)(EAST) = '1' else
                     control_in(UP)(TX) when table(UP)(EAST) = '1' else
                     control_in(DOWN)(TX) when table(DOWN)(EAST) = '1' else
                     control_in(LOCAL)(TX) when table(LOCAL)(EAST) = '1' else
                     '0';
    
    control_out(EAST)(STALL_GO) <= control_in(SOUTH)(STALL_GO) when table(EAST)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when table(EAST)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when table(EAST)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when table(EAST)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when table(EAST)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when table(EAST)(LOCAL) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- SOUTH PORT
--------------------------------------------------------------------------------------
    data_out(SOUTH) <= data_in(WEST) when table(WEST)(SOUTH) = '1' else
                     data_in(NORTH) when table(NORTH)(SOUTH) = '1' else
                     data_in(UP) when table(UP)(SOUTH) = '1' else
                     data_in(DOWN) when table(DOWN)(SOUTH) = '1' else
                     data_in(LOCAL) when table(LOCAL)(SOUTH) = '1' else
                     data_in(EAST); --when table(EAST)(SOUTH) = '1'
                    
    control_out(SOUTH)(EOP) <= control_in(WEST)(EOP) when table(WEST)(SOUTH) = '1' else
                     control_in(NORTH)(EOP) when table(NORTH)(SOUTH) = '1' else
                     control_in(UP)(EOP) when table(UP)(SOUTH) = '1' else
                     control_in(DOWN)(EOP) when table(DOWN)(SOUTH) = '1' else
                     control_in(LOCAL)(EOP) when table(LOCAL)(SOUTH) = '1' else
                     control_in(EAST)(EOP) when table(EAST)(SOUTH) = '1' else
                     '0';
    
    control_out(SOUTH)(RX) <= control_in(WEST)(TX) when table(WEST)(SOUTH) = '1' else
                     control_in(NORTH)(TX) when table(NORTH)(SOUTH) = '1' else
                     control_in(UP)(TX) when table(UP)(SOUTH) = '1' else
                     control_in(DOWN)(TX) when table(DOWN)(SOUTH) = '1' else
                     control_in(LOCAL)(TX) when table(LOCAL)(SOUTH) = '1' else
                     control_in(EAST)(TX) when table(EAST)(SOUTH) = '1' else
                     '0';
    
    control_out(SOUTH)(STALL_GO) <= control_in(WEST)(STALL_GO) when table(SOUTH)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when table(SOUTH)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when table(SOUTH)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when table(SOUTH)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when table(SOUTH)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when table(SOUTH)(EAST) = '1' else
                     '0';      
--------------------------------------------------------------------------------------
-- WEST PORT
--------------------------------------------------------------------------------------
    data_out(WEST) <= data_in(NORTH) when table(NORTH)(WEST) = '1' else
                     data_in(UP) when table(UP)(WEST) = '1' else
                     data_in(DOWN) when table(DOWN)(WEST) = '1' else
                     data_in(LOCAL) when table(LOCAL)(WEST) = '1' else
                     data_in(EAST) when table(EAST)(WEST) = '1' else
                     data_in(SOUTH); --when table(SOUTH)(WEST) = '1'
                    
    control_out(WEST)(EOP) <= control_in(NORTH)(EOP) when table(NORTH)(WEST) = '1' else
                     control_in(UP)(EOP) when table(UP)(WEST) = '1' else
                     control_in(DOWN)(EOP) when table(DOWN)(WEST) = '1' else
                     control_in(LOCAL)(EOP) when table(LOCAL)(WEST) = '1' else
                     control_in(EAST)(EOP) when table(EAST)(WEST) = '1' else
                     control_in(SOUTH)(EOP) when table(SOUTH)(WEST) = '1' else
                     '0';
    
    control_out(WEST)(RX) <= control_in(NORTH)(TX) when table(NORTH)(WEST) = '1' else
                     control_in(UP)(TX) when table(UP)(WEST) = '1' else
                     control_in(DOWN)(TX) when table(DOWN)(WEST) = '1' else
                     control_in(LOCAL)(TX) when table(LOCAL)(WEST) = '1' else
                     control_in(EAST)(TX) when table(EAST)(WEST) = '1' else
                     control_in(SOUTH)(TX) when table(SOUTH)(WEST) = '1' else
                     '0';
    
    control_out(WEST)(STALL_GO) <= control_in(NORTH)(STALL_GO) when table(WEST)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when table(WEST)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when table(WEST)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when table(WEST)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when table(WEST)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when table(WEST)(SOUTH) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- NORTH PORT
--------------------------------------------------------------------------------------
    data_out(NORTH) <= data_in(UP) when table(UP)(NORTH) = '1' else
                     data_in(DOWN) when table(DOWN)(NORTH) = '1' else
                     data_in(LOCAL) when table(LOCAL)(NORTH) = '1' else
                     data_in(EAST) when table(EAST)(NORTH) = '1' else
                     data_in(SOUTH) when table(SOUTH)(NORTH) = '1' else
                     data_in(WEST); --when table(WEST)(NORTH) = '1'
                    
    control_out(NORTH)(EOP) <= control_in(UP)(EOP) when table(UP)(NORTH) = '1' else
                     control_in(DOWN)(EOP) when table(DOWN)(NORTH) = '1' else
                     control_in(LOCAL)(EOP) when table(LOCAL)(NORTH) = '1' else
                     control_in(EAST)(EOP) when table(EAST)(NORTH) = '1' else
                     control_in(SOUTH)(EOP) when table(SOUTH)(NORTH) = '1' else
                     control_in(WEST)(EOP) when table(WEST)(NORTH) = '1' else
                     '0';
    
    control_out(NORTH)(RX) <= control_in(UP)(TX) when table(UP)(NORTH) = '1' else
                     control_in(DOWN)(TX) when table(DOWN)(NORTH) = '1' else
                     control_in(LOCAL)(TX) when table(LOCAL)(NORTH) = '1' else
                     control_in(EAST)(TX) when table(EAST)(NORTH) = '1' else
                     control_in(SOUTH)(TX) when table(SOUTH)(NORTH) = '1' else
                     control_in(WEST)(TX) when table(WEST)(NORTH) = '1' else
                     '0';
    
    control_out(NORTH)(STALL_GO) <= control_in(UP)(STALL_GO) when table(NORTH)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when table(NORTH)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when table(NORTH)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when table(NORTH)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when table(NORTH)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when table(NORTH)(WEST) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- UP PORT
--------------------------------------------------------------------------------------
    data_out(UP) <= data_in(DOWN) when table(DOWN)(UP) = '1' else
                     data_in(LOCAL) when table(LOCAL)(UP) = '1' else
                     data_in(EAST) when table(EAST)(UP) = '1' else
                     data_in(SOUTH) when table(SOUTH)(UP) = '1' else
                     data_in(WEST) when table(WEST)(UP) = '1' else
                     data_in(NORTH); --when table(NORTH)(UP) = '1'
                    
    control_out(UP)(EOP) <= control_in(DOWN)(EOP) when table(DOWN)(UP) = '1' else
                     control_in(LOCAL)(EOP) when table(LOCAL)(UP) = '1' else
                     control_in(EAST)(EOP) when table(EAST)(UP) = '1' else
                     control_in(SOUTH)(EOP) when table(SOUTH)(UP) = '1' else
                     control_in(WEST)(EOP) when table(WEST)(UP) = '1' else
                     control_in(NORTH)(EOP) when table(NORTH)(UP) = '1' else
                     '0';
    
    control_out(UP)(RX) <= control_in(DOWN)(TX) when table(DOWN)(UP) = '1' else
                     control_in(LOCAL)(TX) when table(LOCAL)(UP) = '1' else
                     control_in(EAST)(TX) when table(EAST)(UP) = '1' else
                     control_in(SOUTH)(TX) when table(SOUTH)(UP) = '1' else
                     control_in(WEST)(TX) when table(WEST)(UP) = '1' else
                     control_in(NORTH)(TX) when table(DOWN)(NORTH) = '1' else
                     '0';
    
    control_out(UP)(STALL_GO) <= control_in(DOWN)(STALL_GO) when table(UP)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when table(UP)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when table(UP)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when table(UP)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when table(UP)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when table(UP)(NORTH) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- DOWN PORT
--------------------------------------------------------------------------------------
    data_out(DOWN) <= data_in(LOCAL) when table(LOCAL)(DOWN) = '1' else
                     data_in(EAST) when table(EAST)(DOWN) = '1' else
                     data_in(SOUTH) when table(SOUTH)(DOWN) = '1' else
                     data_in(WEST) when table(WEST)(DOWN) = '1' else
                     data_in(NORTH) when table(NORTH)(DOWN) = '1' else
                     data_in(UP); --when table(UP)(DOWN) = '1'
                    
    control_out(DOWN)(EOP) <= control_in(EAST)(EOP) when table(LOCAL)(DOWN) = '1' else
                     control_in(EAST)(EOP) when table(EAST)(DOWN) = '1' else
                     control_in(SOUTH)(EOP) when table(SOUTH)(DOWN) = '1' else
                     control_in(WEST)(EOP) when table(WEST)(DOWN) = '1' else
                     control_in(NORTH)(EOP) when table(NORTH)(DOWN) = '1' else
                     control_in(UP)(EOP) when table(UP)(DOWN) = '1' else
                     '0';
    
    control_out(DOWN)(RX) <= control_in(LOCAL)(TX) when table(LOCAL)(DOWN) = '1' else
                     control_in(EAST)(TX) when table(EAST)(DOWN) = '1' else
                     control_in(SOUTH)(TX) when table(SOUTH)(DOWN) = '1' else
                     control_in(WEST)(TX) when table(WEST)(DOWN) = '1' else
                     control_in(NORTH)(TX) when table(NORTH)(DOWN) = '1' else
                     control_in(UP)(TX) when table(UP)(DOWN) = '1' else
                     '0';
    
    control_out(DOWN)(STALL_GO) <= control_in(LOCAL)(STALL_GO) when table(DOWN)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when table(DOWN)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when table(DOWN)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when table(DOWN)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when table(DOWN)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when table(DOWN)(UP) = '1' else
                     '0';
--------------------------------------------------------------------------------------

end architecture;
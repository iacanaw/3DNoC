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
        routingTable:   in Array1D_ports(0 to PORTS-1);
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
    data_out(LOCAL) <= data_in(EAST) when routingTable(EAST)(LOCAL) = '1' else
                    data_in(SOUTH) when routingTable(SOUTH)(LOCAL) = '1' else
                    data_in(WEST) when routingTable(WEST)(LOCAL) = '1' else
                    data_in(NORTH) when routingTable(NORTH)(LOCAL) = '1' else
                    data_in(UP) when routingTable(UP)(LOCAL) = '1' else
                    data_in(DOWN); --when routingTable(DOWN)(LOCAL) = '1'
                    
    control_out(LOCAL)(EOP) <= control_in(EAST)(EOP) when routingTable(EAST)(LOCAL) = '1' else
                     control_in(SOUTH)(EOP) when routingTable(SOUTH)(LOCAL) = '1' else
                     control_in(WEST)(EOP) when routingTable(WEST)(LOCAL) = '1' else
                     control_in(NORTH)(EOP) when routingTable(NORTH)(LOCAL) = '1' else
                     control_in(UP)(EOP) when routingTable(UP)(LOCAL) = '1' else
                     control_in(DOWN)(EOP) when routingTable(DOWN)(LOCAL) = '1' else
                     '0';
    
    control_out(LOCAL)(RX) <= control_in(EAST)(TX) when routingTable(EAST)(LOCAL) = '1' else
                     control_in(SOUTH)(TX) when routingTable(SOUTH)(LOCAL) = '1' else
                     control_in(WEST)(TX) when routingTable(WEST)(LOCAL) = '1' else
                     control_in(NORTH)(TX) when routingTable(NORTH)(LOCAL) = '1' else
                     control_in(UP)(TX) when routingTable(UP)(LOCAL) = '1' else
                     control_in(DOWN)(TX) when routingTable(DOWN)(LOCAL) = '1' else
                     '0';
    
    control_out(LOCAL)(STALL_GO) <= control_in(EAST)(STALL_GO) when routingTable(LOCAL)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when routingTable(LOCAL)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when routingTable(LOCAL)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when routingTable(LOCAL)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when routingTable(LOCAL)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when routingTable(LOCAL)(DOWN) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- EAST PORT
--------------------------------------------------------------------------------------
    data_out(EAST) <= data_in(SOUTH) when routingTable(SOUTH)(EAST) = '1' else
                     data_in(WEST) when routingTable(WEST)(EAST) = '1' else
                     data_in(NORTH) when routingTable(NORTH)(EAST) = '1' else
                     data_in(UP) when routingTable(UP)(EAST) = '1' else
                     data_in(DOWN) when routingTable(DOWN)(EAST) = '1' else
                     data_in(LOCAL); --when routingTable(LOCAL)(EAST) = '1'
                    
    control_out(EAST)(EOP) <= control_in(SOUTH)(EOP) when routingTable(SOUTH)(EAST) = '1' else
                     control_in(WEST)(EOP) when routingTable(WEST)(EAST) = '1' else
                     control_in(NORTH)(EOP) when routingTable(NORTH)(EAST) = '1' else
                     control_in(UP)(EOP) when routingTable(UP)(EAST) = '1' else
                     control_in(DOWN)(EOP) when routingTable(DOWN)(EAST) = '1' else
                     control_in(LOCAL)(EOP) when routingTable(LOCAL)(EAST) = '1' else
                     '0';
    
    control_out(EAST)(RX) <= control_in(SOUTH)(TX) when routingTable(SOUTH)(EAST) = '1' else
                     control_in(WEST)(TX) when routingTable(WEST)(EAST) = '1' else
                     control_in(NORTH)(TX) when routingTable(NORTH)(EAST) = '1' else
                     control_in(UP)(TX) when routingTable(UP)(EAST) = '1' else
                     control_in(DOWN)(TX) when routingTable(DOWN)(EAST) = '1' else
                     control_in(LOCAL)(TX) when routingTable(LOCAL)(EAST) = '1' else
                     '0';
    
    control_out(EAST)(STALL_GO) <= control_in(SOUTH)(STALL_GO) when routingTable(EAST)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when routingTable(EAST)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when routingTable(EAST)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when routingTable(EAST)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when routingTable(EAST)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when routingTable(EAST)(LOCAL) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- SOUTH PORT
--------------------------------------------------------------------------------------
    data_out(SOUTH) <= data_in(WEST) when routingTable(WEST)(SOUTH) = '1' else
                     data_in(NORTH) when routingTable(NORTH)(SOUTH) = '1' else
                     data_in(UP) when routingTable(UP)(SOUTH) = '1' else
                     data_in(DOWN) when routingTable(DOWN)(SOUTH) = '1' else
                     data_in(LOCAL) when routingTable(LOCAL)(SOUTH) = '1' else
                     data_in(EAST); --when routingTable(EAST)(SOUTH) = '1'
                    
    control_out(SOUTH)(EOP) <= control_in(WEST)(EOP) when routingTable(WEST)(SOUTH) = '1' else
                     control_in(NORTH)(EOP) when routingTable(NORTH)(SOUTH) = '1' else
                     control_in(UP)(EOP) when routingTable(UP)(SOUTH) = '1' else
                     control_in(DOWN)(EOP) when routingTable(DOWN)(SOUTH) = '1' else
                     control_in(LOCAL)(EOP) when routingTable(LOCAL)(SOUTH) = '1' else
                     control_in(EAST)(EOP) when routingTable(EAST)(SOUTH) = '1' else
                     '0';
    
    control_out(SOUTH)(RX) <= control_in(WEST)(TX) when routingTable(WEST)(SOUTH) = '1' else
                     control_in(NORTH)(TX) when routingTable(NORTH)(SOUTH) = '1' else
                     control_in(UP)(TX) when routingTable(UP)(SOUTH) = '1' else
                     control_in(DOWN)(TX) when routingTable(DOWN)(SOUTH) = '1' else
                     control_in(LOCAL)(TX) when routingTable(LOCAL)(SOUTH) = '1' else
                     control_in(EAST)(TX) when routingTable(EAST)(SOUTH) = '1' else
                     '0';
    
    control_out(SOUTH)(STALL_GO) <= control_in(WEST)(STALL_GO) when routingTable(SOUTH)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when routingTable(SOUTH)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when routingTable(SOUTH)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when routingTable(SOUTH)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when routingTable(SOUTH)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when routingTable(SOUTH)(EAST) = '1' else
                     '0';      
--------------------------------------------------------------------------------------
-- WEST PORT
--------------------------------------------------------------------------------------
    data_out(WEST) <= data_in(NORTH) when routingTable(NORTH)(WEST) = '1' else
                     data_in(UP) when routingTable(UP)(WEST) = '1' else
                     data_in(DOWN) when routingTable(DOWN)(WEST) = '1' else
                     data_in(LOCAL) when routingTable(LOCAL)(WEST) = '1' else
                     data_in(EAST) when routingTable(EAST)(WEST) = '1' else
                     data_in(SOUTH); --when routingTable(SOUTH)(WEST) = '1'
                    
    control_out(WEST)(EOP) <= control_in(NORTH)(EOP) when routingTable(NORTH)(WEST) = '1' else
                     control_in(UP)(EOP) when routingTable(UP)(WEST) = '1' else
                     control_in(DOWN)(EOP) when routingTable(DOWN)(WEST) = '1' else
                     control_in(LOCAL)(EOP) when routingTable(LOCAL)(WEST) = '1' else
                     control_in(EAST)(EOP) when routingTable(EAST)(WEST) = '1' else
                     control_in(SOUTH)(EOP) when routingTable(SOUTH)(WEST) = '1' else
                     '0';
    
    control_out(WEST)(RX) <= control_in(NORTH)(TX) when routingTable(NORTH)(WEST) = '1' else
                     control_in(UP)(TX) when routingTable(UP)(WEST) = '1' else
                     control_in(DOWN)(TX) when routingTable(DOWN)(WEST) = '1' else
                     control_in(LOCAL)(TX) when routingTable(LOCAL)(WEST) = '1' else
                     control_in(EAST)(TX) when routingTable(EAST)(WEST) = '1' else
                     control_in(SOUTH)(TX) when routingTable(SOUTH)(WEST) = '1' else
                     '0';
    
    control_out(WEST)(STALL_GO) <= control_in(NORTH)(STALL_GO) when routingTable(WEST)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when routingTable(WEST)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when routingTable(WEST)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when routingTable(WEST)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when routingTable(WEST)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when routingTable(WEST)(SOUTH) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- NORTH PORT
--------------------------------------------------------------------------------------
    data_out(NORTH) <= data_in(UP) when routingTable(UP)(NORTH) = '1' else
                     data_in(DOWN) when routingTable(DOWN)(NORTH) = '1' else
                     data_in(LOCAL) when routingTable(LOCAL)(NORTH) = '1' else
                     data_in(EAST) when routingTable(EAST)(NORTH) = '1' else
                     data_in(SOUTH) when routingTable(SOUTH)(NORTH) = '1' else
                     data_in(WEST); --when routingTable(WEST)(NORTH) = '1'
                    
    control_out(NORTH)(EOP) <= control_in(UP)(EOP) when routingTable(UP)(NORTH) = '1' else
                     control_in(DOWN)(EOP) when routingTable(DOWN)(NORTH) = '1' else
                     control_in(LOCAL)(EOP) when routingTable(LOCAL)(NORTH) = '1' else
                     control_in(EAST)(EOP) when routingTable(EAST)(NORTH) = '1' else
                     control_in(SOUTH)(EOP) when routingTable(SOUTH)(NORTH) = '1' else
                     control_in(WEST)(EOP) when routingTable(WEST)(NORTH) = '1' else
                     '0';
    
    control_out(NORTH)(RX) <= control_in(UP)(TX) when routingTable(UP)(NORTH) = '1' else
                     control_in(DOWN)(TX) when routingTable(DOWN)(NORTH) = '1' else
                     control_in(LOCAL)(TX) when routingTable(LOCAL)(NORTH) = '1' else
                     control_in(EAST)(TX) when routingTable(EAST)(NORTH) = '1' else
                     control_in(SOUTH)(TX) when routingTable(SOUTH)(NORTH) = '1' else
                     control_in(WEST)(TX) when routingTable(WEST)(NORTH) = '1' else
                     '0';
    
    control_out(NORTH)(STALL_GO) <= control_in(UP)(STALL_GO) when routingTable(NORTH)(UP) = '1' else
                     control_in(DOWN)(STALL_GO) when routingTable(NORTH)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when routingTable(NORTH)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when routingTable(NORTH)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when routingTable(NORTH)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when routingTable(NORTH)(WEST) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- UP PORT
--------------------------------------------------------------------------------------
    data_out(UP) <= data_in(DOWN) when routingTable(DOWN)(UP) = '1' else
                     data_in(LOCAL) when routingTable(LOCAL)(UP) = '1' else
                     data_in(EAST) when routingTable(EAST)(UP) = '1' else
                     data_in(SOUTH) when routingTable(SOUTH)(UP) = '1' else
                     data_in(WEST) when routingTable(WEST)(UP) = '1' else
                     data_in(NORTH); --when routingTable(NORTH)(UP) = '1'
                    
    control_out(UP)(EOP) <= control_in(DOWN)(EOP) when routingTable(DOWN)(UP) = '1' else
                     control_in(LOCAL)(EOP) when routingTable(LOCAL)(UP) = '1' else
                     control_in(EAST)(EOP) when routingTable(EAST)(UP) = '1' else
                     control_in(SOUTH)(EOP) when routingTable(SOUTH)(UP) = '1' else
                     control_in(WEST)(EOP) when routingTable(WEST)(UP) = '1' else
                     control_in(NORTH)(EOP) when routingTable(NORTH)(UP) = '1' else
                     '0';
    
    control_out(UP)(RX) <= control_in(DOWN)(TX) when routingTable(DOWN)(UP) = '1' else
                     control_in(LOCAL)(TX) when routingTable(LOCAL)(UP) = '1' else
                     control_in(EAST)(TX) when routingTable(EAST)(UP) = '1' else
                     control_in(SOUTH)(TX) when routingTable(SOUTH)(UP) = '1' else
                     control_in(WEST)(TX) when routingTable(WEST)(UP) = '1' else
                     control_in(NORTH)(TX) when routingTable(NORTH)(UP) = '1' else
                     '0';
    
    control_out(UP)(STALL_GO) <= control_in(DOWN)(STALL_GO) when routingTable(UP)(DOWN) = '1' else
                     control_in(LOCAL)(STALL_GO) when routingTable(UP)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when routingTable(UP)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when routingTable(UP)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when routingTable(UP)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when routingTable(UP)(NORTH) = '1' else
                     '0';
--------------------------------------------------------------------------------------
-- DOWN PORT
--------------------------------------------------------------------------------------
    data_out(DOWN) <= data_in(LOCAL) when routingTable(LOCAL)(DOWN) = '1' else
                     data_in(EAST) when routingTable(EAST)(DOWN) = '1' else
                     data_in(SOUTH) when routingTable(SOUTH)(DOWN) = '1' else
                     data_in(WEST) when routingTable(WEST)(DOWN) = '1' else
                     data_in(NORTH) when routingTable(NORTH)(DOWN) = '1' else
                     data_in(UP); --when routingTable(UP)(DOWN) = '1'
                    
    control_out(DOWN)(EOP) <= control_in(LOCAL)(EOP) when routingTable(LOCAL)(DOWN) = '1' else
                     control_in(EAST)(EOP) when routingTable(EAST)(DOWN) = '1' else
                     control_in(SOUTH)(EOP) when routingTable(SOUTH)(DOWN) = '1' else
                     control_in(WEST)(EOP) when routingTable(WEST)(DOWN) = '1' else
                     control_in(NORTH)(EOP) when routingTable(NORTH)(DOWN) = '1' else
                     control_in(UP)(EOP) when routingTable(UP)(DOWN) = '1' else
                     '0';
    
    control_out(DOWN)(RX) <= control_in(LOCAL)(TX) when routingTable(LOCAL)(DOWN) = '1' else
                     control_in(EAST)(TX) when routingTable(EAST)(DOWN) = '1' else
                     control_in(SOUTH)(TX) when routingTable(SOUTH)(DOWN) = '1' else
                     control_in(WEST)(TX) when routingTable(WEST)(DOWN) = '1' else
                     control_in(NORTH)(TX) when routingTable(NORTH)(DOWN) = '1' else
                     control_in(UP)(TX) when routingTable(UP)(DOWN) = '1' else
                     '0';
    
    control_out(DOWN)(STALL_GO) <= control_in(LOCAL)(STALL_GO) when routingTable(DOWN)(LOCAL) = '1' else
                     control_in(EAST)(STALL_GO) when routingTable(DOWN)(EAST) = '1' else
                     control_in(SOUTH)(STALL_GO) when routingTable(DOWN)(SOUTH) = '1' else
                     control_in(WEST)(STALL_GO) when routingTable(DOWN)(WEST) = '1' else
                     control_in(NORTH)(STALL_GO) when routingTable(DOWN)(NORTH) = '1' else
                     control_in(UP)(STALL_GO) when routingTable(DOWN)(UP) = '1' else
                     '0';
--------------------------------------------------------------------------------------

end architecture;
--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Router Unit                                                       --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Apr 8th, 2015                                       --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;

entity Router is
generic(address: std_logic_vector(DATA_WIDTH-1 downto 0));
    port(
        clk           : in std_logic;
        rst           : in std_logic;
        
        -- Data and control inputs
        data_in       : in Array1D_data(0 to PORTS-1);
        control_in    : in Array1D_control(0 to PORTS-1);
        -- Data and control outputs
        data_out      : out Array1D_data(0 to PORTS-1);
        control_out   : out Array1D_control(0 to PORTS-1)
    );
end Router;

architecture Router of Router is


begin
    
    -- Direct routing for test
    data_out(EAST)  <= data_in(WEST);
    data_out(WEST)  <= data_in(EAST);
    data_out(DOWN)  <= data_in(UP);
    data_out(UP)    <= data_in(DOWN);
    data_out(SOUTH) <= data_in(NORTH);
    data_out(NORTH) <= data_in(SOUTH);

end architecture;
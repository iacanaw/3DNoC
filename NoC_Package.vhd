--------------------------------------------------------------------------------------
-- DESIGN UNIT  : NoC Package                                                       --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Apr 8th, 2015                                       --
--------------------------------------------------------------------------------------
-- TEMP SECTIONS ARE INCOMPLETE
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package NoC_Package is

    -- Constants
    
    -- Dimension X and Y need to be greater than 1, for 2D NoCs use Z = 1
    -- X grows from left to right, Y grows from front to back, Z grows from bottom to top
    constant DIM_X    : integer := 9;
    constant DIM_Y    : integer := 10;
    constant DIM_Z    : integer := 9;
    
    constant DATA_WIDTH     : integer := 16;
    constant CONTROL_WIDTH  : integer := 3;
    
    constant EOP        : integer := 0;
    constant RX         : integer := 1;
    constant TX         : integer := 1;
    constant STALL_GO   : integer := 2;

    constant LOCAL      : integer := 0;
    constant EAST       : integer := 1;
    constant SOUTH      : integer := 2;
    constant WEST       : integer := 3;
    constant NORTH      : integer := 4;
    constant UP         : integer := 5;
    constant DOWN       : integer := 6;
    
    constant BUFFER_DEPTH : integer := 8; -- Buffer depth must be greater than 1 and a power of 2
    
    constant PORTS : integer := 7;
    
    -- Types of arrays
    
    -- Types used at Router and SwitchControl interface.
    -- Each element indicates a port (LOCAL, EAST, WEST, NORTH, SOUTH, UP or DOWN).
    type Array1D_data is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type Array1D_control is array (natural range <>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);
    type Array1D_ports is array (natural range<>) of std_logic_vector(PORTS-1 downto 0);
    
    -- Types used at NoC interface. 
    -- In case of 3D NoCs, each element (x,y,z) indicates a router local port. 
    -- In case of 2D NoCs z=1. Each element (x,y,1) indicates a router local port. 
    type Array3D_data is array (natural range <>, natural range <>, natural range<>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type Array3D_control is array (natural range <>, natural range <>, natural range<>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);
    
    -- Types used to interconnect routers when generating a NoC instance (NoC.vhd).
    type Array4D_data is array (natural range <>, natural range <>, natural range <>, natural range<>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type array4D_control is array (natural range <>, natural range <>, natural range <>, natural range<>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);

    type DataBuff is array(0 to BUFFER_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    function Log2(temp : natural) return natural;
    function Address(x,y,z : natural)return std_logic_vector;
    function GetX(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
    function GetY(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
    function GetZ(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
    function XYZ(target,current: std_logic_vector(DATA_WIDTH-1 downto 0)) return integer;
    
end package;

package body NoC_Package is
    
    -- Function returns the logarithm of 2 from the argument.
    function Log2(temp : natural) return natural is
        variable result : natural;
    begin
        for i in 0 to integer'high loop
            if (2**i >= temp) then
                return i;
            end if;
        end loop;
        return 0;
    end function Log2;
    
    -- Function returns the address of a router in flit format.
    function Address(x,y,z : natural)return std_logic_vector is
        variable address : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable binX : std_logic_vector(Log2(DIM_X)-1 downto 0);
        variable binY : std_logic_vector(Log2(DIM_Y)-1 downto 0);
        variable binZ : std_logic_vector(Log2(DIM_Z)-1 downto 0);
        variable zeros2D: std_logic_vector(15-(Log2(DIM_X)+Log2(DIM_Y)) downto 0);
        variable zeros3D: std_logic_vector(15-(Log2(DIM_X)+Log2(DIM_Y)+Log2(DIM_Z)) downto 0);
    begin
        if(DIM_Z = 1) then -- NoC 2D
            binX := std_logic_vector(to_unsigned(x,Log2(DIM_X)));
            binY := std_logic_vector(to_unsigned(y,Log2(DIM_Y)));
            zeros2D := (others=>'0');
            address := zeros2D & binX & binY;
        else  -- NoC 3D
            binX := std_logic_vector(to_unsigned(x,Log2(DIM_X)));
            binY := std_logic_vector(to_unsigned(y,Log2(DIM_Y)));
            binZ := std_logic_vector(to_unsigned(z,Log2(DIM_Z)));
            zeros3D := (others=>'0');
            address := zeros3D & binX & binY & binZ;
        end if;
        return address;

        return address;
    end function Address;

    -- Function returns the coordinate X of an address.
    function GetX(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
        variable Xaddress : natural;
    begin
        Xaddress := TO_INTEGER(UNSIGNED(address(Log2(DIM_Z)+Log2(DIM_Y)+Log2(DIM_X)-1 downto Log2(DIM_Z)+Log2(DIM_Y))));
        return Xaddress;
    end function GetX;
    
    -- Function returns the coordinate Y of an address.
    function GetY(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
        variable Yaddress : natural;
    begin
        Yaddress := TO_INTEGER(UNSIGNED(address(Log2(DIM_Y)+Log2(DIM_Z)-1 downto Log2(DIM_Z))));
        return Yaddress;
    end function GetY;

    -- Function returns the coordinate Z of an address.
    function GetZ(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
        variable Zaddress : natural;
    begin
        if (DIM_Z > 1) then
            Zaddress := TO_INTEGER(UNSIGNED(address(Log2(DIM_Z)-1 downto 0)));
        else
            Zaddress := 0;
        end if;
        return Zaddress;
    end function GetZ;
    
    -- Function returns the port that should be used to send the packet according the XYZ algorithm.
    function XYZ(target,current: std_logic_vector(DATA_WIDTH-1 downto 0)) return integer is
        variable outputPort : integer range 0 to PORTS-1;
        variable currentX   : integer range 0 to DIM_X-1 := GetX(current);
        variable currentY   : integer range 0 to DIM_Y-1 := GetY(current);
        variable currentZ   : integer range 0 to DIM_Z-1 := GetZ(current);
        variable tarGetX    : integer range 0 to DIM_X-1 := GetX(target);
        variable tarGetY    : integer range 0 to DIM_Y-1 := GetY(target);
        variable tarGetZ    : integer range 0 to DIM_Z-1 := GetZ(target);
    begin
        if(currentX = tarGetX) then
        
            if(currentY = tarGetY) then
            
                if(currentZ = tarGetZ) then
                    outputPort := LOCAL;
                elsif(currentZ < tarGetZ) then
                    outputPort := UP;
                else --currentZ > tarGetZ
                    outputPort := DOWN;
                end if;
                
            elsif (currentY < tarGetY) then
                outputPort := NORTH;
            else --currentY > tarGetY
                outputPort := SOUTH;
            end if;
            
        elsif (currentX < tarGetX) then
            outputPort := EAST;
        else --currentX > tarGetX
            outputPort := WEST;
        end if;
        
        return outputPort;
        
    end XYZ;

end NoC_Package;
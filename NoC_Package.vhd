--------------------------------------------------------------------------------------
-- DESIGN UNIT  : NoC Package                                                       --
-- DESCRIPTION  : 													     		   	--
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Apr 8th, 2015										--
--------------------------------------------------------------------------------------
-- TEMP SECTIONS ARE INCOMPLETE
library ieee;
use ieee.std_Logic_1164.all;
use ieee.numeric_std.all; -- Used in getAddress() function
use ieee.std_logic_unsigned.all; -- Used in getX,Y,Z() functions

package NoC_Package is

	-- Constants
	
	-- Dimension X and Y need to be greater than 1, for two-dimensional NoCs use Z = 1
	-- X grows from left to right, Y grows from front to back, Z grows from bottom to top
	constant DIM_X	: integer := 9;	
	constant DIM_Y	: integer := 10; 
	constant DIM_Z	: integer := 9;
	
	constant DATA_WIDTH 	: integer := 16;
	constant CONTROL_WIDTH	: integer := 3;
	
	constant EOP 		: integer := 0;
	constant RX			: integer := 1;
	constant TX			: integer := 1;
	constant STALL_GO 	: integer := 2;

	constant LOCAL  : integer := 0;
	constant EAST	: integer := 1;
	constant SOUTH  : integer := 2;
	constant WEST 	: integer := 3;
	constant NORTH	: integer := 4;
	constant UP		: integer := 5;
	constant DOWN	: integer := 6;
	
	constant BUFFER_DEPTH : integer := 8; -- Buffer depth must be greater than 1 and a power of 2
	
	constant NPORT : integer := 7;
	
	-- Types of arrays
	
	-- Array used to route the gate for each node
	type array1D_data is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
	type array1D_control is array (natural range <>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);
	type array1D is array (natural range<>) of std_logic;
	type array1D_ports is array (natural range<>) of std_logic_vector(NPORT-1 downto 0);
	
	-- Array used to route the node (X,Y,Z)
	type array3D_data is array (natural range <>, natural range <>, natural range<>) of std_logic_vector(DATA_WIDTH-1 downto 0);
	type array3D_control is array (natural range <>, natural range <>, natural range<>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);
	
	-- Array used to route the node and node gate  (X,Y,Z,Gate)
	type array4D_data is array (natural range <>, natural range <>, natural range <>, natural range<>) of std_logic_vector(DATA_WIDTH-1 downto 0);
	type array4D_control is array (natural range <>, natural range <>, natural range <>, natural range<>) of std_logic_vector(CONTROL_WIDTH-1 downto 0);

	type data_buff is array(0 to BUFFER_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	
	function log2(temp : natural) return natural;
	function getAddress(x,y,z : natural)return std_logic_vector;
	function getX(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
	function getY(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
	function getZ(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural;
	function XYZ(target,current: std_logic_vector(DATA_WIDTH-1 downto 0)) return integer;
	
end package;

package body NoC_Package is
	
	-- Function returns the logaritm of 2 from the argument
	function log2(temp : natural) return natural is
		variable result : natural;
	begin
		for i in 0 to integer'high loop
			if (2**i >= temp) then
				return i;
			end if;
		end loop;
		return 0;
	end function log2;
	
	function getAddress(x,y,z : natural)return std_logic_vector is
		variable address : std_logic_vector(DATA_WIDTH-1 downto 0);
		variable binX : std_logic_vector(log2(DIM_X)-1 downto 0);
		variable binY : std_logic_vector(log2(DIM_Y)-1 downto 0);
		variable binZ : std_logic_vector(log2(DIM_Z)-1 downto 0);
		variable zeros2D: std_logic_vector(15-(log2(DIM_X)+log2(DIM_Y)) downto 0);
		variable zeros3D: std_logic_vector(15-(log2(DIM_X)+log2(DIM_Y)+log2(DIM_Z)) downto 0);
	begin
		if(DIM_Z = 1) then -- NoC 2D
			binX := std_logic_vector(to_unsigned(x,log2(DIM_X)));
			binY := std_logic_vector(to_unsigned(y,log2(DIM_Y)));
			zeros2D := (others=>'0');
			address := binX & binY & zeros2D;
		else  -- NoC 3D
			binX := std_logic_vector(to_unsigned(x,log2(DIM_X)));
			binY := std_logic_vector(to_unsigned(y,log2(DIM_Y)));
			binZ := std_logic_vector(to_unsigned(z,log2(DIM_Z)));
			zeros3D := (others=>'0');
			address := binX & binY & binZ & zeros3D;
		end if;
		return address;

		return address;
	end function getAddress;

	function getX(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
		variable Xaddress : natural;
	begin
		
		Xaddress := CONV_INTEGER(address(DATA_WIDTH-1 downto DATA_WIDTH-1-log2(DIM_X)));
		--Xaddress := TO_INTEGER(UNSIGNED(address(DATA_WIDTH-1 downto DATA_WIDTH-1-log2(DIM_X)));
		
		return Xaddress;
	end function getX;
	
	function getY(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
		variable Yaddress : natural;
	begin
		
		Yaddress := CONV_INTEGER(address(DATA_WIDTH-1-log2(DIM_X)-1 downto DATA_WIDTH-1-log2(DIM_X)-1-log2(DIM_Y)));
		
		return Yaddress;
	end function getY;

	function getZ(address : std_logic_vector(DATA_WIDTH-1 downto 0)) return natural is
		variable Zaddress : natural;
	begin
	
		if (DIM_Z > 1) then
			Zaddress := CONV_INTEGER(address(DATA_WIDTH-1-log2(DIM_X)-1-log2(DIM_Y)-1 downto DATA_WIDTH-1-log2(DIM_X)-1-log2(DIM_Y)-1-log2(DIM_Z)));
		else
			Zaddress := 0;
		end if;
		
		return Zaddress;
	end function getZ;
	
	function XYZ(target,current: std_logic_vector(DATA_WIDTH-1 downto 0)) return integer is
		variable outputPort: integer range 0 to NPORT-1;
		variable currentX : integer range 0 to DIM_X-1 := getX(current);
		variable currentY : integer range 0 to DIM_Y-1 := getY(current);
		variable currentZ : integer range 0 to DIM_Z-1 := getZ(current);
		variable targetX : integer range 0 to DIM_X-1 := getX(target);
		variable targetY : integer range 0 to DIM_Y-1 := getY(target);
		variable targetZ : integer range 0 to DIM_Z-1 := getZ(target);
	begin
		if(currentX = targetX) then
		
			if(currentY = targetY) then
			
				if(currentZ = targetZ) then
					outputPort := LOCAL;
				elsif(currentZ < targetZ) then
					outputPort := UP;
				else --currentZ > targetZ
					outputPort := DOWN;
				end if;
				
			elsif (currentY < targetY) then
				outputPort := SOUTH;
			else --currentY > targetY
				outputPort := NORTH;
			end if;
			
		elsif (currentX < targetX) then
			outputPort := WEST;
		else --currentX > targetX
			outputPort := EAST;
		end if;
		
		return outputPort;
		
	end XYZ;
	
end NoC_Package;
--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Switch Control                                                    --
-- DESCRIPTION  : 											     				   	--
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Jun 16th, 2015										--
--------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use ieee.std_logic_unsigned.all; -- if routingReq /= 0 then


entity Switch_Control is
	generic(
		address : std_logic_vector(DATA_WIDTH-1 downto 0)		
	);
	port(
		clk			:	in	std_logic;
		rst			:	in	std_logic;
		
		routingReq  :	in  std_logic_vector( NPORT-1 downto 0);
		routingAck  :	out std_logic_vector( NPORT-1 downto 0);
		data        :	in  array1D_data(0 to NPORT-1);
		sending     :	in  std_logic_vector( NPORT-1 downto 0);    
		table       :	out array1D_ports(0 to NPORT-1)
	);
end Switch_Control;

architecture Switch_Control of Switch_Control is

	
	type state is (S0,S1,S2);
	signal currentState: state;
	
	signal freePorts: std_logic_vector( NPORT-1 downto 0);
	signal routingTable: array1D_ports(0 to NPORT-1); -- routingTable(inPort)(outPort)
	signal selectedInPort: integer range 0 to NPORT-1;
	signal nextInPort: integer range 0 to NPORT-1;
	
	signal routedOutPort: integer range 0 to NPORT-1;
begin
	
	process(selectedInPort,routingReq)
	begin
		case selectedInPort is
			when LOCAL =>
				if routingReq(EAST) = '1' then nextInPort <= EAST;
				elsif routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				elsif routingReq(WEST) = '1' then nextInPort <= WEST;
				elsif routingReq(NORTH) = '1' then nextInPort <= NORTH;
				elsif routingReq(UP) = '1' then nextInPort <= UP;
				elsif routingReq(DOWN) = '1' then nextInPort <= DOWN;
				else nextInPort <= LOCAL;
				end if;
			when EAST =>
				if routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				elsif routingReq(WEST) = '1' then nextInPort <= WEST;
				elsif routingReq(NORTH) = '1' then nextInPort <= NORTH;
				elsif routingReq(UP) = '1' then nextInPort <= UP;
				elsif routingReq(DOWN) = '1' then nextInPort <= DOWN;
				elsif routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				else nextInPort <= EAST;
				end if;
			when SOUTH =>
				if routingReq(WEST) = '1' then nextInPort <= WEST;
				elsif routingReq(NORTH) = '1' then nextInPort <= NORTH;
				elsif routingReq(UP) = '1' then nextInPort <= UP;
				elsif routingReq(DOWN) = '1' then nextInPort <= DOWN;
				elsif routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				elsif routingReq(EAST) = '1' then nextInPort <= EAST;
				else nextInPort <= SOUTH;
				end if;
			when WEST =>
				if routingReq(NORTH) = '1' then nextInPort <= NORTH;
				elsif routingReq(UP) = '1' then nextInPort <= UP;
				elsif routingReq(DOWN) = '1' then nextInPort <= DOWN;
				elsif routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				elsif routingReq(EAST) = '1' then nextInPort <= EAST;
				elsif routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				else nextInPort <= WEST;
				end if;
			when NORTH =>
				if routingReq(UP) = '1' then nextInPort <= UP;
				elsif routingReq(DOWN) = '1' then nextInPort <= DOWN;
				elsif routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				elsif routingReq(EAST) = '1' then nextInPort <= EAST;
				elsif routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				elsif routingReq(WEST) = '1' then nextInPort <= WEST;
				else nextInPort <= NORTH;
				end if;
			when UP =>
				if routingReq(DOWN) = '1' then nextInPort <= DOWN;
				elsif routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				elsif routingReq(EAST) = '1' then nextInPort <= EAST;
				elsif routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				elsif routingReq(WEST) = '1' then nextInPort <= WEST;
				elsif routingReq(NORTH) = '1' then nextInPort <= NORTH;
				else nextInPort <= UP;
				end if;
			when DOWN =>
				if routingReq(LOCAL) = '1' then nextInPort <= LOCAL;
				elsif routingReq(EAST) = '1' then nextInPort <= EAST;
				elsif routingReq(SOUTH) = '1' then nextInPort <= SOUTH;
				elsif routingReq(WEST) = '1' then nextInPort <= WEST;
				elsif routingReq(NORTH) = '1' then nextInPort <= NORTH;
				elsif routingReq(UP) = '1' then nextInPort <= UP;
				else nextInPort <= DOWN;
				end if;
			when others =>
				nextInPort <= LOCAL;
		end case;
	end process;
	
	routedOutPort <= XYZ(data(selectedInPort),address);
	
	process(clk, rst)
	begin
		if rst = '1' then
            routingAck <= (others => '0');                  
            routingTable <= (others=>(others=>'0'));            
            currentState <= S0;
            
        elsif rising_edge(clk) then
            case currentState is
                -- Takes the port selected by the PriorityEncoder function
                when S0 =>
					-- Select a port
					selectedInPort <= nextInPort;
                    -- Wait for a port request.
                    if routingReq /= 0 then
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;                    
                    
                    -- Updates the routing table.
                    for i in 0 to NPORT-1 loop
                        if sending(i) = '0' then
                            routingTable(i) <= (others=>'0');
                        end if;
                    end loop;                      
                                    
                -- Sets the routing table if the routed output port is available
                when S1 =>    
                    if freePorts(routedOutPort) = '0' then  -- 0 = free;
                        routingTable(selectedInPort)(routedOutPort) <= '1';
                        routingAck(selectedInPort) <= '1';
                        currentState <= S2;
                    else
                        currentState <= S0;
                    end if;
                    
                -- Holds the routing acknowledgement active for one cycle
                when S2 =>
                    routingAck(selectedInPort) <= '0'; 
                    currentState <= S0;
                    
                when others =>
                    currentState <= S0;
                
            end case;  
        end if;

	end process;
	
	table <= routingTable;
	
	FREE_PORTS: for i in 0 to NPORT-1 generate
        freePorts(i) <= (routingTable(LOCAL)(i)) or (routingTable(EAST)(i)) or (routingTable(SOUTH)(i)) or (routingTable(WEST)(i)) or (routingTable(NORTH)(i)) or (routingTable(UP)(i)) or (routingTable(DOWN)(i));
    end generate;
	
end Switch_Control;
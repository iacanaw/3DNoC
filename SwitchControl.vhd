--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Switch Control                                                    --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Jun 16th, 2015                                      --
--------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use ieee.numeric_std.all;


entity SwitchControl is
    generic(
        address : std_logic_vector(DATA_WIDTH-1 downto 0)        
    );
    port(
        clk         :    in    std_logic;
        rst         :    in    std_logic;
        
        routingReq  :    in  std_logic_vector( PORTS-1 downto 0);
        routingAck  :    out std_logic_vector( PORTS-1 downto 0);
        data        :    in  Array1D_data(0 to PORTS-1);
        sending     :    in  std_logic_vector( PORTS-1 downto 0);    
        table       :    out Array1D_ports(0 to PORTS-1)
    );
end SwitchControl;

architecture behavioral of SwitchControl is
   
    type state is (IDLE,SET_ROUTING_TABLE,ROUTING_ACK);
    signal currentState: state;
    
    signal freePorts: std_logic_vector( PORTS-1 downto 0);
    signal routingTable: Array1D_ports(0 to PORTS-1); -- routingTable(iPORTS)(outPort)
    signal selectedInPort: integer range 0 to PORTS-1;
    signal nextIPORTS: integer range 0 to PORTS-1;
    
    signal routedOutPort: integer range 0 to PORTS-1;
begin
    
    -------------------------------------------------------------
    -- Round robin policy to chose the input port to be served --
    -------------------------------------------------------------
    process(selectedInPort,routingReq)
    begin
        case selectedInPort is
            when LOCAL =>
                if routingReq(EAST) = '1'       then nextIPORTS <= EAST;
                elsif routingReq(SOUTH) = '1'   then nextIPORTS <= SOUTH;
                elsif routingReq(WEST) = '1'    then nextIPORTS <= WEST;
                elsif routingReq(NORTH) = '1'   then nextIPORTS <= NORTH;
                elsif routingReq(UP) = '1'      then nextIPORTS <= UP;
                elsif routingReq(DOWN) = '1'    then nextIPORTS <= DOWN;
                else nextIPORTS <= LOCAL;
                end if;
            when EAST =>
                if routingReq(SOUTH) = '1'      then nextIPORTS <= SOUTH;
                elsif routingReq(WEST) = '1'    then nextIPORTS <= WEST;
                elsif routingReq(NORTH) = '1'   then nextIPORTS <= NORTH;
                elsif routingReq(UP) = '1'      then nextIPORTS <= UP;
                elsif routingReq(DOWN) = '1'    then nextIPORTS <= DOWN;
                elsif routingReq(LOCAL) = '1'   then nextIPORTS <= LOCAL;
                else nextIPORTS <= EAST;
                end if;
            when SOUTH =>
                if routingReq(WEST) = '1'       then nextIPORTS <= WEST;
                elsif routingReq(NORTH) = '1'   then nextIPORTS <= NORTH;
                elsif routingReq(UP) = '1'      then nextIPORTS <= UP;
                elsif routingReq(DOWN) = '1'    then nextIPORTS <= DOWN;
                elsif routingReq(LOCAL) = '1'   then nextIPORTS <= LOCAL;
                elsif routingReq(EAST) = '1'    then nextIPORTS <= EAST;
                else nextIPORTS <= SOUTH;
                end if;
            when WEST =>
                if routingReq(NORTH) = '1'      then nextIPORTS <= NORTH;
                elsif routingReq(UP) = '1'      then nextIPORTS <= UP;
                elsif routingReq(DOWN) = '1'    then nextIPORTS <= DOWN;
                elsif routingReq(LOCAL) = '1'   then nextIPORTS <= LOCAL;
                elsif routingReq(EAST) = '1'    then nextIPORTS <= EAST;
                elsif routingReq(SOUTH) = '1'   then nextIPORTS <= SOUTH;
                else nextIPORTS <= WEST;
                end if;
            when NORTH =>
                if routingReq(UP) = '1'         then nextIPORTS <= UP;
                elsif routingReq(DOWN) = '1'    then nextIPORTS <= DOWN;
                elsif routingReq(LOCAL) = '1'   then nextIPORTS <= LOCAL;
                elsif routingReq(EAST) = '1'    then nextIPORTS <= EAST;
                elsif routingReq(SOUTH) = '1'   then nextIPORTS <= SOUTH;
                elsif routingReq(WEST) = '1'    then nextIPORTS <= WEST;
                else nextIPORTS <= NORTH;
                end if;
            when UP =>
                if routingReq(DOWN) = '1'       then nextIPORTS <= DOWN;
                elsif routingReq(LOCAL) = '1'   then nextIPORTS <= LOCAL;
                elsif routingReq(EAST) = '1'    then nextIPORTS <= EAST;
                elsif routingReq(SOUTH) = '1'   then nextIPORTS <= SOUTH;
                elsif routingReq(WEST) = '1'    then nextIPORTS <= WEST;
                elsif routingReq(NORTH) = '1'   then nextIPORTS <= NORTH;
                else nextIPORTS <= UP;
                end if;
            when DOWN =>
                if routingReq(LOCAL) = '1'      then nextIPORTS <= LOCAL;
                elsif routingReq(EAST) = '1'    then nextIPORTS <= EAST;
                elsif routingReq(SOUTH) = '1'   then nextIPORTS <= SOUTH;
                elsif routingReq(WEST) = '1'    then nextIPORTS <= WEST;
                elsif routingReq(NORTH) = '1'   then nextIPORTS <= NORTH;
                elsif routingReq(UP) = '1'      then nextIPORTS <= UP;
                else nextIPORTS <= DOWN;
                end if;
            when others =>
                nextIPORTS <= LOCAL;
        end case;
    end process;
    
    routedOutPort <= XYZ(data(selectedInPort),address);
    
    ------------------------------
    -- Routing table management --
    ------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            routingAck <= (others => '0');                  
            routingTable <= (others=>(others=>'0'));            
            currentState <= IDLE;
            
        elsif rising_edge(clk) then
            case currentState is
                -- Takes the port selected by the round robin
                when IDLE =>
                    selectedInPort <= nextIPORTS;
                    
                    -- Wait for a port request.
                    if SIGNED(routingReq) /= 0 then
                        currentState <= SET_ROUTING_TABLE;
                    else
                        currentState <= IDLE;
                    end if;                    
                    
                    -- Updates the routing table.
                    -- Frees the output ports released by the input ones 
                    for i in 0 to PORTS-1 loop
                        if sending(i) = '0' then
                            routingTable(i) <= (others=>'0');
                        end if;
                    end loop;                      
                                    
                -- Sets the routing table if the routed output port is available
                when SET_ROUTING_TABLE =>    
                    if freePorts(routedOutPort) = '0' then  -- 0 = free;
                        routingTable(selectedInPort)(routedOutPort) <= '1';
                        routingAck(selectedInPort) <= '1';
                        currentState <= ROUTING_ACK;
                    else
                        currentState <= IDLE;
                    end if;
                    
                -- Holds the routing acknowledgement active for one cycle
                when ROUTING_ACK =>
                    routingAck(selectedInPort) <= '0'; 
                    currentState <= IDLE;
                    
                when others =>
                    currentState <= IDLE;
                
            end case;   
        end if;

    end process;
    
    table <= routingTable;
    
    -- Update the current free output ports
    FREE_PORTS: for i in 0 to PORTS-1 generate
        freePorts(i) <= (routingTable(LOCAL)(i)) or (routingTable(EAST)(i)) or (routingTable(SOUTH)(i)) or (routingTable(WEST)(i)) or (routingTable(NORTH)(i)) or (routingTable(UP)(i)) or (routingTable(DOWN)(i));
    end generate;
    
end architecture;
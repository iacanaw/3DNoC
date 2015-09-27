--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Switch Control                                                    --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.2.2                                                             --
-- HISTORY      : Version 0.1 - Jun 16th, 2015                                      --
--              : Version 0.2.1 - Set 18th, 2015                                    --
--------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use ieee.numeric_std.all;


entity SwitchControl is
    generic(
        address : std_logic_vector(DATA_WIDTH-1 downto 0)     := x"0000"    
    );
    port(
        clk         :    in    std_logic;
        rst         :    in    std_logic;
        
        routingReq  :    in  std_logic_vector(PORTS-1 downto 0);    -- Routing request from input buffers
        routingAck  :    out std_logic_vector(PORTS-1 downto 0);    -- Routing acknowledgement to input buffers
        data        :    in  Array1D_data(0 to PORTS-1);    -- Each array element corresponds to a input buffer data_out
        sending     :    in  std_logic_vector(PORTS-1 downto 0);  -- Each array element signals an input buffer transmiting data
        table       :    out Array1D_3bits(0 to PORTS-1)    -- Routing table to be connected to crossbar
    );
end SwitchControl;

architecture behavioral of SwitchControl is
   
    type state is (IDLE,ROUTING_ACK);
    signal currentState: state;
    
    signal freePorts: std_logic_vector(PORTS-1 downto 0);   -- Status of all output ports (0 = free; 1 = busy)
    signal routingTable: Array1D_3bits(0 to PORTS-1); -- routingTable(inPort): value = outPort
    signal selectedInPort: integer range 0 to PORTS-1;  -- Input port selected to routing
    signal nextInPort: integer range 0 to PORTS-1;  -- Next input port to be selected to routing
    signal routedOutPort: integer range 0 to PORTS-1;   -- Output port selected by the routing algorithm
    
begin
    
    -------------------------------------------------------------
    -- Round robin policy to chose the input port to be served --
    -------------------------------------------------------------
    NoC2D : if(DIM_X>1 and DIM_Y>1 and DIM_Z=1) generate
        process(selectedInPort,routingReq)
        begin
            case selectedInPort is
                when LOCAL =>
                    if routingReq(EAST) = '1'       then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    else nextInPort <= LOCAL;
                    end if;
                when EAST =>
                    if routingReq(SOUTH) = '1'      then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    else nextInPort <= EAST;
                    end if;
                when SOUTH =>
                    if routingReq(WEST) = '1'       then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    else nextInPort <= SOUTH;
                    end if;
                when WEST =>
                    if routingReq(NORTH) = '1'      then nextInPort <= NORTH;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    else nextInPort <= WEST;
                    end if;
                when NORTH =>
                    if routingReq(LOCAL) = '1'      then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    else nextInPort <= NORTH;
                    end if;
                when others =>
                    nextInPort <= LOCAL;
            end case;
        end process;
        
        -- Routing
        routedOutPort <= XY(data(nextInPort),address);
        
    end generate;
    
    NoC3D : if(DIM_X>1 and DIM_Y>1 and DIM_Z>1) generate
        process(selectedInPort,routingReq)
        begin
            case selectedInPort is
                when LOCAL =>
                    if routingReq(EAST) = '1'       then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(UP) = '1'      then nextInPort <= UP;
                    elsif routingReq(DOWN) = '1'    then nextInPort <= DOWN;
                    else nextInPort <= LOCAL;
                    end if;
                when EAST =>
                    if routingReq(SOUTH) = '1'      then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(UP) = '1'      then nextInPort <= UP;
                    elsif routingReq(DOWN) = '1'    then nextInPort <= DOWN;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    else nextInPort <= EAST;
                    end if;
                when SOUTH =>
                    if routingReq(WEST) = '1'       then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(UP) = '1'      then nextInPort <= UP;
                    elsif routingReq(DOWN) = '1'    then nextInPort <= DOWN;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    else nextInPort <= SOUTH;
                    end if;
                when WEST =>
                    if routingReq(NORTH) = '1'      then nextInPort <= NORTH;
                    elsif routingReq(UP) = '1'      then nextInPort <= UP;
                    elsif routingReq(DOWN) = '1'    then nextInPort <= DOWN;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    else nextInPort <= WEST;
                    end if;
                when NORTH =>
                    if routingReq(UP) = '1'         then nextInPort <= UP;
                    elsif routingReq(DOWN) = '1'    then nextInPort <= DOWN;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    else nextInPort <= NORTH;
                    end if;
                when UP =>
                    if routingReq(DOWN) = '1'       then nextInPort <= DOWN;
                    elsif routingReq(LOCAL) = '1'   then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    else nextInPort <= UP;
                    end if;
                when DOWN =>
                    if routingReq(LOCAL) = '1'      then nextInPort <= LOCAL;
                    elsif routingReq(EAST) = '1'    then nextInPort <= EAST;
                    elsif routingReq(SOUTH) = '1'   then nextInPort <= SOUTH;
                    elsif routingReq(WEST) = '1'    then nextInPort <= WEST;
                    elsif routingReq(NORTH) = '1'   then nextInPort <= NORTH;
                    elsif routingReq(UP) = '1'      then nextInPort <= UP;
                    else nextInPort <= DOWN;
                    end if;
                when others =>
                    nextInPort <= LOCAL;
            end case;
            
            -- RR: for i in 0 to PORTS-1 generate
                -- if (routingReq(((selectedInPort+i rem 6)+1)-(selectedInPort/6)) = '1') then
                    -- nextInPort <= ((selectedInPort+i rem 6)+1)-(selectedInPort/6);
                -- else
                    -- nextInPort <= selectedInPort;
                -- end if;
            -- end generate;
            
         end process;

        -- Routing
        routedOutPort <= XYZ(data(nextInPort),address);
        
    end generate;
    
    
    
    ------------------------------
    -- Routing table management --
    ------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            routingAck <= (others=>'0');                  
            routingTable <= (others=>(others=>'1'));
            freePorts <= (others=>'0');
            currentState <= IDLE;
            
        elsif rising_edge(clk) then
            case currentState is
                
                -- Takes the port selected by the round robin
                when IDLE =>
                    selectedInPort <= nextInPort;
                    
                    -- Updates the routing table.
                    -- Frees the output ports released by the input ones 
                    for i in 0 to PORTS-1 loop
                        if sending(i) = '0' and TO_INTEGER(UNSIGNED(routingTable(i))) < PORTS then
                            routingTable(i) <= (others=>'1');
                            freePorts(TO_INTEGER(UNSIGNED(routingTable(i)))) <= '0';
                        end if;
                    end loop;   
                    
                    -- Wait for a port request.
                    -- Sets the routing table if the routed output port is available
                    if SIGNED(routingReq) /= 0 and freePorts(routedOutPort) = '0' then
                        routingTable(nextInPort) <= STD_LOGIC_VECTOR(TO_UNSIGNED(routedOutPort,3));
                        routingAck(nextInPort) <= '1';
                        freePorts(routedOutPort) <= '1'; -- 1 means that the port is busy.
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
    
end architecture;
--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Gate Buffer Testbench                                                      --
-- DESCRIPTION  :                                                                     --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - May 13th, 2015                                        --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use ieee.std_logic_unsigned.all; -- if routingReq /= 0 then

entity SwitchControl_tb is
end SwitchControl_tb;


architecture SwitchControl_tb of SwitchControl_tb is

    signal clk         : std_logic := '0';
    signal rst         : std_logic;
    
    signal routingReq  :    std_logic_vector(PORTS-1 downto 0) := (OTHERS=>'0');
    signal routingAck  :    std_logic_vector(PORTS-1 downto 0) ;
    signal data        :    array1D_data(0 to PORTS-1) := (OTHERS=>(OTHERS=>'0'));
    signal sending     :    std_logic_vector(PORTS-1 downto 0) := (OTHERS=>'0');    
    signal table       :    array1D_ports(0 to PORTS-1);
    signal flag        :    std_logic_vector(PORTS-1 downto 0) := (OTHERS=>'0');
begin
    
    clk <= not clk after 5 ns;
    
    rst <= '1', '0' after 7 ns;
   
    -- LOCAL 0 
    process 
    begin
        if flag(LOCAL) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            routingReq(LOCAL) <= '1';
            data(LOCAL) <= x"0655";
            flag(LOCAL) <= '1';
        end if;
        if(routingAck = "0000001") then 
            routingReq(LOCAL) <= '0';
            sending(LOCAL) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(LOCAL) <= '0';
        end if;
        wait until clk = '1';
    end process;
    
    -- EAST 1 
    process 
    begin
        if flag(EAST) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            routingReq(EAST) <= '1';
            data(EAST) <= x"0455";
            flag(EAST) <= '1';
        end if;
        if(routingAck = "0000010") then 
            routingReq(EAST) <= '0';
            sending(EAST) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            wait until clk = '1'; 
            wait until clk = '1'; 
            sending(EAST) <= '0';
        end if;
        wait until clk = '1';
    end process;
    
    -- SOUTH 2 
    process 
    begin
        if flag(SOUTH) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            routingReq(SOUTH) <= '1';
            data(SOUTH) <= x"0455";
            flag(SOUTH) <= '1';
        end if;
        if(routingAck = "0000100") then 
            routingReq(SOUTH) <= '0';
            sending(SOUTH) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(SOUTH) <= '0';
        end if;
        wait until clk = '1';
    end process;

        -- WEST 3 
    process 
    begin
        if flag(WEST) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            routingReq(WEST) <= '1';
            data(WEST) <= x"0557";
            flag(WEST) <= '1';
        end if;
        if(routingAck = "0001000") then 
            routingReq(WEST) <= '0';
            sending(WEST) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(WEST) <= '0';
        end if;
        wait until clk = '1';
    end process;

        -- NORTH 4 
    process 
    begin
        if flag(NORTH) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            routingReq(NORTH) <= '1';
            data(NORTH) <= x"0551";
            flag(NORTH) <= '1';
        end if;
        if(routingAck = "0010000") then 
            routingReq(NORTH) <= '0';
            sending(NORTH) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(NORTH) <= '0';
        end if;
        wait until clk = '1';
    end process;

        -- UP 5 
    process 
    begin
        if flag(UP) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            wait until clk = '1';
            routingReq(UP) <= '1';
            data(UP) <= x"0555";
            flag(UP) <= '1';
        end if;
        if(routingAck = "0100000") then 
            routingReq(UP) <= '0';
            sending(UP) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(UP) <= '0';
        end if;
        wait until clk = '1';
    end process;

        -- DOWN 6
    process 
    begin
        if flag(DOWN) = '0' then
            wait until clk = '1';
            wait until clk = '1';
            routingReq(DOWN) <= '1';
            data(DOWN) <= x"0255";
            flag(DOWN) <= '1';
        end if;
        if(routingAck = "1000000") then 
            routingReq(DOWN) <= '0';
            sending(DOWN) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(DOWN) <= '0';
        end if;
        wait until clk = '1';
    end process;
    
    SWITCH: entity work.SwitchControl 
    generic map(address  => Address(5,5,5))
    port map(
        clk            => clk,
        rst            => rst,
        
        routingReq  => routingReq,
        routingAck  => routingAck,
        data        => data,
        sending     => sending,    
        table       => table
    );
        
end SwitchControl_tb;



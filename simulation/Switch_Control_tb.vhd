--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Gate Buffer Testbench                                                      --
-- DESCRIPTION  :                                                                     --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - May 13th, 2015                                        --
--------------------------------------------------------------------------------------
-- TEMP SECTIONS ARE INCOMPLETE
library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use ieee.std_logic_unsigned.all; -- if routingReq /= 0 then

entity Switch_Control_tb is
end Switch_Control_tb;


architecture Switch_Control_tb of Switch_Control_tb is

    signal clk            : std_logic := '0';
    signal rst            : std_logic;
    
    signal routingReq  :    std_logic_vector( NPORT-1 downto 0);
    signal routingAck  :    std_logic_vector( NPORT-1 downto 0);
    signal data        :    array1D_data(0 to NPORT-1);
    signal sending     :    std_logic_vector( NPORT-1 downto 0) := (OTHERS=>'0');    
    signal table       :    array1D_ports(0 to NPORT-1);

    signal flag           : std_logic := '1';
begin
    
    clk <= not clk after 5 ns;
    
    rst <= '1', '0' after 7 ns;
    
    process
    begin
        
        if(flag = '1') then
            
            routingReq  <=  (OTHERS=>'0');
            data(LOCAL) <=  (OTHERS=>'0');
            data(EAST)  <=  (OTHERS=>'0');
            data(SOUTH) <=  (OTHERS=>'0');
            data(WEST) <=   (OTHERS=>'0');
            data(NORTH) <= (OTHERS=>'0');
            data(UP) <= (OTHERS=>'0');
            data(DOWN) <= (OTHERS=>'0');
            wait until clk = '1';
            wait until clk = '1';
            
            routingReq(LOCAL) <= '1';
            data(LOCAL) <= x"0655";
            
            routingReq(WEST) <= '1';
            data(WEST) <= x"0655";
            
            routingReq(NORTH) <= '1';
            data(NORTH) <= x"0555";
            
            routingReq(SOUTH) <= '1';
            data(SOUTH) <= x"0511";
            
            routingReq(EAST) <= '1';
            data(EAST) <= x"0558";
            
            flag <= '0';
        end if;
        
        wait until clk = '1';
        if(routingAck = "0000000") then
            
        elsif(routingAck = "0000001") then 
            routingReq(LOCAL) <= '0';
            wait until clk = '1';
            sending(LOCAL) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(LOCAL) <= '0';            
        elsif(routingAck = "0000010") then
            routingReq(EAST) <= '0';
            wait until clk = '1';
            sending(EAST) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(EAST) <= '0';
        elsif(routingAck = "0000100") then
            routingReq(SOUTH) <= '0';
            wait until clk = '1';
            sending(SOUTH) <= '1';
            wait until clk = '1';
            wait until clk = '1';
            sending(SOUTH) <= '0';            
        elsif(routingAck = "0001000") then
            routingReq(WEST) <= '0';
            wait until clk = '1';
            sending(WEST) <= '1';
            wait until clk = '1';
            wait until clk = '1';
            sending(WEST) <= '0';
        elsif(routingAck = "0010000") then
            routingReq(NORTH) <= '0';
            wait until clk = '1';
            sending(NORTH) <= '1';
            wait until clk = '1';
            wait until clk = '1';
            sending(NORTH) <= '0';
        elsif(routingAck = "0100000") then
            routingReq(UP) <= '0';
            wait until clk = '1';
            sending(UP) <= '1';
            wait until clk = '1';
            wait until clk = '1';
            sending(UP) <= '0';
        elsif(routingAck = "1000000") then
            routingReq(DOWN) <= '0';
            wait until clk = '1';
            sending(DOWN) <= '1';
            wait until clk = '1';
            wait until clk = '1';
            sending(DOWN) <= '0';
        else
            sending <= (OTHERS=>'0');
        end if;
    end process;
        
    SWITCH: entity work.Switch_Control 
    generic map(address  => getAddress(5,5,5))
    port map(
        clk            => clk,
        rst            => rst,
        
        routingReq  => routingReq,
        routingAck  => routingAck,
        data        => data,
        sending     => sending,    
        table       => table
    );
        
end Switch_Control_tb;



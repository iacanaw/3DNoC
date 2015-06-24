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
    
begin
    
    clk <= not clk after 5 ns;
    
    rst <= '1', '0' after 7 ns;
    
    -- Local
    process 
    begin
        wait until clk = '1';
        wait until clk = '1';
        routingReq(LOCAL) <= '1';
        data(LOCAL) <= x"0655";
        
        if(routingAck = "0000001") then 
            routingReq(LOCAL) <= '0';
            sending(LOCAL) <= '1';
            wait until clk = '1';
            wait until clk = '1'; 
            sending(LOCAL) <= '0';
            wait;
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



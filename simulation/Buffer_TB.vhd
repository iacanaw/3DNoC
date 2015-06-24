--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Gate Buffer Testbench                                                      --
-- DESCRIPTION  : 															        --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - May 13th, 2015										--
--------------------------------------------------------------------------------------
-- TEMP SECTIONS ARE INCOMPLETE
library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use IEEE.std_logic_arith.all;

entity Buffer_TB is
end Buffer_TB;


architecture Buffer_TB of Buffer_TB is

	signal clk			: std_logic := '0';
	signal rst			: std_logic;
	
	signal control_in 	: std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal data_in 		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal routingAck	: std_logic := '0';
	
	signal data_out 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal control_out 	: std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal routingReq	: std_logic;


begin
	
	clk <= not clk after 5 ns;
	
	rst <= '1', '0' after 7 ns;
				
	-- data_in 				<= x"123A" after 15 ns, x"123B" after 25 ns, x"123C" after 45 ns, x"123D" after 55 ns;
	-- control_in(EOP) 		<= '1' after 55 ns;
	-- control_in(RX)			<= '1' after 15 ns, '0' after 35 ns, '1' after 45 ns, '0' after 75 ns;
	-- routingAck 				<= '1' after 45 ns;
	
	process
	begin
		wait until clk = '1'; -- 5 ns
		wait until clk = '1'; -- 15 ns
		control_in(RX) 	<= '1';
		data_in 		<= x"123A";
		
		wait until clk = '1'; -- 25 ns
		data_in 		<= x"123B";

		wait until clk = '1'; -- 35 ns
		control_in(RX) 	<= '0';
		
		wait until clk = '1'; -- 45 ns
		data_in 		<= x"123C";
		control_in(RX) 	<= '1';
		routingAck 		<= '1';
		
		wait until clk = '1'; -- 55 ns
		data_in 		<= x"123D";
		control_in(EOP)	<= '1';
		routingAck 		<= '0';
		
		wait until clk = '1'; -- 65 ns
		
		
		wait until clk = '1'; -- 75 ns
		control_in(EOP)	<= '0';
		control_in(RX) 	<= '0';
		
		wait;
		
	end process;
	
	BUFFER_0: entity work.gateBuffer 
		port map (
			clk				=> clk,
			rst				=> rst,
			 	
			
			-- Receiving/Sending Interface
			data_in		=> data_in,
			control_in	=> control_in,
			data_out	=> data_out,
			control_out	=> control_out,
			
			-- Switch Control Interface
			routingRequest	=> routingReq,
			routingAck		=> routingAck
		);
		
end Buffer_TB;



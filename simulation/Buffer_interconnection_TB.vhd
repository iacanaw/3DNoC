--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Gate Buffer interconnection Testbench                                                      --
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
use IEEE.std_logic_unsigned.all;

entity Buffer_interconnection_TB is
end Buffer_interconnection_TB;


architecture Buffer_interconnection_TB of Buffer_interconnection_TB is

	signal clk			: std_logic := '0';
	signal rst			: std_logic;
	
	-- BUFFER_0
	signal control_in0 	: std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal data_in0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal routingAck0	: std_logic;
	
	signal data_out0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal control_out0 : std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal routingReq0	: std_logic;
	
	-- BUFFER_1
	signal control_in1 	: std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal data_in1 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal routingAck1	: std_logic;
	
	signal data_out1 	: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal control_out1	: std_logic_vector(CONTROL_WIDTH-1 downto 0) := "100";
	signal routingReq1	: std_logic;
	
	signal stall_go1	:std_logic;

begin

	clk <= not clk after 5 ns;
	
	rst <= '1', '0' after 7 ns;
				
	-- data_in 				<= x"123A" after 15 ns, x"123B" after 25 ns, x"123C" after 45 ns, x"123D" after 55 ns;
	-- control_in(EOP) 		<= '1' after 55 ns;
	-- control_in(RX)			<= '1' after 15 ns, '0' after 35 ns, '1' after 45 ns, '0' after 75 ns;
	-- routingAck 				<= '1' after 45 ns;
	
	stall_go1 <= '0', '1' after 200 ns;
	
	process
	variable data: std_logic_vector(DATA_WIDTH-1 downto 0);
	begin
		data := x"123A";
		
		
		wait until clk = '1'; -- 5 ns
		wait until clk = '1'; -- 15 ns
				
		
		for i in 0 to 30 loop
			if control_out0(STALL_GO) = '1' then
				data_in0 <= data;
				control_in0(RX) 	<= '1';
				if i = 30 then
					control_in0(EOP) <= '1';
				end if;
				data := data + 1;
			end if;
			wait until clk = '1';		
		end loop;
		wait until clk = '1'; -- 75 ns
		
		wait;
		
	end process;
	
	process
	begin
		routingAck0 <= '0';
		
		wait until routingReq0 = '1';
		wait until clk = '1';
		routingAck0 <= '1';
		wait until clk = '1';

	end process;
	
	process
	begin
		routingAck1 <= '0';
		
		wait until routingReq1 = '1';
		wait until clk = '1';
		routingAck1 <= '1';
		wait until clk = '1';

	end process;
	
	BUFFER_0: entity work.gateBuffer 
		port map (
			clk				=> clk,
			rst				=> rst,
			 	
			-- Receiving/Sending Interface
			data_in		=> data_in0,
			control_in(EOP) => control_in0(EOP),
			control_in(RX)	=> control_in0(RX),
			control_in(STALL_GO) => control_out1(STALL_GO),
			data_out	=> data_out0,
			control_out(EOP) => control_out0(EOP),
			control_out(RX)	=> control_out0(TX),
			control_out(STALL_GO) => control_out0(STALL_GO),
			
			-- Switch Control Interface
			routingRequest	=> routingReq0,
			routingAck		=> routingAck0
		);
		
	BUFFER_1: entity work.gateBuffer 
		port map (
			clk				=> clk,
			rst				=> rst,
			 	
			-- Receiving/Sending Interface
			data_in		=> data_out0,
			control_in(EOP) => control_out0(EOP),
			control_in(RX)	=> control_out0(TX),
			control_in(STALL_GO) => stall_go1,
			data_out	=> data_out1,
			control_out(EOP) => control_out1(EOP),
			control_out(RX)	=> control_out1(TX),
			control_out(STALL_GO) => control_out1(STALL_GO),
			
			-- Switch Control Interface
			routingRequest	=> routingReq1,
			routingAck		=> routingAck1
		);
		
end Buffer_interconnection_TB;



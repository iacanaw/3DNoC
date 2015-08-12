--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Router Unit                                                       --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Apr 8th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Apr 8th, 2015                                       --
--              : Version 0.2 - Jul 9th, 2015                                       --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;

entity Router is
generic(address: std_logic_vector(DATA_WIDTH-1 downto 0));
    port(
        clk           : in std_logic;
        rst           : in std_logic;
        -- Data and control inputs
        data_in       : in Array1D_data(0 to PORTS-1);
        control_in    : in Array1D_control(0 to PORTS-1);
        -- Data and control outputs
        data_out      : out Array1D_data(0 to PORTS-1);
        control_out   : out Array1D_control(0 to PORTS-1)
    );
end Router;

architecture Router of Router is
    signal routingTable     : Array1D_ports(0 to PORTS-1);
    signal bufferDataOut    : Array1D_data(0 to PORTS-1);
    signal bufferControlOut : Array1D_control(0 to PORTS-1);
    signal routingRequest   : std_logic_vector(PORTS-1 downto 0);
    signal routingAck       : std_logic_vector(PORTS-1 downto 0);
    signal sending          : std_logic_vector(PORTS-1 downto 0);
begin
--------------------------------------------------------------------------------------
-- CROSSBAR
--------------------------------------------------------------------------------------
CROSSBAR: entity work.Crossbar
    port map(   
        routingTable    => routingTable,
        data_in         => bufferDataOut,
        control_in      => bufferControlOut,
        data_out        => data_out,
        control_out     => control_out
    );
--------------------------------------------------------------------------------------
-- SWITCH CONTROL
--------------------------------------------------------------------------------------
SWITCH_CONTROL: entity work.SwitchControl
    generic map(address  => address)
    port map(
        clk             => clk,
        rst             => rst,
        routingReq      => routingRequest,
        routingAck      => routingAck,
        data            => bufferDataOut,
        sending         => sending,
        table           => routingTable
    );
--------------------------------------------------------------------------------------
-- Buffers instantiation with a for ... generate
--------------------------------------------------------------------------------------
	PortBuffers: for n in 0 to PORTS-1 generate
		BufferN: entity work.InputBuffer 
		port map(
			clk             => clk,
			rst             => rst,
			data_in         => data_in(n),
			control_in      => control_in(n),
			data_out        => bufferDataOut(n),
			control_out     => bufferControlOut(n),
			routingRequest  => routingRequest(n),
			routingAck      => routingAck(n),
			sending         => sending(n)
		);
	end generate;
-- --------------------------------------------------------------------------------------
-- -- LOCAL PORT
-- --------------------------------------------------------------------------------------
-- LOCAL_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(LOCAL),
        -- control_in      => control_in(LOCAL),
        -- data_out        => bufferDataOut(LOCAL),
        -- control_out     => bufferControlOut(LOCAL),
        -- routingRequest  => routingRequest(LOCAL),
        -- routingAck      => routingAck(LOCAL),
        -- sending         => sending(LOCAL)
    -- );
-- --------------------------------------------------------------------------------------
-- -- EAST PORT
-- --------------------------------------------------------------------------------------
-- EAST_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(EAST),
        -- control_in      => control_in(EAST),
        -- data_out        => bufferDataOut(EAST),
        -- control_out     => bufferControlOut(EAST),
        -- routingRequest  => routingRequest(EAST),
        -- routingAck      => routingAck(EAST),
        -- sending         => sending(EAST)
    -- );
-- --------------------------------------------------------------------------------------
-- -- SOUTH PORT
-- --------------------------------------------------------------------------------------
-- SOUTH_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(SOUTH),
        -- control_in      => control_in(SOUTH),
        -- data_out        => bufferDataOut(SOUTH),
        -- control_out     => bufferControlOut(SOUTH),
        -- routingRequest  => routingRequest(SOUTH),
        -- routingAck      => routingAck(SOUTH),
        -- sending         => sending(SOUTH)
    -- );
-- --------------------------------------------------------------------------------------
-- -- WEST PORT
-- --------------------------------------------------------------------------------------
-- WEST_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(WEST),
        -- control_in      => control_in(WEST),
        -- data_out        => bufferDataOut(WEST),
        -- control_out     => bufferControlOut(WEST),
        -- routingRequest  => routingRequest(WEST),
        -- routingAck      => routingAck(WEST),
        -- sending         => sending(WEST)
    -- );
-- --------------------------------------------------------------------------------------
-- -- NORTH PORT
-- --------------------------------------------------------------------------------------
-- NORTH_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(NORTH),
        -- control_in      => control_in(NORTH),
        -- data_out        => bufferDataOut(NORTH),
        -- control_out     => bufferControlOut(NORTH),
        -- routingRequest  => routingRequest(NORTH),
        -- routingAck      => routingAck(NORTH),
        -- sending         => sending(NORTH)
    -- );
-- --------------------------------------------------------------------------------------
-- -- UP PORT
-- --------------------------------------------------------------------------------------
-- UP_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(UP),
        -- control_in      => control_in(UP),
        -- data_out        => bufferDataOut(UP),
        -- control_out     => bufferControlOut(UP),
        -- routingRequest  => routingRequest(UP),
        -- routingAck      => routingAck(UP),
        -- sending         => sending(UP)
    -- );
-- --------------------------------------------------------------------------------------
-- -- DOWN PORT
-- --------------------------------------------------------------------------------------
-- DOWN_BUFFER: entity work.InputBuffer 
    -- port map(
        -- clk             => clk,
        -- rst             => rst,
        -- data_in         => data_in(DOWN),
        -- control_in      => control_in(DOWN),
        -- data_out        => bufferDataOut(DOWN),
        -- control_out     => bufferControlOut(DOWN),
        -- routingRequest  => routingRequest(DOWN),
        -- routingAck      => routingAck(DOWN),
        -- sending         => sending(DOWN)
    -- );
end architecture;
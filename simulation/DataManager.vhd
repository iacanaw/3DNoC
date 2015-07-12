--------------------------------------------------------------------------------------
-- DESIGN UNIT  : Data Manager                                                      --
-- DESCRIPTION  :                                                                   --
-- AUTHOR       : Everton Alceu Carara, Iaçanã Ianiski Weber & Michel Duarte        --
-- CREATED      : Jul 9th, 2015                                                     --
-- VERSION      : 0.1                                                               --
-- HISTORY      : Version 0.1 - Jul 9th, 2015                                       --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.NoC_Package.all;
use std.textio.all;
use work.Text_Package.all;


entity DataManager is 
    generic(
            fileNameIn  : string := "000fileIn";
            fileNameOut : string := "000fileOut"
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        control_in : in std_logic_vector(CONTROL_WIDTH-1 downto 0);
        
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
        control_out : out std_logic_vector(CONTROL_WIDTH-1 downto 0)
    );
end DataManager;

architecture behavioral of DataManager is
begin
    SEND: block
        type state is (S0, S1);
        signal currentState : state;
        signal words : std_logic_vector(32 downto 0); -- 33 = 32_word + 1_eop
        file flitFile : text open read_mode is fileNameIn;
    begin
        control_out(TX) <= '1' when currentState = S0 else '0';
        process(clk, rst)
            variable flitLine   : line;
            variable str        : string(1 to 9);
        begin 
            if rst = '1' then
                currentState <= S1;
                words <= (OTHERS=>'0');
            elsif rising_edge(clk) then
                case currentState is
                    when S0 =>
                        if not(endfile(flitFile)) then
                            if(control_in(STALL_GO)='1') then
                                readline(flitFile, flitLine);
                                read(flitLine, str);
                                words <= StringToStdLogicVector(str);
                                data_out <= words(DATA_WIDTH-1 downto 0);
                                control_out(EOP) <= words(32);
                                currentState <= S0;
                            else -- Local port haven't space on buffer
                                currentState <= S0;
                            end if;
                        else -- End of File
                            currentState <= S1;
                        end if;

                    when S1 =>
                        if not(endfile(flitFile)) then
                            currentState <= S0;
                        else
                            currentState <= S1;
                        end if;
                end case;
            end if;
        end process;
    end block SEND;
    
    RECIEVE: block
        type state is (S0);
        signal currentState : state;
        file flitFile : text open write_mode is fileNameOut;
    begin
        control_out(STALL_GO) <= '1';
         process(clk, rst)
            variable flitLine   : line;
            variable str        : string (1 to 9);
        begin
            if rst = '1' then
                control_out(STALL_GO) <= '0';
                currentState <= S0;
            elsif rising_edge(clk) then
                case currentState is
                    when S0 =>
                        if control_in(RX) = '1' then
                            write(flitLine, StdLogicVectorToString(control_in(EOP)&data_in));
                            writeline(flitFile, flitLine);
                        end if;
                        currentState <= S0;
                end case;
            end if;
        end process;
    end block RECIEVE;
    
end architecture;
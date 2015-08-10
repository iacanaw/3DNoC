# Sets the compiler
set compiler vcom

# Creates the work library if it does not exist
if { ![file exist work] } {
    vlib work
}

# Source files listed in hierarchical order: bottom -> top
set sourceFiles {
    ../NoC_Package.vhd
    ../InputBuffer.vhd
    ../SwitchControl.vhd
    ../Crossbar.vhd
    ../Router.vhd
    ../NoC.vhd
    Text_Package.vhd
    DataManager.vhd
    TopNoC.vhd
    }

set top TopNoC.vhd

if { [llength $sourceFiles] > 0 } {
    
    foreach file $sourceFiles {
        if [ catch {$compiler $file} ] {
            puts "\n*** ERROR compiling file $file :( ***" 
            return;
        }
    }
}

if { [llength $sourceFiles] > 0 } {
    
    puts "\n*** Compiled files:"  
    
    foreach file $sourceFiles {
        puts \t$file
    }
}

puts "\n*** Compilation OK ;) ***"

# Start simulation
vsim $top

# Crossbar_tb wave
#cb_wave.do
#run 150 ns

# SwitchControl_tb wave
#do sc_wave.do
#run 500ns
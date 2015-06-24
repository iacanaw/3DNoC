# Sets the compiler
set compiler vcom

# Creates the work library if it does not exist
if { ![file exist work] } {
    vlib work
}

# Source files listed in hierarchical order: bottom -> top
set sourceFiles {
    ../NoC_Package.vhd
    ../Buffer.vhd
    ../Switch_Control.vhd
    ../Router.vhd
    ../NoC.vhd
    Switch_Control_tb.vhd
    }

set top Switch_Control_tb

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

vsim $top

# Wave.do
do sc_wave.do
run 500ns
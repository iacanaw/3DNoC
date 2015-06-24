# Sets the compiler
set compiler vcom

# Creates the work library if it does not exist
if { ![file exist work] } {
	vlib work
}

# Source files listed in hierarchical order: bottom -> top
set sourceFiles {
	NoC/NoC_Package.vhd
	NoC/Buffer.vhd
	NoC/Buffer_interconnection_TB.vhd
	}
#NoC/Buffer_TB.vhd

set top Buffer_interconnection_TB

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

#vsim $top

# Wave.do
# do wave.do

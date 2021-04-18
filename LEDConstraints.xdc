# Clock on E3
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# LED Stuff
set_property PACKAGE_PIN H16 [get_ports arduinoClock]
set_property IOSTANDARD LVCMOS33 [get_ports arduinoClock]

set_property PACKAGE_PIN D17 [get_ports finished]
set_property IOSTANDARD LVCMOS33 [get_ports finished]

set_property PACKAGE_PIN P17 [get_ports ready]
set_property IOSTANDARD LVCMOS33 [get_ports ready]

set_property PACKAGE_PIN R12 [get_ports LED]
set_property IOSTANDARD LVCMOS33 [get_ports LED]

set_property PACKAGE_PIN C17 [get_ports {ledOut[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[0]}]
set_property PACKAGE_PIN D18 [get_ports {ledOut[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[1]}]
set_property PACKAGE_PIN E18 [get_ports {ledOut[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[2]}]
set_property PACKAGE_PIN G17 [get_ports {ledOut[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[3]}]

set_property PACKAGE_PIN D14 [get_ports {ledOut[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[4]}]
set_property PACKAGE_PIN F16 [get_ports {ledOut[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[5]}]
set_property PACKAGE_PIN G16 [get_ports {ledOut[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[6]}]
set_property PACKAGE_PIN H14 [get_ports {ledOut[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut[7]}]
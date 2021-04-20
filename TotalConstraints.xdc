# Clock on E3
set_property PACKAGE_PIN E3 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports clock]

# LED 2
set_property PACKAGE_PIN F3 [get_ports arduinoClock2]
set_property IOSTANDARD LVCMOS33 [get_ports arduinoClock2]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {arduinoClock2_IBUF}]

set_property PACKAGE_PIN G2 [get_ports arduinoStart2]
set_property IOSTANDARD LVCMOS33 [get_ports arduinoStart2]

set_property PACKAGE_PIN K1 [get_ports {ledOut2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[0]}]
set_property PACKAGE_PIN F6 [get_ports {ledOut2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[1]}]
set_property PACKAGE_PIN J2 [get_ports {ledOut2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[2]}]
set_property PACKAGE_PIN G6 [get_ports {ledOut2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[3]}]

set_property PACKAGE_PIN H4 [get_ports {ledOut2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[4]}]
set_property PACKAGE_PIN H1 [get_ports {ledOut2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[5]}]
set_property PACKAGE_PIN G1 [get_ports {ledOut2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[6]}]
set_property PACKAGE_PIN G3 [get_ports {ledOut2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ledOut2[7]}]
# LED Stuff
set_property PACKAGE_PIN H16 [get_ports arduinoClock]
set_property IOSTANDARD LVCMOS33 [get_ports arduinoClock]

set_property PACKAGE_PIN D17 [get_ports arduinoStart]
set_property IOSTANDARD LVCMOS33 [get_ports arduinoStart]

set_property PACKAGE_PIN P17 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

set_property PACKAGE_PIN G14 [get_ports startest]
set_property IOSTANDARD LVCMOS33 [get_ports startest]

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
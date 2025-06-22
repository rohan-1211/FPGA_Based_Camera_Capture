set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property PACKAGE_PIN F14 [get_ports {D[1]}]
set_property PACKAGE_PIN J13 [get_ports {D[0]}]
set_property PACKAGE_PIN F15 [get_ports {D[3]}]
set_property PACKAGE_PIN J14 [get_ports {D[2]}]
set_property PACKAGE_PIN H13 [get_ports {D[5]}]
set_property PACKAGE_PIN E14 [get_ports {D[4]}]
set_property PACKAGE_PIN H14 [get_ports {D[7]}]
set_property PACKAGE_PIN E15 [get_ports {D[6]}]

set_property PACKAGE_PIN J2 [get_ports reset_n]
set_property PACKAGE_PIN J1 [get_ports start]
set_property PACKAGE_PIN G2 [get_ports btn_invert]
set_property PACKAGE_PIN H2 [get_ports btn_grey]
set_property IOSTANDARD LVCMOS25 [get_ports reset_n]
set_property IOSTANDARD LVCMOS25 [get_ports start]
set_property IOSTANDARD LVCMOS25 [get_ports btn_invert]
set_property IOSTANDARD LVCMOS25 [get_ports btn_grey]

set_property PACKAGE_PIN H17 [get_ports pclk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pclk_IBUF]
set_property PACKAGE_PIN K16 [get_ports vsync_camera]
set_property PACKAGE_PIN K14 [get_ports href]

set_property PACKAGE_PIN G18 [get_ports xclk]
set_property IOSTANDARD LVCMOS33 [get_ports xclk]

set_property PACKAGE_PIN C13 [get_ports led_output]
set_property IOSTANDARD LVCMOS33 [get_ports led_output]

set_property PACKAGE_PIN C14 [get_ports locked1]
set_property IOSTANDARD LVCMOS33 [get_ports locked1]

set_property PACKAGE_PIN D15 [get_ports vde1]
set_property IOSTANDARD LVCMOS33 [get_ports vde1]

set_property PACKAGE_PIN G1 [get_ports btn_alien_raw]
set_property IOSTANDARD LVCMOS25 [get_ports btn_alien_raw]




set_property PACKAGE_PIN H16 [get_ports reset_out]
set_property IOSTANDARD LVCMOS33 [get_ports reset_out]


set_property PACKAGE_PIN J15 [get_ports sda]
set_property PACKAGE_PIN J16 [get_ports scl]


set_property IOSTANDARD LVCMOS33 [get_ports {D[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {D[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports pclk]
set_property IOSTANDARD LVCMOS33 [get_ports vsync_camera]
set_property IOSTANDARD LVCMOS33 [get_ports href]
set_property IOSTANDARD LVCMOS33 [get_ports sda]
set_property IOSTANDARD LVCMOS33 [get_ports scl]

set_property -dict {PACKAGE_PIN V17 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_n]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_p]

set_property -dict {PACKAGE_PIN U18 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[0]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[1]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[2]}]

set_property -dict {PACKAGE_PIN U17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[1]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[2]}]

create_clock -period 10.000 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property PACKAGE_PIN N15 [get_ports Clk]
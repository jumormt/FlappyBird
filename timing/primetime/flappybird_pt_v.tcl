## Copyright (C) 1991-2009 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.

## VENDOR "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 222 10/21/2009 SJ Full Version"

## DATE "11/02/2016 14:25:53"

## 
## Device: Altera EPM1270T144C5 Package TQFP144
## 

## 
## This Tcl script should be used for PrimeTime (Verilog) only
## 

## This file can be sourced in primetime

set report_default_significant_digits 3
set hierarchy_separator .

set quartus_root "c:/eda/altera/91/quartus/"
set search_path [list . [format "%s%s" $quartus_root "eda/synopsys/primetime/lib"]  ]

set link_path [list *  maxii_io_lib.db maxii_asynch_lcell_lib.db  maxii_ufm_lib.db maxii_lcell_register_lib.db  alt_vtl.db]

read_verilog  maxii_all_pt.v 

##########################
## DESIGN ENTRY SECTION ##
##########################

read_verilog  flappybird.vo
current_design flappybird
link
## Set variable timing_propagate_single_condition_min_slew to false only for versions 2004.06 and earlier
regexp {([1-9][0-9][0-9][0-9]\.[0-9][0-9])} $sh_product_version dummy version
if { [string compare "2004.06" $version ] != -1 } {
   set timing_propagate_single_condition_min_slew false
}
set_operating_conditions -analysis_type single
read_sdf flappybird_v.sdo

################################
## TIMING CONSTRAINTS SECTION ##
################################


## Start clock definition ##
# WARNING:  The required clock period is not set. The default value (100 ns) is used. 
create_clock -period 100.000 -waveform {0.000 50.000} [get_ports { clk } ] -name clk  

set_propagated_clock [all_clocks]
## End clock definition ##

## Start create collections ##
## End create collections ##

## Start global settings ##
## End global settings ##

## Start collection commands definition ##

## End collection commands definition ##

## Start individual pin commands definition ##
## End individual pin commands definition ##

## Start Output pin capacitance definition ##
set_load -pin_load 10 [get_ports { C[0] } ]
set_load -pin_load 10 [get_ports { C[1] } ]
set_load -pin_load 10 [get_ports { C[2] } ]
set_load -pin_load 10 [get_ports { C[3] } ]
set_load -pin_load 10 [get_ports { C[4] } ]
set_load -pin_load 10 [get_ports { C[5] } ]
set_load -pin_load 10 [get_ports { C[6] } ]
set_load -pin_load 10 [get_ports { C[7] } ]
set_load -pin_load 10 [get_ports { G[0] } ]
set_load -pin_load 10 [get_ports { G[1] } ]
set_load -pin_load 10 [get_ports { G[2] } ]
set_load -pin_load 10 [get_ports { G[3] } ]
set_load -pin_load 10 [get_ports { G[4] } ]
set_load -pin_load 10 [get_ports { G[5] } ]
set_load -pin_load 10 [get_ports { G[6] } ]
set_load -pin_load 10 [get_ports { G[7] } ]
set_load -pin_load 10 [get_ports { R[0] } ]
set_load -pin_load 10 [get_ports { R[1] } ]
set_load -pin_load 10 [get_ports { R[2] } ]
set_load -pin_load 10 [get_ports { R[3] } ]
set_load -pin_load 10 [get_ports { R[4] } ]
set_load -pin_load 10 [get_ports { R[5] } ]
set_load -pin_load 10 [get_ports { R[6] } ]
set_load -pin_load 10 [get_ports { R[7] } ]
set_load -pin_load 10 [get_ports { cat[0] } ]
set_load -pin_load 10 [get_ports { cat[1] } ]
set_load -pin_load 10 [get_ports { cat[2] } ]
set_load -pin_load 10 [get_ports { cat[3] } ]
set_load -pin_load 10 [get_ports { cat[4] } ]
set_load -pin_load 10 [get_ports { cat[5] } ]
set_load -pin_load 10 [get_ports { cat[6] } ]
set_load -pin_load 10 [get_ports { cat[7] } ]
set_load -pin_load 10 [get_ports { score_view[0] } ]
set_load -pin_load 10 [get_ports { score_view[1] } ]
set_load -pin_load 10 [get_ports { score_view[2] } ]
set_load -pin_load 10 [get_ports { score_view[3] } ]
set_load -pin_load 10 [get_ports { score_view[4] } ]
set_load -pin_load 10 [get_ports { score_view[5] } ]
set_load -pin_load 10 [get_ports { score_view[6] } ]
## End Output pin capacitance definition ##

## Start clock uncertainty definition ##
## End clock uncertainty definition ##

## Start Multicycle and Cut Path definition ##
## End Multicycle and Cut Path definition ##

## Destroy Collections ##

update_timing

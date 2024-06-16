# vsynth_create_project.tcl: Tcl script for re-creating project 'vsynth'

set script_dir [file dirname [file normalize [info script]]]
puts "script directory: $script_dir"

set src_dir [file normalize [file join $script_dir "src"]]
puts "src directory: $src_dir"

set constr_dir [file normalize [file join $script_dir "constr"]]
puts "constr directory: $constr_dir"

set sim_dir [file normalize [file join $script_dir "sim"]]
puts "sim directory: $sim_dir"

set project_name "vsynth"

set workspace_dir [pwd]
puts "workspace directory: $workspace_dir"

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Set the project name
set _xil_proj_name_ $project_name

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a50ticsg324-1L -force

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part_repo_paths" -value "[file normalize "$origin_dir/../../../AppData/Roaming/Xilinx/Vivado/2021.2/xhub/board_store/xilinx_board_store"]" -objects $obj
set_property -name "board_part" -value "digilentinc.com:nexys-a7-50t:part0:1.3" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "nexys-a7-50t" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${src_dir}/vsynth_top.v"] \
 [file normalize "${src_dir}/vsynth_test.v"] \
 [file normalize "${src_dir}/debouncer_test.v"] \
 [file normalize "${src_dir}/common/debouncer_pulse.v"] \
 [file normalize "${src_dir}/common/edge_detector.v"] \
 [file normalize "${src_dir}/midi_test.v"] \
 [file normalize "${src_dir}/uart_rx_test.v"] \
 [file normalize "${src_dir}/common/mux_4_1_hot1.v"] \
 [file normalize "${src_dir}/common/shift_reg_right.v"] \
 [file normalize "${src_dir}/common/prescaler.v"] \
 [file normalize "${src_dir}/common/register.v"] \
 [file normalize "${src_dir}/common/register_clr.v"] \
 [file normalize "${src_dir}/common/up_cnt_mod.v"] \
 [file normalize "${src_dir}/common/up_cnt_mod_load.v"] \
 [file normalize "${src_dir}/common/shift_reg.v"] \
 [file normalize "${src_dir}/7seg/bcd7seg.v"] \
 [file normalize "${src_dir}/7seg/bin2bcd.v"] \
 [file normalize "${src_dir}/7seg/seg_8bit.v"] \
 [file normalize "${src_dir}/uart/uart_fsm.v"] \
 [file normalize "${src_dir}/uart/uart_rx.v"] \
 [file normalize "${src_dir}/midi/midi.v"] \
 [file normalize "${src_dir}/midi/midi_fsm.v"] \
 [file normalize "${src_dir}/midi/poly_midi.v"] \
 [file normalize "${src_dir}/midi/polyphony.v"] \
 [file normalize "${src_dir}/midi/cc_decoder.v"] \
 [file normalize "${src_dir}/nco/nco.v"] \
 [file normalize "${src_dir}/nco/nco_bank.v"] \
 [file normalize "${src_dir}/nco/phase2sample.v"] \
 [file normalize "${src_dir}/nco/step_size_rom.v"] \
 [file normalize "${src_dir}/nco/step_size_rom.mem"] \
 [file normalize "${src_dir}/wavetables/sample_rom.v"] \
 [file normalize "${src_dir}/wavetables/wavetable_data_rom.v"] \
 [file normalize "${src_dir}/wavetables/wavetable_offset_rom.v"] \
 [file normalize "${src_dir}/wavetables/wavetable_loader.v"] \
 [file normalize "${src_dir}/wavetables/wavetable_ram.v"] \
 [file normalize "${src_dir}/wavetables/wtb_synthesis.v"] \
 [file normalize "${src_dir}/wavetables/wavetable_offset_rom.mem"] \
 [file normalize "${src_dir}/wavetables/wavetable_data_rom.mem"] \
 [file normalize "${src_dir}/wavetables/sample_rom.mem"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "vsynth_top" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "top" -value "vsynth_top" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]
set files [list \
 [file normalize "${constr_dir}/vsynth_top.xdc"] \
]
add_files -norecurse -fileset $obj $files

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${sim_dir}/poly_midi_tb.v"] \
 [file normalize "${sim_dir}/nco_tb.v"] \
 [file normalize "${sim_dir}/rom_tb.v"] \
 [file normalize "${sim_dir}/up_cnt_mod_tb.v"] \
 [file normalize "${sim_dir}/uart_rx_tb.v"] \
 [file normalize "${sim_dir}/midi_tb.v"] \
 [file normalize "${sim_dir}/poly_midi_module_tb.v"] \
 [file normalize "${sim_dir}/phase2sample_tb.v"] \
 [file normalize "${sim_dir}/nco_bank_tb.v"] \
 [file normalize "${sim_dir}/shift_reg_tb.v"] \
 [file normalize "${sim_dir}/wavetable_ram_tb.v"] \
 [file normalize "${sim_dir}/up_cnt_mod_load_tb.v"] \
 [file normalize "${sim_dir}/wavetable_loader_tb.v"] \
 [file normalize "${sim_dir}/wtb_synthesis_tb.v"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "wtb_synthesis_tb" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "top" -value "wtb_synthesis_tb" -objects $obj
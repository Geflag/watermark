# This is a generated file. Use and modify at your own risk.
################################################################################

set kernel_name    "sdx_kernel_addwm"
set kernel_vendor  "team_447"
set kernel_library "kernel"

##############################################################################

proc edit_core {core} {
  set bif      [::ipx::get_bus_interfaces -of $core  "m00_axi_im"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  set bif      [::ipx::get_bus_interfaces -of $core  "m01_axi_wm"] 
  set bifparam [::ipx::add_bus_parameter -quiet "MAX_BURST_LENGTH" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_READ_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam
  set bifparam [::ipx::add_bus_parameter -quiet "NUM_WRITE_OUTSTANDING" $bif]
  set_property value        32           $bifparam
  set_property value_source constant     $bifparam

  ::ipx::associate_bus_interfaces -busif "m00_axi_im" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "m01_axi_wm" -clock "ap_clk" $core
  ::ipx::associate_bus_interfaces -busif "s_axi_control" -clock "ap_clk" $core

  set mem_map    [::ipx::add_memory_map -quiet "s_axi_control" $core]
  set addr_block [::ipx::add_address_block -quiet "reg0" $mem_map]

  set reg      [::ipx::add_register "Control" $addr_block]
  set_property address_offset 0x000 $reg
  set_property size           1     $reg

  set reg      [::ipx::add_register -quiet "addwm_strength" $addr_block]
  set_property address_offset 0x010 $reg
  set_property size           4   $reg

  set reg      [::ipx::add_register -quiet "im_input_addr" $addr_block]
  set_property address_offset 0x018 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "wm_input_addr" $addr_block]
  set_property address_offset 0x020 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "im_output_addr" $addr_block]
  set_property address_offset 0x028 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "im_input_size" $addr_block]
  set_property address_offset 0x030 $reg
  set_property size           4   $reg

  set reg      [::ipx::add_register -quiet "wm_input_size" $addr_block]
  set_property address_offset 0x038 $reg
  set_property size           4   $reg

  set reg      [::ipx::add_register -quiet "im_output_size" $addr_block]
  set_property address_offset 0x040 $reg
  set_property size           4   $reg

  set reg      [::ipx::add_register -quiet "axi00_im" $addr_block]
  set_property address_offset 0x048 $reg
  set_property size           8   $reg

  set reg      [::ipx::add_register -quiet "axi01_wm" $addr_block]
  set_property address_offset 0x050 $reg
  set_property size           8   $reg

  set_property slave_memory_map_ref "s_axi_control" [::ipx::get_bus_interfaces -of $core "s_axi_control"]

  set_property xpm_libraries {XPM_CDC XPM_MEMORY XPM_FIFO} $core
  set_property sdx_kernel true $core
  set_property sdx_kernel_type rtl $core
}

##############################################################################

proc package_project {path_to_packaged kernel_vendor kernel_library kernel_name} {
  set core [::ipx::package_project -root_dir $path_to_packaged -vendor $kernel_vendor -library $kernel_library -taxonomy "/KernelIP" -import_files -set_current false]
  foreach user_parameter [::ipx::get_user_parameters -of $core] {
    ::ipx::remove_user_parameter [get_property NAME $user_parameter] $core
  }
  ::ipx::create_xgui_files $core
  set_property supported_families { } $core
  set_property auto_family_support_level level_2 $core
  set_property used_in {out_of_context implementation synthesis} [::ipx::get_files -type xdc -of_objects [::ipx::get_file_groups "xilinx_anylanguagesynthesis" -of_objects $core] *_ooc.xdc]
  edit_core $core
  ::ipx::update_checksums $core
  ::ipx::save_core $core
  ::ipx::unload_core $core
  unset core
}

##############################################################################

proc package_project_dcp {path_to_dcp path_to_packaged kernel_vendor kernel_library kernel_name} {
  set core [::ipx::package_checkpoint -dcp_file $path_to_dcp -root_dir $path_to_packaged -vendor $kernel_vendor -library $kernel_library -name $kernel_name -taxonomy "/KernelIP" -force]
  edit_core $core
  ::ipx::update_checksums $core
  ::ipx::save_core $core
  ::ipx::unload_core $core
  unset core
}

##############################################################################

// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1 ns / 1 ps
// Top level of the kernel. Do not modify module name, parameters or ports.
module sdx_kernel_addwm #(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12  ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32  ,
  parameter integer C_M00_AXI_IM_ADDR_WIDTH    = 64  ,
  parameter integer C_M00_AXI_IM_DATA_WIDTH    = 512,
  parameter integer C_M01_AXI_WM_ADDR_WIDTH    = 64  ,
  parameter integer C_M01_AXI_WM_DATA_WIDTH    = 128
)
(
  // System Signals
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst_n             ,
  //  Note: A minimum subset of AXI4 memory mapped signals are declared.  AXI
  // signals omitted from these interfaces are automatically inferred with the
  // optimal values for Xilinx SDx systems.  This allows Xilinx AXI4 Interconnects
  // within the system to be optimized by removing logic for AXI4 protocol
  // features that are not necessary. When adapting AXI4 masters within the RTL
  // kernel that have signals not declared below, it is suitable to add the
  // signals to the declarations below to connect them to the AXI4 Master.
  // 
  // List of ommited signals - effect
  // -------------------------------
  // ID - Transaction ID are used for multithreading and out of order
  // transactions.  This increases complexity. This saves logic and increases Fmax
  // in the system when ommited.
  // SIZE - Default value is log2(data width in bytes). Needed for subsize bursts.
  // This saves logic and increases Fmax in the system when ommited.
  // BURST - Default value (0b01) is incremental.  Wrap and fixed bursts are not
  // recommended. This saves logic and increases Fmax in the system when ommited.
  // LOCK - Not supported in AXI4
  // CACHE - Default value (0b0011) allows modifiable transactions. No benefit to
  // changing this.
  // PROT - Has no effect in SDx systems.
  // QOS - Has no effect in SDx systems.
  // REGION - Has no effect in SDx systems.
  // USER - Has no effect in SDx systems.
  // RESP - Not useful in most SDx systems.
  // 
  // AXI4 master interface m00_axi_im
  output wire                                    m00_axi_im_awvalid   ,
  input  wire                                    m00_axi_im_awready   ,
  output wire [C_M00_AXI_IM_ADDR_WIDTH-1:0]      m00_axi_im_awaddr    ,
  output wire [8-1:0]                            m00_axi_im_awlen     ,
  output wire                                    m00_axi_im_wvalid    ,
  input  wire                                    m00_axi_im_wready    ,
  output wire [C_M00_AXI_IM_DATA_WIDTH-1:0]      m00_axi_im_wdata     ,
  output wire [C_M00_AXI_IM_DATA_WIDTH/8-1:0]    m00_axi_im_wstrb     ,
  output wire                                    m00_axi_im_wlast     ,
  input  wire                                    m00_axi_im_bvalid    ,
  output wire                                    m00_axi_im_bready    ,
  output wire                                    m00_axi_im_arvalid   ,
  input  wire                                    m00_axi_im_arready   ,
  output wire [C_M00_AXI_IM_ADDR_WIDTH-1:0]      m00_axi_im_araddr    ,
  output wire [8-1:0]                            m00_axi_im_arlen     ,
  
  output wire                                    m00_axi_im_awid      ,
  output wire [2:0]                              m00_axi_im_awsize    ,
  
  output wire [1:0]                              m00_axi_im_awburst ,
  output wire [1:0]                              m00_axi_im_awlock  ,
  output wire [3:0]                              m00_axi_im_awcache ,
  output wire [2:0]                              m00_axi_im_awprot  ,
  output wire [3:0]                              m00_axi_im_awqos   ,
  output wire [3:0]                              m00_axi_im_awregion,
  
  output wire                                    m00_axi_im_arid     ,
  output wire [2:0]                              m00_axi_im_arsize   ,
  output wire [1:0]                              m00_axi_im_arburst  ,
  output wire [1:0]                              m00_axi_im_arlock   ,
  output wire [3:0]                              m00_axi_im_arcache  ,
  output wire [2:0]                              m00_axi_im_arprot   ,
  output wire [3:0]                              m00_axi_im_arqos    ,
  output wire [3:0]                              m00_axi_im_arregion ,
  
  input  wire [1:0]                              m00_axi_im_bresp     ,
  input  wire                                    m00_axi_im_bid       ,
  
  input  wire                                    m00_axi_im_rvalid    ,
  output wire                                    m00_axi_im_rready    ,
  input  wire [C_M00_AXI_IM_DATA_WIDTH-1:0]      m00_axi_im_rdata     ,
  input  wire                                    m00_axi_im_rlast     ,
  // AXI4 master interface m01_axi_wm
  output wire                                    m01_axi_wm_awvalid   ,
  input  wire                                    m01_axi_wm_awready   ,
  output wire [C_M01_AXI_WM_ADDR_WIDTH-1:0]      m01_axi_wm_awaddr    ,
  output wire [8-1:0]                            m01_axi_wm_awlen     ,
  output wire                                    m01_axi_wm_awid      ,
  output wire [2:0]                              m01_axi_wm_awsize    ,
  output wire                                    m01_axi_wm_wvalid    ,
  input  wire                                    m01_axi_wm_wready    ,
  output wire [C_M01_AXI_WM_DATA_WIDTH-1:0]      m01_axi_wm_wdata     ,
  output wire [C_M01_AXI_WM_DATA_WIDTH/8-1:0]    m01_axi_wm_wstrb     ,
  output wire                                    m01_axi_wm_wlast     ,
  input  wire                                    m01_axi_wm_bvalid    ,
  output wire                                    m01_axi_wm_bready    ,
  output wire                                    m01_axi_wm_arvalid   ,
  input  wire                                    m01_axi_wm_arready   ,
  output wire [C_M01_AXI_WM_ADDR_WIDTH-1:0]      m01_axi_wm_araddr    ,
  output wire [8-1:0]                            m01_axi_wm_arlen     ,
  input  wire                                    m01_axi_wm_rvalid    ,
  output wire                                    m01_axi_wm_rready    ,
  input  wire [C_M01_AXI_WM_DATA_WIDTH-1:0]      m01_axi_wm_rdata     ,
  input  wire                                    m01_axi_wm_rlast     ,
  
  output wire [1:0]                              m01_axi_wm_awburst ,
  output wire [1:0]                              m01_axi_wm_awlock  ,
  output wire [3:0]                              m01_axi_wm_awcache ,
  output wire [2:0]                              m01_axi_wm_awprot  ,
  output wire [3:0]                              m01_axi_wm_awqos   ,
  output wire [3:0]                              m01_axi_wm_awregion,
                                                         
  output wire                                    m01_axi_wm_arid     ,
  output wire [2:0]                              m01_axi_wm_arsize   ,
  output wire [1:0]                              m01_axi_wm_arburst  ,
  output wire [1:0]                              m01_axi_wm_arlock   ,
  output wire [3:0]                              m01_axi_wm_arcache  ,
  output wire [2:0]                              m01_axi_wm_arprot   ,
  output wire [3:0]                              m01_axi_wm_arqos    ,
  output wire [3:0]                              m01_axi_wm_arregion ,
                                                         
  input  wire [1:0]                              m01_axi_wm_bresp     ,
  input  wire                                    m01_axi_wm_bid       ,
  // AXI4-Lite slave interface
  input  wire                                    s_axi_control_awvalid,
  output wire                                    s_axi_control_awready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_awaddr ,
  input  wire                                    s_axi_control_wvalid ,
  output wire                                    s_axi_control_wready ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_wdata  ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb  ,
  input  wire                                    s_axi_control_arvalid,
  output wire                                    s_axi_control_arready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_araddr ,
  output wire                                    s_axi_control_rvalid ,
  input  wire                                    s_axi_control_rready ,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_rdata  ,
  output wire [2-1:0]                            s_axi_control_rresp  ,
  output wire                                    s_axi_control_bvalid ,
  input  wire                                    s_axi_control_bready ,
  output wire [2-1:0]                            s_axi_control_bresp  ,
  output wire                                    interrupt            
);

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
reg                                 areset                         = 1'b0;
wire                                ap_start                      ;
wire                                ap_idle                       ;
wire                                ap_done                       ;
wire [32-1:0]                       addwm_strength                ;
wire [64-1:0]                       im_input_addr                 ;
wire [64-1:0]                       wm_input_addr                 ;
wire [64-1:0]                       im_output_addr                ;
wire [32-1:0]                       im_input_size                 ;
wire [32-1:0]                       wm_input_size                 ;
wire [32-1:0]                       im_output_size                ;
wire [64-1:0]                       axi00_im                      ;
wire [64-1:0]                       axi01_wm                      ;

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

///////////////////////////////////////////////////////////////////////////////
// Begin control interface RTL.  Modifying not recommended.
///////////////////////////////////////////////////////////////////////////////


// AXI4-Lite slave interface
// sdx_kernel_addwm_control_s_axi #(
  // .C_ADDR_WIDTH ( C_S_AXI_CONTROL_ADDR_WIDTH ),
  // .C_DATA_WIDTH ( C_S_AXI_CONTROL_DATA_WIDTH )
// )
// inst_control_s_axi (
  // .aclk           ( ap_clk                ),
  // .areset         ( areset                ),
  // .aclk_en        ( 1'b1                  ),
  // .awvalid        ( s_axi_control_awvalid ),
  // .awready        ( s_axi_control_awready ),
  // .awaddr         ( s_axi_control_awaddr  ),
  // .wvalid         ( s_axi_control_wvalid  ),
  // .wready         ( s_axi_control_wready  ),
  // .wdata          ( s_axi_control_wdata   ),
  // .wstrb          ( s_axi_control_wstrb   ),
  // .arvalid        ( s_axi_control_arvalid ),
  // .arready        ( s_axi_control_arready ),
  // .araddr         ( s_axi_control_araddr  ),
  // .rvalid         ( s_axi_control_rvalid  ),
  // .rready         ( s_axi_control_rready  ),
  // .rdata          ( s_axi_control_rdata   ),
  // .rresp          ( s_axi_control_rresp   ),
  // .bvalid         ( s_axi_control_bvalid  ),
  // .bready         ( s_axi_control_bready  ),
  // .bresp          ( s_axi_control_bresp   ),
  // .interrupt      ( interrupt             ),
  // .ap_start       ( ap_start              ),
  // .ap_done        ( ap_done               ),
  // .ap_idle        ( ap_idle               ),
  // .addwm_strength ( addwm_strength        ),
  // .im_input_addr  ( im_input_addr         ),
  // .wm_input_addr  ( wm_input_addr         ),
  // .im_output_addr ( im_output_addr        ),
  // .im_input_size  ( im_input_size         ),
  // .wm_input_size  ( wm_input_size         ),
  // .im_output_size ( im_output_size        ),
  // .axi00_im       ( axi00_im              ),
  // .axi01_wm       ( axi01_wm              )
// );

///////////////////////////////////////////////////////////////////////////////
// Add kernel logic here.  Modify/remove example code as necessary.
///////////////////////////////////////////////////////////////////////////////

// Example RTL block.  Remove to insert custom logic.
sdx_kernel_addwm_int #(
  .C_M00_AXI_IM_ADDR_WIDTH ( C_M00_AXI_IM_ADDR_WIDTH ),
  .C_M00_AXI_IM_DATA_WIDTH ( C_M00_AXI_IM_DATA_WIDTH ),
  .C_M01_AXI_WM_ADDR_WIDTH ( C_M01_AXI_WM_ADDR_WIDTH ),
  .C_M01_AXI_WM_DATA_WIDTH ( C_M01_AXI_WM_DATA_WIDTH )
)
inst_int (
  .ap_clk             ( ap_clk             ),
  .ap_rst_n           ( ap_rst_n           ),
  .aclk_en        ( 1'b1                  ),
  .s_axi_control_AWVALID        ( s_axi_control_awvalid ),
  .s_axi_control_AWREADY        ( s_axi_control_awready ),
  .s_axi_control_AWADDR         ( s_axi_control_awaddr  ),
  .s_axi_control_WVALID         ( s_axi_control_wvalid  ),
  .s_axi_control_WREADY         ( s_axi_control_wready  ),
  .s_axi_control_WDATA          ( s_axi_control_wdata   ),
  .s_axi_control_WSTRB          ( s_axi_control_wstrb   ),
  .s_axi_control_ARVALID        ( s_axi_control_arvalid ),
  .s_axi_control_ARREADY        ( s_axi_control_arready ),
  .s_axi_control_ARADDR         ( s_axi_control_araddr  ),
  .s_axi_control_RVALID         ( s_axi_control_rvalid  ),
  .s_axi_control_RREADY         ( s_axi_control_rready  ),
  .s_axi_control_RDATA          ( s_axi_control_rdata   ),
  .s_axi_control_RRESP          ( s_axi_control_rresp   ),
  .s_axi_control_BVALID         ( s_axi_control_bvalid  ),
  .s_axi_control_BREADY         ( s_axi_control_bready  ),
  .s_axi_control_BRESP          ( s_axi_control_bresp   ),
  .m00_axi_im_awvalid ( m00_axi_im_awvalid ),
  .m00_axi_im_awready ( m00_axi_im_awready ),
  .m00_axi_im_awaddr  ( m00_axi_im_awaddr  ),
  .m00_axi_im_awlen   ( m00_axi_im_awlen   ),
  
  .m00_axi_im_awid     (m00_axi_im_awid    ) ,
  .m00_axi_im_awsize   (m00_axi_im_awsize  ) , 
  .m00_axi_im_awburst  (m00_axi_im_awburst ) ,
  .m00_axi_im_awlock   (m00_axi_im_awlock  ) ,
  .m00_axi_im_awcache  (m00_axi_im_awcache ) ,
  .m00_axi_im_awprot   (m00_axi_im_awprot  ) ,
  .m00_axi_im_awqos    (m00_axi_im_awqos   ) ,
  .m00_axi_im_awregion (m00_axi_im_awregion) , 
  .m00_axi_im_arid     (m00_axi_im_arid    ) ,
  .m00_axi_im_arsize   (m00_axi_im_arsize  ) ,
  .m00_axi_im_arburst  (m00_axi_im_arburst ) ,
  .m00_axi_im_arlock   (m00_axi_im_arlock  ) ,
  .m00_axi_im_arcache  (m00_axi_im_arcache ) ,
  .m00_axi_im_arprot   (m00_axi_im_arprot  ) ,
  .m00_axi_im_arqos    (m00_axi_im_arqos   ) ,
  .m00_axi_im_arregion (m00_axi_im_arregion) , 
  .m00_axi_im_bresp    (m00_axi_im_bresp   ) ,
  .m00_axi_im_bid      (m00_axi_im_bid     ) ,
  
  .m00_axi_im_wvalid  ( m00_axi_im_wvalid  ),
  .m00_axi_im_wready  ( m00_axi_im_wready  ),
  .m00_axi_im_wdata   ( m00_axi_im_wdata   ),
  .m00_axi_im_wstrb   ( m00_axi_im_wstrb   ),
  .m00_axi_im_wlast   ( m00_axi_im_wlast   ),
  .m00_axi_im_bvalid  ( m00_axi_im_bvalid  ),
  .m00_axi_im_bready  ( m00_axi_im_bready  ),
  .m00_axi_im_arvalid ( m00_axi_im_arvalid ),
  .m00_axi_im_arready ( m00_axi_im_arready ),
  .m00_axi_im_araddr  ( m00_axi_im_araddr  ),
  .m00_axi_im_arlen   ( m00_axi_im_arlen   ),
  .m00_axi_im_rvalid  ( m00_axi_im_rvalid  ),
  .m00_axi_im_rready  ( m00_axi_im_rready  ),
  .m00_axi_im_rdata   ( m00_axi_im_rdata   ),
  .m00_axi_im_rlast   ( m00_axi_im_rlast   ),
  .m01_axi_wm_awvalid ( m01_axi_wm_awvalid ),
  .m01_axi_wm_awready ( m01_axi_wm_awready ),
  .m01_axi_wm_awaddr  ( m01_axi_wm_awaddr  ),
  .m01_axi_wm_awlen   ( m01_axi_wm_awlen   ),

  .m01_axi_wm_awid    (m01_axi_wm_awid    ) ,
  .m01_axi_wm_awsize  (m01_axi_wm_awsize  ) ,
  
  .m01_axi_wm_wvalid  ( m01_axi_wm_wvalid  ),
  .m01_axi_wm_wready  ( m01_axi_wm_wready  ),
  .m01_axi_wm_wdata   ( m01_axi_wm_wdata   ),
  .m01_axi_wm_wstrb   ( m01_axi_wm_wstrb   ),
  .m01_axi_wm_wlast   ( m01_axi_wm_wlast   ),
  .m01_axi_wm_bvalid  ( m01_axi_wm_bvalid  ),
  .m01_axi_wm_bready  ( m01_axi_wm_bready  ),
  .m01_axi_wm_arvalid ( m01_axi_wm_arvalid ),
  .m01_axi_wm_arready ( m01_axi_wm_arready ),
  .m01_axi_wm_araddr  ( m01_axi_wm_araddr  ),
  .m01_axi_wm_arlen   ( m01_axi_wm_arlen   ),
  .m01_axi_wm_rvalid  ( m01_axi_wm_rvalid  ),
  .m01_axi_wm_rready  ( m01_axi_wm_rready  ),
  .m01_axi_wm_rdata   ( m01_axi_wm_rdata   ),
  .m01_axi_wm_rlast   ( m01_axi_wm_rlast   ),
  
  .m01_axi_wm_awburst (m01_axi_wm_awburst ) ,
  .m01_axi_wm_awlock  (m01_axi_wm_awlock  ) ,
  .m01_axi_wm_awcache (m01_axi_wm_awcache ) ,
  .m01_axi_wm_awprot  (m01_axi_wm_awprot  ) ,
  .m01_axi_wm_awqos   (m01_axi_wm_awqos   ) ,
  .m01_axi_wm_awregion(m01_axi_wm_awregion) ,     
  .m01_axi_wm_arid    (m01_axi_wm_arid    ) ,
  .m01_axi_wm_arsize  (m01_axi_wm_arsize  ) ,
  .m01_axi_wm_arburst (m01_axi_wm_arburst ) ,
  .m01_axi_wm_arlock  (m01_axi_wm_arlock  ) ,
  .m01_axi_wm_arcache (m01_axi_wm_arcache ) ,
  .m01_axi_wm_arprot  (m01_axi_wm_arprot  ) ,
  .m01_axi_wm_arqos   (m01_axi_wm_arqos   ) ,
  .m01_axi_wm_arregion(m01_axi_wm_arregion) ,        
  .m01_axi_wm_bresp   (m01_axi_wm_bresp   )  ,
  .m01_axi_wm_bid     (m01_axi_wm_bid     )  

  // .ap_start           ( ap_start           ),
  // .ap_done            ( ap_done            ),
  // .ap_idle            ( ap_idle            ),
  // .addwm_strength     ( addwm_strength     ),
  // .im_input_addr      ( im_input_addr      ),
  // .wm_input_addr      ( wm_input_addr      ),
  // .im_output_addr     ( im_output_addr     ),
  // .im_input_size      ( im_input_size      ),
  // .wm_input_size      ( wm_input_size      ),
  // .im_output_size     ( im_output_size     ),
  // .axi00_im           ( axi00_im           ),
  // .axi01_wm           ( axi01_wm           )
);

endmodule
`default_nettype wire

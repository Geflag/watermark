// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1 ns / 1 ps
// Top level of the kernel. Do not modify module name, parameters or ports.
module sdx_kernel_addwm #(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12 ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32 ,
  parameter integer C_M00_AXI_IM_ADDR_WIDTH    = 64 ,
  parameter integer C_M00_AXI_IM_DATA_WIDTH    = 512,
  parameter integer C_M01_AXI_WM_ADDR_WIDTH    = 64 ,
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
  input  wire                                    m00_axi_im_rvalid    ,
  output wire                                    m00_axi_im_rready    ,
  input  wire [C_M00_AXI_IM_DATA_WIDTH-1:0]      m00_axi_im_rdata     ,
  input  wire                                    m00_axi_im_rlast     ,
  // AXI4 master interface m01_axi_wm
  output wire                                    m01_axi_wm_awvalid   ,
  input  wire                                    m01_axi_wm_awready   ,
  output wire [C_M01_AXI_WM_ADDR_WIDTH-1:0]      m01_axi_wm_awaddr    ,
  output wire [8-1:0]                            m01_axi_wm_awlen     ,
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
wire [32-1:0]                       p00                           ;
wire [32-1:0]                       p01                           ;
wire [32-1:0]                       p10                           ;
wire [32-1:0]                       p11                           ;
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
sdx_kernel_addwm_control_s_axi #(
  .C_ADDR_WIDTH ( C_S_AXI_CONTROL_ADDR_WIDTH ),
  .C_DATA_WIDTH ( C_S_AXI_CONTROL_DATA_WIDTH )
)
inst_control_s_axi (
  .aclk      ( ap_clk                ),
  .areset    ( areset                ),
  .aclk_en   ( 1'b1                  ),
  .awvalid   ( s_axi_control_awvalid ),
  .awready   ( s_axi_control_awready ),
  .awaddr    ( s_axi_control_awaddr  ),
  .wvalid    ( s_axi_control_wvalid  ),
  .wready    ( s_axi_control_wready  ),
  .wdata     ( s_axi_control_wdata   ),
  .wstrb     ( s_axi_control_wstrb   ),
  .arvalid   ( s_axi_control_arvalid ),
  .arready   ( s_axi_control_arready ),
  .araddr    ( s_axi_control_araddr  ),
  .rvalid    ( s_axi_control_rvalid  ),
  .rready    ( s_axi_control_rready  ),
  .rdata     ( s_axi_control_rdata   ),
  .rresp     ( s_axi_control_rresp   ),
  .bvalid    ( s_axi_control_bvalid  ),
  .bready    ( s_axi_control_bready  ),
  .bresp     ( s_axi_control_bresp   ),
  .interrupt ( interrupt             ),
  .ap_start  ( ap_start              ),
  .ap_done   ( ap_done               ),
  .ap_idle   ( ap_idle               ),
  .p00       ( p00                   ),
  .p01       ( p01                   ),
  .p10       ( p10                   ),
  .p11       ( p11                   ),
  .axi00_im  ( axi00_im              ),
  .axi01_wm  ( axi01_wm              )
);

///////////////////////////////////////////////////////////////////////////////
// Add kernel logic here.  Modify/remove example code as necessary.
///////////////////////////////////////////////////////////////////////////////

// Example RTL block.  Remove to insert custom logic.
sdx_kernel_addwm_example #(
  .C_M00_AXI_IM_ADDR_WIDTH ( C_M00_AXI_IM_ADDR_WIDTH ),
  .C_M00_AXI_IM_DATA_WIDTH ( C_M00_AXI_IM_DATA_WIDTH ),
  .C_M01_AXI_WM_ADDR_WIDTH ( C_M01_AXI_WM_ADDR_WIDTH ),
  .C_M01_AXI_WM_DATA_WIDTH ( C_M01_AXI_WM_DATA_WIDTH )
)
inst_example (
  .ap_clk             ( ap_clk             ),
  .ap_rst_n           ( ap_rst_n           ),
  .m00_axi_im_awvalid ( m00_axi_im_awvalid ),
  .m00_axi_im_awready ( m00_axi_im_awready ),
  .m00_axi_im_awaddr  ( m00_axi_im_awaddr  ),
  .m00_axi_im_awlen   ( m00_axi_im_awlen   ),
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
  .ap_start           ( ap_start           ),
  .ap_done            ( ap_done            ),
  .ap_idle            ( ap_idle            ),
  .p00                ( p00                ),
  .p01                ( p01                ),
  .p10                ( p10                ),
  .p11                ( p11                ),
  .axi00_im           ( axi00_im           ),
  .axi01_wm           ( axi01_wm           )
);

endmodule
`default_nettype wire

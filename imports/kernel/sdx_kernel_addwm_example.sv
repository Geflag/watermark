// This is a generated file. Use and modify at your own risk.
//////////////////////////////////////////////////////////////////////////////// 
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
module sdx_kernel_addwm_example #(
  parameter integer C_M00_AXI_IM_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_IM_DATA_WIDTH = 512,
  parameter integer C_M01_AXI_WM_ADDR_WIDTH = 64 ,
  parameter integer C_M01_AXI_WM_DATA_WIDTH = 128
)
(
  // System Signals
  input  wire                                 ap_clk            ,
  input  wire                                 ap_rst_n          ,
  // AXI4 master interface m00_axi_im
  output wire                                 m00_axi_im_awvalid,
  input  wire                                 m00_axi_im_awready,
  output wire [C_M00_AXI_IM_ADDR_WIDTH-1:0]   m00_axi_im_awaddr ,
  output wire [8-1:0]                         m00_axi_im_awlen  ,
  output wire                                 m00_axi_im_wvalid ,
  input  wire                                 m00_axi_im_wready ,
  output wire [C_M00_AXI_IM_DATA_WIDTH-1:0]   m00_axi_im_wdata  ,
  output wire [C_M00_AXI_IM_DATA_WIDTH/8-1:0] m00_axi_im_wstrb  ,
  output wire                                 m00_axi_im_wlast  ,
  input  wire                                 m00_axi_im_bvalid ,
  output wire                                 m00_axi_im_bready ,
  output wire                                 m00_axi_im_arvalid,
  input  wire                                 m00_axi_im_arready,
  output wire [C_M00_AXI_IM_ADDR_WIDTH-1:0]   m00_axi_im_araddr ,
  output wire [8-1:0]                         m00_axi_im_arlen  ,
  input  wire                                 m00_axi_im_rvalid ,
  output wire                                 m00_axi_im_rready ,
  input  wire [C_M00_AXI_IM_DATA_WIDTH-1:0]   m00_axi_im_rdata  ,
  input  wire                                 m00_axi_im_rlast  ,
  // AXI4 master interface m01_axi_wm
  output wire                                 m01_axi_wm_awvalid,
  input  wire                                 m01_axi_wm_awready,
  output wire [C_M01_AXI_WM_ADDR_WIDTH-1:0]   m01_axi_wm_awaddr ,
  output wire [8-1:0]                         m01_axi_wm_awlen  ,
  output wire                                 m01_axi_wm_wvalid ,
  input  wire                                 m01_axi_wm_wready ,
  output wire [C_M01_AXI_WM_DATA_WIDTH-1:0]   m01_axi_wm_wdata  ,
  output wire [C_M01_AXI_WM_DATA_WIDTH/8-1:0] m01_axi_wm_wstrb  ,
  output wire                                 m01_axi_wm_wlast  ,
  input  wire                                 m01_axi_wm_bvalid ,
  output wire                                 m01_axi_wm_bready ,
  output wire                                 m01_axi_wm_arvalid,
  input  wire                                 m01_axi_wm_arready,
  output wire [C_M01_AXI_WM_ADDR_WIDTH-1:0]   m01_axi_wm_araddr ,
  output wire [8-1:0]                         m01_axi_wm_arlen  ,
  input  wire                                 m01_axi_wm_rvalid ,
  output wire                                 m01_axi_wm_rready ,
  input  wire [C_M01_AXI_WM_DATA_WIDTH-1:0]   m01_axi_wm_rdata  ,
  input  wire                                 m01_axi_wm_rlast  ,
  // SDx Control Signals
  input  wire                                 ap_start          ,
  output wire                                 ap_idle           ,
  output wire                                 ap_done           ,
  input  wire [32-1:0]                        p00               ,//addwm strength
  input  wire [32-1:0]                        p01               ,//im read length
  input  wire [32-1:0]                        p10               ,//im write length
  input  wire [32-1:0]                        p11               ,//wm read length
  input  wire [64-1:0]                        axi00_im          ,
  input  wire [64-1:0]                        axi01_wm          
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 2;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b0;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [32-1:0]                       ctrl_constant                  = 32'd1;


logic [C_M01_AXI_WM_DATA_WIDTH-1:0]  wm_to_kernel_data  ;
logic                                wm_to_kernel_valid ;
logic                                wm_to_kernel_ready ;
logic                                wm_to_kernel_last  ;
logic                                wm_rd_done         ;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_start_pulse | ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r;

// im example
sdx_kernel_addwm_example_vadd_im #(
  .C_M_AXI_ADDR_WIDTH ( C_M00_AXI_IM_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M00_AXI_IM_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                      ),
  .C_XFER_SIZE_WIDTH  ( 32                      )
)
inst_example_vadd_m00_axi_im (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi00_im                ),
  //.ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ),
  .rd_ctrl_xfer_size_in_bytes ( p01                  ),
  .wr_ctrl_xfer_size_in_bytes ( p02                  ),
  .ctrl_constant           ( 32'b1                   ),
  .ap_start                ( ap_start_pulse          ),
  .ap_done                 ( ap_done_i[0]            ),
  .m_axi_awvalid           ( m00_axi_im_awvalid      ),
  .m_axi_awready           ( m00_axi_im_awready      ),
  .m_axi_awaddr            ( m00_axi_im_awaddr       ),
  .m_axi_awlen             ( m00_axi_im_awlen        ),
  .m_axi_wvalid            ( m00_axi_im_wvalid       ),
  .m_axi_wready            ( m00_axi_im_wready       ),
  .m_axi_wdata             ( m00_axi_im_wdata        ),
  .m_axi_wstrb             ( m00_axi_im_wstrb        ),
  .m_axi_wlast             ( m00_axi_im_wlast        ),
  .m_axi_bvalid            ( m00_axi_im_bvalid       ),
  .m_axi_bready            ( m00_axi_im_bready       ),
  .m_axi_arvalid           ( m00_axi_im_arvalid      ),
  .m_axi_arready           ( m00_axi_im_arready      ),
  .m_axi_araddr            ( m00_axi_im_araddr       ),
  .m_axi_arlen             ( m00_axi_im_arlen        ),
  .m_axi_rvalid            ( m00_axi_im_rvalid       ),
  .m_axi_rready            ( m00_axi_im_rready       ),
  .m_axi_rdata             ( m00_axi_im_rdata        ),
  .m_axi_rlast             ( m00_axi_im_rlast        ),
  //watermark to kernel
  .wm_to_kernel_data       (wm_to_kernel_data        ),
  .wm_to_kernel_valid      (wm_to_kernel_valid       ),
  .wm_to_kernel_last       (wm_to_kernel_last        ),
  .wm_to_kernel_ready      (wm_to_kernel_ready       ),
  .wm_rd_done              (wm_rd_done               )
);


// wm example
sdx_kernel_addwm_example_vadd_wm #(
  .C_M_AXI_ADDR_WIDTH ( C_M01_AXI_WM_ADDR_WIDTH ),
  .C_M_AXI_DATA_WIDTH ( C_M01_AXI_WM_DATA_WIDTH ),
  .C_ADDER_BIT_WIDTH  ( 32                      ),
  .C_XFER_SIZE_WIDTH  ( 32                      )
)
inst_example_vadd_m01_axi_wm (
  .aclk                    ( ap_clk                  ),
  .areset                  ( areset                  ),
  .kernel_clk              ( ap_clk                  ),
  .kernel_rst              ( areset                  ),
  .ctrl_addr_offset        ( axi01_wm                ),
  //.ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ),
  .ctrl_xfer_size_in_bytes ( p11                     ),
  .ctrl_constant           ( 32'b1                   ),
  .ap_start                ( ap_start_pulse          ),
  .ap_done                 ( ap_done_i[1]            ),
  .m_axi_awvalid           ( m01_axi_wm_awvalid      ),
  .m_axi_awready           ( m01_axi_wm_awready      ),
  .m_axi_awaddr            ( m01_axi_wm_awaddr       ),
  .m_axi_awlen             ( m01_axi_wm_awlen        ),
  .m_axi_wvalid            ( m01_axi_wm_wvalid       ),
  .m_axi_wready            ( m01_axi_wm_wready       ),
  .m_axi_wdata             ( m01_axi_wm_wdata        ),
  .m_axi_wstrb             ( m01_axi_wm_wstrb        ),
  .m_axi_wlast             ( m01_axi_wm_wlast        ),
  .m_axi_bvalid            ( m01_axi_wm_bvalid       ),
  .m_axi_bready            ( m01_axi_wm_bready       ),
  .m_axi_arvalid           ( m01_axi_wm_arvalid      ),
  .m_axi_arready           ( m01_axi_wm_arready      ),
  .m_axi_araddr            ( m01_axi_wm_araddr       ),
  .m_axi_arlen             ( m01_axi_wm_arlen        ),
  .m_axi_rvalid            ( m01_axi_wm_rvalid       ),
  .m_axi_rready            ( m01_axi_wm_rready       ),
  .m_axi_rdata             ( m01_axi_wm_rdata        ),
  .m_axi_rlast             ( m01_axi_wm_rlast        ),
  //watermark to kernel
  .wm_to_kernel_data       (wm_to_kernel_data        ),
  .wm_to_kernel_valid      (wm_to_kernel_valid       ),
  .wm_to_kernel_last       (wm_to_kernel_last        ),
  .wm_to_kernel_ready      (wm_to_kernel_ready       )
);


endmodule : sdx_kernel_addwm_example
`default_nettype wire

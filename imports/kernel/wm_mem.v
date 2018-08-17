/* 128-bit WaterMark input band width, into 4-bit output, 
    -- Port delay  is 2 clk cycle  (from i_rea to o_w_data)

*/

module wm_mem 
#(
  parameter integer FIFO_DEPTH    = 512,         //  Must be lager than 312.5;
  parameter integer WM_BAND_WIDTH = 128,
  parameter integer DOP           = 4,
  parameter integer WM_CNT        =   313
)
(
    input                       clk,
    input                       rst_n,
    input                       i_done,

    input   [WM_BAND_WIDTH-1:0]    i_w_data,
    input                       i_wea,
    output                      o_wm_cnt_last,

    output  [DOP-1:0]           o_w_data,
    input                       i_rea
);


  function integer clog2;
      input integer value;

      for(clog2 = 0; value > 0; clog2 = clog2 + 1) begin
          value = value >> 1;
      end
  endfunction


  localparam    integer     LP_FIFO_CNT_WIDTH = clog2(FIFO_DEPTH-1);
  localparam    integer     LP_CNT_ROW_END = WM_BAND_WIDTH / DOP;              // 32
  localparam    integer     LP_CNT_ROW_WIDTH = clog2(LP_CNT_ROW_END-1);     // 5



  // fifo
  wire  [WM_BAND_WIDTH-1:0]  w_fifo_dout;
  wire                    w_fifo_rd_en;

  reg [LP_FIFO_CNT_WIDTH-1:0] wm_read_cnt;
  reg [LP_CNT_ROW_WIDTH-1:0]  bit_cnt;
  reg [WM_BAND_WIDTH-1:0]        r_fifo_dout;

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n)              wm_read_cnt <= 0;
    else if(i_done)         wm_read_cnt <= 0;
    else if(i_wea)          wm_read_cnt <= (wm_read_cnt== WM_CNT-1) ? 0 : wm_read_cnt+1;
    else; 
  end

  always@( posedge clk or negedge rst_n) begin
    if(!rst_n)                bit_cnt <= 0;
    else if (i_done)          bit_cnt <= 0;
    else if (i_rea)           bit_cnt <= (bit_cnt == LP_CNT_ROW_END-1) ? 0 : bit_cnt + 1;
    else;
  end

  always@( posedge clk or negedge rst_n) begin
    if(!rst_n)                r_fifo_dout <= 0;
    else if(i_done)           r_fifo_dout <= 0;
    else if(i_rea) begin
      if(bit_cnt == 0)        r_fifo_dout <= w_fifo_dout >> DOP;
      else                    r_fifo_dout <= r_fifo_dout >> DOP;
    end
  end

  assign o_w_data = (bit_cnt == 0) ? w_fifo_dout[DOP-1:0] : r_fifo_dout[DOP-1:0];
  assign w_fifo_rd_en = (bit_cnt == 0) && i_rea;
  assign o_wm_cnt_last = i_wea && (wm_read_cnt == WM_CNT - 1);
  
  // xpm_fifo_sync: Synchronous FIFO
  // Xilinx Parameterized Macro, Version 2017.4
  
  wire  wm_mem_empty;
  wire [LP_FIFO_CNT_WIDTH-1:0] wm_mem_rd_cnt;
  wire  [LP_FIFO_CNT_WIDTH-1:0] wm_mem_wr_cnt;
  xpm_fifo_sync # (

  .FIFO_MEMORY_TYPE          ("auto"              ),              //string; "auto", "block", "distributed", or "ultra";
  .ECC_MODE                  ("no_ecc"            ),              //string; "no_ecc" or "en_ecc";
  .FIFO_WRITE_DEPTH          (FIFO_DEPTH          ),              //positive integer
  .WRITE_DATA_WIDTH          (WM_BAND_WIDTH          ),              //positive integer
  .WR_DATA_COUNT_WIDTH       (LP_FIFO_CNT_WIDTH   ),              //positive integer
  .PROG_FULL_THRESH          (10                  ),              //positive integer
  .FULL_RESET_VALUE          (0                   ),              //positive integer; 0 or 1
  .USE_ADV_FEATURES          ("0707"              ),              //string; "0000" to "1F1F"; 
  .READ_MODE                 ("fwft"              ),              //string; "std" or "fwft";
  .FIFO_READ_LATENCY         (0                   ),              //positive integer;
  .READ_DATA_WIDTH           (WM_BAND_WIDTH          ),              //positive integer
  .RD_DATA_COUNT_WIDTH       (LP_FIFO_CNT_WIDTH   ),              //positive integer
  .PROG_EMPTY_THRESH         (10                  ),              //positive integer
  .DOUT_RESET_VALUE          ("0"                 ),              //string
  .WAKEUP_TIME               (0                   )               //positive integer; 0 or 2;

  ) xpm_fifo_sync_inst (

  .sleep            (1'b0                     ),
  .rst              ((!rst_n) || i_done       ),
  .wr_clk           (clk                      ),
  .wr_en            (i_wea                    ),
  .din              (i_w_data                 ),
  .full             (                         ),
  .overflow         (                         ),
  .prog_full        (                         ),
  .wr_data_count    (                         ),
  .almost_full      (                         ),
  .wr_ack           (                         ),
  .wr_rst_busy      (                         ),
  .rd_en            (w_fifo_rd_en             ),
  .dout             (w_fifo_dout              ),
  .empty            (wm_mem_empty             ),
  .prog_empty       (                         ),
  .rd_data_count    (                         ),
  .almost_empty     (                         ),
  .data_valid       (                         ),
  .underflow        (                         ),
  .rd_rst_busy      (                         ),
  .injectsbiterr    (1'b0                     ),
  .injectdbiterr    (1'b0                     ),
  .sbiterr          (                         ),
  .dbiterr          (                         )

  );
endmodule
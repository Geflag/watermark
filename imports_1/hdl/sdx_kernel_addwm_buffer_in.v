module buffer_in
#(
    parameter BAND_WIDTH    = 512,
    parameter FIFO_DEPTH    = 128,
    parameter BLK_WIDTH     = 4,
    parameter IM_CHN_CNT    = 4
)
(
    clk,
    rst_n,
    i_done,

    i_im_data,
    i_im_vld,
    o_im_data,
    o_im_vld,
    
    o_im_in_last
);

    input    clk            ;
    input    rst_n          ;
    input    i_done         ;

    input  [BAND_WIDTH-1:0]                 i_im_data       ;
    input                                   i_im_vld        ;
    output [BLK_WIDTH * BAND_WIDTH-1:0]     o_im_data       ;
    output                                  o_im_vld        ;
    output                                  o_im_in_last    ;

    function integer clog2;
        input integer value;

        for(clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
        end
    endfunction

    localparam          LP_FIFO_CNT_WIDTH = clog2(FIFO_DEPTH-1);

    localparam          IM_WIDTH      = 800;
    localparam          IM_DATA_WIDTH = 8;

    localparam          COL_CNT = (IM_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) / (BAND_WIDTH);
    localparam          ROW_CNT = IM_WIDTH;
    // localparam          CHANNEL_CNT = 1;
    localparam          FIFO_IN_CNT = COL_CNT;

    localparam          COL_CNT_WIDTH = clog2(COL_CNT-1);
    localparam          ROW_CNT_WIDTH = clog2(ROW_CNT-1);
    // localparam          CHANNEL_CNT_WIDTH = 2; //clog2(CHANNEL_CNT-1);
    localparam          FIFO_IN_CNT_WIDTH = clog2(FIFO_IN_CNT-1);

    /* Decalration */   
    reg     [COL_CNT_WIDTH-1:0]             r_col_cnt;
    reg     [ROW_CNT_WIDTH-1:0]             r_row_cnt;
    // reg     [CHANNEL_CNT_WIDTH-1:0]         r_chn_cnt;
    wire    w_col_cnt_last;
    wire    w_row_cnt_last;
    // wire    w_chn_cnt_last;

    wire    w_fifo_in_rd_en;

    /* Control-block */
    
    // COUNTER
    assign w_col_cnt_last = i_im_vld        && (r_col_cnt == (COL_CNT-1)    );
    assign w_row_cnt_last = w_col_cnt_last  && (r_row_cnt == (ROW_CNT-1)    );
    // assign w_chn_cnt_last = w_row_cnt_last  && (r_chn_cnt == (CHANNEL_CNT-1));

    always@(posedge clk or negedge rst_n)   begin
        if(~rst_n)                  r_col_cnt <= 0;
        else if(i_done)             r_col_cnt <= 0;
        else if(i_im_vld)           r_col_cnt <= w_col_cnt_last ? 0 : r_col_cnt + 1;
        else;
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)                  r_row_cnt <= 0;
        else if(i_done)             r_row_cnt <= 0;
        else if(w_col_cnt_last)     r_row_cnt <= w_row_cnt_last ? 0 : r_row_cnt + 1;
        else;
    end

    // always @(posedge clk or negedge rst_n) begin
    //     if(~rst_n)                  r_chn_cnt <= 0;
    //     else if(i_done)             r_chn_cnt <= 0;
    //     else if(w_row_cnt_last)     r_chn_cnt <= w_chn_cnt_last ? 0 : r_chn_cnt + 1;
    //     else;
    // end
    
    /* FIFO-BLOCK */

    wire    [BLK_WIDTH-2:0]             w_fifo_in_wr_en;
    
    assign w_fifo_in_rd_en = (r_row_cnt[1:0] == 2'b11) && (i_im_vld);
    assign o_im_vld = w_fifo_in_rd_en;
    assign o_im_in_last = w_row_cnt_last;

    genvar blk_idx;
    generate
        for (blk_idx = 0 ; blk_idx < BLK_WIDTH  ; blk_idx= blk_idx + 1 ) begin : fifo_in

            if (blk_idx == BLK_WIDTH - 1) begin

                assign o_im_data[blk_idx * BAND_WIDTH +: BAND_WIDTH] = i_im_data;

            end else  begin 

                // xpm_fifo_sync: Synchronous FIFO
                // Xilinx Parameterized Macro, Version 2017.4
                wire  [BAND_WIDTH-1:0]  w_fifo_dout;
                
                xpm_fifo_sync # (

                .FIFO_MEMORY_TYPE          ("auto"              ),              //string; "auto", "block", "distributed", or "ultra";
                .ECC_MODE                  ("no_ecc"            ),              //string; "no_ecc" or "en_ecc";
                .FIFO_WRITE_DEPTH          (FIFO_DEPTH          ),              //positive integer
                .WRITE_DATA_WIDTH          (BAND_WIDTH          ),              //positive integer
                .WR_DATA_COUNT_WIDTH       (LP_FIFO_CNT_WIDTH   ),              //positive integer
                .PROG_FULL_THRESH          (10                  ),              //positive integer
                .FULL_RESET_VALUE          (0                   ),              //positive integer; 0 or 1
                .USE_ADV_FEATURES          ("0707"              ),              //string; "0000" to "1F1F"; 
                .READ_MODE                 ("fwft"              ),              //string; "std" or "fwft";
                .FIFO_READ_LATENCY         (0                   ),              //positive integer;
                .READ_DATA_WIDTH           (BAND_WIDTH          ),              //positive integer
                .RD_DATA_COUNT_WIDTH       (LP_FIFO_CNT_WIDTH   ),              //positive integer
                .PROG_EMPTY_THRESH         (10                  ),              //positive integer
                .DOUT_RESET_VALUE          ("0"                 ),              //string
                .WAKEUP_TIME               (0                   )               //positive integer; 0 or 2;

                ) xpm_fifo_sync_inst (

                .sleep            (1'b0                     ),
                .rst              (!rst_n                   ),
                .wr_clk           (clk                      ),
                .wr_en            (w_fifo_in_wr_en[blk_idx] ),
                .din              (i_im_data                ),
                .full             (                         ),
                .overflow         (                         ),
                .prog_full        (                         ),
                .wr_data_count    (                         ),
                .almost_full      (                         ),
                .wr_ack           (                         ),
                .wr_rst_busy      (                         ),
                .rd_en            (w_fifo_in_rd_en          ),
                .dout             (w_fifo_dout              ),
                .empty            (                         ),
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

                assign w_fifo_in_wr_en[blk_idx] = i_im_vld && (r_row_cnt[1:0] == blk_idx) ;
                assign o_im_data[blk_idx * BAND_WIDTH +: BAND_WIDTH] = w_fifo_dout;

            end
        end

        
    endgenerate




endmodule
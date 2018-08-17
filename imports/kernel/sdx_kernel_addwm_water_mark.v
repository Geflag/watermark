module water_mark (
    clk,
    rst_n,
    i_done,

    S_axis_wm_tdata,
    S_axis_wm_tvalid,
    S_axis_wm_tready,
    S_axis_wm_tlast,

    S_axis_im_tdata,
    S_axis_im_tvalid,
    S_axis_im_tready,
    S_axis_im_tlast,

    M_axis_im_tdata,
    M_axis_im_tvalid,
    M_axis_im_tready,
    M_axis_im_tlast
);
    
    function integer clog2;
        input integer value;

        for(clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
        end
    endfunction

    localparam BAND_WIDTH    = 512;
    localparam WM_BAND_WIDTH = 128;                              // 128

    localparam BLK_WIDTH     = 4;
    localparam IM_WIDTH      = 800;
    localparam IM_DATA_WIDTH = 8;
    localparam IM_CHN_CNT    = 4;
    
    genvar      row;
    localparam          DATA_SIZE = BAND_WIDTH / (IM_DATA_WIDTH * IM_CHN_CNT);              // Number of Pixel per read;
    localparam          DOP = BAND_WIDTH / (IM_DATA_WIDTH * BLK_WIDTH * IM_CHN_CNT);      // Degree of Parallelism
    localparam          BLK_SIZE = BLK_WIDTH * BLK_WIDTH;
    localparam          WM_CNT  = ( (40000 - 1) / WM_BAND_WIDTH) + 1;            // 313
    // localparam          COL_CNT = IM_WIDTH / (BAND_WIDTH / IM_DATA_WIDTH);  //
    // localparam          ROW_CNT = IM_WIDTH;                                 // 800
    // localparam          FIFO_IN_CNT = COL_CNT;
    // localparam          WM_CNT_WIDTH  = clog2(WM_CNT-1);
    // localparam          COL_CNT_WIDTH = clog2(COL_CNT-1);
    // localparam          ROW_CNT_WIDTH = clog2(ROW_CNT-1);
    // localparam          FIFO_IN_CNT_WIDTH = clog2(FIFO_IN_CNT-1);

    input                           clk;
    input                           rst_n;
    input                           i_done;

    input       [BAND_WIDTH-1:0]    S_axis_wm_tdata;
    input                           S_axis_wm_tvalid;
    output      reg                 S_axis_wm_tready;
    input                           S_axis_wm_tlast;

    input       [BAND_WIDTH-1:0]    S_axis_im_tdata;            // 只有�??100个是有用的�??       
    input                           S_axis_im_tvalid;
    output      reg                 S_axis_im_tready;
    input                           S_axis_im_tlast;

    output      [BAND_WIDTH-1:0]    M_axis_im_tdata;
    output                          M_axis_im_tvalid;
    output                          M_axis_im_tready;
    output                          M_axis_im_tlast;


/* Declare */
    // WATER_MARK_IN
    wire    [DOP-1:0]           w_wm_dout;
    wire                        w_wm_wr_en;
    wire                        w_wm_rd_en;
    wire                        w_wm_cnt_last;

    // FIFO_IN
    wire    [BAND_WIDTH * BLK_WIDTH-1:0]    w_fifo_in_dout;
    wire                                    w_fifo_in_dout_vld;
    wire                                    w_fifo_in_last;
    wire                                    w_fifo_in_dout_last;

    // FIFO_OUT
    wire    [BLK_WIDTH * BAND_WIDTH-1:0]    w_fifo_out_din;

/* AXI_CONTROL */
    wire w_axis_wmin_vld, w_axis_wmin_last;
    wire w_axis_imin_vld, w_axis_imin_last;
    wire w_axis_imout_vld,w_axis_imout_last;
    reg  [1:0] r_axis_imout_last_ff2;

    assign w_axis_wmin_vld  = S_axis_wm_tvalid && S_axis_wm_tready;
    // assign w_axis_wmin_last = S_axis_wm_tvalid && S_axis_wm_tready && S_axis_wm_tlast;
    assign w_axis_wmin_last = S_axis_wm_tvalid && S_axis_wm_tready && w_wm_cnt_last;
    assign w_axis_imin_vld  = S_axis_im_tvalid && S_axis_im_tready;
    assign w_axis_imin_last = S_axis_im_tvalid && S_axis_im_tready && S_axis_im_tlast;
    assign w_axis_imout_vld = M_axis_im_tvalid && M_axis_im_tready;
    assign w_axis_imout_last= M_axis_im_tvalid && M_axis_im_tready && M_axis_im_tlast;

    always@(posedge clk or negedge rst_n)   begin
        if(~rst_n)                          S_axis_wm_tready <= 1;
        // else if(i_done)                  S_axis_wm_tready <= 1;
        else if(r_axis_imout_last_ff2[1])   S_axis_wm_tready <= 1;
        else if(w_axis_wmin_last)           S_axis_wm_tready <= 0;
        else;
    end

    always@(posedge clk or negedge rst_n)   begin
        if(~rst_n)                      S_axis_im_tready <= 0;
        else if(w_axis_imout_last)      S_axis_im_tready <= 0;
        else if(w_fifo_in_dout_last)    S_axis_im_tready <= 0;
        else if(w_axis_wmin_last)       S_axis_im_tready <= 1;
        // else if(r_chn_cnt_last)     S_axis_im_tready <= 0;
        else;   
    end

    always@(posedge clk or negedge rst_n)   begin
        r_axis_imout_last_ff2 <= {r_axis_imout_last_ff2[0],w_axis_imout_last};
    end

/* WATER_MARK_IN */

    assign w_wm_wr_en = w_axis_wmin_vld     ;
    assign w_wm_rd_en = w_fifo_in_dout_vld  ;

    wm_mem #(
        .FIFO_DEPTH     (512        ),
        .WM_BAND_WIDTH  (WM_BAND_WIDTH ),
        .DOP            (DOP        )       
    ) inst_wm_mem(
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .i_done             (w_axis_imout_last  ),
        .i_w_data           (S_axis_wm_tdata    ),
        .i_wea              (w_wm_wr_en         ),
        .o_wm_cnt_last      (w_wm_cnt_last      ),
        .o_w_data           (w_wm_dout          ),
        .i_rea              (w_wm_rd_en         )
    );

/* FIFO_IN */

    buffer_in   #(
        .BAND_WIDTH     (BAND_WIDTH     ),  
        .FIFO_DEPTH     (128            ),  
        .BLK_WIDTH      (BLK_WIDTH      ),
        .IM_CHN_CNT     (IM_CHN_CNT)
    ) inst_buffer_in(
        .clk             (clk                   ),
        .rst_n           (rst_n                 ),
        .i_done          (w_axis_imout_last     ),
        .i_im_data       (S_axis_im_tdata       ),
        .i_im_vld        (w_axis_imin_vld       ),
        .o_im_data       (w_fifo_in_dout        ),
        .o_im_vld        (w_fifo_in_dout_vld    ),
        .o_im_in_last    (w_fifo_in_dout_last   )
    );

/* PE */

    wire    [BLK_SIZE * IM_DATA_WIDTH -1:0]      w_pe_image_in  [DOP-1:0] [IM_CHN_CNT-2:0];
    wire    [BLK_SIZE * IM_DATA_WIDTH -1:0]      w_pe_image_out [DOP-1:0] [IM_CHN_CNT-2:0];
    reg                                         o_image_valid;

    genvar par_idx;
    genvar chn;
    genvar col;
    generate
        for(par_idx = 0; par_idx < DOP; par_idx = par_idx + 1)  begin:    PE_blk
            for (chn = 0; chn < IM_CHN_CNT; chn = chn + 1)      begin
                for(row = 0; row < BLK_WIDTH; row = row + 1)    begin
                    for(col = 0; col < BLK_WIDTH; col = col + 1)  begin
                        if(chn == 3) begin
                            // w_fifo_out_din[row * BAND_WIDTH + par_idx * (BLK_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) + col*(IM_DATA_WIDTH * IM_CHN_CNT) + chn*(IM_DATA_WIDTH) +: IM_DATA_WIDTH] = w_fifo_in_dout[row * BAND_WIDTH + par_idx * (BLK_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) + col*(IM_DATA_WIDTH * IM_CHN_CNT) + chn*(IM_DATA_WIDTH) +: IM_DATA_WIDTH];
                            assign w_fifo_out_din[row * BAND_WIDTH + par_idx * (BLK_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) + col*(IM_DATA_WIDTH * IM_CHN_CNT) + chn*(IM_DATA_WIDTH) +: IM_DATA_WIDTH] = 0;
                        end else begin
                            assign w_pe_image_in[par_idx][chn][row * (BLK_WIDTH * IM_DATA_WIDTH) + col * IM_DATA_WIDTH +: IM_DATA_WIDTH] = w_fifo_in_dout[row * BAND_WIDTH + par_idx * (BLK_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) + col*(IM_DATA_WIDTH * IM_CHN_CNT) + chn*(IM_DATA_WIDTH) +: IM_DATA_WIDTH];
                            assign w_fifo_out_din[row * BAND_WIDTH + par_idx * (BLK_WIDTH * IM_DATA_WIDTH * IM_CHN_CNT) + col*(IM_DATA_WIDTH * IM_CHN_CNT) + chn*(IM_DATA_WIDTH) +: IM_DATA_WIDTH] = w_pe_image_out[par_idx][chn][row * (BLK_WIDTH * IM_DATA_WIDTH) + col * IM_DATA_WIDTH +: IM_DATA_WIDTH];
                        end
                    end
                end
                
                if (chn < 3) begin
                    pe #(
                        .BLK_WIDTH     (BLK_WIDTH     ),
                        .IM_DATA_WIDTH (IM_DATA_WIDTH )
                    ) inst_pe (
                        .clk            (clk                            ),
                        .rst_n          (rst_n                          ),
                        .i_image        (w_pe_image_in[par_idx][chn]    ),
                        .i_image_valid  (w_fifo_in_dout_vld             ),
                        .i_watermark    (w_wm_dout[par_idx]             ),
                        .o_image        (w_pe_image_out[par_idx][chn]   )
                    );
                end else begin

                end
            end    
        end
    endgenerate

    always@(posedge clk or negedge rst_n)   begin
        if(~rst_n)          o_image_valid <= 0;
        else                o_image_valid <=  w_fifo_in_dout_vld;
    end

/* FIFO_OUT */
    buffer_out #(
        .BAND_WIDTH     (BAND_WIDTH     ),
        .FIFO_DEPTH     (128            ),
        .BLK_WIDTH      (BLK_WIDTH      ),
        .IM_CHN_CNT     (IM_CHN_CNT     )
    ) buffer_out_inst (
        .clk             (clk                       ),
        .rst_n           (rst_n                     ),
        .i_done          (w_axis_imout_last         ),
        .i_im_data       (w_fifo_out_din            ),
        .i_im_vld        (o_image_valid             ),
        .o_im_data       (M_axis_im_tdata           ),
        .o_im_vld        (M_axis_im_tvalid          ),
        .i_im_out_txfer  (w_axis_imout_vld          ),
        .o_im_out_last   (M_axis_im_tlast           )
    );

endmodule

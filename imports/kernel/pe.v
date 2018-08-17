module pe#(
    parameter  BLK_WIDTH        = 4,
    parameter  IM_DATA_WIDTH    = 8
)(
    clk,
    rst_n,

    i_image,
    i_image_valid,
    i_watermark,

    o_image
    
);
    localparam          BLK_SIZE            = BLK_WIDTH * BLK_WIDTH;    
    localparam          FDOMAIN_DATA_WIDTH  = IM_DATA_WIDTH + 6;
    localparam   signed MAX_IMDATA = {{(FDOMAIN_DATA_WIDTH-IM_DATA_WIDTH){1'b0}}, {(IM_DATA_WIDTH){1'b1}}};
    

    input       clk;
    input       rst_n;

    input   [BLK_SIZE * IM_DATA_WIDTH -1:0] i_image;
    input                                   i_image_valid;
    input                                   i_watermark;

    output  [BLK_SIZE * IM_DATA_WIDTH -1:0] o_image;       

/* DCT */

    wire  		[IM_DATA_WIDTH-1        :0]     M  	        [BLK_SIZE-1:0];
    wire signed [IM_DATA_WIDTH-1+3      :0]     M_col       [BLK_SIZE-1:0];
    wire signed [FDOMAIN_DATA_WIDTH-1   :0]     w_dct_out   [BLK_SIZE-1:0];

        genvar i,j;
    generate
        for(i=0; i<BLK_SIZE; i=i+1)   begin
            assign M[i] = i_image[IM_DATA_WIDTH*i+IM_DATA_WIDTH-1 : IM_DATA_WIDTH*i];
        end
    endgenerate

    generate
        for(j=0;j<4;j=j+1) begin: DCT_column_row
            DCT4#(												//column
                .WIDTH	('d8)
            )inst_DCT4_col(
                .A0		(M[j]		),
                .A1     (M[j+4]		),
                .A2     (M[j+8]		),
                .A3     (M[j+12]	),
                .B0     (M_col[j]	),
                .B1     (M_col[j+4]	),
                .B2     (M_col[j+8]	),
                .B3     (M_col[j+12])
            );
            
            DCT4#(												//row
                .WIDTH	('d11)
            )inst_DCT4_row(
                .A0		(M_col[4*j]		),
                .A1     (M_col[4*j+1]	),
                .A2     (M_col[4*j+2]	),
                .A3     (M_col[4*j+3]	),
                .B0     (w_dct_out[4*j]		),
                .B1     (w_dct_out[4*j+1]	),
                .B2     (w_dct_out[4*j+2]	),
                .B3     (w_dct_out[4*j+3]	)
            );
        end
    endgenerate

/* ADD-WATERMARK */

    // wire signed [FDOMAIN_DATA_WIDTH-1 : 0]     w_dct_out_wm;
    wire signed [FDOMAIN_DATA_WIDTH-1 : 0]     w_dct_out_shift;
    // wire signed [FDOMAIN_DATA_WIDTH-1 : 0]     w_dct_out_wm   [BLK_SIZE-1:0];
    reg  signed [FDOMAIN_DATA_WIDTH-1 : 0]     r_dct_out_wm   [BLK_SIZE-1:0];
    
    assign w_dct_out_shift = w_dct_out[0] >>> 6;
    // assign w_dct_out_shift = (w_dct_out[0] * 10'b0000010000) >>> 10;
    // assign w_dct_out_wm[0] = i_watermark  ? w_dct_out[0] + w_dct_out_shift : w_dct_out[0] - w_dct_out_shift;

    always@(posedge clk or negedge rst_n)   begin
        if(~rst_n)              r_dct_out_wm[0] <= 0;     
        else if(i_image_valid)  r_dct_out_wm[0] <= i_watermark ? w_dct_out[0] + w_dct_out_shift : w_dct_out[0] -w_dct_out_shift;
        else;
    end

    generate
        for(i=1; i<BLK_SIZE; i=i+1) begin
            always@(posedge clk or negedge rst_n)   begin
                if(~rst_n)              r_dct_out_wm[i] <= 0;     
                else if(i_image_valid)  r_dct_out_wm[i] <=  w_dct_out[i];
                else;
            end
        end
    endgenerate

/* IDCT */
    wire    signed [FDOMAIN_DATA_WIDTH-1:0] w_idct_row  [BLK_SIZE-1:0];
    wire    signed [FDOMAIN_DATA_WIDTH-1:0] w_idct_col  [BLK_SIZE-1:0];
    wire           [IM_DATA_WIDTH-1:0]      w_idct_out  [BLK_SIZE-1:0];

    generate
        for(j=0; j<BLK_WIDTH; j=j+1)    begin: IDCT_col_row
            IDCT4 # (
                .WIDTH(FDOMAIN_DATA_WIDTH)
            ) inst_IDCT4_row (
                .A0(r_dct_out_wm[j  ]   ),
                .A1(r_dct_out_wm[j+4]   ),
                .A2(r_dct_out_wm[j+8]   ),
                .A3(r_dct_out_wm[j+12]  ),
                .B0(w_idct_row[j]	    ),
                .B1(w_idct_row[j+4]	    ),
                .B2(w_idct_row[j+8]	    ),
                .B3(w_idct_row[j+12]    )
            );

            IDCT4 #( 
                .WIDTH(FDOMAIN_DATA_WIDTH)
            ) inst_IDCT4_col(
                .A0(w_idct_row[4*j]     ),
                .A1(w_idct_row[4*j+1]   ),
                .A2(w_idct_row[4*j+2]   ),
                .A3(w_idct_row[4*j+3]   ),
                .B0(w_idct_col[4*j]	    ),
                .B1(w_idct_col[4*j+1]   ),
                .B2(w_idct_col[4*j+2]   ),
                .B3(w_idct_col[4*j+3]   )
            );
        end

        for (i=0; i<BLK_SIZE; i=i+1)    begin: QUANT
            assign w_idct_out[i] = w_idct_col[i] < 0 ? 0 
                                    : w_idct_col[i] > MAX_IMDATA ? MAX_IMDATA 
                                    : w_idct_col[i][IM_DATA_WIDTH-1:0];
            assign o_image[i*IM_DATA_WIDTH +: IM_DATA_WIDTH] = w_idct_out[i];
        end

    endgenerate

endmodule
// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
// kernel: sdx_kernel_addwm
//
// Purpose: This kernel example shows a basic vector add +1 (constant) by
//          manipulating memory inplace.
//-----------------------------------------------------------------------------
#define BUFFER_SIZE 8192
#include <string.h>
#include <stdbool.h>
#include "hls_half.h"

// Do not modify function declaration
extern "C" void sdx_kernel_addwm (
    unsigned int p00,
    unsigned int p01,
    unsigned int p10,
    unsigned int p11,
    int* axi00_im,
    int* axi01_wm
) {

    #pragma HLS INTERFACE m_axi port=axi00_im offset=slave bundle=m00_axi_im
    #pragma HLS INTERFACE m_axi port=axi01_wm offset=slave bundle=m01_axi_wm
    #pragma HLS INTERFACE s_axilite port=p00 bundle=control
    #pragma HLS INTERFACE s_axilite port=p01 bundle=control
    #pragma HLS INTERFACE s_axilite port=p10 bundle=control
    #pragma HLS INTERFACE s_axilite port=p11 bundle=control
    #pragma HLS INTERFACE s_axilite port=axi00_im bundle=control
    #pragma HLS INTERFACE s_axilite port=axi01_wm bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

// Modify contents below to match the function of the RTL Kernel
    int i = 0;

    // Create input and output buffers for interface m00_axi_im
    int m00_axi_im_input_buffer[BUFFER_SIZE];
    int m00_axi_im_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m00_axi_im_length = 4096;


    // Assign input to a buffer
    memcpy(m00_axi_im_input_buffer, (int*) axi00_im, m00_axi_im_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m00_axi_im_length; i++) {
      m00_axi_im_output_buffer[i] = m00_axi_im_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi00_im, m00_axi_im_output_buffer, m00_axi_im_length*sizeof(int));


    // Create input and output buffers for interface m01_axi_wm
    int m01_axi_wm_input_buffer[BUFFER_SIZE];
    int m01_axi_wm_output_buffer[BUFFER_SIZE];


    // length is specified in number of words.
    unsigned int m01_axi_wm_length = 4096;


    // Assign input to a buffer
    memcpy(m01_axi_wm_input_buffer, (int*) axi01_wm, m01_axi_wm_length*sizeof(int));

    // Add 1 to input buffer and assign to output buffer.
    for (i = 0; i < m01_axi_wm_length; i++) {
      m01_axi_wm_output_buffer[i] = m01_axi_wm_input_buffer[i]  + 1;
    }

    // assign output buffer out to memory
    memcpy((int*) axi01_wm, m01_axi_wm_output_buffer, m01_axi_wm_length*sizeof(int));


}


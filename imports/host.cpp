// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
Vendor: Xilinx
Associated Filename: main.c
#Purpose: This example shows a basic vector add +1 (constant) by manipulating
#         memory inplace.
*******************************************************************************/

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <CL/opencl.h>
#include <CL/cl_ext.h>
#include <CL/cl2.hpp>
#include <limits.h>

////////////////////////////////////////////////////////////////////////////////

#define NUM_WORKGROUPS (1)
#define WORKGROUP_SIZE (256)
#define IM_MAX_LENGTH 800*800
#define WM_MAX_LENGTH 16*313

#if defined(SDX_PLATFORM) && !defined(TARGET_DEVICE)
#define STR_VALUE(arg)      #arg
#define GET_STRING(name) STR_VALUE(name)
#define TARGET_DEVICE GET_STRING(SDX_PLATFORM)
#endif

////////////////////////////////////////////////////////////////////////////////

int load_file_to_memory(const char *filename, char **result)
{
    uint size = 0;
    FILE *f = fopen(filename, "rb");
    if (f == NULL) {
        *result = NULL;
        return -1; // -1 means file opening fail
    }
    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);
    *result = (char *)malloc(size+1);
    if (size != fread(*result, sizeof(char), size, f)) {
        free(*result);
        return -2; // -2 means file reading fail
    }
    fclose(f);
    (*result)[size] = 0;
    return size;
}

int main(int argc, char** argv)
{

    int err;                            // error code returned from api calls
    int check_status = 0;
    //const uint number_of_words = 4096; // 16KB of data
    const uint im_number_of_words = 800*800;
    const uint wm_number_of_words = 16*313;


    cl_platform_id platform_id;         // platform id
    cl_device_id device_id;             // compute device id
    cl_context context;                 // compute context
    cl_command_queue commands;          // compute command queue
    cl_program program;                 // compute programs
    cl_kernel kernel;                   // compute kernel

    char cl_platform_vendor[1001];
    char target_device_name[1001] = TARGET_DEVICE;

    int h_axi00_im_input[IM_MAX_LENGTH];                    // host memory for input vector
    int h_axi00_im_output[IM_MAX_LENGTH];                   // host memory for output vector
    cl_mem d_axi00_im;                         // device memory used for a vector

    int h_axi01_wm_input[WM_MAX_LENGTH];                    // host memory for input vector
    int h_axi01_wm_output[WM_MAX_LENGTH];                   // host memory for output vector
    cl_mem d_axi01_wm;                         // device memory used for a vector

    if (argc != 2) {
        printf("Usage: %s xclbin\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Fill our data sets with pattern
    int i = 0;
    for(i = 0; i < IM_MAX_LENGTH; i++) {

        h_axi00_im_input[i]  = i;
        h_axi00_im_output[i] = 0; 

    }

    for(i = 0; i < WM_MAX_LENGTH; i++) {

        h_axi01_wm_input[i]  = i;
        h_axi01_wm_output[i] = 0; 

    }

   // Get all platforms and then select Xilinx platform
    cl_platform_id platforms[16];       // platform id
    cl_uint platform_count;
    int platform_found = 0;
    err = clGetPlatformIDs(16, platforms, &platform_count);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to find an OpenCL platform!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }
    printf("INFO: Found %d platforms\n", platform_count);

    // Find Xilinx Plaftorm
    for (unsigned int iplat=0; iplat<platform_count; iplat++) {
        err = clGetPlatformInfo(platforms[iplat], CL_PLATFORM_VENDOR, 1000, (void *)cl_platform_vendor,NULL);
        if (err != CL_SUCCESS) {
            printf("Error: clGetPlatformInfo(CL_PLATFORM_VENDOR) failed!\n");
            printf("Test failed\n");
            return EXIT_FAILURE;
        }
        if (strcmp(cl_platform_vendor, "Xilinx") == 0) {
            printf("INFO: Selected platform %d from %s\n", iplat, cl_platform_vendor);
            platform_id = platforms[iplat];
            platform_found = 1;
        }
    }
    if (!platform_found) {
        printf("ERROR: Platform Xilinx not found. Exit.\n");
        return EXIT_FAILURE;
    }

   // Get Accelerator compute device
    cl_uint num_devices;
    unsigned int device_found = 0;
    cl_device_id devices[16];  // compute device id
    char cl_device_name[1001];
    err = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_ACCELERATOR, 16, devices, &num_devices);
    printf("INFO: Found %d devices\n", num_devices);
    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to create a device group!\n");
        printf("ERROR: Test failed\n");
        return -1;
    }

    //iterate all devices to select the target device.
    for (uint i=0; i<num_devices; i++) {
        err = clGetDeviceInfo(devices[i], CL_DEVICE_NAME, 1024, cl_device_name, 0);
        if (err != CL_SUCCESS) {
            printf("Error: Failed to get device name for device %d!\n", i);
            printf("Test failed\n");
            return EXIT_FAILURE;
        }
        printf("CL_DEVICE_NAME %s\n", cl_device_name);
        if(strcmp(cl_device_name, target_device_name) == 0) {
            device_id = devices[i];
            device_found = 1;
            printf("Selected %s as the target device\n", cl_device_name);
       }
    }

    if (!device_found) {
        printf("Target device %s not found. Exit.\n", target_device_name);
        return EXIT_FAILURE;
    }

    // Create a compute context
    //
    context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
    if (!context) {
        printf("Error: Failed to create a compute context!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Create a command commands
    commands = clCreateCommandQueue(context, device_id, 0, &err);
    if (!commands) {
        printf("Error: Failed to create a command commands!\n");
        printf("Error: code %i\n",err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    int status;

    // Create Program Objects
    // Load binary from disk
    unsigned char *kernelbinary;
    char *xclbin = argv[1];

    //------------------------------------------------------------------------------
    // xclbin
    //------------------------------------------------------------------------------
    printf("INFO: loading xclbin %s\n", xclbin);
    int n_i0 = load_file_to_memory(xclbin, (char **) &kernelbinary);
    if (n_i0 < 0) {
        printf("failed to load kernel from xclbin: %s\n", xclbin);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    size_t n0 = n_i0;

    // Create the compute program from offline
    program = clCreateProgramWithBinary(context, 1, &device_id, &n0,
                                        (const unsigned char **) &kernelbinary, &status, &err);

    if ((!program) || (err!=CL_SUCCESS)) {
        printf("Error: Failed to create compute program from binary %d!\n", err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Build the program executable
    //
    err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (err != CL_SUCCESS) {
        size_t len;
        char buffer[2048];

        printf("Error: Failed to build program executable!\n");
        clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
        printf("%s\n", buffer);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Create the compute kernel in the program we wish to run
    //
     kernel = clCreateKernel(program, "sdx_kernel_addwm", &err);
    if (!kernel || err != CL_SUCCESS) {
        printf("Error: Failed to create compute kernel!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Create structs to define memory bank mapping
    cl_mem_ext_ptr_t d_bank0_ext;
    cl_mem_ext_ptr_t d_bank1_ext;
    cl_mem_ext_ptr_t d_bank2_ext;
    cl_mem_ext_ptr_t d_bank3_ext;

    d_bank0_ext.flags = XCL_MEM_DDR_BANK0;
    d_bank0_ext.obj = NULL;
    d_bank0_ext.param = 0;

    d_bank1_ext.flags = XCL_MEM_DDR_BANK1;
    d_bank1_ext.obj = NULL;
    d_bank1_ext.param = 0;

    d_bank2_ext.flags = XCL_MEM_DDR_BANK2;
    d_bank2_ext.obj = NULL;
    d_bank2_ext.param = 0;

    d_bank3_ext.flags = XCL_MEM_DDR_BANK3;
    d_bank3_ext.obj = NULL;
    d_bank3_ext.param = 0;
    // Create the input and output arrays in device memory for our calculation



    d_axi00_im = clCreateBuffer(context,  CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX,  sizeof(int) * im_number_of_words, &d_bank0_ext, NULL);



    d_axi01_wm = clCreateBuffer(context,  CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX,  sizeof(int) * wm_number_of_words, &d_bank0_ext, NULL);


    if (!(d_axi00_im&&d_axi01_wm)) {
        printf("Error: Failed to allocate device memory!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }
    // Write our data set into the input array in device memory
    //


    err = clEnqueueWriteBuffer(commands, d_axi00_im, CL_TRUE, 0, sizeof(int) * im_number_of_words, h_axi00_im_input, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to write to source array h_axi00_im_input!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }


    err = clEnqueueWriteBuffer(commands, d_axi01_wm, CL_TRUE, 0, sizeof(int) * wm_number_of_words, h_axi01_wm_input, 0, NULL, NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to write to source array h_axi01_wm_input!\n");
        printf("Test failed\n");
        return EXIT_FAILURE;
    }


    // Set the arguments to our compute kernel
    // int vector_length = MAX_LENGTH;
    err = 0;
    cl_uint d_p00 = 0;
    err |= clSetKernelArg(kernel, 0, sizeof(cl_uint), &d_p00); // Not used in example RTL logic.
    cl_uint d_p01 = 4*800*800;
    err |= clSetKernelArg(kernel, 1, sizeof(cl_uint), &d_p01); // Not used in example RTL logic.
    cl_uint d_p10 = 4*800*800;
    err |= clSetKernelArg(kernel, 2, sizeof(cl_uint), &d_p10); // Not used in example RTL logic.
    cl_uint d_p11 = 200*200/8;
    err |= clSetKernelArg(kernel, 3, sizeof(cl_uint), &d_p11); // Not used in example RTL logic.
    err |= clSetKernelArg(kernel, 4, sizeof(cl_mem), &d_axi00_im); 
    err |= clSetKernelArg(kernel, 5, sizeof(cl_mem), &d_axi01_wm); 

    if (err != CL_SUCCESS) {
        printf("Error: Failed to set kernel arguments! %d\n", err);
        printf("Test failed\n");
        return EXIT_FAILURE;
    }

    // Execute the kernel over the entire range of our 1d input data set
    // using the maximum number of work group items for this device

    err = clEnqueueTask(commands, kernel, 0, NULL, NULL);
    if (err) {
            printf("Error: Failed to execute kernel! %d\n", err);
            printf("Test failed\n");
            return EXIT_FAILURE;
        }

    // Read back the results from the device to verify the output
    //
    cl_event readevent;
    clFinish(commands);

    err = 0;
    err |= clEnqueueReadBuffer( commands, d_axi00_im, CL_TRUE, 0, sizeof(int) * im_number_of_words, h_axi00_im_output, 0, NULL, &readevent );

    //err |= clEnqueueReadBuffer( commands, d_axi01_wm, CL_TRUE, 0, sizeof(int) * number_of_words, h_axi01_wm_output, 0, NULL, &readevent );


    if (err != CL_SUCCESS) {
            printf("Error: Failed to read output array! %d\n", err);
            printf("Test failed\n");
            return EXIT_FAILURE;
        }
    clWaitForEvents(1, &readevent);
    // Check Results

    for (uint i = 0; i < number_of_words; i++) {
        if ((h_axi00_im_input[i] + 1) != h_axi00_im_output[i]) {
            printf("ERROR in sdx_kernel_addwm - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_axi00_im_input[i], h_axi00_im_input[i], h_axi00_im_output[i], h_axi00_im_output[i]);
            check_status = 1;
        }
      //  printf("i=%d, input=%d, output=%d\n", i,  h_axi00_im_input[i], h_axi00_im_output[i]);
    }


    // for (uint i = 0; i < number_of_words; i++) {
    //     if ((h_axi01_wm_input[i] + 1) != h_axi01_wm_output[i]) {
    //         printf("ERROR in sdx_kernel_addwm - array index %d (host addr 0x%03x) - input=%d (0x%x), output=%d (0x%x)\n", i, i*4, h_axi01_wm_input[i], h_axi01_wm_input[i], h_axi01_wm_output[i], h_axi01_wm_output[i]);
    //         check_status = 1;
    //     }
    //   //  printf("i=%d, input=%d, output=%d\n", i,  h_axi01_wm_input[i], h_axi01_wm_output[i]);
    // }


    //--------------------------------------------------------------------------
    // Shutdown and cleanup
    //-------------------------------------------------------------------------- 
    clReleaseMemObject(d_axi00_im);

    clReleaseMemObject(d_axi01_wm);


    clReleaseProgram(program);
    clReleaseKernel(kernel);
    clReleaseCommandQueue(commands);
    clReleaseContext(context);

    if (check_status) {
        printf("INFO: Test failed\n");
        return EXIT_FAILURE;
    } else {
        printf("INFO: Test completed successfully.\n");
        return EXIT_SUCCESS;
    }


} // end of main

module user_project_wrapper (user_clock2,
    vccd1,
    vccd2,
    vdda1,
    vdda2,
    vssa1,
    vssa2,
    vssd1,
    vssd2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vccd1;
 input vccd2;
 input vdda1;
 input vdda2;
 input vssa1;
 input vssa2;
 input vssd1;
 input vssd2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire caravel_uart_rx;
 wire caravel_uart_tx;
 wire caravel_wb_ack_i;
 wire \caravel_wb_adr_o[0] ;
 wire \caravel_wb_adr_o[10] ;
 wire \caravel_wb_adr_o[11] ;
 wire \caravel_wb_adr_o[12] ;
 wire \caravel_wb_adr_o[13] ;
 wire \caravel_wb_adr_o[14] ;
 wire \caravel_wb_adr_o[15] ;
 wire \caravel_wb_adr_o[16] ;
 wire \caravel_wb_adr_o[17] ;
 wire \caravel_wb_adr_o[18] ;
 wire \caravel_wb_adr_o[19] ;
 wire \caravel_wb_adr_o[1] ;
 wire \caravel_wb_adr_o[20] ;
 wire \caravel_wb_adr_o[21] ;
 wire \caravel_wb_adr_o[22] ;
 wire \caravel_wb_adr_o[23] ;
 wire \caravel_wb_adr_o[24] ;
 wire \caravel_wb_adr_o[25] ;
 wire \caravel_wb_adr_o[26] ;
 wire \caravel_wb_adr_o[27] ;
 wire \caravel_wb_adr_o[2] ;
 wire \caravel_wb_adr_o[3] ;
 wire \caravel_wb_adr_o[4] ;
 wire \caravel_wb_adr_o[5] ;
 wire \caravel_wb_adr_o[6] ;
 wire \caravel_wb_adr_o[7] ;
 wire \caravel_wb_adr_o[8] ;
 wire \caravel_wb_adr_o[9] ;
 wire caravel_wb_cyc_o;
 wire \caravel_wb_data_i[0] ;
 wire \caravel_wb_data_i[10] ;
 wire \caravel_wb_data_i[11] ;
 wire \caravel_wb_data_i[12] ;
 wire \caravel_wb_data_i[13] ;
 wire \caravel_wb_data_i[14] ;
 wire \caravel_wb_data_i[15] ;
 wire \caravel_wb_data_i[16] ;
 wire \caravel_wb_data_i[17] ;
 wire \caravel_wb_data_i[18] ;
 wire \caravel_wb_data_i[19] ;
 wire \caravel_wb_data_i[1] ;
 wire \caravel_wb_data_i[20] ;
 wire \caravel_wb_data_i[21] ;
 wire \caravel_wb_data_i[22] ;
 wire \caravel_wb_data_i[23] ;
 wire \caravel_wb_data_i[24] ;
 wire \caravel_wb_data_i[25] ;
 wire \caravel_wb_data_i[26] ;
 wire \caravel_wb_data_i[27] ;
 wire \caravel_wb_data_i[28] ;
 wire \caravel_wb_data_i[29] ;
 wire \caravel_wb_data_i[2] ;
 wire \caravel_wb_data_i[30] ;
 wire \caravel_wb_data_i[31] ;
 wire \caravel_wb_data_i[3] ;
 wire \caravel_wb_data_i[4] ;
 wire \caravel_wb_data_i[5] ;
 wire \caravel_wb_data_i[6] ;
 wire \caravel_wb_data_i[7] ;
 wire \caravel_wb_data_i[8] ;
 wire \caravel_wb_data_i[9] ;
 wire \caravel_wb_data_o[0] ;
 wire \caravel_wb_data_o[10] ;
 wire \caravel_wb_data_o[11] ;
 wire \caravel_wb_data_o[12] ;
 wire \caravel_wb_data_o[13] ;
 wire \caravel_wb_data_o[14] ;
 wire \caravel_wb_data_o[15] ;
 wire \caravel_wb_data_o[16] ;
 wire \caravel_wb_data_o[17] ;
 wire \caravel_wb_data_o[18] ;
 wire \caravel_wb_data_o[19] ;
 wire \caravel_wb_data_o[1] ;
 wire \caravel_wb_data_o[20] ;
 wire \caravel_wb_data_o[21] ;
 wire \caravel_wb_data_o[22] ;
 wire \caravel_wb_data_o[23] ;
 wire \caravel_wb_data_o[24] ;
 wire \caravel_wb_data_o[25] ;
 wire \caravel_wb_data_o[26] ;
 wire \caravel_wb_data_o[27] ;
 wire \caravel_wb_data_o[28] ;
 wire \caravel_wb_data_o[29] ;
 wire \caravel_wb_data_o[2] ;
 wire \caravel_wb_data_o[30] ;
 wire \caravel_wb_data_o[31] ;
 wire \caravel_wb_data_o[3] ;
 wire \caravel_wb_data_o[4] ;
 wire \caravel_wb_data_o[5] ;
 wire \caravel_wb_data_o[6] ;
 wire \caravel_wb_data_o[7] ;
 wire \caravel_wb_data_o[8] ;
 wire \caravel_wb_data_o[9] ;
 wire caravel_wb_error_i;
 wire \caravel_wb_sel_o[0] ;
 wire \caravel_wb_sel_o[1] ;
 wire \caravel_wb_sel_o[2] ;
 wire \caravel_wb_sel_o[3] ;
 wire caravel_wb_stall_i;
 wire caravel_wb_stb_o;
 wire caravel_wb_we_o;
 wire \core0Index[0] ;
 wire \core0Index[1] ;
 wire \core0Index[2] ;
 wire \core0Index[3] ;
 wire \core0Index[4] ;
 wire \core0Index[5] ;
 wire \core0Index[6] ;
 wire \core0Index[7] ;
 wire \core1Index[0] ;
 wire \core1Index[1] ;
 wire \core1Index[2] ;
 wire \core1Index[3] ;
 wire \core1Index[4] ;
 wire \core1Index[5] ;
 wire \core1Index[6] ;
 wire \core1Index[7] ;
 wire \experiarSoC/core0Memory_wb_ack_o ;
 wire \experiarSoC/core0Memory_wb_adr_i[0] ;
 wire \experiarSoC/core0Memory_wb_adr_i[10] ;
 wire \experiarSoC/core0Memory_wb_adr_i[11] ;
 wire \experiarSoC/core0Memory_wb_adr_i[12] ;
 wire \experiarSoC/core0Memory_wb_adr_i[13] ;
 wire \experiarSoC/core0Memory_wb_adr_i[14] ;
 wire \experiarSoC/core0Memory_wb_adr_i[15] ;
 wire \experiarSoC/core0Memory_wb_adr_i[16] ;
 wire \experiarSoC/core0Memory_wb_adr_i[17] ;
 wire \experiarSoC/core0Memory_wb_adr_i[18] ;
 wire \experiarSoC/core0Memory_wb_adr_i[19] ;
 wire \experiarSoC/core0Memory_wb_adr_i[1] ;
 wire \experiarSoC/core0Memory_wb_adr_i[20] ;
 wire \experiarSoC/core0Memory_wb_adr_i[21] ;
 wire \experiarSoC/core0Memory_wb_adr_i[22] ;
 wire \experiarSoC/core0Memory_wb_adr_i[23] ;
 wire \experiarSoC/core0Memory_wb_adr_i[2] ;
 wire \experiarSoC/core0Memory_wb_adr_i[3] ;
 wire \experiarSoC/core0Memory_wb_adr_i[4] ;
 wire \experiarSoC/core0Memory_wb_adr_i[5] ;
 wire \experiarSoC/core0Memory_wb_adr_i[6] ;
 wire \experiarSoC/core0Memory_wb_adr_i[7] ;
 wire \experiarSoC/core0Memory_wb_adr_i[8] ;
 wire \experiarSoC/core0Memory_wb_adr_i[9] ;
 wire \experiarSoC/core0Memory_wb_cyc_i ;
 wire \experiarSoC/core0Memory_wb_data_i[0] ;
 wire \experiarSoC/core0Memory_wb_data_i[10] ;
 wire \experiarSoC/core0Memory_wb_data_i[11] ;
 wire \experiarSoC/core0Memory_wb_data_i[12] ;
 wire \experiarSoC/core0Memory_wb_data_i[13] ;
 wire \experiarSoC/core0Memory_wb_data_i[14] ;
 wire \experiarSoC/core0Memory_wb_data_i[15] ;
 wire \experiarSoC/core0Memory_wb_data_i[16] ;
 wire \experiarSoC/core0Memory_wb_data_i[17] ;
 wire \experiarSoC/core0Memory_wb_data_i[18] ;
 wire \experiarSoC/core0Memory_wb_data_i[19] ;
 wire \experiarSoC/core0Memory_wb_data_i[1] ;
 wire \experiarSoC/core0Memory_wb_data_i[20] ;
 wire \experiarSoC/core0Memory_wb_data_i[21] ;
 wire \experiarSoC/core0Memory_wb_data_i[22] ;
 wire \experiarSoC/core0Memory_wb_data_i[23] ;
 wire \experiarSoC/core0Memory_wb_data_i[24] ;
 wire \experiarSoC/core0Memory_wb_data_i[25] ;
 wire \experiarSoC/core0Memory_wb_data_i[26] ;
 wire \experiarSoC/core0Memory_wb_data_i[27] ;
 wire \experiarSoC/core0Memory_wb_data_i[28] ;
 wire \experiarSoC/core0Memory_wb_data_i[29] ;
 wire \experiarSoC/core0Memory_wb_data_i[2] ;
 wire \experiarSoC/core0Memory_wb_data_i[30] ;
 wire \experiarSoC/core0Memory_wb_data_i[31] ;
 wire \experiarSoC/core0Memory_wb_data_i[3] ;
 wire \experiarSoC/core0Memory_wb_data_i[4] ;
 wire \experiarSoC/core0Memory_wb_data_i[5] ;
 wire \experiarSoC/core0Memory_wb_data_i[6] ;
 wire \experiarSoC/core0Memory_wb_data_i[7] ;
 wire \experiarSoC/core0Memory_wb_data_i[8] ;
 wire \experiarSoC/core0Memory_wb_data_i[9] ;
 wire \experiarSoC/core0Memory_wb_data_o[0] ;
 wire \experiarSoC/core0Memory_wb_data_o[10] ;
 wire \experiarSoC/core0Memory_wb_data_o[11] ;
 wire \experiarSoC/core0Memory_wb_data_o[12] ;
 wire \experiarSoC/core0Memory_wb_data_o[13] ;
 wire \experiarSoC/core0Memory_wb_data_o[14] ;
 wire \experiarSoC/core0Memory_wb_data_o[15] ;
 wire \experiarSoC/core0Memory_wb_data_o[16] ;
 wire \experiarSoC/core0Memory_wb_data_o[17] ;
 wire \experiarSoC/core0Memory_wb_data_o[18] ;
 wire \experiarSoC/core0Memory_wb_data_o[19] ;
 wire \experiarSoC/core0Memory_wb_data_o[1] ;
 wire \experiarSoC/core0Memory_wb_data_o[20] ;
 wire \experiarSoC/core0Memory_wb_data_o[21] ;
 wire \experiarSoC/core0Memory_wb_data_o[22] ;
 wire \experiarSoC/core0Memory_wb_data_o[23] ;
 wire \experiarSoC/core0Memory_wb_data_o[24] ;
 wire \experiarSoC/core0Memory_wb_data_o[25] ;
 wire \experiarSoC/core0Memory_wb_data_o[26] ;
 wire \experiarSoC/core0Memory_wb_data_o[27] ;
 wire \experiarSoC/core0Memory_wb_data_o[28] ;
 wire \experiarSoC/core0Memory_wb_data_o[29] ;
 wire \experiarSoC/core0Memory_wb_data_o[2] ;
 wire \experiarSoC/core0Memory_wb_data_o[30] ;
 wire \experiarSoC/core0Memory_wb_data_o[31] ;
 wire \experiarSoC/core0Memory_wb_data_o[3] ;
 wire \experiarSoC/core0Memory_wb_data_o[4] ;
 wire \experiarSoC/core0Memory_wb_data_o[5] ;
 wire \experiarSoC/core0Memory_wb_data_o[6] ;
 wire \experiarSoC/core0Memory_wb_data_o[7] ;
 wire \experiarSoC/core0Memory_wb_data_o[8] ;
 wire \experiarSoC/core0Memory_wb_data_o[9] ;
 wire \experiarSoC/core0Memory_wb_error_o ;
 wire \experiarSoC/core0Memory_wb_sel_i[0] ;
 wire \experiarSoC/core0Memory_wb_sel_i[1] ;
 wire \experiarSoC/core0Memory_wb_sel_i[2] ;
 wire \experiarSoC/core0Memory_wb_sel_i[3] ;
 wire \experiarSoC/core0Memory_wb_stall_o ;
 wire \experiarSoC/core0Memory_wb_stb_i ;
 wire \experiarSoC/core0Memory_wb_we_i ;
 wire \experiarSoC/core0SRAM0_dout0[0] ;
 wire \experiarSoC/core0SRAM0_dout0[10] ;
 wire \experiarSoC/core0SRAM0_dout0[11] ;
 wire \experiarSoC/core0SRAM0_dout0[12] ;
 wire \experiarSoC/core0SRAM0_dout0[13] ;
 wire \experiarSoC/core0SRAM0_dout0[14] ;
 wire \experiarSoC/core0SRAM0_dout0[15] ;
 wire \experiarSoC/core0SRAM0_dout0[16] ;
 wire \experiarSoC/core0SRAM0_dout0[17] ;
 wire \experiarSoC/core0SRAM0_dout0[18] ;
 wire \experiarSoC/core0SRAM0_dout0[19] ;
 wire \experiarSoC/core0SRAM0_dout0[1] ;
 wire \experiarSoC/core0SRAM0_dout0[20] ;
 wire \experiarSoC/core0SRAM0_dout0[21] ;
 wire \experiarSoC/core0SRAM0_dout0[22] ;
 wire \experiarSoC/core0SRAM0_dout0[23] ;
 wire \experiarSoC/core0SRAM0_dout0[24] ;
 wire \experiarSoC/core0SRAM0_dout0[25] ;
 wire \experiarSoC/core0SRAM0_dout0[26] ;
 wire \experiarSoC/core0SRAM0_dout0[27] ;
 wire \experiarSoC/core0SRAM0_dout0[28] ;
 wire \experiarSoC/core0SRAM0_dout0[29] ;
 wire \experiarSoC/core0SRAM0_dout0[2] ;
 wire \experiarSoC/core0SRAM0_dout0[30] ;
 wire \experiarSoC/core0SRAM0_dout0[31] ;
 wire \experiarSoC/core0SRAM0_dout0[3] ;
 wire \experiarSoC/core0SRAM0_dout0[4] ;
 wire \experiarSoC/core0SRAM0_dout0[5] ;
 wire \experiarSoC/core0SRAM0_dout0[6] ;
 wire \experiarSoC/core0SRAM0_dout0[7] ;
 wire \experiarSoC/core0SRAM0_dout0[8] ;
 wire \experiarSoC/core0SRAM0_dout0[9] ;
 wire \experiarSoC/core0SRAM0_dout1[0] ;
 wire \experiarSoC/core0SRAM0_dout1[10] ;
 wire \experiarSoC/core0SRAM0_dout1[11] ;
 wire \experiarSoC/core0SRAM0_dout1[12] ;
 wire \experiarSoC/core0SRAM0_dout1[13] ;
 wire \experiarSoC/core0SRAM0_dout1[14] ;
 wire \experiarSoC/core0SRAM0_dout1[15] ;
 wire \experiarSoC/core0SRAM0_dout1[16] ;
 wire \experiarSoC/core0SRAM0_dout1[17] ;
 wire \experiarSoC/core0SRAM0_dout1[18] ;
 wire \experiarSoC/core0SRAM0_dout1[19] ;
 wire \experiarSoC/core0SRAM0_dout1[1] ;
 wire \experiarSoC/core0SRAM0_dout1[20] ;
 wire \experiarSoC/core0SRAM0_dout1[21] ;
 wire \experiarSoC/core0SRAM0_dout1[22] ;
 wire \experiarSoC/core0SRAM0_dout1[23] ;
 wire \experiarSoC/core0SRAM0_dout1[24] ;
 wire \experiarSoC/core0SRAM0_dout1[25] ;
 wire \experiarSoC/core0SRAM0_dout1[26] ;
 wire \experiarSoC/core0SRAM0_dout1[27] ;
 wire \experiarSoC/core0SRAM0_dout1[28] ;
 wire \experiarSoC/core0SRAM0_dout1[29] ;
 wire \experiarSoC/core0SRAM0_dout1[2] ;
 wire \experiarSoC/core0SRAM0_dout1[30] ;
 wire \experiarSoC/core0SRAM0_dout1[31] ;
 wire \experiarSoC/core0SRAM0_dout1[3] ;
 wire \experiarSoC/core0SRAM0_dout1[4] ;
 wire \experiarSoC/core0SRAM0_dout1[5] ;
 wire \experiarSoC/core0SRAM0_dout1[6] ;
 wire \experiarSoC/core0SRAM0_dout1[7] ;
 wire \experiarSoC/core0SRAM0_dout1[8] ;
 wire \experiarSoC/core0SRAM0_dout1[9] ;
 wire \experiarSoC/core0SRAM1_dout0[0] ;
 wire \experiarSoC/core0SRAM1_dout0[10] ;
 wire \experiarSoC/core0SRAM1_dout0[11] ;
 wire \experiarSoC/core0SRAM1_dout0[12] ;
 wire \experiarSoC/core0SRAM1_dout0[13] ;
 wire \experiarSoC/core0SRAM1_dout0[14] ;
 wire \experiarSoC/core0SRAM1_dout0[15] ;
 wire \experiarSoC/core0SRAM1_dout0[16] ;
 wire \experiarSoC/core0SRAM1_dout0[17] ;
 wire \experiarSoC/core0SRAM1_dout0[18] ;
 wire \experiarSoC/core0SRAM1_dout0[19] ;
 wire \experiarSoC/core0SRAM1_dout0[1] ;
 wire \experiarSoC/core0SRAM1_dout0[20] ;
 wire \experiarSoC/core0SRAM1_dout0[21] ;
 wire \experiarSoC/core0SRAM1_dout0[22] ;
 wire \experiarSoC/core0SRAM1_dout0[23] ;
 wire \experiarSoC/core0SRAM1_dout0[24] ;
 wire \experiarSoC/core0SRAM1_dout0[25] ;
 wire \experiarSoC/core0SRAM1_dout0[26] ;
 wire \experiarSoC/core0SRAM1_dout0[27] ;
 wire \experiarSoC/core0SRAM1_dout0[28] ;
 wire \experiarSoC/core0SRAM1_dout0[29] ;
 wire \experiarSoC/core0SRAM1_dout0[2] ;
 wire \experiarSoC/core0SRAM1_dout0[30] ;
 wire \experiarSoC/core0SRAM1_dout0[31] ;
 wire \experiarSoC/core0SRAM1_dout0[3] ;
 wire \experiarSoC/core0SRAM1_dout0[4] ;
 wire \experiarSoC/core0SRAM1_dout0[5] ;
 wire \experiarSoC/core0SRAM1_dout0[6] ;
 wire \experiarSoC/core0SRAM1_dout0[7] ;
 wire \experiarSoC/core0SRAM1_dout0[8] ;
 wire \experiarSoC/core0SRAM1_dout0[9] ;
 wire \experiarSoC/core0SRAM1_dout1[0] ;
 wire \experiarSoC/core0SRAM1_dout1[10] ;
 wire \experiarSoC/core0SRAM1_dout1[11] ;
 wire \experiarSoC/core0SRAM1_dout1[12] ;
 wire \experiarSoC/core0SRAM1_dout1[13] ;
 wire \experiarSoC/core0SRAM1_dout1[14] ;
 wire \experiarSoC/core0SRAM1_dout1[15] ;
 wire \experiarSoC/core0SRAM1_dout1[16] ;
 wire \experiarSoC/core0SRAM1_dout1[17] ;
 wire \experiarSoC/core0SRAM1_dout1[18] ;
 wire \experiarSoC/core0SRAM1_dout1[19] ;
 wire \experiarSoC/core0SRAM1_dout1[1] ;
 wire \experiarSoC/core0SRAM1_dout1[20] ;
 wire \experiarSoC/core0SRAM1_dout1[21] ;
 wire \experiarSoC/core0SRAM1_dout1[22] ;
 wire \experiarSoC/core0SRAM1_dout1[23] ;
 wire \experiarSoC/core0SRAM1_dout1[24] ;
 wire \experiarSoC/core0SRAM1_dout1[25] ;
 wire \experiarSoC/core0SRAM1_dout1[26] ;
 wire \experiarSoC/core0SRAM1_dout1[27] ;
 wire \experiarSoC/core0SRAM1_dout1[28] ;
 wire \experiarSoC/core0SRAM1_dout1[29] ;
 wire \experiarSoC/core0SRAM1_dout1[2] ;
 wire \experiarSoC/core0SRAM1_dout1[30] ;
 wire \experiarSoC/core0SRAM1_dout1[31] ;
 wire \experiarSoC/core0SRAM1_dout1[3] ;
 wire \experiarSoC/core0SRAM1_dout1[4] ;
 wire \experiarSoC/core0SRAM1_dout1[5] ;
 wire \experiarSoC/core0SRAM1_dout1[6] ;
 wire \experiarSoC/core0SRAM1_dout1[7] ;
 wire \experiarSoC/core0SRAM1_dout1[8] ;
 wire \experiarSoC/core0SRAM1_dout1[9] ;
 wire \experiarSoC/core0SRAM_addr0[0] ;
 wire \experiarSoC/core0SRAM_addr0[1] ;
 wire \experiarSoC/core0SRAM_addr0[2] ;
 wire \experiarSoC/core0SRAM_addr0[3] ;
 wire \experiarSoC/core0SRAM_addr0[4] ;
 wire \experiarSoC/core0SRAM_addr0[5] ;
 wire \experiarSoC/core0SRAM_addr0[6] ;
 wire \experiarSoC/core0SRAM_addr0[7] ;
 wire \experiarSoC/core0SRAM_addr0[8] ;
 wire \experiarSoC/core0SRAM_addr1[0] ;
 wire \experiarSoC/core0SRAM_addr1[1] ;
 wire \experiarSoC/core0SRAM_addr1[2] ;
 wire \experiarSoC/core0SRAM_addr1[3] ;
 wire \experiarSoC/core0SRAM_addr1[4] ;
 wire \experiarSoC/core0SRAM_addr1[5] ;
 wire \experiarSoC/core0SRAM_addr1[6] ;
 wire \experiarSoC/core0SRAM_addr1[7] ;
 wire \experiarSoC/core0SRAM_addr1[8] ;
 wire \experiarSoC/core0SRAM_clk0 ;
 wire \experiarSoC/core0SRAM_clk1 ;
 wire \experiarSoC/core0SRAM_csb0[0] ;
 wire \experiarSoC/core0SRAM_csb0[1] ;
 wire \experiarSoC/core0SRAM_csb1[0] ;
 wire \experiarSoC/core0SRAM_csb1[1] ;
 wire \experiarSoC/core0SRAM_din0[0] ;
 wire \experiarSoC/core0SRAM_din0[10] ;
 wire \experiarSoC/core0SRAM_din0[11] ;
 wire \experiarSoC/core0SRAM_din0[12] ;
 wire \experiarSoC/core0SRAM_din0[13] ;
 wire \experiarSoC/core0SRAM_din0[14] ;
 wire \experiarSoC/core0SRAM_din0[15] ;
 wire \experiarSoC/core0SRAM_din0[16] ;
 wire \experiarSoC/core0SRAM_din0[17] ;
 wire \experiarSoC/core0SRAM_din0[18] ;
 wire \experiarSoC/core0SRAM_din0[19] ;
 wire \experiarSoC/core0SRAM_din0[1] ;
 wire \experiarSoC/core0SRAM_din0[20] ;
 wire \experiarSoC/core0SRAM_din0[21] ;
 wire \experiarSoC/core0SRAM_din0[22] ;
 wire \experiarSoC/core0SRAM_din0[23] ;
 wire \experiarSoC/core0SRAM_din0[24] ;
 wire \experiarSoC/core0SRAM_din0[25] ;
 wire \experiarSoC/core0SRAM_din0[26] ;
 wire \experiarSoC/core0SRAM_din0[27] ;
 wire \experiarSoC/core0SRAM_din0[28] ;
 wire \experiarSoC/core0SRAM_din0[29] ;
 wire \experiarSoC/core0SRAM_din0[2] ;
 wire \experiarSoC/core0SRAM_din0[30] ;
 wire \experiarSoC/core0SRAM_din0[31] ;
 wire \experiarSoC/core0SRAM_din0[3] ;
 wire \experiarSoC/core0SRAM_din0[4] ;
 wire \experiarSoC/core0SRAM_din0[5] ;
 wire \experiarSoC/core0SRAM_din0[6] ;
 wire \experiarSoC/core0SRAM_din0[7] ;
 wire \experiarSoC/core0SRAM_din0[8] ;
 wire \experiarSoC/core0SRAM_din0[9] ;
 wire \experiarSoC/core0SRAM_web0 ;
 wire \experiarSoC/core0SRAM_wmask0[0] ;
 wire \experiarSoC/core0SRAM_wmask0[1] ;
 wire \experiarSoC/core0SRAM_wmask0[2] ;
 wire \experiarSoC/core0SRAM_wmask0[3] ;
 wire \experiarSoC/core0_tdi ;
 wire \experiarSoC/core0_tdo ;
 wire \experiarSoC/core0_wb_ack_i ;
 wire \experiarSoC/core0_wb_adr_o[0] ;
 wire \experiarSoC/core0_wb_adr_o[10] ;
 wire \experiarSoC/core0_wb_adr_o[11] ;
 wire \experiarSoC/core0_wb_adr_o[12] ;
 wire \experiarSoC/core0_wb_adr_o[13] ;
 wire \experiarSoC/core0_wb_adr_o[14] ;
 wire \experiarSoC/core0_wb_adr_o[15] ;
 wire \experiarSoC/core0_wb_adr_o[16] ;
 wire \experiarSoC/core0_wb_adr_o[17] ;
 wire \experiarSoC/core0_wb_adr_o[18] ;
 wire \experiarSoC/core0_wb_adr_o[19] ;
 wire \experiarSoC/core0_wb_adr_o[1] ;
 wire \experiarSoC/core0_wb_adr_o[20] ;
 wire \experiarSoC/core0_wb_adr_o[21] ;
 wire \experiarSoC/core0_wb_adr_o[22] ;
 wire \experiarSoC/core0_wb_adr_o[23] ;
 wire \experiarSoC/core0_wb_adr_o[24] ;
 wire \experiarSoC/core0_wb_adr_o[25] ;
 wire \experiarSoC/core0_wb_adr_o[26] ;
 wire \experiarSoC/core0_wb_adr_o[27] ;
 wire \experiarSoC/core0_wb_adr_o[2] ;
 wire \experiarSoC/core0_wb_adr_o[3] ;
 wire \experiarSoC/core0_wb_adr_o[4] ;
 wire \experiarSoC/core0_wb_adr_o[5] ;
 wire \experiarSoC/core0_wb_adr_o[6] ;
 wire \experiarSoC/core0_wb_adr_o[7] ;
 wire \experiarSoC/core0_wb_adr_o[8] ;
 wire \experiarSoC/core0_wb_adr_o[9] ;
 wire \experiarSoC/core0_wb_cyc_o ;
 wire \experiarSoC/core0_wb_data_i[0] ;
 wire \experiarSoC/core0_wb_data_i[10] ;
 wire \experiarSoC/core0_wb_data_i[11] ;
 wire \experiarSoC/core0_wb_data_i[12] ;
 wire \experiarSoC/core0_wb_data_i[13] ;
 wire \experiarSoC/core0_wb_data_i[14] ;
 wire \experiarSoC/core0_wb_data_i[15] ;
 wire \experiarSoC/core0_wb_data_i[16] ;
 wire \experiarSoC/core0_wb_data_i[17] ;
 wire \experiarSoC/core0_wb_data_i[18] ;
 wire \experiarSoC/core0_wb_data_i[19] ;
 wire \experiarSoC/core0_wb_data_i[1] ;
 wire \experiarSoC/core0_wb_data_i[20] ;
 wire \experiarSoC/core0_wb_data_i[21] ;
 wire \experiarSoC/core0_wb_data_i[22] ;
 wire \experiarSoC/core0_wb_data_i[23] ;
 wire \experiarSoC/core0_wb_data_i[24] ;
 wire \experiarSoC/core0_wb_data_i[25] ;
 wire \experiarSoC/core0_wb_data_i[26] ;
 wire \experiarSoC/core0_wb_data_i[27] ;
 wire \experiarSoC/core0_wb_data_i[28] ;
 wire \experiarSoC/core0_wb_data_i[29] ;
 wire \experiarSoC/core0_wb_data_i[2] ;
 wire \experiarSoC/core0_wb_data_i[30] ;
 wire \experiarSoC/core0_wb_data_i[31] ;
 wire \experiarSoC/core0_wb_data_i[3] ;
 wire \experiarSoC/core0_wb_data_i[4] ;
 wire \experiarSoC/core0_wb_data_i[5] ;
 wire \experiarSoC/core0_wb_data_i[6] ;
 wire \experiarSoC/core0_wb_data_i[7] ;
 wire \experiarSoC/core0_wb_data_i[8] ;
 wire \experiarSoC/core0_wb_data_i[9] ;
 wire \experiarSoC/core0_wb_data_o[0] ;
 wire \experiarSoC/core0_wb_data_o[10] ;
 wire \experiarSoC/core0_wb_data_o[11] ;
 wire \experiarSoC/core0_wb_data_o[12] ;
 wire \experiarSoC/core0_wb_data_o[13] ;
 wire \experiarSoC/core0_wb_data_o[14] ;
 wire \experiarSoC/core0_wb_data_o[15] ;
 wire \experiarSoC/core0_wb_data_o[16] ;
 wire \experiarSoC/core0_wb_data_o[17] ;
 wire \experiarSoC/core0_wb_data_o[18] ;
 wire \experiarSoC/core0_wb_data_o[19] ;
 wire \experiarSoC/core0_wb_data_o[1] ;
 wire \experiarSoC/core0_wb_data_o[20] ;
 wire \experiarSoC/core0_wb_data_o[21] ;
 wire \experiarSoC/core0_wb_data_o[22] ;
 wire \experiarSoC/core0_wb_data_o[23] ;
 wire \experiarSoC/core0_wb_data_o[24] ;
 wire \experiarSoC/core0_wb_data_o[25] ;
 wire \experiarSoC/core0_wb_data_o[26] ;
 wire \experiarSoC/core0_wb_data_o[27] ;
 wire \experiarSoC/core0_wb_data_o[28] ;
 wire \experiarSoC/core0_wb_data_o[29] ;
 wire \experiarSoC/core0_wb_data_o[2] ;
 wire \experiarSoC/core0_wb_data_o[30] ;
 wire \experiarSoC/core0_wb_data_o[31] ;
 wire \experiarSoC/core0_wb_data_o[3] ;
 wire \experiarSoC/core0_wb_data_o[4] ;
 wire \experiarSoC/core0_wb_data_o[5] ;
 wire \experiarSoC/core0_wb_data_o[6] ;
 wire \experiarSoC/core0_wb_data_o[7] ;
 wire \experiarSoC/core0_wb_data_o[8] ;
 wire \experiarSoC/core0_wb_data_o[9] ;
 wire \experiarSoC/core0_wb_error_i ;
 wire \experiarSoC/core0_wb_sel_o[0] ;
 wire \experiarSoC/core0_wb_sel_o[1] ;
 wire \experiarSoC/core0_wb_sel_o[2] ;
 wire \experiarSoC/core0_wb_sel_o[3] ;
 wire \experiarSoC/core0_wb_stall_i ;
 wire \experiarSoC/core0_wb_stb_o ;
 wire \experiarSoC/core0_wb_we_o ;
 wire \experiarSoC/core1Memory_wb_ack_o ;
 wire \experiarSoC/core1Memory_wb_adr_i[0] ;
 wire \experiarSoC/core1Memory_wb_adr_i[10] ;
 wire \experiarSoC/core1Memory_wb_adr_i[11] ;
 wire \experiarSoC/core1Memory_wb_adr_i[12] ;
 wire \experiarSoC/core1Memory_wb_adr_i[13] ;
 wire \experiarSoC/core1Memory_wb_adr_i[14] ;
 wire \experiarSoC/core1Memory_wb_adr_i[15] ;
 wire \experiarSoC/core1Memory_wb_adr_i[16] ;
 wire \experiarSoC/core1Memory_wb_adr_i[17] ;
 wire \experiarSoC/core1Memory_wb_adr_i[18] ;
 wire \experiarSoC/core1Memory_wb_adr_i[19] ;
 wire \experiarSoC/core1Memory_wb_adr_i[1] ;
 wire \experiarSoC/core1Memory_wb_adr_i[20] ;
 wire \experiarSoC/core1Memory_wb_adr_i[21] ;
 wire \experiarSoC/core1Memory_wb_adr_i[22] ;
 wire \experiarSoC/core1Memory_wb_adr_i[23] ;
 wire \experiarSoC/core1Memory_wb_adr_i[2] ;
 wire \experiarSoC/core1Memory_wb_adr_i[3] ;
 wire \experiarSoC/core1Memory_wb_adr_i[4] ;
 wire \experiarSoC/core1Memory_wb_adr_i[5] ;
 wire \experiarSoC/core1Memory_wb_adr_i[6] ;
 wire \experiarSoC/core1Memory_wb_adr_i[7] ;
 wire \experiarSoC/core1Memory_wb_adr_i[8] ;
 wire \experiarSoC/core1Memory_wb_adr_i[9] ;
 wire \experiarSoC/core1Memory_wb_cyc_i ;
 wire \experiarSoC/core1Memory_wb_data_i[0] ;
 wire \experiarSoC/core1Memory_wb_data_i[10] ;
 wire \experiarSoC/core1Memory_wb_data_i[11] ;
 wire \experiarSoC/core1Memory_wb_data_i[12] ;
 wire \experiarSoC/core1Memory_wb_data_i[13] ;
 wire \experiarSoC/core1Memory_wb_data_i[14] ;
 wire \experiarSoC/core1Memory_wb_data_i[15] ;
 wire \experiarSoC/core1Memory_wb_data_i[16] ;
 wire \experiarSoC/core1Memory_wb_data_i[17] ;
 wire \experiarSoC/core1Memory_wb_data_i[18] ;
 wire \experiarSoC/core1Memory_wb_data_i[19] ;
 wire \experiarSoC/core1Memory_wb_data_i[1] ;
 wire \experiarSoC/core1Memory_wb_data_i[20] ;
 wire \experiarSoC/core1Memory_wb_data_i[21] ;
 wire \experiarSoC/core1Memory_wb_data_i[22] ;
 wire \experiarSoC/core1Memory_wb_data_i[23] ;
 wire \experiarSoC/core1Memory_wb_data_i[24] ;
 wire \experiarSoC/core1Memory_wb_data_i[25] ;
 wire \experiarSoC/core1Memory_wb_data_i[26] ;
 wire \experiarSoC/core1Memory_wb_data_i[27] ;
 wire \experiarSoC/core1Memory_wb_data_i[28] ;
 wire \experiarSoC/core1Memory_wb_data_i[29] ;
 wire \experiarSoC/core1Memory_wb_data_i[2] ;
 wire \experiarSoC/core1Memory_wb_data_i[30] ;
 wire \experiarSoC/core1Memory_wb_data_i[31] ;
 wire \experiarSoC/core1Memory_wb_data_i[3] ;
 wire \experiarSoC/core1Memory_wb_data_i[4] ;
 wire \experiarSoC/core1Memory_wb_data_i[5] ;
 wire \experiarSoC/core1Memory_wb_data_i[6] ;
 wire \experiarSoC/core1Memory_wb_data_i[7] ;
 wire \experiarSoC/core1Memory_wb_data_i[8] ;
 wire \experiarSoC/core1Memory_wb_data_i[9] ;
 wire \experiarSoC/core1Memory_wb_data_o[0] ;
 wire \experiarSoC/core1Memory_wb_data_o[10] ;
 wire \experiarSoC/core1Memory_wb_data_o[11] ;
 wire \experiarSoC/core1Memory_wb_data_o[12] ;
 wire \experiarSoC/core1Memory_wb_data_o[13] ;
 wire \experiarSoC/core1Memory_wb_data_o[14] ;
 wire \experiarSoC/core1Memory_wb_data_o[15] ;
 wire \experiarSoC/core1Memory_wb_data_o[16] ;
 wire \experiarSoC/core1Memory_wb_data_o[17] ;
 wire \experiarSoC/core1Memory_wb_data_o[18] ;
 wire \experiarSoC/core1Memory_wb_data_o[19] ;
 wire \experiarSoC/core1Memory_wb_data_o[1] ;
 wire \experiarSoC/core1Memory_wb_data_o[20] ;
 wire \experiarSoC/core1Memory_wb_data_o[21] ;
 wire \experiarSoC/core1Memory_wb_data_o[22] ;
 wire \experiarSoC/core1Memory_wb_data_o[23] ;
 wire \experiarSoC/core1Memory_wb_data_o[24] ;
 wire \experiarSoC/core1Memory_wb_data_o[25] ;
 wire \experiarSoC/core1Memory_wb_data_o[26] ;
 wire \experiarSoC/core1Memory_wb_data_o[27] ;
 wire \experiarSoC/core1Memory_wb_data_o[28] ;
 wire \experiarSoC/core1Memory_wb_data_o[29] ;
 wire \experiarSoC/core1Memory_wb_data_o[2] ;
 wire \experiarSoC/core1Memory_wb_data_o[30] ;
 wire \experiarSoC/core1Memory_wb_data_o[31] ;
 wire \experiarSoC/core1Memory_wb_data_o[3] ;
 wire \experiarSoC/core1Memory_wb_data_o[4] ;
 wire \experiarSoC/core1Memory_wb_data_o[5] ;
 wire \experiarSoC/core1Memory_wb_data_o[6] ;
 wire \experiarSoC/core1Memory_wb_data_o[7] ;
 wire \experiarSoC/core1Memory_wb_data_o[8] ;
 wire \experiarSoC/core1Memory_wb_data_o[9] ;
 wire \experiarSoC/core1Memory_wb_error_o ;
 wire \experiarSoC/core1Memory_wb_sel_i[0] ;
 wire \experiarSoC/core1Memory_wb_sel_i[1] ;
 wire \experiarSoC/core1Memory_wb_sel_i[2] ;
 wire \experiarSoC/core1Memory_wb_sel_i[3] ;
 wire \experiarSoC/core1Memory_wb_stall_o ;
 wire \experiarSoC/core1Memory_wb_stb_i ;
 wire \experiarSoC/core1Memory_wb_we_i ;
 wire \experiarSoC/core1SRAM0_dout0[0] ;
 wire \experiarSoC/core1SRAM0_dout0[10] ;
 wire \experiarSoC/core1SRAM0_dout0[11] ;
 wire \experiarSoC/core1SRAM0_dout0[12] ;
 wire \experiarSoC/core1SRAM0_dout0[13] ;
 wire \experiarSoC/core1SRAM0_dout0[14] ;
 wire \experiarSoC/core1SRAM0_dout0[15] ;
 wire \experiarSoC/core1SRAM0_dout0[16] ;
 wire \experiarSoC/core1SRAM0_dout0[17] ;
 wire \experiarSoC/core1SRAM0_dout0[18] ;
 wire \experiarSoC/core1SRAM0_dout0[19] ;
 wire \experiarSoC/core1SRAM0_dout0[1] ;
 wire \experiarSoC/core1SRAM0_dout0[20] ;
 wire \experiarSoC/core1SRAM0_dout0[21] ;
 wire \experiarSoC/core1SRAM0_dout0[22] ;
 wire \experiarSoC/core1SRAM0_dout0[23] ;
 wire \experiarSoC/core1SRAM0_dout0[24] ;
 wire \experiarSoC/core1SRAM0_dout0[25] ;
 wire \experiarSoC/core1SRAM0_dout0[26] ;
 wire \experiarSoC/core1SRAM0_dout0[27] ;
 wire \experiarSoC/core1SRAM0_dout0[28] ;
 wire \experiarSoC/core1SRAM0_dout0[29] ;
 wire \experiarSoC/core1SRAM0_dout0[2] ;
 wire \experiarSoC/core1SRAM0_dout0[30] ;
 wire \experiarSoC/core1SRAM0_dout0[31] ;
 wire \experiarSoC/core1SRAM0_dout0[3] ;
 wire \experiarSoC/core1SRAM0_dout0[4] ;
 wire \experiarSoC/core1SRAM0_dout0[5] ;
 wire \experiarSoC/core1SRAM0_dout0[6] ;
 wire \experiarSoC/core1SRAM0_dout0[7] ;
 wire \experiarSoC/core1SRAM0_dout0[8] ;
 wire \experiarSoC/core1SRAM0_dout0[9] ;
 wire \experiarSoC/core1SRAM0_dout1[0] ;
 wire \experiarSoC/core1SRAM0_dout1[10] ;
 wire \experiarSoC/core1SRAM0_dout1[11] ;
 wire \experiarSoC/core1SRAM0_dout1[12] ;
 wire \experiarSoC/core1SRAM0_dout1[13] ;
 wire \experiarSoC/core1SRAM0_dout1[14] ;
 wire \experiarSoC/core1SRAM0_dout1[15] ;
 wire \experiarSoC/core1SRAM0_dout1[16] ;
 wire \experiarSoC/core1SRAM0_dout1[17] ;
 wire \experiarSoC/core1SRAM0_dout1[18] ;
 wire \experiarSoC/core1SRAM0_dout1[19] ;
 wire \experiarSoC/core1SRAM0_dout1[1] ;
 wire \experiarSoC/core1SRAM0_dout1[20] ;
 wire \experiarSoC/core1SRAM0_dout1[21] ;
 wire \experiarSoC/core1SRAM0_dout1[22] ;
 wire \experiarSoC/core1SRAM0_dout1[23] ;
 wire \experiarSoC/core1SRAM0_dout1[24] ;
 wire \experiarSoC/core1SRAM0_dout1[25] ;
 wire \experiarSoC/core1SRAM0_dout1[26] ;
 wire \experiarSoC/core1SRAM0_dout1[27] ;
 wire \experiarSoC/core1SRAM0_dout1[28] ;
 wire \experiarSoC/core1SRAM0_dout1[29] ;
 wire \experiarSoC/core1SRAM0_dout1[2] ;
 wire \experiarSoC/core1SRAM0_dout1[30] ;
 wire \experiarSoC/core1SRAM0_dout1[31] ;
 wire \experiarSoC/core1SRAM0_dout1[3] ;
 wire \experiarSoC/core1SRAM0_dout1[4] ;
 wire \experiarSoC/core1SRAM0_dout1[5] ;
 wire \experiarSoC/core1SRAM0_dout1[6] ;
 wire \experiarSoC/core1SRAM0_dout1[7] ;
 wire \experiarSoC/core1SRAM0_dout1[8] ;
 wire \experiarSoC/core1SRAM0_dout1[9] ;
 wire \experiarSoC/core1SRAM1_dout0[0] ;
 wire \experiarSoC/core1SRAM1_dout0[10] ;
 wire \experiarSoC/core1SRAM1_dout0[11] ;
 wire \experiarSoC/core1SRAM1_dout0[12] ;
 wire \experiarSoC/core1SRAM1_dout0[13] ;
 wire \experiarSoC/core1SRAM1_dout0[14] ;
 wire \experiarSoC/core1SRAM1_dout0[15] ;
 wire \experiarSoC/core1SRAM1_dout0[16] ;
 wire \experiarSoC/core1SRAM1_dout0[17] ;
 wire \experiarSoC/core1SRAM1_dout0[18] ;
 wire \experiarSoC/core1SRAM1_dout0[19] ;
 wire \experiarSoC/core1SRAM1_dout0[1] ;
 wire \experiarSoC/core1SRAM1_dout0[20] ;
 wire \experiarSoC/core1SRAM1_dout0[21] ;
 wire \experiarSoC/core1SRAM1_dout0[22] ;
 wire \experiarSoC/core1SRAM1_dout0[23] ;
 wire \experiarSoC/core1SRAM1_dout0[24] ;
 wire \experiarSoC/core1SRAM1_dout0[25] ;
 wire \experiarSoC/core1SRAM1_dout0[26] ;
 wire \experiarSoC/core1SRAM1_dout0[27] ;
 wire \experiarSoC/core1SRAM1_dout0[28] ;
 wire \experiarSoC/core1SRAM1_dout0[29] ;
 wire \experiarSoC/core1SRAM1_dout0[2] ;
 wire \experiarSoC/core1SRAM1_dout0[30] ;
 wire \experiarSoC/core1SRAM1_dout0[31] ;
 wire \experiarSoC/core1SRAM1_dout0[3] ;
 wire \experiarSoC/core1SRAM1_dout0[4] ;
 wire \experiarSoC/core1SRAM1_dout0[5] ;
 wire \experiarSoC/core1SRAM1_dout0[6] ;
 wire \experiarSoC/core1SRAM1_dout0[7] ;
 wire \experiarSoC/core1SRAM1_dout0[8] ;
 wire \experiarSoC/core1SRAM1_dout0[9] ;
 wire \experiarSoC/core1SRAM1_dout1[0] ;
 wire \experiarSoC/core1SRAM1_dout1[10] ;
 wire \experiarSoC/core1SRAM1_dout1[11] ;
 wire \experiarSoC/core1SRAM1_dout1[12] ;
 wire \experiarSoC/core1SRAM1_dout1[13] ;
 wire \experiarSoC/core1SRAM1_dout1[14] ;
 wire \experiarSoC/core1SRAM1_dout1[15] ;
 wire \experiarSoC/core1SRAM1_dout1[16] ;
 wire \experiarSoC/core1SRAM1_dout1[17] ;
 wire \experiarSoC/core1SRAM1_dout1[18] ;
 wire \experiarSoC/core1SRAM1_dout1[19] ;
 wire \experiarSoC/core1SRAM1_dout1[1] ;
 wire \experiarSoC/core1SRAM1_dout1[20] ;
 wire \experiarSoC/core1SRAM1_dout1[21] ;
 wire \experiarSoC/core1SRAM1_dout1[22] ;
 wire \experiarSoC/core1SRAM1_dout1[23] ;
 wire \experiarSoC/core1SRAM1_dout1[24] ;
 wire \experiarSoC/core1SRAM1_dout1[25] ;
 wire \experiarSoC/core1SRAM1_dout1[26] ;
 wire \experiarSoC/core1SRAM1_dout1[27] ;
 wire \experiarSoC/core1SRAM1_dout1[28] ;
 wire \experiarSoC/core1SRAM1_dout1[29] ;
 wire \experiarSoC/core1SRAM1_dout1[2] ;
 wire \experiarSoC/core1SRAM1_dout1[30] ;
 wire \experiarSoC/core1SRAM1_dout1[31] ;
 wire \experiarSoC/core1SRAM1_dout1[3] ;
 wire \experiarSoC/core1SRAM1_dout1[4] ;
 wire \experiarSoC/core1SRAM1_dout1[5] ;
 wire \experiarSoC/core1SRAM1_dout1[6] ;
 wire \experiarSoC/core1SRAM1_dout1[7] ;
 wire \experiarSoC/core1SRAM1_dout1[8] ;
 wire \experiarSoC/core1SRAM1_dout1[9] ;
 wire \experiarSoC/core1SRAM_addr0[0] ;
 wire \experiarSoC/core1SRAM_addr0[1] ;
 wire \experiarSoC/core1SRAM_addr0[2] ;
 wire \experiarSoC/core1SRAM_addr0[3] ;
 wire \experiarSoC/core1SRAM_addr0[4] ;
 wire \experiarSoC/core1SRAM_addr0[5] ;
 wire \experiarSoC/core1SRAM_addr0[6] ;
 wire \experiarSoC/core1SRAM_addr0[7] ;
 wire \experiarSoC/core1SRAM_addr0[8] ;
 wire \experiarSoC/core1SRAM_addr1[0] ;
 wire \experiarSoC/core1SRAM_addr1[1] ;
 wire \experiarSoC/core1SRAM_addr1[2] ;
 wire \experiarSoC/core1SRAM_addr1[3] ;
 wire \experiarSoC/core1SRAM_addr1[4] ;
 wire \experiarSoC/core1SRAM_addr1[5] ;
 wire \experiarSoC/core1SRAM_addr1[6] ;
 wire \experiarSoC/core1SRAM_addr1[7] ;
 wire \experiarSoC/core1SRAM_addr1[8] ;
 wire \experiarSoC/core1SRAM_clk0 ;
 wire \experiarSoC/core1SRAM_clk1 ;
 wire \experiarSoC/core1SRAM_csb0[0] ;
 wire \experiarSoC/core1SRAM_csb0[1] ;
 wire \experiarSoC/core1SRAM_csb1[0] ;
 wire \experiarSoC/core1SRAM_csb1[1] ;
 wire \experiarSoC/core1SRAM_din0[0] ;
 wire \experiarSoC/core1SRAM_din0[10] ;
 wire \experiarSoC/core1SRAM_din0[11] ;
 wire \experiarSoC/core1SRAM_din0[12] ;
 wire \experiarSoC/core1SRAM_din0[13] ;
 wire \experiarSoC/core1SRAM_din0[14] ;
 wire \experiarSoC/core1SRAM_din0[15] ;
 wire \experiarSoC/core1SRAM_din0[16] ;
 wire \experiarSoC/core1SRAM_din0[17] ;
 wire \experiarSoC/core1SRAM_din0[18] ;
 wire \experiarSoC/core1SRAM_din0[19] ;
 wire \experiarSoC/core1SRAM_din0[1] ;
 wire \experiarSoC/core1SRAM_din0[20] ;
 wire \experiarSoC/core1SRAM_din0[21] ;
 wire \experiarSoC/core1SRAM_din0[22] ;
 wire \experiarSoC/core1SRAM_din0[23] ;
 wire \experiarSoC/core1SRAM_din0[24] ;
 wire \experiarSoC/core1SRAM_din0[25] ;
 wire \experiarSoC/core1SRAM_din0[26] ;
 wire \experiarSoC/core1SRAM_din0[27] ;
 wire \experiarSoC/core1SRAM_din0[28] ;
 wire \experiarSoC/core1SRAM_din0[29] ;
 wire \experiarSoC/core1SRAM_din0[2] ;
 wire \experiarSoC/core1SRAM_din0[30] ;
 wire \experiarSoC/core1SRAM_din0[31] ;
 wire \experiarSoC/core1SRAM_din0[3] ;
 wire \experiarSoC/core1SRAM_din0[4] ;
 wire \experiarSoC/core1SRAM_din0[5] ;
 wire \experiarSoC/core1SRAM_din0[6] ;
 wire \experiarSoC/core1SRAM_din0[7] ;
 wire \experiarSoC/core1SRAM_din0[8] ;
 wire \experiarSoC/core1SRAM_din0[9] ;
 wire \experiarSoC/core1SRAM_web0 ;
 wire \experiarSoC/core1SRAM_wmask0[0] ;
 wire \experiarSoC/core1SRAM_wmask0[1] ;
 wire \experiarSoC/core1SRAM_wmask0[2] ;
 wire \experiarSoC/core1SRAM_wmask0[3] ;
 wire \experiarSoC/core1_tdo ;
 wire \experiarSoC/core1_wb_ack_i ;
 wire \experiarSoC/core1_wb_adr_o[0] ;
 wire \experiarSoC/core1_wb_adr_o[10] ;
 wire \experiarSoC/core1_wb_adr_o[11] ;
 wire \experiarSoC/core1_wb_adr_o[12] ;
 wire \experiarSoC/core1_wb_adr_o[13] ;
 wire \experiarSoC/core1_wb_adr_o[14] ;
 wire \experiarSoC/core1_wb_adr_o[15] ;
 wire \experiarSoC/core1_wb_adr_o[16] ;
 wire \experiarSoC/core1_wb_adr_o[17] ;
 wire \experiarSoC/core1_wb_adr_o[18] ;
 wire \experiarSoC/core1_wb_adr_o[19] ;
 wire \experiarSoC/core1_wb_adr_o[1] ;
 wire \experiarSoC/core1_wb_adr_o[20] ;
 wire \experiarSoC/core1_wb_adr_o[21] ;
 wire \experiarSoC/core1_wb_adr_o[22] ;
 wire \experiarSoC/core1_wb_adr_o[23] ;
 wire \experiarSoC/core1_wb_adr_o[24] ;
 wire \experiarSoC/core1_wb_adr_o[25] ;
 wire \experiarSoC/core1_wb_adr_o[26] ;
 wire \experiarSoC/core1_wb_adr_o[27] ;
 wire \experiarSoC/core1_wb_adr_o[2] ;
 wire \experiarSoC/core1_wb_adr_o[3] ;
 wire \experiarSoC/core1_wb_adr_o[4] ;
 wire \experiarSoC/core1_wb_adr_o[5] ;
 wire \experiarSoC/core1_wb_adr_o[6] ;
 wire \experiarSoC/core1_wb_adr_o[7] ;
 wire \experiarSoC/core1_wb_adr_o[8] ;
 wire \experiarSoC/core1_wb_adr_o[9] ;
 wire \experiarSoC/core1_wb_cyc_o ;
 wire \experiarSoC/core1_wb_data_i[0] ;
 wire \experiarSoC/core1_wb_data_i[10] ;
 wire \experiarSoC/core1_wb_data_i[11] ;
 wire \experiarSoC/core1_wb_data_i[12] ;
 wire \experiarSoC/core1_wb_data_i[13] ;
 wire \experiarSoC/core1_wb_data_i[14] ;
 wire \experiarSoC/core1_wb_data_i[15] ;
 wire \experiarSoC/core1_wb_data_i[16] ;
 wire \experiarSoC/core1_wb_data_i[17] ;
 wire \experiarSoC/core1_wb_data_i[18] ;
 wire \experiarSoC/core1_wb_data_i[19] ;
 wire \experiarSoC/core1_wb_data_i[1] ;
 wire \experiarSoC/core1_wb_data_i[20] ;
 wire \experiarSoC/core1_wb_data_i[21] ;
 wire \experiarSoC/core1_wb_data_i[22] ;
 wire \experiarSoC/core1_wb_data_i[23] ;
 wire \experiarSoC/core1_wb_data_i[24] ;
 wire \experiarSoC/core1_wb_data_i[25] ;
 wire \experiarSoC/core1_wb_data_i[26] ;
 wire \experiarSoC/core1_wb_data_i[27] ;
 wire \experiarSoC/core1_wb_data_i[28] ;
 wire \experiarSoC/core1_wb_data_i[29] ;
 wire \experiarSoC/core1_wb_data_i[2] ;
 wire \experiarSoC/core1_wb_data_i[30] ;
 wire \experiarSoC/core1_wb_data_i[31] ;
 wire \experiarSoC/core1_wb_data_i[3] ;
 wire \experiarSoC/core1_wb_data_i[4] ;
 wire \experiarSoC/core1_wb_data_i[5] ;
 wire \experiarSoC/core1_wb_data_i[6] ;
 wire \experiarSoC/core1_wb_data_i[7] ;
 wire \experiarSoC/core1_wb_data_i[8] ;
 wire \experiarSoC/core1_wb_data_i[9] ;
 wire \experiarSoC/core1_wb_data_o[0] ;
 wire \experiarSoC/core1_wb_data_o[10] ;
 wire \experiarSoC/core1_wb_data_o[11] ;
 wire \experiarSoC/core1_wb_data_o[12] ;
 wire \experiarSoC/core1_wb_data_o[13] ;
 wire \experiarSoC/core1_wb_data_o[14] ;
 wire \experiarSoC/core1_wb_data_o[15] ;
 wire \experiarSoC/core1_wb_data_o[16] ;
 wire \experiarSoC/core1_wb_data_o[17] ;
 wire \experiarSoC/core1_wb_data_o[18] ;
 wire \experiarSoC/core1_wb_data_o[19] ;
 wire \experiarSoC/core1_wb_data_o[1] ;
 wire \experiarSoC/core1_wb_data_o[20] ;
 wire \experiarSoC/core1_wb_data_o[21] ;
 wire \experiarSoC/core1_wb_data_o[22] ;
 wire \experiarSoC/core1_wb_data_o[23] ;
 wire \experiarSoC/core1_wb_data_o[24] ;
 wire \experiarSoC/core1_wb_data_o[25] ;
 wire \experiarSoC/core1_wb_data_o[26] ;
 wire \experiarSoC/core1_wb_data_o[27] ;
 wire \experiarSoC/core1_wb_data_o[28] ;
 wire \experiarSoC/core1_wb_data_o[29] ;
 wire \experiarSoC/core1_wb_data_o[2] ;
 wire \experiarSoC/core1_wb_data_o[30] ;
 wire \experiarSoC/core1_wb_data_o[31] ;
 wire \experiarSoC/core1_wb_data_o[3] ;
 wire \experiarSoC/core1_wb_data_o[4] ;
 wire \experiarSoC/core1_wb_data_o[5] ;
 wire \experiarSoC/core1_wb_data_o[6] ;
 wire \experiarSoC/core1_wb_data_o[7] ;
 wire \experiarSoC/core1_wb_data_o[8] ;
 wire \experiarSoC/core1_wb_data_o[9] ;
 wire \experiarSoC/core1_wb_error_i ;
 wire \experiarSoC/core1_wb_sel_o[0] ;
 wire \experiarSoC/core1_wb_sel_o[1] ;
 wire \experiarSoC/core1_wb_sel_o[2] ;
 wire \experiarSoC/core1_wb_sel_o[3] ;
 wire \experiarSoC/core1_wb_stall_i ;
 wire \experiarSoC/core1_wb_stb_o ;
 wire \experiarSoC/core1_wb_we_o ;
 wire \experiarSoC/flashSRAM_addr0[0] ;
 wire \experiarSoC/flashSRAM_addr0[1] ;
 wire \experiarSoC/flashSRAM_addr0[2] ;
 wire \experiarSoC/flashSRAM_addr0[3] ;
 wire \experiarSoC/flashSRAM_addr0[4] ;
 wire \experiarSoC/flashSRAM_addr0[5] ;
 wire \experiarSoC/flashSRAM_addr0[6] ;
 wire \experiarSoC/flashSRAM_addr0[7] ;
 wire \experiarSoC/flashSRAM_addr0[8] ;
 wire \experiarSoC/flashSRAM_addr1[0] ;
 wire \experiarSoC/flashSRAM_addr1[1] ;
 wire \experiarSoC/flashSRAM_addr1[2] ;
 wire \experiarSoC/flashSRAM_addr1[3] ;
 wire \experiarSoC/flashSRAM_addr1[4] ;
 wire \experiarSoC/flashSRAM_addr1[5] ;
 wire \experiarSoC/flashSRAM_addr1[6] ;
 wire \experiarSoC/flashSRAM_addr1[7] ;
 wire \experiarSoC/flashSRAM_addr1[8] ;
 wire \experiarSoC/flashSRAM_clk0 ;
 wire \experiarSoC/flashSRAM_clk1 ;
 wire \experiarSoC/flashSRAM_csb0 ;
 wire \experiarSoC/flashSRAM_csb1 ;
 wire \experiarSoC/flashSRAM_din0[0] ;
 wire \experiarSoC/flashSRAM_din0[10] ;
 wire \experiarSoC/flashSRAM_din0[11] ;
 wire \experiarSoC/flashSRAM_din0[12] ;
 wire \experiarSoC/flashSRAM_din0[13] ;
 wire \experiarSoC/flashSRAM_din0[14] ;
 wire \experiarSoC/flashSRAM_din0[15] ;
 wire \experiarSoC/flashSRAM_din0[16] ;
 wire \experiarSoC/flashSRAM_din0[17] ;
 wire \experiarSoC/flashSRAM_din0[18] ;
 wire \experiarSoC/flashSRAM_din0[19] ;
 wire \experiarSoC/flashSRAM_din0[1] ;
 wire \experiarSoC/flashSRAM_din0[20] ;
 wire \experiarSoC/flashSRAM_din0[21] ;
 wire \experiarSoC/flashSRAM_din0[22] ;
 wire \experiarSoC/flashSRAM_din0[23] ;
 wire \experiarSoC/flashSRAM_din0[24] ;
 wire \experiarSoC/flashSRAM_din0[25] ;
 wire \experiarSoC/flashSRAM_din0[26] ;
 wire \experiarSoC/flashSRAM_din0[27] ;
 wire \experiarSoC/flashSRAM_din0[28] ;
 wire \experiarSoC/flashSRAM_din0[29] ;
 wire \experiarSoC/flashSRAM_din0[2] ;
 wire \experiarSoC/flashSRAM_din0[30] ;
 wire \experiarSoC/flashSRAM_din0[31] ;
 wire \experiarSoC/flashSRAM_din0[3] ;
 wire \experiarSoC/flashSRAM_din0[4] ;
 wire \experiarSoC/flashSRAM_din0[5] ;
 wire \experiarSoC/flashSRAM_din0[6] ;
 wire \experiarSoC/flashSRAM_din0[7] ;
 wire \experiarSoC/flashSRAM_din0[8] ;
 wire \experiarSoC/flashSRAM_din0[9] ;
 wire \experiarSoC/flashSRAM_dout0[0] ;
 wire \experiarSoC/flashSRAM_dout0[10] ;
 wire \experiarSoC/flashSRAM_dout0[11] ;
 wire \experiarSoC/flashSRAM_dout0[12] ;
 wire \experiarSoC/flashSRAM_dout0[13] ;
 wire \experiarSoC/flashSRAM_dout0[14] ;
 wire \experiarSoC/flashSRAM_dout0[15] ;
 wire \experiarSoC/flashSRAM_dout0[16] ;
 wire \experiarSoC/flashSRAM_dout0[17] ;
 wire \experiarSoC/flashSRAM_dout0[18] ;
 wire \experiarSoC/flashSRAM_dout0[19] ;
 wire \experiarSoC/flashSRAM_dout0[1] ;
 wire \experiarSoC/flashSRAM_dout0[20] ;
 wire \experiarSoC/flashSRAM_dout0[21] ;
 wire \experiarSoC/flashSRAM_dout0[22] ;
 wire \experiarSoC/flashSRAM_dout0[23] ;
 wire \experiarSoC/flashSRAM_dout0[24] ;
 wire \experiarSoC/flashSRAM_dout0[25] ;
 wire \experiarSoC/flashSRAM_dout0[26] ;
 wire \experiarSoC/flashSRAM_dout0[27] ;
 wire \experiarSoC/flashSRAM_dout0[28] ;
 wire \experiarSoC/flashSRAM_dout0[29] ;
 wire \experiarSoC/flashSRAM_dout0[2] ;
 wire \experiarSoC/flashSRAM_dout0[30] ;
 wire \experiarSoC/flashSRAM_dout0[31] ;
 wire \experiarSoC/flashSRAM_dout0[3] ;
 wire \experiarSoC/flashSRAM_dout0[4] ;
 wire \experiarSoC/flashSRAM_dout0[5] ;
 wire \experiarSoC/flashSRAM_dout0[6] ;
 wire \experiarSoC/flashSRAM_dout0[7] ;
 wire \experiarSoC/flashSRAM_dout0[8] ;
 wire \experiarSoC/flashSRAM_dout0[9] ;
 wire \experiarSoC/flashSRAM_dout1[0] ;
 wire \experiarSoC/flashSRAM_dout1[10] ;
 wire \experiarSoC/flashSRAM_dout1[11] ;
 wire \experiarSoC/flashSRAM_dout1[12] ;
 wire \experiarSoC/flashSRAM_dout1[13] ;
 wire \experiarSoC/flashSRAM_dout1[14] ;
 wire \experiarSoC/flashSRAM_dout1[15] ;
 wire \experiarSoC/flashSRAM_dout1[16] ;
 wire \experiarSoC/flashSRAM_dout1[17] ;
 wire \experiarSoC/flashSRAM_dout1[18] ;
 wire \experiarSoC/flashSRAM_dout1[19] ;
 wire \experiarSoC/flashSRAM_dout1[1] ;
 wire \experiarSoC/flashSRAM_dout1[20] ;
 wire \experiarSoC/flashSRAM_dout1[21] ;
 wire \experiarSoC/flashSRAM_dout1[22] ;
 wire \experiarSoC/flashSRAM_dout1[23] ;
 wire \experiarSoC/flashSRAM_dout1[24] ;
 wire \experiarSoC/flashSRAM_dout1[25] ;
 wire \experiarSoC/flashSRAM_dout1[26] ;
 wire \experiarSoC/flashSRAM_dout1[27] ;
 wire \experiarSoC/flashSRAM_dout1[28] ;
 wire \experiarSoC/flashSRAM_dout1[29] ;
 wire \experiarSoC/flashSRAM_dout1[2] ;
 wire \experiarSoC/flashSRAM_dout1[30] ;
 wire \experiarSoC/flashSRAM_dout1[31] ;
 wire \experiarSoC/flashSRAM_dout1[3] ;
 wire \experiarSoC/flashSRAM_dout1[4] ;
 wire \experiarSoC/flashSRAM_dout1[5] ;
 wire \experiarSoC/flashSRAM_dout1[6] ;
 wire \experiarSoC/flashSRAM_dout1[7] ;
 wire \experiarSoC/flashSRAM_dout1[8] ;
 wire \experiarSoC/flashSRAM_dout1[9] ;
 wire \experiarSoC/flashSRAM_web0 ;
 wire \experiarSoC/flashSRAM_wmask0[0] ;
 wire \experiarSoC/flashSRAM_wmask0[1] ;
 wire \experiarSoC/flashSRAM_wmask0[2] ;
 wire \experiarSoC/flashSRAM_wmask0[3] ;
 wire \experiarSoC/flash_csb ;
 wire \experiarSoC/flash_io0_read ;
 wire \experiarSoC/flash_io0_we ;
 wire \experiarSoC/flash_io0_write ;
 wire \experiarSoC/flash_io1_read ;
 wire \experiarSoC/flash_io1_we ;
 wire \experiarSoC/flash_io1_write ;
 wire \experiarSoC/flash_sck ;
 wire \experiarSoC/flash_wb_ack_o ;
 wire \experiarSoC/flash_wb_adr_i[0] ;
 wire \experiarSoC/flash_wb_adr_i[10] ;
 wire \experiarSoC/flash_wb_adr_i[11] ;
 wire \experiarSoC/flash_wb_adr_i[12] ;
 wire \experiarSoC/flash_wb_adr_i[13] ;
 wire \experiarSoC/flash_wb_adr_i[14] ;
 wire \experiarSoC/flash_wb_adr_i[15] ;
 wire \experiarSoC/flash_wb_adr_i[16] ;
 wire \experiarSoC/flash_wb_adr_i[17] ;
 wire \experiarSoC/flash_wb_adr_i[18] ;
 wire \experiarSoC/flash_wb_adr_i[19] ;
 wire \experiarSoC/flash_wb_adr_i[1] ;
 wire \experiarSoC/flash_wb_adr_i[20] ;
 wire \experiarSoC/flash_wb_adr_i[21] ;
 wire \experiarSoC/flash_wb_adr_i[22] ;
 wire \experiarSoC/flash_wb_adr_i[23] ;
 wire \experiarSoC/flash_wb_adr_i[2] ;
 wire \experiarSoC/flash_wb_adr_i[3] ;
 wire \experiarSoC/flash_wb_adr_i[4] ;
 wire \experiarSoC/flash_wb_adr_i[5] ;
 wire \experiarSoC/flash_wb_adr_i[6] ;
 wire \experiarSoC/flash_wb_adr_i[7] ;
 wire \experiarSoC/flash_wb_adr_i[8] ;
 wire \experiarSoC/flash_wb_adr_i[9] ;
 wire \experiarSoC/flash_wb_cyc_i ;
 wire \experiarSoC/flash_wb_data_i[0] ;
 wire \experiarSoC/flash_wb_data_i[10] ;
 wire \experiarSoC/flash_wb_data_i[11] ;
 wire \experiarSoC/flash_wb_data_i[12] ;
 wire \experiarSoC/flash_wb_data_i[13] ;
 wire \experiarSoC/flash_wb_data_i[14] ;
 wire \experiarSoC/flash_wb_data_i[15] ;
 wire \experiarSoC/flash_wb_data_i[16] ;
 wire \experiarSoC/flash_wb_data_i[17] ;
 wire \experiarSoC/flash_wb_data_i[18] ;
 wire \experiarSoC/flash_wb_data_i[19] ;
 wire \experiarSoC/flash_wb_data_i[1] ;
 wire \experiarSoC/flash_wb_data_i[20] ;
 wire \experiarSoC/flash_wb_data_i[21] ;
 wire \experiarSoC/flash_wb_data_i[22] ;
 wire \experiarSoC/flash_wb_data_i[23] ;
 wire \experiarSoC/flash_wb_data_i[24] ;
 wire \experiarSoC/flash_wb_data_i[25] ;
 wire \experiarSoC/flash_wb_data_i[26] ;
 wire \experiarSoC/flash_wb_data_i[27] ;
 wire \experiarSoC/flash_wb_data_i[28] ;
 wire \experiarSoC/flash_wb_data_i[29] ;
 wire \experiarSoC/flash_wb_data_i[2] ;
 wire \experiarSoC/flash_wb_data_i[30] ;
 wire \experiarSoC/flash_wb_data_i[31] ;
 wire \experiarSoC/flash_wb_data_i[3] ;
 wire \experiarSoC/flash_wb_data_i[4] ;
 wire \experiarSoC/flash_wb_data_i[5] ;
 wire \experiarSoC/flash_wb_data_i[6] ;
 wire \experiarSoC/flash_wb_data_i[7] ;
 wire \experiarSoC/flash_wb_data_i[8] ;
 wire \experiarSoC/flash_wb_data_i[9] ;
 wire \experiarSoC/flash_wb_data_o[0] ;
 wire \experiarSoC/flash_wb_data_o[10] ;
 wire \experiarSoC/flash_wb_data_o[11] ;
 wire \experiarSoC/flash_wb_data_o[12] ;
 wire \experiarSoC/flash_wb_data_o[13] ;
 wire \experiarSoC/flash_wb_data_o[14] ;
 wire \experiarSoC/flash_wb_data_o[15] ;
 wire \experiarSoC/flash_wb_data_o[16] ;
 wire \experiarSoC/flash_wb_data_o[17] ;
 wire \experiarSoC/flash_wb_data_o[18] ;
 wire \experiarSoC/flash_wb_data_o[19] ;
 wire \experiarSoC/flash_wb_data_o[1] ;
 wire \experiarSoC/flash_wb_data_o[20] ;
 wire \experiarSoC/flash_wb_data_o[21] ;
 wire \experiarSoC/flash_wb_data_o[22] ;
 wire \experiarSoC/flash_wb_data_o[23] ;
 wire \experiarSoC/flash_wb_data_o[24] ;
 wire \experiarSoC/flash_wb_data_o[25] ;
 wire \experiarSoC/flash_wb_data_o[26] ;
 wire \experiarSoC/flash_wb_data_o[27] ;
 wire \experiarSoC/flash_wb_data_o[28] ;
 wire \experiarSoC/flash_wb_data_o[29] ;
 wire \experiarSoC/flash_wb_data_o[2] ;
 wire \experiarSoC/flash_wb_data_o[30] ;
 wire \experiarSoC/flash_wb_data_o[31] ;
 wire \experiarSoC/flash_wb_data_o[3] ;
 wire \experiarSoC/flash_wb_data_o[4] ;
 wire \experiarSoC/flash_wb_data_o[5] ;
 wire \experiarSoC/flash_wb_data_o[6] ;
 wire \experiarSoC/flash_wb_data_o[7] ;
 wire \experiarSoC/flash_wb_data_o[8] ;
 wire \experiarSoC/flash_wb_data_o[9] ;
 wire \experiarSoC/flash_wb_error_o ;
 wire \experiarSoC/flash_wb_sel_i[0] ;
 wire \experiarSoC/flash_wb_sel_i[1] ;
 wire \experiarSoC/flash_wb_sel_i[2] ;
 wire \experiarSoC/flash_wb_sel_i[3] ;
 wire \experiarSoC/flash_wb_stall_o ;
 wire \experiarSoC/flash_wb_stb_i ;
 wire \experiarSoC/flash_wb_we_i ;
 wire \experiarSoC/jtag_tck ;
 wire \experiarSoC/jtag_tms ;
 wire \experiarSoC/peripherals_wb_ack_o ;
 wire \experiarSoC/peripherals_wb_adr_i[0] ;
 wire \experiarSoC/peripherals_wb_adr_i[10] ;
 wire \experiarSoC/peripherals_wb_adr_i[11] ;
 wire \experiarSoC/peripherals_wb_adr_i[12] ;
 wire \experiarSoC/peripherals_wb_adr_i[13] ;
 wire \experiarSoC/peripherals_wb_adr_i[14] ;
 wire \experiarSoC/peripherals_wb_adr_i[15] ;
 wire \experiarSoC/peripherals_wb_adr_i[16] ;
 wire \experiarSoC/peripherals_wb_adr_i[17] ;
 wire \experiarSoC/peripherals_wb_adr_i[18] ;
 wire \experiarSoC/peripherals_wb_adr_i[19] ;
 wire \experiarSoC/peripherals_wb_adr_i[1] ;
 wire \experiarSoC/peripherals_wb_adr_i[20] ;
 wire \experiarSoC/peripherals_wb_adr_i[21] ;
 wire \experiarSoC/peripherals_wb_adr_i[22] ;
 wire \experiarSoC/peripherals_wb_adr_i[23] ;
 wire \experiarSoC/peripherals_wb_adr_i[2] ;
 wire \experiarSoC/peripherals_wb_adr_i[3] ;
 wire \experiarSoC/peripherals_wb_adr_i[4] ;
 wire \experiarSoC/peripherals_wb_adr_i[5] ;
 wire \experiarSoC/peripherals_wb_adr_i[6] ;
 wire \experiarSoC/peripherals_wb_adr_i[7] ;
 wire \experiarSoC/peripherals_wb_adr_i[8] ;
 wire \experiarSoC/peripherals_wb_adr_i[9] ;
 wire \experiarSoC/peripherals_wb_cyc_i ;
 wire \experiarSoC/peripherals_wb_data_i[0] ;
 wire \experiarSoC/peripherals_wb_data_i[10] ;
 wire \experiarSoC/peripherals_wb_data_i[11] ;
 wire \experiarSoC/peripherals_wb_data_i[12] ;
 wire \experiarSoC/peripherals_wb_data_i[13] ;
 wire \experiarSoC/peripherals_wb_data_i[14] ;
 wire \experiarSoC/peripherals_wb_data_i[15] ;
 wire \experiarSoC/peripherals_wb_data_i[16] ;
 wire \experiarSoC/peripherals_wb_data_i[17] ;
 wire \experiarSoC/peripherals_wb_data_i[18] ;
 wire \experiarSoC/peripherals_wb_data_i[19] ;
 wire \experiarSoC/peripherals_wb_data_i[1] ;
 wire \experiarSoC/peripherals_wb_data_i[20] ;
 wire \experiarSoC/peripherals_wb_data_i[21] ;
 wire \experiarSoC/peripherals_wb_data_i[22] ;
 wire \experiarSoC/peripherals_wb_data_i[23] ;
 wire \experiarSoC/peripherals_wb_data_i[24] ;
 wire \experiarSoC/peripherals_wb_data_i[25] ;
 wire \experiarSoC/peripherals_wb_data_i[26] ;
 wire \experiarSoC/peripherals_wb_data_i[27] ;
 wire \experiarSoC/peripherals_wb_data_i[28] ;
 wire \experiarSoC/peripherals_wb_data_i[29] ;
 wire \experiarSoC/peripherals_wb_data_i[2] ;
 wire \experiarSoC/peripherals_wb_data_i[30] ;
 wire \experiarSoC/peripherals_wb_data_i[31] ;
 wire \experiarSoC/peripherals_wb_data_i[3] ;
 wire \experiarSoC/peripherals_wb_data_i[4] ;
 wire \experiarSoC/peripherals_wb_data_i[5] ;
 wire \experiarSoC/peripherals_wb_data_i[6] ;
 wire \experiarSoC/peripherals_wb_data_i[7] ;
 wire \experiarSoC/peripherals_wb_data_i[8] ;
 wire \experiarSoC/peripherals_wb_data_i[9] ;
 wire \experiarSoC/peripherals_wb_data_o[0] ;
 wire \experiarSoC/peripherals_wb_data_o[10] ;
 wire \experiarSoC/peripherals_wb_data_o[11] ;
 wire \experiarSoC/peripherals_wb_data_o[12] ;
 wire \experiarSoC/peripherals_wb_data_o[13] ;
 wire \experiarSoC/peripherals_wb_data_o[14] ;
 wire \experiarSoC/peripherals_wb_data_o[15] ;
 wire \experiarSoC/peripherals_wb_data_o[16] ;
 wire \experiarSoC/peripherals_wb_data_o[17] ;
 wire \experiarSoC/peripherals_wb_data_o[18] ;
 wire \experiarSoC/peripherals_wb_data_o[19] ;
 wire \experiarSoC/peripherals_wb_data_o[1] ;
 wire \experiarSoC/peripherals_wb_data_o[20] ;
 wire \experiarSoC/peripherals_wb_data_o[21] ;
 wire \experiarSoC/peripherals_wb_data_o[22] ;
 wire \experiarSoC/peripherals_wb_data_o[23] ;
 wire \experiarSoC/peripherals_wb_data_o[24] ;
 wire \experiarSoC/peripherals_wb_data_o[25] ;
 wire \experiarSoC/peripherals_wb_data_o[26] ;
 wire \experiarSoC/peripherals_wb_data_o[27] ;
 wire \experiarSoC/peripherals_wb_data_o[28] ;
 wire \experiarSoC/peripherals_wb_data_o[29] ;
 wire \experiarSoC/peripherals_wb_data_o[2] ;
 wire \experiarSoC/peripherals_wb_data_o[30] ;
 wire \experiarSoC/peripherals_wb_data_o[31] ;
 wire \experiarSoC/peripherals_wb_data_o[3] ;
 wire \experiarSoC/peripherals_wb_data_o[4] ;
 wire \experiarSoC/peripherals_wb_data_o[5] ;
 wire \experiarSoC/peripherals_wb_data_o[6] ;
 wire \experiarSoC/peripherals_wb_data_o[7] ;
 wire \experiarSoC/peripherals_wb_data_o[8] ;
 wire \experiarSoC/peripherals_wb_data_o[9] ;
 wire \experiarSoC/peripherals_wb_error_o ;
 wire \experiarSoC/peripherals_wb_sel_i[0] ;
 wire \experiarSoC/peripherals_wb_sel_i[1] ;
 wire \experiarSoC/peripherals_wb_sel_i[2] ;
 wire \experiarSoC/peripherals_wb_sel_i[3] ;
 wire \experiarSoC/peripherals_wb_stall_o ;
 wire \experiarSoC/peripherals_wb_stb_i ;
 wire \experiarSoC/peripherals_wb_we_i ;
 wire \experiarSoC/vga_b[0] ;
 wire \experiarSoC/vga_b[1] ;
 wire \experiarSoC/vga_g[0] ;
 wire \experiarSoC/vga_g[1] ;
 wire \experiarSoC/vga_hsync ;
 wire \experiarSoC/vga_r[0] ;
 wire \experiarSoC/vga_r[1] ;
 wire \experiarSoC/vga_vsync ;
 wire \experiarSoC/videoMemory_wb_ack_o ;
 wire \experiarSoC/videoMemory_wb_adr_i[0] ;
 wire \experiarSoC/videoMemory_wb_adr_i[10] ;
 wire \experiarSoC/videoMemory_wb_adr_i[11] ;
 wire \experiarSoC/videoMemory_wb_adr_i[12] ;
 wire \experiarSoC/videoMemory_wb_adr_i[13] ;
 wire \experiarSoC/videoMemory_wb_adr_i[14] ;
 wire \experiarSoC/videoMemory_wb_adr_i[15] ;
 wire \experiarSoC/videoMemory_wb_adr_i[16] ;
 wire \experiarSoC/videoMemory_wb_adr_i[17] ;
 wire \experiarSoC/videoMemory_wb_adr_i[18] ;
 wire \experiarSoC/videoMemory_wb_adr_i[19] ;
 wire \experiarSoC/videoMemory_wb_adr_i[1] ;
 wire \experiarSoC/videoMemory_wb_adr_i[20] ;
 wire \experiarSoC/videoMemory_wb_adr_i[21] ;
 wire \experiarSoC/videoMemory_wb_adr_i[22] ;
 wire \experiarSoC/videoMemory_wb_adr_i[23] ;
 wire \experiarSoC/videoMemory_wb_adr_i[2] ;
 wire \experiarSoC/videoMemory_wb_adr_i[3] ;
 wire \experiarSoC/videoMemory_wb_adr_i[4] ;
 wire \experiarSoC/videoMemory_wb_adr_i[5] ;
 wire \experiarSoC/videoMemory_wb_adr_i[6] ;
 wire \experiarSoC/videoMemory_wb_adr_i[7] ;
 wire \experiarSoC/videoMemory_wb_adr_i[8] ;
 wire \experiarSoC/videoMemory_wb_adr_i[9] ;
 wire \experiarSoC/videoMemory_wb_cyc_i ;
 wire \experiarSoC/videoMemory_wb_data_i[0] ;
 wire \experiarSoC/videoMemory_wb_data_i[10] ;
 wire \experiarSoC/videoMemory_wb_data_i[11] ;
 wire \experiarSoC/videoMemory_wb_data_i[12] ;
 wire \experiarSoC/videoMemory_wb_data_i[13] ;
 wire \experiarSoC/videoMemory_wb_data_i[14] ;
 wire \experiarSoC/videoMemory_wb_data_i[15] ;
 wire \experiarSoC/videoMemory_wb_data_i[16] ;
 wire \experiarSoC/videoMemory_wb_data_i[17] ;
 wire \experiarSoC/videoMemory_wb_data_i[18] ;
 wire \experiarSoC/videoMemory_wb_data_i[19] ;
 wire \experiarSoC/videoMemory_wb_data_i[1] ;
 wire \experiarSoC/videoMemory_wb_data_i[20] ;
 wire \experiarSoC/videoMemory_wb_data_i[21] ;
 wire \experiarSoC/videoMemory_wb_data_i[22] ;
 wire \experiarSoC/videoMemory_wb_data_i[23] ;
 wire \experiarSoC/videoMemory_wb_data_i[24] ;
 wire \experiarSoC/videoMemory_wb_data_i[25] ;
 wire \experiarSoC/videoMemory_wb_data_i[26] ;
 wire \experiarSoC/videoMemory_wb_data_i[27] ;
 wire \experiarSoC/videoMemory_wb_data_i[28] ;
 wire \experiarSoC/videoMemory_wb_data_i[29] ;
 wire \experiarSoC/videoMemory_wb_data_i[2] ;
 wire \experiarSoC/videoMemory_wb_data_i[30] ;
 wire \experiarSoC/videoMemory_wb_data_i[31] ;
 wire \experiarSoC/videoMemory_wb_data_i[3] ;
 wire \experiarSoC/videoMemory_wb_data_i[4] ;
 wire \experiarSoC/videoMemory_wb_data_i[5] ;
 wire \experiarSoC/videoMemory_wb_data_i[6] ;
 wire \experiarSoC/videoMemory_wb_data_i[7] ;
 wire \experiarSoC/videoMemory_wb_data_i[8] ;
 wire \experiarSoC/videoMemory_wb_data_i[9] ;
 wire \experiarSoC/videoMemory_wb_data_o[0] ;
 wire \experiarSoC/videoMemory_wb_data_o[10] ;
 wire \experiarSoC/videoMemory_wb_data_o[11] ;
 wire \experiarSoC/videoMemory_wb_data_o[12] ;
 wire \experiarSoC/videoMemory_wb_data_o[13] ;
 wire \experiarSoC/videoMemory_wb_data_o[14] ;
 wire \experiarSoC/videoMemory_wb_data_o[15] ;
 wire \experiarSoC/videoMemory_wb_data_o[16] ;
 wire \experiarSoC/videoMemory_wb_data_o[17] ;
 wire \experiarSoC/videoMemory_wb_data_o[18] ;
 wire \experiarSoC/videoMemory_wb_data_o[19] ;
 wire \experiarSoC/videoMemory_wb_data_o[1] ;
 wire \experiarSoC/videoMemory_wb_data_o[20] ;
 wire \experiarSoC/videoMemory_wb_data_o[21] ;
 wire \experiarSoC/videoMemory_wb_data_o[22] ;
 wire \experiarSoC/videoMemory_wb_data_o[23] ;
 wire \experiarSoC/videoMemory_wb_data_o[24] ;
 wire \experiarSoC/videoMemory_wb_data_o[25] ;
 wire \experiarSoC/videoMemory_wb_data_o[26] ;
 wire \experiarSoC/videoMemory_wb_data_o[27] ;
 wire \experiarSoC/videoMemory_wb_data_o[28] ;
 wire \experiarSoC/videoMemory_wb_data_o[29] ;
 wire \experiarSoC/videoMemory_wb_data_o[2] ;
 wire \experiarSoC/videoMemory_wb_data_o[30] ;
 wire \experiarSoC/videoMemory_wb_data_o[31] ;
 wire \experiarSoC/videoMemory_wb_data_o[3] ;
 wire \experiarSoC/videoMemory_wb_data_o[4] ;
 wire \experiarSoC/videoMemory_wb_data_o[5] ;
 wire \experiarSoC/videoMemory_wb_data_o[6] ;
 wire \experiarSoC/videoMemory_wb_data_o[7] ;
 wire \experiarSoC/videoMemory_wb_data_o[8] ;
 wire \experiarSoC/videoMemory_wb_data_o[9] ;
 wire \experiarSoC/videoMemory_wb_error_o ;
 wire \experiarSoC/videoMemory_wb_sel_i[0] ;
 wire \experiarSoC/videoMemory_wb_sel_i[1] ;
 wire \experiarSoC/videoMemory_wb_sel_i[2] ;
 wire \experiarSoC/videoMemory_wb_sel_i[3] ;
 wire \experiarSoC/videoMemory_wb_stall_o ;
 wire \experiarSoC/videoMemory_wb_stb_i ;
 wire \experiarSoC/videoMemory_wb_we_i ;
 wire \experiarSoC/videoSRAM0_dout0[0] ;
 wire \experiarSoC/videoSRAM0_dout0[10] ;
 wire \experiarSoC/videoSRAM0_dout0[11] ;
 wire \experiarSoC/videoSRAM0_dout0[12] ;
 wire \experiarSoC/videoSRAM0_dout0[13] ;
 wire \experiarSoC/videoSRAM0_dout0[14] ;
 wire \experiarSoC/videoSRAM0_dout0[15] ;
 wire \experiarSoC/videoSRAM0_dout0[16] ;
 wire \experiarSoC/videoSRAM0_dout0[17] ;
 wire \experiarSoC/videoSRAM0_dout0[18] ;
 wire \experiarSoC/videoSRAM0_dout0[19] ;
 wire \experiarSoC/videoSRAM0_dout0[1] ;
 wire \experiarSoC/videoSRAM0_dout0[20] ;
 wire \experiarSoC/videoSRAM0_dout0[21] ;
 wire \experiarSoC/videoSRAM0_dout0[22] ;
 wire \experiarSoC/videoSRAM0_dout0[23] ;
 wire \experiarSoC/videoSRAM0_dout0[24] ;
 wire \experiarSoC/videoSRAM0_dout0[25] ;
 wire \experiarSoC/videoSRAM0_dout0[26] ;
 wire \experiarSoC/videoSRAM0_dout0[27] ;
 wire \experiarSoC/videoSRAM0_dout0[28] ;
 wire \experiarSoC/videoSRAM0_dout0[29] ;
 wire \experiarSoC/videoSRAM0_dout0[2] ;
 wire \experiarSoC/videoSRAM0_dout0[30] ;
 wire \experiarSoC/videoSRAM0_dout0[31] ;
 wire \experiarSoC/videoSRAM0_dout0[3] ;
 wire \experiarSoC/videoSRAM0_dout0[4] ;
 wire \experiarSoC/videoSRAM0_dout0[5] ;
 wire \experiarSoC/videoSRAM0_dout0[6] ;
 wire \experiarSoC/videoSRAM0_dout0[7] ;
 wire \experiarSoC/videoSRAM0_dout0[8] ;
 wire \experiarSoC/videoSRAM0_dout0[9] ;
 wire \experiarSoC/videoSRAM0_dout1[0] ;
 wire \experiarSoC/videoSRAM0_dout1[10] ;
 wire \experiarSoC/videoSRAM0_dout1[11] ;
 wire \experiarSoC/videoSRAM0_dout1[12] ;
 wire \experiarSoC/videoSRAM0_dout1[13] ;
 wire \experiarSoC/videoSRAM0_dout1[14] ;
 wire \experiarSoC/videoSRAM0_dout1[15] ;
 wire \experiarSoC/videoSRAM0_dout1[16] ;
 wire \experiarSoC/videoSRAM0_dout1[17] ;
 wire \experiarSoC/videoSRAM0_dout1[18] ;
 wire \experiarSoC/videoSRAM0_dout1[19] ;
 wire \experiarSoC/videoSRAM0_dout1[1] ;
 wire \experiarSoC/videoSRAM0_dout1[20] ;
 wire \experiarSoC/videoSRAM0_dout1[21] ;
 wire \experiarSoC/videoSRAM0_dout1[22] ;
 wire \experiarSoC/videoSRAM0_dout1[23] ;
 wire \experiarSoC/videoSRAM0_dout1[24] ;
 wire \experiarSoC/videoSRAM0_dout1[25] ;
 wire \experiarSoC/videoSRAM0_dout1[26] ;
 wire \experiarSoC/videoSRAM0_dout1[27] ;
 wire \experiarSoC/videoSRAM0_dout1[28] ;
 wire \experiarSoC/videoSRAM0_dout1[29] ;
 wire \experiarSoC/videoSRAM0_dout1[2] ;
 wire \experiarSoC/videoSRAM0_dout1[30] ;
 wire \experiarSoC/videoSRAM0_dout1[31] ;
 wire \experiarSoC/videoSRAM0_dout1[3] ;
 wire \experiarSoC/videoSRAM0_dout1[4] ;
 wire \experiarSoC/videoSRAM0_dout1[5] ;
 wire \experiarSoC/videoSRAM0_dout1[6] ;
 wire \experiarSoC/videoSRAM0_dout1[7] ;
 wire \experiarSoC/videoSRAM0_dout1[8] ;
 wire \experiarSoC/videoSRAM0_dout1[9] ;
 wire \experiarSoC/videoSRAM1_dout0[0] ;
 wire \experiarSoC/videoSRAM1_dout0[10] ;
 wire \experiarSoC/videoSRAM1_dout0[11] ;
 wire \experiarSoC/videoSRAM1_dout0[12] ;
 wire \experiarSoC/videoSRAM1_dout0[13] ;
 wire \experiarSoC/videoSRAM1_dout0[14] ;
 wire \experiarSoC/videoSRAM1_dout0[15] ;
 wire \experiarSoC/videoSRAM1_dout0[16] ;
 wire \experiarSoC/videoSRAM1_dout0[17] ;
 wire \experiarSoC/videoSRAM1_dout0[18] ;
 wire \experiarSoC/videoSRAM1_dout0[19] ;
 wire \experiarSoC/videoSRAM1_dout0[1] ;
 wire \experiarSoC/videoSRAM1_dout0[20] ;
 wire \experiarSoC/videoSRAM1_dout0[21] ;
 wire \experiarSoC/videoSRAM1_dout0[22] ;
 wire \experiarSoC/videoSRAM1_dout0[23] ;
 wire \experiarSoC/videoSRAM1_dout0[24] ;
 wire \experiarSoC/videoSRAM1_dout0[25] ;
 wire \experiarSoC/videoSRAM1_dout0[26] ;
 wire \experiarSoC/videoSRAM1_dout0[27] ;
 wire \experiarSoC/videoSRAM1_dout0[28] ;
 wire \experiarSoC/videoSRAM1_dout0[29] ;
 wire \experiarSoC/videoSRAM1_dout0[2] ;
 wire \experiarSoC/videoSRAM1_dout0[30] ;
 wire \experiarSoC/videoSRAM1_dout0[31] ;
 wire \experiarSoC/videoSRAM1_dout0[3] ;
 wire \experiarSoC/videoSRAM1_dout0[4] ;
 wire \experiarSoC/videoSRAM1_dout0[5] ;
 wire \experiarSoC/videoSRAM1_dout0[6] ;
 wire \experiarSoC/videoSRAM1_dout0[7] ;
 wire \experiarSoC/videoSRAM1_dout0[8] ;
 wire \experiarSoC/videoSRAM1_dout0[9] ;
 wire \experiarSoC/videoSRAM1_dout1[0] ;
 wire \experiarSoC/videoSRAM1_dout1[10] ;
 wire \experiarSoC/videoSRAM1_dout1[11] ;
 wire \experiarSoC/videoSRAM1_dout1[12] ;
 wire \experiarSoC/videoSRAM1_dout1[13] ;
 wire \experiarSoC/videoSRAM1_dout1[14] ;
 wire \experiarSoC/videoSRAM1_dout1[15] ;
 wire \experiarSoC/videoSRAM1_dout1[16] ;
 wire \experiarSoC/videoSRAM1_dout1[17] ;
 wire \experiarSoC/videoSRAM1_dout1[18] ;
 wire \experiarSoC/videoSRAM1_dout1[19] ;
 wire \experiarSoC/videoSRAM1_dout1[1] ;
 wire \experiarSoC/videoSRAM1_dout1[20] ;
 wire \experiarSoC/videoSRAM1_dout1[21] ;
 wire \experiarSoC/videoSRAM1_dout1[22] ;
 wire \experiarSoC/videoSRAM1_dout1[23] ;
 wire \experiarSoC/videoSRAM1_dout1[24] ;
 wire \experiarSoC/videoSRAM1_dout1[25] ;
 wire \experiarSoC/videoSRAM1_dout1[26] ;
 wire \experiarSoC/videoSRAM1_dout1[27] ;
 wire \experiarSoC/videoSRAM1_dout1[28] ;
 wire \experiarSoC/videoSRAM1_dout1[29] ;
 wire \experiarSoC/videoSRAM1_dout1[2] ;
 wire \experiarSoC/videoSRAM1_dout1[30] ;
 wire \experiarSoC/videoSRAM1_dout1[31] ;
 wire \experiarSoC/videoSRAM1_dout1[3] ;
 wire \experiarSoC/videoSRAM1_dout1[4] ;
 wire \experiarSoC/videoSRAM1_dout1[5] ;
 wire \experiarSoC/videoSRAM1_dout1[6] ;
 wire \experiarSoC/videoSRAM1_dout1[7] ;
 wire \experiarSoC/videoSRAM1_dout1[8] ;
 wire \experiarSoC/videoSRAM1_dout1[9] ;
 wire \experiarSoC/videoSRAM2_dout0[0] ;
 wire \experiarSoC/videoSRAM2_dout0[10] ;
 wire \experiarSoC/videoSRAM2_dout0[11] ;
 wire \experiarSoC/videoSRAM2_dout0[12] ;
 wire \experiarSoC/videoSRAM2_dout0[13] ;
 wire \experiarSoC/videoSRAM2_dout0[14] ;
 wire \experiarSoC/videoSRAM2_dout0[15] ;
 wire \experiarSoC/videoSRAM2_dout0[16] ;
 wire \experiarSoC/videoSRAM2_dout0[17] ;
 wire \experiarSoC/videoSRAM2_dout0[18] ;
 wire \experiarSoC/videoSRAM2_dout0[19] ;
 wire \experiarSoC/videoSRAM2_dout0[1] ;
 wire \experiarSoC/videoSRAM2_dout0[20] ;
 wire \experiarSoC/videoSRAM2_dout0[21] ;
 wire \experiarSoC/videoSRAM2_dout0[22] ;
 wire \experiarSoC/videoSRAM2_dout0[23] ;
 wire \experiarSoC/videoSRAM2_dout0[24] ;
 wire \experiarSoC/videoSRAM2_dout0[25] ;
 wire \experiarSoC/videoSRAM2_dout0[26] ;
 wire \experiarSoC/videoSRAM2_dout0[27] ;
 wire \experiarSoC/videoSRAM2_dout0[28] ;
 wire \experiarSoC/videoSRAM2_dout0[29] ;
 wire \experiarSoC/videoSRAM2_dout0[2] ;
 wire \experiarSoC/videoSRAM2_dout0[30] ;
 wire \experiarSoC/videoSRAM2_dout0[31] ;
 wire \experiarSoC/videoSRAM2_dout0[3] ;
 wire \experiarSoC/videoSRAM2_dout0[4] ;
 wire \experiarSoC/videoSRAM2_dout0[5] ;
 wire \experiarSoC/videoSRAM2_dout0[6] ;
 wire \experiarSoC/videoSRAM2_dout0[7] ;
 wire \experiarSoC/videoSRAM2_dout0[8] ;
 wire \experiarSoC/videoSRAM2_dout0[9] ;
 wire \experiarSoC/videoSRAM2_dout1[0] ;
 wire \experiarSoC/videoSRAM2_dout1[10] ;
 wire \experiarSoC/videoSRAM2_dout1[11] ;
 wire \experiarSoC/videoSRAM2_dout1[12] ;
 wire \experiarSoC/videoSRAM2_dout1[13] ;
 wire \experiarSoC/videoSRAM2_dout1[14] ;
 wire \experiarSoC/videoSRAM2_dout1[15] ;
 wire \experiarSoC/videoSRAM2_dout1[16] ;
 wire \experiarSoC/videoSRAM2_dout1[17] ;
 wire \experiarSoC/videoSRAM2_dout1[18] ;
 wire \experiarSoC/videoSRAM2_dout1[19] ;
 wire \experiarSoC/videoSRAM2_dout1[1] ;
 wire \experiarSoC/videoSRAM2_dout1[20] ;
 wire \experiarSoC/videoSRAM2_dout1[21] ;
 wire \experiarSoC/videoSRAM2_dout1[22] ;
 wire \experiarSoC/videoSRAM2_dout1[23] ;
 wire \experiarSoC/videoSRAM2_dout1[24] ;
 wire \experiarSoC/videoSRAM2_dout1[25] ;
 wire \experiarSoC/videoSRAM2_dout1[26] ;
 wire \experiarSoC/videoSRAM2_dout1[27] ;
 wire \experiarSoC/videoSRAM2_dout1[28] ;
 wire \experiarSoC/videoSRAM2_dout1[29] ;
 wire \experiarSoC/videoSRAM2_dout1[2] ;
 wire \experiarSoC/videoSRAM2_dout1[30] ;
 wire \experiarSoC/videoSRAM2_dout1[31] ;
 wire \experiarSoC/videoSRAM2_dout1[3] ;
 wire \experiarSoC/videoSRAM2_dout1[4] ;
 wire \experiarSoC/videoSRAM2_dout1[5] ;
 wire \experiarSoC/videoSRAM2_dout1[6] ;
 wire \experiarSoC/videoSRAM2_dout1[7] ;
 wire \experiarSoC/videoSRAM2_dout1[8] ;
 wire \experiarSoC/videoSRAM2_dout1[9] ;
 wire \experiarSoC/videoSRAM3_dout0[0] ;
 wire \experiarSoC/videoSRAM3_dout0[10] ;
 wire \experiarSoC/videoSRAM3_dout0[11] ;
 wire \experiarSoC/videoSRAM3_dout0[12] ;
 wire \experiarSoC/videoSRAM3_dout0[13] ;
 wire \experiarSoC/videoSRAM3_dout0[14] ;
 wire \experiarSoC/videoSRAM3_dout0[15] ;
 wire \experiarSoC/videoSRAM3_dout0[16] ;
 wire \experiarSoC/videoSRAM3_dout0[17] ;
 wire \experiarSoC/videoSRAM3_dout0[18] ;
 wire \experiarSoC/videoSRAM3_dout0[19] ;
 wire \experiarSoC/videoSRAM3_dout0[1] ;
 wire \experiarSoC/videoSRAM3_dout0[20] ;
 wire \experiarSoC/videoSRAM3_dout0[21] ;
 wire \experiarSoC/videoSRAM3_dout0[22] ;
 wire \experiarSoC/videoSRAM3_dout0[23] ;
 wire \experiarSoC/videoSRAM3_dout0[24] ;
 wire \experiarSoC/videoSRAM3_dout0[25] ;
 wire \experiarSoC/videoSRAM3_dout0[26] ;
 wire \experiarSoC/videoSRAM3_dout0[27] ;
 wire \experiarSoC/videoSRAM3_dout0[28] ;
 wire \experiarSoC/videoSRAM3_dout0[29] ;
 wire \experiarSoC/videoSRAM3_dout0[2] ;
 wire \experiarSoC/videoSRAM3_dout0[30] ;
 wire \experiarSoC/videoSRAM3_dout0[31] ;
 wire \experiarSoC/videoSRAM3_dout0[3] ;
 wire \experiarSoC/videoSRAM3_dout0[4] ;
 wire \experiarSoC/videoSRAM3_dout0[5] ;
 wire \experiarSoC/videoSRAM3_dout0[6] ;
 wire \experiarSoC/videoSRAM3_dout0[7] ;
 wire \experiarSoC/videoSRAM3_dout0[8] ;
 wire \experiarSoC/videoSRAM3_dout0[9] ;
 wire \experiarSoC/videoSRAM3_dout1[0] ;
 wire \experiarSoC/videoSRAM3_dout1[10] ;
 wire \experiarSoC/videoSRAM3_dout1[11] ;
 wire \experiarSoC/videoSRAM3_dout1[12] ;
 wire \experiarSoC/videoSRAM3_dout1[13] ;
 wire \experiarSoC/videoSRAM3_dout1[14] ;
 wire \experiarSoC/videoSRAM3_dout1[15] ;
 wire \experiarSoC/videoSRAM3_dout1[16] ;
 wire \experiarSoC/videoSRAM3_dout1[17] ;
 wire \experiarSoC/videoSRAM3_dout1[18] ;
 wire \experiarSoC/videoSRAM3_dout1[19] ;
 wire \experiarSoC/videoSRAM3_dout1[1] ;
 wire \experiarSoC/videoSRAM3_dout1[20] ;
 wire \experiarSoC/videoSRAM3_dout1[21] ;
 wire \experiarSoC/videoSRAM3_dout1[22] ;
 wire \experiarSoC/videoSRAM3_dout1[23] ;
 wire \experiarSoC/videoSRAM3_dout1[24] ;
 wire \experiarSoC/videoSRAM3_dout1[25] ;
 wire \experiarSoC/videoSRAM3_dout1[26] ;
 wire \experiarSoC/videoSRAM3_dout1[27] ;
 wire \experiarSoC/videoSRAM3_dout1[28] ;
 wire \experiarSoC/videoSRAM3_dout1[29] ;
 wire \experiarSoC/videoSRAM3_dout1[2] ;
 wire \experiarSoC/videoSRAM3_dout1[30] ;
 wire \experiarSoC/videoSRAM3_dout1[31] ;
 wire \experiarSoC/videoSRAM3_dout1[3] ;
 wire \experiarSoC/videoSRAM3_dout1[4] ;
 wire \experiarSoC/videoSRAM3_dout1[5] ;
 wire \experiarSoC/videoSRAM3_dout1[6] ;
 wire \experiarSoC/videoSRAM3_dout1[7] ;
 wire \experiarSoC/videoSRAM3_dout1[8] ;
 wire \experiarSoC/videoSRAM3_dout1[9] ;
 wire \experiarSoC/videoSRAMLeft_addr0[0] ;
 wire \experiarSoC/videoSRAMLeft_addr0[1] ;
 wire \experiarSoC/videoSRAMLeft_addr0[2] ;
 wire \experiarSoC/videoSRAMLeft_addr0[3] ;
 wire \experiarSoC/videoSRAMLeft_addr0[4] ;
 wire \experiarSoC/videoSRAMLeft_addr0[5] ;
 wire \experiarSoC/videoSRAMLeft_addr0[6] ;
 wire \experiarSoC/videoSRAMLeft_addr0[7] ;
 wire \experiarSoC/videoSRAMLeft_addr0[8] ;
 wire \experiarSoC/videoSRAMLeft_addr1[0] ;
 wire \experiarSoC/videoSRAMLeft_addr1[1] ;
 wire \experiarSoC/videoSRAMLeft_addr1[2] ;
 wire \experiarSoC/videoSRAMLeft_addr1[3] ;
 wire \experiarSoC/videoSRAMLeft_addr1[4] ;
 wire \experiarSoC/videoSRAMLeft_addr1[5] ;
 wire \experiarSoC/videoSRAMLeft_addr1[6] ;
 wire \experiarSoC/videoSRAMLeft_addr1[7] ;
 wire \experiarSoC/videoSRAMLeft_addr1[8] ;
 wire \experiarSoC/videoSRAMLeft_clk0 ;
 wire \experiarSoC/videoSRAMLeft_clk1 ;
 wire \experiarSoC/videoSRAMLeft_csb0[0] ;
 wire \experiarSoC/videoSRAMLeft_csb0[1] ;
 wire \experiarSoC/videoSRAMLeft_csb1[0] ;
 wire \experiarSoC/videoSRAMLeft_csb1[1] ;
 wire \experiarSoC/videoSRAMLeft_din0[0] ;
 wire \experiarSoC/videoSRAMLeft_din0[10] ;
 wire \experiarSoC/videoSRAMLeft_din0[11] ;
 wire \experiarSoC/videoSRAMLeft_din0[12] ;
 wire \experiarSoC/videoSRAMLeft_din0[13] ;
 wire \experiarSoC/videoSRAMLeft_din0[14] ;
 wire \experiarSoC/videoSRAMLeft_din0[15] ;
 wire \experiarSoC/videoSRAMLeft_din0[16] ;
 wire \experiarSoC/videoSRAMLeft_din0[17] ;
 wire \experiarSoC/videoSRAMLeft_din0[18] ;
 wire \experiarSoC/videoSRAMLeft_din0[19] ;
 wire \experiarSoC/videoSRAMLeft_din0[1] ;
 wire \experiarSoC/videoSRAMLeft_din0[20] ;
 wire \experiarSoC/videoSRAMLeft_din0[21] ;
 wire \experiarSoC/videoSRAMLeft_din0[22] ;
 wire \experiarSoC/videoSRAMLeft_din0[23] ;
 wire \experiarSoC/videoSRAMLeft_din0[24] ;
 wire \experiarSoC/videoSRAMLeft_din0[25] ;
 wire \experiarSoC/videoSRAMLeft_din0[26] ;
 wire \experiarSoC/videoSRAMLeft_din0[27] ;
 wire \experiarSoC/videoSRAMLeft_din0[28] ;
 wire \experiarSoC/videoSRAMLeft_din0[29] ;
 wire \experiarSoC/videoSRAMLeft_din0[2] ;
 wire \experiarSoC/videoSRAMLeft_din0[30] ;
 wire \experiarSoC/videoSRAMLeft_din0[31] ;
 wire \experiarSoC/videoSRAMLeft_din0[3] ;
 wire \experiarSoC/videoSRAMLeft_din0[4] ;
 wire \experiarSoC/videoSRAMLeft_din0[5] ;
 wire \experiarSoC/videoSRAMLeft_din0[6] ;
 wire \experiarSoC/videoSRAMLeft_din0[7] ;
 wire \experiarSoC/videoSRAMLeft_din0[8] ;
 wire \experiarSoC/videoSRAMLeft_din0[9] ;
 wire \experiarSoC/videoSRAMLeft_web0 ;
 wire \experiarSoC/videoSRAMLeft_wmask0[0] ;
 wire \experiarSoC/videoSRAMLeft_wmask0[1] ;
 wire \experiarSoC/videoSRAMLeft_wmask0[2] ;
 wire \experiarSoC/videoSRAMLeft_wmask0[3] ;
 wire \experiarSoC/videoSRAMRight_addr0[0] ;
 wire \experiarSoC/videoSRAMRight_addr0[1] ;
 wire \experiarSoC/videoSRAMRight_addr0[2] ;
 wire \experiarSoC/videoSRAMRight_addr0[3] ;
 wire \experiarSoC/videoSRAMRight_addr0[4] ;
 wire \experiarSoC/videoSRAMRight_addr0[5] ;
 wire \experiarSoC/videoSRAMRight_addr0[6] ;
 wire \experiarSoC/videoSRAMRight_addr0[7] ;
 wire \experiarSoC/videoSRAMRight_addr0[8] ;
 wire \experiarSoC/videoSRAMRight_addr1[0] ;
 wire \experiarSoC/videoSRAMRight_addr1[1] ;
 wire \experiarSoC/videoSRAMRight_addr1[2] ;
 wire \experiarSoC/videoSRAMRight_addr1[3] ;
 wire \experiarSoC/videoSRAMRight_addr1[4] ;
 wire \experiarSoC/videoSRAMRight_addr1[5] ;
 wire \experiarSoC/videoSRAMRight_addr1[6] ;
 wire \experiarSoC/videoSRAMRight_addr1[7] ;
 wire \experiarSoC/videoSRAMRight_addr1[8] ;
 wire \experiarSoC/videoSRAMRight_clk0 ;
 wire \experiarSoC/videoSRAMRight_clk1 ;
 wire \experiarSoC/videoSRAMRight_csb0[0] ;
 wire \experiarSoC/videoSRAMRight_csb0[1] ;
 wire \experiarSoC/videoSRAMRight_csb1[0] ;
 wire \experiarSoC/videoSRAMRight_csb1[1] ;
 wire \experiarSoC/videoSRAMRight_din0[0] ;
 wire \experiarSoC/videoSRAMRight_din0[10] ;
 wire \experiarSoC/videoSRAMRight_din0[11] ;
 wire \experiarSoC/videoSRAMRight_din0[12] ;
 wire \experiarSoC/videoSRAMRight_din0[13] ;
 wire \experiarSoC/videoSRAMRight_din0[14] ;
 wire \experiarSoC/videoSRAMRight_din0[15] ;
 wire \experiarSoC/videoSRAMRight_din0[16] ;
 wire \experiarSoC/videoSRAMRight_din0[17] ;
 wire \experiarSoC/videoSRAMRight_din0[18] ;
 wire \experiarSoC/videoSRAMRight_din0[19] ;
 wire \experiarSoC/videoSRAMRight_din0[1] ;
 wire \experiarSoC/videoSRAMRight_din0[20] ;
 wire \experiarSoC/videoSRAMRight_din0[21] ;
 wire \experiarSoC/videoSRAMRight_din0[22] ;
 wire \experiarSoC/videoSRAMRight_din0[23] ;
 wire \experiarSoC/videoSRAMRight_din0[24] ;
 wire \experiarSoC/videoSRAMRight_din0[25] ;
 wire \experiarSoC/videoSRAMRight_din0[26] ;
 wire \experiarSoC/videoSRAMRight_din0[27] ;
 wire \experiarSoC/videoSRAMRight_din0[28] ;
 wire \experiarSoC/videoSRAMRight_din0[29] ;
 wire \experiarSoC/videoSRAMRight_din0[2] ;
 wire \experiarSoC/videoSRAMRight_din0[30] ;
 wire \experiarSoC/videoSRAMRight_din0[31] ;
 wire \experiarSoC/videoSRAMRight_din0[3] ;
 wire \experiarSoC/videoSRAMRight_din0[4] ;
 wire \experiarSoC/videoSRAMRight_din0[5] ;
 wire \experiarSoC/videoSRAMRight_din0[6] ;
 wire \experiarSoC/videoSRAMRight_din0[7] ;
 wire \experiarSoC/videoSRAMRight_din0[8] ;
 wire \experiarSoC/videoSRAMRight_din0[9] ;
 wire \experiarSoC/videoSRAMRight_web0 ;
 wire \experiarSoC/videoSRAMRight_wmask0[0] ;
 wire \experiarSoC/videoSRAMRight_wmask0[1] ;
 wire \experiarSoC/videoSRAMRight_wmask0[2] ;
 wire \experiarSoC/videoSRAMRight_wmask0[3] ;
 wire \manufacturerID[0] ;
 wire \manufacturerID[10] ;
 wire \manufacturerID[1] ;
 wire \manufacturerID[2] ;
 wire \manufacturerID[3] ;
 wire \manufacturerID[4] ;
 wire \manufacturerID[5] ;
 wire \manufacturerID[6] ;
 wire \manufacturerID[7] ;
 wire \manufacturerID[8] ;
 wire \manufacturerID[9] ;
 wire \partID[0] ;
 wire \partID[10] ;
 wire \partID[11] ;
 wire \partID[12] ;
 wire \partID[13] ;
 wire \partID[14] ;
 wire \partID[15] ;
 wire \partID[1] ;
 wire \partID[2] ;
 wire \partID[3] ;
 wire \partID[4] ;
 wire \partID[5] ;
 wire \partID[6] ;
 wire \partID[7] ;
 wire \partID[8] ;
 wire \partID[9] ;
 wire \versionID[0] ;
 wire \versionID[1] ;
 wire \versionID[2] ;
 wire \versionID[3] ;

 Art art (.vccd1(vccd1),
    .vssd1(vssd1));
 CaravelHost caravelHost (.caravel_uart_rx(caravel_uart_tx),
    .caravel_uart_tx(caravel_uart_rx),
    .caravel_wb_ack_i(caravel_wb_ack_i),
    .caravel_wb_cyc_o(caravel_wb_cyc_o),
    .caravel_wb_error_i(caravel_wb_error_i),
    .caravel_wb_stall_i(caravel_wb_stall_i),
    .caravel_wb_stb_o(caravel_wb_stb_o),
    .caravel_wb_we_o(caravel_wb_we_o),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .caravel_wb_adr_o({\caravel_wb_adr_o[27] ,
    \caravel_wb_adr_o[26] ,
    \caravel_wb_adr_o[25] ,
    \caravel_wb_adr_o[24] ,
    \caravel_wb_adr_o[23] ,
    \caravel_wb_adr_o[22] ,
    \caravel_wb_adr_o[21] ,
    \caravel_wb_adr_o[20] ,
    \caravel_wb_adr_o[19] ,
    \caravel_wb_adr_o[18] ,
    \caravel_wb_adr_o[17] ,
    \caravel_wb_adr_o[16] ,
    \caravel_wb_adr_o[15] ,
    \caravel_wb_adr_o[14] ,
    \caravel_wb_adr_o[13] ,
    \caravel_wb_adr_o[12] ,
    \caravel_wb_adr_o[11] ,
    \caravel_wb_adr_o[10] ,
    \caravel_wb_adr_o[9] ,
    \caravel_wb_adr_o[8] ,
    \caravel_wb_adr_o[7] ,
    \caravel_wb_adr_o[6] ,
    \caravel_wb_adr_o[5] ,
    \caravel_wb_adr_o[4] ,
    \caravel_wb_adr_o[3] ,
    \caravel_wb_adr_o[2] ,
    \caravel_wb_adr_o[1] ,
    \caravel_wb_adr_o[0] }),
    .caravel_wb_data_i({\caravel_wb_data_i[31] ,
    \caravel_wb_data_i[30] ,
    \caravel_wb_data_i[29] ,
    \caravel_wb_data_i[28] ,
    \caravel_wb_data_i[27] ,
    \caravel_wb_data_i[26] ,
    \caravel_wb_data_i[25] ,
    \caravel_wb_data_i[24] ,
    \caravel_wb_data_i[23] ,
    \caravel_wb_data_i[22] ,
    \caravel_wb_data_i[21] ,
    \caravel_wb_data_i[20] ,
    \caravel_wb_data_i[19] ,
    \caravel_wb_data_i[18] ,
    \caravel_wb_data_i[17] ,
    \caravel_wb_data_i[16] ,
    \caravel_wb_data_i[15] ,
    \caravel_wb_data_i[14] ,
    \caravel_wb_data_i[13] ,
    \caravel_wb_data_i[12] ,
    \caravel_wb_data_i[11] ,
    \caravel_wb_data_i[10] ,
    \caravel_wb_data_i[9] ,
    \caravel_wb_data_i[8] ,
    \caravel_wb_data_i[7] ,
    \caravel_wb_data_i[6] ,
    \caravel_wb_data_i[5] ,
    \caravel_wb_data_i[4] ,
    \caravel_wb_data_i[3] ,
    \caravel_wb_data_i[2] ,
    \caravel_wb_data_i[1] ,
    \caravel_wb_data_i[0] }),
    .caravel_wb_data_o({\caravel_wb_data_o[31] ,
    \caravel_wb_data_o[30] ,
    \caravel_wb_data_o[29] ,
    \caravel_wb_data_o[28] ,
    \caravel_wb_data_o[27] ,
    \caravel_wb_data_o[26] ,
    \caravel_wb_data_o[25] ,
    \caravel_wb_data_o[24] ,
    \caravel_wb_data_o[23] ,
    \caravel_wb_data_o[22] ,
    \caravel_wb_data_o[21] ,
    \caravel_wb_data_o[20] ,
    \caravel_wb_data_o[19] ,
    \caravel_wb_data_o[18] ,
    \caravel_wb_data_o[17] ,
    \caravel_wb_data_o[16] ,
    \caravel_wb_data_o[15] ,
    \caravel_wb_data_o[14] ,
    \caravel_wb_data_o[13] ,
    \caravel_wb_data_o[12] ,
    \caravel_wb_data_o[11] ,
    \caravel_wb_data_o[10] ,
    \caravel_wb_data_o[9] ,
    \caravel_wb_data_o[8] ,
    \caravel_wb_data_o[7] ,
    \caravel_wb_data_o[6] ,
    \caravel_wb_data_o[5] ,
    \caravel_wb_data_o[4] ,
    \caravel_wb_data_o[3] ,
    \caravel_wb_data_o[2] ,
    \caravel_wb_data_o[1] ,
    \caravel_wb_data_o[0] }),
    .caravel_wb_sel_o({\caravel_wb_sel_o[3] ,
    \caravel_wb_sel_o[2] ,
    \caravel_wb_sel_o[1] ,
    \caravel_wb_sel_o[0] }),
    .core0Index({\core0Index[7] ,
    \core0Index[6] ,
    \core0Index[5] ,
    \core0Index[4] ,
    \core0Index[3] ,
    \core0Index[2] ,
    \core0Index[1] ,
    \core0Index[0] }),
    .core1Index({\core1Index[7] ,
    \core1Index[6] ,
    \core1Index[5] ,
    \core1Index[4] ,
    \core1Index[3] ,
    \core1Index[2] ,
    \core1Index[1] ,
    \core1Index[0] }),
    .manufacturerID({\manufacturerID[10] ,
    \manufacturerID[9] ,
    \manufacturerID[8] ,
    \manufacturerID[7] ,
    \manufacturerID[6] ,
    \manufacturerID[5] ,
    \manufacturerID[4] ,
    \manufacturerID[3] ,
    \manufacturerID[2] ,
    \manufacturerID[1] ,
    \manufacturerID[0] }),
    .partID({\partID[15] ,
    \partID[14] ,
    \partID[13] ,
    \partID[12] ,
    \partID[11] ,
    \partID[10] ,
    \partID[9] ,
    \partID[8] ,
    \partID[7] ,
    \partID[6] ,
    \partID[5] ,
    \partID[4] ,
    \partID[3] ,
    \partID[2] ,
    \partID[1] ,
    \partID[0] }),
    .versionID({\versionID[3] ,
    \versionID[2] ,
    \versionID[1] ,
    \versionID[0] }),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_data_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_data_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wbs_sel_i({wbs_sel_i[3],
    wbs_sel_i[2],
    wbs_sel_i[1],
    wbs_sel_i[0]}));
 ExperiarCore \experiarSoC/core0  (.clk0(\experiarSoC/core0SRAM_clk0 ),
    .clk1(\experiarSoC/core0SRAM_clk1 ),
    .core_wb_ack_i(\experiarSoC/core0_wb_ack_i ),
    .core_wb_cyc_o(\experiarSoC/core0_wb_cyc_o ),
    .core_wb_error_i(\experiarSoC/core0_wb_error_i ),
    .core_wb_stall_i(\experiarSoC/core0_wb_stall_i ),
    .core_wb_stb_o(\experiarSoC/core0_wb_stb_o ),
    .core_wb_we_o(\experiarSoC/core0_wb_we_o ),
    .jtag_tck(\experiarSoC/jtag_tck ),
    .jtag_tdi(\experiarSoC/core0_tdi ),
    .jtag_tdo(\experiarSoC/core0_tdo ),
    .jtag_tms(\experiarSoC/jtag_tms ),
    .localMemory_wb_ack_o(\experiarSoC/core0Memory_wb_ack_o ),
    .localMemory_wb_cyc_i(\experiarSoC/core0Memory_wb_cyc_i ),
    .localMemory_wb_error_o(\experiarSoC/core0Memory_wb_error_o ),
    .localMemory_wb_stall_o(\experiarSoC/core0Memory_wb_stall_o ),
    .localMemory_wb_stb_i(\experiarSoC/core0Memory_wb_stb_i ),
    .localMemory_wb_we_i(\experiarSoC/core0Memory_wb_we_i ),
    .probe_isBranch(la_data_out[27]),
    .probe_isCompressed(la_data_out[23]),
    .probe_isLoad(la_data_out[24]),
    .probe_isStore(la_data_out[25]),
    .probe_takeBranch(la_data_out[26]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .web0(\experiarSoC/core0SRAM_web0 ),
    .addr0({\experiarSoC/core0SRAM_addr0[8] ,
    \experiarSoC/core0SRAM_addr0[7] ,
    \experiarSoC/core0SRAM_addr0[6] ,
    \experiarSoC/core0SRAM_addr0[5] ,
    \experiarSoC/core0SRAM_addr0[4] ,
    \experiarSoC/core0SRAM_addr0[3] ,
    \experiarSoC/core0SRAM_addr0[2] ,
    \experiarSoC/core0SRAM_addr0[1] ,
    \experiarSoC/core0SRAM_addr0[0] }),
    .addr1({\experiarSoC/core0SRAM_addr1[8] ,
    \experiarSoC/core0SRAM_addr1[7] ,
    \experiarSoC/core0SRAM_addr1[6] ,
    \experiarSoC/core0SRAM_addr1[5] ,
    \experiarSoC/core0SRAM_addr1[4] ,
    \experiarSoC/core0SRAM_addr1[3] ,
    \experiarSoC/core0SRAM_addr1[2] ,
    \experiarSoC/core0SRAM_addr1[1] ,
    \experiarSoC/core0SRAM_addr1[0] }),
    .coreIndex({\core0Index[7] ,
    \core0Index[6] ,
    \core0Index[5] ,
    \core0Index[4] ,
    \core0Index[3] ,
    \core0Index[2] ,
    \core0Index[1] ,
    \core0Index[0] }),
    .core_wb_adr_o({\experiarSoC/core0_wb_adr_o[27] ,
    \experiarSoC/core0_wb_adr_o[26] ,
    \experiarSoC/core0_wb_adr_o[25] ,
    \experiarSoC/core0_wb_adr_o[24] ,
    \experiarSoC/core0_wb_adr_o[23] ,
    \experiarSoC/core0_wb_adr_o[22] ,
    \experiarSoC/core0_wb_adr_o[21] ,
    \experiarSoC/core0_wb_adr_o[20] ,
    \experiarSoC/core0_wb_adr_o[19] ,
    \experiarSoC/core0_wb_adr_o[18] ,
    \experiarSoC/core0_wb_adr_o[17] ,
    \experiarSoC/core0_wb_adr_o[16] ,
    \experiarSoC/core0_wb_adr_o[15] ,
    \experiarSoC/core0_wb_adr_o[14] ,
    \experiarSoC/core0_wb_adr_o[13] ,
    \experiarSoC/core0_wb_adr_o[12] ,
    \experiarSoC/core0_wb_adr_o[11] ,
    \experiarSoC/core0_wb_adr_o[10] ,
    \experiarSoC/core0_wb_adr_o[9] ,
    \experiarSoC/core0_wb_adr_o[8] ,
    \experiarSoC/core0_wb_adr_o[7] ,
    \experiarSoC/core0_wb_adr_o[6] ,
    \experiarSoC/core0_wb_adr_o[5] ,
    \experiarSoC/core0_wb_adr_o[4] ,
    \experiarSoC/core0_wb_adr_o[3] ,
    \experiarSoC/core0_wb_adr_o[2] ,
    \experiarSoC/core0_wb_adr_o[1] ,
    \experiarSoC/core0_wb_adr_o[0] }),
    .core_wb_data_i({\experiarSoC/core0_wb_data_i[31] ,
    \experiarSoC/core0_wb_data_i[30] ,
    \experiarSoC/core0_wb_data_i[29] ,
    \experiarSoC/core0_wb_data_i[28] ,
    \experiarSoC/core0_wb_data_i[27] ,
    \experiarSoC/core0_wb_data_i[26] ,
    \experiarSoC/core0_wb_data_i[25] ,
    \experiarSoC/core0_wb_data_i[24] ,
    \experiarSoC/core0_wb_data_i[23] ,
    \experiarSoC/core0_wb_data_i[22] ,
    \experiarSoC/core0_wb_data_i[21] ,
    \experiarSoC/core0_wb_data_i[20] ,
    \experiarSoC/core0_wb_data_i[19] ,
    \experiarSoC/core0_wb_data_i[18] ,
    \experiarSoC/core0_wb_data_i[17] ,
    \experiarSoC/core0_wb_data_i[16] ,
    \experiarSoC/core0_wb_data_i[15] ,
    \experiarSoC/core0_wb_data_i[14] ,
    \experiarSoC/core0_wb_data_i[13] ,
    \experiarSoC/core0_wb_data_i[12] ,
    \experiarSoC/core0_wb_data_i[11] ,
    \experiarSoC/core0_wb_data_i[10] ,
    \experiarSoC/core0_wb_data_i[9] ,
    \experiarSoC/core0_wb_data_i[8] ,
    \experiarSoC/core0_wb_data_i[7] ,
    \experiarSoC/core0_wb_data_i[6] ,
    \experiarSoC/core0_wb_data_i[5] ,
    \experiarSoC/core0_wb_data_i[4] ,
    \experiarSoC/core0_wb_data_i[3] ,
    \experiarSoC/core0_wb_data_i[2] ,
    \experiarSoC/core0_wb_data_i[1] ,
    \experiarSoC/core0_wb_data_i[0] }),
    .core_wb_data_o({\experiarSoC/core0_wb_data_o[31] ,
    \experiarSoC/core0_wb_data_o[30] ,
    \experiarSoC/core0_wb_data_o[29] ,
    \experiarSoC/core0_wb_data_o[28] ,
    \experiarSoC/core0_wb_data_o[27] ,
    \experiarSoC/core0_wb_data_o[26] ,
    \experiarSoC/core0_wb_data_o[25] ,
    \experiarSoC/core0_wb_data_o[24] ,
    \experiarSoC/core0_wb_data_o[23] ,
    \experiarSoC/core0_wb_data_o[22] ,
    \experiarSoC/core0_wb_data_o[21] ,
    \experiarSoC/core0_wb_data_o[20] ,
    \experiarSoC/core0_wb_data_o[19] ,
    \experiarSoC/core0_wb_data_o[18] ,
    \experiarSoC/core0_wb_data_o[17] ,
    \experiarSoC/core0_wb_data_o[16] ,
    \experiarSoC/core0_wb_data_o[15] ,
    \experiarSoC/core0_wb_data_o[14] ,
    \experiarSoC/core0_wb_data_o[13] ,
    \experiarSoC/core0_wb_data_o[12] ,
    \experiarSoC/core0_wb_data_o[11] ,
    \experiarSoC/core0_wb_data_o[10] ,
    \experiarSoC/core0_wb_data_o[9] ,
    \experiarSoC/core0_wb_data_o[8] ,
    \experiarSoC/core0_wb_data_o[7] ,
    \experiarSoC/core0_wb_data_o[6] ,
    \experiarSoC/core0_wb_data_o[5] ,
    \experiarSoC/core0_wb_data_o[4] ,
    \experiarSoC/core0_wb_data_o[3] ,
    \experiarSoC/core0_wb_data_o[2] ,
    \experiarSoC/core0_wb_data_o[1] ,
    \experiarSoC/core0_wb_data_o[0] }),
    .core_wb_sel_o({\experiarSoC/core0_wb_sel_o[3] ,
    \experiarSoC/core0_wb_sel_o[2] ,
    \experiarSoC/core0_wb_sel_o[1] ,
    \experiarSoC/core0_wb_sel_o[0] }),
    .csb0({\experiarSoC/core0SRAM_csb0[1] ,
    \experiarSoC/core0SRAM_csb0[0] }),
    .csb1({\experiarSoC/core0SRAM_csb1[1] ,
    \experiarSoC/core0SRAM_csb1[0] }),
    .din0({\experiarSoC/core0SRAM_din0[31] ,
    \experiarSoC/core0SRAM_din0[30] ,
    \experiarSoC/core0SRAM_din0[29] ,
    \experiarSoC/core0SRAM_din0[28] ,
    \experiarSoC/core0SRAM_din0[27] ,
    \experiarSoC/core0SRAM_din0[26] ,
    \experiarSoC/core0SRAM_din0[25] ,
    \experiarSoC/core0SRAM_din0[24] ,
    \experiarSoC/core0SRAM_din0[23] ,
    \experiarSoC/core0SRAM_din0[22] ,
    \experiarSoC/core0SRAM_din0[21] ,
    \experiarSoC/core0SRAM_din0[20] ,
    \experiarSoC/core0SRAM_din0[19] ,
    \experiarSoC/core0SRAM_din0[18] ,
    \experiarSoC/core0SRAM_din0[17] ,
    \experiarSoC/core0SRAM_din0[16] ,
    \experiarSoC/core0SRAM_din0[15] ,
    \experiarSoC/core0SRAM_din0[14] ,
    \experiarSoC/core0SRAM_din0[13] ,
    \experiarSoC/core0SRAM_din0[12] ,
    \experiarSoC/core0SRAM_din0[11] ,
    \experiarSoC/core0SRAM_din0[10] ,
    \experiarSoC/core0SRAM_din0[9] ,
    \experiarSoC/core0SRAM_din0[8] ,
    \experiarSoC/core0SRAM_din0[7] ,
    \experiarSoC/core0SRAM_din0[6] ,
    \experiarSoC/core0SRAM_din0[5] ,
    \experiarSoC/core0SRAM_din0[4] ,
    \experiarSoC/core0SRAM_din0[3] ,
    \experiarSoC/core0SRAM_din0[2] ,
    \experiarSoC/core0SRAM_din0[1] ,
    \experiarSoC/core0SRAM_din0[0] }),
    .dout0({\experiarSoC/core0SRAM1_dout0[31] ,
    \experiarSoC/core0SRAM1_dout0[30] ,
    \experiarSoC/core0SRAM1_dout0[29] ,
    \experiarSoC/core0SRAM1_dout0[28] ,
    \experiarSoC/core0SRAM1_dout0[27] ,
    \experiarSoC/core0SRAM1_dout0[26] ,
    \experiarSoC/core0SRAM1_dout0[25] ,
    \experiarSoC/core0SRAM1_dout0[24] ,
    \experiarSoC/core0SRAM1_dout0[23] ,
    \experiarSoC/core0SRAM1_dout0[22] ,
    \experiarSoC/core0SRAM1_dout0[21] ,
    \experiarSoC/core0SRAM1_dout0[20] ,
    \experiarSoC/core0SRAM1_dout0[19] ,
    \experiarSoC/core0SRAM1_dout0[18] ,
    \experiarSoC/core0SRAM1_dout0[17] ,
    \experiarSoC/core0SRAM1_dout0[16] ,
    \experiarSoC/core0SRAM1_dout0[15] ,
    \experiarSoC/core0SRAM1_dout0[14] ,
    \experiarSoC/core0SRAM1_dout0[13] ,
    \experiarSoC/core0SRAM1_dout0[12] ,
    \experiarSoC/core0SRAM1_dout0[11] ,
    \experiarSoC/core0SRAM1_dout0[10] ,
    \experiarSoC/core0SRAM1_dout0[9] ,
    \experiarSoC/core0SRAM1_dout0[8] ,
    \experiarSoC/core0SRAM1_dout0[7] ,
    \experiarSoC/core0SRAM1_dout0[6] ,
    \experiarSoC/core0SRAM1_dout0[5] ,
    \experiarSoC/core0SRAM1_dout0[4] ,
    \experiarSoC/core0SRAM1_dout0[3] ,
    \experiarSoC/core0SRAM1_dout0[2] ,
    \experiarSoC/core0SRAM1_dout0[1] ,
    \experiarSoC/core0SRAM1_dout0[0] ,
    \experiarSoC/core0SRAM0_dout0[31] ,
    \experiarSoC/core0SRAM0_dout0[30] ,
    \experiarSoC/core0SRAM0_dout0[29] ,
    \experiarSoC/core0SRAM0_dout0[28] ,
    \experiarSoC/core0SRAM0_dout0[27] ,
    \experiarSoC/core0SRAM0_dout0[26] ,
    \experiarSoC/core0SRAM0_dout0[25] ,
    \experiarSoC/core0SRAM0_dout0[24] ,
    \experiarSoC/core0SRAM0_dout0[23] ,
    \experiarSoC/core0SRAM0_dout0[22] ,
    \experiarSoC/core0SRAM0_dout0[21] ,
    \experiarSoC/core0SRAM0_dout0[20] ,
    \experiarSoC/core0SRAM0_dout0[19] ,
    \experiarSoC/core0SRAM0_dout0[18] ,
    \experiarSoC/core0SRAM0_dout0[17] ,
    \experiarSoC/core0SRAM0_dout0[16] ,
    \experiarSoC/core0SRAM0_dout0[15] ,
    \experiarSoC/core0SRAM0_dout0[14] ,
    \experiarSoC/core0SRAM0_dout0[13] ,
    \experiarSoC/core0SRAM0_dout0[12] ,
    \experiarSoC/core0SRAM0_dout0[11] ,
    \experiarSoC/core0SRAM0_dout0[10] ,
    \experiarSoC/core0SRAM0_dout0[9] ,
    \experiarSoC/core0SRAM0_dout0[8] ,
    \experiarSoC/core0SRAM0_dout0[7] ,
    \experiarSoC/core0SRAM0_dout0[6] ,
    \experiarSoC/core0SRAM0_dout0[5] ,
    \experiarSoC/core0SRAM0_dout0[4] ,
    \experiarSoC/core0SRAM0_dout0[3] ,
    \experiarSoC/core0SRAM0_dout0[2] ,
    \experiarSoC/core0SRAM0_dout0[1] ,
    \experiarSoC/core0SRAM0_dout0[0] }),
    .dout1({\experiarSoC/core0SRAM1_dout1[31] ,
    \experiarSoC/core0SRAM1_dout1[30] ,
    \experiarSoC/core0SRAM1_dout1[29] ,
    \experiarSoC/core0SRAM1_dout1[28] ,
    \experiarSoC/core0SRAM1_dout1[27] ,
    \experiarSoC/core0SRAM1_dout1[26] ,
    \experiarSoC/core0SRAM1_dout1[25] ,
    \experiarSoC/core0SRAM1_dout1[24] ,
    \experiarSoC/core0SRAM1_dout1[23] ,
    \experiarSoC/core0SRAM1_dout1[22] ,
    \experiarSoC/core0SRAM1_dout1[21] ,
    \experiarSoC/core0SRAM1_dout1[20] ,
    \experiarSoC/core0SRAM1_dout1[19] ,
    \experiarSoC/core0SRAM1_dout1[18] ,
    \experiarSoC/core0SRAM1_dout1[17] ,
    \experiarSoC/core0SRAM1_dout1[16] ,
    \experiarSoC/core0SRAM1_dout1[15] ,
    \experiarSoC/core0SRAM1_dout1[14] ,
    \experiarSoC/core0SRAM1_dout1[13] ,
    \experiarSoC/core0SRAM1_dout1[12] ,
    \experiarSoC/core0SRAM1_dout1[11] ,
    \experiarSoC/core0SRAM1_dout1[10] ,
    \experiarSoC/core0SRAM1_dout1[9] ,
    \experiarSoC/core0SRAM1_dout1[8] ,
    \experiarSoC/core0SRAM1_dout1[7] ,
    \experiarSoC/core0SRAM1_dout1[6] ,
    \experiarSoC/core0SRAM1_dout1[5] ,
    \experiarSoC/core0SRAM1_dout1[4] ,
    \experiarSoC/core0SRAM1_dout1[3] ,
    \experiarSoC/core0SRAM1_dout1[2] ,
    \experiarSoC/core0SRAM1_dout1[1] ,
    \experiarSoC/core0SRAM1_dout1[0] ,
    \experiarSoC/core0SRAM0_dout1[31] ,
    \experiarSoC/core0SRAM0_dout1[30] ,
    \experiarSoC/core0SRAM0_dout1[29] ,
    \experiarSoC/core0SRAM0_dout1[28] ,
    \experiarSoC/core0SRAM0_dout1[27] ,
    \experiarSoC/core0SRAM0_dout1[26] ,
    \experiarSoC/core0SRAM0_dout1[25] ,
    \experiarSoC/core0SRAM0_dout1[24] ,
    \experiarSoC/core0SRAM0_dout1[23] ,
    \experiarSoC/core0SRAM0_dout1[22] ,
    \experiarSoC/core0SRAM0_dout1[21] ,
    \experiarSoC/core0SRAM0_dout1[20] ,
    \experiarSoC/core0SRAM0_dout1[19] ,
    \experiarSoC/core0SRAM0_dout1[18] ,
    \experiarSoC/core0SRAM0_dout1[17] ,
    \experiarSoC/core0SRAM0_dout1[16] ,
    \experiarSoC/core0SRAM0_dout1[15] ,
    \experiarSoC/core0SRAM0_dout1[14] ,
    \experiarSoC/core0SRAM0_dout1[13] ,
    \experiarSoC/core0SRAM0_dout1[12] ,
    \experiarSoC/core0SRAM0_dout1[11] ,
    \experiarSoC/core0SRAM0_dout1[10] ,
    \experiarSoC/core0SRAM0_dout1[9] ,
    \experiarSoC/core0SRAM0_dout1[8] ,
    \experiarSoC/core0SRAM0_dout1[7] ,
    \experiarSoC/core0SRAM0_dout1[6] ,
    \experiarSoC/core0SRAM0_dout1[5] ,
    \experiarSoC/core0SRAM0_dout1[4] ,
    \experiarSoC/core0SRAM0_dout1[3] ,
    \experiarSoC/core0SRAM0_dout1[2] ,
    \experiarSoC/core0SRAM0_dout1[1] ,
    \experiarSoC/core0SRAM0_dout1[0] }),
    .localMemory_wb_adr_i({\experiarSoC/core0Memory_wb_adr_i[23] ,
    \experiarSoC/core0Memory_wb_adr_i[22] ,
    \experiarSoC/core0Memory_wb_adr_i[21] ,
    \experiarSoC/core0Memory_wb_adr_i[20] ,
    \experiarSoC/core0Memory_wb_adr_i[19] ,
    \experiarSoC/core0Memory_wb_adr_i[18] ,
    \experiarSoC/core0Memory_wb_adr_i[17] ,
    \experiarSoC/core0Memory_wb_adr_i[16] ,
    \experiarSoC/core0Memory_wb_adr_i[15] ,
    \experiarSoC/core0Memory_wb_adr_i[14] ,
    \experiarSoC/core0Memory_wb_adr_i[13] ,
    \experiarSoC/core0Memory_wb_adr_i[12] ,
    \experiarSoC/core0Memory_wb_adr_i[11] ,
    \experiarSoC/core0Memory_wb_adr_i[10] ,
    \experiarSoC/core0Memory_wb_adr_i[9] ,
    \experiarSoC/core0Memory_wb_adr_i[8] ,
    \experiarSoC/core0Memory_wb_adr_i[7] ,
    \experiarSoC/core0Memory_wb_adr_i[6] ,
    \experiarSoC/core0Memory_wb_adr_i[5] ,
    \experiarSoC/core0Memory_wb_adr_i[4] ,
    \experiarSoC/core0Memory_wb_adr_i[3] ,
    \experiarSoC/core0Memory_wb_adr_i[2] ,
    \experiarSoC/core0Memory_wb_adr_i[1] ,
    \experiarSoC/core0Memory_wb_adr_i[0] }),
    .localMemory_wb_data_i({\experiarSoC/core0Memory_wb_data_i[31] ,
    \experiarSoC/core0Memory_wb_data_i[30] ,
    \experiarSoC/core0Memory_wb_data_i[29] ,
    \experiarSoC/core0Memory_wb_data_i[28] ,
    \experiarSoC/core0Memory_wb_data_i[27] ,
    \experiarSoC/core0Memory_wb_data_i[26] ,
    \experiarSoC/core0Memory_wb_data_i[25] ,
    \experiarSoC/core0Memory_wb_data_i[24] ,
    \experiarSoC/core0Memory_wb_data_i[23] ,
    \experiarSoC/core0Memory_wb_data_i[22] ,
    \experiarSoC/core0Memory_wb_data_i[21] ,
    \experiarSoC/core0Memory_wb_data_i[20] ,
    \experiarSoC/core0Memory_wb_data_i[19] ,
    \experiarSoC/core0Memory_wb_data_i[18] ,
    \experiarSoC/core0Memory_wb_data_i[17] ,
    \experiarSoC/core0Memory_wb_data_i[16] ,
    \experiarSoC/core0Memory_wb_data_i[15] ,
    \experiarSoC/core0Memory_wb_data_i[14] ,
    \experiarSoC/core0Memory_wb_data_i[13] ,
    \experiarSoC/core0Memory_wb_data_i[12] ,
    \experiarSoC/core0Memory_wb_data_i[11] ,
    \experiarSoC/core0Memory_wb_data_i[10] ,
    \experiarSoC/core0Memory_wb_data_i[9] ,
    \experiarSoC/core0Memory_wb_data_i[8] ,
    \experiarSoC/core0Memory_wb_data_i[7] ,
    \experiarSoC/core0Memory_wb_data_i[6] ,
    \experiarSoC/core0Memory_wb_data_i[5] ,
    \experiarSoC/core0Memory_wb_data_i[4] ,
    \experiarSoC/core0Memory_wb_data_i[3] ,
    \experiarSoC/core0Memory_wb_data_i[2] ,
    \experiarSoC/core0Memory_wb_data_i[1] ,
    \experiarSoC/core0Memory_wb_data_i[0] }),
    .localMemory_wb_data_o({\experiarSoC/core0Memory_wb_data_o[31] ,
    \experiarSoC/core0Memory_wb_data_o[30] ,
    \experiarSoC/core0Memory_wb_data_o[29] ,
    \experiarSoC/core0Memory_wb_data_o[28] ,
    \experiarSoC/core0Memory_wb_data_o[27] ,
    \experiarSoC/core0Memory_wb_data_o[26] ,
    \experiarSoC/core0Memory_wb_data_o[25] ,
    \experiarSoC/core0Memory_wb_data_o[24] ,
    \experiarSoC/core0Memory_wb_data_o[23] ,
    \experiarSoC/core0Memory_wb_data_o[22] ,
    \experiarSoC/core0Memory_wb_data_o[21] ,
    \experiarSoC/core0Memory_wb_data_o[20] ,
    \experiarSoC/core0Memory_wb_data_o[19] ,
    \experiarSoC/core0Memory_wb_data_o[18] ,
    \experiarSoC/core0Memory_wb_data_o[17] ,
    \experiarSoC/core0Memory_wb_data_o[16] ,
    \experiarSoC/core0Memory_wb_data_o[15] ,
    \experiarSoC/core0Memory_wb_data_o[14] ,
    \experiarSoC/core0Memory_wb_data_o[13] ,
    \experiarSoC/core0Memory_wb_data_o[12] ,
    \experiarSoC/core0Memory_wb_data_o[11] ,
    \experiarSoC/core0Memory_wb_data_o[10] ,
    \experiarSoC/core0Memory_wb_data_o[9] ,
    \experiarSoC/core0Memory_wb_data_o[8] ,
    \experiarSoC/core0Memory_wb_data_o[7] ,
    \experiarSoC/core0Memory_wb_data_o[6] ,
    \experiarSoC/core0Memory_wb_data_o[5] ,
    \experiarSoC/core0Memory_wb_data_o[4] ,
    \experiarSoC/core0Memory_wb_data_o[3] ,
    \experiarSoC/core0Memory_wb_data_o[2] ,
    \experiarSoC/core0Memory_wb_data_o[1] ,
    \experiarSoC/core0Memory_wb_data_o[0] }),
    .localMemory_wb_sel_i({\experiarSoC/core0Memory_wb_sel_i[3] ,
    \experiarSoC/core0Memory_wb_sel_i[2] ,
    \experiarSoC/core0Memory_wb_sel_i[1] ,
    \experiarSoC/core0Memory_wb_sel_i[0] }),
    .manufacturerID({\manufacturerID[10] ,
    \manufacturerID[9] ,
    \manufacturerID[8] ,
    \manufacturerID[7] ,
    \manufacturerID[6] ,
    \manufacturerID[5] ,
    \manufacturerID[4] ,
    \manufacturerID[3] ,
    \manufacturerID[2] ,
    \manufacturerID[1] ,
    \manufacturerID[0] }),
    .partID({\partID[15] ,
    \partID[14] ,
    \partID[13] ,
    \partID[12] ,
    \partID[11] ,
    \partID[10] ,
    \partID[9] ,
    \partID[8] ,
    \partID[7] ,
    \partID[6] ,
    \partID[5] ,
    \partID[4] ,
    \partID[3] ,
    \partID[2] ,
    \partID[1] ,
    \partID[0] }),
    .probe_errorCode({la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28]}),
    .probe_jtagInstruction({la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18]}),
    .probe_opcode({la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32]}),
    .probe_programCounter({la_data_out[70],
    la_data_out[69],
    la_data_out[68],
    la_data_out[67],
    la_data_out[66],
    la_data_out[65],
    la_data_out[64],
    la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48],
    la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39]}),
    .probe_state({la_data_out[72],
    la_data_out[71]}),
    .versionID({\versionID[3] ,
    \versionID[2] ,
    \versionID[1] ,
    \versionID[0] }),
    .wmask0({\experiarSoC/core0SRAM_wmask0[3] ,
    \experiarSoC/core0SRAM_wmask0[2] ,
    \experiarSoC/core0SRAM_wmask0[1] ,
    \experiarSoC/core0SRAM_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/core0SRAM0  (.csb0(\experiarSoC/core0SRAM_csb0[0] ),
    .csb1(\experiarSoC/core0SRAM_csb1[0] ),
    .web0(\experiarSoC/core0SRAM_web0 ),
    .clk0(\experiarSoC/core0SRAM_clk0 ),
    .clk1(\experiarSoC/core0SRAM_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/core0SRAM_addr0[8] ,
    \experiarSoC/core0SRAM_addr0[7] ,
    \experiarSoC/core0SRAM_addr0[6] ,
    \experiarSoC/core0SRAM_addr0[5] ,
    \experiarSoC/core0SRAM_addr0[4] ,
    \experiarSoC/core0SRAM_addr0[3] ,
    \experiarSoC/core0SRAM_addr0[2] ,
    \experiarSoC/core0SRAM_addr0[1] ,
    \experiarSoC/core0SRAM_addr0[0] }),
    .addr1({\experiarSoC/core0SRAM_addr1[8] ,
    \experiarSoC/core0SRAM_addr1[7] ,
    \experiarSoC/core0SRAM_addr1[6] ,
    \experiarSoC/core0SRAM_addr1[5] ,
    \experiarSoC/core0SRAM_addr1[4] ,
    \experiarSoC/core0SRAM_addr1[3] ,
    \experiarSoC/core0SRAM_addr1[2] ,
    \experiarSoC/core0SRAM_addr1[1] ,
    \experiarSoC/core0SRAM_addr1[0] }),
    .din0({\experiarSoC/core0SRAM_din0[31] ,
    \experiarSoC/core0SRAM_din0[30] ,
    \experiarSoC/core0SRAM_din0[29] ,
    \experiarSoC/core0SRAM_din0[28] ,
    \experiarSoC/core0SRAM_din0[27] ,
    \experiarSoC/core0SRAM_din0[26] ,
    \experiarSoC/core0SRAM_din0[25] ,
    \experiarSoC/core0SRAM_din0[24] ,
    \experiarSoC/core0SRAM_din0[23] ,
    \experiarSoC/core0SRAM_din0[22] ,
    \experiarSoC/core0SRAM_din0[21] ,
    \experiarSoC/core0SRAM_din0[20] ,
    \experiarSoC/core0SRAM_din0[19] ,
    \experiarSoC/core0SRAM_din0[18] ,
    \experiarSoC/core0SRAM_din0[17] ,
    \experiarSoC/core0SRAM_din0[16] ,
    \experiarSoC/core0SRAM_din0[15] ,
    \experiarSoC/core0SRAM_din0[14] ,
    \experiarSoC/core0SRAM_din0[13] ,
    \experiarSoC/core0SRAM_din0[12] ,
    \experiarSoC/core0SRAM_din0[11] ,
    \experiarSoC/core0SRAM_din0[10] ,
    \experiarSoC/core0SRAM_din0[9] ,
    \experiarSoC/core0SRAM_din0[8] ,
    \experiarSoC/core0SRAM_din0[7] ,
    \experiarSoC/core0SRAM_din0[6] ,
    \experiarSoC/core0SRAM_din0[5] ,
    \experiarSoC/core0SRAM_din0[4] ,
    \experiarSoC/core0SRAM_din0[3] ,
    \experiarSoC/core0SRAM_din0[2] ,
    \experiarSoC/core0SRAM_din0[1] ,
    \experiarSoC/core0SRAM_din0[0] }),
    .dout0({\experiarSoC/core0SRAM0_dout0[31] ,
    \experiarSoC/core0SRAM0_dout0[30] ,
    \experiarSoC/core0SRAM0_dout0[29] ,
    \experiarSoC/core0SRAM0_dout0[28] ,
    \experiarSoC/core0SRAM0_dout0[27] ,
    \experiarSoC/core0SRAM0_dout0[26] ,
    \experiarSoC/core0SRAM0_dout0[25] ,
    \experiarSoC/core0SRAM0_dout0[24] ,
    \experiarSoC/core0SRAM0_dout0[23] ,
    \experiarSoC/core0SRAM0_dout0[22] ,
    \experiarSoC/core0SRAM0_dout0[21] ,
    \experiarSoC/core0SRAM0_dout0[20] ,
    \experiarSoC/core0SRAM0_dout0[19] ,
    \experiarSoC/core0SRAM0_dout0[18] ,
    \experiarSoC/core0SRAM0_dout0[17] ,
    \experiarSoC/core0SRAM0_dout0[16] ,
    \experiarSoC/core0SRAM0_dout0[15] ,
    \experiarSoC/core0SRAM0_dout0[14] ,
    \experiarSoC/core0SRAM0_dout0[13] ,
    \experiarSoC/core0SRAM0_dout0[12] ,
    \experiarSoC/core0SRAM0_dout0[11] ,
    \experiarSoC/core0SRAM0_dout0[10] ,
    \experiarSoC/core0SRAM0_dout0[9] ,
    \experiarSoC/core0SRAM0_dout0[8] ,
    \experiarSoC/core0SRAM0_dout0[7] ,
    \experiarSoC/core0SRAM0_dout0[6] ,
    \experiarSoC/core0SRAM0_dout0[5] ,
    \experiarSoC/core0SRAM0_dout0[4] ,
    \experiarSoC/core0SRAM0_dout0[3] ,
    \experiarSoC/core0SRAM0_dout0[2] ,
    \experiarSoC/core0SRAM0_dout0[1] ,
    \experiarSoC/core0SRAM0_dout0[0] }),
    .dout1({\experiarSoC/core0SRAM0_dout1[31] ,
    \experiarSoC/core0SRAM0_dout1[30] ,
    \experiarSoC/core0SRAM0_dout1[29] ,
    \experiarSoC/core0SRAM0_dout1[28] ,
    \experiarSoC/core0SRAM0_dout1[27] ,
    \experiarSoC/core0SRAM0_dout1[26] ,
    \experiarSoC/core0SRAM0_dout1[25] ,
    \experiarSoC/core0SRAM0_dout1[24] ,
    \experiarSoC/core0SRAM0_dout1[23] ,
    \experiarSoC/core0SRAM0_dout1[22] ,
    \experiarSoC/core0SRAM0_dout1[21] ,
    \experiarSoC/core0SRAM0_dout1[20] ,
    \experiarSoC/core0SRAM0_dout1[19] ,
    \experiarSoC/core0SRAM0_dout1[18] ,
    \experiarSoC/core0SRAM0_dout1[17] ,
    \experiarSoC/core0SRAM0_dout1[16] ,
    \experiarSoC/core0SRAM0_dout1[15] ,
    \experiarSoC/core0SRAM0_dout1[14] ,
    \experiarSoC/core0SRAM0_dout1[13] ,
    \experiarSoC/core0SRAM0_dout1[12] ,
    \experiarSoC/core0SRAM0_dout1[11] ,
    \experiarSoC/core0SRAM0_dout1[10] ,
    \experiarSoC/core0SRAM0_dout1[9] ,
    \experiarSoC/core0SRAM0_dout1[8] ,
    \experiarSoC/core0SRAM0_dout1[7] ,
    \experiarSoC/core0SRAM0_dout1[6] ,
    \experiarSoC/core0SRAM0_dout1[5] ,
    \experiarSoC/core0SRAM0_dout1[4] ,
    \experiarSoC/core0SRAM0_dout1[3] ,
    \experiarSoC/core0SRAM0_dout1[2] ,
    \experiarSoC/core0SRAM0_dout1[1] ,
    \experiarSoC/core0SRAM0_dout1[0] }),
    .wmask0({\experiarSoC/core0SRAM_wmask0[3] ,
    \experiarSoC/core0SRAM_wmask0[2] ,
    \experiarSoC/core0SRAM_wmask0[1] ,
    \experiarSoC/core0SRAM_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/core0SRAM1  (.csb0(\experiarSoC/core0SRAM_csb0[1] ),
    .csb1(\experiarSoC/core0SRAM_csb1[1] ),
    .web0(\experiarSoC/core0SRAM_web0 ),
    .clk0(\experiarSoC/core0SRAM_clk0 ),
    .clk1(\experiarSoC/core0SRAM_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/core0SRAM_addr0[8] ,
    \experiarSoC/core0SRAM_addr0[7] ,
    \experiarSoC/core0SRAM_addr0[6] ,
    \experiarSoC/core0SRAM_addr0[5] ,
    \experiarSoC/core0SRAM_addr0[4] ,
    \experiarSoC/core0SRAM_addr0[3] ,
    \experiarSoC/core0SRAM_addr0[2] ,
    \experiarSoC/core0SRAM_addr0[1] ,
    \experiarSoC/core0SRAM_addr0[0] }),
    .addr1({\experiarSoC/core0SRAM_addr1[8] ,
    \experiarSoC/core0SRAM_addr1[7] ,
    \experiarSoC/core0SRAM_addr1[6] ,
    \experiarSoC/core0SRAM_addr1[5] ,
    \experiarSoC/core0SRAM_addr1[4] ,
    \experiarSoC/core0SRAM_addr1[3] ,
    \experiarSoC/core0SRAM_addr1[2] ,
    \experiarSoC/core0SRAM_addr1[1] ,
    \experiarSoC/core0SRAM_addr1[0] }),
    .din0({\experiarSoC/core0SRAM_din0[31] ,
    \experiarSoC/core0SRAM_din0[30] ,
    \experiarSoC/core0SRAM_din0[29] ,
    \experiarSoC/core0SRAM_din0[28] ,
    \experiarSoC/core0SRAM_din0[27] ,
    \experiarSoC/core0SRAM_din0[26] ,
    \experiarSoC/core0SRAM_din0[25] ,
    \experiarSoC/core0SRAM_din0[24] ,
    \experiarSoC/core0SRAM_din0[23] ,
    \experiarSoC/core0SRAM_din0[22] ,
    \experiarSoC/core0SRAM_din0[21] ,
    \experiarSoC/core0SRAM_din0[20] ,
    \experiarSoC/core0SRAM_din0[19] ,
    \experiarSoC/core0SRAM_din0[18] ,
    \experiarSoC/core0SRAM_din0[17] ,
    \experiarSoC/core0SRAM_din0[16] ,
    \experiarSoC/core0SRAM_din0[15] ,
    \experiarSoC/core0SRAM_din0[14] ,
    \experiarSoC/core0SRAM_din0[13] ,
    \experiarSoC/core0SRAM_din0[12] ,
    \experiarSoC/core0SRAM_din0[11] ,
    \experiarSoC/core0SRAM_din0[10] ,
    \experiarSoC/core0SRAM_din0[9] ,
    \experiarSoC/core0SRAM_din0[8] ,
    \experiarSoC/core0SRAM_din0[7] ,
    \experiarSoC/core0SRAM_din0[6] ,
    \experiarSoC/core0SRAM_din0[5] ,
    \experiarSoC/core0SRAM_din0[4] ,
    \experiarSoC/core0SRAM_din0[3] ,
    \experiarSoC/core0SRAM_din0[2] ,
    \experiarSoC/core0SRAM_din0[1] ,
    \experiarSoC/core0SRAM_din0[0] }),
    .dout0({\experiarSoC/core0SRAM1_dout0[31] ,
    \experiarSoC/core0SRAM1_dout0[30] ,
    \experiarSoC/core0SRAM1_dout0[29] ,
    \experiarSoC/core0SRAM1_dout0[28] ,
    \experiarSoC/core0SRAM1_dout0[27] ,
    \experiarSoC/core0SRAM1_dout0[26] ,
    \experiarSoC/core0SRAM1_dout0[25] ,
    \experiarSoC/core0SRAM1_dout0[24] ,
    \experiarSoC/core0SRAM1_dout0[23] ,
    \experiarSoC/core0SRAM1_dout0[22] ,
    \experiarSoC/core0SRAM1_dout0[21] ,
    \experiarSoC/core0SRAM1_dout0[20] ,
    \experiarSoC/core0SRAM1_dout0[19] ,
    \experiarSoC/core0SRAM1_dout0[18] ,
    \experiarSoC/core0SRAM1_dout0[17] ,
    \experiarSoC/core0SRAM1_dout0[16] ,
    \experiarSoC/core0SRAM1_dout0[15] ,
    \experiarSoC/core0SRAM1_dout0[14] ,
    \experiarSoC/core0SRAM1_dout0[13] ,
    \experiarSoC/core0SRAM1_dout0[12] ,
    \experiarSoC/core0SRAM1_dout0[11] ,
    \experiarSoC/core0SRAM1_dout0[10] ,
    \experiarSoC/core0SRAM1_dout0[9] ,
    \experiarSoC/core0SRAM1_dout0[8] ,
    \experiarSoC/core0SRAM1_dout0[7] ,
    \experiarSoC/core0SRAM1_dout0[6] ,
    \experiarSoC/core0SRAM1_dout0[5] ,
    \experiarSoC/core0SRAM1_dout0[4] ,
    \experiarSoC/core0SRAM1_dout0[3] ,
    \experiarSoC/core0SRAM1_dout0[2] ,
    \experiarSoC/core0SRAM1_dout0[1] ,
    \experiarSoC/core0SRAM1_dout0[0] }),
    .dout1({\experiarSoC/core0SRAM1_dout1[31] ,
    \experiarSoC/core0SRAM1_dout1[30] ,
    \experiarSoC/core0SRAM1_dout1[29] ,
    \experiarSoC/core0SRAM1_dout1[28] ,
    \experiarSoC/core0SRAM1_dout1[27] ,
    \experiarSoC/core0SRAM1_dout1[26] ,
    \experiarSoC/core0SRAM1_dout1[25] ,
    \experiarSoC/core0SRAM1_dout1[24] ,
    \experiarSoC/core0SRAM1_dout1[23] ,
    \experiarSoC/core0SRAM1_dout1[22] ,
    \experiarSoC/core0SRAM1_dout1[21] ,
    \experiarSoC/core0SRAM1_dout1[20] ,
    \experiarSoC/core0SRAM1_dout1[19] ,
    \experiarSoC/core0SRAM1_dout1[18] ,
    \experiarSoC/core0SRAM1_dout1[17] ,
    \experiarSoC/core0SRAM1_dout1[16] ,
    \experiarSoC/core0SRAM1_dout1[15] ,
    \experiarSoC/core0SRAM1_dout1[14] ,
    \experiarSoC/core0SRAM1_dout1[13] ,
    \experiarSoC/core0SRAM1_dout1[12] ,
    \experiarSoC/core0SRAM1_dout1[11] ,
    \experiarSoC/core0SRAM1_dout1[10] ,
    \experiarSoC/core0SRAM1_dout1[9] ,
    \experiarSoC/core0SRAM1_dout1[8] ,
    \experiarSoC/core0SRAM1_dout1[7] ,
    \experiarSoC/core0SRAM1_dout1[6] ,
    \experiarSoC/core0SRAM1_dout1[5] ,
    \experiarSoC/core0SRAM1_dout1[4] ,
    \experiarSoC/core0SRAM1_dout1[3] ,
    \experiarSoC/core0SRAM1_dout1[2] ,
    \experiarSoC/core0SRAM1_dout1[1] ,
    \experiarSoC/core0SRAM1_dout1[0] }),
    .wmask0({\experiarSoC/core0SRAM_wmask0[3] ,
    \experiarSoC/core0SRAM_wmask0[2] ,
    \experiarSoC/core0SRAM_wmask0[1] ,
    \experiarSoC/core0SRAM_wmask0[0] }));
 ExperiarCore \experiarSoC/core1  (.clk0(\experiarSoC/core1SRAM_clk0 ),
    .clk1(\experiarSoC/core1SRAM_clk1 ),
    .core_wb_ack_i(\experiarSoC/core1_wb_ack_i ),
    .core_wb_cyc_o(\experiarSoC/core1_wb_cyc_o ),
    .core_wb_error_i(\experiarSoC/core1_wb_error_i ),
    .core_wb_stall_i(\experiarSoC/core1_wb_stall_i ),
    .core_wb_stb_o(\experiarSoC/core1_wb_stb_o ),
    .core_wb_we_o(\experiarSoC/core1_wb_we_o ),
    .jtag_tck(\experiarSoC/jtag_tck ),
    .jtag_tdi(\experiarSoC/core0_tdo ),
    .jtag_tdo(\experiarSoC/core1_tdo ),
    .jtag_tms(\experiarSoC/jtag_tms ),
    .localMemory_wb_ack_o(\experiarSoC/core1Memory_wb_ack_o ),
    .localMemory_wb_cyc_i(\experiarSoC/core1Memory_wb_cyc_i ),
    .localMemory_wb_error_o(\experiarSoC/core1Memory_wb_error_o ),
    .localMemory_wb_stall_o(\experiarSoC/core1Memory_wb_stall_o ),
    .localMemory_wb_stb_i(\experiarSoC/core1Memory_wb_stb_i ),
    .localMemory_wb_we_i(\experiarSoC/core1Memory_wb_we_i ),
    .probe_isBranch(la_data_out[82]),
    .probe_isCompressed(la_data_out[78]),
    .probe_isLoad(la_data_out[79]),
    .probe_isStore(la_data_out[80]),
    .probe_takeBranch(la_data_out[81]),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .web0(\experiarSoC/core1SRAM_web0 ),
    .addr0({\experiarSoC/core1SRAM_addr0[8] ,
    \experiarSoC/core1SRAM_addr0[7] ,
    \experiarSoC/core1SRAM_addr0[6] ,
    \experiarSoC/core1SRAM_addr0[5] ,
    \experiarSoC/core1SRAM_addr0[4] ,
    \experiarSoC/core1SRAM_addr0[3] ,
    \experiarSoC/core1SRAM_addr0[2] ,
    \experiarSoC/core1SRAM_addr0[1] ,
    \experiarSoC/core1SRAM_addr0[0] }),
    .addr1({\experiarSoC/core1SRAM_addr1[8] ,
    \experiarSoC/core1SRAM_addr1[7] ,
    \experiarSoC/core1SRAM_addr1[6] ,
    \experiarSoC/core1SRAM_addr1[5] ,
    \experiarSoC/core1SRAM_addr1[4] ,
    \experiarSoC/core1SRAM_addr1[3] ,
    \experiarSoC/core1SRAM_addr1[2] ,
    \experiarSoC/core1SRAM_addr1[1] ,
    \experiarSoC/core1SRAM_addr1[0] }),
    .coreIndex({\core1Index[7] ,
    \core1Index[6] ,
    \core1Index[5] ,
    \core1Index[4] ,
    \core1Index[3] ,
    \core1Index[2] ,
    \core1Index[1] ,
    \core1Index[0] }),
    .core_wb_adr_o({\experiarSoC/core1_wb_adr_o[27] ,
    \experiarSoC/core1_wb_adr_o[26] ,
    \experiarSoC/core1_wb_adr_o[25] ,
    \experiarSoC/core1_wb_adr_o[24] ,
    \experiarSoC/core1_wb_adr_o[23] ,
    \experiarSoC/core1_wb_adr_o[22] ,
    \experiarSoC/core1_wb_adr_o[21] ,
    \experiarSoC/core1_wb_adr_o[20] ,
    \experiarSoC/core1_wb_adr_o[19] ,
    \experiarSoC/core1_wb_adr_o[18] ,
    \experiarSoC/core1_wb_adr_o[17] ,
    \experiarSoC/core1_wb_adr_o[16] ,
    \experiarSoC/core1_wb_adr_o[15] ,
    \experiarSoC/core1_wb_adr_o[14] ,
    \experiarSoC/core1_wb_adr_o[13] ,
    \experiarSoC/core1_wb_adr_o[12] ,
    \experiarSoC/core1_wb_adr_o[11] ,
    \experiarSoC/core1_wb_adr_o[10] ,
    \experiarSoC/core1_wb_adr_o[9] ,
    \experiarSoC/core1_wb_adr_o[8] ,
    \experiarSoC/core1_wb_adr_o[7] ,
    \experiarSoC/core1_wb_adr_o[6] ,
    \experiarSoC/core1_wb_adr_o[5] ,
    \experiarSoC/core1_wb_adr_o[4] ,
    \experiarSoC/core1_wb_adr_o[3] ,
    \experiarSoC/core1_wb_adr_o[2] ,
    \experiarSoC/core1_wb_adr_o[1] ,
    \experiarSoC/core1_wb_adr_o[0] }),
    .core_wb_data_i({\experiarSoC/core1_wb_data_i[31] ,
    \experiarSoC/core1_wb_data_i[30] ,
    \experiarSoC/core1_wb_data_i[29] ,
    \experiarSoC/core1_wb_data_i[28] ,
    \experiarSoC/core1_wb_data_i[27] ,
    \experiarSoC/core1_wb_data_i[26] ,
    \experiarSoC/core1_wb_data_i[25] ,
    \experiarSoC/core1_wb_data_i[24] ,
    \experiarSoC/core1_wb_data_i[23] ,
    \experiarSoC/core1_wb_data_i[22] ,
    \experiarSoC/core1_wb_data_i[21] ,
    \experiarSoC/core1_wb_data_i[20] ,
    \experiarSoC/core1_wb_data_i[19] ,
    \experiarSoC/core1_wb_data_i[18] ,
    \experiarSoC/core1_wb_data_i[17] ,
    \experiarSoC/core1_wb_data_i[16] ,
    \experiarSoC/core1_wb_data_i[15] ,
    \experiarSoC/core1_wb_data_i[14] ,
    \experiarSoC/core1_wb_data_i[13] ,
    \experiarSoC/core1_wb_data_i[12] ,
    \experiarSoC/core1_wb_data_i[11] ,
    \experiarSoC/core1_wb_data_i[10] ,
    \experiarSoC/core1_wb_data_i[9] ,
    \experiarSoC/core1_wb_data_i[8] ,
    \experiarSoC/core1_wb_data_i[7] ,
    \experiarSoC/core1_wb_data_i[6] ,
    \experiarSoC/core1_wb_data_i[5] ,
    \experiarSoC/core1_wb_data_i[4] ,
    \experiarSoC/core1_wb_data_i[3] ,
    \experiarSoC/core1_wb_data_i[2] ,
    \experiarSoC/core1_wb_data_i[1] ,
    \experiarSoC/core1_wb_data_i[0] }),
    .core_wb_data_o({\experiarSoC/core1_wb_data_o[31] ,
    \experiarSoC/core1_wb_data_o[30] ,
    \experiarSoC/core1_wb_data_o[29] ,
    \experiarSoC/core1_wb_data_o[28] ,
    \experiarSoC/core1_wb_data_o[27] ,
    \experiarSoC/core1_wb_data_o[26] ,
    \experiarSoC/core1_wb_data_o[25] ,
    \experiarSoC/core1_wb_data_o[24] ,
    \experiarSoC/core1_wb_data_o[23] ,
    \experiarSoC/core1_wb_data_o[22] ,
    \experiarSoC/core1_wb_data_o[21] ,
    \experiarSoC/core1_wb_data_o[20] ,
    \experiarSoC/core1_wb_data_o[19] ,
    \experiarSoC/core1_wb_data_o[18] ,
    \experiarSoC/core1_wb_data_o[17] ,
    \experiarSoC/core1_wb_data_o[16] ,
    \experiarSoC/core1_wb_data_o[15] ,
    \experiarSoC/core1_wb_data_o[14] ,
    \experiarSoC/core1_wb_data_o[13] ,
    \experiarSoC/core1_wb_data_o[12] ,
    \experiarSoC/core1_wb_data_o[11] ,
    \experiarSoC/core1_wb_data_o[10] ,
    \experiarSoC/core1_wb_data_o[9] ,
    \experiarSoC/core1_wb_data_o[8] ,
    \experiarSoC/core1_wb_data_o[7] ,
    \experiarSoC/core1_wb_data_o[6] ,
    \experiarSoC/core1_wb_data_o[5] ,
    \experiarSoC/core1_wb_data_o[4] ,
    \experiarSoC/core1_wb_data_o[3] ,
    \experiarSoC/core1_wb_data_o[2] ,
    \experiarSoC/core1_wb_data_o[1] ,
    \experiarSoC/core1_wb_data_o[0] }),
    .core_wb_sel_o({\experiarSoC/core1_wb_sel_o[3] ,
    \experiarSoC/core1_wb_sel_o[2] ,
    \experiarSoC/core1_wb_sel_o[1] ,
    \experiarSoC/core1_wb_sel_o[0] }),
    .csb0({\experiarSoC/core1SRAM_csb0[1] ,
    \experiarSoC/core1SRAM_csb0[0] }),
    .csb1({\experiarSoC/core1SRAM_csb1[1] ,
    \experiarSoC/core1SRAM_csb1[0] }),
    .din0({\experiarSoC/core1SRAM_din0[31] ,
    \experiarSoC/core1SRAM_din0[30] ,
    \experiarSoC/core1SRAM_din0[29] ,
    \experiarSoC/core1SRAM_din0[28] ,
    \experiarSoC/core1SRAM_din0[27] ,
    \experiarSoC/core1SRAM_din0[26] ,
    \experiarSoC/core1SRAM_din0[25] ,
    \experiarSoC/core1SRAM_din0[24] ,
    \experiarSoC/core1SRAM_din0[23] ,
    \experiarSoC/core1SRAM_din0[22] ,
    \experiarSoC/core1SRAM_din0[21] ,
    \experiarSoC/core1SRAM_din0[20] ,
    \experiarSoC/core1SRAM_din0[19] ,
    \experiarSoC/core1SRAM_din0[18] ,
    \experiarSoC/core1SRAM_din0[17] ,
    \experiarSoC/core1SRAM_din0[16] ,
    \experiarSoC/core1SRAM_din0[15] ,
    \experiarSoC/core1SRAM_din0[14] ,
    \experiarSoC/core1SRAM_din0[13] ,
    \experiarSoC/core1SRAM_din0[12] ,
    \experiarSoC/core1SRAM_din0[11] ,
    \experiarSoC/core1SRAM_din0[10] ,
    \experiarSoC/core1SRAM_din0[9] ,
    \experiarSoC/core1SRAM_din0[8] ,
    \experiarSoC/core1SRAM_din0[7] ,
    \experiarSoC/core1SRAM_din0[6] ,
    \experiarSoC/core1SRAM_din0[5] ,
    \experiarSoC/core1SRAM_din0[4] ,
    \experiarSoC/core1SRAM_din0[3] ,
    \experiarSoC/core1SRAM_din0[2] ,
    \experiarSoC/core1SRAM_din0[1] ,
    \experiarSoC/core1SRAM_din0[0] }),
    .dout0({\experiarSoC/core1SRAM1_dout0[31] ,
    \experiarSoC/core1SRAM1_dout0[30] ,
    \experiarSoC/core1SRAM1_dout0[29] ,
    \experiarSoC/core1SRAM1_dout0[28] ,
    \experiarSoC/core1SRAM1_dout0[27] ,
    \experiarSoC/core1SRAM1_dout0[26] ,
    \experiarSoC/core1SRAM1_dout0[25] ,
    \experiarSoC/core1SRAM1_dout0[24] ,
    \experiarSoC/core1SRAM1_dout0[23] ,
    \experiarSoC/core1SRAM1_dout0[22] ,
    \experiarSoC/core1SRAM1_dout0[21] ,
    \experiarSoC/core1SRAM1_dout0[20] ,
    \experiarSoC/core1SRAM1_dout0[19] ,
    \experiarSoC/core1SRAM1_dout0[18] ,
    \experiarSoC/core1SRAM1_dout0[17] ,
    \experiarSoC/core1SRAM1_dout0[16] ,
    \experiarSoC/core1SRAM1_dout0[15] ,
    \experiarSoC/core1SRAM1_dout0[14] ,
    \experiarSoC/core1SRAM1_dout0[13] ,
    \experiarSoC/core1SRAM1_dout0[12] ,
    \experiarSoC/core1SRAM1_dout0[11] ,
    \experiarSoC/core1SRAM1_dout0[10] ,
    \experiarSoC/core1SRAM1_dout0[9] ,
    \experiarSoC/core1SRAM1_dout0[8] ,
    \experiarSoC/core1SRAM1_dout0[7] ,
    \experiarSoC/core1SRAM1_dout0[6] ,
    \experiarSoC/core1SRAM1_dout0[5] ,
    \experiarSoC/core1SRAM1_dout0[4] ,
    \experiarSoC/core1SRAM1_dout0[3] ,
    \experiarSoC/core1SRAM1_dout0[2] ,
    \experiarSoC/core1SRAM1_dout0[1] ,
    \experiarSoC/core1SRAM1_dout0[0] ,
    \experiarSoC/core1SRAM0_dout0[31] ,
    \experiarSoC/core1SRAM0_dout0[30] ,
    \experiarSoC/core1SRAM0_dout0[29] ,
    \experiarSoC/core1SRAM0_dout0[28] ,
    \experiarSoC/core1SRAM0_dout0[27] ,
    \experiarSoC/core1SRAM0_dout0[26] ,
    \experiarSoC/core1SRAM0_dout0[25] ,
    \experiarSoC/core1SRAM0_dout0[24] ,
    \experiarSoC/core1SRAM0_dout0[23] ,
    \experiarSoC/core1SRAM0_dout0[22] ,
    \experiarSoC/core1SRAM0_dout0[21] ,
    \experiarSoC/core1SRAM0_dout0[20] ,
    \experiarSoC/core1SRAM0_dout0[19] ,
    \experiarSoC/core1SRAM0_dout0[18] ,
    \experiarSoC/core1SRAM0_dout0[17] ,
    \experiarSoC/core1SRAM0_dout0[16] ,
    \experiarSoC/core1SRAM0_dout0[15] ,
    \experiarSoC/core1SRAM0_dout0[14] ,
    \experiarSoC/core1SRAM0_dout0[13] ,
    \experiarSoC/core1SRAM0_dout0[12] ,
    \experiarSoC/core1SRAM0_dout0[11] ,
    \experiarSoC/core1SRAM0_dout0[10] ,
    \experiarSoC/core1SRAM0_dout0[9] ,
    \experiarSoC/core1SRAM0_dout0[8] ,
    \experiarSoC/core1SRAM0_dout0[7] ,
    \experiarSoC/core1SRAM0_dout0[6] ,
    \experiarSoC/core1SRAM0_dout0[5] ,
    \experiarSoC/core1SRAM0_dout0[4] ,
    \experiarSoC/core1SRAM0_dout0[3] ,
    \experiarSoC/core1SRAM0_dout0[2] ,
    \experiarSoC/core1SRAM0_dout0[1] ,
    \experiarSoC/core1SRAM0_dout0[0] }),
    .dout1({\experiarSoC/core1SRAM1_dout1[31] ,
    \experiarSoC/core1SRAM1_dout1[30] ,
    \experiarSoC/core1SRAM1_dout1[29] ,
    \experiarSoC/core1SRAM1_dout1[28] ,
    \experiarSoC/core1SRAM1_dout1[27] ,
    \experiarSoC/core1SRAM1_dout1[26] ,
    \experiarSoC/core1SRAM1_dout1[25] ,
    \experiarSoC/core1SRAM1_dout1[24] ,
    \experiarSoC/core1SRAM1_dout1[23] ,
    \experiarSoC/core1SRAM1_dout1[22] ,
    \experiarSoC/core1SRAM1_dout1[21] ,
    \experiarSoC/core1SRAM1_dout1[20] ,
    \experiarSoC/core1SRAM1_dout1[19] ,
    \experiarSoC/core1SRAM1_dout1[18] ,
    \experiarSoC/core1SRAM1_dout1[17] ,
    \experiarSoC/core1SRAM1_dout1[16] ,
    \experiarSoC/core1SRAM1_dout1[15] ,
    \experiarSoC/core1SRAM1_dout1[14] ,
    \experiarSoC/core1SRAM1_dout1[13] ,
    \experiarSoC/core1SRAM1_dout1[12] ,
    \experiarSoC/core1SRAM1_dout1[11] ,
    \experiarSoC/core1SRAM1_dout1[10] ,
    \experiarSoC/core1SRAM1_dout1[9] ,
    \experiarSoC/core1SRAM1_dout1[8] ,
    \experiarSoC/core1SRAM1_dout1[7] ,
    \experiarSoC/core1SRAM1_dout1[6] ,
    \experiarSoC/core1SRAM1_dout1[5] ,
    \experiarSoC/core1SRAM1_dout1[4] ,
    \experiarSoC/core1SRAM1_dout1[3] ,
    \experiarSoC/core1SRAM1_dout1[2] ,
    \experiarSoC/core1SRAM1_dout1[1] ,
    \experiarSoC/core1SRAM1_dout1[0] ,
    \experiarSoC/core1SRAM0_dout1[31] ,
    \experiarSoC/core1SRAM0_dout1[30] ,
    \experiarSoC/core1SRAM0_dout1[29] ,
    \experiarSoC/core1SRAM0_dout1[28] ,
    \experiarSoC/core1SRAM0_dout1[27] ,
    \experiarSoC/core1SRAM0_dout1[26] ,
    \experiarSoC/core1SRAM0_dout1[25] ,
    \experiarSoC/core1SRAM0_dout1[24] ,
    \experiarSoC/core1SRAM0_dout1[23] ,
    \experiarSoC/core1SRAM0_dout1[22] ,
    \experiarSoC/core1SRAM0_dout1[21] ,
    \experiarSoC/core1SRAM0_dout1[20] ,
    \experiarSoC/core1SRAM0_dout1[19] ,
    \experiarSoC/core1SRAM0_dout1[18] ,
    \experiarSoC/core1SRAM0_dout1[17] ,
    \experiarSoC/core1SRAM0_dout1[16] ,
    \experiarSoC/core1SRAM0_dout1[15] ,
    \experiarSoC/core1SRAM0_dout1[14] ,
    \experiarSoC/core1SRAM0_dout1[13] ,
    \experiarSoC/core1SRAM0_dout1[12] ,
    \experiarSoC/core1SRAM0_dout1[11] ,
    \experiarSoC/core1SRAM0_dout1[10] ,
    \experiarSoC/core1SRAM0_dout1[9] ,
    \experiarSoC/core1SRAM0_dout1[8] ,
    \experiarSoC/core1SRAM0_dout1[7] ,
    \experiarSoC/core1SRAM0_dout1[6] ,
    \experiarSoC/core1SRAM0_dout1[5] ,
    \experiarSoC/core1SRAM0_dout1[4] ,
    \experiarSoC/core1SRAM0_dout1[3] ,
    \experiarSoC/core1SRAM0_dout1[2] ,
    \experiarSoC/core1SRAM0_dout1[1] ,
    \experiarSoC/core1SRAM0_dout1[0] }),
    .localMemory_wb_adr_i({\experiarSoC/core1Memory_wb_adr_i[23] ,
    \experiarSoC/core1Memory_wb_adr_i[22] ,
    \experiarSoC/core1Memory_wb_adr_i[21] ,
    \experiarSoC/core1Memory_wb_adr_i[20] ,
    \experiarSoC/core1Memory_wb_adr_i[19] ,
    \experiarSoC/core1Memory_wb_adr_i[18] ,
    \experiarSoC/core1Memory_wb_adr_i[17] ,
    \experiarSoC/core1Memory_wb_adr_i[16] ,
    \experiarSoC/core1Memory_wb_adr_i[15] ,
    \experiarSoC/core1Memory_wb_adr_i[14] ,
    \experiarSoC/core1Memory_wb_adr_i[13] ,
    \experiarSoC/core1Memory_wb_adr_i[12] ,
    \experiarSoC/core1Memory_wb_adr_i[11] ,
    \experiarSoC/core1Memory_wb_adr_i[10] ,
    \experiarSoC/core1Memory_wb_adr_i[9] ,
    \experiarSoC/core1Memory_wb_adr_i[8] ,
    \experiarSoC/core1Memory_wb_adr_i[7] ,
    \experiarSoC/core1Memory_wb_adr_i[6] ,
    \experiarSoC/core1Memory_wb_adr_i[5] ,
    \experiarSoC/core1Memory_wb_adr_i[4] ,
    \experiarSoC/core1Memory_wb_adr_i[3] ,
    \experiarSoC/core1Memory_wb_adr_i[2] ,
    \experiarSoC/core1Memory_wb_adr_i[1] ,
    \experiarSoC/core1Memory_wb_adr_i[0] }),
    .localMemory_wb_data_i({\experiarSoC/core1Memory_wb_data_i[31] ,
    \experiarSoC/core1Memory_wb_data_i[30] ,
    \experiarSoC/core1Memory_wb_data_i[29] ,
    \experiarSoC/core1Memory_wb_data_i[28] ,
    \experiarSoC/core1Memory_wb_data_i[27] ,
    \experiarSoC/core1Memory_wb_data_i[26] ,
    \experiarSoC/core1Memory_wb_data_i[25] ,
    \experiarSoC/core1Memory_wb_data_i[24] ,
    \experiarSoC/core1Memory_wb_data_i[23] ,
    \experiarSoC/core1Memory_wb_data_i[22] ,
    \experiarSoC/core1Memory_wb_data_i[21] ,
    \experiarSoC/core1Memory_wb_data_i[20] ,
    \experiarSoC/core1Memory_wb_data_i[19] ,
    \experiarSoC/core1Memory_wb_data_i[18] ,
    \experiarSoC/core1Memory_wb_data_i[17] ,
    \experiarSoC/core1Memory_wb_data_i[16] ,
    \experiarSoC/core1Memory_wb_data_i[15] ,
    \experiarSoC/core1Memory_wb_data_i[14] ,
    \experiarSoC/core1Memory_wb_data_i[13] ,
    \experiarSoC/core1Memory_wb_data_i[12] ,
    \experiarSoC/core1Memory_wb_data_i[11] ,
    \experiarSoC/core1Memory_wb_data_i[10] ,
    \experiarSoC/core1Memory_wb_data_i[9] ,
    \experiarSoC/core1Memory_wb_data_i[8] ,
    \experiarSoC/core1Memory_wb_data_i[7] ,
    \experiarSoC/core1Memory_wb_data_i[6] ,
    \experiarSoC/core1Memory_wb_data_i[5] ,
    \experiarSoC/core1Memory_wb_data_i[4] ,
    \experiarSoC/core1Memory_wb_data_i[3] ,
    \experiarSoC/core1Memory_wb_data_i[2] ,
    \experiarSoC/core1Memory_wb_data_i[1] ,
    \experiarSoC/core1Memory_wb_data_i[0] }),
    .localMemory_wb_data_o({\experiarSoC/core1Memory_wb_data_o[31] ,
    \experiarSoC/core1Memory_wb_data_o[30] ,
    \experiarSoC/core1Memory_wb_data_o[29] ,
    \experiarSoC/core1Memory_wb_data_o[28] ,
    \experiarSoC/core1Memory_wb_data_o[27] ,
    \experiarSoC/core1Memory_wb_data_o[26] ,
    \experiarSoC/core1Memory_wb_data_o[25] ,
    \experiarSoC/core1Memory_wb_data_o[24] ,
    \experiarSoC/core1Memory_wb_data_o[23] ,
    \experiarSoC/core1Memory_wb_data_o[22] ,
    \experiarSoC/core1Memory_wb_data_o[21] ,
    \experiarSoC/core1Memory_wb_data_o[20] ,
    \experiarSoC/core1Memory_wb_data_o[19] ,
    \experiarSoC/core1Memory_wb_data_o[18] ,
    \experiarSoC/core1Memory_wb_data_o[17] ,
    \experiarSoC/core1Memory_wb_data_o[16] ,
    \experiarSoC/core1Memory_wb_data_o[15] ,
    \experiarSoC/core1Memory_wb_data_o[14] ,
    \experiarSoC/core1Memory_wb_data_o[13] ,
    \experiarSoC/core1Memory_wb_data_o[12] ,
    \experiarSoC/core1Memory_wb_data_o[11] ,
    \experiarSoC/core1Memory_wb_data_o[10] ,
    \experiarSoC/core1Memory_wb_data_o[9] ,
    \experiarSoC/core1Memory_wb_data_o[8] ,
    \experiarSoC/core1Memory_wb_data_o[7] ,
    \experiarSoC/core1Memory_wb_data_o[6] ,
    \experiarSoC/core1Memory_wb_data_o[5] ,
    \experiarSoC/core1Memory_wb_data_o[4] ,
    \experiarSoC/core1Memory_wb_data_o[3] ,
    \experiarSoC/core1Memory_wb_data_o[2] ,
    \experiarSoC/core1Memory_wb_data_o[1] ,
    \experiarSoC/core1Memory_wb_data_o[0] }),
    .localMemory_wb_sel_i({\experiarSoC/core1Memory_wb_sel_i[3] ,
    \experiarSoC/core1Memory_wb_sel_i[2] ,
    \experiarSoC/core1Memory_wb_sel_i[1] ,
    \experiarSoC/core1Memory_wb_sel_i[0] }),
    .manufacturerID({\manufacturerID[10] ,
    \manufacturerID[9] ,
    \manufacturerID[8] ,
    \manufacturerID[7] ,
    \manufacturerID[6] ,
    \manufacturerID[5] ,
    \manufacturerID[4] ,
    \manufacturerID[3] ,
    \manufacturerID[2] ,
    \manufacturerID[1] ,
    \manufacturerID[0] }),
    .partID({\partID[15] ,
    \partID[14] ,
    \partID[13] ,
    \partID[12] ,
    \partID[11] ,
    \partID[10] ,
    \partID[9] ,
    \partID[8] ,
    \partID[7] ,
    \partID[6] ,
    \partID[5] ,
    \partID[4] ,
    \partID[3] ,
    \partID[2] ,
    \partID[1] ,
    \partID[0] }),
    .probe_errorCode({la_data_out[86],
    la_data_out[85],
    la_data_out[84],
    la_data_out[83]}),
    .probe_jtagInstruction({la_data_out[77],
    la_data_out[76],
    la_data_out[75],
    la_data_out[74],
    la_data_out[73]}),
    .probe_opcode({la_data_out[93],
    la_data_out[92],
    la_data_out[91],
    la_data_out[90],
    la_data_out[89],
    la_data_out[88],
    la_data_out[87]}),
    .probe_programCounter({la_data_out[125],
    la_data_out[124],
    la_data_out[123],
    la_data_out[122],
    la_data_out[121],
    la_data_out[120],
    la_data_out[119],
    la_data_out[118],
    la_data_out[117],
    la_data_out[116],
    la_data_out[115],
    la_data_out[114],
    la_data_out[113],
    la_data_out[112],
    la_data_out[111],
    la_data_out[110],
    la_data_out[109],
    la_data_out[108],
    la_data_out[107],
    la_data_out[106],
    la_data_out[105],
    la_data_out[104],
    la_data_out[103],
    la_data_out[102],
    la_data_out[101],
    la_data_out[100],
    la_data_out[99],
    la_data_out[98],
    la_data_out[97],
    la_data_out[96],
    la_data_out[95],
    la_data_out[94]}),
    .probe_state({la_data_out[127],
    la_data_out[126]}),
    .versionID({\versionID[3] ,
    \versionID[2] ,
    \versionID[1] ,
    \versionID[0] }),
    .wmask0({\experiarSoC/core1SRAM_wmask0[3] ,
    \experiarSoC/core1SRAM_wmask0[2] ,
    \experiarSoC/core1SRAM_wmask0[1] ,
    \experiarSoC/core1SRAM_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/core1SRAM0  (.csb0(\experiarSoC/core1SRAM_csb0[0] ),
    .csb1(\experiarSoC/core1SRAM_csb1[0] ),
    .web0(\experiarSoC/core1SRAM_web0 ),
    .clk0(\experiarSoC/core1SRAM_clk0 ),
    .clk1(\experiarSoC/core1SRAM_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/core1SRAM_addr0[8] ,
    \experiarSoC/core1SRAM_addr0[7] ,
    \experiarSoC/core1SRAM_addr0[6] ,
    \experiarSoC/core1SRAM_addr0[5] ,
    \experiarSoC/core1SRAM_addr0[4] ,
    \experiarSoC/core1SRAM_addr0[3] ,
    \experiarSoC/core1SRAM_addr0[2] ,
    \experiarSoC/core1SRAM_addr0[1] ,
    \experiarSoC/core1SRAM_addr0[0] }),
    .addr1({\experiarSoC/core1SRAM_addr1[8] ,
    \experiarSoC/core1SRAM_addr1[7] ,
    \experiarSoC/core1SRAM_addr1[6] ,
    \experiarSoC/core1SRAM_addr1[5] ,
    \experiarSoC/core1SRAM_addr1[4] ,
    \experiarSoC/core1SRAM_addr1[3] ,
    \experiarSoC/core1SRAM_addr1[2] ,
    \experiarSoC/core1SRAM_addr1[1] ,
    \experiarSoC/core1SRAM_addr1[0] }),
    .din0({\experiarSoC/core1SRAM_din0[31] ,
    \experiarSoC/core1SRAM_din0[30] ,
    \experiarSoC/core1SRAM_din0[29] ,
    \experiarSoC/core1SRAM_din0[28] ,
    \experiarSoC/core1SRAM_din0[27] ,
    \experiarSoC/core1SRAM_din0[26] ,
    \experiarSoC/core1SRAM_din0[25] ,
    \experiarSoC/core1SRAM_din0[24] ,
    \experiarSoC/core1SRAM_din0[23] ,
    \experiarSoC/core1SRAM_din0[22] ,
    \experiarSoC/core1SRAM_din0[21] ,
    \experiarSoC/core1SRAM_din0[20] ,
    \experiarSoC/core1SRAM_din0[19] ,
    \experiarSoC/core1SRAM_din0[18] ,
    \experiarSoC/core1SRAM_din0[17] ,
    \experiarSoC/core1SRAM_din0[16] ,
    \experiarSoC/core1SRAM_din0[15] ,
    \experiarSoC/core1SRAM_din0[14] ,
    \experiarSoC/core1SRAM_din0[13] ,
    \experiarSoC/core1SRAM_din0[12] ,
    \experiarSoC/core1SRAM_din0[11] ,
    \experiarSoC/core1SRAM_din0[10] ,
    \experiarSoC/core1SRAM_din0[9] ,
    \experiarSoC/core1SRAM_din0[8] ,
    \experiarSoC/core1SRAM_din0[7] ,
    \experiarSoC/core1SRAM_din0[6] ,
    \experiarSoC/core1SRAM_din0[5] ,
    \experiarSoC/core1SRAM_din0[4] ,
    \experiarSoC/core1SRAM_din0[3] ,
    \experiarSoC/core1SRAM_din0[2] ,
    \experiarSoC/core1SRAM_din0[1] ,
    \experiarSoC/core1SRAM_din0[0] }),
    .dout0({\experiarSoC/core1SRAM0_dout0[31] ,
    \experiarSoC/core1SRAM0_dout0[30] ,
    \experiarSoC/core1SRAM0_dout0[29] ,
    \experiarSoC/core1SRAM0_dout0[28] ,
    \experiarSoC/core1SRAM0_dout0[27] ,
    \experiarSoC/core1SRAM0_dout0[26] ,
    \experiarSoC/core1SRAM0_dout0[25] ,
    \experiarSoC/core1SRAM0_dout0[24] ,
    \experiarSoC/core1SRAM0_dout0[23] ,
    \experiarSoC/core1SRAM0_dout0[22] ,
    \experiarSoC/core1SRAM0_dout0[21] ,
    \experiarSoC/core1SRAM0_dout0[20] ,
    \experiarSoC/core1SRAM0_dout0[19] ,
    \experiarSoC/core1SRAM0_dout0[18] ,
    \experiarSoC/core1SRAM0_dout0[17] ,
    \experiarSoC/core1SRAM0_dout0[16] ,
    \experiarSoC/core1SRAM0_dout0[15] ,
    \experiarSoC/core1SRAM0_dout0[14] ,
    \experiarSoC/core1SRAM0_dout0[13] ,
    \experiarSoC/core1SRAM0_dout0[12] ,
    \experiarSoC/core1SRAM0_dout0[11] ,
    \experiarSoC/core1SRAM0_dout0[10] ,
    \experiarSoC/core1SRAM0_dout0[9] ,
    \experiarSoC/core1SRAM0_dout0[8] ,
    \experiarSoC/core1SRAM0_dout0[7] ,
    \experiarSoC/core1SRAM0_dout0[6] ,
    \experiarSoC/core1SRAM0_dout0[5] ,
    \experiarSoC/core1SRAM0_dout0[4] ,
    \experiarSoC/core1SRAM0_dout0[3] ,
    \experiarSoC/core1SRAM0_dout0[2] ,
    \experiarSoC/core1SRAM0_dout0[1] ,
    \experiarSoC/core1SRAM0_dout0[0] }),
    .dout1({\experiarSoC/core1SRAM0_dout1[31] ,
    \experiarSoC/core1SRAM0_dout1[30] ,
    \experiarSoC/core1SRAM0_dout1[29] ,
    \experiarSoC/core1SRAM0_dout1[28] ,
    \experiarSoC/core1SRAM0_dout1[27] ,
    \experiarSoC/core1SRAM0_dout1[26] ,
    \experiarSoC/core1SRAM0_dout1[25] ,
    \experiarSoC/core1SRAM0_dout1[24] ,
    \experiarSoC/core1SRAM0_dout1[23] ,
    \experiarSoC/core1SRAM0_dout1[22] ,
    \experiarSoC/core1SRAM0_dout1[21] ,
    \experiarSoC/core1SRAM0_dout1[20] ,
    \experiarSoC/core1SRAM0_dout1[19] ,
    \experiarSoC/core1SRAM0_dout1[18] ,
    \experiarSoC/core1SRAM0_dout1[17] ,
    \experiarSoC/core1SRAM0_dout1[16] ,
    \experiarSoC/core1SRAM0_dout1[15] ,
    \experiarSoC/core1SRAM0_dout1[14] ,
    \experiarSoC/core1SRAM0_dout1[13] ,
    \experiarSoC/core1SRAM0_dout1[12] ,
    \experiarSoC/core1SRAM0_dout1[11] ,
    \experiarSoC/core1SRAM0_dout1[10] ,
    \experiarSoC/core1SRAM0_dout1[9] ,
    \experiarSoC/core1SRAM0_dout1[8] ,
    \experiarSoC/core1SRAM0_dout1[7] ,
    \experiarSoC/core1SRAM0_dout1[6] ,
    \experiarSoC/core1SRAM0_dout1[5] ,
    \experiarSoC/core1SRAM0_dout1[4] ,
    \experiarSoC/core1SRAM0_dout1[3] ,
    \experiarSoC/core1SRAM0_dout1[2] ,
    \experiarSoC/core1SRAM0_dout1[1] ,
    \experiarSoC/core1SRAM0_dout1[0] }),
    .wmask0({\experiarSoC/core1SRAM_wmask0[3] ,
    \experiarSoC/core1SRAM_wmask0[2] ,
    \experiarSoC/core1SRAM_wmask0[1] ,
    \experiarSoC/core1SRAM_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/core1SRAM1  (.csb0(\experiarSoC/core1SRAM_csb0[1] ),
    .csb1(\experiarSoC/core1SRAM_csb1[1] ),
    .web0(\experiarSoC/core1SRAM_web0 ),
    .clk0(\experiarSoC/core1SRAM_clk0 ),
    .clk1(\experiarSoC/core1SRAM_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/core1SRAM_addr0[8] ,
    \experiarSoC/core1SRAM_addr0[7] ,
    \experiarSoC/core1SRAM_addr0[6] ,
    \experiarSoC/core1SRAM_addr0[5] ,
    \experiarSoC/core1SRAM_addr0[4] ,
    \experiarSoC/core1SRAM_addr0[3] ,
    \experiarSoC/core1SRAM_addr0[2] ,
    \experiarSoC/core1SRAM_addr0[1] ,
    \experiarSoC/core1SRAM_addr0[0] }),
    .addr1({\experiarSoC/core1SRAM_addr1[8] ,
    \experiarSoC/core1SRAM_addr1[7] ,
    \experiarSoC/core1SRAM_addr1[6] ,
    \experiarSoC/core1SRAM_addr1[5] ,
    \experiarSoC/core1SRAM_addr1[4] ,
    \experiarSoC/core1SRAM_addr1[3] ,
    \experiarSoC/core1SRAM_addr1[2] ,
    \experiarSoC/core1SRAM_addr1[1] ,
    \experiarSoC/core1SRAM_addr1[0] }),
    .din0({\experiarSoC/core1SRAM_din0[31] ,
    \experiarSoC/core1SRAM_din0[30] ,
    \experiarSoC/core1SRAM_din0[29] ,
    \experiarSoC/core1SRAM_din0[28] ,
    \experiarSoC/core1SRAM_din0[27] ,
    \experiarSoC/core1SRAM_din0[26] ,
    \experiarSoC/core1SRAM_din0[25] ,
    \experiarSoC/core1SRAM_din0[24] ,
    \experiarSoC/core1SRAM_din0[23] ,
    \experiarSoC/core1SRAM_din0[22] ,
    \experiarSoC/core1SRAM_din0[21] ,
    \experiarSoC/core1SRAM_din0[20] ,
    \experiarSoC/core1SRAM_din0[19] ,
    \experiarSoC/core1SRAM_din0[18] ,
    \experiarSoC/core1SRAM_din0[17] ,
    \experiarSoC/core1SRAM_din0[16] ,
    \experiarSoC/core1SRAM_din0[15] ,
    \experiarSoC/core1SRAM_din0[14] ,
    \experiarSoC/core1SRAM_din0[13] ,
    \experiarSoC/core1SRAM_din0[12] ,
    \experiarSoC/core1SRAM_din0[11] ,
    \experiarSoC/core1SRAM_din0[10] ,
    \experiarSoC/core1SRAM_din0[9] ,
    \experiarSoC/core1SRAM_din0[8] ,
    \experiarSoC/core1SRAM_din0[7] ,
    \experiarSoC/core1SRAM_din0[6] ,
    \experiarSoC/core1SRAM_din0[5] ,
    \experiarSoC/core1SRAM_din0[4] ,
    \experiarSoC/core1SRAM_din0[3] ,
    \experiarSoC/core1SRAM_din0[2] ,
    \experiarSoC/core1SRAM_din0[1] ,
    \experiarSoC/core1SRAM_din0[0] }),
    .dout0({\experiarSoC/core1SRAM1_dout0[31] ,
    \experiarSoC/core1SRAM1_dout0[30] ,
    \experiarSoC/core1SRAM1_dout0[29] ,
    \experiarSoC/core1SRAM1_dout0[28] ,
    \experiarSoC/core1SRAM1_dout0[27] ,
    \experiarSoC/core1SRAM1_dout0[26] ,
    \experiarSoC/core1SRAM1_dout0[25] ,
    \experiarSoC/core1SRAM1_dout0[24] ,
    \experiarSoC/core1SRAM1_dout0[23] ,
    \experiarSoC/core1SRAM1_dout0[22] ,
    \experiarSoC/core1SRAM1_dout0[21] ,
    \experiarSoC/core1SRAM1_dout0[20] ,
    \experiarSoC/core1SRAM1_dout0[19] ,
    \experiarSoC/core1SRAM1_dout0[18] ,
    \experiarSoC/core1SRAM1_dout0[17] ,
    \experiarSoC/core1SRAM1_dout0[16] ,
    \experiarSoC/core1SRAM1_dout0[15] ,
    \experiarSoC/core1SRAM1_dout0[14] ,
    \experiarSoC/core1SRAM1_dout0[13] ,
    \experiarSoC/core1SRAM1_dout0[12] ,
    \experiarSoC/core1SRAM1_dout0[11] ,
    \experiarSoC/core1SRAM1_dout0[10] ,
    \experiarSoC/core1SRAM1_dout0[9] ,
    \experiarSoC/core1SRAM1_dout0[8] ,
    \experiarSoC/core1SRAM1_dout0[7] ,
    \experiarSoC/core1SRAM1_dout0[6] ,
    \experiarSoC/core1SRAM1_dout0[5] ,
    \experiarSoC/core1SRAM1_dout0[4] ,
    \experiarSoC/core1SRAM1_dout0[3] ,
    \experiarSoC/core1SRAM1_dout0[2] ,
    \experiarSoC/core1SRAM1_dout0[1] ,
    \experiarSoC/core1SRAM1_dout0[0] }),
    .dout1({\experiarSoC/core1SRAM1_dout1[31] ,
    \experiarSoC/core1SRAM1_dout1[30] ,
    \experiarSoC/core1SRAM1_dout1[29] ,
    \experiarSoC/core1SRAM1_dout1[28] ,
    \experiarSoC/core1SRAM1_dout1[27] ,
    \experiarSoC/core1SRAM1_dout1[26] ,
    \experiarSoC/core1SRAM1_dout1[25] ,
    \experiarSoC/core1SRAM1_dout1[24] ,
    \experiarSoC/core1SRAM1_dout1[23] ,
    \experiarSoC/core1SRAM1_dout1[22] ,
    \experiarSoC/core1SRAM1_dout1[21] ,
    \experiarSoC/core1SRAM1_dout1[20] ,
    \experiarSoC/core1SRAM1_dout1[19] ,
    \experiarSoC/core1SRAM1_dout1[18] ,
    \experiarSoC/core1SRAM1_dout1[17] ,
    \experiarSoC/core1SRAM1_dout1[16] ,
    \experiarSoC/core1SRAM1_dout1[15] ,
    \experiarSoC/core1SRAM1_dout1[14] ,
    \experiarSoC/core1SRAM1_dout1[13] ,
    \experiarSoC/core1SRAM1_dout1[12] ,
    \experiarSoC/core1SRAM1_dout1[11] ,
    \experiarSoC/core1SRAM1_dout1[10] ,
    \experiarSoC/core1SRAM1_dout1[9] ,
    \experiarSoC/core1SRAM1_dout1[8] ,
    \experiarSoC/core1SRAM1_dout1[7] ,
    \experiarSoC/core1SRAM1_dout1[6] ,
    \experiarSoC/core1SRAM1_dout1[5] ,
    \experiarSoC/core1SRAM1_dout1[4] ,
    \experiarSoC/core1SRAM1_dout1[3] ,
    \experiarSoC/core1SRAM1_dout1[2] ,
    \experiarSoC/core1SRAM1_dout1[1] ,
    \experiarSoC/core1SRAM1_dout1[0] }),
    .wmask0({\experiarSoC/core1SRAM_wmask0[3] ,
    \experiarSoC/core1SRAM_wmask0[2] ,
    \experiarSoC/core1SRAM_wmask0[1] ,
    \experiarSoC/core1SRAM_wmask0[0] }));
 Flash \experiarSoC/flash  (.flash_csb(\experiarSoC/flash_csb ),
    .flash_io0_read(\experiarSoC/flash_io0_read ),
    .flash_io0_we(\experiarSoC/flash_io0_we ),
    .flash_io0_write(\experiarSoC/flash_io0_write ),
    .flash_io1_read(\experiarSoC/flash_io1_read ),
    .flash_io1_we(\experiarSoC/flash_io1_we ),
    .flash_io1_write(\experiarSoC/flash_io1_write ),
    .flash_sck(\experiarSoC/flash_sck ),
    .sram_clk0(\experiarSoC/flashSRAM_clk0 ),
    .sram_clk1(\experiarSoC/flashSRAM_clk1 ),
    .sram_csb0(\experiarSoC/flashSRAM_csb0 ),
    .sram_csb1(\experiarSoC/flashSRAM_csb1 ),
    .sram_web0(\experiarSoC/flashSRAM_web0 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_ack_o(\experiarSoC/flash_wb_ack_o ),
    .wb_clk_i(wb_clk_i),
    .wb_cyc_i(\experiarSoC/flash_wb_cyc_i ),
    .wb_error_o(\experiarSoC/flash_wb_error_o ),
    .wb_rst_i(wb_rst_i),
    .wb_stall_o(\experiarSoC/flash_wb_stall_o ),
    .wb_stb_i(\experiarSoC/flash_wb_stb_i ),
    .wb_we_i(\experiarSoC/flash_wb_we_i ),
    .sram_addr0({\experiarSoC/flashSRAM_addr0[8] ,
    \experiarSoC/flashSRAM_addr0[7] ,
    \experiarSoC/flashSRAM_addr0[6] ,
    \experiarSoC/flashSRAM_addr0[5] ,
    \experiarSoC/flashSRAM_addr0[4] ,
    \experiarSoC/flashSRAM_addr0[3] ,
    \experiarSoC/flashSRAM_addr0[2] ,
    \experiarSoC/flashSRAM_addr0[1] ,
    \experiarSoC/flashSRAM_addr0[0] }),
    .sram_addr1({\experiarSoC/flashSRAM_addr1[8] ,
    \experiarSoC/flashSRAM_addr1[7] ,
    \experiarSoC/flashSRAM_addr1[6] ,
    \experiarSoC/flashSRAM_addr1[5] ,
    \experiarSoC/flashSRAM_addr1[4] ,
    \experiarSoC/flashSRAM_addr1[3] ,
    \experiarSoC/flashSRAM_addr1[2] ,
    \experiarSoC/flashSRAM_addr1[1] ,
    \experiarSoC/flashSRAM_addr1[0] }),
    .sram_din0({\experiarSoC/flashSRAM_din0[31] ,
    \experiarSoC/flashSRAM_din0[30] ,
    \experiarSoC/flashSRAM_din0[29] ,
    \experiarSoC/flashSRAM_din0[28] ,
    \experiarSoC/flashSRAM_din0[27] ,
    \experiarSoC/flashSRAM_din0[26] ,
    \experiarSoC/flashSRAM_din0[25] ,
    \experiarSoC/flashSRAM_din0[24] ,
    \experiarSoC/flashSRAM_din0[23] ,
    \experiarSoC/flashSRAM_din0[22] ,
    \experiarSoC/flashSRAM_din0[21] ,
    \experiarSoC/flashSRAM_din0[20] ,
    \experiarSoC/flashSRAM_din0[19] ,
    \experiarSoC/flashSRAM_din0[18] ,
    \experiarSoC/flashSRAM_din0[17] ,
    \experiarSoC/flashSRAM_din0[16] ,
    \experiarSoC/flashSRAM_din0[15] ,
    \experiarSoC/flashSRAM_din0[14] ,
    \experiarSoC/flashSRAM_din0[13] ,
    \experiarSoC/flashSRAM_din0[12] ,
    \experiarSoC/flashSRAM_din0[11] ,
    \experiarSoC/flashSRAM_din0[10] ,
    \experiarSoC/flashSRAM_din0[9] ,
    \experiarSoC/flashSRAM_din0[8] ,
    \experiarSoC/flashSRAM_din0[7] ,
    \experiarSoC/flashSRAM_din0[6] ,
    \experiarSoC/flashSRAM_din0[5] ,
    \experiarSoC/flashSRAM_din0[4] ,
    \experiarSoC/flashSRAM_din0[3] ,
    \experiarSoC/flashSRAM_din0[2] ,
    \experiarSoC/flashSRAM_din0[1] ,
    \experiarSoC/flashSRAM_din0[0] }),
    .sram_dout0({\experiarSoC/flashSRAM_dout0[31] ,
    \experiarSoC/flashSRAM_dout0[30] ,
    \experiarSoC/flashSRAM_dout0[29] ,
    \experiarSoC/flashSRAM_dout0[28] ,
    \experiarSoC/flashSRAM_dout0[27] ,
    \experiarSoC/flashSRAM_dout0[26] ,
    \experiarSoC/flashSRAM_dout0[25] ,
    \experiarSoC/flashSRAM_dout0[24] ,
    \experiarSoC/flashSRAM_dout0[23] ,
    \experiarSoC/flashSRAM_dout0[22] ,
    \experiarSoC/flashSRAM_dout0[21] ,
    \experiarSoC/flashSRAM_dout0[20] ,
    \experiarSoC/flashSRAM_dout0[19] ,
    \experiarSoC/flashSRAM_dout0[18] ,
    \experiarSoC/flashSRAM_dout0[17] ,
    \experiarSoC/flashSRAM_dout0[16] ,
    \experiarSoC/flashSRAM_dout0[15] ,
    \experiarSoC/flashSRAM_dout0[14] ,
    \experiarSoC/flashSRAM_dout0[13] ,
    \experiarSoC/flashSRAM_dout0[12] ,
    \experiarSoC/flashSRAM_dout0[11] ,
    \experiarSoC/flashSRAM_dout0[10] ,
    \experiarSoC/flashSRAM_dout0[9] ,
    \experiarSoC/flashSRAM_dout0[8] ,
    \experiarSoC/flashSRAM_dout0[7] ,
    \experiarSoC/flashSRAM_dout0[6] ,
    \experiarSoC/flashSRAM_dout0[5] ,
    \experiarSoC/flashSRAM_dout0[4] ,
    \experiarSoC/flashSRAM_dout0[3] ,
    \experiarSoC/flashSRAM_dout0[2] ,
    \experiarSoC/flashSRAM_dout0[1] ,
    \experiarSoC/flashSRAM_dout0[0] }),
    .sram_dout1({\experiarSoC/flashSRAM_dout1[31] ,
    \experiarSoC/flashSRAM_dout1[30] ,
    \experiarSoC/flashSRAM_dout1[29] ,
    \experiarSoC/flashSRAM_dout1[28] ,
    \experiarSoC/flashSRAM_dout1[27] ,
    \experiarSoC/flashSRAM_dout1[26] ,
    \experiarSoC/flashSRAM_dout1[25] ,
    \experiarSoC/flashSRAM_dout1[24] ,
    \experiarSoC/flashSRAM_dout1[23] ,
    \experiarSoC/flashSRAM_dout1[22] ,
    \experiarSoC/flashSRAM_dout1[21] ,
    \experiarSoC/flashSRAM_dout1[20] ,
    \experiarSoC/flashSRAM_dout1[19] ,
    \experiarSoC/flashSRAM_dout1[18] ,
    \experiarSoC/flashSRAM_dout1[17] ,
    \experiarSoC/flashSRAM_dout1[16] ,
    \experiarSoC/flashSRAM_dout1[15] ,
    \experiarSoC/flashSRAM_dout1[14] ,
    \experiarSoC/flashSRAM_dout1[13] ,
    \experiarSoC/flashSRAM_dout1[12] ,
    \experiarSoC/flashSRAM_dout1[11] ,
    \experiarSoC/flashSRAM_dout1[10] ,
    \experiarSoC/flashSRAM_dout1[9] ,
    \experiarSoC/flashSRAM_dout1[8] ,
    \experiarSoC/flashSRAM_dout1[7] ,
    \experiarSoC/flashSRAM_dout1[6] ,
    \experiarSoC/flashSRAM_dout1[5] ,
    \experiarSoC/flashSRAM_dout1[4] ,
    \experiarSoC/flashSRAM_dout1[3] ,
    \experiarSoC/flashSRAM_dout1[2] ,
    \experiarSoC/flashSRAM_dout1[1] ,
    \experiarSoC/flashSRAM_dout1[0] }),
    .sram_wmask0({\experiarSoC/flashSRAM_wmask0[3] ,
    \experiarSoC/flashSRAM_wmask0[2] ,
    \experiarSoC/flashSRAM_wmask0[1] ,
    \experiarSoC/flashSRAM_wmask0[0] }),
    .wb_adr_i({\experiarSoC/flash_wb_adr_i[23] ,
    \experiarSoC/flash_wb_adr_i[22] ,
    \experiarSoC/flash_wb_adr_i[21] ,
    \experiarSoC/flash_wb_adr_i[20] ,
    \experiarSoC/flash_wb_adr_i[19] ,
    \experiarSoC/flash_wb_adr_i[18] ,
    \experiarSoC/flash_wb_adr_i[17] ,
    \experiarSoC/flash_wb_adr_i[16] ,
    \experiarSoC/flash_wb_adr_i[15] ,
    \experiarSoC/flash_wb_adr_i[14] ,
    \experiarSoC/flash_wb_adr_i[13] ,
    \experiarSoC/flash_wb_adr_i[12] ,
    \experiarSoC/flash_wb_adr_i[11] ,
    \experiarSoC/flash_wb_adr_i[10] ,
    \experiarSoC/flash_wb_adr_i[9] ,
    \experiarSoC/flash_wb_adr_i[8] ,
    \experiarSoC/flash_wb_adr_i[7] ,
    \experiarSoC/flash_wb_adr_i[6] ,
    \experiarSoC/flash_wb_adr_i[5] ,
    \experiarSoC/flash_wb_adr_i[4] ,
    \experiarSoC/flash_wb_adr_i[3] ,
    \experiarSoC/flash_wb_adr_i[2] ,
    \experiarSoC/flash_wb_adr_i[1] ,
    \experiarSoC/flash_wb_adr_i[0] }),
    .wb_data_i({\experiarSoC/flash_wb_data_i[31] ,
    \experiarSoC/flash_wb_data_i[30] ,
    \experiarSoC/flash_wb_data_i[29] ,
    \experiarSoC/flash_wb_data_i[28] ,
    \experiarSoC/flash_wb_data_i[27] ,
    \experiarSoC/flash_wb_data_i[26] ,
    \experiarSoC/flash_wb_data_i[25] ,
    \experiarSoC/flash_wb_data_i[24] ,
    \experiarSoC/flash_wb_data_i[23] ,
    \experiarSoC/flash_wb_data_i[22] ,
    \experiarSoC/flash_wb_data_i[21] ,
    \experiarSoC/flash_wb_data_i[20] ,
    \experiarSoC/flash_wb_data_i[19] ,
    \experiarSoC/flash_wb_data_i[18] ,
    \experiarSoC/flash_wb_data_i[17] ,
    \experiarSoC/flash_wb_data_i[16] ,
    \experiarSoC/flash_wb_data_i[15] ,
    \experiarSoC/flash_wb_data_i[14] ,
    \experiarSoC/flash_wb_data_i[13] ,
    \experiarSoC/flash_wb_data_i[12] ,
    \experiarSoC/flash_wb_data_i[11] ,
    \experiarSoC/flash_wb_data_i[10] ,
    \experiarSoC/flash_wb_data_i[9] ,
    \experiarSoC/flash_wb_data_i[8] ,
    \experiarSoC/flash_wb_data_i[7] ,
    \experiarSoC/flash_wb_data_i[6] ,
    \experiarSoC/flash_wb_data_i[5] ,
    \experiarSoC/flash_wb_data_i[4] ,
    \experiarSoC/flash_wb_data_i[3] ,
    \experiarSoC/flash_wb_data_i[2] ,
    \experiarSoC/flash_wb_data_i[1] ,
    \experiarSoC/flash_wb_data_i[0] }),
    .wb_data_o({\experiarSoC/flash_wb_data_o[31] ,
    \experiarSoC/flash_wb_data_o[30] ,
    \experiarSoC/flash_wb_data_o[29] ,
    \experiarSoC/flash_wb_data_o[28] ,
    \experiarSoC/flash_wb_data_o[27] ,
    \experiarSoC/flash_wb_data_o[26] ,
    \experiarSoC/flash_wb_data_o[25] ,
    \experiarSoC/flash_wb_data_o[24] ,
    \experiarSoC/flash_wb_data_o[23] ,
    \experiarSoC/flash_wb_data_o[22] ,
    \experiarSoC/flash_wb_data_o[21] ,
    \experiarSoC/flash_wb_data_o[20] ,
    \experiarSoC/flash_wb_data_o[19] ,
    \experiarSoC/flash_wb_data_o[18] ,
    \experiarSoC/flash_wb_data_o[17] ,
    \experiarSoC/flash_wb_data_o[16] ,
    \experiarSoC/flash_wb_data_o[15] ,
    \experiarSoC/flash_wb_data_o[14] ,
    \experiarSoC/flash_wb_data_o[13] ,
    \experiarSoC/flash_wb_data_o[12] ,
    \experiarSoC/flash_wb_data_o[11] ,
    \experiarSoC/flash_wb_data_o[10] ,
    \experiarSoC/flash_wb_data_o[9] ,
    \experiarSoC/flash_wb_data_o[8] ,
    \experiarSoC/flash_wb_data_o[7] ,
    \experiarSoC/flash_wb_data_o[6] ,
    \experiarSoC/flash_wb_data_o[5] ,
    \experiarSoC/flash_wb_data_o[4] ,
    \experiarSoC/flash_wb_data_o[3] ,
    \experiarSoC/flash_wb_data_o[2] ,
    \experiarSoC/flash_wb_data_o[1] ,
    \experiarSoC/flash_wb_data_o[0] }),
    .wb_sel_i({\experiarSoC/flash_wb_sel_i[3] ,
    \experiarSoC/flash_wb_sel_i[2] ,
    \experiarSoC/flash_wb_sel_i[1] ,
    \experiarSoC/flash_wb_sel_i[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/flashSRAM  (.csb0(\experiarSoC/flashSRAM_csb0 ),
    .csb1(\experiarSoC/flashSRAM_csb1 ),
    .web0(\experiarSoC/flashSRAM_web0 ),
    .clk0(\experiarSoC/flashSRAM_clk0 ),
    .clk1(\experiarSoC/flashSRAM_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/flashSRAM_addr0[8] ,
    \experiarSoC/flashSRAM_addr0[7] ,
    \experiarSoC/flashSRAM_addr0[6] ,
    \experiarSoC/flashSRAM_addr0[5] ,
    \experiarSoC/flashSRAM_addr0[4] ,
    \experiarSoC/flashSRAM_addr0[3] ,
    \experiarSoC/flashSRAM_addr0[2] ,
    \experiarSoC/flashSRAM_addr0[1] ,
    \experiarSoC/flashSRAM_addr0[0] }),
    .addr1({\experiarSoC/flashSRAM_addr1[8] ,
    \experiarSoC/flashSRAM_addr1[7] ,
    \experiarSoC/flashSRAM_addr1[6] ,
    \experiarSoC/flashSRAM_addr1[5] ,
    \experiarSoC/flashSRAM_addr1[4] ,
    \experiarSoC/flashSRAM_addr1[3] ,
    \experiarSoC/flashSRAM_addr1[2] ,
    \experiarSoC/flashSRAM_addr1[1] ,
    \experiarSoC/flashSRAM_addr1[0] }),
    .din0({\experiarSoC/flashSRAM_din0[31] ,
    \experiarSoC/flashSRAM_din0[30] ,
    \experiarSoC/flashSRAM_din0[29] ,
    \experiarSoC/flashSRAM_din0[28] ,
    \experiarSoC/flashSRAM_din0[27] ,
    \experiarSoC/flashSRAM_din0[26] ,
    \experiarSoC/flashSRAM_din0[25] ,
    \experiarSoC/flashSRAM_din0[24] ,
    \experiarSoC/flashSRAM_din0[23] ,
    \experiarSoC/flashSRAM_din0[22] ,
    \experiarSoC/flashSRAM_din0[21] ,
    \experiarSoC/flashSRAM_din0[20] ,
    \experiarSoC/flashSRAM_din0[19] ,
    \experiarSoC/flashSRAM_din0[18] ,
    \experiarSoC/flashSRAM_din0[17] ,
    \experiarSoC/flashSRAM_din0[16] ,
    \experiarSoC/flashSRAM_din0[15] ,
    \experiarSoC/flashSRAM_din0[14] ,
    \experiarSoC/flashSRAM_din0[13] ,
    \experiarSoC/flashSRAM_din0[12] ,
    \experiarSoC/flashSRAM_din0[11] ,
    \experiarSoC/flashSRAM_din0[10] ,
    \experiarSoC/flashSRAM_din0[9] ,
    \experiarSoC/flashSRAM_din0[8] ,
    \experiarSoC/flashSRAM_din0[7] ,
    \experiarSoC/flashSRAM_din0[6] ,
    \experiarSoC/flashSRAM_din0[5] ,
    \experiarSoC/flashSRAM_din0[4] ,
    \experiarSoC/flashSRAM_din0[3] ,
    \experiarSoC/flashSRAM_din0[2] ,
    \experiarSoC/flashSRAM_din0[1] ,
    \experiarSoC/flashSRAM_din0[0] }),
    .dout0({\experiarSoC/flashSRAM_dout0[31] ,
    \experiarSoC/flashSRAM_dout0[30] ,
    \experiarSoC/flashSRAM_dout0[29] ,
    \experiarSoC/flashSRAM_dout0[28] ,
    \experiarSoC/flashSRAM_dout0[27] ,
    \experiarSoC/flashSRAM_dout0[26] ,
    \experiarSoC/flashSRAM_dout0[25] ,
    \experiarSoC/flashSRAM_dout0[24] ,
    \experiarSoC/flashSRAM_dout0[23] ,
    \experiarSoC/flashSRAM_dout0[22] ,
    \experiarSoC/flashSRAM_dout0[21] ,
    \experiarSoC/flashSRAM_dout0[20] ,
    \experiarSoC/flashSRAM_dout0[19] ,
    \experiarSoC/flashSRAM_dout0[18] ,
    \experiarSoC/flashSRAM_dout0[17] ,
    \experiarSoC/flashSRAM_dout0[16] ,
    \experiarSoC/flashSRAM_dout0[15] ,
    \experiarSoC/flashSRAM_dout0[14] ,
    \experiarSoC/flashSRAM_dout0[13] ,
    \experiarSoC/flashSRAM_dout0[12] ,
    \experiarSoC/flashSRAM_dout0[11] ,
    \experiarSoC/flashSRAM_dout0[10] ,
    \experiarSoC/flashSRAM_dout0[9] ,
    \experiarSoC/flashSRAM_dout0[8] ,
    \experiarSoC/flashSRAM_dout0[7] ,
    \experiarSoC/flashSRAM_dout0[6] ,
    \experiarSoC/flashSRAM_dout0[5] ,
    \experiarSoC/flashSRAM_dout0[4] ,
    \experiarSoC/flashSRAM_dout0[3] ,
    \experiarSoC/flashSRAM_dout0[2] ,
    \experiarSoC/flashSRAM_dout0[1] ,
    \experiarSoC/flashSRAM_dout0[0] }),
    .dout1({\experiarSoC/flashSRAM_dout1[31] ,
    \experiarSoC/flashSRAM_dout1[30] ,
    \experiarSoC/flashSRAM_dout1[29] ,
    \experiarSoC/flashSRAM_dout1[28] ,
    \experiarSoC/flashSRAM_dout1[27] ,
    \experiarSoC/flashSRAM_dout1[26] ,
    \experiarSoC/flashSRAM_dout1[25] ,
    \experiarSoC/flashSRAM_dout1[24] ,
    \experiarSoC/flashSRAM_dout1[23] ,
    \experiarSoC/flashSRAM_dout1[22] ,
    \experiarSoC/flashSRAM_dout1[21] ,
    \experiarSoC/flashSRAM_dout1[20] ,
    \experiarSoC/flashSRAM_dout1[19] ,
    \experiarSoC/flashSRAM_dout1[18] ,
    \experiarSoC/flashSRAM_dout1[17] ,
    \experiarSoC/flashSRAM_dout1[16] ,
    \experiarSoC/flashSRAM_dout1[15] ,
    \experiarSoC/flashSRAM_dout1[14] ,
    \experiarSoC/flashSRAM_dout1[13] ,
    \experiarSoC/flashSRAM_dout1[12] ,
    \experiarSoC/flashSRAM_dout1[11] ,
    \experiarSoC/flashSRAM_dout1[10] ,
    \experiarSoC/flashSRAM_dout1[9] ,
    \experiarSoC/flashSRAM_dout1[8] ,
    \experiarSoC/flashSRAM_dout1[7] ,
    \experiarSoC/flashSRAM_dout1[6] ,
    \experiarSoC/flashSRAM_dout1[5] ,
    \experiarSoC/flashSRAM_dout1[4] ,
    \experiarSoC/flashSRAM_dout1[3] ,
    \experiarSoC/flashSRAM_dout1[2] ,
    \experiarSoC/flashSRAM_dout1[1] ,
    \experiarSoC/flashSRAM_dout1[0] }),
    .wmask0({\experiarSoC/flashSRAM_wmask0[3] ,
    \experiarSoC/flashSRAM_wmask0[2] ,
    \experiarSoC/flashSRAM_wmask0[1] ,
    \experiarSoC/flashSRAM_wmask0[0] }));
 Peripherals \experiarSoC/peripherals  (.flash_csb(\experiarSoC/flash_csb ),
    .flash_io0_read(\experiarSoC/flash_io0_read ),
    .flash_io0_we(\experiarSoC/flash_io0_we ),
    .flash_io0_write(\experiarSoC/flash_io0_write ),
    .flash_io1_read(\experiarSoC/flash_io1_read ),
    .flash_io1_we(\experiarSoC/flash_io1_we ),
    .flash_io1_write(\experiarSoC/flash_io1_write ),
    .flash_sck(\experiarSoC/flash_sck ),
    .internal_uart_rx(caravel_uart_rx),
    .internal_uart_tx(caravel_uart_tx),
    .jtag_tck(\experiarSoC/jtag_tck ),
    .jtag_tdi(\experiarSoC/core0_tdi ),
    .jtag_tdo(\experiarSoC/core1_tdo ),
    .jtag_tms(\experiarSoC/jtag_tms ),
    .vccd1(vccd1),
    .vga_hsync(\experiarSoC/vga_hsync ),
    .vga_vsync(\experiarSoC/vga_vsync ),
    .vssd1(vssd1),
    .wb_ack_o(\experiarSoC/peripherals_wb_ack_o ),
    .wb_clk_i(wb_clk_i),
    .wb_cyc_i(\experiarSoC/peripherals_wb_cyc_i ),
    .wb_error_o(\experiarSoC/peripherals_wb_error_o ),
    .wb_rst_i(wb_rst_i),
    .wb_stall_o(\experiarSoC/peripherals_wb_stall_o ),
    .wb_stb_i(\experiarSoC/peripherals_wb_stb_i ),
    .wb_we_i(\experiarSoC/peripherals_wb_we_i ),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5],
    io_in[4],
    io_in[3],
    io_in[2],
    io_in[1],
    io_in[0]}),
    .io_oeb({io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .io_out({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}),
    .probe_blink({la_data_out[1],
    la_data_out[0]}),
    .vga_b({\experiarSoC/vga_b[1] ,
    \experiarSoC/vga_b[0] }),
    .vga_g({\experiarSoC/vga_g[1] ,
    \experiarSoC/vga_g[0] }),
    .vga_r({\experiarSoC/vga_r[1] ,
    \experiarSoC/vga_r[0] }),
    .wb_adr_i({\experiarSoC/peripherals_wb_adr_i[23] ,
    \experiarSoC/peripherals_wb_adr_i[22] ,
    \experiarSoC/peripherals_wb_adr_i[21] ,
    \experiarSoC/peripherals_wb_adr_i[20] ,
    \experiarSoC/peripherals_wb_adr_i[19] ,
    \experiarSoC/peripherals_wb_adr_i[18] ,
    \experiarSoC/peripherals_wb_adr_i[17] ,
    \experiarSoC/peripherals_wb_adr_i[16] ,
    \experiarSoC/peripherals_wb_adr_i[15] ,
    \experiarSoC/peripherals_wb_adr_i[14] ,
    \experiarSoC/peripherals_wb_adr_i[13] ,
    \experiarSoC/peripherals_wb_adr_i[12] ,
    \experiarSoC/peripherals_wb_adr_i[11] ,
    \experiarSoC/peripherals_wb_adr_i[10] ,
    \experiarSoC/peripherals_wb_adr_i[9] ,
    \experiarSoC/peripherals_wb_adr_i[8] ,
    \experiarSoC/peripherals_wb_adr_i[7] ,
    \experiarSoC/peripherals_wb_adr_i[6] ,
    \experiarSoC/peripherals_wb_adr_i[5] ,
    \experiarSoC/peripherals_wb_adr_i[4] ,
    \experiarSoC/peripherals_wb_adr_i[3] ,
    \experiarSoC/peripherals_wb_adr_i[2] ,
    \experiarSoC/peripherals_wb_adr_i[1] ,
    \experiarSoC/peripherals_wb_adr_i[0] }),
    .wb_data_i({\experiarSoC/peripherals_wb_data_i[31] ,
    \experiarSoC/peripherals_wb_data_i[30] ,
    \experiarSoC/peripherals_wb_data_i[29] ,
    \experiarSoC/peripherals_wb_data_i[28] ,
    \experiarSoC/peripherals_wb_data_i[27] ,
    \experiarSoC/peripherals_wb_data_i[26] ,
    \experiarSoC/peripherals_wb_data_i[25] ,
    \experiarSoC/peripherals_wb_data_i[24] ,
    \experiarSoC/peripherals_wb_data_i[23] ,
    \experiarSoC/peripherals_wb_data_i[22] ,
    \experiarSoC/peripherals_wb_data_i[21] ,
    \experiarSoC/peripherals_wb_data_i[20] ,
    \experiarSoC/peripherals_wb_data_i[19] ,
    \experiarSoC/peripherals_wb_data_i[18] ,
    \experiarSoC/peripherals_wb_data_i[17] ,
    \experiarSoC/peripherals_wb_data_i[16] ,
    \experiarSoC/peripherals_wb_data_i[15] ,
    \experiarSoC/peripherals_wb_data_i[14] ,
    \experiarSoC/peripherals_wb_data_i[13] ,
    \experiarSoC/peripherals_wb_data_i[12] ,
    \experiarSoC/peripherals_wb_data_i[11] ,
    \experiarSoC/peripherals_wb_data_i[10] ,
    \experiarSoC/peripherals_wb_data_i[9] ,
    \experiarSoC/peripherals_wb_data_i[8] ,
    \experiarSoC/peripherals_wb_data_i[7] ,
    \experiarSoC/peripherals_wb_data_i[6] ,
    \experiarSoC/peripherals_wb_data_i[5] ,
    \experiarSoC/peripherals_wb_data_i[4] ,
    \experiarSoC/peripherals_wb_data_i[3] ,
    \experiarSoC/peripherals_wb_data_i[2] ,
    \experiarSoC/peripherals_wb_data_i[1] ,
    \experiarSoC/peripherals_wb_data_i[0] }),
    .wb_data_o({\experiarSoC/peripherals_wb_data_o[31] ,
    \experiarSoC/peripherals_wb_data_o[30] ,
    \experiarSoC/peripherals_wb_data_o[29] ,
    \experiarSoC/peripherals_wb_data_o[28] ,
    \experiarSoC/peripherals_wb_data_o[27] ,
    \experiarSoC/peripherals_wb_data_o[26] ,
    \experiarSoC/peripherals_wb_data_o[25] ,
    \experiarSoC/peripherals_wb_data_o[24] ,
    \experiarSoC/peripherals_wb_data_o[23] ,
    \experiarSoC/peripherals_wb_data_o[22] ,
    \experiarSoC/peripherals_wb_data_o[21] ,
    \experiarSoC/peripherals_wb_data_o[20] ,
    \experiarSoC/peripherals_wb_data_o[19] ,
    \experiarSoC/peripherals_wb_data_o[18] ,
    \experiarSoC/peripherals_wb_data_o[17] ,
    \experiarSoC/peripherals_wb_data_o[16] ,
    \experiarSoC/peripherals_wb_data_o[15] ,
    \experiarSoC/peripherals_wb_data_o[14] ,
    \experiarSoC/peripherals_wb_data_o[13] ,
    \experiarSoC/peripherals_wb_data_o[12] ,
    \experiarSoC/peripherals_wb_data_o[11] ,
    \experiarSoC/peripherals_wb_data_o[10] ,
    \experiarSoC/peripherals_wb_data_o[9] ,
    \experiarSoC/peripherals_wb_data_o[8] ,
    \experiarSoC/peripherals_wb_data_o[7] ,
    \experiarSoC/peripherals_wb_data_o[6] ,
    \experiarSoC/peripherals_wb_data_o[5] ,
    \experiarSoC/peripherals_wb_data_o[4] ,
    \experiarSoC/peripherals_wb_data_o[3] ,
    \experiarSoC/peripherals_wb_data_o[2] ,
    \experiarSoC/peripherals_wb_data_o[1] ,
    \experiarSoC/peripherals_wb_data_o[0] }),
    .wb_sel_i({\experiarSoC/peripherals_wb_sel_i[3] ,
    \experiarSoC/peripherals_wb_sel_i[2] ,
    \experiarSoC/peripherals_wb_sel_i[1] ,
    \experiarSoC/peripherals_wb_sel_i[0] }));
 Video \experiarSoC/video  (.sram0_clk0(\experiarSoC/videoSRAMLeft_clk0 ),
    .sram0_clk1(\experiarSoC/videoSRAMLeft_clk1 ),
    .sram0_web0(\experiarSoC/videoSRAMLeft_web0 ),
    .sram1_clk0(\experiarSoC/videoSRAMRight_clk0 ),
    .sram1_clk1(\experiarSoC/videoSRAMRight_clk1 ),
    .sram1_web0(\experiarSoC/videoSRAMRight_web0 ),
    .vccd1(vccd1),
    .vga_hsync(\experiarSoC/vga_hsync ),
    .vga_vsync(\experiarSoC/vga_vsync ),
    .vssd1(vssd1),
    .wb_ack_o(\experiarSoC/videoMemory_wb_ack_o ),
    .wb_clk_i(wb_clk_i),
    .wb_cyc_i(\experiarSoC/videoMemory_wb_cyc_i ),
    .wb_error_o(\experiarSoC/videoMemory_wb_error_o ),
    .wb_rst_i(wb_rst_i),
    .wb_stall_o(\experiarSoC/videoMemory_wb_stall_o ),
    .wb_stb_i(\experiarSoC/videoMemory_wb_stb_i ),
    .wb_we_i(\experiarSoC/videoMemory_wb_we_i ),
    .sram0_addr0({\experiarSoC/videoSRAMLeft_addr0[8] ,
    \experiarSoC/videoSRAMLeft_addr0[7] ,
    \experiarSoC/videoSRAMLeft_addr0[6] ,
    \experiarSoC/videoSRAMLeft_addr0[5] ,
    \experiarSoC/videoSRAMLeft_addr0[4] ,
    \experiarSoC/videoSRAMLeft_addr0[3] ,
    \experiarSoC/videoSRAMLeft_addr0[2] ,
    \experiarSoC/videoSRAMLeft_addr0[1] ,
    \experiarSoC/videoSRAMLeft_addr0[0] }),
    .sram0_addr1({\experiarSoC/videoSRAMLeft_addr1[8] ,
    \experiarSoC/videoSRAMLeft_addr1[7] ,
    \experiarSoC/videoSRAMLeft_addr1[6] ,
    \experiarSoC/videoSRAMLeft_addr1[5] ,
    \experiarSoC/videoSRAMLeft_addr1[4] ,
    \experiarSoC/videoSRAMLeft_addr1[3] ,
    \experiarSoC/videoSRAMLeft_addr1[2] ,
    \experiarSoC/videoSRAMLeft_addr1[1] ,
    \experiarSoC/videoSRAMLeft_addr1[0] }),
    .sram0_csb0({\experiarSoC/videoSRAMLeft_csb0[1] ,
    \experiarSoC/videoSRAMLeft_csb0[0] }),
    .sram0_csb1({\experiarSoC/videoSRAMLeft_csb1[1] ,
    \experiarSoC/videoSRAMLeft_csb1[0] }),
    .sram0_din0({\experiarSoC/videoSRAMLeft_din0[31] ,
    \experiarSoC/videoSRAMLeft_din0[30] ,
    \experiarSoC/videoSRAMLeft_din0[29] ,
    \experiarSoC/videoSRAMLeft_din0[28] ,
    \experiarSoC/videoSRAMLeft_din0[27] ,
    \experiarSoC/videoSRAMLeft_din0[26] ,
    \experiarSoC/videoSRAMLeft_din0[25] ,
    \experiarSoC/videoSRAMLeft_din0[24] ,
    \experiarSoC/videoSRAMLeft_din0[23] ,
    \experiarSoC/videoSRAMLeft_din0[22] ,
    \experiarSoC/videoSRAMLeft_din0[21] ,
    \experiarSoC/videoSRAMLeft_din0[20] ,
    \experiarSoC/videoSRAMLeft_din0[19] ,
    \experiarSoC/videoSRAMLeft_din0[18] ,
    \experiarSoC/videoSRAMLeft_din0[17] ,
    \experiarSoC/videoSRAMLeft_din0[16] ,
    \experiarSoC/videoSRAMLeft_din0[15] ,
    \experiarSoC/videoSRAMLeft_din0[14] ,
    \experiarSoC/videoSRAMLeft_din0[13] ,
    \experiarSoC/videoSRAMLeft_din0[12] ,
    \experiarSoC/videoSRAMLeft_din0[11] ,
    \experiarSoC/videoSRAMLeft_din0[10] ,
    \experiarSoC/videoSRAMLeft_din0[9] ,
    \experiarSoC/videoSRAMLeft_din0[8] ,
    \experiarSoC/videoSRAMLeft_din0[7] ,
    \experiarSoC/videoSRAMLeft_din0[6] ,
    \experiarSoC/videoSRAMLeft_din0[5] ,
    \experiarSoC/videoSRAMLeft_din0[4] ,
    \experiarSoC/videoSRAMLeft_din0[3] ,
    \experiarSoC/videoSRAMLeft_din0[2] ,
    \experiarSoC/videoSRAMLeft_din0[1] ,
    \experiarSoC/videoSRAMLeft_din0[0] }),
    .sram0_dout0({\experiarSoC/videoSRAM1_dout0[31] ,
    \experiarSoC/videoSRAM1_dout0[30] ,
    \experiarSoC/videoSRAM1_dout0[29] ,
    \experiarSoC/videoSRAM1_dout0[28] ,
    \experiarSoC/videoSRAM1_dout0[27] ,
    \experiarSoC/videoSRAM1_dout0[26] ,
    \experiarSoC/videoSRAM1_dout0[25] ,
    \experiarSoC/videoSRAM1_dout0[24] ,
    \experiarSoC/videoSRAM1_dout0[23] ,
    \experiarSoC/videoSRAM1_dout0[22] ,
    \experiarSoC/videoSRAM1_dout0[21] ,
    \experiarSoC/videoSRAM1_dout0[20] ,
    \experiarSoC/videoSRAM1_dout0[19] ,
    \experiarSoC/videoSRAM1_dout0[18] ,
    \experiarSoC/videoSRAM1_dout0[17] ,
    \experiarSoC/videoSRAM1_dout0[16] ,
    \experiarSoC/videoSRAM1_dout0[15] ,
    \experiarSoC/videoSRAM1_dout0[14] ,
    \experiarSoC/videoSRAM1_dout0[13] ,
    \experiarSoC/videoSRAM1_dout0[12] ,
    \experiarSoC/videoSRAM1_dout0[11] ,
    \experiarSoC/videoSRAM1_dout0[10] ,
    \experiarSoC/videoSRAM1_dout0[9] ,
    \experiarSoC/videoSRAM1_dout0[8] ,
    \experiarSoC/videoSRAM1_dout0[7] ,
    \experiarSoC/videoSRAM1_dout0[6] ,
    \experiarSoC/videoSRAM1_dout0[5] ,
    \experiarSoC/videoSRAM1_dout0[4] ,
    \experiarSoC/videoSRAM1_dout0[3] ,
    \experiarSoC/videoSRAM1_dout0[2] ,
    \experiarSoC/videoSRAM1_dout0[1] ,
    \experiarSoC/videoSRAM1_dout0[0] ,
    \experiarSoC/videoSRAM0_dout0[31] ,
    \experiarSoC/videoSRAM0_dout0[30] ,
    \experiarSoC/videoSRAM0_dout0[29] ,
    \experiarSoC/videoSRAM0_dout0[28] ,
    \experiarSoC/videoSRAM0_dout0[27] ,
    \experiarSoC/videoSRAM0_dout0[26] ,
    \experiarSoC/videoSRAM0_dout0[25] ,
    \experiarSoC/videoSRAM0_dout0[24] ,
    \experiarSoC/videoSRAM0_dout0[23] ,
    \experiarSoC/videoSRAM0_dout0[22] ,
    \experiarSoC/videoSRAM0_dout0[21] ,
    \experiarSoC/videoSRAM0_dout0[20] ,
    \experiarSoC/videoSRAM0_dout0[19] ,
    \experiarSoC/videoSRAM0_dout0[18] ,
    \experiarSoC/videoSRAM0_dout0[17] ,
    \experiarSoC/videoSRAM0_dout0[16] ,
    \experiarSoC/videoSRAM0_dout0[15] ,
    \experiarSoC/videoSRAM0_dout0[14] ,
    \experiarSoC/videoSRAM0_dout0[13] ,
    \experiarSoC/videoSRAM0_dout0[12] ,
    \experiarSoC/videoSRAM0_dout0[11] ,
    \experiarSoC/videoSRAM0_dout0[10] ,
    \experiarSoC/videoSRAM0_dout0[9] ,
    \experiarSoC/videoSRAM0_dout0[8] ,
    \experiarSoC/videoSRAM0_dout0[7] ,
    \experiarSoC/videoSRAM0_dout0[6] ,
    \experiarSoC/videoSRAM0_dout0[5] ,
    \experiarSoC/videoSRAM0_dout0[4] ,
    \experiarSoC/videoSRAM0_dout0[3] ,
    \experiarSoC/videoSRAM0_dout0[2] ,
    \experiarSoC/videoSRAM0_dout0[1] ,
    \experiarSoC/videoSRAM0_dout0[0] }),
    .sram0_dout1({\experiarSoC/videoSRAM1_dout1[31] ,
    \experiarSoC/videoSRAM1_dout1[30] ,
    \experiarSoC/videoSRAM1_dout1[29] ,
    \experiarSoC/videoSRAM1_dout1[28] ,
    \experiarSoC/videoSRAM1_dout1[27] ,
    \experiarSoC/videoSRAM1_dout1[26] ,
    \experiarSoC/videoSRAM1_dout1[25] ,
    \experiarSoC/videoSRAM1_dout1[24] ,
    \experiarSoC/videoSRAM1_dout1[23] ,
    \experiarSoC/videoSRAM1_dout1[22] ,
    \experiarSoC/videoSRAM1_dout1[21] ,
    \experiarSoC/videoSRAM1_dout1[20] ,
    \experiarSoC/videoSRAM1_dout1[19] ,
    \experiarSoC/videoSRAM1_dout1[18] ,
    \experiarSoC/videoSRAM1_dout1[17] ,
    \experiarSoC/videoSRAM1_dout1[16] ,
    \experiarSoC/videoSRAM1_dout1[15] ,
    \experiarSoC/videoSRAM1_dout1[14] ,
    \experiarSoC/videoSRAM1_dout1[13] ,
    \experiarSoC/videoSRAM1_dout1[12] ,
    \experiarSoC/videoSRAM1_dout1[11] ,
    \experiarSoC/videoSRAM1_dout1[10] ,
    \experiarSoC/videoSRAM1_dout1[9] ,
    \experiarSoC/videoSRAM1_dout1[8] ,
    \experiarSoC/videoSRAM1_dout1[7] ,
    \experiarSoC/videoSRAM1_dout1[6] ,
    \experiarSoC/videoSRAM1_dout1[5] ,
    \experiarSoC/videoSRAM1_dout1[4] ,
    \experiarSoC/videoSRAM1_dout1[3] ,
    \experiarSoC/videoSRAM1_dout1[2] ,
    \experiarSoC/videoSRAM1_dout1[1] ,
    \experiarSoC/videoSRAM1_dout1[0] ,
    \experiarSoC/videoSRAM0_dout1[31] ,
    \experiarSoC/videoSRAM0_dout1[30] ,
    \experiarSoC/videoSRAM0_dout1[29] ,
    \experiarSoC/videoSRAM0_dout1[28] ,
    \experiarSoC/videoSRAM0_dout1[27] ,
    \experiarSoC/videoSRAM0_dout1[26] ,
    \experiarSoC/videoSRAM0_dout1[25] ,
    \experiarSoC/videoSRAM0_dout1[24] ,
    \experiarSoC/videoSRAM0_dout1[23] ,
    \experiarSoC/videoSRAM0_dout1[22] ,
    \experiarSoC/videoSRAM0_dout1[21] ,
    \experiarSoC/videoSRAM0_dout1[20] ,
    \experiarSoC/videoSRAM0_dout1[19] ,
    \experiarSoC/videoSRAM0_dout1[18] ,
    \experiarSoC/videoSRAM0_dout1[17] ,
    \experiarSoC/videoSRAM0_dout1[16] ,
    \experiarSoC/videoSRAM0_dout1[15] ,
    \experiarSoC/videoSRAM0_dout1[14] ,
    \experiarSoC/videoSRAM0_dout1[13] ,
    \experiarSoC/videoSRAM0_dout1[12] ,
    \experiarSoC/videoSRAM0_dout1[11] ,
    \experiarSoC/videoSRAM0_dout1[10] ,
    \experiarSoC/videoSRAM0_dout1[9] ,
    \experiarSoC/videoSRAM0_dout1[8] ,
    \experiarSoC/videoSRAM0_dout1[7] ,
    \experiarSoC/videoSRAM0_dout1[6] ,
    \experiarSoC/videoSRAM0_dout1[5] ,
    \experiarSoC/videoSRAM0_dout1[4] ,
    \experiarSoC/videoSRAM0_dout1[3] ,
    \experiarSoC/videoSRAM0_dout1[2] ,
    \experiarSoC/videoSRAM0_dout1[1] ,
    \experiarSoC/videoSRAM0_dout1[0] }),
    .sram0_wmask0({\experiarSoC/videoSRAMLeft_wmask0[3] ,
    \experiarSoC/videoSRAMLeft_wmask0[2] ,
    \experiarSoC/videoSRAMLeft_wmask0[1] ,
    \experiarSoC/videoSRAMLeft_wmask0[0] }),
    .sram1_addr0({\experiarSoC/videoSRAMRight_addr0[8] ,
    \experiarSoC/videoSRAMRight_addr0[7] ,
    \experiarSoC/videoSRAMRight_addr0[6] ,
    \experiarSoC/videoSRAMRight_addr0[5] ,
    \experiarSoC/videoSRAMRight_addr0[4] ,
    \experiarSoC/videoSRAMRight_addr0[3] ,
    \experiarSoC/videoSRAMRight_addr0[2] ,
    \experiarSoC/videoSRAMRight_addr0[1] ,
    \experiarSoC/videoSRAMRight_addr0[0] }),
    .sram1_addr1({\experiarSoC/videoSRAMRight_addr1[8] ,
    \experiarSoC/videoSRAMRight_addr1[7] ,
    \experiarSoC/videoSRAMRight_addr1[6] ,
    \experiarSoC/videoSRAMRight_addr1[5] ,
    \experiarSoC/videoSRAMRight_addr1[4] ,
    \experiarSoC/videoSRAMRight_addr1[3] ,
    \experiarSoC/videoSRAMRight_addr1[2] ,
    \experiarSoC/videoSRAMRight_addr1[1] ,
    \experiarSoC/videoSRAMRight_addr1[0] }),
    .sram1_csb0({\experiarSoC/videoSRAMRight_csb0[1] ,
    \experiarSoC/videoSRAMRight_csb0[0] }),
    .sram1_csb1({\experiarSoC/videoSRAMRight_csb1[1] ,
    \experiarSoC/videoSRAMRight_csb1[0] }),
    .sram1_din0({\experiarSoC/videoSRAMRight_din0[31] ,
    \experiarSoC/videoSRAMRight_din0[30] ,
    \experiarSoC/videoSRAMRight_din0[29] ,
    \experiarSoC/videoSRAMRight_din0[28] ,
    \experiarSoC/videoSRAMRight_din0[27] ,
    \experiarSoC/videoSRAMRight_din0[26] ,
    \experiarSoC/videoSRAMRight_din0[25] ,
    \experiarSoC/videoSRAMRight_din0[24] ,
    \experiarSoC/videoSRAMRight_din0[23] ,
    \experiarSoC/videoSRAMRight_din0[22] ,
    \experiarSoC/videoSRAMRight_din0[21] ,
    \experiarSoC/videoSRAMRight_din0[20] ,
    \experiarSoC/videoSRAMRight_din0[19] ,
    \experiarSoC/videoSRAMRight_din0[18] ,
    \experiarSoC/videoSRAMRight_din0[17] ,
    \experiarSoC/videoSRAMRight_din0[16] ,
    \experiarSoC/videoSRAMRight_din0[15] ,
    \experiarSoC/videoSRAMRight_din0[14] ,
    \experiarSoC/videoSRAMRight_din0[13] ,
    \experiarSoC/videoSRAMRight_din0[12] ,
    \experiarSoC/videoSRAMRight_din0[11] ,
    \experiarSoC/videoSRAMRight_din0[10] ,
    \experiarSoC/videoSRAMRight_din0[9] ,
    \experiarSoC/videoSRAMRight_din0[8] ,
    \experiarSoC/videoSRAMRight_din0[7] ,
    \experiarSoC/videoSRAMRight_din0[6] ,
    \experiarSoC/videoSRAMRight_din0[5] ,
    \experiarSoC/videoSRAMRight_din0[4] ,
    \experiarSoC/videoSRAMRight_din0[3] ,
    \experiarSoC/videoSRAMRight_din0[2] ,
    \experiarSoC/videoSRAMRight_din0[1] ,
    \experiarSoC/videoSRAMRight_din0[0] }),
    .sram1_dout0({\experiarSoC/videoSRAM3_dout0[31] ,
    \experiarSoC/videoSRAM3_dout0[30] ,
    \experiarSoC/videoSRAM3_dout0[29] ,
    \experiarSoC/videoSRAM3_dout0[28] ,
    \experiarSoC/videoSRAM3_dout0[27] ,
    \experiarSoC/videoSRAM3_dout0[26] ,
    \experiarSoC/videoSRAM3_dout0[25] ,
    \experiarSoC/videoSRAM3_dout0[24] ,
    \experiarSoC/videoSRAM3_dout0[23] ,
    \experiarSoC/videoSRAM3_dout0[22] ,
    \experiarSoC/videoSRAM3_dout0[21] ,
    \experiarSoC/videoSRAM3_dout0[20] ,
    \experiarSoC/videoSRAM3_dout0[19] ,
    \experiarSoC/videoSRAM3_dout0[18] ,
    \experiarSoC/videoSRAM3_dout0[17] ,
    \experiarSoC/videoSRAM3_dout0[16] ,
    \experiarSoC/videoSRAM3_dout0[15] ,
    \experiarSoC/videoSRAM3_dout0[14] ,
    \experiarSoC/videoSRAM3_dout0[13] ,
    \experiarSoC/videoSRAM3_dout0[12] ,
    \experiarSoC/videoSRAM3_dout0[11] ,
    \experiarSoC/videoSRAM3_dout0[10] ,
    \experiarSoC/videoSRAM3_dout0[9] ,
    \experiarSoC/videoSRAM3_dout0[8] ,
    \experiarSoC/videoSRAM3_dout0[7] ,
    \experiarSoC/videoSRAM3_dout0[6] ,
    \experiarSoC/videoSRAM3_dout0[5] ,
    \experiarSoC/videoSRAM3_dout0[4] ,
    \experiarSoC/videoSRAM3_dout0[3] ,
    \experiarSoC/videoSRAM3_dout0[2] ,
    \experiarSoC/videoSRAM3_dout0[1] ,
    \experiarSoC/videoSRAM3_dout0[0] ,
    \experiarSoC/videoSRAM2_dout0[31] ,
    \experiarSoC/videoSRAM2_dout0[30] ,
    \experiarSoC/videoSRAM2_dout0[29] ,
    \experiarSoC/videoSRAM2_dout0[28] ,
    \experiarSoC/videoSRAM2_dout0[27] ,
    \experiarSoC/videoSRAM2_dout0[26] ,
    \experiarSoC/videoSRAM2_dout0[25] ,
    \experiarSoC/videoSRAM2_dout0[24] ,
    \experiarSoC/videoSRAM2_dout0[23] ,
    \experiarSoC/videoSRAM2_dout0[22] ,
    \experiarSoC/videoSRAM2_dout0[21] ,
    \experiarSoC/videoSRAM2_dout0[20] ,
    \experiarSoC/videoSRAM2_dout0[19] ,
    \experiarSoC/videoSRAM2_dout0[18] ,
    \experiarSoC/videoSRAM2_dout0[17] ,
    \experiarSoC/videoSRAM2_dout0[16] ,
    \experiarSoC/videoSRAM2_dout0[15] ,
    \experiarSoC/videoSRAM2_dout0[14] ,
    \experiarSoC/videoSRAM2_dout0[13] ,
    \experiarSoC/videoSRAM2_dout0[12] ,
    \experiarSoC/videoSRAM2_dout0[11] ,
    \experiarSoC/videoSRAM2_dout0[10] ,
    \experiarSoC/videoSRAM2_dout0[9] ,
    \experiarSoC/videoSRAM2_dout0[8] ,
    \experiarSoC/videoSRAM2_dout0[7] ,
    \experiarSoC/videoSRAM2_dout0[6] ,
    \experiarSoC/videoSRAM2_dout0[5] ,
    \experiarSoC/videoSRAM2_dout0[4] ,
    \experiarSoC/videoSRAM2_dout0[3] ,
    \experiarSoC/videoSRAM2_dout0[2] ,
    \experiarSoC/videoSRAM2_dout0[1] ,
    \experiarSoC/videoSRAM2_dout0[0] }),
    .sram1_dout1({\experiarSoC/videoSRAM3_dout1[31] ,
    \experiarSoC/videoSRAM3_dout1[30] ,
    \experiarSoC/videoSRAM3_dout1[29] ,
    \experiarSoC/videoSRAM3_dout1[28] ,
    \experiarSoC/videoSRAM3_dout1[27] ,
    \experiarSoC/videoSRAM3_dout1[26] ,
    \experiarSoC/videoSRAM3_dout1[25] ,
    \experiarSoC/videoSRAM3_dout1[24] ,
    \experiarSoC/videoSRAM3_dout1[23] ,
    \experiarSoC/videoSRAM3_dout1[22] ,
    \experiarSoC/videoSRAM3_dout1[21] ,
    \experiarSoC/videoSRAM3_dout1[20] ,
    \experiarSoC/videoSRAM3_dout1[19] ,
    \experiarSoC/videoSRAM3_dout1[18] ,
    \experiarSoC/videoSRAM3_dout1[17] ,
    \experiarSoC/videoSRAM3_dout1[16] ,
    \experiarSoC/videoSRAM3_dout1[15] ,
    \experiarSoC/videoSRAM3_dout1[14] ,
    \experiarSoC/videoSRAM3_dout1[13] ,
    \experiarSoC/videoSRAM3_dout1[12] ,
    \experiarSoC/videoSRAM3_dout1[11] ,
    \experiarSoC/videoSRAM3_dout1[10] ,
    \experiarSoC/videoSRAM3_dout1[9] ,
    \experiarSoC/videoSRAM3_dout1[8] ,
    \experiarSoC/videoSRAM3_dout1[7] ,
    \experiarSoC/videoSRAM3_dout1[6] ,
    \experiarSoC/videoSRAM3_dout1[5] ,
    \experiarSoC/videoSRAM3_dout1[4] ,
    \experiarSoC/videoSRAM3_dout1[3] ,
    \experiarSoC/videoSRAM3_dout1[2] ,
    \experiarSoC/videoSRAM3_dout1[1] ,
    \experiarSoC/videoSRAM3_dout1[0] ,
    \experiarSoC/videoSRAM2_dout1[31] ,
    \experiarSoC/videoSRAM2_dout1[30] ,
    \experiarSoC/videoSRAM2_dout1[29] ,
    \experiarSoC/videoSRAM2_dout1[28] ,
    \experiarSoC/videoSRAM2_dout1[27] ,
    \experiarSoC/videoSRAM2_dout1[26] ,
    \experiarSoC/videoSRAM2_dout1[25] ,
    \experiarSoC/videoSRAM2_dout1[24] ,
    \experiarSoC/videoSRAM2_dout1[23] ,
    \experiarSoC/videoSRAM2_dout1[22] ,
    \experiarSoC/videoSRAM2_dout1[21] ,
    \experiarSoC/videoSRAM2_dout1[20] ,
    \experiarSoC/videoSRAM2_dout1[19] ,
    \experiarSoC/videoSRAM2_dout1[18] ,
    \experiarSoC/videoSRAM2_dout1[17] ,
    \experiarSoC/videoSRAM2_dout1[16] ,
    \experiarSoC/videoSRAM2_dout1[15] ,
    \experiarSoC/videoSRAM2_dout1[14] ,
    \experiarSoC/videoSRAM2_dout1[13] ,
    \experiarSoC/videoSRAM2_dout1[12] ,
    \experiarSoC/videoSRAM2_dout1[11] ,
    \experiarSoC/videoSRAM2_dout1[10] ,
    \experiarSoC/videoSRAM2_dout1[9] ,
    \experiarSoC/videoSRAM2_dout1[8] ,
    \experiarSoC/videoSRAM2_dout1[7] ,
    \experiarSoC/videoSRAM2_dout1[6] ,
    \experiarSoC/videoSRAM2_dout1[5] ,
    \experiarSoC/videoSRAM2_dout1[4] ,
    \experiarSoC/videoSRAM2_dout1[3] ,
    \experiarSoC/videoSRAM2_dout1[2] ,
    \experiarSoC/videoSRAM2_dout1[1] ,
    \experiarSoC/videoSRAM2_dout1[0] }),
    .sram1_wmask0({\experiarSoC/videoSRAMRight_wmask0[3] ,
    \experiarSoC/videoSRAMRight_wmask0[2] ,
    \experiarSoC/videoSRAMRight_wmask0[1] ,
    \experiarSoC/videoSRAMRight_wmask0[0] }),
    .vga_b({\experiarSoC/vga_b[1] ,
    \experiarSoC/vga_b[0] }),
    .vga_g({\experiarSoC/vga_g[1] ,
    \experiarSoC/vga_g[0] }),
    .vga_r({\experiarSoC/vga_r[1] ,
    \experiarSoC/vga_r[0] }),
    .wb_adr_i({\experiarSoC/videoMemory_wb_adr_i[23] ,
    \experiarSoC/videoMemory_wb_adr_i[22] ,
    \experiarSoC/videoMemory_wb_adr_i[21] ,
    \experiarSoC/videoMemory_wb_adr_i[20] ,
    \experiarSoC/videoMemory_wb_adr_i[19] ,
    \experiarSoC/videoMemory_wb_adr_i[18] ,
    \experiarSoC/videoMemory_wb_adr_i[17] ,
    \experiarSoC/videoMemory_wb_adr_i[16] ,
    \experiarSoC/videoMemory_wb_adr_i[15] ,
    \experiarSoC/videoMemory_wb_adr_i[14] ,
    \experiarSoC/videoMemory_wb_adr_i[13] ,
    \experiarSoC/videoMemory_wb_adr_i[12] ,
    \experiarSoC/videoMemory_wb_adr_i[11] ,
    \experiarSoC/videoMemory_wb_adr_i[10] ,
    \experiarSoC/videoMemory_wb_adr_i[9] ,
    \experiarSoC/videoMemory_wb_adr_i[8] ,
    \experiarSoC/videoMemory_wb_adr_i[7] ,
    \experiarSoC/videoMemory_wb_adr_i[6] ,
    \experiarSoC/videoMemory_wb_adr_i[5] ,
    \experiarSoC/videoMemory_wb_adr_i[4] ,
    \experiarSoC/videoMemory_wb_adr_i[3] ,
    \experiarSoC/videoMemory_wb_adr_i[2] ,
    \experiarSoC/videoMemory_wb_adr_i[1] ,
    \experiarSoC/videoMemory_wb_adr_i[0] }),
    .wb_data_i({\experiarSoC/videoMemory_wb_data_i[31] ,
    \experiarSoC/videoMemory_wb_data_i[30] ,
    \experiarSoC/videoMemory_wb_data_i[29] ,
    \experiarSoC/videoMemory_wb_data_i[28] ,
    \experiarSoC/videoMemory_wb_data_i[27] ,
    \experiarSoC/videoMemory_wb_data_i[26] ,
    \experiarSoC/videoMemory_wb_data_i[25] ,
    \experiarSoC/videoMemory_wb_data_i[24] ,
    \experiarSoC/videoMemory_wb_data_i[23] ,
    \experiarSoC/videoMemory_wb_data_i[22] ,
    \experiarSoC/videoMemory_wb_data_i[21] ,
    \experiarSoC/videoMemory_wb_data_i[20] ,
    \experiarSoC/videoMemory_wb_data_i[19] ,
    \experiarSoC/videoMemory_wb_data_i[18] ,
    \experiarSoC/videoMemory_wb_data_i[17] ,
    \experiarSoC/videoMemory_wb_data_i[16] ,
    \experiarSoC/videoMemory_wb_data_i[15] ,
    \experiarSoC/videoMemory_wb_data_i[14] ,
    \experiarSoC/videoMemory_wb_data_i[13] ,
    \experiarSoC/videoMemory_wb_data_i[12] ,
    \experiarSoC/videoMemory_wb_data_i[11] ,
    \experiarSoC/videoMemory_wb_data_i[10] ,
    \experiarSoC/videoMemory_wb_data_i[9] ,
    \experiarSoC/videoMemory_wb_data_i[8] ,
    \experiarSoC/videoMemory_wb_data_i[7] ,
    \experiarSoC/videoMemory_wb_data_i[6] ,
    \experiarSoC/videoMemory_wb_data_i[5] ,
    \experiarSoC/videoMemory_wb_data_i[4] ,
    \experiarSoC/videoMemory_wb_data_i[3] ,
    \experiarSoC/videoMemory_wb_data_i[2] ,
    \experiarSoC/videoMemory_wb_data_i[1] ,
    \experiarSoC/videoMemory_wb_data_i[0] }),
    .wb_data_o({\experiarSoC/videoMemory_wb_data_o[31] ,
    \experiarSoC/videoMemory_wb_data_o[30] ,
    \experiarSoC/videoMemory_wb_data_o[29] ,
    \experiarSoC/videoMemory_wb_data_o[28] ,
    \experiarSoC/videoMemory_wb_data_o[27] ,
    \experiarSoC/videoMemory_wb_data_o[26] ,
    \experiarSoC/videoMemory_wb_data_o[25] ,
    \experiarSoC/videoMemory_wb_data_o[24] ,
    \experiarSoC/videoMemory_wb_data_o[23] ,
    \experiarSoC/videoMemory_wb_data_o[22] ,
    \experiarSoC/videoMemory_wb_data_o[21] ,
    \experiarSoC/videoMemory_wb_data_o[20] ,
    \experiarSoC/videoMemory_wb_data_o[19] ,
    \experiarSoC/videoMemory_wb_data_o[18] ,
    \experiarSoC/videoMemory_wb_data_o[17] ,
    \experiarSoC/videoMemory_wb_data_o[16] ,
    \experiarSoC/videoMemory_wb_data_o[15] ,
    \experiarSoC/videoMemory_wb_data_o[14] ,
    \experiarSoC/videoMemory_wb_data_o[13] ,
    \experiarSoC/videoMemory_wb_data_o[12] ,
    \experiarSoC/videoMemory_wb_data_o[11] ,
    \experiarSoC/videoMemory_wb_data_o[10] ,
    \experiarSoC/videoMemory_wb_data_o[9] ,
    \experiarSoC/videoMemory_wb_data_o[8] ,
    \experiarSoC/videoMemory_wb_data_o[7] ,
    \experiarSoC/videoMemory_wb_data_o[6] ,
    \experiarSoC/videoMemory_wb_data_o[5] ,
    \experiarSoC/videoMemory_wb_data_o[4] ,
    \experiarSoC/videoMemory_wb_data_o[3] ,
    \experiarSoC/videoMemory_wb_data_o[2] ,
    \experiarSoC/videoMemory_wb_data_o[1] ,
    \experiarSoC/videoMemory_wb_data_o[0] }),
    .wb_sel_i({\experiarSoC/videoMemory_wb_sel_i[3] ,
    \experiarSoC/videoMemory_wb_sel_i[2] ,
    \experiarSoC/videoMemory_wb_sel_i[1] ,
    \experiarSoC/videoMemory_wb_sel_i[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/videoSRAM0  (.csb0(\experiarSoC/videoSRAMLeft_csb0[0] ),
    .csb1(\experiarSoC/videoSRAMLeft_csb1[0] ),
    .web0(\experiarSoC/videoSRAMLeft_web0 ),
    .clk0(\experiarSoC/videoSRAMLeft_clk0 ),
    .clk1(\experiarSoC/videoSRAMLeft_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/videoSRAMLeft_addr0[8] ,
    \experiarSoC/videoSRAMLeft_addr0[7] ,
    \experiarSoC/videoSRAMLeft_addr0[6] ,
    \experiarSoC/videoSRAMLeft_addr0[5] ,
    \experiarSoC/videoSRAMLeft_addr0[4] ,
    \experiarSoC/videoSRAMLeft_addr0[3] ,
    \experiarSoC/videoSRAMLeft_addr0[2] ,
    \experiarSoC/videoSRAMLeft_addr0[1] ,
    \experiarSoC/videoSRAMLeft_addr0[0] }),
    .addr1({\experiarSoC/videoSRAMLeft_addr1[8] ,
    \experiarSoC/videoSRAMLeft_addr1[7] ,
    \experiarSoC/videoSRAMLeft_addr1[6] ,
    \experiarSoC/videoSRAMLeft_addr1[5] ,
    \experiarSoC/videoSRAMLeft_addr1[4] ,
    \experiarSoC/videoSRAMLeft_addr1[3] ,
    \experiarSoC/videoSRAMLeft_addr1[2] ,
    \experiarSoC/videoSRAMLeft_addr1[1] ,
    \experiarSoC/videoSRAMLeft_addr1[0] }),
    .din0({\experiarSoC/videoSRAMLeft_din0[31] ,
    \experiarSoC/videoSRAMLeft_din0[30] ,
    \experiarSoC/videoSRAMLeft_din0[29] ,
    \experiarSoC/videoSRAMLeft_din0[28] ,
    \experiarSoC/videoSRAMLeft_din0[27] ,
    \experiarSoC/videoSRAMLeft_din0[26] ,
    \experiarSoC/videoSRAMLeft_din0[25] ,
    \experiarSoC/videoSRAMLeft_din0[24] ,
    \experiarSoC/videoSRAMLeft_din0[23] ,
    \experiarSoC/videoSRAMLeft_din0[22] ,
    \experiarSoC/videoSRAMLeft_din0[21] ,
    \experiarSoC/videoSRAMLeft_din0[20] ,
    \experiarSoC/videoSRAMLeft_din0[19] ,
    \experiarSoC/videoSRAMLeft_din0[18] ,
    \experiarSoC/videoSRAMLeft_din0[17] ,
    \experiarSoC/videoSRAMLeft_din0[16] ,
    \experiarSoC/videoSRAMLeft_din0[15] ,
    \experiarSoC/videoSRAMLeft_din0[14] ,
    \experiarSoC/videoSRAMLeft_din0[13] ,
    \experiarSoC/videoSRAMLeft_din0[12] ,
    \experiarSoC/videoSRAMLeft_din0[11] ,
    \experiarSoC/videoSRAMLeft_din0[10] ,
    \experiarSoC/videoSRAMLeft_din0[9] ,
    \experiarSoC/videoSRAMLeft_din0[8] ,
    \experiarSoC/videoSRAMLeft_din0[7] ,
    \experiarSoC/videoSRAMLeft_din0[6] ,
    \experiarSoC/videoSRAMLeft_din0[5] ,
    \experiarSoC/videoSRAMLeft_din0[4] ,
    \experiarSoC/videoSRAMLeft_din0[3] ,
    \experiarSoC/videoSRAMLeft_din0[2] ,
    \experiarSoC/videoSRAMLeft_din0[1] ,
    \experiarSoC/videoSRAMLeft_din0[0] }),
    .dout0({\experiarSoC/videoSRAM0_dout0[31] ,
    \experiarSoC/videoSRAM0_dout0[30] ,
    \experiarSoC/videoSRAM0_dout0[29] ,
    \experiarSoC/videoSRAM0_dout0[28] ,
    \experiarSoC/videoSRAM0_dout0[27] ,
    \experiarSoC/videoSRAM0_dout0[26] ,
    \experiarSoC/videoSRAM0_dout0[25] ,
    \experiarSoC/videoSRAM0_dout0[24] ,
    \experiarSoC/videoSRAM0_dout0[23] ,
    \experiarSoC/videoSRAM0_dout0[22] ,
    \experiarSoC/videoSRAM0_dout0[21] ,
    \experiarSoC/videoSRAM0_dout0[20] ,
    \experiarSoC/videoSRAM0_dout0[19] ,
    \experiarSoC/videoSRAM0_dout0[18] ,
    \experiarSoC/videoSRAM0_dout0[17] ,
    \experiarSoC/videoSRAM0_dout0[16] ,
    \experiarSoC/videoSRAM0_dout0[15] ,
    \experiarSoC/videoSRAM0_dout0[14] ,
    \experiarSoC/videoSRAM0_dout0[13] ,
    \experiarSoC/videoSRAM0_dout0[12] ,
    \experiarSoC/videoSRAM0_dout0[11] ,
    \experiarSoC/videoSRAM0_dout0[10] ,
    \experiarSoC/videoSRAM0_dout0[9] ,
    \experiarSoC/videoSRAM0_dout0[8] ,
    \experiarSoC/videoSRAM0_dout0[7] ,
    \experiarSoC/videoSRAM0_dout0[6] ,
    \experiarSoC/videoSRAM0_dout0[5] ,
    \experiarSoC/videoSRAM0_dout0[4] ,
    \experiarSoC/videoSRAM0_dout0[3] ,
    \experiarSoC/videoSRAM0_dout0[2] ,
    \experiarSoC/videoSRAM0_dout0[1] ,
    \experiarSoC/videoSRAM0_dout0[0] }),
    .dout1({\experiarSoC/videoSRAM0_dout1[31] ,
    \experiarSoC/videoSRAM0_dout1[30] ,
    \experiarSoC/videoSRAM0_dout1[29] ,
    \experiarSoC/videoSRAM0_dout1[28] ,
    \experiarSoC/videoSRAM0_dout1[27] ,
    \experiarSoC/videoSRAM0_dout1[26] ,
    \experiarSoC/videoSRAM0_dout1[25] ,
    \experiarSoC/videoSRAM0_dout1[24] ,
    \experiarSoC/videoSRAM0_dout1[23] ,
    \experiarSoC/videoSRAM0_dout1[22] ,
    \experiarSoC/videoSRAM0_dout1[21] ,
    \experiarSoC/videoSRAM0_dout1[20] ,
    \experiarSoC/videoSRAM0_dout1[19] ,
    \experiarSoC/videoSRAM0_dout1[18] ,
    \experiarSoC/videoSRAM0_dout1[17] ,
    \experiarSoC/videoSRAM0_dout1[16] ,
    \experiarSoC/videoSRAM0_dout1[15] ,
    \experiarSoC/videoSRAM0_dout1[14] ,
    \experiarSoC/videoSRAM0_dout1[13] ,
    \experiarSoC/videoSRAM0_dout1[12] ,
    \experiarSoC/videoSRAM0_dout1[11] ,
    \experiarSoC/videoSRAM0_dout1[10] ,
    \experiarSoC/videoSRAM0_dout1[9] ,
    \experiarSoC/videoSRAM0_dout1[8] ,
    \experiarSoC/videoSRAM0_dout1[7] ,
    \experiarSoC/videoSRAM0_dout1[6] ,
    \experiarSoC/videoSRAM0_dout1[5] ,
    \experiarSoC/videoSRAM0_dout1[4] ,
    \experiarSoC/videoSRAM0_dout1[3] ,
    \experiarSoC/videoSRAM0_dout1[2] ,
    \experiarSoC/videoSRAM0_dout1[1] ,
    \experiarSoC/videoSRAM0_dout1[0] }),
    .wmask0({\experiarSoC/videoSRAMLeft_wmask0[3] ,
    \experiarSoC/videoSRAMLeft_wmask0[2] ,
    \experiarSoC/videoSRAMLeft_wmask0[1] ,
    \experiarSoC/videoSRAMLeft_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/videoSRAM1  (.csb0(\experiarSoC/videoSRAMLeft_csb0[1] ),
    .csb1(\experiarSoC/videoSRAMLeft_csb1[1] ),
    .web0(\experiarSoC/videoSRAMLeft_web0 ),
    .clk0(\experiarSoC/videoSRAMLeft_clk0 ),
    .clk1(\experiarSoC/videoSRAMLeft_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/videoSRAMLeft_addr0[8] ,
    \experiarSoC/videoSRAMLeft_addr0[7] ,
    \experiarSoC/videoSRAMLeft_addr0[6] ,
    \experiarSoC/videoSRAMLeft_addr0[5] ,
    \experiarSoC/videoSRAMLeft_addr0[4] ,
    \experiarSoC/videoSRAMLeft_addr0[3] ,
    \experiarSoC/videoSRAMLeft_addr0[2] ,
    \experiarSoC/videoSRAMLeft_addr0[1] ,
    \experiarSoC/videoSRAMLeft_addr0[0] }),
    .addr1({\experiarSoC/videoSRAMLeft_addr1[8] ,
    \experiarSoC/videoSRAMLeft_addr1[7] ,
    \experiarSoC/videoSRAMLeft_addr1[6] ,
    \experiarSoC/videoSRAMLeft_addr1[5] ,
    \experiarSoC/videoSRAMLeft_addr1[4] ,
    \experiarSoC/videoSRAMLeft_addr1[3] ,
    \experiarSoC/videoSRAMLeft_addr1[2] ,
    \experiarSoC/videoSRAMLeft_addr1[1] ,
    \experiarSoC/videoSRAMLeft_addr1[0] }),
    .din0({\experiarSoC/videoSRAMLeft_din0[31] ,
    \experiarSoC/videoSRAMLeft_din0[30] ,
    \experiarSoC/videoSRAMLeft_din0[29] ,
    \experiarSoC/videoSRAMLeft_din0[28] ,
    \experiarSoC/videoSRAMLeft_din0[27] ,
    \experiarSoC/videoSRAMLeft_din0[26] ,
    \experiarSoC/videoSRAMLeft_din0[25] ,
    \experiarSoC/videoSRAMLeft_din0[24] ,
    \experiarSoC/videoSRAMLeft_din0[23] ,
    \experiarSoC/videoSRAMLeft_din0[22] ,
    \experiarSoC/videoSRAMLeft_din0[21] ,
    \experiarSoC/videoSRAMLeft_din0[20] ,
    \experiarSoC/videoSRAMLeft_din0[19] ,
    \experiarSoC/videoSRAMLeft_din0[18] ,
    \experiarSoC/videoSRAMLeft_din0[17] ,
    \experiarSoC/videoSRAMLeft_din0[16] ,
    \experiarSoC/videoSRAMLeft_din0[15] ,
    \experiarSoC/videoSRAMLeft_din0[14] ,
    \experiarSoC/videoSRAMLeft_din0[13] ,
    \experiarSoC/videoSRAMLeft_din0[12] ,
    \experiarSoC/videoSRAMLeft_din0[11] ,
    \experiarSoC/videoSRAMLeft_din0[10] ,
    \experiarSoC/videoSRAMLeft_din0[9] ,
    \experiarSoC/videoSRAMLeft_din0[8] ,
    \experiarSoC/videoSRAMLeft_din0[7] ,
    \experiarSoC/videoSRAMLeft_din0[6] ,
    \experiarSoC/videoSRAMLeft_din0[5] ,
    \experiarSoC/videoSRAMLeft_din0[4] ,
    \experiarSoC/videoSRAMLeft_din0[3] ,
    \experiarSoC/videoSRAMLeft_din0[2] ,
    \experiarSoC/videoSRAMLeft_din0[1] ,
    \experiarSoC/videoSRAMLeft_din0[0] }),
    .dout0({\experiarSoC/videoSRAM1_dout0[31] ,
    \experiarSoC/videoSRAM1_dout0[30] ,
    \experiarSoC/videoSRAM1_dout0[29] ,
    \experiarSoC/videoSRAM1_dout0[28] ,
    \experiarSoC/videoSRAM1_dout0[27] ,
    \experiarSoC/videoSRAM1_dout0[26] ,
    \experiarSoC/videoSRAM1_dout0[25] ,
    \experiarSoC/videoSRAM1_dout0[24] ,
    \experiarSoC/videoSRAM1_dout0[23] ,
    \experiarSoC/videoSRAM1_dout0[22] ,
    \experiarSoC/videoSRAM1_dout0[21] ,
    \experiarSoC/videoSRAM1_dout0[20] ,
    \experiarSoC/videoSRAM1_dout0[19] ,
    \experiarSoC/videoSRAM1_dout0[18] ,
    \experiarSoC/videoSRAM1_dout0[17] ,
    \experiarSoC/videoSRAM1_dout0[16] ,
    \experiarSoC/videoSRAM1_dout0[15] ,
    \experiarSoC/videoSRAM1_dout0[14] ,
    \experiarSoC/videoSRAM1_dout0[13] ,
    \experiarSoC/videoSRAM1_dout0[12] ,
    \experiarSoC/videoSRAM1_dout0[11] ,
    \experiarSoC/videoSRAM1_dout0[10] ,
    \experiarSoC/videoSRAM1_dout0[9] ,
    \experiarSoC/videoSRAM1_dout0[8] ,
    \experiarSoC/videoSRAM1_dout0[7] ,
    \experiarSoC/videoSRAM1_dout0[6] ,
    \experiarSoC/videoSRAM1_dout0[5] ,
    \experiarSoC/videoSRAM1_dout0[4] ,
    \experiarSoC/videoSRAM1_dout0[3] ,
    \experiarSoC/videoSRAM1_dout0[2] ,
    \experiarSoC/videoSRAM1_dout0[1] ,
    \experiarSoC/videoSRAM1_dout0[0] }),
    .dout1({\experiarSoC/videoSRAM1_dout1[31] ,
    \experiarSoC/videoSRAM1_dout1[30] ,
    \experiarSoC/videoSRAM1_dout1[29] ,
    \experiarSoC/videoSRAM1_dout1[28] ,
    \experiarSoC/videoSRAM1_dout1[27] ,
    \experiarSoC/videoSRAM1_dout1[26] ,
    \experiarSoC/videoSRAM1_dout1[25] ,
    \experiarSoC/videoSRAM1_dout1[24] ,
    \experiarSoC/videoSRAM1_dout1[23] ,
    \experiarSoC/videoSRAM1_dout1[22] ,
    \experiarSoC/videoSRAM1_dout1[21] ,
    \experiarSoC/videoSRAM1_dout1[20] ,
    \experiarSoC/videoSRAM1_dout1[19] ,
    \experiarSoC/videoSRAM1_dout1[18] ,
    \experiarSoC/videoSRAM1_dout1[17] ,
    \experiarSoC/videoSRAM1_dout1[16] ,
    \experiarSoC/videoSRAM1_dout1[15] ,
    \experiarSoC/videoSRAM1_dout1[14] ,
    \experiarSoC/videoSRAM1_dout1[13] ,
    \experiarSoC/videoSRAM1_dout1[12] ,
    \experiarSoC/videoSRAM1_dout1[11] ,
    \experiarSoC/videoSRAM1_dout1[10] ,
    \experiarSoC/videoSRAM1_dout1[9] ,
    \experiarSoC/videoSRAM1_dout1[8] ,
    \experiarSoC/videoSRAM1_dout1[7] ,
    \experiarSoC/videoSRAM1_dout1[6] ,
    \experiarSoC/videoSRAM1_dout1[5] ,
    \experiarSoC/videoSRAM1_dout1[4] ,
    \experiarSoC/videoSRAM1_dout1[3] ,
    \experiarSoC/videoSRAM1_dout1[2] ,
    \experiarSoC/videoSRAM1_dout1[1] ,
    \experiarSoC/videoSRAM1_dout1[0] }),
    .wmask0({\experiarSoC/videoSRAMLeft_wmask0[3] ,
    \experiarSoC/videoSRAMLeft_wmask0[2] ,
    \experiarSoC/videoSRAMLeft_wmask0[1] ,
    \experiarSoC/videoSRAMLeft_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/videoSRAM2  (.csb0(\experiarSoC/videoSRAMRight_csb0[0] ),
    .csb1(\experiarSoC/videoSRAMRight_csb1[0] ),
    .web0(\experiarSoC/videoSRAMRight_web0 ),
    .clk0(\experiarSoC/videoSRAMRight_clk0 ),
    .clk1(\experiarSoC/videoSRAMRight_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/videoSRAMRight_addr0[8] ,
    \experiarSoC/videoSRAMRight_addr0[7] ,
    \experiarSoC/videoSRAMRight_addr0[6] ,
    \experiarSoC/videoSRAMRight_addr0[5] ,
    \experiarSoC/videoSRAMRight_addr0[4] ,
    \experiarSoC/videoSRAMRight_addr0[3] ,
    \experiarSoC/videoSRAMRight_addr0[2] ,
    \experiarSoC/videoSRAMRight_addr0[1] ,
    \experiarSoC/videoSRAMRight_addr0[0] }),
    .addr1({\experiarSoC/videoSRAMRight_addr1[8] ,
    \experiarSoC/videoSRAMRight_addr1[7] ,
    \experiarSoC/videoSRAMRight_addr1[6] ,
    \experiarSoC/videoSRAMRight_addr1[5] ,
    \experiarSoC/videoSRAMRight_addr1[4] ,
    \experiarSoC/videoSRAMRight_addr1[3] ,
    \experiarSoC/videoSRAMRight_addr1[2] ,
    \experiarSoC/videoSRAMRight_addr1[1] ,
    \experiarSoC/videoSRAMRight_addr1[0] }),
    .din0({\experiarSoC/videoSRAMRight_din0[31] ,
    \experiarSoC/videoSRAMRight_din0[30] ,
    \experiarSoC/videoSRAMRight_din0[29] ,
    \experiarSoC/videoSRAMRight_din0[28] ,
    \experiarSoC/videoSRAMRight_din0[27] ,
    \experiarSoC/videoSRAMRight_din0[26] ,
    \experiarSoC/videoSRAMRight_din0[25] ,
    \experiarSoC/videoSRAMRight_din0[24] ,
    \experiarSoC/videoSRAMRight_din0[23] ,
    \experiarSoC/videoSRAMRight_din0[22] ,
    \experiarSoC/videoSRAMRight_din0[21] ,
    \experiarSoC/videoSRAMRight_din0[20] ,
    \experiarSoC/videoSRAMRight_din0[19] ,
    \experiarSoC/videoSRAMRight_din0[18] ,
    \experiarSoC/videoSRAMRight_din0[17] ,
    \experiarSoC/videoSRAMRight_din0[16] ,
    \experiarSoC/videoSRAMRight_din0[15] ,
    \experiarSoC/videoSRAMRight_din0[14] ,
    \experiarSoC/videoSRAMRight_din0[13] ,
    \experiarSoC/videoSRAMRight_din0[12] ,
    \experiarSoC/videoSRAMRight_din0[11] ,
    \experiarSoC/videoSRAMRight_din0[10] ,
    \experiarSoC/videoSRAMRight_din0[9] ,
    \experiarSoC/videoSRAMRight_din0[8] ,
    \experiarSoC/videoSRAMRight_din0[7] ,
    \experiarSoC/videoSRAMRight_din0[6] ,
    \experiarSoC/videoSRAMRight_din0[5] ,
    \experiarSoC/videoSRAMRight_din0[4] ,
    \experiarSoC/videoSRAMRight_din0[3] ,
    \experiarSoC/videoSRAMRight_din0[2] ,
    \experiarSoC/videoSRAMRight_din0[1] ,
    \experiarSoC/videoSRAMRight_din0[0] }),
    .dout0({\experiarSoC/videoSRAM2_dout0[31] ,
    \experiarSoC/videoSRAM2_dout0[30] ,
    \experiarSoC/videoSRAM2_dout0[29] ,
    \experiarSoC/videoSRAM2_dout0[28] ,
    \experiarSoC/videoSRAM2_dout0[27] ,
    \experiarSoC/videoSRAM2_dout0[26] ,
    \experiarSoC/videoSRAM2_dout0[25] ,
    \experiarSoC/videoSRAM2_dout0[24] ,
    \experiarSoC/videoSRAM2_dout0[23] ,
    \experiarSoC/videoSRAM2_dout0[22] ,
    \experiarSoC/videoSRAM2_dout0[21] ,
    \experiarSoC/videoSRAM2_dout0[20] ,
    \experiarSoC/videoSRAM2_dout0[19] ,
    \experiarSoC/videoSRAM2_dout0[18] ,
    \experiarSoC/videoSRAM2_dout0[17] ,
    \experiarSoC/videoSRAM2_dout0[16] ,
    \experiarSoC/videoSRAM2_dout0[15] ,
    \experiarSoC/videoSRAM2_dout0[14] ,
    \experiarSoC/videoSRAM2_dout0[13] ,
    \experiarSoC/videoSRAM2_dout0[12] ,
    \experiarSoC/videoSRAM2_dout0[11] ,
    \experiarSoC/videoSRAM2_dout0[10] ,
    \experiarSoC/videoSRAM2_dout0[9] ,
    \experiarSoC/videoSRAM2_dout0[8] ,
    \experiarSoC/videoSRAM2_dout0[7] ,
    \experiarSoC/videoSRAM2_dout0[6] ,
    \experiarSoC/videoSRAM2_dout0[5] ,
    \experiarSoC/videoSRAM2_dout0[4] ,
    \experiarSoC/videoSRAM2_dout0[3] ,
    \experiarSoC/videoSRAM2_dout0[2] ,
    \experiarSoC/videoSRAM2_dout0[1] ,
    \experiarSoC/videoSRAM2_dout0[0] }),
    .dout1({\experiarSoC/videoSRAM2_dout1[31] ,
    \experiarSoC/videoSRAM2_dout1[30] ,
    \experiarSoC/videoSRAM2_dout1[29] ,
    \experiarSoC/videoSRAM2_dout1[28] ,
    \experiarSoC/videoSRAM2_dout1[27] ,
    \experiarSoC/videoSRAM2_dout1[26] ,
    \experiarSoC/videoSRAM2_dout1[25] ,
    \experiarSoC/videoSRAM2_dout1[24] ,
    \experiarSoC/videoSRAM2_dout1[23] ,
    \experiarSoC/videoSRAM2_dout1[22] ,
    \experiarSoC/videoSRAM2_dout1[21] ,
    \experiarSoC/videoSRAM2_dout1[20] ,
    \experiarSoC/videoSRAM2_dout1[19] ,
    \experiarSoC/videoSRAM2_dout1[18] ,
    \experiarSoC/videoSRAM2_dout1[17] ,
    \experiarSoC/videoSRAM2_dout1[16] ,
    \experiarSoC/videoSRAM2_dout1[15] ,
    \experiarSoC/videoSRAM2_dout1[14] ,
    \experiarSoC/videoSRAM2_dout1[13] ,
    \experiarSoC/videoSRAM2_dout1[12] ,
    \experiarSoC/videoSRAM2_dout1[11] ,
    \experiarSoC/videoSRAM2_dout1[10] ,
    \experiarSoC/videoSRAM2_dout1[9] ,
    \experiarSoC/videoSRAM2_dout1[8] ,
    \experiarSoC/videoSRAM2_dout1[7] ,
    \experiarSoC/videoSRAM2_dout1[6] ,
    \experiarSoC/videoSRAM2_dout1[5] ,
    \experiarSoC/videoSRAM2_dout1[4] ,
    \experiarSoC/videoSRAM2_dout1[3] ,
    \experiarSoC/videoSRAM2_dout1[2] ,
    \experiarSoC/videoSRAM2_dout1[1] ,
    \experiarSoC/videoSRAM2_dout1[0] }),
    .wmask0({\experiarSoC/videoSRAMRight_wmask0[3] ,
    \experiarSoC/videoSRAMRight_wmask0[2] ,
    \experiarSoC/videoSRAMRight_wmask0[1] ,
    \experiarSoC/videoSRAMRight_wmask0[0] }));
 sky130_sram_2kbyte_1rw1r_32x512_8 \experiarSoC/videoSRAM3  (.csb0(\experiarSoC/videoSRAMRight_csb0[1] ),
    .csb1(\experiarSoC/videoSRAMRight_csb1[1] ),
    .web0(\experiarSoC/videoSRAMRight_web0 ),
    .clk0(\experiarSoC/videoSRAMRight_clk0 ),
    .clk1(\experiarSoC/videoSRAMRight_clk1 ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .addr0({\experiarSoC/videoSRAMRight_addr0[8] ,
    \experiarSoC/videoSRAMRight_addr0[7] ,
    \experiarSoC/videoSRAMRight_addr0[6] ,
    \experiarSoC/videoSRAMRight_addr0[5] ,
    \experiarSoC/videoSRAMRight_addr0[4] ,
    \experiarSoC/videoSRAMRight_addr0[3] ,
    \experiarSoC/videoSRAMRight_addr0[2] ,
    \experiarSoC/videoSRAMRight_addr0[1] ,
    \experiarSoC/videoSRAMRight_addr0[0] }),
    .addr1({\experiarSoC/videoSRAMRight_addr1[8] ,
    \experiarSoC/videoSRAMRight_addr1[7] ,
    \experiarSoC/videoSRAMRight_addr1[6] ,
    \experiarSoC/videoSRAMRight_addr1[5] ,
    \experiarSoC/videoSRAMRight_addr1[4] ,
    \experiarSoC/videoSRAMRight_addr1[3] ,
    \experiarSoC/videoSRAMRight_addr1[2] ,
    \experiarSoC/videoSRAMRight_addr1[1] ,
    \experiarSoC/videoSRAMRight_addr1[0] }),
    .din0({\experiarSoC/videoSRAMRight_din0[31] ,
    \experiarSoC/videoSRAMRight_din0[30] ,
    \experiarSoC/videoSRAMRight_din0[29] ,
    \experiarSoC/videoSRAMRight_din0[28] ,
    \experiarSoC/videoSRAMRight_din0[27] ,
    \experiarSoC/videoSRAMRight_din0[26] ,
    \experiarSoC/videoSRAMRight_din0[25] ,
    \experiarSoC/videoSRAMRight_din0[24] ,
    \experiarSoC/videoSRAMRight_din0[23] ,
    \experiarSoC/videoSRAMRight_din0[22] ,
    \experiarSoC/videoSRAMRight_din0[21] ,
    \experiarSoC/videoSRAMRight_din0[20] ,
    \experiarSoC/videoSRAMRight_din0[19] ,
    \experiarSoC/videoSRAMRight_din0[18] ,
    \experiarSoC/videoSRAMRight_din0[17] ,
    \experiarSoC/videoSRAMRight_din0[16] ,
    \experiarSoC/videoSRAMRight_din0[15] ,
    \experiarSoC/videoSRAMRight_din0[14] ,
    \experiarSoC/videoSRAMRight_din0[13] ,
    \experiarSoC/videoSRAMRight_din0[12] ,
    \experiarSoC/videoSRAMRight_din0[11] ,
    \experiarSoC/videoSRAMRight_din0[10] ,
    \experiarSoC/videoSRAMRight_din0[9] ,
    \experiarSoC/videoSRAMRight_din0[8] ,
    \experiarSoC/videoSRAMRight_din0[7] ,
    \experiarSoC/videoSRAMRight_din0[6] ,
    \experiarSoC/videoSRAMRight_din0[5] ,
    \experiarSoC/videoSRAMRight_din0[4] ,
    \experiarSoC/videoSRAMRight_din0[3] ,
    \experiarSoC/videoSRAMRight_din0[2] ,
    \experiarSoC/videoSRAMRight_din0[1] ,
    \experiarSoC/videoSRAMRight_din0[0] }),
    .dout0({\experiarSoC/videoSRAM3_dout0[31] ,
    \experiarSoC/videoSRAM3_dout0[30] ,
    \experiarSoC/videoSRAM3_dout0[29] ,
    \experiarSoC/videoSRAM3_dout0[28] ,
    \experiarSoC/videoSRAM3_dout0[27] ,
    \experiarSoC/videoSRAM3_dout0[26] ,
    \experiarSoC/videoSRAM3_dout0[25] ,
    \experiarSoC/videoSRAM3_dout0[24] ,
    \experiarSoC/videoSRAM3_dout0[23] ,
    \experiarSoC/videoSRAM3_dout0[22] ,
    \experiarSoC/videoSRAM3_dout0[21] ,
    \experiarSoC/videoSRAM3_dout0[20] ,
    \experiarSoC/videoSRAM3_dout0[19] ,
    \experiarSoC/videoSRAM3_dout0[18] ,
    \experiarSoC/videoSRAM3_dout0[17] ,
    \experiarSoC/videoSRAM3_dout0[16] ,
    \experiarSoC/videoSRAM3_dout0[15] ,
    \experiarSoC/videoSRAM3_dout0[14] ,
    \experiarSoC/videoSRAM3_dout0[13] ,
    \experiarSoC/videoSRAM3_dout0[12] ,
    \experiarSoC/videoSRAM3_dout0[11] ,
    \experiarSoC/videoSRAM3_dout0[10] ,
    \experiarSoC/videoSRAM3_dout0[9] ,
    \experiarSoC/videoSRAM3_dout0[8] ,
    \experiarSoC/videoSRAM3_dout0[7] ,
    \experiarSoC/videoSRAM3_dout0[6] ,
    \experiarSoC/videoSRAM3_dout0[5] ,
    \experiarSoC/videoSRAM3_dout0[4] ,
    \experiarSoC/videoSRAM3_dout0[3] ,
    \experiarSoC/videoSRAM3_dout0[2] ,
    \experiarSoC/videoSRAM3_dout0[1] ,
    \experiarSoC/videoSRAM3_dout0[0] }),
    .dout1({\experiarSoC/videoSRAM3_dout1[31] ,
    \experiarSoC/videoSRAM3_dout1[30] ,
    \experiarSoC/videoSRAM3_dout1[29] ,
    \experiarSoC/videoSRAM3_dout1[28] ,
    \experiarSoC/videoSRAM3_dout1[27] ,
    \experiarSoC/videoSRAM3_dout1[26] ,
    \experiarSoC/videoSRAM3_dout1[25] ,
    \experiarSoC/videoSRAM3_dout1[24] ,
    \experiarSoC/videoSRAM3_dout1[23] ,
    \experiarSoC/videoSRAM3_dout1[22] ,
    \experiarSoC/videoSRAM3_dout1[21] ,
    \experiarSoC/videoSRAM3_dout1[20] ,
    \experiarSoC/videoSRAM3_dout1[19] ,
    \experiarSoC/videoSRAM3_dout1[18] ,
    \experiarSoC/videoSRAM3_dout1[17] ,
    \experiarSoC/videoSRAM3_dout1[16] ,
    \experiarSoC/videoSRAM3_dout1[15] ,
    \experiarSoC/videoSRAM3_dout1[14] ,
    \experiarSoC/videoSRAM3_dout1[13] ,
    \experiarSoC/videoSRAM3_dout1[12] ,
    \experiarSoC/videoSRAM3_dout1[11] ,
    \experiarSoC/videoSRAM3_dout1[10] ,
    \experiarSoC/videoSRAM3_dout1[9] ,
    \experiarSoC/videoSRAM3_dout1[8] ,
    \experiarSoC/videoSRAM3_dout1[7] ,
    \experiarSoC/videoSRAM3_dout1[6] ,
    \experiarSoC/videoSRAM3_dout1[5] ,
    \experiarSoC/videoSRAM3_dout1[4] ,
    \experiarSoC/videoSRAM3_dout1[3] ,
    \experiarSoC/videoSRAM3_dout1[2] ,
    \experiarSoC/videoSRAM3_dout1[1] ,
    \experiarSoC/videoSRAM3_dout1[0] }),
    .wmask0({\experiarSoC/videoSRAMRight_wmask0[3] ,
    \experiarSoC/videoSRAMRight_wmask0[2] ,
    \experiarSoC/videoSRAMRight_wmask0[1] ,
    \experiarSoC/videoSRAMRight_wmask0[0] }));
 WishboneInterconnect \experiarSoC/wishboneInterconnect  (.master0_wb_ack_i(caravel_wb_ack_i),
    .master0_wb_cyc_o(caravel_wb_cyc_o),
    .master0_wb_error_i(caravel_wb_error_i),
    .master0_wb_stall_i(caravel_wb_stall_i),
    .master0_wb_stb_o(caravel_wb_stb_o),
    .master0_wb_we_o(caravel_wb_we_o),
    .master1_wb_ack_i(\experiarSoC/core0_wb_ack_i ),
    .master1_wb_cyc_o(\experiarSoC/core0_wb_cyc_o ),
    .master1_wb_error_i(\experiarSoC/core0_wb_error_i ),
    .master1_wb_stall_i(\experiarSoC/core0_wb_stall_i ),
    .master1_wb_stb_o(\experiarSoC/core0_wb_stb_o ),
    .master1_wb_we_o(\experiarSoC/core0_wb_we_o ),
    .master2_wb_ack_i(\experiarSoC/core1_wb_ack_i ),
    .master2_wb_cyc_o(\experiarSoC/core1_wb_cyc_o ),
    .master2_wb_error_i(\experiarSoC/core1_wb_error_i ),
    .master2_wb_stall_i(\experiarSoC/core1_wb_stall_i ),
    .master2_wb_stb_o(\experiarSoC/core1_wb_stb_o ),
    .master2_wb_we_o(\experiarSoC/core1_wb_we_o ),
    .slave0_wb_ack_o(\experiarSoC/core0Memory_wb_ack_o ),
    .slave0_wb_cyc_i(\experiarSoC/core0Memory_wb_cyc_i ),
    .slave0_wb_error_o(\experiarSoC/core0Memory_wb_error_o ),
    .slave0_wb_stall_o(\experiarSoC/core0Memory_wb_stall_o ),
    .slave0_wb_stb_i(\experiarSoC/core0Memory_wb_stb_i ),
    .slave0_wb_we_i(\experiarSoC/core0Memory_wb_we_i ),
    .slave1_wb_ack_o(\experiarSoC/core1Memory_wb_ack_o ),
    .slave1_wb_cyc_i(\experiarSoC/core1Memory_wb_cyc_i ),
    .slave1_wb_error_o(\experiarSoC/core1Memory_wb_error_o ),
    .slave1_wb_stall_o(\experiarSoC/core1Memory_wb_stall_o ),
    .slave1_wb_stb_i(\experiarSoC/core1Memory_wb_stb_i ),
    .slave1_wb_we_i(\experiarSoC/core1Memory_wb_we_i ),
    .slave2_wb_ack_o(\experiarSoC/videoMemory_wb_ack_o ),
    .slave2_wb_cyc_i(\experiarSoC/videoMemory_wb_cyc_i ),
    .slave2_wb_error_o(\experiarSoC/videoMemory_wb_error_o ),
    .slave2_wb_stall_o(\experiarSoC/videoMemory_wb_stall_o ),
    .slave2_wb_stb_i(\experiarSoC/videoMemory_wb_stb_i ),
    .slave2_wb_we_i(\experiarSoC/videoMemory_wb_we_i ),
    .slave3_wb_ack_o(\experiarSoC/peripherals_wb_ack_o ),
    .slave3_wb_cyc_i(\experiarSoC/peripherals_wb_cyc_i ),
    .slave3_wb_error_o(\experiarSoC/peripherals_wb_error_o ),
    .slave3_wb_stall_o(\experiarSoC/peripherals_wb_stall_o ),
    .slave3_wb_stb_i(\experiarSoC/peripherals_wb_stb_i ),
    .slave3_wb_we_i(\experiarSoC/peripherals_wb_we_i ),
    .slave4_wb_ack_o(\experiarSoC/flash_wb_ack_o ),
    .slave4_wb_cyc_i(\experiarSoC/flash_wb_cyc_i ),
    .slave4_wb_error_o(\experiarSoC/flash_wb_error_o ),
    .slave4_wb_stall_o(\experiarSoC/flash_wb_stall_o ),
    .slave4_wb_stb_i(\experiarSoC/flash_wb_stb_i ),
    .slave4_wb_we_i(\experiarSoC/flash_wb_we_i ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .master0_wb_adr_o({\caravel_wb_adr_o[27] ,
    \caravel_wb_adr_o[26] ,
    \caravel_wb_adr_o[25] ,
    \caravel_wb_adr_o[24] ,
    \caravel_wb_adr_o[23] ,
    \caravel_wb_adr_o[22] ,
    \caravel_wb_adr_o[21] ,
    \caravel_wb_adr_o[20] ,
    \caravel_wb_adr_o[19] ,
    \caravel_wb_adr_o[18] ,
    \caravel_wb_adr_o[17] ,
    \caravel_wb_adr_o[16] ,
    \caravel_wb_adr_o[15] ,
    \caravel_wb_adr_o[14] ,
    \caravel_wb_adr_o[13] ,
    \caravel_wb_adr_o[12] ,
    \caravel_wb_adr_o[11] ,
    \caravel_wb_adr_o[10] ,
    \caravel_wb_adr_o[9] ,
    \caravel_wb_adr_o[8] ,
    \caravel_wb_adr_o[7] ,
    \caravel_wb_adr_o[6] ,
    \caravel_wb_adr_o[5] ,
    \caravel_wb_adr_o[4] ,
    \caravel_wb_adr_o[3] ,
    \caravel_wb_adr_o[2] ,
    \caravel_wb_adr_o[1] ,
    \caravel_wb_adr_o[0] }),
    .master0_wb_data_i({\caravel_wb_data_i[31] ,
    \caravel_wb_data_i[30] ,
    \caravel_wb_data_i[29] ,
    \caravel_wb_data_i[28] ,
    \caravel_wb_data_i[27] ,
    \caravel_wb_data_i[26] ,
    \caravel_wb_data_i[25] ,
    \caravel_wb_data_i[24] ,
    \caravel_wb_data_i[23] ,
    \caravel_wb_data_i[22] ,
    \caravel_wb_data_i[21] ,
    \caravel_wb_data_i[20] ,
    \caravel_wb_data_i[19] ,
    \caravel_wb_data_i[18] ,
    \caravel_wb_data_i[17] ,
    \caravel_wb_data_i[16] ,
    \caravel_wb_data_i[15] ,
    \caravel_wb_data_i[14] ,
    \caravel_wb_data_i[13] ,
    \caravel_wb_data_i[12] ,
    \caravel_wb_data_i[11] ,
    \caravel_wb_data_i[10] ,
    \caravel_wb_data_i[9] ,
    \caravel_wb_data_i[8] ,
    \caravel_wb_data_i[7] ,
    \caravel_wb_data_i[6] ,
    \caravel_wb_data_i[5] ,
    \caravel_wb_data_i[4] ,
    \caravel_wb_data_i[3] ,
    \caravel_wb_data_i[2] ,
    \caravel_wb_data_i[1] ,
    \caravel_wb_data_i[0] }),
    .master0_wb_data_o({\caravel_wb_data_o[31] ,
    \caravel_wb_data_o[30] ,
    \caravel_wb_data_o[29] ,
    \caravel_wb_data_o[28] ,
    \caravel_wb_data_o[27] ,
    \caravel_wb_data_o[26] ,
    \caravel_wb_data_o[25] ,
    \caravel_wb_data_o[24] ,
    \caravel_wb_data_o[23] ,
    \caravel_wb_data_o[22] ,
    \caravel_wb_data_o[21] ,
    \caravel_wb_data_o[20] ,
    \caravel_wb_data_o[19] ,
    \caravel_wb_data_o[18] ,
    \caravel_wb_data_o[17] ,
    \caravel_wb_data_o[16] ,
    \caravel_wb_data_o[15] ,
    \caravel_wb_data_o[14] ,
    \caravel_wb_data_o[13] ,
    \caravel_wb_data_o[12] ,
    \caravel_wb_data_o[11] ,
    \caravel_wb_data_o[10] ,
    \caravel_wb_data_o[9] ,
    \caravel_wb_data_o[8] ,
    \caravel_wb_data_o[7] ,
    \caravel_wb_data_o[6] ,
    \caravel_wb_data_o[5] ,
    \caravel_wb_data_o[4] ,
    \caravel_wb_data_o[3] ,
    \caravel_wb_data_o[2] ,
    \caravel_wb_data_o[1] ,
    \caravel_wb_data_o[0] }),
    .master0_wb_sel_o({\caravel_wb_sel_o[3] ,
    \caravel_wb_sel_o[2] ,
    \caravel_wb_sel_o[1] ,
    \caravel_wb_sel_o[0] }),
    .master1_wb_adr_o({\experiarSoC/core0_wb_adr_o[27] ,
    \experiarSoC/core0_wb_adr_o[26] ,
    \experiarSoC/core0_wb_adr_o[25] ,
    \experiarSoC/core0_wb_adr_o[24] ,
    \experiarSoC/core0_wb_adr_o[23] ,
    \experiarSoC/core0_wb_adr_o[22] ,
    \experiarSoC/core0_wb_adr_o[21] ,
    \experiarSoC/core0_wb_adr_o[20] ,
    \experiarSoC/core0_wb_adr_o[19] ,
    \experiarSoC/core0_wb_adr_o[18] ,
    \experiarSoC/core0_wb_adr_o[17] ,
    \experiarSoC/core0_wb_adr_o[16] ,
    \experiarSoC/core0_wb_adr_o[15] ,
    \experiarSoC/core0_wb_adr_o[14] ,
    \experiarSoC/core0_wb_adr_o[13] ,
    \experiarSoC/core0_wb_adr_o[12] ,
    \experiarSoC/core0_wb_adr_o[11] ,
    \experiarSoC/core0_wb_adr_o[10] ,
    \experiarSoC/core0_wb_adr_o[9] ,
    \experiarSoC/core0_wb_adr_o[8] ,
    \experiarSoC/core0_wb_adr_o[7] ,
    \experiarSoC/core0_wb_adr_o[6] ,
    \experiarSoC/core0_wb_adr_o[5] ,
    \experiarSoC/core0_wb_adr_o[4] ,
    \experiarSoC/core0_wb_adr_o[3] ,
    \experiarSoC/core0_wb_adr_o[2] ,
    \experiarSoC/core0_wb_adr_o[1] ,
    \experiarSoC/core0_wb_adr_o[0] }),
    .master1_wb_data_i({\experiarSoC/core0_wb_data_i[31] ,
    \experiarSoC/core0_wb_data_i[30] ,
    \experiarSoC/core0_wb_data_i[29] ,
    \experiarSoC/core0_wb_data_i[28] ,
    \experiarSoC/core0_wb_data_i[27] ,
    \experiarSoC/core0_wb_data_i[26] ,
    \experiarSoC/core0_wb_data_i[25] ,
    \experiarSoC/core0_wb_data_i[24] ,
    \experiarSoC/core0_wb_data_i[23] ,
    \experiarSoC/core0_wb_data_i[22] ,
    \experiarSoC/core0_wb_data_i[21] ,
    \experiarSoC/core0_wb_data_i[20] ,
    \experiarSoC/core0_wb_data_i[19] ,
    \experiarSoC/core0_wb_data_i[18] ,
    \experiarSoC/core0_wb_data_i[17] ,
    \experiarSoC/core0_wb_data_i[16] ,
    \experiarSoC/core0_wb_data_i[15] ,
    \experiarSoC/core0_wb_data_i[14] ,
    \experiarSoC/core0_wb_data_i[13] ,
    \experiarSoC/core0_wb_data_i[12] ,
    \experiarSoC/core0_wb_data_i[11] ,
    \experiarSoC/core0_wb_data_i[10] ,
    \experiarSoC/core0_wb_data_i[9] ,
    \experiarSoC/core0_wb_data_i[8] ,
    \experiarSoC/core0_wb_data_i[7] ,
    \experiarSoC/core0_wb_data_i[6] ,
    \experiarSoC/core0_wb_data_i[5] ,
    \experiarSoC/core0_wb_data_i[4] ,
    \experiarSoC/core0_wb_data_i[3] ,
    \experiarSoC/core0_wb_data_i[2] ,
    \experiarSoC/core0_wb_data_i[1] ,
    \experiarSoC/core0_wb_data_i[0] }),
    .master1_wb_data_o({\experiarSoC/core0_wb_data_o[31] ,
    \experiarSoC/core0_wb_data_o[30] ,
    \experiarSoC/core0_wb_data_o[29] ,
    \experiarSoC/core0_wb_data_o[28] ,
    \experiarSoC/core0_wb_data_o[27] ,
    \experiarSoC/core0_wb_data_o[26] ,
    \experiarSoC/core0_wb_data_o[25] ,
    \experiarSoC/core0_wb_data_o[24] ,
    \experiarSoC/core0_wb_data_o[23] ,
    \experiarSoC/core0_wb_data_o[22] ,
    \experiarSoC/core0_wb_data_o[21] ,
    \experiarSoC/core0_wb_data_o[20] ,
    \experiarSoC/core0_wb_data_o[19] ,
    \experiarSoC/core0_wb_data_o[18] ,
    \experiarSoC/core0_wb_data_o[17] ,
    \experiarSoC/core0_wb_data_o[16] ,
    \experiarSoC/core0_wb_data_o[15] ,
    \experiarSoC/core0_wb_data_o[14] ,
    \experiarSoC/core0_wb_data_o[13] ,
    \experiarSoC/core0_wb_data_o[12] ,
    \experiarSoC/core0_wb_data_o[11] ,
    \experiarSoC/core0_wb_data_o[10] ,
    \experiarSoC/core0_wb_data_o[9] ,
    \experiarSoC/core0_wb_data_o[8] ,
    \experiarSoC/core0_wb_data_o[7] ,
    \experiarSoC/core0_wb_data_o[6] ,
    \experiarSoC/core0_wb_data_o[5] ,
    \experiarSoC/core0_wb_data_o[4] ,
    \experiarSoC/core0_wb_data_o[3] ,
    \experiarSoC/core0_wb_data_o[2] ,
    \experiarSoC/core0_wb_data_o[1] ,
    \experiarSoC/core0_wb_data_o[0] }),
    .master1_wb_sel_o({\experiarSoC/core0_wb_sel_o[3] ,
    \experiarSoC/core0_wb_sel_o[2] ,
    \experiarSoC/core0_wb_sel_o[1] ,
    \experiarSoC/core0_wb_sel_o[0] }),
    .master2_wb_adr_o({\experiarSoC/core1_wb_adr_o[27] ,
    \experiarSoC/core1_wb_adr_o[26] ,
    \experiarSoC/core1_wb_adr_o[25] ,
    \experiarSoC/core1_wb_adr_o[24] ,
    \experiarSoC/core1_wb_adr_o[23] ,
    \experiarSoC/core1_wb_adr_o[22] ,
    \experiarSoC/core1_wb_adr_o[21] ,
    \experiarSoC/core1_wb_adr_o[20] ,
    \experiarSoC/core1_wb_adr_o[19] ,
    \experiarSoC/core1_wb_adr_o[18] ,
    \experiarSoC/core1_wb_adr_o[17] ,
    \experiarSoC/core1_wb_adr_o[16] ,
    \experiarSoC/core1_wb_adr_o[15] ,
    \experiarSoC/core1_wb_adr_o[14] ,
    \experiarSoC/core1_wb_adr_o[13] ,
    \experiarSoC/core1_wb_adr_o[12] ,
    \experiarSoC/core1_wb_adr_o[11] ,
    \experiarSoC/core1_wb_adr_o[10] ,
    \experiarSoC/core1_wb_adr_o[9] ,
    \experiarSoC/core1_wb_adr_o[8] ,
    \experiarSoC/core1_wb_adr_o[7] ,
    \experiarSoC/core1_wb_adr_o[6] ,
    \experiarSoC/core1_wb_adr_o[5] ,
    \experiarSoC/core1_wb_adr_o[4] ,
    \experiarSoC/core1_wb_adr_o[3] ,
    \experiarSoC/core1_wb_adr_o[2] ,
    \experiarSoC/core1_wb_adr_o[1] ,
    \experiarSoC/core1_wb_adr_o[0] }),
    .master2_wb_data_i({\experiarSoC/core1_wb_data_i[31] ,
    \experiarSoC/core1_wb_data_i[30] ,
    \experiarSoC/core1_wb_data_i[29] ,
    \experiarSoC/core1_wb_data_i[28] ,
    \experiarSoC/core1_wb_data_i[27] ,
    \experiarSoC/core1_wb_data_i[26] ,
    \experiarSoC/core1_wb_data_i[25] ,
    \experiarSoC/core1_wb_data_i[24] ,
    \experiarSoC/core1_wb_data_i[23] ,
    \experiarSoC/core1_wb_data_i[22] ,
    \experiarSoC/core1_wb_data_i[21] ,
    \experiarSoC/core1_wb_data_i[20] ,
    \experiarSoC/core1_wb_data_i[19] ,
    \experiarSoC/core1_wb_data_i[18] ,
    \experiarSoC/core1_wb_data_i[17] ,
    \experiarSoC/core1_wb_data_i[16] ,
    \experiarSoC/core1_wb_data_i[15] ,
    \experiarSoC/core1_wb_data_i[14] ,
    \experiarSoC/core1_wb_data_i[13] ,
    \experiarSoC/core1_wb_data_i[12] ,
    \experiarSoC/core1_wb_data_i[11] ,
    \experiarSoC/core1_wb_data_i[10] ,
    \experiarSoC/core1_wb_data_i[9] ,
    \experiarSoC/core1_wb_data_i[8] ,
    \experiarSoC/core1_wb_data_i[7] ,
    \experiarSoC/core1_wb_data_i[6] ,
    \experiarSoC/core1_wb_data_i[5] ,
    \experiarSoC/core1_wb_data_i[4] ,
    \experiarSoC/core1_wb_data_i[3] ,
    \experiarSoC/core1_wb_data_i[2] ,
    \experiarSoC/core1_wb_data_i[1] ,
    \experiarSoC/core1_wb_data_i[0] }),
    .master2_wb_data_o({\experiarSoC/core1_wb_data_o[31] ,
    \experiarSoC/core1_wb_data_o[30] ,
    \experiarSoC/core1_wb_data_o[29] ,
    \experiarSoC/core1_wb_data_o[28] ,
    \experiarSoC/core1_wb_data_o[27] ,
    \experiarSoC/core1_wb_data_o[26] ,
    \experiarSoC/core1_wb_data_o[25] ,
    \experiarSoC/core1_wb_data_o[24] ,
    \experiarSoC/core1_wb_data_o[23] ,
    \experiarSoC/core1_wb_data_o[22] ,
    \experiarSoC/core1_wb_data_o[21] ,
    \experiarSoC/core1_wb_data_o[20] ,
    \experiarSoC/core1_wb_data_o[19] ,
    \experiarSoC/core1_wb_data_o[18] ,
    \experiarSoC/core1_wb_data_o[17] ,
    \experiarSoC/core1_wb_data_o[16] ,
    \experiarSoC/core1_wb_data_o[15] ,
    \experiarSoC/core1_wb_data_o[14] ,
    \experiarSoC/core1_wb_data_o[13] ,
    \experiarSoC/core1_wb_data_o[12] ,
    \experiarSoC/core1_wb_data_o[11] ,
    \experiarSoC/core1_wb_data_o[10] ,
    \experiarSoC/core1_wb_data_o[9] ,
    \experiarSoC/core1_wb_data_o[8] ,
    \experiarSoC/core1_wb_data_o[7] ,
    \experiarSoC/core1_wb_data_o[6] ,
    \experiarSoC/core1_wb_data_o[5] ,
    \experiarSoC/core1_wb_data_o[4] ,
    \experiarSoC/core1_wb_data_o[3] ,
    \experiarSoC/core1_wb_data_o[2] ,
    \experiarSoC/core1_wb_data_o[1] ,
    \experiarSoC/core1_wb_data_o[0] }),
    .master2_wb_sel_o({\experiarSoC/core1_wb_sel_o[3] ,
    \experiarSoC/core1_wb_sel_o[2] ,
    \experiarSoC/core1_wb_sel_o[1] ,
    \experiarSoC/core1_wb_sel_o[0] }),
    .probe_master0_currentSlave({la_data_out[3],
    la_data_out[2]}),
    .probe_master1_currentSlave({la_data_out[5],
    la_data_out[4]}),
    .probe_master2_currentSlave({la_data_out[7],
    la_data_out[6]}),
    .probe_master3_currentSlave({la_data_out[9],
    la_data_out[8]}),
    .probe_slave0_currentMaster({la_data_out[11],
    la_data_out[10]}),
    .probe_slave1_currentMaster({la_data_out[13],
    la_data_out[12]}),
    .probe_slave2_currentMaster({la_data_out[15],
    la_data_out[14]}),
    .probe_slave3_currentMaster({la_data_out[17],
    la_data_out[16]}),
    .slave0_wb_adr_i({\experiarSoC/core0Memory_wb_adr_i[23] ,
    \experiarSoC/core0Memory_wb_adr_i[22] ,
    \experiarSoC/core0Memory_wb_adr_i[21] ,
    \experiarSoC/core0Memory_wb_adr_i[20] ,
    \experiarSoC/core0Memory_wb_adr_i[19] ,
    \experiarSoC/core0Memory_wb_adr_i[18] ,
    \experiarSoC/core0Memory_wb_adr_i[17] ,
    \experiarSoC/core0Memory_wb_adr_i[16] ,
    \experiarSoC/core0Memory_wb_adr_i[15] ,
    \experiarSoC/core0Memory_wb_adr_i[14] ,
    \experiarSoC/core0Memory_wb_adr_i[13] ,
    \experiarSoC/core0Memory_wb_adr_i[12] ,
    \experiarSoC/core0Memory_wb_adr_i[11] ,
    \experiarSoC/core0Memory_wb_adr_i[10] ,
    \experiarSoC/core0Memory_wb_adr_i[9] ,
    \experiarSoC/core0Memory_wb_adr_i[8] ,
    \experiarSoC/core0Memory_wb_adr_i[7] ,
    \experiarSoC/core0Memory_wb_adr_i[6] ,
    \experiarSoC/core0Memory_wb_adr_i[5] ,
    \experiarSoC/core0Memory_wb_adr_i[4] ,
    \experiarSoC/core0Memory_wb_adr_i[3] ,
    \experiarSoC/core0Memory_wb_adr_i[2] ,
    \experiarSoC/core0Memory_wb_adr_i[1] ,
    \experiarSoC/core0Memory_wb_adr_i[0] }),
    .slave0_wb_data_i({\experiarSoC/core0Memory_wb_data_i[31] ,
    \experiarSoC/core0Memory_wb_data_i[30] ,
    \experiarSoC/core0Memory_wb_data_i[29] ,
    \experiarSoC/core0Memory_wb_data_i[28] ,
    \experiarSoC/core0Memory_wb_data_i[27] ,
    \experiarSoC/core0Memory_wb_data_i[26] ,
    \experiarSoC/core0Memory_wb_data_i[25] ,
    \experiarSoC/core0Memory_wb_data_i[24] ,
    \experiarSoC/core0Memory_wb_data_i[23] ,
    \experiarSoC/core0Memory_wb_data_i[22] ,
    \experiarSoC/core0Memory_wb_data_i[21] ,
    \experiarSoC/core0Memory_wb_data_i[20] ,
    \experiarSoC/core0Memory_wb_data_i[19] ,
    \experiarSoC/core0Memory_wb_data_i[18] ,
    \experiarSoC/core0Memory_wb_data_i[17] ,
    \experiarSoC/core0Memory_wb_data_i[16] ,
    \experiarSoC/core0Memory_wb_data_i[15] ,
    \experiarSoC/core0Memory_wb_data_i[14] ,
    \experiarSoC/core0Memory_wb_data_i[13] ,
    \experiarSoC/core0Memory_wb_data_i[12] ,
    \experiarSoC/core0Memory_wb_data_i[11] ,
    \experiarSoC/core0Memory_wb_data_i[10] ,
    \experiarSoC/core0Memory_wb_data_i[9] ,
    \experiarSoC/core0Memory_wb_data_i[8] ,
    \experiarSoC/core0Memory_wb_data_i[7] ,
    \experiarSoC/core0Memory_wb_data_i[6] ,
    \experiarSoC/core0Memory_wb_data_i[5] ,
    \experiarSoC/core0Memory_wb_data_i[4] ,
    \experiarSoC/core0Memory_wb_data_i[3] ,
    \experiarSoC/core0Memory_wb_data_i[2] ,
    \experiarSoC/core0Memory_wb_data_i[1] ,
    \experiarSoC/core0Memory_wb_data_i[0] }),
    .slave0_wb_data_o({\experiarSoC/core0Memory_wb_data_o[31] ,
    \experiarSoC/core0Memory_wb_data_o[30] ,
    \experiarSoC/core0Memory_wb_data_o[29] ,
    \experiarSoC/core0Memory_wb_data_o[28] ,
    \experiarSoC/core0Memory_wb_data_o[27] ,
    \experiarSoC/core0Memory_wb_data_o[26] ,
    \experiarSoC/core0Memory_wb_data_o[25] ,
    \experiarSoC/core0Memory_wb_data_o[24] ,
    \experiarSoC/core0Memory_wb_data_o[23] ,
    \experiarSoC/core0Memory_wb_data_o[22] ,
    \experiarSoC/core0Memory_wb_data_o[21] ,
    \experiarSoC/core0Memory_wb_data_o[20] ,
    \experiarSoC/core0Memory_wb_data_o[19] ,
    \experiarSoC/core0Memory_wb_data_o[18] ,
    \experiarSoC/core0Memory_wb_data_o[17] ,
    \experiarSoC/core0Memory_wb_data_o[16] ,
    \experiarSoC/core0Memory_wb_data_o[15] ,
    \experiarSoC/core0Memory_wb_data_o[14] ,
    \experiarSoC/core0Memory_wb_data_o[13] ,
    \experiarSoC/core0Memory_wb_data_o[12] ,
    \experiarSoC/core0Memory_wb_data_o[11] ,
    \experiarSoC/core0Memory_wb_data_o[10] ,
    \experiarSoC/core0Memory_wb_data_o[9] ,
    \experiarSoC/core0Memory_wb_data_o[8] ,
    \experiarSoC/core0Memory_wb_data_o[7] ,
    \experiarSoC/core0Memory_wb_data_o[6] ,
    \experiarSoC/core0Memory_wb_data_o[5] ,
    \experiarSoC/core0Memory_wb_data_o[4] ,
    \experiarSoC/core0Memory_wb_data_o[3] ,
    \experiarSoC/core0Memory_wb_data_o[2] ,
    \experiarSoC/core0Memory_wb_data_o[1] ,
    \experiarSoC/core0Memory_wb_data_o[0] }),
    .slave0_wb_sel_i({\experiarSoC/core0Memory_wb_sel_i[3] ,
    \experiarSoC/core0Memory_wb_sel_i[2] ,
    \experiarSoC/core0Memory_wb_sel_i[1] ,
    \experiarSoC/core0Memory_wb_sel_i[0] }),
    .slave1_wb_adr_i({\experiarSoC/core1Memory_wb_adr_i[23] ,
    \experiarSoC/core1Memory_wb_adr_i[22] ,
    \experiarSoC/core1Memory_wb_adr_i[21] ,
    \experiarSoC/core1Memory_wb_adr_i[20] ,
    \experiarSoC/core1Memory_wb_adr_i[19] ,
    \experiarSoC/core1Memory_wb_adr_i[18] ,
    \experiarSoC/core1Memory_wb_adr_i[17] ,
    \experiarSoC/core1Memory_wb_adr_i[16] ,
    \experiarSoC/core1Memory_wb_adr_i[15] ,
    \experiarSoC/core1Memory_wb_adr_i[14] ,
    \experiarSoC/core1Memory_wb_adr_i[13] ,
    \experiarSoC/core1Memory_wb_adr_i[12] ,
    \experiarSoC/core1Memory_wb_adr_i[11] ,
    \experiarSoC/core1Memory_wb_adr_i[10] ,
    \experiarSoC/core1Memory_wb_adr_i[9] ,
    \experiarSoC/core1Memory_wb_adr_i[8] ,
    \experiarSoC/core1Memory_wb_adr_i[7] ,
    \experiarSoC/core1Memory_wb_adr_i[6] ,
    \experiarSoC/core1Memory_wb_adr_i[5] ,
    \experiarSoC/core1Memory_wb_adr_i[4] ,
    \experiarSoC/core1Memory_wb_adr_i[3] ,
    \experiarSoC/core1Memory_wb_adr_i[2] ,
    \experiarSoC/core1Memory_wb_adr_i[1] ,
    \experiarSoC/core1Memory_wb_adr_i[0] }),
    .slave1_wb_data_i({\experiarSoC/core1Memory_wb_data_i[31] ,
    \experiarSoC/core1Memory_wb_data_i[30] ,
    \experiarSoC/core1Memory_wb_data_i[29] ,
    \experiarSoC/core1Memory_wb_data_i[28] ,
    \experiarSoC/core1Memory_wb_data_i[27] ,
    \experiarSoC/core1Memory_wb_data_i[26] ,
    \experiarSoC/core1Memory_wb_data_i[25] ,
    \experiarSoC/core1Memory_wb_data_i[24] ,
    \experiarSoC/core1Memory_wb_data_i[23] ,
    \experiarSoC/core1Memory_wb_data_i[22] ,
    \experiarSoC/core1Memory_wb_data_i[21] ,
    \experiarSoC/core1Memory_wb_data_i[20] ,
    \experiarSoC/core1Memory_wb_data_i[19] ,
    \experiarSoC/core1Memory_wb_data_i[18] ,
    \experiarSoC/core1Memory_wb_data_i[17] ,
    \experiarSoC/core1Memory_wb_data_i[16] ,
    \experiarSoC/core1Memory_wb_data_i[15] ,
    \experiarSoC/core1Memory_wb_data_i[14] ,
    \experiarSoC/core1Memory_wb_data_i[13] ,
    \experiarSoC/core1Memory_wb_data_i[12] ,
    \experiarSoC/core1Memory_wb_data_i[11] ,
    \experiarSoC/core1Memory_wb_data_i[10] ,
    \experiarSoC/core1Memory_wb_data_i[9] ,
    \experiarSoC/core1Memory_wb_data_i[8] ,
    \experiarSoC/core1Memory_wb_data_i[7] ,
    \experiarSoC/core1Memory_wb_data_i[6] ,
    \experiarSoC/core1Memory_wb_data_i[5] ,
    \experiarSoC/core1Memory_wb_data_i[4] ,
    \experiarSoC/core1Memory_wb_data_i[3] ,
    \experiarSoC/core1Memory_wb_data_i[2] ,
    \experiarSoC/core1Memory_wb_data_i[1] ,
    \experiarSoC/core1Memory_wb_data_i[0] }),
    .slave1_wb_data_o({\experiarSoC/core1Memory_wb_data_o[31] ,
    \experiarSoC/core1Memory_wb_data_o[30] ,
    \experiarSoC/core1Memory_wb_data_o[29] ,
    \experiarSoC/core1Memory_wb_data_o[28] ,
    \experiarSoC/core1Memory_wb_data_o[27] ,
    \experiarSoC/core1Memory_wb_data_o[26] ,
    \experiarSoC/core1Memory_wb_data_o[25] ,
    \experiarSoC/core1Memory_wb_data_o[24] ,
    \experiarSoC/core1Memory_wb_data_o[23] ,
    \experiarSoC/core1Memory_wb_data_o[22] ,
    \experiarSoC/core1Memory_wb_data_o[21] ,
    \experiarSoC/core1Memory_wb_data_o[20] ,
    \experiarSoC/core1Memory_wb_data_o[19] ,
    \experiarSoC/core1Memory_wb_data_o[18] ,
    \experiarSoC/core1Memory_wb_data_o[17] ,
    \experiarSoC/core1Memory_wb_data_o[16] ,
    \experiarSoC/core1Memory_wb_data_o[15] ,
    \experiarSoC/core1Memory_wb_data_o[14] ,
    \experiarSoC/core1Memory_wb_data_o[13] ,
    \experiarSoC/core1Memory_wb_data_o[12] ,
    \experiarSoC/core1Memory_wb_data_o[11] ,
    \experiarSoC/core1Memory_wb_data_o[10] ,
    \experiarSoC/core1Memory_wb_data_o[9] ,
    \experiarSoC/core1Memory_wb_data_o[8] ,
    \experiarSoC/core1Memory_wb_data_o[7] ,
    \experiarSoC/core1Memory_wb_data_o[6] ,
    \experiarSoC/core1Memory_wb_data_o[5] ,
    \experiarSoC/core1Memory_wb_data_o[4] ,
    \experiarSoC/core1Memory_wb_data_o[3] ,
    \experiarSoC/core1Memory_wb_data_o[2] ,
    \experiarSoC/core1Memory_wb_data_o[1] ,
    \experiarSoC/core1Memory_wb_data_o[0] }),
    .slave1_wb_sel_i({\experiarSoC/core1Memory_wb_sel_i[3] ,
    \experiarSoC/core1Memory_wb_sel_i[2] ,
    \experiarSoC/core1Memory_wb_sel_i[1] ,
    \experiarSoC/core1Memory_wb_sel_i[0] }),
    .slave2_wb_adr_i({\experiarSoC/videoMemory_wb_adr_i[23] ,
    \experiarSoC/videoMemory_wb_adr_i[22] ,
    \experiarSoC/videoMemory_wb_adr_i[21] ,
    \experiarSoC/videoMemory_wb_adr_i[20] ,
    \experiarSoC/videoMemory_wb_adr_i[19] ,
    \experiarSoC/videoMemory_wb_adr_i[18] ,
    \experiarSoC/videoMemory_wb_adr_i[17] ,
    \experiarSoC/videoMemory_wb_adr_i[16] ,
    \experiarSoC/videoMemory_wb_adr_i[15] ,
    \experiarSoC/videoMemory_wb_adr_i[14] ,
    \experiarSoC/videoMemory_wb_adr_i[13] ,
    \experiarSoC/videoMemory_wb_adr_i[12] ,
    \experiarSoC/videoMemory_wb_adr_i[11] ,
    \experiarSoC/videoMemory_wb_adr_i[10] ,
    \experiarSoC/videoMemory_wb_adr_i[9] ,
    \experiarSoC/videoMemory_wb_adr_i[8] ,
    \experiarSoC/videoMemory_wb_adr_i[7] ,
    \experiarSoC/videoMemory_wb_adr_i[6] ,
    \experiarSoC/videoMemory_wb_adr_i[5] ,
    \experiarSoC/videoMemory_wb_adr_i[4] ,
    \experiarSoC/videoMemory_wb_adr_i[3] ,
    \experiarSoC/videoMemory_wb_adr_i[2] ,
    \experiarSoC/videoMemory_wb_adr_i[1] ,
    \experiarSoC/videoMemory_wb_adr_i[0] }),
    .slave2_wb_data_i({\experiarSoC/videoMemory_wb_data_i[31] ,
    \experiarSoC/videoMemory_wb_data_i[30] ,
    \experiarSoC/videoMemory_wb_data_i[29] ,
    \experiarSoC/videoMemory_wb_data_i[28] ,
    \experiarSoC/videoMemory_wb_data_i[27] ,
    \experiarSoC/videoMemory_wb_data_i[26] ,
    \experiarSoC/videoMemory_wb_data_i[25] ,
    \experiarSoC/videoMemory_wb_data_i[24] ,
    \experiarSoC/videoMemory_wb_data_i[23] ,
    \experiarSoC/videoMemory_wb_data_i[22] ,
    \experiarSoC/videoMemory_wb_data_i[21] ,
    \experiarSoC/videoMemory_wb_data_i[20] ,
    \experiarSoC/videoMemory_wb_data_i[19] ,
    \experiarSoC/videoMemory_wb_data_i[18] ,
    \experiarSoC/videoMemory_wb_data_i[17] ,
    \experiarSoC/videoMemory_wb_data_i[16] ,
    \experiarSoC/videoMemory_wb_data_i[15] ,
    \experiarSoC/videoMemory_wb_data_i[14] ,
    \experiarSoC/videoMemory_wb_data_i[13] ,
    \experiarSoC/videoMemory_wb_data_i[12] ,
    \experiarSoC/videoMemory_wb_data_i[11] ,
    \experiarSoC/videoMemory_wb_data_i[10] ,
    \experiarSoC/videoMemory_wb_data_i[9] ,
    \experiarSoC/videoMemory_wb_data_i[8] ,
    \experiarSoC/videoMemory_wb_data_i[7] ,
    \experiarSoC/videoMemory_wb_data_i[6] ,
    \experiarSoC/videoMemory_wb_data_i[5] ,
    \experiarSoC/videoMemory_wb_data_i[4] ,
    \experiarSoC/videoMemory_wb_data_i[3] ,
    \experiarSoC/videoMemory_wb_data_i[2] ,
    \experiarSoC/videoMemory_wb_data_i[1] ,
    \experiarSoC/videoMemory_wb_data_i[0] }),
    .slave2_wb_data_o({\experiarSoC/videoMemory_wb_data_o[31] ,
    \experiarSoC/videoMemory_wb_data_o[30] ,
    \experiarSoC/videoMemory_wb_data_o[29] ,
    \experiarSoC/videoMemory_wb_data_o[28] ,
    \experiarSoC/videoMemory_wb_data_o[27] ,
    \experiarSoC/videoMemory_wb_data_o[26] ,
    \experiarSoC/videoMemory_wb_data_o[25] ,
    \experiarSoC/videoMemory_wb_data_o[24] ,
    \experiarSoC/videoMemory_wb_data_o[23] ,
    \experiarSoC/videoMemory_wb_data_o[22] ,
    \experiarSoC/videoMemory_wb_data_o[21] ,
    \experiarSoC/videoMemory_wb_data_o[20] ,
    \experiarSoC/videoMemory_wb_data_o[19] ,
    \experiarSoC/videoMemory_wb_data_o[18] ,
    \experiarSoC/videoMemory_wb_data_o[17] ,
    \experiarSoC/videoMemory_wb_data_o[16] ,
    \experiarSoC/videoMemory_wb_data_o[15] ,
    \experiarSoC/videoMemory_wb_data_o[14] ,
    \experiarSoC/videoMemory_wb_data_o[13] ,
    \experiarSoC/videoMemory_wb_data_o[12] ,
    \experiarSoC/videoMemory_wb_data_o[11] ,
    \experiarSoC/videoMemory_wb_data_o[10] ,
    \experiarSoC/videoMemory_wb_data_o[9] ,
    \experiarSoC/videoMemory_wb_data_o[8] ,
    \experiarSoC/videoMemory_wb_data_o[7] ,
    \experiarSoC/videoMemory_wb_data_o[6] ,
    \experiarSoC/videoMemory_wb_data_o[5] ,
    \experiarSoC/videoMemory_wb_data_o[4] ,
    \experiarSoC/videoMemory_wb_data_o[3] ,
    \experiarSoC/videoMemory_wb_data_o[2] ,
    \experiarSoC/videoMemory_wb_data_o[1] ,
    \experiarSoC/videoMemory_wb_data_o[0] }),
    .slave2_wb_sel_i({\experiarSoC/videoMemory_wb_sel_i[3] ,
    \experiarSoC/videoMemory_wb_sel_i[2] ,
    \experiarSoC/videoMemory_wb_sel_i[1] ,
    \experiarSoC/videoMemory_wb_sel_i[0] }),
    .slave3_wb_adr_i({\experiarSoC/peripherals_wb_adr_i[23] ,
    \experiarSoC/peripherals_wb_adr_i[22] ,
    \experiarSoC/peripherals_wb_adr_i[21] ,
    \experiarSoC/peripherals_wb_adr_i[20] ,
    \experiarSoC/peripherals_wb_adr_i[19] ,
    \experiarSoC/peripherals_wb_adr_i[18] ,
    \experiarSoC/peripherals_wb_adr_i[17] ,
    \experiarSoC/peripherals_wb_adr_i[16] ,
    \experiarSoC/peripherals_wb_adr_i[15] ,
    \experiarSoC/peripherals_wb_adr_i[14] ,
    \experiarSoC/peripherals_wb_adr_i[13] ,
    \experiarSoC/peripherals_wb_adr_i[12] ,
    \experiarSoC/peripherals_wb_adr_i[11] ,
    \experiarSoC/peripherals_wb_adr_i[10] ,
    \experiarSoC/peripherals_wb_adr_i[9] ,
    \experiarSoC/peripherals_wb_adr_i[8] ,
    \experiarSoC/peripherals_wb_adr_i[7] ,
    \experiarSoC/peripherals_wb_adr_i[6] ,
    \experiarSoC/peripherals_wb_adr_i[5] ,
    \experiarSoC/peripherals_wb_adr_i[4] ,
    \experiarSoC/peripherals_wb_adr_i[3] ,
    \experiarSoC/peripherals_wb_adr_i[2] ,
    \experiarSoC/peripherals_wb_adr_i[1] ,
    \experiarSoC/peripherals_wb_adr_i[0] }),
    .slave3_wb_data_i({\experiarSoC/peripherals_wb_data_i[31] ,
    \experiarSoC/peripherals_wb_data_i[30] ,
    \experiarSoC/peripherals_wb_data_i[29] ,
    \experiarSoC/peripherals_wb_data_i[28] ,
    \experiarSoC/peripherals_wb_data_i[27] ,
    \experiarSoC/peripherals_wb_data_i[26] ,
    \experiarSoC/peripherals_wb_data_i[25] ,
    \experiarSoC/peripherals_wb_data_i[24] ,
    \experiarSoC/peripherals_wb_data_i[23] ,
    \experiarSoC/peripherals_wb_data_i[22] ,
    \experiarSoC/peripherals_wb_data_i[21] ,
    \experiarSoC/peripherals_wb_data_i[20] ,
    \experiarSoC/peripherals_wb_data_i[19] ,
    \experiarSoC/peripherals_wb_data_i[18] ,
    \experiarSoC/peripherals_wb_data_i[17] ,
    \experiarSoC/peripherals_wb_data_i[16] ,
    \experiarSoC/peripherals_wb_data_i[15] ,
    \experiarSoC/peripherals_wb_data_i[14] ,
    \experiarSoC/peripherals_wb_data_i[13] ,
    \experiarSoC/peripherals_wb_data_i[12] ,
    \experiarSoC/peripherals_wb_data_i[11] ,
    \experiarSoC/peripherals_wb_data_i[10] ,
    \experiarSoC/peripherals_wb_data_i[9] ,
    \experiarSoC/peripherals_wb_data_i[8] ,
    \experiarSoC/peripherals_wb_data_i[7] ,
    \experiarSoC/peripherals_wb_data_i[6] ,
    \experiarSoC/peripherals_wb_data_i[5] ,
    \experiarSoC/peripherals_wb_data_i[4] ,
    \experiarSoC/peripherals_wb_data_i[3] ,
    \experiarSoC/peripherals_wb_data_i[2] ,
    \experiarSoC/peripherals_wb_data_i[1] ,
    \experiarSoC/peripherals_wb_data_i[0] }),
    .slave3_wb_data_o({\experiarSoC/peripherals_wb_data_o[31] ,
    \experiarSoC/peripherals_wb_data_o[30] ,
    \experiarSoC/peripherals_wb_data_o[29] ,
    \experiarSoC/peripherals_wb_data_o[28] ,
    \experiarSoC/peripherals_wb_data_o[27] ,
    \experiarSoC/peripherals_wb_data_o[26] ,
    \experiarSoC/peripherals_wb_data_o[25] ,
    \experiarSoC/peripherals_wb_data_o[24] ,
    \experiarSoC/peripherals_wb_data_o[23] ,
    \experiarSoC/peripherals_wb_data_o[22] ,
    \experiarSoC/peripherals_wb_data_o[21] ,
    \experiarSoC/peripherals_wb_data_o[20] ,
    \experiarSoC/peripherals_wb_data_o[19] ,
    \experiarSoC/peripherals_wb_data_o[18] ,
    \experiarSoC/peripherals_wb_data_o[17] ,
    \experiarSoC/peripherals_wb_data_o[16] ,
    \experiarSoC/peripherals_wb_data_o[15] ,
    \experiarSoC/peripherals_wb_data_o[14] ,
    \experiarSoC/peripherals_wb_data_o[13] ,
    \experiarSoC/peripherals_wb_data_o[12] ,
    \experiarSoC/peripherals_wb_data_o[11] ,
    \experiarSoC/peripherals_wb_data_o[10] ,
    \experiarSoC/peripherals_wb_data_o[9] ,
    \experiarSoC/peripherals_wb_data_o[8] ,
    \experiarSoC/peripherals_wb_data_o[7] ,
    \experiarSoC/peripherals_wb_data_o[6] ,
    \experiarSoC/peripherals_wb_data_o[5] ,
    \experiarSoC/peripherals_wb_data_o[4] ,
    \experiarSoC/peripherals_wb_data_o[3] ,
    \experiarSoC/peripherals_wb_data_o[2] ,
    \experiarSoC/peripherals_wb_data_o[1] ,
    \experiarSoC/peripherals_wb_data_o[0] }),
    .slave3_wb_sel_i({\experiarSoC/peripherals_wb_sel_i[3] ,
    \experiarSoC/peripherals_wb_sel_i[2] ,
    \experiarSoC/peripherals_wb_sel_i[1] ,
    \experiarSoC/peripherals_wb_sel_i[0] }),
    .slave4_wb_adr_i({\experiarSoC/flash_wb_adr_i[23] ,
    \experiarSoC/flash_wb_adr_i[22] ,
    \experiarSoC/flash_wb_adr_i[21] ,
    \experiarSoC/flash_wb_adr_i[20] ,
    \experiarSoC/flash_wb_adr_i[19] ,
    \experiarSoC/flash_wb_adr_i[18] ,
    \experiarSoC/flash_wb_adr_i[17] ,
    \experiarSoC/flash_wb_adr_i[16] ,
    \experiarSoC/flash_wb_adr_i[15] ,
    \experiarSoC/flash_wb_adr_i[14] ,
    \experiarSoC/flash_wb_adr_i[13] ,
    \experiarSoC/flash_wb_adr_i[12] ,
    \experiarSoC/flash_wb_adr_i[11] ,
    \experiarSoC/flash_wb_adr_i[10] ,
    \experiarSoC/flash_wb_adr_i[9] ,
    \experiarSoC/flash_wb_adr_i[8] ,
    \experiarSoC/flash_wb_adr_i[7] ,
    \experiarSoC/flash_wb_adr_i[6] ,
    \experiarSoC/flash_wb_adr_i[5] ,
    \experiarSoC/flash_wb_adr_i[4] ,
    \experiarSoC/flash_wb_adr_i[3] ,
    \experiarSoC/flash_wb_adr_i[2] ,
    \experiarSoC/flash_wb_adr_i[1] ,
    \experiarSoC/flash_wb_adr_i[0] }),
    .slave4_wb_data_i({\experiarSoC/flash_wb_data_i[31] ,
    \experiarSoC/flash_wb_data_i[30] ,
    \experiarSoC/flash_wb_data_i[29] ,
    \experiarSoC/flash_wb_data_i[28] ,
    \experiarSoC/flash_wb_data_i[27] ,
    \experiarSoC/flash_wb_data_i[26] ,
    \experiarSoC/flash_wb_data_i[25] ,
    \experiarSoC/flash_wb_data_i[24] ,
    \experiarSoC/flash_wb_data_i[23] ,
    \experiarSoC/flash_wb_data_i[22] ,
    \experiarSoC/flash_wb_data_i[21] ,
    \experiarSoC/flash_wb_data_i[20] ,
    \experiarSoC/flash_wb_data_i[19] ,
    \experiarSoC/flash_wb_data_i[18] ,
    \experiarSoC/flash_wb_data_i[17] ,
    \experiarSoC/flash_wb_data_i[16] ,
    \experiarSoC/flash_wb_data_i[15] ,
    \experiarSoC/flash_wb_data_i[14] ,
    \experiarSoC/flash_wb_data_i[13] ,
    \experiarSoC/flash_wb_data_i[12] ,
    \experiarSoC/flash_wb_data_i[11] ,
    \experiarSoC/flash_wb_data_i[10] ,
    \experiarSoC/flash_wb_data_i[9] ,
    \experiarSoC/flash_wb_data_i[8] ,
    \experiarSoC/flash_wb_data_i[7] ,
    \experiarSoC/flash_wb_data_i[6] ,
    \experiarSoC/flash_wb_data_i[5] ,
    \experiarSoC/flash_wb_data_i[4] ,
    \experiarSoC/flash_wb_data_i[3] ,
    \experiarSoC/flash_wb_data_i[2] ,
    \experiarSoC/flash_wb_data_i[1] ,
    \experiarSoC/flash_wb_data_i[0] }),
    .slave4_wb_data_o({\experiarSoC/flash_wb_data_o[31] ,
    \experiarSoC/flash_wb_data_o[30] ,
    \experiarSoC/flash_wb_data_o[29] ,
    \experiarSoC/flash_wb_data_o[28] ,
    \experiarSoC/flash_wb_data_o[27] ,
    \experiarSoC/flash_wb_data_o[26] ,
    \experiarSoC/flash_wb_data_o[25] ,
    \experiarSoC/flash_wb_data_o[24] ,
    \experiarSoC/flash_wb_data_o[23] ,
    \experiarSoC/flash_wb_data_o[22] ,
    \experiarSoC/flash_wb_data_o[21] ,
    \experiarSoC/flash_wb_data_o[20] ,
    \experiarSoC/flash_wb_data_o[19] ,
    \experiarSoC/flash_wb_data_o[18] ,
    \experiarSoC/flash_wb_data_o[17] ,
    \experiarSoC/flash_wb_data_o[16] ,
    \experiarSoC/flash_wb_data_o[15] ,
    \experiarSoC/flash_wb_data_o[14] ,
    \experiarSoC/flash_wb_data_o[13] ,
    \experiarSoC/flash_wb_data_o[12] ,
    \experiarSoC/flash_wb_data_o[11] ,
    \experiarSoC/flash_wb_data_o[10] ,
    \experiarSoC/flash_wb_data_o[9] ,
    \experiarSoC/flash_wb_data_o[8] ,
    \experiarSoC/flash_wb_data_o[7] ,
    \experiarSoC/flash_wb_data_o[6] ,
    \experiarSoC/flash_wb_data_o[5] ,
    \experiarSoC/flash_wb_data_o[4] ,
    \experiarSoC/flash_wb_data_o[3] ,
    \experiarSoC/flash_wb_data_o[2] ,
    \experiarSoC/flash_wb_data_o[1] ,
    \experiarSoC/flash_wb_data_o[0] }),
    .slave4_wb_sel_i({\experiarSoC/flash_wb_sel_i[3] ,
    \experiarSoC/flash_wb_sel_i[2] ,
    \experiarSoC/flash_wb_sel_i[1] ,
    \experiarSoC/flash_wb_sel_i[0] }));
endmodule

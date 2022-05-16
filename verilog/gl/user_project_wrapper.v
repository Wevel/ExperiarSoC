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
 wire \caravel_wb_adr_o[28] ;
 wire \caravel_wb_adr_o[29] ;
 wire \caravel_wb_adr_o[2] ;
 wire \caravel_wb_adr_o[30] ;
 wire \caravel_wb_adr_o[31] ;
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

 CaravelHost caravelHost (.caravel_uart_rx(caravel_uart_rx),
    .caravel_uart_tx(caravel_uart_tx),
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
    .caravel_wb_adr_o({\caravel_wb_adr_o[31] ,
    \caravel_wb_adr_o[30] ,
    \caravel_wb_adr_o[29] ,
    \caravel_wb_adr_o[28] ,
    \caravel_wb_adr_o[27] ,
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
endmodule

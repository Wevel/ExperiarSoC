// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
		parameter BITS = 32
	) (
	`ifdef USE_POWER_PINS
		inout vdda1,	// User area 1 3.3V supply
		inout vdda2,	// User area 2 3.3V supply
		inout vssa1,	// User area 1 analog ground
		inout vssa2,	// User area 2 analog ground
		inout vccd1,	// User area 1 1.8V supply
		inout vccd2,	// User area 2 1.8v supply
		inout vssd1,	// User area 1 digital ground
		inout vssd2,	// User area 2 digital ground
	`endif

		// Wishbone Slave ports (WB MI A)
		input wb_clk_i,
		input wb_rst_i,
		input wbs_stb_i,
		input wbs_cyc_i,
		input wbs_we_i,
		input [3:0] wbs_sel_i,
		input [31:0] wbs_dat_i,
		input [31:0] wbs_adr_i,
		output wbs_ack_o,
		output [31:0] wbs_dat_o,

		// Logic Analyzer Signals
		input  [127:0] la_data_in,
		output [127:0] la_data_out,
		input  [127:0] la_oenb,

		// IOs
		input  [`MPRJ_IO_PADS-1:0] io_in,
		output [`MPRJ_IO_PADS-1:0] io_out,
		output [`MPRJ_IO_PADS-1:0] io_oeb,

		// Analog (direct connection to GPIO pad---use with caution)
		// Note that analog I/O is not available on the 7 lowest-numbered
		// GPIO pads, and so the analog_io indexing is offset from the
		// GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
		inout [`MPRJ_IO_PADS-10:0] analog_io,

		// Independent clock (on independent integer divider)
		input   user_clock2,

		// User maskable interrupt signals
		output [2:0] user_irq
	);

	/*--------------------------------------*/
	/* User project is instantiated  here   */
	/*--------------------------------------*/

	wire [`MPRJ_IO_PADS-1:0] io_out2;
	wire [`MPRJ_IO_PADS-1:0] io_oeb2;
	assign io_out = io_out2;
	assign io_oeb = io_oeb2;

	// assign io_out = { 
	// 	io_out2[`MPRJ_IO_PADS-1:5],
	// 	caravel_wb_cyc_o,
	// 	caravel_wb_ack_i,
	// 	wbs_cyc_i && wbs_stb_i,
	// 	wbs_ack_o,
	// 	wbs_we_i
	// };
	//assign io_oeb = { io_oeb2[`MPRJ_IO_PADS-1:5], 5'b0 };

	// Caravel wishbone master
	wire caravel_wb_cyc_o;
	wire caravel_wb_stb_o;
	wire caravel_wb_we_o;
	wire[3:0] caravel_wb_sel_o;
	wire[31:0] caravel_wb_data_o;
	wire[27:0] caravel_wb_adr_o;
	wire caravel_wb_ack_i;
	wire caravel_wb_stall_i;
	wire caravel_wb_error_i;
	wire[31:0] caravel_wb_data_i;

	// Caravel UART
	wire caravel_uart_rx;
	wire caravel_uart_tx;

	// Configuration
	wire[7:0] core0Index;
	wire[7:0] core1Index;
	wire[10:0] manufacturerID;
	wire[15:0] partID;
	wire[3:0] versionID;

	ExperiarSoC experiarSoC(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
    	.wb_clk_i(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.caravel_wb_cyc_o(caravel_wb_cyc_o),
		.caravel_wb_stb_o(caravel_wb_stb_o),
		.caravel_wb_we_o(caravel_wb_we_o),
		.caravel_wb_sel_o(caravel_wb_sel_o),
		.caravel_wb_data_o(caravel_wb_data_o),
		.caravel_wb_adr_o(caravel_wb_adr_o),
		.caravel_wb_ack_i(caravel_wb_ack_i),
		.caravel_wb_stall_i(caravel_wb_stall_i),
		.caravel_wb_error_i(caravel_wb_error_i),
		.caravel_wb_data_i(caravel_wb_data_i),
		.io_in(io_in),
		.io_out(io_out2),
		.io_oeb(io_oeb2),
		.caravel_uart_rx(caravel_uart_rx),
		.caravel_uart_tx(caravel_uart_tx),
		.la_data_in(la_data_in),
		.la_data_out(la_data_out),
		.la_oenb(la_oenb),
		.core0Index(core0Index),
		.core1Index(core1Index),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID));

	CaravelHost caravelHost(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.wb_clk_i(wb_clk_i),
    	.wb_rst_i(wb_rst_i),
		.wbs_stb_i(wbs_stb_i),
		.wbs_cyc_i(wbs_cyc_i),
		.wbs_we_i(wbs_we_i),
		.wbs_sel_i(wbs_sel_i),
		.wbs_data_i(wbs_dat_i),
		.wbs_adr_i(wbs_adr_i),
		.wbs_ack_o(wbs_ack_o),
		.wbs_data_o(wbs_dat_o),
		.caravel_wb_cyc_o(caravel_wb_cyc_o),
		.caravel_wb_stb_o(caravel_wb_stb_o),
		.caravel_wb_we_o(caravel_wb_we_o),
		.caravel_wb_sel_o(caravel_wb_sel_o),
		.caravel_wb_data_o(caravel_wb_data_o),
		.caravel_wb_adr_o(caravel_wb_adr_o),
		.caravel_wb_ack_i(caravel_wb_ack_i),
		.caravel_wb_stall_i(caravel_wb_stall_i),
		.caravel_wb_error_i(caravel_wb_error_i),
		.caravel_wb_data_i(caravel_wb_data_i),
		// Swap Tx and Rx pins, as these are with reference to the interface
		.caravel_uart_rx(caravel_uart_tx),
		.caravel_uart_tx(caravel_uart_rx),
		.core0Index(core0Index),
		.core1Index(core1Index),
		.manufacturerID(manufacturerID),
		.partID(partID),
		.versionID(versionID));

	// Add dumby module for art
	wire dumyPin;
	Art art(
`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V power
		.vssd1(vssd1),	// User area 1 digital ground
`endif
		.dumyPin(dumyPin));

endmodule	// user_project_wrapper

`default_nettype wire

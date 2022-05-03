module WBSlaveSelect #(
		parameter ID = 4'h0
	)(
		input wire[31:0] wb_address,
		output wire[23:0] localAddress,
		output wire wbSlaveEnable
	);

assign wbSlaveEnable = (wb_address[27:24] == ID); // (wb_address[31:28] == 4'b0000) && 
assign localAddress = wb_address[23:0];

endmodule
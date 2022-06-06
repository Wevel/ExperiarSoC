module MasterArbiter (
		input wire clk,
		input wire rst,

		input wire[3:0] request,
		output wire[1:0] masterSelected
	);

	localparam MASTER0 = 2'h0;
	localparam MASTER1 = 2'h1;
	localparam MASTER2 = 2'h2;
	localparam MASTER3 = 2'h3;

	reg[1:0] currentMaster = MASTER0;
	reg[1:0] nextMaster;

	always @(*) begin
		nextMaster = currentMaster;

		case (currentMaster)
			MASTER0: begin
				if (!request[0]) begin
					if (request[1]) nextMaster = MASTER1;
					else if (request[2]) nextMaster = MASTER2;
					else if (request[3]) nextMaster = MASTER3;
				end
			end

			MASTER1: begin
				if (!request[1]) begin
					if (request[2]) nextMaster = MASTER2;
					else if (request[3]) nextMaster = MASTER3;
					else if (request[0]) nextMaster = MASTER0;
				end
			end

			MASTER2: begin
				if (!request[2]) begin
					if (request[3]) nextMaster = MASTER3;
					else if (request[0]) nextMaster = MASTER0;
					else if (request[1]) nextMaster = MASTER1;
				end
			end

			MASTER3: begin
				if (!request[3]) begin
					if (request[0]) nextMaster = MASTER0;
					else if (request[1]) nextMaster = MASTER1;
					else if (request[2]) nextMaster = MASTER2;
				end
			end
		endcase
	end

	always @(posedge clk) begin
		if (rst) currentMaster <= MASTER0;
		else currentMaster <= nextMaster;
	end

	assign masterSelected = nextMaster;

endmodule
module ov7670_registers	(
						input	logic		clk,
						input	logic		resend,
						input	logic		advance,
						output	logic[15:0]	command,
						output logic		finished	
	);

	logic [15:0]	sreg;
	logic [7:0]		address;
	logic [15:0]	rgb;

    initial begin
        address = '0;
    end

	always_comb begin : proc_sreg
		command = sreg;
		if (sreg == 16'hFFFF) begin
			finished = 1'b1;
		end else begin
			finished = 1'b0;
		end
	end

	always_ff @(posedge clk) begin : proc_0
		if (resend == 1'b1) begin
			address <= '0;			
		end else if (advance == 1'b1) begin
			address <= address + 1;
		end

		case(address)
			8'h00 	: sreg <= 16'h1280;
			8'h01 	: sreg <= 16'h1280;
			8'h02 	: sreg <= 16'h1200;
			8'h03 	: sreg <= 16'h1100;
			8'h04 	: sreg <= 16'h0C00;
			8'h05 	: sreg <= 16'h3E00;
			8'h06 	: sreg <= 16'h8C00;
			8'h07 	: sreg <= 16'h0400;
			8'h08 	: sreg <= 16'h4010;
			8'h09 	: sreg <= 16'h3A14;
			8'h0A 	: sreg <= 16'h1438;
			8'h11 	: sreg <= 16'h589E;
			8'h12 	: sreg <= 16'h3D88;
			8'h13 	: sreg <= 16'h1100;
			8'h14 	: sreg <= 16'h1711;
			8'h15 	: sreg <= 16'h1861;
			8'h16 	: sreg <= 16'h32A4;
			8'h17 	: sreg <= 16'h1903;
			8'h18	: sreg <= 16'h1A7B;
			8'h19 	: sreg <= 16'h030A;
			default	: sreg <= 16'hFFFF;
		endcase
	end
endmodule
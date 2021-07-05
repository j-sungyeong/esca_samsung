module debounce	(
				input	logic 		clk,
				input 	logic 		i,
				output 	logic 		o
				);

	logic[23:0] c;

	always_ff @(posedge clk) begin : proc_
		if (i == 1'b1) begin
			if (c == 24'hFFFFFF) begin
				o <= 1'b1;
			end else begin
				o <= 1'b0;
			end
			c <= c+1;
		end else begin
			c <= '0;
			o <= 1'b0;
		end
	end
endmodule // debounce
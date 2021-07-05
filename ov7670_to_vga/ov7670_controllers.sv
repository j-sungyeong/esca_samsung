module ov7670_controller	(
							input	logic 		clk,
							input	logic		resend,
							output logic		config_finished,
							output logic		sioc,
							inout 	logic 		siod,
							output	logic 		reset,
							output logic 		pwdn,
							output logic 		xclk
							);
	logic 			sys_clk;
	logic [15:0]	command;
	logic 			finished;
	logic 			taken;
	logic 			send;
	logic [7:0]    camera_address = 8'h42;


    initial begin
        finished = '0;
        taken ='0;
        sys_clk = '0;
    end

	always_comb begin : proc_config
		config_finished = finished;
		send = ~finished;
		reset = 1'b1;
		pwdn = 1'b0;
		xclk = sys_clk;
	end

	i2c_sender Inst_i2c_sender(
		.clk(clk),
		.taken(taken),
		.siod(siod),
		.sioc(sioc),
		.send(send),
		.id(camera_address),
		.regi(command[15:8]),
		.value(command[7:0])
		);

	ov7670_registers Inst_ov7670_registers(
		.clk(clk),
		.advance(taken),
		.command(command),
		.finished(finished),
		.resend(resend)
		);

	always_ff @(posedge clk) begin : proc_
		sys_clk <= ~sys_clk;
	end
endmodule
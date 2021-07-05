//////////////////////////////////////////////////////////////////////////////////
// Company: Embedded Computing Lab, Korea University
// Engineer: Kwon Guyun
//           1216kg@naver.com
// 
// Create Date: 2021/07/01 11:04:31
// Design Name: ov7670_top
// Module Name: ov7670_top
// Project Name: project_ov7670
// Target Devices: zedboard
// Tool Versions: Vivado 2019.1
// Description: top module of ov7670 to VGA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: reference design: http://www.nazim.ru/2512
//                      up button - reset ov7670
//                      switch 6 - pause image
//                      switch 7 - change resolution
//////////////////////////////////////////////////////////////////////////////////


module ov7670_top	(
					input 	logic 		    clk100_zed,
					output logic 			OV7670_SIOC,                           // similar with I2C's SCL
					inout 	logic 			OV7670_SIOD,                           // similar with I2C's SDA
					output logic 			OV7670_RESET,                          // ov7670 reset
					output logic 			OV7670_PWDN,                           // ov7670 power down
					input 	logic 			OV7670_VSYNC,                          // ov7670 vertical sync
					input 	logic 			OV7670_HREF,                           // ov7670 horizontal reference
					input 	logic 			OV7670_PCLK,                           // ov7670 pclock
					output logic 			OV7670_XCLK,                           // ov7670 xclock
					input 	logic [7:0] 	OV7670_D,                              // ov7670 data
		
					output logic [7:0]		LED,                                   // zedboard_LED
		
					output logic [3:0]		vga_red,                               // vga red output
					output	logic [3:0]		vga_green,                             // vga green output
					output	logic [3:0]		vga_blue,                              // vga blue output
					output	logic 			vga_hsync,                             // vga horizontal sync
					output	logic 			vga_vsync,                             // vga vertical sync

					input 	logic			btn,                                    // zedboard BTNU (up button)
					input 	logic			sw7,                                    // zedboard SW7 (switch 7)
					input 	logic			sw6,                                    // zedboard SW6 (switch 6)
					input 	logic			sw5                                     // zedboard SW5 (switch 5)

					);
    
    localparam widthlength = 8;                                            // lenet_input data pixel accumulation size
    localparam heightlength = 8;
    localparam lenet_size = 28;
    localparam ACC_D_SIZE = $clog2(widthlength * heightlength) + 4 - 1;           // each lenet pixel's data size
	// clocks
	logic			clk100;
	logic			clk75;
	logic			clk50;
	logic 			clk25;
	// debounce to controller
	logic			resend;
	// capture to mem_blk_0
	logic [18:0]	capture_addr;
	logic [7:0] 	capture_data;
	logic [0:0]		capture_we;
	// mem_blk_0 -> core -> mem_blk_1
	logic [7:0]		data_to_core;
	logic [3:0]		data_from_core;
	logic [18:0]	addr_core_to_mem0;
	logic [18:0]	addr_core_to_mem1;
	logic [0:0]		we_core_to_mem1;
	// mem_blk_1 to vga
	logic [18:0]	frame_addr;
	logic [3:0]		frame_pixel;
	// controller to LED
	logic 			config_finished;
	// memory2 controller
	logic [9:0]		addr_core_to_mem2;
	logic [ACC_D_SIZE:0]		data_core_to_mem2;
	logic 			lenet_we;
	// lenet memory access
	logic [9:0]    addr_lenet_to_mem2;
	logic [15:0]   data_lenet_from_mem2;
	logic          ren_lenet_to_mem2;
	
	logic [15-ACC_D_SIZE:0] zerotemp;

    assign LED = {sw7, sw6, sw5, btn, 3'b000, config_finished};             // show LED some informations
    assign zerotemp = '0;
    
		clk_wiz_0 clkwiz(                                             // clock generator
			.clk_in_wiz(clk100_zed),
			.clk_100wiz(clk100),
			.clk_75wiz(clk75),
			.clk_50wiz(clk50),
			.clk_25wiz(clk25)
			);                                                       

		debounce idebounce(                                           // handles button input
			.clk(clk50),
			.i(btn),
			.o(resend)
			);

		ov7670_capture icapture(                                      // gets datas from ov7670 and stores them to fb1
			.pclk(OV7670_PCLK),
			.vsync(OV7670_VSYNC),
			.href(OV7670_HREF),
			.sw(sw6),
			.din(OV7670_D),
			.addr(capture_addr),
			.dout(capture_data),
			.we(capture_we[0])
			);

    	blk_mem_gen_0 fb1(                                             // stores captured data
			.clka(OV7670_PCLK),
			.wea(capture_we),
			.addra(capture_addr),
			.dina(capture_data),

			.clkb(clk50),
			.addrb(addr_core_to_mem0),
			.doutb(data_to_core)
			);

		core #(
		    .width(640),
		    .height(480),
		    .widthlength(widthlength),
		    .heightlength(heightlength),
		    .lenet_size(lenet_size),
		    .ACC_D_SIZE(ACC_D_SIZE)
		    )icore(                                                   // loads data from fb1 and processes it, stores processed data to fb2 and fb3, you can modify this module to change vga output or anything else
			.clk25(clk25),
			.addr_mem0(addr_core_to_mem0),
			.addr_mem1(addr_core_to_mem1),
			.din(data_to_core),
			.dout(data_from_core),
			.we(we_core_to_mem1[0]),
			.addr_mem2(addr_core_to_mem2),
			.lenet_signal(sw7),
			.lenet_dout(data_core_to_mem2),
			.lenet_we(lenet_we)
			);


		blk_mem_gen_1 fb2(                                            // stores processed data, connected with vga module
			.clka(clk25),
			.wea(we_core_to_mem1),
			.addra(addr_core_to_mem1),
			.dina(data_from_core),

			.clkb(clk50),
			.addrb(frame_addr),
			.doutb(frame_pixel)
			);

		vga #(
		     .widthlength(widthlength),
		     .heightlength(heightlength),
		     .lenet_size(lenet_size)
		     )ivga(                                                     // loads data from fb and sends it to vga output
			.clk25(clk25),
			.vga_red(vga_red),
			.vga_green(vga_green),
			.vga_blue(vga_blue),
			.vga_hsync(vga_hsync),
			.vga_vsync(vga_vsync),
			.frame_addr(frame_addr),
			.frame_pixel(frame_pixel),
			.sw(sw5)
			);

		ov7670_controller controller(                                 // initialize ov7670 or reset ov7670, reset has some bug to be fixed in future
			.clk(clk50),
			.sioc(OV7670_SIOC),
			.resend(resend),
			.config_finished(config_finished),
			.siod(OV7670_SIOD),
			.pwdn(OV7670_PWDN),
			.reset(OV7670_RESET),
			.xclk(OV7670_XCLK)
			);
			
		blk_mem_gen_2 fb3(                                            // stores processed data, for now, stores datas for Lenet input
			.clka(clk25),
			.wea(lenet_we),
			.addra(addr_core_to_mem2),
			.dina({data_core_to_mem2,zerotemp}),

			.clkb(clk100),
			.addrb(addr_lenet_to_mem2),
			.doutb(data_lenet_from_mem2),
			.enb(ren_lenet_to_mem2)
			);

endmodule // ov7670_top
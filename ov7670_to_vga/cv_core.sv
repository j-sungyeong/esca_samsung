//////////////////////////////////////////////////////////////////////////////////
// Company: Embedded Computing Lab, Korea University
// Engineer: Kwon Guyun
//           1216kg@naver.com
// 
// Create Date: 2021/07/01 11:04:31
// Design Name: ov7670_capture
// Module Name: ov7670_capture
// Project Name: project_ov7670
// Target Devices: zedboard
// Tool Versions: Vivado 2019.1
// Description: get a image like data and process it before send it to vga
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: reference design: http://www.nazim.ru/2512
// 
//////////////////////////////////////////////////////////////////////////////////
module core 
            #
            (
            parameter width = 640,
            parameter height = 480,
			parameter widthlength = 8,
			parameter heightlength = 8,
			parameter lenet_size = 28,
			parameter ACC_D_SIZE = 9,
			
            localparam c_frame = width * height,                                 // number of total pixels per image
            localparam left = width / 2 - widthlength * lenet_size / 2,          // resolution-changing rectangle's left, right, up, down
            localparam right = width / 2 + widthlength * lenet_size / 2,
            localparam upper = height / 2 - heightlength * lenet_size / 2,
            localparam downer = height / 2 + heightlength * lenet_size / 2
            )
            (
			input	                       clk25,
			output	logic[18:0]	           addr_mem0,
			output logic[18:0]	           addr_mem1,
			input 	wire[7:0]	           din,
			output logic[3:0]	           dout,
			output	logic                 we,
			output logic[9:0]            addr_mem2,
			input 	logic                 lenet_signal,
			output logic[ACC_D_SIZE:0]   lenet_dout,
			output logic                 lenet_we
			);
	

	
	logic[18:0]	counter;
	logic[18:0]	address_mem0;
	logic[18:0]	address_mem1;
    logic[lenet_size-1:0][ACC_D_SIZE:0] accu_temp;
    logic[lenet_size-1:0][ACC_D_SIZE:0] out_temp;
    logic[9:0]hcounter;
    logic[9:0]vcounter;
    logic lenet_doing;
    
	initial begin
		counter = '0;
		address_mem0 = '0;
		address_mem1 = -1; 
		hcounter = '0;
		vcounter = '0;
		lenet_doing = '0;
		we = '0;
	end
    assign addr_mem0 = address_mem0;
    assign addr_mem1 = address_mem1;
	always_ff @(posedge clk25) begin : proc_25
		//if (address_mem1 >= 1) begin
		//   we <= '1;
		//end else begin
		//   we <= '0;
		//end
		if (counter >= c_frame) begin                                                                                                        // originally >= c_frame, but because of sync, we need to calculate until address_mem1 is c_frame + 1, so I changed >= to >            
			counter <= '0;
			hcounter <= -1;
			vcounter <= '0;
			address_mem0 <= '0;
            we <= '0; 
			dout <= '0;
			lenet_doing <= lenet_signal;  
		     
		end else begin
			address_mem0 <= address_mem0 + 1;
			counter <= counter + 1;
			if(hcounter == 0) begin
                we <= '1; 
            end
			if (hcounter >= width - 1) begin
                hcounter <= 0;
                vcounter <= vcounter + 1;
            end else begin
                hcounter <= hcounter + 1;
            end
			
            if (lenet_doing == 1'b1) begin 
                if (hcounter >= left && vcounter >= upper && hcounter < right && vcounter < downer) begin
                    if ((hcounter - left) % widthlength == 0 && (vcounter - upper) % heightlength ==0) begin
                        out_temp[(hcounter-left)/widthlength] = accu_temp[(hcounter-left)/widthlength];				                                // out temp is only used for vga out 
                        accu_temp[(hcounter-left)/widthlength] <= din[7:4] + widthlength * heightlength / 2;                                        // add widthlength * heightlength / 2, because I want to do round, not round down
                    end else begin
                        accu_temp[(hcounter-left)/widthlength] <= accu_temp[(hcounter-left)/widthlength] + din[7:4];                                 					
                    end
                        dout = $unsigned(out_temp[(hcounter-left)/widthlength]) / (widthlength * heightlength);                   
                   if ((hcounter - left) % widthlength == (widthlength - 1) && (vcounter - upper) % heightlength == (heightlength - 1)) begin       
                        addr_mem2 <= 2 + (hcounter - left) / widthlength + 32 * (vcounter - upper) / heightlength;
                        lenet_dout <= accu_temp[(hcounter-left)/widthlength] + din[7:4];
                        lenet_we <= 1'b1;
                    end
                     //dout = out_temp[(hcounter-left)/widthlength][ACC_D_SIZE:ACC_D_SIZE-3];
                    
                    if (vcounter - upper < heightlength) begin
                    	address_mem1 <= vcounter * width + hcounter + width * (lenet_size - 1) * heightlength;
                    end else begin
                    	address_mem1 <= vcounter * width + hcounter - width * heightlength;
                    end
                end else begin
                    dout <= din[7:4];
                    address_mem1 <= vcounter * width + hcounter;
                end
    
            end else begin
                dout <= din[7:4];
                address_mem1 <= vcounter * width + hcounter;
            end
		end
		
	end
endmodule // core
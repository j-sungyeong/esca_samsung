module vga	
			#(
            parameter widthlength = 8,
            parameter heightlength = 8,
            parameter lenet_size = 28,
			localparam hRez = 640,
			localparam hStartSync = 640 + 16,
			localparam hEndSync = 640 + 16 + 96,
			localparam hMaxCount = 800,

			localparam vRez = 480,
			localparam vStartSync = 480 + 10,
			localparam vEndSync = 480 + 10 + 2,
			localparam vMaxCount = 480 + 10 + 2 +33,

			localparam hsync_active = 1'b0,
			localparam vsync_active = 1'b0,
			
            localparam left = hRez / 2 - widthlength * lenet_size / 2,
            localparam right = hRez / 2 + widthlength * lenet_size / 2 + 1,
            localparam upper = vRez / 2 - heightlength * lenet_size / 2 - 1,
            localparam downer = vRez / 2 + heightlength * lenet_size / 2
			
			)
			(
			input	logic		clk25,
			output logic[3:0]	vga_red,
			output logic[3:0]	vga_green,
			output	logic[3:0]	vga_blue,
			output	logic 		vga_hsync,
			output logic		vga_vsync,
			output	logic[18:0]	frame_addr,
			input 	logic[3:0]	frame_pixel,
			input  logic      sw
			);



	logic [9:0]		hCounter = 10'b0;
	logic [9:0]		vCounter = 10'b0;
	logic [18:0]	address;
	logic 			blank = 1'b1;
	
	assign frame_addr = address;


	always_ff @(posedge clk25) begin : proc_2
		if (hCounter == hMaxCount-1) begin
			hCounter <= 10'b0;
			if (vCounter == vMaxCount-1) begin
				vCounter <= 10'b0;
			end	else begin
				vCounter <= vCounter+1;
			end
		end else begin
			hCounter <= hCounter+1;
		end

		if (blank == 1'b0) begin
		    if (sw) begin
                if ((hCounter == left || hCounter == right)&&(vCounter >= upper && vCounter <= downer)) begin
                    vga_red <= 4'b0;
                    vga_green <= 4'b1111;
                    vga_blue <= 4'b0;	
                end else if ((hCounter >= left && hCounter <= right)&&(vCounter == upper || vCounter == downer)) begin
                    vga_red <= 4'b0;
                    vga_green <= 4'b1111;
                    vga_blue <= 4'b0;	
                end else begin
                    vga_red <= frame_pixel;
                    vga_green <= frame_pixel;
                    vga_blue <= frame_pixel;
                end
            end else begin
                vga_red <= frame_pixel;
                vga_green <= frame_pixel;
                vga_blue <= frame_pixel;
            end
		end else begin
			vga_red <= 4'b0;
			vga_green <= 4'b0;
			vga_blue <= 4'b0;
		end

		if (vCounter >= vRez) begin
			address <= 19'b0;
			blank <= 1'b1;
		end else begin
			if (hCounter < 640) begin
				blank <= 1'b0;
				address <= address + 1;
			end else begin
				blank <= 1'b1;
			end
		end

		if (hCounter > hStartSync && hCounter <= hEndSync) begin
			vga_hsync <= hsync_active;
		end else begin
			vga_hsync <= ~hsync_active;
		end

		if (vCounter >= vStartSync && vCounter < vEndSync) begin
			vga_vsync <= vsync_active;
		end else begin
			vga_vsync <= ~vsync_active;
		end
	end
endmodule // vga
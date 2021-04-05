`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	input ctrl1, 
	input ctrl2, 
	input ctrl3, 
	input ctrl4,
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/kr211/Downloads/final2/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
	wire slowclock;
    wire slowerClock;
    
	reg[31:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	assign slowclock = pixCounter[20];
	assign slowerClock = pixCounter[22];
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA 

	reg signed[10:0] originx[9:0];
	reg signed[10:0] originy[9:0];
	reg[9:0] active_block = 0;
	integer i;
	initial begin
		originx[0] <= 10'd50;
		originy[0] <= 10'd50;
		for(i = 1; i < 10; i = i + 1) begin
			originx[i] <= 10'd0;
			originy[i] <= -10'd60;
		end
	end
	reg[9:0] xend_1, yend_1, xend_2, yend_2;
	reg active_reached = 0;
	always @(posedge slowerClock) begin
		originx[active_block] <= originx[active_block] - 25*ctrl1 + 25*ctrl2;
        // originx <= originx - ctrl2;
	    originy[active_block] <= originy[active_block] == VIDEO_HEIGHT - 50 ? originy[active_block] : originy[active_block] + 1;
		active_reached <= originy[active_block] == VIDEO_HEIGHT - 50;
		if(active_reached == 1) begin
			if(xend_1 > originx[active_block] || xend_1 == 0) begin
				xend_1 = originx[active_block];
			end
			if(xend_2 < originx[active_block] + 50 || xend_2 == 0) begin
				xend_2 = originx[active_block] + 50;
			end
			if(yend_1 > originy[active_block] || yend_1 == 0) begin
				yend_1 = originy[active_block];
			end
			if(yend_2 < originy[active_block] + 50 || yend_2 == 0) begin
				yend_2 = originy[active_block] + 50;
			end
			
			active_block <= active_block + 1;
			
			originy[active_block] <= 10'd50;
			active_reached <= 0;
		end
		// originy <= originy - ctrl4;
	end
	
	
    wire[9:0] x;
	wire[8:0] y;

	wire [9:0] xend;
	wire [8:0] yend;
	assign xend = originx[active_block] + 9'd50;
	assign yend = originy[active_block] + 8'd50;
	wire xgreater;
	wire xless;
	assign xgreater = x > originx[active_block];
	assign xless = x < xend;

	wire ygreater;
	wire yless;
	assign ygreater = y > originy[active_block];
	assign yless = y < yend;

	wire inside;
	//and insideand(inside, xgreater, xless, ygreater, yless);
	assign inside = ((x >= xend_1) & (x <= xend_2) & (y >= yend_1) & (y <= yend_2)) | (xless & yless & xgreater & ygreater);
	//assign inside = (xless & yless & xgreater & ygreater);
	wire active, screenEnd;

	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colortemp, colorOut; 			  // Output color 
	assign colortemp = active ? colorData : 12'd0; // When not active, output black
	assign colorOut = inside ? 12'd0 : colortemp;
	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule
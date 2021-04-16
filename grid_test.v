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
	//localparam FILES_PATH = "C:/Users/kr211/Downloads/final2/";
    localparam FILES_PATH = "";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
	wire slowclock;
    wire slowerClock;
    
	reg[31:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	assign slowclock = pixCounter[20];
	assign slowerClock = pixCounter[15];
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA 

	reg signed[10:0] originx[9:0];
	reg signed[10:0] originy[9:0];
    reg grid[15:0] [15:0];
    reg[6:0] active_cell_x = 0;
    reg[6:0] active_cell_y = 0;
	reg[9:0] active_block = 0;
    reg floor_reached = 0;
	integer i,m;
	initial begin
		originx[0] <= 10'd50;
		originy[0] <= 10'd50;
		for(i = 0; i < 16; i = i + 1) begin
            for(m = 0; m < 16; m = m + 1) begin
			    grid[i][m] <= 0;
            end
		end
        active_cell_x <= 0;
        active_cell_y <= 0;
        grid[0][0] <= 1;
	end
    reg blocked = 0;
    
    always @(posedge slowerClock) begin
        blocked <= 0;
        floor_reached <= (active_cell_y >= 15) || (active_cell_y < 15 && grid[active_cell_y + 1][active_cell_x] == 1);
        /*if(floor_reached) begin
            grid[active_cell_y][active_cell_x] <= 1;
        end
        else begin
            if(ctrl1 == 0 && ctrl2 == 0)
                grid[active_cell_y-1][active_cell_x] <= 0;
            if(ctrl1 == 1 && ctrl2 == 0)
                grid[active_cell_y-1][active_cell_x+1] <= 0;
            if(ctrl1 == 0 && ctrl2 == 1)
                grid[active_cell_y-1][active_cell_x-1] <= 0;
        end*/
        if(grid[active_cell_y+1][active_cell_x + 1] == 1 & ctrl2) begin
            active_cell_x <= (active_cell_x - ctrl1 + ctrl2)< 0 ? 0 : active_cell_x - ctrl1;
            blocked <= 1;   
        end
        else if(grid[active_cell_y+1][active_cell_x - 1] == 1 & ctrl1) begin
            active_cell_x <= (active_cell_x - ctrl1 + ctrl2)< 0 ? 0 : active_cell_x +ctrl2; 
            blocked <= 1;
        end
        else
            active_cell_x <= (active_cell_x - ctrl1 + ctrl2)< 0 ? 0 : active_cell_x - ctrl1 + ctrl2;
        
        active_cell_y <= floor_reached ? active_cell_y : active_cell_y + 1;
        
        if(floor_reached) begin
            active_cell_y <= 0;
            active_cell_x <= 0;
        end
    end
    always @(negedge slowerClock) begin
        if(floor_reached) begin
            //$display("NEGEDGE");
            grid[active_cell_y][active_cell_x] <= 1;
        end
        else begin
            if((ctrl1 == 0 && ctrl2 == 0) | blocked)
                grid[active_cell_y-1][active_cell_x] <= 0;
            if(ctrl1 == 1 && ctrl2 == 0 && !blocked)
                grid[active_cell_y-1][active_cell_x+1] <= 0;
            if(ctrl1 == 0 && ctrl2 == 1 && !blocked)
                grid[active_cell_y-1][active_cell_x-1] <= 0;
        end
        grid[active_cell_y][active_cell_x] <= 1;
    end
	
    wire[9:0] x;
	wire[8:0] y;

	/*wire [9:0] xend;
	wire [8:0] yend;
	assign xend = originx[active_block] + 9'd50;
	assign yend = originy[active_block] + 8'd50;
	wire xgreater;
	wire xless;
	assign xgreater = x > originx[active_block];
	less = x < xend;

	wire ygreater;
	wire yless;
	assign ygreater = y > originy[active_block];
	assign yless = y < yend;
    */
	wire inside;
    reg xyinside = 0;
    reg[8:0] x2 = 25;
    reg[8:0] y2 = 25;
    integer j, k;
    always @(posedge slowerClock) begin
        for(j = 0; j < 16; j = j + 1) begin
            for(k = 0; k < 16; k = k + 1) begin
                if(grid[j][k] == 1) begin
                    if(inside == 0) begin
                        xyinside <= (y2 > j*50) & (y2 < (j+1)*50) & (x2 > k*50) & (x2 < (k+1) * 50);
                    end
                end
            end
        end
    end
	/*//and insideand(inside, xgreater, xless, ygreater, yless);
	assign inside = ((x >= xend_1) & (x <= xend_2) & (y >= yend_1) & (y <= yend_2)) | (xless & yless & xgreater & ygreater);
	//assign inside = (xless & yless & xgreater & ygreater);*/
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
    integer n;
    always @(posedge slowerClock) begin
        $display("active x: %d active y: %d, floor_reached: %b, right: %b", active_cell_x, active_cell_y, floor_reached, ctrl2);
        $display("inside: %d", inside);
        for(n = 0; n < 16; n = n + 1) begin
            $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", grid[n][0], grid[n][1], grid[n][2], grid[n][3], grid[n][4], grid[n][5], grid[n][6], grid[n][7], grid[n][8], grid[n][9], grid[n][10], grid[n][11], grid[n][12], grid[n][13], grid[n][14], grid[n][15]);
        end
    end
endmodule
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
	
    wire slowerClock;
    
	reg[31:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
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
    //reg[6:0] active_cell[3][4]; //2x4, active_cell[0] contains metadata ([0][0] is left most, [0][1] is right most)

    always @(posedge slowerClock) begin
        blocked <= 0;
        floor_reached <= (active_cell_y >= 15) || (active_cell_y < 15 && grid[active_cell_y + 1][active_cell_x] == 1);
        
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
    integer a, b, c;
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

        for(a = 0; a < 16; a = a+1) begin
            if(grid[a][0] & grid[a][1] & grid[a][2] & grid[a][3] & grid[a][4] & grid[a][5] & grid[a][6] & grid[a][7] & grid[a][8] & grid[a][9] & grid[a][10] & grid[a][11] & grid[a][12] & grid[a][13] & grid[a][14] & grid[a][15]) begin
            //if(grid[a][12] & grid[a][13] & grid[a][14] & grid[a][15]) begin
                for(b = 0; b < 16; b = b+1) begin
                    for(c = a; c > 0; c = c - 1) begin
                        grid[c][b] <= grid[c-1][b];
                    end
                    
                end
            end
        end
    end
	

    //VGA stuff
    wire[9:0] x;
	wire[8:0] y;

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


    integer n;
    always @(posedge slowerClock) begin
        $display("active x: %d active y: %d, floor_reached: %b, right: %b", active_cell_x, active_cell_y, floor_reached, ctrl2);
        $display("inside: %d", inside);
        for(n = 0; n < 16; n = n + 1) begin
            $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", grid[n][0], grid[n][1], grid[n][2], grid[n][3], grid[n][4], grid[n][5], grid[n][6], grid[n][7], grid[n][8], grid[n][9], grid[n][10], grid[n][11], grid[n][12], grid[n][13], grid[n][14], grid[n][15]);
        end
    end
endmodule
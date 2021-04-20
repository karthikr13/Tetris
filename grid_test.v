`timescale 1 ns/ 100 ps
module grid_test(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
    input enable,
	input ctrl1, 
	input ctrl2, 
    output [255:0]  grid_out);
	
	// Lab Memory Files Location
	//localparam FILES_PATH = "C:/Users/kr211/Downloads/final2/";
    localparam FILES_PATH = "";
    reg[255:0] grid_out_reg;
	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
	
    wire slowerClock;
    
	reg[31:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	assign slowerClock = pixCounter[0];
	always @(posedge clk) begin
        if(enable == 1) begin
            pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
        end
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA 

    reg grid[15:0] [15:0];
    reg floor_reached = 0;

	integer i,m;

	initial begin
		for(i = 0; i < 16; i = i + 1) begin
            for(m = 0; m < 16; m = m + 1) begin
			    grid[i][m] <= 0;
            end
		end
        for(i = 0; i < 2; i = i + 1) begin
            for(m = 0; m < 4; m = m + 1) begin
                active_cell_y[i][m] <= i;
                active_cell_x[i][m] <= m;
            end
        end
        for(i = 0; i < 256; i = i + 1) begin
            grid_out_reg[i] <= 0;
        end
	end
    reg blocked = 0;
    //reg signed[6:0] active_cell[2][4][2]; //2x4x2; [0][0] is top left, [1][3] is bottom right. if cell should be empty, it'll be set to -1
    reg signed[6:0] active_cell_y[1:0][3:0];
    reg signed[6:0] active_cell_x[1:0][3:0];
    integer yint, r;
    always @(posedge slowerClock) begin
        blocked <= 0;
        floor_reached <= 0;
        for(r=0; r <4; r = r + 1) begin
            if(!floor_reached)
                floor_reached <= (active_cell_y[1][r] >= 15) || grid[active_cell_y[1][r] + 1][active_cell_x[1][r]] == 1;
        end
        for(yint = 0; yint < 2; yint = yint + 1) begin
            if((active_cell_y[yint][3]==15  | (grid[active_cell_y[yint][3]+1][active_cell_x[yint][3] + 1] == 1)) & ctrl2 & !blocked) begin
                //active_cell_x <= (active_cell_x - ctrl1)< 0 ? 0 : active_cell_x - ctrl1;
                blocked <= 1;
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        active_cell_x[k][i] <= active_cell_x[k][i] - ctrl1;
                    end
                end   
            end
            else if(grid[active_cell_y[yint][0]+1][active_cell_x[yint][0] - 1] == 1 & ctrl1) begin
                //active_cell_x <= (active_cell_x - ctrl1)< 0 ? 0 : active_cell_x +ctrl2; 
                blocked <= 1;
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        active_cell_x[k][i] <= active_cell_x[k][i] + ctrl2;
                    end
                end   
            end
        else
            //active_cell_x <= (active_cell_x - ctrl1 + ctrl2)< 0 ? 0 : active_cell_x - ctrl1 + ctrl2;
            for(k = 0; k < 2; k = k+1) begin
                for(i = 0; i < 4; i = i + 1) begin
                    active_cell_x[k][i] <= active_cell_x[k][3]==15 ? active_cell_x[k][i] - ctrl1 : active_cell_x[k][i] - ctrl1 + ctrl2;
                end
            end   
        end

        for(k = 0; k < 2; k = k+1) begin
            for(i = 0; i < 4; i = i + 1) begin
                active_cell_y[k][i] <= floor_reached ? active_cell_y[k][i] : active_cell_y[k][i] + 1;
            end
        end   

        if(floor_reached) begin
            for(i = 0; i < 2; i = i + 1) begin
                for(m = 0; m < 4; m = m + 1) begin
                    active_cell_y[i][m] <= i;
                    active_cell_x[i][m] <= m;
                end
            end
        end
    end

    integer a, b, c;
    always @(posedge slowerClock) begin
        if(floor_reached) begin
        end
        else begin
            if((ctrl1 == 0 && ctrl2 == 0) | blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]] <= 0;
                    end
                end
            end
            if(ctrl1 == 1 && ctrl2 == 0 && !blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]+1] <= 0;
                    end
                end
            end
            if(ctrl1 == 0 && ctrl2 == 1 && !blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]-1] <= 0;
                    end
                end
            end
        end
        
        if(!floor_reached) begin
            for(k = 0; k < 2; k = k+1) begin
                for(i = 0; i < 4; i = i + 1) begin
                    grid[active_cell_y[k][i]][active_cell_x[k][i]] <= 1;
                end
            end
        end
        

        for(a = 0; a < 16; a = a+1) begin
            if(grid[a][0] & grid[a][1] & grid[a][2] & grid[a][3] & grid[a][4] & grid[a][5] & grid[a][6] & grid[a][7] & grid[a][8] & grid[a][9] & grid[a][10] & grid[a][11] & grid[a][12] & grid[a][13] & grid[a][14] & grid[a][15]) begin
                for(b = 0; b < 16; b = b+1) begin
                    for(c = a; c > 0; c = c - 1) begin
                        grid[c][b] <= grid[c-1][b];
                    end
                    
                end
            end
        end
    end
	
    always @(posedge slowerClock) begin
        if(floor_reached) begin
        end
        else begin
            if((ctrl1 == 0 && ctrl2 == 0) | blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]] <= 0;
                    end
                end
            end
            if(ctrl1 == 1 && ctrl2 == 0 && !blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]+1] <= 0;
                    end
                end
            end
            if(ctrl1 == 0 && ctrl2 == 1 && !blocked) begin
                for(k = 0; k < 2; k = k+1) begin
                    for(i = 0; i < 4; i = i + 1) begin
                        grid[active_cell_y[k][i]-1][active_cell_x[k][i]-1] <= 0;
                    end
                end
            end
        end
        
        if(!floor_reached) begin
            for(k = 0; k < 2; k = k+1) begin
                for(i = 0; i < 4; i = i + 1) begin
                    grid[active_cell_y[k][i]][active_cell_x[k][i]] <= 1;
                end
            end
        end
        

        for(a = 0; a < 16; a = a+1) begin
            if(grid[a][0] & grid[a][1] & grid[a][2] & grid[a][3] & grid[a][4] & grid[a][5] & grid[a][6] & grid[a][7] & grid[a][8] & grid[a][9] & grid[a][10] & grid[a][11] & grid[a][12] & grid[a][13] & grid[a][14] & grid[a][15]) begin
                for(b = 0; b < 16; b = b+1) begin
                    for(c = a; c > 0; c = c - 1) begin
                        grid[c][b] <= grid[c-1][b];
                    end
                    
                end
            end
        end
        for(i = 0; i < 256; i = i + 1) begin
            grid_out_reg[i] <= grid[i % 16][i / 16];
        end
    end
    assign grid_out = grid_out_reg;
  
    integer j, k;
  
    integer n;
    always @(posedge slowerClock) begin
        
        for(n = 0; n < 16; n = n + 1) begin
            $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", grid_out[n+0], grid_out[n+16], grid_out[n+32], grid_out[n+48], grid_out[n+64], grid_out[n+80], grid_out[n+96], grid_out[n+112], grid_out[n+128], grid_out[n+144], grid_out[n+160], grid_out[n+176], grid_out[n+192], grid_out[n+208], grid_out[n+224], grid_out[n+240]);
        end
    end
    
endmodule
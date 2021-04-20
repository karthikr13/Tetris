module grid_test_tb;
    reg clk = 0;
    reg l, r = 0;
    wire w2,w3,w4,w5,w6,w7,w8,w12,w13;
    wire[3:0] w9,w10,w11;
    wire[255:0] grid_out;
    //single_block_grid c(     
	grid_test c(
    clk, 			// 100 MHz System Clock
	 w2, 		// Reset Signal
	 
	 1'b0, 
	 r, 
    grid_out);
    integer i, n;
    initial begin
        for(i = 0; i < 150000000000; i = i + 1) begin
            if(i > 300000) begin
                r <= 1'b1;
            end
            #20
            clk = ~clk;
            //$display("%d", grid_out);
            //$display("%b", grid_out);
            /*for(n = 0; n < 16; n = n + 1) begin
                $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", grid_out[n+0], grid_out[n+16], grid_out[n+32], grid_out[n+48], grid_out[n+64], grid_out[n+80], grid_out[n+96], grid_out[n+112], grid_out[n+128], grid_out[n+144], grid_out[n+160], grid_out[n+176], grid_out[n+192], grid_out[n+208], grid_out[n+224], grid_out[n+240]);
            end*/
        end
    end

endmodule
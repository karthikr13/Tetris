module grid_test;
    reg clk = 0;
    reg l, r = 0;
    wire w2,w3,w4,w5,w6,w7,w8,w12,w13;
    wire[3:0] w9,w10,w11;
    VGAController c(     
	clk, 			// 100 MHz System Clock
	 w2, 		// Reset Signal
	 w3, 		// H Sync Signal
	 w4, 		// Veritcal Sync Signal
	 1'b0, 
	 r, 
	 w7, 
	 w8,
	w9,  // Red Signal Bits
	 w10,  // Green Signal Bits
	 w11,  // Blue Signal Bits
	 w12,
	 w13);
    integer i;
    initial begin
        for(i = 0; i < 1500000000000000; i = i + 1) begin
            if(i > 300000) begin
                r <= 1'b1;
            end
            #20
            clk = ~clk;
        end
    end

endmodule
module random_test;
    reg[4:0] rand;
    integer i;
    integer seed = 20;
    initial begin    
        for (i=0; i<15; i=i+1) begin
            rand = $urandom(seed)%10;
            $display("random from 0 to 10: %d",rand); 
        end 
        for (i=0; i<5; i=i+1) begin
            rand = $urandom%2;
            $display("random from 0 to 1: %d",rand); 
        end 
   end
endmodule
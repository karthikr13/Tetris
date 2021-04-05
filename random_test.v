//CANNOT USE THIS - NOT SYNTHESIZABLE
module random_test(a);
    reg seed = 20;


   output[10:0] a;
   assign a = $urandom(20);
   
   initial begin
       #20
       $display("A1: %d", a);
   end
endmodule
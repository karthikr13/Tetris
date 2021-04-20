module registertemp(read, writeIn, clock, writeenable, readenable, reset);
    input [31:0] writeIn;
    input clock, writeenable, readenable, reset;
    output [31:0] read;
    wire [31:0] dffout;

    dffe_ref a_dff0(.q(dffout[0]), .d(writeIn[0]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff1(.q(dffout[1]), .d(writeIn[1]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff2(.q(dffout[2]), .d(writeIn[2]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff3(.q(dffout[3]), .d(writeIn[3]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff4(.q(dffout[4]), .d(writeIn[4]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff5(.q(dffout[5]), .d(writeIn[5]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff6(.q(dffout[6]), .d(writeIn[6]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff7(.q(dffout[7]), .d(writeIn[7]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff8(.q(dffout[8]), .d(writeIn[8]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff9(.q(dffout[9]), .d(writeIn[9]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff10(.q(dffout[10]), .d(writeIn[10]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff11(.q(dffout[11]), .d(writeIn[11]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff12(.q(dffout[12]), .d(writeIn[12]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff13(.q(dffout[13]), .d(writeIn[13]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff14(.q(dffout[14]), .d(writeIn[14]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff15(.q(dffout[15]), .d(writeIn[15]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff16(.q(dffout[16]), .d(writeIn[16]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff17(.q(dffout[17]), .d(writeIn[17]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff18(.q(dffout[18]), .d(writeIn[18]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff19(.q(dffout[19]), .d(writeIn[19]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff20(.q(dffout[20]), .d(writeIn[20]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff21(.q(dffout[21]), .d(writeIn[21]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff22(.q(dffout[22]), .d(writeIn[22]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff23(.q(dffout[23]), .d(writeIn[23]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff24(.q(dffout[24]), .d(writeIn[24]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff25(.q(dffout[25]), .d(writeIn[25]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff26(.q(dffout[26]), .d(writeIn[26]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff27(.q(dffout[27]), .d(writeIn[27]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff28(.q(dffout[28]), .d(writeIn[28]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff29(.q(dffout[29]), .d(writeIn[29]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff30(.q(dffout[30]), .d(writeIn[30]), 
        .clk(clock), .en(writeenable), .clr(reset));
    dffe_ref a_dff31(.q(dffout[31]), .d(writeIn[31]), 
        .clk(clock), .en(writeenable), .clr(reset));
    assign read = dffout;

endmodule
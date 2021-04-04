module LedController(
    input        clk, 		// System Clock Input 100 Mhz
    output       audioOut,	// PWM signal to the audio jack	
    );	// Audio Enable

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency


	// Initialize the frequency array. FREQs[0] = 261
	// reg[10:0] FREQs[0:15];
	// initial begin
	// 	$readmemh("FREQs.mem", FREQs);
	// end


	// wire[10:0] freq;
	wire[20:0] CounterLimit;
	// assign freq = FREQs[switches];
	assign CounterLimit = 20'd63;
    // reg[3:0] counter = 0;
	////////////////////
	// Your Code Here //
	////////////////////
	wire pwmout;
	wire[6:0] duty_cycle;
	reg dividedClock = 0;
    reg clock50mhz = 0;
	reg[20:0] counter = 0;
    reg[20:0] counter2 = 0;
    reg[20:0] onoffcounter = 0;
    reg zeroorone = 0;
    reg reset = 0;
    reg data = 1;
    reg zero = 0;
    reg[20:0] dataCounter = 0;

	always @(posedge clk) begin
		if(counter < 2)
			counter <= counter + 1;
		else begin
			counter <= 0;
			clock50mhz <= ~clock50mhz;
		end

        
	end

    always @(posedge clock50mhz) begin
        if(counter2 <  CounterLimit)
            counter2 <= counter2 + 1;
        else begin
            counter2 <= 0;
            dividedClock = ~dividedClock;
        end
        if(dataCounter < 20'd20) begin
            zero <= 1;
            data <= 1;
            dataCounter <= dataCounter + 1;
        end else if(dataCounter < 20'd40) begin
            // $display("One");
            dataCounter <= dataCounter + 1;
            data <= 1;
            zero <= 0;
        end else if(dataCounter < 20'd63) begin
            // $display("Zero");
            dataCounter <= dataCounter + 1;
            data <= 0;
            zero <= 0;
        end else begin
            dataCounter <= 0;
        end
    end

    always @(posedge dividedClock) begin
        if(onoffcounter < 20'd400000)
            reset <= 0;
            onoffcounter <= onoffcounter + 1;
        else if(onoffcounter < 20'd400240)
            onoffcounter <= onoffcounter + 1;
            reset <= 1;
        else begin
            onoffcounter <= 0;
            reset <= 0;
            zeroorone <= ~zeroorone;
        end
    end

    // assign dividedClock = 1;

    //assign duty_cycle = reset ? 0
    wire zeroone;
    assign zeroone = zeroorone ? zero : data;
    assign audioOut = reset ? 1'b0 : zeroone;
	// assign duty_cycle = reset ? 7'd0 : 7'd64;
	// PWMSerializer pwm(dividedClock, 1'b0, duty_cycle, pwmout);
	// assign audioOut = pwmout;
    // always @(posedge clock50mhz) begin
    //     $display("data %b, reset %b, onoffcounter %d, dividedclock %b", data, reset, onoffcounter, dividedClock);
    // end
endmodule
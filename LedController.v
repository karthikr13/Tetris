module LedControllerFinal(
    input clk, 		// System Clock Input 100 Mhz
    input arduinoClock,
    input arduinoClock2,
    input CTRL_BEGIN, //system signal to begin reading data... sent to arduino?
    input[255:0] data,
    output[7:0]  ledOut,	// PWM signal to the audio jack
    output[7:0]  ledOut2,	// PWM signal to the audio jack
    output ready,
    output ready2,
    input tempfinished,
    output finished,
    output finished2);	// Signal to Arduino to start rendering

    /*
    * Inputs: Clock, arduinoclock, and a ready signal
        On ready signal, the controller will render values on the arduino from a data line.
    */

	// localparam MHz = 1000000;
	// localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	////////////////////
	// Your Code Here //
	////////////////////
	// reg dividedClock = 0;
    // reg clock50mhz = 0;
	// reg[20:0] counter = 0;
    reg[7:0] color = 8'b10011010;
    reg[7:0] colorMax = 8'b11111111;

    reg[7:0] dataCounter = 0;
    reg[7:0] dataCounterMax = 8'd127;
    reg[255:0] dataReg = 0;

    reg[7:0] color2 = 8'b10011010;
    // reg[7:0] colorMax = 8'b11111111;
    reg[7:0] dataCounter2 = 128;
    reg[7:0] dataCounterMax2 = 8'd255;

    reg readyReg = 0;
    wire datatemp1 = 256'd1;
    wire datatemp2 = 256'd2;
    wire datatemp3 = 256'b1 <<< 128;
    reg[4:0] newcounter = 0;
    reg latched = 0;
    reg latched2 = 0;
    reg latched3 = 0;
    reg finishedReg = 0;

    //testing
    
    reg[255:0] dataRegTest[3:0];
    

    always @(posedge arduinoClock) begin
        if(latched == 1) begin
            latched2 <= 0;
        end
//        if(dataReg == 0) begin
//            dataReg <= data;
//        end
        if(dataCounter < 128) begin
            latched2 <= 0;
            color <= dataReg[dataCounter] ? 8'b10011001 : 8'b11110000;
            // tempReg <= dataReg[8'b11111111-dataCounter];
            dataCounter <= dataCounter + 1;
            $display("totalReg: %b, Value: %b", dataReg, dataReg[dataCounter]);
        end else begin
            dataCounter <= 0;
            latched2 <= 1;
        end

        if(color < colorMax) begin
            color <= dataReg[dataCounter];
        end else begin
            color <= 0;
        end
    end

    always @(posedge arduinoClock2) begin
        if(latched == 1) begin
            latched3 <= 0;
        end
        if(dataCounter2 < 255) begin
            $display("totalReg: %b, Value: %b", dataReg, dataReg[dataCounter2]);

            // latched3 <= 0;
            color2 <= dataReg[dataCounter2] ? 8'b11111111 : 8'b10011001;
            // tempReg <= dataReg[8'b11111111-dataCounter2];
            dataCounter2 <= dataCounter2 + 1;
        end else begin
            dataCounter2 <= 128;
            latched3 <= 1;
        end

        if(color2 < colorMax) begin
            color2 <= dataReg[dataCounter2];
        end else begin
            color2 <= 0;
        end
    end

    always @(negedge clk) begin
        if (CTRL_BEGIN == 1) begin
            finishedReg <= 0;
            dataRegTest[0] <= 256'd1;
            dataRegTest[1] <= 256'd1 << 250;
            dataRegTest[2] <= 256'd1 <<< 250;
            dataRegTest[3] <= 256'd1 <<< 30;
            dataReg <= data;
            latched <= 1;
        end
        if((latched2 == 1 && latched3 == 1) || tempfinished == 1) begin
            latched <= 0;
            finishedReg <= 1;
        end
        // $display("start, latch, finish: %b, %b, %b", CTRL_BEGIN, latched, finished);
        // $display("%b", dataReg);
        $display("LED Conroller: Data: %b", data);
    end

    assign ledOut = color;
    assign ledOut2 = color2;
    assign ready = CTRL_BEGIN;
    assign ready2 = CTRL_BEGIN;
    assign finished = latched2;
    assign finished2 = latched3;
endmodule
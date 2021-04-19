module LedControllerFinal(
    input clk, 		// System Clock Input 100 Mhz
    input arduinoClock,
    input CTRL_BEGIN, //system signal to begin reading data... sent to arduino?
    input[255:0] data,
    output[7:0]  ledOut,	// PWM signal to the audio jack
    output ready,
    output temp);	// Signal to Arduino to start rendering

    /*
    * Inputs: Clock, arduinoclock, and a ready signal
        On ready signal, the controller will render values on the arduino from a data line.
    */

	// localparam MHz = 1000000;
	// localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	////////////////////
	// Your Code Here //
	////////////////////
	reg dividedClock = 0;
    reg clock50mhz = 0;
	reg[20:0] counter = 0;
    reg[7:0] color = 8'b10011010;
    reg[7:0] colorMax = 8'b11111111;

    reg[7:0] dataCounter = 0;
    reg[7:0] dataCounterMax = 8'd127;
    reg[255:0] dataReg = 0;

    reg readyReg = 0;
    wire datatemp1 = 256'd1;
    wire datatemp2 = 256'd2;
    wire datatemp3 = 256'b1 <<< 128;
    reg[4:0] newcounter = 0;
    reg tempReg = 0;

    always @(posedge arduinoClock) begin
//        if(dataReg == 0) begin
//            dataReg <= data;
//        end
        if(dataCounter <= 255) begin
            color <= dataReg[dataCounter] ? 8'b11111111 : 8'b0;
            tempReg <= dataReg[8'b11111111-dataCounter];

            dataCounter <= dataCounter + 1;
            $display("Counter: %d, Value: %b", dataCounter, dataReg[dataCounter]);
        end else begin
            dataCounter <= 0;
        end

        // if(color < colorMax) begin
        //     color <= color + 1;
        // end else begin
        //     color <= 0;
        // end
    end

    always @(posedge clk) begin
        if (CTRL_BEGIN == 1) begin
            // if(newcounter < 4) begin
            //     newcounter <= newcounter + 1;
            // end else begin
            //     newcounter <= 0;
            // end
            // if(newcounter == 0) begin
            //     // color <= 8'b11111111;
            //     dataReg <= datatemp1;
            // end else if (newcounter == 1) begin
            //     // color <= 8'b0;
            //     dataReg <= datatemp2;
            // end else if (newcounter == 2) begin
            //     // color <= 8'b11101110;
            //     dataReg <= datatemp3;
            // end else if (newcounter == 3) begin
            //     // color <= 8'b11110000;
            //     dataReg <= 256'b1<<<255;
            // end
            dataReg <= data;
        end
    end

    // always @(CTRL_BEGIN) begin
    //     dataReg <= data;
    //     //tell arduino to start
    //     readyReg <= 1;
    // end

    // outputreg <= reg[counter]
    assign temp = tempReg;
    assign ledOut = color;
    assign ready = CTRL_BEGIN;
endmodule
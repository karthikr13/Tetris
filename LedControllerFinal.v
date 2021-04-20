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
    output finished);	// Signal to Arduino to start rendering

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
    reg latched2 = 1;
    reg latched3 = 1;
    reg finishedReg = 0;

    always @(posedge arduinoClock) begin
        if(latched == 1) begin
            latched2 <= 0;
        end
//        if(dataReg == 0) begin
//            dataReg <= data;
//        end
        if(dataCounter < 128) begin
            // color <= dataReg[dataCounter] ? 8'b11111111 : 8'b11110000;
            // tempReg <= dataReg[8'b11111111-dataCounter];

            dataCounter <= dataCounter + 1;
            // $display("Counter1: %d, Value: %b", dataCounter, dataReg[dataCounter]);
        end else begin
            dataCounter <= 0;
            latched2 <= 1;
        end

        if(color < colorMax) begin
            color <= color + 1;
        end else begin
            color <= 0;
        end
    end

    always @(posedge arduinoClock2) begin
        if(latched == 1) begin
            latched3 <= 0;
        end
        if(dataCounter2 < 255) begin
            // color2 <= dataReg[dataCounter2] ? 8'b11111111 : 8'b11110000;
            // tempReg <= dataReg[8'b11111111-dataCounter2];

            dataCounter2 <= dataCounter2 + 1;
            // $display("Counter2: %d, Value: %b", dataCounter2, dataReg[dataCounter2]);
        end else begin
            dataCounter2 <= 128;
            latched3 <= 1;
        end

        if(color2 < colorMax) begin
            color2 <= color2 + 1;
        end else begin
            color2 <= 0;
        end
    end

    integer n;

    always @(posedge clk) begin
        if (CTRL_BEGIN == 1 && latched == 0) begin
            finishedReg <= 0;
            latched <= 1;
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

            for(n = 0; n < 16; n = n + 1) begin
                $display("%d %b %b %b %b %b %b %b %b %b %b %b %b %d %d %d", dataReg[n+0], dataReg[n+16], dataReg[n+32], dataReg[n+48], dataReg[n+64], dataReg[n+80], dataReg[n+96], dataReg[n+112], dataReg[n+128], dataReg[n+144], dataReg[n+160], dataReg[n+176], dataReg[n+192], dataReg[n+208], dataReg[n+224], dataReg[n+240]);
            end
        end
        if(latched2 == 1 && latched3 == 1) begin
            latched <= 0;
            finishedReg <= 1;
        end
    end

    // always @(CTRL_BEGIN) begin
    //     dataReg <= data;
    //     //tell arduino to start
    //     readyReg <= 1;
    // end

    // outputreg <= reg[counter]
    assign ledOut = color;
    assign ledOut2 = color2;
    assign ready = CTRL_BEGIN;
    assign ready2 = CTRL_BEGIN;
    assign finished = finishedReg;
endmodule
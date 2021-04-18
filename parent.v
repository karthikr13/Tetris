module parent(
    input arduinoClock,
    input clock,
    output[7:0] ledOut
);
    wire[255:0] values;
    reg[7:0] counter = 0;


    LedController controller(clock, ledOut, arduinoClock, /*ready*/, finished);

    karthikthing(values);

    always @(posedge arduinoClock) begin
        if(counter < 255) begin
            dataCounter <= dataCounter + 1;
        end else begin
            dataCounter <= 0;
        end
    end

endmodule
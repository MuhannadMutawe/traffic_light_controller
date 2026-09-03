// Code your testbench here
// or browse Examples
module tb_traffic_light_controller;

    logic clk;
    logic reset;
    logic [1:0] state;
    logic [3:0] counter;
    logic red, green, yellow;

    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .counter(counter),
        .red(red),
        .green(green),
        .yellow(yellow)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        reset = 1;

        repeat (2)
            @(posedge clk);

        reset = 0;

        repeat (40)
            @(posedge clk);

        $finish;
    end

    always @(posedge clk) begin
        if (!reset) begin
            if (state == 2'b00) begin
                if (!red || green || yellow)
                    $display("Error in RED state");
            end
            else if (state == 2'b01) begin
                if (red || !green || yellow)
                    $display("Error in GREEN state");
            end
            else if (state == 2'b10) begin
                if (red || green || !yellow)
                    $display("Error in YELLOW state");
            end
            else begin
                $display("Invalid state");
            end
        end
    end

    initial begin
        $monitor("Time=%0t Reset=%b State=%b Counter=%d R=%b G=%b Y=%b",
                 $time, reset, state, counter, red, green, yellow);
    end

endmodule
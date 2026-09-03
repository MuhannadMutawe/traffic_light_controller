// Code your design here
module traffic_light_controller (
    input logic clk,
    input logic reset,
    output logic [1:0] state,
    output logic [3:0] counter,
    output logic red,
    output logic green,
    output logic yellow);

    typedef enum logic [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= RED;
            counter <= 0;
        end
        else begin
            current_state <= next_state;

            if (current_state != next_state)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    always_comb begin
        next_state = current_state;

        if (current_state == RED) begin
            if (counter == 4)
                next_state = GREEN;
        end
        else if (current_state == GREEN) begin
            if (counter == 9)
                next_state = YELLOW;
        end
        else if (current_state == YELLOW) begin
            if (counter == 2)
                next_state = RED;
        end
        else begin
            next_state = RED;
        end
    end

    always_comb begin
        red = 0;
        green = 0;
        yellow = 0;

        if (current_state == RED)
            red = 1;
        else if (current_state == GREEN)
            green = 1;
        else if (current_state == YELLOW)
            yellow = 1;
        else
            red = 1;
    end

    always_comb begin
        state = current_state;
    end

endmodule
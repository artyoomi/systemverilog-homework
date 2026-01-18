//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module conv_last_to_first
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_last,
    input  [width - 1:0] up_data,

    output               down_valid,
    output               down_first,
    output [width - 1:0] down_data
);
    // Task:
    // Implement a module that converts 'last' input status signal
    // to the 'first' output status signal.
    //
    // See README for full description of the task with timing diagram.

    logic transmission_started;

    always_ff @ (posedge clock)
        if (reset) begin
            transmission_started <= '0;
        end else begin
            // We additionaly check up_last to prevent misdetection of case
            // where up_last signal is set in two bars in a row
            if (~transmission_started & up_valid & ~up_last) begin
                transmission_started <= '1;
            end else if (transmission_started & up_last) begin
                transmission_started <= '0;
            end
        end

    assign down_valid = up_valid;
    assign down_first = up_valid & ~transmission_started;
    assign down_data  = up_data;

endmodule

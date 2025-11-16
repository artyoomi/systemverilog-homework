//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts single-bit serial data to the multi-bit parallel value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits and receiving last 'serial_valid' input,
    // the module should assert the 'parallel_valid' at the same clock cycle
    // and output 'parallel_data' value.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [    width - 1:0] saved_serial_data;
    logic [$clog2(width):0] processed_count;

    // Control processed_count values
    always_ff @ (posedge clk)
        if (rst) begin
            processed_count <= '0;
        end else if (serial_valid) begin
            processed_count <= (processed_count == width - 1) ? ('0) : (processed_count + 1);
        end

    // Controls output and save logic
    always_comb begin
        // It will always being updated until processed_coun incremented
        saved_serial_data[processed_count] = serial_data;
        parallel_valid = 1'b0;

        if (serial_valid & processed_count == width - 1) begin
            parallel_valid = 1'b1;
            parallel_data  = saved_serial_data;
        end
    end

endmodule

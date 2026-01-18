//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module gearbox_1_to_2
# (
    parameter width = 0
)
(
    input                    clk,
    input                    rst,

    input                    up_vld,    // upstream
    input  [    width - 1:0] up_data,

    output                   down_vld,  // downstream
    output [2 * width - 1:0] down_data
);
    // Task:
    // Implement a module that transforms a stream of data
    // from 'width' to the 2*'width' data width.
    //
    // The module should be capable to accept new data at each
    // clock cycle and produce concatenated 'down_data'
    // at each second clock cycle.
    //
    // The module should work properly with reset 'rst'
    // and valid 'vld' signals

    logic               data_vld;
    logic [width - 1:0] data;

    always_ff @ (posedge clk)
        if (rst) begin
            data_vld <= '0;
            data     <=  0;
        end else begin
            if (~data_vld & up_vld) begin
                data_vld <= '1;
                data     <= up_data;
            end else if (data_vld & up_vld) begin
                data_vld <= '0;
            end
        end

    assign down_vld  = data_vld & up_vld;
    assign down_data = {data, up_data};

endmodule

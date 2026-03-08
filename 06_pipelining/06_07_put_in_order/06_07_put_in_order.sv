module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);

    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.

    // clog2 returns ceiling, so it is not necessary to add 1 to provide proper width
    logic [ $clog2(n_inputs) - 1 : 0 ] counter;
    // One-hot encoded counter representation
    logic [ n_inputs - 1 : 0 ] mask;

    logic [ n_inputs - 1 : 0 ]                  data_vlds;
    logic [ n_inputs - 1 : 0 ][ width - 1 : 0 ] data;

    // Logic to properly store incoming values
    always_ff @ (posedge clk)
        if (rst) begin
            data_vlds <= '0;
            data      <= '0;
        end else begin
            data_vlds <= (data_vlds | up_vlds);
            data      <= (data      | up_data);

            if (mask & data_vlds) begin
                if (mask & ~up_vlds) begin
                    data_vlds[counter] <= 1'b0;
                    data     [counter] <= '0;
                end else begin
                    data_vlds[counter] <= up_vlds[counter];
                    data     [counter] <= up_data[counter];
                end
            end
        end

    // Logic to control counter value and mask
    always_ff @ (posedge clk)
        if (rst) begin
            counter <= 0;
            mask    <= { {(n_inputs - 1){1'b0}}, 1'b1 };
        end else if (mask & data_vlds) begin
            counter <= counter + 1;
            // Shift to left
            mask    <= { mask[n_inputs - 2:0], mask[n_inputs - 1] };
        end

    assign down_vld  = data_vlds[counter];
    assign down_data = data[counter];

endmodule

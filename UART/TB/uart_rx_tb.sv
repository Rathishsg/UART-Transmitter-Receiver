module uart_rx_tb;

    logic clk;
    logic rst;
    logic rx;
    logic [7:0] rx_data;
    logic rx_done;

    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );


    initial clk = 0;
    always #5 clk = ~clk;
    task send_byte(input [7:0] data);
        integer i;
        begin
            rx = 0;  // Start bit
            #10;

            for (i = 0; i < 8; i++) begin
                rx = data[i];
                #10;
            end

            rx = 1; // Stop bit
            #10;
        end
    endtask

    initial begin
        rx = 1; // idle state
        rst = 1;
        #20;
        rst = 0;

        #20;
        send_byte(8'hA5); 

        #200;
        $finish;
    end

endmodule


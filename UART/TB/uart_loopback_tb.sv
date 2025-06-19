module uart_loopback_tb;

    logic clk;
    logic rst;
    logic tx_start;
    logic [7:0] tx_data;
    logic tx;
    logic tx_done;

    logic rx;
    logic [7:0] rx_data;
    logic rx_done;


    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(tx),            
        .rx_data(rx_data),
        .rx_done(rx_done)
    );


    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #20;
        rst = 0;


        @(posedge clk);
        tx_data = 8'b10101010;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait (tx_done);


        wait (rx_done);
        $display("TX sent: %b", tx_data);
        $display("RX got : %b", rx_data);

        #50;
        $stop;
    end

endmodule


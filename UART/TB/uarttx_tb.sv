module uart_tb;


    logic clk;
    logic rst;
    logic tx_start;
    logic [7:0] tx_data;


    logic tx;
    logic tx_done;


    uart_tx dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );


    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #20;
        rst = 0;

        #20;
        tx_data = 8'hA5;
        tx_start = 1;

        #10;
        tx_start = 0;
      
        wait (tx_done);

        #50;

        $finish;
    end

endmodule


`timescale 1ps/1ps
module test_dp_ram ();

    localparam DATA_WIDTH =8;
    localparam ADDR_WIDTH =9;// [7:0]dp_ram[0:8]

    reg r_clk,w_clk;
    reg r_enable,w_enable;
    reg [DATA_WIDTH-1:0]in_data;//write is in read is out
    reg [ADDR_WIDTH-1:0]in_addr,out_addr;
    wire [DATA_WIDTH-1:0]out_data;
    always #5 r_clk=~r_clk;
    always #6 w_clk=~w_clk;

    initial begin
        r_enable=1'b0;
        w_enable=1'b0;
        in_data='b1;
        in_addr='b1;
        out_addr='b1;
        r_clk=1'b0;
        #2 w_clk=1'b0;
        #10 r_enable=1;
        #100 w_enable=1;
        #10 in_data=8'b1110_0011;
        #100 w_enable=0;
        #10 $finish;
    end
    dp_ram u1(
                .r_clk(r_clk),
                .r_enable(r_enable),
                .r_addr(out_addr),
                .w_clk(w_clk),
                .w_enable(w_enable),
                .w_addr(out_addr),
                .w_data(in_data),
                .r_data(out_data)
                );

    initial begin
        $vcdpluson;
    end
endmodule
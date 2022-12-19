module dp_ram (
    w_clk,
    r_clk,
    w_enable,
    r_enable,
    w_addr,
    r_addr,
    w_data,
    r_data
);
    parameter RAM_WIDTH = 8;
    parameter RAM_DEPTH = 512;
    parameter ADDR_WIDTH =9;
    input w_clk;
    input r_clk;
    input w_enable;
    input r_enable;
    input [ADDR_WIDTH-1:0]w_addr;
    input [ADDR_WIDTH-1:0]r_addr;
    input [RAM_WIDTH-1:0] w_data;
    output [RAM_WIDTH-1:0] r_data;
    reg [RAM_WIDTH-1:0]r_data ;

    reg [RAM_WIDTH-1:0]memo[RAM_DEPTH-1:0] ;

    always @(posedge w_clk) begin
        if(w_enable) begin
            memo[w_addr]<=w_data;
        end
    end
    always @(posedge r_clk) begin
        if (r_enable) begin
            r_data<=memo[r_addr];
        end    
    end
endmodule
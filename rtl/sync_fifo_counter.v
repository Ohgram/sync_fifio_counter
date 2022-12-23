module sync_fifo_counter (
    clk,
    reset,
    r_enable,
    w_enable,
    r_data,
    w_data,
    full,
    empty,
    fcounter
);
    //all paramrter
    localparam DATA_WIDTH=8;
    localparam ADDR_WIDTH=9;
    //all in out
    input clk,reset,r_enable,w_enable;
    input [DATA_WIDTH-1:0]r_data,w_data;
    output full,empty;
    output [ADDR_WIDTH-1:0]fcounter;
    reg full,empty;
    reg [ADDR_WIDTH-1:0]fcounter;
    //all temp reg
    reg [ADDR_WIDTH-1:0]w_addr,r_addr;
    reg [DATA_WIDTH-1:0]memo[ADDR_WIDTH-1:0];


    //empty
    always @(posedge clk or negedge reset) begin
        if(fcounter==0||(fcounter=='b1&&r_enable==1)||!reset)
            empty<=1;
        else
            empty<=0;
    end
    //full
    always @(posedge clk or negedge reset) begin
        if (!reset)
            full<=0;
        else if(fcounter==ADDR_WIDTH-1||(fcounter==ADDR_WIDTH-2&&w_enable==1))
            full<=1;//when fcounter first time become to 0 or always turn 0 put full to 1
            else
            full<=0;
    end
    
    //counter
    always @(posedge clk or negedge reset) begin
        if(reset)
            fcounter<=9'b0;
        else if(empty==0&&r_enable==1)
            fcounter<=fcounter-1'b1;
        else if(full==0&&w_enable==1)
            fcounter<=fcounter+1'b1;
            
    end

    //write_address
    always @(posedge clk or negedge reset) begin
        if(!reset)
            w_addr<='b1;
        else if(empty==0&&w_enable==1)
            w_addr<=w_addr+1'b1;
            else
            w_addr<=w_addr;
    end
    //read_address
    always @(posedge clk or negedge reset) begin
        if(!reset)
            r_addr<='b1;
        else if(full==0&&r_enable==1)
            r_addr<=r_addr+1'b1;
        else
            r_addr<=r_addr;
    end

    my_dp_ram  u1(
            .r_clk(clk),
            .r_enable(r_enable),
            .r_addr(),
            .w_clk(clk),
            .w_enable(w_enable),
            .w_addr(),
            .w_data(w_data),
            .r_data(r_data)
);
endmodule
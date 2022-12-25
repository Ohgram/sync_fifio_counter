module sync_fifo_counter (
    reset,
    clk,
    r_enable,
    w_enable,
    w_data,
    r_data,
    full,
    empty,
    fcounter
);
    parameter DATA_WIDTH=8;
    parameter ADDR_WIDTH=9;

    input   reset;
    input   clk;
    input   r_enable;
    input   w_enable;
    input   [DATA_WIDTH-1:0] w_data;
    output  [DATA_WIDTH-1:0] r_data;
    output  full;
    output  empty;
    output  [ADDR_WIDTH-1:0] fcounter;

    wire  [DATA_WIDTH-1:0] r_data;
    reg  full;
    reg  empty;
    reg  [ADDR_WIDTH-1:0] fcounter;    
    
    reg [ADDR_WIDTH-1:0] r_addr;
    reg [ADDR_WIDTH-1:0] w_addr;

    //important my first time wrong
    wire r_allow=(r_enable&&!empty);
    wire w_allow=(w_enable&&!full);

    //empty
    always @(posedge clk or posedge reset) begin
        if(reset)
            empty<=1'b1;
        else
            empty<=(!w_enable&&(fcounter[8:1]==8'h0)&&((fcounter[0]==0)||r_enable));
    end

    //full
    always @(posedge clk or posedge reset) begin
        if(reset)
            full<=1'b0;
        else
            full<=(!r_enable&&(fcounter[8:1]==8'hFF)&&((fcounter[0]==1)||w_enable));
    end    
    
    //r_addr
    always @(posedge clk or posedge reset) begin
        if(reset)
            r_addr<='h0;
        else if(r_allow)
            r_addr<=r_addr+'b1;
    end

    //w_addr
    always @(posedge clk or posedge reset) begin
        if(reset)
            w_addr<='h0;
        else if(w_allow)
            w_addr<=w_addr+'b1;
    end

    //fcounter
    always @(posedge clk or posedge reset) begin
        if(reset)
            fcounter<='h0;
        else if((!r_allow&&w_allow)||(r_allow&&!w_allow))
            begin
                if(w_allow)
                    fcounter<=fcounter+'b1;
                else
                    fcounter<=fcounter-'b1;
            end
    end

    my_dp_ram  u1(
            .r_clk(clk),
            .r_enable(r_allow),
            .r_addr(r_addr),
            .w_clk(clk),
            .w_enable(w_allow),
            .w_addr(w_addr),
            .w_data(w_data),
            .r_data(r_data)
);





    // //empty
    // always @(posedge clk or posedge reset) begin
    //     if(fcounter==0||(fcounter=='b1&&r_enable==1)||!reset)
    //         empty<=1;
    //     else
    //         empty<=0;
    // end
    // //full
    // always @(posedge clk or posedge reset) begin
    //     if (!reset)
    //         full<=0;
    //     else if(fcounter==ADDR_WIDTH-1||(fcounter==ADDR_WIDTH-2&&w_enable==1))
    //         full<=1;//when fcounter first time become to 0 or always turn 0 put full to 1
    //         else
    //         full<=0;
    // end
endmodule
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
    wire w_allow,r_allow;

    assign w_allow=w_enable&&!full;
    assign r_allow=r_enable&&!empty;


    //empty
    always @(posedge clk or posedge reset) begin
        if(reset)
            empty<=1;
        else if(w_enable==0&&fcounter[8:1]=='h00)//whenever empty=1 the w_enable must=0
                if(fcounter[0]==0||r_enable==1)
                    empty<=1;
                else
                    empty<=0;
            else
                empty<=0;
    end
    //full
    always @(posedge clk or posedge reset) begin
        if (reset)
            full<=0;
        else if(r_enable==0&&fcounter[8:1]==8'hFF)
                if(fcounter[0]==1||w_enable==1)
                    full<=1;//when fcounter first time become to 0 or always turn 0 put full to 1
                else
                    full<=0;
            else
                full<=0;
    end
    //w_addr
    always @(posedge clk or posedge reset) begin
        if(reset)
            w_addr<='b0;
        else if(w_allow)
            w_addr<=w_addr+1'b1;
    end
    //r_addr
    always @(posedge clk or posedge reset) begin
        if(reset)
            r_addr<='b0;
        else if(r_allow)
            r_addr<=r_addr+1'b1;
    end

    //counter
    always @(posedge clk or posedge reset) begin
        if(reset)
            fcounter<=9'b0;
        else if(r_allow==1&&w_allow==0)
            fcounter<=fcounter-1'b1;
        else if(r_allow==0&&w_allow==1)
            fcounter<=fcounter+1'b1;
            
    end

    my_dp_ram  u1(
            .r_clk(clk),
            .r_enable(r_enable),
            .r_addr(r_addr),
            .w_clk(clk),
            .w_enable(w_enable),
            .w_addr(w_addr),
            .w_data(w_data),
            .r_data(r_data)
);
endmodule
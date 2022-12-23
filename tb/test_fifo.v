`timescale 1ns/1ns	//时间单位/精度
 
//------------<模块及端口声明>----------------------------------------
module tb_sync_fifo_cnt();
 
parameter   DATA_WIDTH = 8  ;			//FIFO位宽
parameter   DATA_DEPTH = 512 ;			//FIFO深度
 
reg									clk		;
reg									rst_n	;
reg		[DATA_WIDTH-1:0]			data_in	;
reg									rd_en	;
reg									wr_en	;
						
wire	[DATA_WIDTH-1:0]			data_out;	
wire								empty	;	
wire								full	;
wire	[$clog2(DATA_DEPTH) : 0]	fifo_cnt;
 
 
//------------<例化被测试模块>----------------------------------------
// sync_fifo_cnt
// #(
// 	.DATA_WIDTH	(DATA_WIDTH),			//FIFO位宽
//     .DATA_DEPTH	(DATA_DEPTH)			//FIFO深度
// )
sync_fifo_counter(
	.clk		(clk		),
	.reset		(rst_n		),
	.w_data	(data_in	),
	.r_enable		(rd_en		),
	.w_enable		(wr_en		),
                 
	.r_data	(data_out	),	
	.empty		(empty		),	
	.full		(full		),
	.fcounter	(fifo_cnt	)			
);
 
//------------<设置初始测试条件>----------------------------------------
initial begin
	clk = 1'b0;							//初始时钟为0
	rst_n <= 1'b0;						//初始复位
	data_in <= 'd0;		
	wr_en <= 1'b0;		
	rd_en <= 1'b0;
    #10 rst_n <= 1'b1;
    #10 rst_n <= 1'b0;
    //重复512次写操作，让FIFO写满 	
	repeat(512) begin		
		@(negedge clk)begin		
			// rst_n <= 1'b0;				
			wr_en <= 1'b1;		
			data_in <= $random;			//生成512位随机数
		end
	end
//重复512次读操作，让FIFO读空	
	repeat(512) begin
		@(negedge clk)begin		
			wr_en <= 1'b0;
			rd_en <= 1'd1;
		end
	end
//重复4次写操作，写入4个随机数据	
	repeat(4) begin
		@(negedge clk)begin		
			wr_en <= 1'b1;
			data_in <= $random;	//生成8位随机数
			rd_en <= 1'b0;
		end
	end
//持续同时对FIFO读写，写入数据为随机数据	
	forever begin
		@(negedge clk)begin		
			wr_en <= 1'b1;
			data_in <= $random;	//生成8位随机数
			rd_en <= 1'b1;
		end
	end
end
initial begin
    #21000 $finish;
end 
//------------<设置时钟>----------------------------------------------
always #10 clk = ~clk;			//系统时钟周期20ns

    initial begin
        $vcdpluson;
    end

endmodule
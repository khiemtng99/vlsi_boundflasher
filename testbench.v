module testbench;

parameter MAX = 15;
parameter HALF_CYCLE = 5;
parameter CYCLE = HALF_CYCLE * 2;

reg clk;
reg rst;
reg flick;
wire [MAX:0] led;

boundflasher boundflasher_test(.led(led), .clk(clk), .rst(rst), .flick(flick));

initial begin
	clk = 1'b1;
	forever #HALF_CYCLE clk = !clk;
end

initial begin
	// normal operation
	rst = 1'b0;
	flick = 1'b0;
	#(CYCLE*1) rst = 1'b1;
	#(CYCLE*1) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	//kick_back_point1_check
	#(CYCLE*60) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*26) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	//kick_back_point2_check
	#(CYCLE*60) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*38) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	//kick_back_point3_check
	#(CYCLE*30) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*43) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	//non_kick_back_point_check
	#(CYCLE*30) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*10) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*10) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*10) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*8) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*10) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	//reset_signal_check2
	#(CYCLE*20) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	#(CYCLE*43) rst = 1'b0;	
	
	//reset_signal_check1
	#(CYCLE*5) flick = 1'b1;
	#(CYCLE*1) flick = 1'b0;
	
	
	#(CYCLE*5) $finish;
end

always @ (posedge clk) begin
	$display ("t = %d, rst = %b, clk = %b, flick = %b, state = %d, led = %b", $stime, rst, clk, flick, boundflasher_test.state, led);
end

initial begin
	$recordfile ("waves");
  	$recordvars ("depth = 0", testbench);
end

endmodule 
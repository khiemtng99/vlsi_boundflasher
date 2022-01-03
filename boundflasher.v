module boundflasher(led, clk, rst, flick);

parameter MAX = 15;

output reg [MAX:0]led;
input clk;
input flick;
input rst;
reg [MAX:0]led_next;
reg [2:0]state;

always @ (flick or clk) begin
	case (state)
	// state 0
	3'b000: begin				
			if(flick == 1'b1) 
				state = 3'b001;
			else
				led_next[MAX:0] = 16'b0;
		end
	// state 1
	3'b001: begin				
			if(led[15] == 1'b1) 
				state = 3'b010;
			else
				led_next[MAX:0] = {led[MAX - 1:0], 1'b1};
		end		
	// state 2
	3'b010: begin				
			if(led[5] == 1'b0) begin
				if(flick == 1'b1)
					state = 3'b001;
				else
					state = 3'b011;
			end
			else
				led_next[MAX:0] = {1'b0, led[MAX:1]};
		end
	// state 3
	3'b011: begin				
			if(led[10] == 1'b1) 
				state = 3'b100;
			else
				led_next[MAX:0] = {led[MAX - 1:0], 1'b1};
		end
	// state 4		
	3'b100: begin		
			if((led[0] == 1'b0 || led[5:4] == 2'b01) && flick == 1'b1) 
				state = 3'b011;
			else if(led[0] == 1'b0 && flick == 1'b0)
				state = 3'b101;
			else 
				led_next[MAX:0] = {1'b0, led[MAX:1]};
		end
	// state 5	
	3'b101: begin				
			if(led[5] == 1'b1) 
				state = 3'b110;
			else 
				led_next[MAX:0] = {led[MAX - 1:0], 1'b1};
		end
	// state 6		
	3'b110: begin				
			if(led[0] == 1'b0) 
				state = 3'b000;
			else
				led_next[MAX:0] = {1'b0, led[MAX:1]};
		end
	default: state = 3'b000;
	endcase
end

always @ (posedge clk or negedge rst) begin
	if(rst == 1'b0) begin
		led <= 16'b0;
		state <= 3'b0;
	end
	else begin
		led[MAX:0] <= led_next[MAX:0];
	end
end

endmodule

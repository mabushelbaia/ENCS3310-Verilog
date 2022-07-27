module Mohammad_1200198_21mux (out, A, B, sel);
	input A, B, sel;
	output out;
	assign out = (sel)? B: A;
endmodule

module Mohammad_1200198_7SEG (out, in);
	input [1:0] in;
	output reg [6:0] out;
	always @(*) begin
		case(in)
			0:out = 7'b0000001;
			1:out = 7'b1001111;
			2:out = 7'b0010010;
			3:out = 7'b0000110; 
			/*
			5:out = 7'b0100100;
			6:out = 7'b0100000;
			7:out = 7'b0001111;
			8:out = 7'b0000000;
			9:out = 7'b0000110;
			*/
		endcase
	end
endmodule

module Mohammad_1200198_Comparator (out_first, out_second, in_first, in_second); // 1200198 % 100 = 98
	input [6:0] in_first, in_second;
	output out_first, out_second;
	assign out_first = (in_first == 7'b0010010)? 1 : 0; // first-digit
	assign out_second = (in_second == 7'b0000110)? 1: 0; // second-digit
endmodule

module Mohammad_1200198_DFF (D, CLK, Q);
	input D;
	input CLK;
	output reg Q;
	always @(posedge CLK) begin
		Q  <= D;  // (<=) is a non-blocking assignment used for sequential logic
	end
endmodule
	
module Mohammad_1200198_PriorityEncoder (out, in);
	input [3:0] in;
	output reg [1:0] out;
	always @(*) begin
		casex(in)
			4'b0001: out = 2'b00;
			4'b001x: out = 2'b01;
			4'b01xx: out = 2'b10;
			4'b1xxx: out = 2'b11;
			default: out = 2'b00;
		endcase
	end
endmodule


module MUX41(input [3:0] X,input [1:0] S, output Y);	   						//#17ns (AND, OR) #13ns (NAND)
	wire [3:0]	Z;
	wire [1:0]	Si;																// Complement
	not  #(3ns) (Si[0], S[0]), (Si[1], S[1]);
	nand #(5ns) (Z[0], X[0], Si[1], Si[0]), (Z[1], X[1], Si[1], S[0]), 	
				(Z[2], X[2], S[1], Si[0]), (Z[3], X[3],S[1], S[0]),
				(Y, Z[0], Z[1], Z[2], Z[3]); 
endmodule



module Full_Adder(input a, b, c, output carry, sum); 									// SUM #11ns , Carry #10ns
	wire z1, z2, z3;
	xor  	#(11ns) (sum, a, b, c);		
	nand 	#(5ns)  (z1, a, b), (z2, a, c), (z3, b, c), (carry, z1, z2, z3);
endmodule



module Ripple_Adder(input [3:0]A, B, input cin, output [4:0] SUM);	// #41ns										
	wire [4:0] c;
	genvar i; 
	assign c[0] = cin,
		   SUM[4] = c[4];  // we assigned it to zero here to check the verification unit.
	generate
		for (i=0; i < 4; i = i + 1) 
				Full_Adder FA(A[i], B[i], c[i], c[i+1], SUM[i]);
	endgenerate	
endmodule 



module LookAhead_Addder(input [3:0] A, B, input cin, output [4:0] SUM); // 32ns	
	wire [3:0] P, G, Gi;
	wire [4:0] C;
	wire [9:0] Z;
	assign C[0] = cin, SUM[4] = C[4];
	genvar i;
	generate
	for(i=0; i < 4; i = i + 1)	// 4 - 4 - 8
		begin
		xor  #(11ns) (P[i], A[i], B[i]); 
		not  #(3ns)  (G[i], Gi[i]);
		nand #(5ns)	(Gi[i], A[i], B[i]);
		xor  #(11ns) (SUM[i], P[i], C[i]);  
		end
	endgenerate
	 
	// C1   = 	 G0 + P0Cin
	// NAND = 	(G0' . (POCin)')'  
	nand  #(5ns)  				// we flipped it to and here to check the verification unit.
	(C[1], Gi[0], Z[0]), 
	(Z[0], P[0], C[0]); 
	// C2   = 	 G1 + P1G0 + P1P0Cin 			
	// NAND =	(G1' . (P1G0)' . (P1P0Cin)')'
	nand  #(5ns)
	(C[2], Gi[1], Z[1], Z[2]), 
	(Z[1], P[1], P[0], C[0]),
	(Z[2], P[1], G[0]),	 
	// C3   =	 G2 + P2G1 + P2P1G0 + P2P1P0Cin	
	// NAND =	(G2' . (P2G1)' . (P2P1G0)' . (P2P1P0Cin)')'
	(C[3], Gi[2], Z[3], Z[4], Z[5]), 
	(Z[3], P[2], P[1], P[0], C[0]), 
	(Z[4], P[2], P[1], G[0]), 
	(Z[5], P[2], G[1]),
	// C4   =  	 G3 + P3G2 + P3P2G1 + P3P2G1	+ P3P2P1G0 + P3P2P1P0Cin 
	// NAND =	(G3' . (P3G2)' . (P3P2G1)' . (P3P2G1)'	. (P3P2P1G0)' . (P3P2P1P0Cin)')'
	(C[4], Gi[3], Z[6], Z[7], Z[8], Z[9]), 
	(Z[6], P[3], P[2], P[1], P[0], C[0]), 
	(Z[7], P[3], P[2], P[1], G[0]), 
	(Z[8], P[3], P[2], G[1]), 
	(Z[9], P[3], G[2]);  
endmodule



module Arithmetic_Unit(input [3:0] A, B, input [2:0] mode, output [4:0] D);	 //54ns	39ns
	wire [3:0] Bi, Z;
	genvar i;
	generate
	for (i=0; i < 4; i = i + 1) begin
			not #(3ns) (Bi[i], B[i]);
			MUX41 M4({1'b1,1'b0, Bi[i], B[i]}, mode[2:1], Z[i]);	
		end
	endgenerate	
	//	Ripple_Adder 	 RA(A, Z, mode[0], D[4:0]);		 //Stage 1
	LookAhead_Addder LA(A, Z, mode[0], D[4:0]);	 		 //Stage 2
endmodule



module Tests_Generator(input clk, output reg [3:0] A, B,output reg [2:0] MODE, output reg [4:0] RES);
	integer counter=0, enabled=1;
	always @ (posedge clk)
		if (enabled) begin
			{MODE, A, B} = counter;
			counter = counter + 1;
			case (MODE)
				0: RES = A + B;
				1: RES = A + B + 1'b1;
				2: RES = A + {1'b0,~B};
				3: RES = A + {1'b0,~B}+ 1'b1;
				4: RES = A;
				5: RES = A + 1'b1;
				6: RES = A + 4'b1111;
				7: RES = {1'b1,A};				  
			endcase			
				
			if (counter == 2**11) enabled = 0;	
		end
endmodule



module Analyzer(input clk, input [4:0] EXPECTED_RESULT, ACCTUAL_RESULT, input [2:0] mode, input [3:0] A, B); 
	always @ (negedge clk)
		if (ACCTUAL_RESULT != EXPECTED_RESULT)
			$display("ERROR: EXPECTED_RESULT=%b , ACCTUAL_RESULT=%b, MODE=%b, A=%b, B=%b" , ACCTUAL_RESULT, EXPECTED_RESULT, mode, A, B);
endmodule



module System;
	reg  [3:0] A, B;
	reg  [2:0] MODE;					
	reg	 [4:0] ACCTUAL_RESULT;
	wire [4:0] EXPECTED_RESULT;
	reg clk = 0;
	Tests_Generator 	TG (clk, A, B, MODE, EXPECTED_RESULT);
	Arithmetic_Unit 	AU (A, B, MODE, ACCTUAL_RESULT); 
	Analyzer			AZ (clk, EXPECTED_RESULT, ACCTUAL_RESULT, MODE, A, B);
	always #54ns clk = ~clk; // 54 or 45
	initial #250us $finish;
endmodule

//Extra Test
module Test;
	reg [3:0] A, B;
	reg CIN;
	wire [4:0] RESULT;
	integer counter = 0, counter2 = 1, maxtime = 0;
	integer ctime;
	//LookAhead_Addder 	AU (A, B, CIN, RESULT);
	Ripple_Adder 	AU (A, B, CIN, RESULT);
	initial begin
		{A, B, CIN} = counter;
		counter = counter + 1;
		ctime = $time;
		repeat(2**9 - 1)begin
			#70ns
			{A, B, CIN} = 11'bx;
			#70ns
			{A, B, CIN} = counter;
			counter = counter + 1;
			ctime = $time;
		end
		#100ns $display("MAX TIME = %0d", maxtime);
	end
	always @ (RESULT)
		if (RESULT == A + B + CIN) begin	
			$display("Time %0d | A = %b | B = %b | CIN = %b | RESULT = %b | %0d", ($time - ctime)/1000, A, B, CIN, RESULT,counter2);
			counter2 = counter2 + 1;
			maxtime = ($time - ctime > maxtime)? $time-ctime : maxtime;
			end
endmodule
	
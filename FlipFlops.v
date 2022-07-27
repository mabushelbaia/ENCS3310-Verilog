module DFF(input D, CLK, R, output reg Q, Qc); 
	assign Qc = ~Q;
	always @(posedge CLK, negedge R)
		if(~R)
			Q <= 0;
		else
			Q <= D;
endmodule	   


module TFF(input T, CLK, R, output reg Q, Qc);
	assign Qc = ~Q;
	always @(posedge CLK, negedge R)
		if(~R)
			Q <= 0;
		else
			Q <= T ^ Q;
endmodule	 


module JKFF(input J, K, CLK, R, output reg Q, Qc);
	assign Qc = ~Q;
	always @(posedge CLK, negedge R)
		if(~R)
			Q <= 0;
		else
			Q <= J&~Q + ~K&Q;
endmodule	   
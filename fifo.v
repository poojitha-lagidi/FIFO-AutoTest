module fifo
#(parameter fifo_depth = 8, //number of locations
parameter data_width = 32) //number of bits 
(input clk, 
 input reset,
 input cs, //chip select: when set, module is operational
 input wr_en, // enable write operation when set
 input rd_en, // enable read operation when set
 input [data_width-1:0] data_in,
 output reg [data_width-1:0] data_out,
 output empty,
 output full);
 localparam fifo_depth_log = $clog2(fifo_depth);
// declare bidimensional array to store data
reg [data_width-1:0] fifo [0:fifo_depth-1];
reg [fifo_depth_log:0] write_pointer;
reg [fifo_depth_log:0] read_pointer;
//write_pointer
always @ (posedge clk or negedge reset) begin
	if(!reset)
		write_pointer <= 0;
	else if(cs && wr_en && !full)
		write_pointer <= write_pointer +1'b1;
end
//read_pointer
always @ (posedge clk or negedge reset) begin
	if(!reset)
		read_pointer <= 0;
	else if(cs && rd_en && !empty)
		read_pointer <= read_pointer +1'b1;
end
// declare full/empty logic
// If empty == 0 --> This means the FIFO is not empty and there is aleast one data element that can be read.
// If empty == 1 --> This means the FIFO is empty and there is no data element that can be read.
// If full == 0 --> This means the FIFO is not full. There is still space available to write more data into the FIFO.
// If full == 1 --> This indicates that the FIFO is full. No more data can be written into the FIFO until some data is read out, freeing up space.
assign empty = (read_pointer == write_pointer);
assign full = (read_pointer == {~write_pointer[fifo_depth_log], write_pointer[fifo_depth_log-1:0]});
// write data
always @ (posedge clk or negedge reset) begin
	if(cs && wr_en && !full) 
		fifo[write_pointer[fifo_depth_log-1:0]] <= data_in;
end
// read data
always @ (posedge clk or negedge reset) begin
	if(!reset) 
		data_out <= 0;
	else if(cs && rd_en && !empty)
		data_out <= fifo[read_pointer[fifo_depth_log-1:0]];
end
endmodule

`timescale 1us/1ns
module fifo_tb;
parameter data_width = 8;
parameter fifo_depth = 8;
reg clk = 0;
reg reset;
reg cs;
reg wr_en;
reg rd_en;
reg [data_width-1:0] data_in;
wire [data_width-1:0] data_out;
wire empty;
wire full;
integer i;
integer success_count, error_count, test_count;
fifo #(.data_width(data_width), .fifo_depth(fifo_depth)) FIFOS (
			.clk(clk),
			.reset(reset),
			.cs(cs),
			.wr_en(wr_en),
			.rd_en(rd_en),
			.data_in(data_in),
			.data_out(data_out),
			.empty(empty),
			.full(full));
always begin #0.5 clk=~clk; end
task write_data (input [data_width-1:0] data);
	begin
		@(posedge clk);
		cs = 1; wr_en = 1;
		data_in = data;
		$display($time, " WRITE data_in=%d", data_in);
		@(posedge clk); cs =1; wr_en = 0;
	end
endtask
task read_data (input [data_width-1:0] expected_data);
	begin
		@(posedge clk);
		cs = 1; rd_en = 1;
		@(posedge clk);
		#0.1;
		$display($time, " READ data_out=%d", data_out);
		compare_data(expected_data, data_out);
		cs =1; rd_en = 0;
	end
endtask
task compare_data (input [data_width-1:0] expected_data, input [data_width-1:0] observed_data);
begin
	if (expected_data === observed_data) begin
		$monitor($time, " SUCCESS expected_data=%d, observed_data=%d", expected_data, observed_data);
		success_count = success_count + 1;
	end else begin
		$monitor($time, " ERROR expected_data=%d, observed_data=%d", expected_data, observed_data);
		error_count = error_count + 1;
	end
	test_count = success_count + error_count;
end
endtask
initial begin
success_count = 0; error_count = 0; test_count = 0;
#1;
reset = 0; rd_en = 0; wr_en = 0;
#1.3; reset = 1;
// SCENARIO 1
$display($time, " SCENARIO 1"); 
write_data(25);
write_data(30);
write_data(100);
read_data(25);
read_data(30);
read_data(100);
read_data(0); // This will throw an error because the FIFO is empty and there is no data to read
// SCENARIO 2
$display($time, " SCENARIO 2"); 
for (i=0; i<fifo_depth; i = i+1) begin
	write_data(2**i);
	read_data(2**i);
end
// SCENARIO 3
$display($time, " SCENARIO 3"); 
for (i=0; i<=fifo_depth; i = i+1) begin // at i=fifo_depth, FIFO will be already full, hence the write operation will be ignored 
	write_data(2**i);
end
write_data(10); // FIFO is full, hence the write operation will be ignored
for (i=0; i<fifo_depth; i = i+1) begin
	read_data(2**i);
end
#1;
$display($time, " TEST RESULTS success_count=%d, error_count=%d, test_count=%d", success_count, error_count, test_count);
#40; $stop;
end
endmodule

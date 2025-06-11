module bytesCounterRX #(

	parameter MAX_COUNT = 65536

)(
    input logic clk,
    input logic rst,
    input logic rxDone,
    output logic [31:0] byte_count
);

logic rxDone_prev;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        byte_count <= 0;
        rxDone_prev <= 1;
    end else begin
        rxDone_prev <= rxDone;
        if ((rxDone & ~rxDone_prev) && byte_count <= MAX_COUNT ) begin
            byte_count <= byte_count + 1;
        end
    end
end

endmodule

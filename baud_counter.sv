module baud_counter (
    input  logic clk,
    input  logic rst,
    input  logic enable,         // Habilita conteo
    output logic baud_tick       // Señal de un ciclo (pulso) cuando se completa el conteo
);

    localparam integer COUNT_MAX = 4340 - 1;  // -1 porque se cuenta desde 0

    logic [12:0] count;  // 13 bits porque 2^13=8192 > 4340

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            baud_tick <= 0;
        end else if (enable) begin
            if (count == COUNT_MAX) begin
                count <= 0;
                baud_tick <= 1;
            end else begin
                count <= count + 1;
                baud_tick <= 0;
            end
        end else begin
            count <= 0;
            baud_tick <= 0;
        end
    end

endmodule

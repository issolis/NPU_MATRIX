module CounterWithPress (
    input  logic clk,       // Clock principal (rápido)
    input  logic rst,       // Reset
    input  logic press,     // Botón (activo alto)
    output logic [31:0] count // Salida del contador
);

    // ===== Divisor de frecuencia =====
    parameter DIV = 24'd12_000_000; // Aproximadamente 2 Hz si clk = 24 MHz
    logic [$clog2(DIV)-1:0] div_cnt = 0;
    logic slow_clk = 0;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt  <= 0;
            slow_clk <= 0;
        end else if (div_cnt == DIV-1) begin
            div_cnt  <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            div_cnt <= div_cnt + 1;
        end
    end

    // ===== Detección de flanco de presionado =====
    logic press_prev;
    wire press_edge = press & ~press_prev;

    always_ff @(posedge slow_clk or posedge rst) begin
        if (rst)
            press_prev <= 0;
        else
            press_prev <= press;
    end

    // ===== Contador =====
    always_ff @(posedge slow_clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (press_edge)
            count <= count + 1;
    end

endmodule

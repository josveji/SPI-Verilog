/* 
Tarea 4
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código que implementa el
módulo Trasmitter_SPI (Master). 
*/

// Declaración del módulo 

module transmitter_SPI(
    // Inputs
    clk, rst, CPH, CKP, MISO,
    data, strt,
    // entrada para inciar lectura?   
    // Outputs
    MOSI, SCK, CS
    ); 

    // Declaración de entradas
    input clk, rst, CPH, CKP, strt, MISO; 
    input [7:0] data;

    // Declaración de salidas
    output [7:0] MOSI; 
    output SCK, CS; 

    // Variables internas
    reg [2:0] state, nx_state;
    reg [3:0] count_bit, nx_count_bit; 

    // quizás sea de utilidad una señal que indique transaccion completada

    // Asignando estados
    localparam WAITING = 2'b00;
    localparam START = 2'b01; 
    localparam TRANSFER = 2b'10;

  // Declarando FFs
    always @(posedge clk) begin
        if (!rst) begin
            state <= WAITING;
            count_bit = 0;

        end else begin
            state <= nx_state;
            count_bit <= nx_count_bit;
        end
    end // Fin declaración de FFs

    // Declaracación lógica combinacional
    always @(*)begin
        nx_state = state; 
        nx_count_bit = count_bit;

        // Declarando modos de operación
        // Modo 00
        if (!CPH) // tal cosa else
        if (!CKP) // tal cosa else

        // En base a lo anterior se define SCK



        // Modo 01
        // Modo 10
        // Modo 11

        case(state)
            WAITING: begin 
                nx_count_bit = 0; 
                if (strt) nx_state = START;
            end
            
            START: begin 
                // activa CS, 
                // CS = 0; 

                // if (count_bit == 15): nx_state = WAITING; 
                
            end

            TRANSFER: begin 
                
            end


        endcase

    end



   





endmodule // Fin de declaración del módulo

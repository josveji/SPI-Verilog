/* 
Tarea 4
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código que implementa el
módulo Receiver_SPI (Slave). 
*/

// Declaración del módulo 

module receiver_SPI(
    // Inputs
    clk,     // Clock, viene del CPU
    rst,     // Reset del sistema
    CPH,     // Define el flanco de SCK 
    CKP,     // Define la polaridad de SCK
    MOSI,    // Recibe bit por bit la información enviada por el Transmisor
    data_in, // Ingreso de dato que debe enviarse por MOSI
    SS,      // Prepara para iniciar el envío de información (CS)
    SCK,     // Reloj interno que sale del Transmisor
   
    // Outputs
    MISO    // Comunicación Receptor -> Transmisor, bit por bit
    ); 

    // Declaración de entradas (inputs)
    input clk, rst, CPH, CKP, MOSI, SS, SCK; 
    input [15:0] data_in; 

    // Declaración de salidas (outputs)
    output reg MISO;

    // Asignando estados
    localparam WAITING = 2'b00;
    localparam START = 2'b01; 
    localparam TRANSFER = 2'b10;
    
    // Para la frecuencia de SCK
    localparam DIV_FREQ = 2;

    // Variables internas
    reg [2:0] state, nx_state;         // Para manejar los estados
    reg [6:0] count_bit, nx_count_bit; // Para contar los bits que salen 
    reg [DIV_FREQ-1:0] div_freq;       // Para calcular SCK
    reg [15:0] inter_data, nx_inter_data;              // Variable interna, almacena data_in
    wire posedge_sck;                  // Capturar Posedge SCK
    wire negedge_sck;                  // Capturar Negedge SCK

    reg sck_anterior; 
    assign posedge_sck = !sck_anterior && SCK; // Flanco positivo de SCK
    assign negedge_sck = sck_anterior && !SCK; // Flanco negativo de SCK
    
    // Declarando FFs
    always @(posedge clk) begin
        if (!rst) begin
            state        <= WAITING;
            count_bit    <= 0;
            div_freq     <= 0;
            sck_anterior <= 0;
            inter_data <= 0; 
        end else begin
            state        <= nx_state;
            count_bit    <= nx_count_bit;
            div_freq     <= div_freq+1;
            sck_anterior <= SCK;
            inter_data   <= nx_inter_data ; 

        end
    end // Fin declaración de FFs

    // Declaración lógica combinacional
    always @(*)begin
        nx_state = state; 
        nx_count_bit = count_bit;
        nx_inter_data = inter_data;

        /*            CPK     CPH
            Modo 00    0       0
            Modo 01    0       1
            Modo 10    1       0
            Modo 11    1       1
        */
        
        case(state)
            WAITING: begin 
                nx_count_bit = 0; // Reinicia contador de bits
                if (!SS) nx_state = START; // Si se activa la señal SS negada
            end
            
            START: begin 
                /*Se preparan las condiciones para iniciar la transacción: 
                    - Se almacena el data_in en inter_data
                */ 
                nx_inter_data = data_in; // Se almacena data_in en inter_data 
                
                nx_state = TRANSFER;
 
            end

            TRANSFER: begin

                // Modo 00 (Posedge SCK)
                if (!CKP && !CPH) begin // Lógica para comunicación con Receptor
                    if (posedge_sck) begin 
                        MISO = inter_data[0];                    // Envía por MISO el bit menos significativo 
                        nx_inter_data = {MOSI, inter_data[15:1]}; // Coloca el bit de MOSI como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                    end 
                    /*
                        Esto es posible ya que conforme llegan bits desde MOSI los otros bits se desplazan a 
                        la derecha, con lo cual se puede solamente enviar el último bit (menos significativo). 
                        Lo cual elimina la necesidad de recorrer inter_data con count_bit. 
                    */

                end 
                
                // Modo 01 (Negedge SCK)
                if (!CKP && CPH) begin // Lógica para comunicación con Receptor
                    if (negedge_sck) begin 
                        MISO = inter_data[0];                    // Envía por MISO el bit menos significativo 
                        nx_inter_data = {MOSI, inter_data[15:1]}; // Coloca el bit de MOSI como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                        if (nx_inter_data == data_in && count_bit != 1) nx_state = WAITING; 
                    end
                end

                // Modo  10
                if (CKP && !CPH) begin // Lógica para comunicación con Receptor
                    if (posedge_sck) begin 
                        MISO = inter_data[0];                    // Envía por MISO el bit menos significativo 
                        nx_inter_data = {MOSI, inter_data[15:1]}; // Coloca el bit de MOSI como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                    end 
                end


                // Modo 11
                if (CKP && CPH) begin // Lógica para comunicación con Receptor
                    if (negedge_sck) begin 
                        MISO = inter_data[0];                    // Envía por MISO el bit menos significativo 
                        nx_inter_data = {MOSI, inter_data[15:1]}; // Coloca el bit de MOSI como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                        if (nx_inter_data == data_in && count_bit != 1) nx_state = WAITING;
                    end 
                end
                
                // Si se enviaron todos los bits y estos llegaron de vuelta a las posiciones originales se termina
                else if (nx_count_bit == 48) nx_state = WAITING; // 32 para que de la vuelta completa (tomando en cuenta 2 receptores)

            end

        endcase

    end

endmodule // Fin de declaración del módulo

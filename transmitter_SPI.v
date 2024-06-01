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
    clk,     // Clock, viene del CPU
    rst,     // Reset del sistema
    CPH,     // Define el flanco de SCK 
    CKP,     // Define la polaridad de SCK
    MISO,    // Recibe bit por bit la información enviada por el Receptor
    strt,    // Inicia la operación de la interfaz
    data_in, // Ingreso de dato que debe enviarse por MOSI

    // Outputs
    MOSI,    // Comunicación Transmisor -> Receptor, bit por bit
    SCK,     // Reloj interno que se transmite al Receptor
    CS       // Indica que va a enviar información al Receptor
    ); 

    // Declaración de entradas (inputs)
    input clk, rst, CPH, CKP, strt, MISO; 
    input [7:0] data_in; 

    // Declaración de salidas (outputs)
    output reg CS, MOSI; 
    output reg SCK;

    // Asignando estados
    localparam WAITING = 2'b00;
    localparam START = 2'b01; 
    localparam TRANSFER = 2'b10;
    
    // Para la frecuencia de SCK
    localparam DIV_FREQ = 2;

    // Variables internas
    reg [2:0] state, nx_state;         // Para manejar los estados
    reg [4:0] count_bit, nx_count_bit; // Para contar los bits que salen *******************Cambiar en caso de 16 
    reg [DIV_FREQ-1:0] div_freq;       // Para calcular SCK
    reg [7:0] inter_data, nx_inter_data;              // Variable interna, almacena data_in
    wire posedge_sck;                  // Capturar Posedge SCK
    wire negedfe_sck;                  // Capturar Negedge SCK

    reg sck_anterior; 
    //reg sck_adelanto; 
    // Para SCK y modos de operacion
    // assign SCK = div_freq[DIV_FREQ-1]; // Tomar bit más significativo (1/4 clk)
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

    // Declaracación lógica combinacional
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
                CS = 1; // Desactiva el Chip Select
                if (strt) nx_state = START; // Si se activa la señal strt
                // else if (get) // 
            end
            
            START: begin 
                /*Se preparan las condiciones para iniciar la transacción: 
                    - Se activa CS en bajo
                    - Operaciones para configurar SCK según el modo deseado
                    - Se almacena el data_in en inter_data
                    - Configurar polaridad de SCK
                */ 
                nx_inter_data = data_in; // Hice un cambio acá 
                CS = 0; 
                if (CKP) begin 
                    SCK = 0; // Modo 1n
                    nx_state = TRANSFER;
                end 
                else if (!CKP) begin
                    SCK = 1;     // Modo 0n
                    nx_state = TRANSFER;
                end
 
            end

            TRANSFER: begin
                SCK = div_freq[DIV_FREQ-1]; // Inicia la oscilación de SCK 
                // Generar captura según modo de SCK

                // Modo n0 (Posedge SCK)
                if (!CPH) begin // Lógica para comunicación con Receptor
                    if (posedge_sck) begin 
                        MOSI = inter_data[0];                    // Envía por MOSI el bit menos significativo 
                        nx_inter_data = {MISO, inter_data[7:1]}; // Coloca el bit de MISO como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                    end 
                    /*
                        Esto es posible ya que los conforme llegan bits desde MOSI los otros bits se desplazan a 
                        la derecha, con lo cual se puede solamente enviar el último bit (menos significativo). 
                        Lo cual elimina la necesidad de recorrer inter_data con count_bit. 
                    */

                end 
                
                // Modo n1 (Negedge SCK)
                if (CPH) begin // Lógica para comunicación con Receptor
                    if (negedge_sck) begin 
                        MOSI = inter_data[0];                    // Envía por MOSI el bit menos significativo 
                        nx_inter_data = {MISO, inter_data[7:1]}; // Coloca el bit de MISO como el más significativo
                        nx_count_bit = count_bit +1;             // Incrementa contador
                    end
                    /*
                        Esto es posible ya que los conforme llegan bits desde MOSI los otros bits se desplazan a 
                        la derecha, con lo cual se puede solamente enviar el último bit (menos significativo). 
                        Lo cual elimina la necesidad de recorrer inter_data con count_bit. 
                    */

                end
                
                // Si se enviaron todos los bits y estos llegaron de vuelta a las posiciones originales se termina
                else if (nx_count_bit == 15) nx_state = WAITING; // 15 para que de la vuelta completa

            end

        endcase

    end

endmodule // Fin de declaración del módulo

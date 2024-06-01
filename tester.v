/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código que implementa las pruebas
para la interfaz SPI. 
*/

// Declaración del módulo

module tester(
    // Outputs 
    clk,     // Clock, viene del CPU
    rst,     // Reset del sistema
    CPH,     // Define el flanco de SCK 
    CKP,     // Define la polaridad de SCK
    MISO,    // Recibe bit por bit la información enviada por el Receptor
    strt,    // Inicia la operación de la interfaz
    data_in, // Ingreso se dato que debe enviarse por MOSI

    // Inputs
    MOSI,    // Comunicación Transmisor -> Receptor, bit por bit
    SCK,     // Reloj interno que se transmite al Receptor
    CS  
);
    // Inputs ahora se tratan como outputs
    output clk, rst, CPH, CKP, strt, MISO; 
    //reg clk;
    output [7:0] data_in; 

    // Regs para outputs
    reg clk, rst, CPH, CKP, strt, MISO;
    reg [7:0] data_in;


    // Outputs ahroa se tratan como inputs
    input CS, MOSI, SCK;
    wire CS, MOSI, SCK;
    
    //input CS, MOSI;
    //reg CS, MOSI;  
    //input SCK;
    //reg SCK;

    // Declaración de reloj
    always begin 
        #1 clk = !clk;
    end
    initial begin 
        MISO = 1;
        //MISO = 8'b10101010;
        data_in = 8'b01010101;
        clk = 0;
        rst = 0; 
        CPH = 0;
        strt = 0; 
        #40 rst = 1;

        #4 strt = 1; 
        CKP = 1;
        #4 strt = 0;
        
        // Proabando MISO
        #10 MISO = 0;
        #10 MISO = 1;
        #10 MISO = 0;
        /*#4 MISO = 1;
        #4 MISO = 0;
        #4 MISO = 1;
        #4 MISO = 0;
        #4 MISO = 1;*/
         

        #200 $finish;


    end

endmodule



// module tester (
//     // Outputs 
//     clk,     // Clock, viene del CPU
//     rst,     // Reset del sistema
//     CPH,     // Define el flanco de SCK 
//     CKP,     // Define la polaridad de SCK
//     MISO,    // Recibe bit por bit la información enviada por el Receptor
//     strt,    // Inicia la operación de la interfaz
//     data_in, // Ingreso se dato que debe enviarse por MOSI

//     // Inputs
//     MOSI,    // Comunicación Transmisor -> Receptor, bit por bit
//     SCK,     // Reloj interno que se transmite al Receptor
//     CS  
// );

// // Declaración de entradas (inputs)
// output clk, rst, CPH, CKP, strt, MISO; 
// output [7:0] data_in; 

// // Declaración de salidas (outputs)
// reg CS, MOSI; 
// input CS, MOSI;
// input SCK;

// //wire CS, MOSI, SCK; 

// /*// Inputs
// input balance_actualizado, entregar_dinero, pin_incorrecto;
// input advertencia, bloqueo, fondos_insuficientes;

// // Wires para Inputs
// wire balance_actualizado, entregar_dinero, pin_incorrecto;
// wire advertencia, bloqueo, fondos_insuficientes;

// */

// // Declaración de reloj
// always begin 
//     #1 clk = !clk;
// end

// // Acá inicia el diseño de pruebas
// /*always begin 
// end*/

// endmodule
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
    // Inputs
    input clk, rst, CPH, CKP, strt, MISO; 
    input [7:0] data_in; 

    // Outputs
    output reg CS, MOSI; 
    output reg SCK;

    // Declaración de reloj
    always begin 
        #1 clk = !clk;
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
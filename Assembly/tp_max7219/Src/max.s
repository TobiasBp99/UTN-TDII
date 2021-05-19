		.syntax		unified
		.cpu		cortex-m0
		.thumb

		.section	.text
		.align		2
 		.global		max_test , max_init, max_normal_op, max_intensity , max_decode , max_scan , max_print
		.global		max_clean , max_print




/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
/*
.equ PORTA_ODR,		0x4001080c		//
.equ GPIOA_CRL, 	0x40010800		// Puerto GPIOA
.equ SPI1_BASE,		0x40013000		// Registro base SPI
.equ SPI1_DR,		0x4001300C		// Buffer Tx
.equ RCC_APB2ENR, 	0x40021018		// Clock a los perifericos
.equ SPI_DELAY, 	0xff			// Demora por software.
*/




/****************************************/
/*	Función max_test. 				 	*/
/*	Prende todo							*/
/****************************************/
		.type	max_test, %function
max_test:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

		POP	{R0, R1, PC}



/****************************************/
/*	Función max_init. 				 	*/
/*	Inicializa MAX					*/
/****************************************/
		.type	max_init, %function
max_init:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR

		MOVS	R0,#15
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#0
		BL spi_cmd_1byte

		POP	{R0, R1, PC}




/****************************************/
/*	Función max_init. 				 	*/
/*	Inicializa MAX					*/
/****************************************/
		.type	max_normal_op, %function
max_normal_op:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR

		MOVS	R0,#12
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#12
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#12
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#12
		MOVS	R1,#1
		BL spi_cmd_1byte

		POP	{R0, R1, PC}





/****************************************/
/*	Función max_intensity 			 	*/
/*	Modifico el brillo					*/
/*	para ver si responde 				*/
/****************************************/
		.type	max_intensity, %function
max_intensity:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R0,#10
		MOVS	R1,#15
		BL spi_cmd_1byte

		MOVS	R0,#10
		MOVS	R1,#8
		BL spi_cmd_1byte

		MOVS	R0,#10
		MOVS	R1,#4
		BL spi_cmd_1byte

		MOVS	R0,#10
		MOVS	R1,#0
		BL spi_cmd_1byte

		POP	{R0, R1, PC}





/****************************************/
/*	Función max_intensity 			 	*/
/*	Modifico el brillo					*/
/****************************************/
		.type	max_decode, %function
max_decode:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R0,#9
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#9
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#9
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#9
		MOVS	R1,#0
		BL spi_cmd_1byte

		POP	{R0, R1, PC}



/****************************************/
/*	Función max_scan 				 	*/
/*	Uso las 8 salidas					*/
/****************************************/
		.type	max_scan, %function
max_scan:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R0,#11
		MOVS	R1,#7
		BL spi_cmd_1byte

		MOVS	R0,#11
		MOVS	R1,#7
		BL spi_cmd_1byte

		MOVS	R0,#11
		MOVS	R1,#7
		BL spi_cmd_1byte

		MOVS	R0,#11
		MOVS	R1,#7
		BL spi_cmd_1byte

		POP	{R0, R1, PC}




/****************************************/
/*	Función max_clean 				 	*/
/*	Limpio la pantalla					*/
/****************************************/
		.type	max_scan, %function
max_clean:
		PUSH	{R0, R1, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R0,#1
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#2
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#3
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#4
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#5
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#6
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#7
		MOVS	R1,#0
		BL spi_cmd_4byte
		MOVS	R0,#8
		MOVS	R1,#0
		BL spi_cmd_4byte

		POP	{R0, R1, PC}

/****************************************/
/*	Función max_print 				 	*/
/*	Limpio la pantalla					*/
/*	R0 : frame
/****************************************/
		.type	max_print, %function
max_print:	//R0 me y R1 lo uso como iterador
		PUSH	{R0, R1, R2, R3, LR}		// Mando a la pila los registros que modifico y LR


		MOVS	R3,#0			// Con esto barro el puntero
		CMP 	R0,#0			// Seria un if
		BGT		frame2			// frame 2
frame1:
		LDR 	R2,=frame_1		// Cargo el punteros
		MOVS	R0,#1			// Inicializo la pos.de.mem del MAX
		B		print
frame2:
		LDR 	R2,=frame_2		// Cargo el puntero
		MOVS	R0,#1			// Inicializo la pos.de.mem del MAX
		B		print
print:
		LDRB	R1,[R2,R3]		// R1 = [R2+offset], con esto me traigo las columnas
		BL spi_cmd_4byte		// Imprimo la columna. R0 = pos.mem ; R1 = data
		ADDS	R0,#1			// Actualizo la linea a escribir
		ADDS	R3,#1			// Actualizo el offset
		CMP		R3,#8
		BNE		print			// Creo que emulo un loop con esto


		POP	{R0, R1, R2, R3, PC}




frame_1:
	.byte	0x18	//B00011000,  // First frame
	.byte	0x3C	//B00111100
	.byte	0x7E	//B01111110
	.byte	0xDB	//B11011011
	.byte	0xFF	//B11111111
	.byte	0x24	//B00100100
	.byte	0x5A	//B01011010
	.byte	0xA5	//B10100101
frame_2:
	.byte	0x18	//B00011000,  // Second frame
	.byte	0x3C	//B00111100
	.byte	0x7E	//B01111110
	.byte	0xDB	//B11011011
	.byte	0xFF	//B11111111
	.byte	0x24	//B00100100
	.byte	0x5A	//B01011010
	.byte	0x42	//B01000010
.end

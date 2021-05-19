		.syntax		unified
		.cpu		cortex-m0
		.thumb
/****************************************/
/*	Defino Rutinas Externas				*/
/****************************************/
/*
	.extern		led_init, led_set
	.extern		spi_init , spi_cmd_1byte
	.extern		gpio_init, gpio_set_cs , gpio_reset_cs
	.global		max_test , max_init , max_intensity , max_decode , max_scan , max_print
*/



/****************************************/
/*	Defino variables en RAM				*/
/****************************************/
	.section	.bss
	//.comm	valor_a_mostrar,4




/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ GPIOA_CRL, 	0x40010800		// Puerto GPIOA
.equ RCC_APB2ENR, 	0x40021018		// Clk en periféricos
.equ PORTC_ODR,		0x4001100C		//
.equ GPIOC_CHR, 	0x40011004		// Puerto GPIOC
.equ LOOP_COMPARE, 	0x2ffff			// Demora por software.
.equ SPI_DELAY, 	0xf				// Demora por software.




/****************************************/
/*	Función main. Acá salta boot.s 		*/
/****************************************/
		.section	.text
		.align		2
 		.global		main
		.type		main, %function
main:
		BL led_init					// Inicializo LED
		BL gpio_init				// Inicializo el ChipSelector CS
		BL gpio_set_cs				// CS = 1 -
		BL spi_init					// Inicializo el SPI

		BL max_test					// Me aseguro que puedo hablar SPI
		LDR		R0,=#LOOP_COMPARE	// Deberìa ver un flash
		BL		delay

		BL max_normal_op

		BL max_init

		BL max_decode				// No codifico a 7 segmentos

		BL max_scan					// Voy a usar las 8 salidas

		BL max_intensity			// Cambio el brillo para probar

		/*
		MOVS	R0,#1
		MOVS	R1,#2
		BL spi_cmd_1byte
		*/

		BL max_clean

		/*
		// Me aseguro que sé imprimir
		MOVS	R0,#1
		MOVS	R1,#1
		BL spi_cmd_4byte
		MOVS	R0,#2
		MOVS	R1,#2
		BL spi_cmd_4byte
		MOVS	R0,#3
		MOVS	R1,#4
		BL spi_cmd_4byte
		MOVS	R0,#4
		MOVS	R1,#8
		BL spi_cmd_4byte
		MOVS	R0,#5
		MOVS	R1,#16
		BL spi_cmd_4byte
		MOVS	R0,#6
		MOVS	R1,#32
		BL spi_cmd_4byte
		MOVS	R0,#7
		MOVS	R1,#64
		BL spi_cmd_4byte
		MOVS	R0,#8
		MOVS	R1,#128
		BL spi_cmd_4byte

		//LDR		R0,=#LOOP_COMPARE	// Debería ver un diagonal
		//BL		delay
		*/

main_loop:

		/*	 LED ON de referencia	*/
		MOVS	R0,#1
		BL		led_set

		//BL max_clean
		MOVS	R0,#0				// Frame1
		BL 		max_print			// Imprimo

		LDR		R0,=#LOOP_COMPARE*8
		BL		delay
		/*	 LED ON de referencia	*/

		/*	 LED OFF de referencia	*/
		MOVS	R0,#0
		BL		led_set

		//BL max_clean
		MOVS	R0,#1				// Frame2
		BL 		max_print			// Imprimo

		LDR		R0,=#LOOP_COMPARE*8
		BL		delay

		B		main_loop				// Vuelvo al main
		/*	 LED OFF de referencia	*/





/****************************************/
/*	Función delay. 				 		*/
/*	Recibe por R0 la demora				*/
/****************************************/
		.type	delay, %function
delay:
		PUSH	{R0, LR}			// Guardo el parámetro y LR en la pila.
delay_dec:
        SUBS	R0, 1				//
        BNE		delay_dec			// while(--R0);
		POP		{R0, PC}			// repongo R0 y vuelvo.










.end

		.syntax		unified
		.cpu		cortex-m0
		.thumb
/****************************************/
/*	Defino Rutinas Externas				*/
/****************************************/
	.extern		led_init, led_set
	.extern		spi_init , spi_cmd_1byte
	.extern		gpio_init, gpio_set_cs , gpio_reset_cs





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

		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#0
		BL spi_cmd_1byte

		MOVS	R0,#15
		MOVS	R1,#1
		BL spi_cmd_1byte

main_loop:
		/*	 LED ON de referencia	*/
		MOVS	R0,#1
		BL		led_set

		LDR		R0,=#LOOP_COMPARE
		BL		delay
		/*	 LED ON de referencia	*/

		/*	 LED OFF de referencia	*/
		MOVS	R0,#0
		BL		led_set
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

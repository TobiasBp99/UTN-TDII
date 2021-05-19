		.syntax		unified
		.cpu		cortex-m0
		.thumb

		.section	.text
		.align		2
 		.global		gpio_init, gpio_set_cs , gpio_reset_cs





/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ GPIOA_CRL, 	0x40010800		// Puerto GPIOA
.equ GPIOA_ODR,		0x4001080C		//
.equ GPIOC_CHR, 	0x40011004		// Puerto GPIOC
.equ RCC_APB2ENR, 	0x40021018		// Registros para habilitar el clock de GPIOC





/****************************************/
/*	Función gpio_init				 	*/
/*	Configura  los clk	de los perif.	*/
/****************************************/
.type	gpio_init, %function
gpio_init:
		PUSH	{R1, R2, LR}		// Mando a la pila los registros que modifico y LR
		/* Le doy Clk a GPIOA,AFIOEN	*/
		LDR		R1,=#RCC_APB2ENR	// Copio el reg para no borrar lo que puse antes
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #5
		MVNS	R1,R1				// R1   = ~R1 = 1010
		ANDS	R2,R2,R1			// R2 & = R1
		MOVS	R1, #5       		// Habilito bit de clk AFIOEN, GPIOA
		ADD		R1, R1, R2			// RCC |=
		LDR 	R2, =#RCC_APB2ENR   // Cargo la dirección de memoria
		STR		R1, [R2]            // Habilito la señal de reloj para
		/* Le doy Clk a GPIOA,AFIOEN	*/

		/* Seteo GPIOA_PIN4				*/
		LDR		R1,=#GPIOA_CRL		// Copio el reg para no borrar lo que puse antes
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #15
		LSLS	R1,R1,#16			// R1 <<= 20. Lo desplazo 4 por cada pin
		MVNS	R1,R1				// R1   = ~R1
		ANDS	R2,R2,R1			// R2 & = 0xfff0ffff
		LDR		R1, =(0b10 << 16)   // Cargo en R1 el bit que configura GPIOA_A. Lo desplazo 4 por cada pin
		ADD		R1, R1, R2			// GPIOA_CRL += configuro pin
		LDR 	R2, =#GPIOA_CRL   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Le paso el valor
		/* Seteo GPIOA_PIN4				*/

		POP		{R1, R2, PC}		// Repongo los registros que toque





/****************************************/
/*	Función gpio_set_cs. 			 	*/
/*	Pone '1' en GPIOA_PIN4				*/
/****************************************/
		.type	gpio_set_cs, %function
gpio_set_cs:
		PUSH	{R1, R2 ,LR}		// Mando a la pila todos los registros que modifico

		LDR		R1,=#GPIOA_ODR		// Copio el reg para no borrar lo que tenía
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #1				// R1   = 0x01
		LSLS	R1, R1, #4			// R1 <<= 4
		ADD		R1, R1, R2			// R1 |= R2
		LDR 	R2, =#GPIOA_ODR   	// Escribo la dirección de memoria para setear GPIOC
		STR 	R1, [R2]          	// Escribo el puerto de salida
		POP		{R1, R2, PC}		// Repongo los registros que toqué.





/****************************************/
/*	Función gpio_reset_cs. 			 	*/
/*	Pone '0' en GPIOA_PIN4				*/
/****************************************/
		.type	gpio_reset_cs, %function
gpio_reset_cs:
		PUSH	{R1, R2 ,LR}		// Mando a la pila todos los registros que modifico

		LDR 	R2, =#GPIOA_ODR
		MOVS	R1, #1					// R1   = 0x01
		LSLS	R1, R1, #4				// R1 <<= 4
		MVNS	R1,R1				// R1   = ~R1
		LDR 	R2, =#GPIOA_ODR   		// Escribo la dirección de memoria para setear GPIOC
		STR 	R1, [R2]          		// Escribo el puerto de salida
		POP		{R1, R2, PC}		// Repongo los registros que toqué.

.end

		.syntax		unified
		.cpu		cortex-m0
		.thumb

		.section	.text
		.align		2
 		.global		spi_init , spi_cmd_1byte, spi_cmd_4byte





/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ PORTA_ODR,		0x4001080c		//
.equ GPIOA_CRL, 	0x40010800		// Puerto GPIOA
.equ SPI1_BASE,		0x40013000		// Registro base SPI
.equ SPI1_DR,		0x4001300C		// Buffer Tx
.equ RCC_APB2ENR, 	0x40021018		// Clock a los perifericos
.equ SPI_DELAY, 	0xff			// Demora por software.





/****************************************/
/*	Función spi_init. 				 	*/
/*	Inicializa El SPI					*/
/****************************************/
		.type	spi_init, %function
spi_init:
		PUSH	{R1, R2, LR}			// Mando a la pila los registros que modifico y LR

		/*	 CLK en SPI1	*/
		LDR		R1,=#RCC_APB2ENR		// Copio el reg para no borrar lo que tenía
		LDR 	R2,[R1]					// En R2 tengo el valor inicial
		LDR		R1, =(1 << 12)      	// Cargo en R1 el bit que me habilita el SPI
		ADD		R1, R1, R2				// RCC += habilitoSPI
		LDR 	R2, =#RCC_APB2ENR   	// Cargo la dirección de memoria
		STR		R1, [R2]            	// Habilito la señal de reloj para SPI
		/*	 CLK en SPI1	*/

		/*	 configuro SPI_CR1 	*/
		LDR		R1, =(0x1UL << (2U)) | (0x1UL << (8U)) | (0x1UL << (11U)) | (0x1UL << (9U)) | (0x3UL << (3U))
		/*	SPI_CR1
			BIDIMODE	:	0: 2-line unidirectional data mode selected
			BIDIOE		:	0: Output disabled (receive-only mode)
			CRCEN		:	0: CRC calculation disabled
			CRCNEXT		:	0: Data phase (no CRC phase)
			DFF			:	1: 16-bit data frame format is selected for transmission/reception
			RXONLY		:	0: Full duplex (Transmit and receive)
			SSM			:	1: Software slave management enabled
			SSI:		:	1: The value of this bit is forced onto the
							NSS pin and the IO value of the NSS pin is ignored.
			LSBFIRST	:	0: MSB transmitted first
			SPE			:	0: Peripheral disabled
			BR[2:0]		:	11: f PCLK /16
			MSTR		:	1:	Master configuration
			CPOL		:	0: CK to 0 when idle
			CPHA		:	0: The first clock transition is the first data capture edge
		*/
		LDR 	R2, =#SPI1_BASE   		// Cargo la dirección de memoria
		STR		R1, [R2]            	// escribí el modo
		/*	 configuro SPI_CR1 	*/

		BL 		spi_pines_set			//

		/*	COnfiguro pines		*/
		POP		{R1, R2, PC}





/****************************************/
/*	Función spi_pines_set			 	*/
/*	Uso GPIOA_5 & GPIOA_7 				*/
/****************************************/
.type	spi_pines_set, %function
spi_pines_set:
		PUSH	{R1, R2, LR}		// Mando a la pila los registros que modifico y LR


		LDR		R1,=#GPIOA_CRL		// Copio el reg para no borrar lo que puse antes
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #15
		LSLS	R1,R1,#20			// R1 <<= 20. Lo desplazo 4 por cada pin
		MVNS	R1,R1				// R1   = ~R1
		ANDS	R2,R2,R1			// R2 & = 0xff0fffff
		LDR		R1, =(0x0b << 20)    // Cargo en R1 el bit que configura GPIOA_5. Lo desplazo 4 por cada pin
		ADD		R1, R1, R2			// GPIOA_CRL |= configuro pin
		LDR 	R2, =#GPIOA_CRL   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Le paso el valor


		LDR		R1,=#GPIOA_CRL		// Copio el reg para no borrar lo que puse antes
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #15
		LSLS	R1,R1,#28			// R1 <<= 20. Lo desplazo 4 por cada pin
		MVNS	R1,R1				// R1   = ~R1
		ANDS	R2,R2,R1			// R2 & = 0x0fffffff
		LDR		R1, =(0x0b << 28)    // Cargo en R1 el bit que configura GPIOA_5. Lo desplazo 4 por cada pin
		ADD		R1, R1, R2			// GPIOA_CRL |= configuro pin
		LDR 	R2, =#GPIOA_CRL   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Le paso el valor
		/*
		LDR		R1,=#GPIOA_CRL		// Copio el reg para no borrar lo que puse antes
		LDR 	R2,[R1]				// En R2 tengo el valor inicial
		MOVS	R1, #15
		LSLS	R1,R1,#16			// R1 <<= 20. Lo desplazo 4 por cada pin
		MVNS	R1,R1				// R1   = ~R1
		ANDS	R2,R2,R1			// R2 & = 0xfff0ffff
		LDR		R1, =(0b11 << 16)   // Cargo en R1 el bit que configura GPIOA_A. Lo desplazo 4 por cada pin
		ADD		R1, R1, R2			// GPIOA_CRL += configuro pin
		LDR 	R2, =#GPIOA_CRL   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Le paso el valor
									//Pongo GPIOA4 como salida.
		*/
		POP		{R1, R2, PC}		// Repongo los registros que toqué.
		//BX		LR					// return





/****************************************/
/*	Función spi_cmd_1byte. 			 		*/
/*	Pone '0' en GPIOA_PIN4				*/
/****************************************/
		.type	spi_cmd_1byte, %function
spi_cmd_1byte:	//Uso parámetros de entrada
		PUSH	{R0, R1, R2, LR}	// R0 = address , R1 = data


		LSLS	R0,R0,#8			// R0 <<= 8 = adress << 8
		ADD		R0, R0, R1			// datoSerie = (address) << 8) | data

		BL		gpio_reset_cs		// Bajo el CS


		LDR		R2,=#SPI1_BASE		// Copio el reg para no borrar lo que tenía
		LDR 	R1,[R2]				// En R1 tengo el valor inicial
		LDR		R2, =(1 << 6)      	// Cargo en R2 el bit que me habilita el SPI
		ADD		R1, R1, R2			// SPI_CR1 += SPE
		LDR 	R2, =#SPI1_BASE   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Ya habilité el periférico


		LDR 	R2, =#SPI1_DR   	// Cargo la dirección de memoria
		STR		R0, [R2]            // Escribo el TxBuffer

		LDR		R0,=#SPI_DELAY
		BL		delay

		BL		gpio_set_cs			// Levanto el CS

		LDR		R2,=#SPI1_BASE		// Copio el reg para no borrar lo que tenía
		LDR 	R0,[R2]				// En R0 tengo el valor inicial
		MOVS	R1, #1
		LSLS	R1,R1,#6			// R1 <<= 6
		MVNS	R1,R1				// R1   = ~R1 = 0b0111111
		ANDS	R0, R0, R1			// SPI_CR1 &= SPE_MASK
		LDR 	R2, =#SPI1_BASE   	// Cargo la dirección de memoria
		STR		R0, [R2]            // Deshabilito el periférico


		POP		{R0, R1, R2, PC}
		//BX		LR					// return

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




/****************************************/
/*	Función spi_cmd_1byte. 			 		*/
/*	Pone '0' en GPIOA_PIN4				*/
/****************************************/
		.type	spi_cmd_4byte, %function
spi_cmd_4byte:	//Uso parámetros de entrada
		PUSH	{R0, R1, R2,R3, LR}	// R0 = address , R1 = data


		LSLS	R0,R0,#8			// R0 <<= 8 = adress << 8
		ADDS	R3, R0, R1			// datoSerie = R3 =  (address) << 8) | data

		BL		gpio_reset_cs		// Bajo el CS


		LDR		R2,=#SPI1_BASE		// Copio el reg para no borrar lo que tenía
		LDR 	R1,[R2]				// En R1 tengo el valor inicial
		LDR		R2, =(1 << 6)      	// Cargo en R2 el bit que me habilita el SPI
		ADD		R1, R1, R2			// SPI_CR1 += SPE
		LDR 	R2, =#SPI1_BASE   	// Cargo la dirección de memoria
		STR		R1, [R2]            // Ya habilité el periférico


		LDR 	R2, =#SPI1_DR   	// Cargo la dirección de memoria
		STR		R3, [R2]            // Escribo el TxBuffer
		LDR		R0,=#SPI_DELAY
		BL		delay

		LDR 	R2, =#SPI1_DR   	// Cargo la dirección de memoria
		STR		R3, [R2]            // Escribo el TxBuffer
		LDR		R0,=#SPI_DELAY
		BL		delay

		LDR 	R2, =#SPI1_DR   	// Cargo la dirección de memoria
		STR		R3, [R2]            // Escribo el TxBuffer
		LDR		R0,=#SPI_DELAY
		BL		delay

		LDR 	R2, =#SPI1_DR   	// Cargo la dirección de memoria
		STR		R3, [R2]            // Escribo el TxBuffer
		LDR		R0,=#SPI_DELAY
		BL		delay

		BL		gpio_set_cs			// Levanto el CS

		LDR		R2,=#SPI1_BASE		// Copio el reg para no borrar lo que tenía
		LDR 	R0,[R2]				// En R0 tengo el valor inicial
		MOVS	R1, #1
		LSLS	R1,R1,#6			// R1 <<= 6
		MVNS	R1,R1				// R1   = ~R1 = 0b0111111
		ANDS	R0, R0, R1			// SPI_CR1 &= SPE_MASK
		LDR 	R2, =#SPI1_BASE   	// Cargo la dirección de memoria
		STR		R0, [R2]            // Deshabilito el periférico


		POP		{R0, R1, R2, R3,PC}
		//BX		LR					// return
.end

		.syntax		unified
		.cpu		cortex-m0
		.thumb

		.section	.text
		.align		2
 		.global		max_init





/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ PORTA_ODR,		0x4001080c		//
.equ GPIOA_CRL, 	0x40010800		// Puerto GPIOA
.equ SPI1_BASE,		0x40013000		// Registro base SPI
.equ SPI1_DR,		0x4001300C		// Buffer Tx
.equ RCC_APB2ENR, 	0x40021018		// Clock a los perifericos








.end

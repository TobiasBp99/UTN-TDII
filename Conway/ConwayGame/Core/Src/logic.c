/*
 * logic.c
 *
 *  Created on: Jun 21, 2021
 *      Author: tobias
 */
#include "stm32f1xx_hal.h"
#include <stdint.h>

#define LEGAJO 1680109
#define ROW 8
#define COL 8
#define NMAX 4
#define NMIN 1
#define NNEW 3

uint32_t xor32(void) {
		static uint32_t y = LEGAJO; /*completar con el legajo que sea*/
		y^= y<<13;
		y^= y>>17;
		y^= y<<5;
        //printf("%x\n",y);
		return y;

	}

void conway( uint8_t* p , uint8_t* f){
    uint8_t i = 0;  //Pos de mem
    uint8_t j = 0;  //Bit de Pos de mem

    uint8_t i_low;
    uint8_t i_up;
    uint8_t j_left;
    uint8_t j_rigth;

    uint8_t live = 0 ;  //
    uint8_t side,up,low;//
    uint8_t n = 0 ;     //neighbourhood

    //Hago evolucionar
    for( i=0 ; i<COL ; i++){
        f[i] = 0;   //Lleno el futuro
        for( j=0 ; j<ROW ; j++){
            i_low = i+1;
            i_up = i-1;
            j_left = j+1;
            j_rigth = j-1;
            //Special cases
            if( i == 0)
                i_up = 7;
            else if (i == 7)
                i_low = 0;

            if( j == 0)
                j_rigth = 7;
            else if (j == 7)
                j_left = 0;

            live = (*(p+i) & (1<<j));

            side    = *(p+i)      & ((1<< j_rigth) | (1<< j_left));         //side
            up      = *(p+i_up)   & ((1<< j_rigth) | (1<<j) | (1<< j_left));//Up
            low     = *(p+i_low)  & ((1<< j_rigth) | (1<<j) | (1<< j_left));//Low
            // Sumo todas las contribuciones
            n =    ((side & (1<<j_rigth))>>j_rigth) + ((side & (1<<j_left))>>j_left)   	+
                    ((up & (1<<j_rigth))>>j_rigth) + ((up & (1<<j_left))>>j_left)       + ((up & (1<<j))>>j) +
                    ((low & (1<<j_rigth))>>j_rigth) + ((low & (1<<j_left))>>j_left)     + ((low & (1<<j))>>j) ;

            if( live ){
                if( n < NMAX && n > NMIN)   // 2 ó 3 vecinos
                    *(f+i) |= 1 << j;
            }
            else
                    if (n == NNEW)
                        *(f+i) |= 1 << j;
            n = 0;
        }
    }

}


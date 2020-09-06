print:  .string "For x-value = %d \n   y-value = %d \n   The y maximum = %d\n"
        .balign 4

        .global main

main:   stp x29, x30, [sp, -16]!
        mov x29, sp

init:   mov x19, -10   //value of "x" will be stored here
        mov x24, 0      // value of "y" will be stored here
        mov x26, 0      // value of maximum "y" will be stored here
        mov x25, 0    // loop counter

test:   cmp x19, 4
        b.ge comp

        mov x20, 57   // the constant 57 is initialized here
        mov x21, 0    // temporary register

        add x21, x21, 11
        mul x21 , x21, x19
        add x20, x20, x21    // 11x +57

        mov x21, -22
        mul x21, x21, x19   //-22x
        mul x21, x21, x19    // -22x^2
        add x20, x20, x21     // -22x^2 + 11x + 57

        mov x21, -2
        mul x21, x21, x19    // -2x
        mul x21, x21, x19    // -2x^2
        mul x21, x21, x19    // -2x^3   
        add x20, x20, x21    // -2x^3 - 22x^2 + 11x + 57

        mov x24, x20

        cmp x25, 0
        b.eq upYmax

        cmp x24, x26
        b.gt upYmax

	adrp x0, print
        add x0, x0, :lo12:print
        mov w1, w19
        mov w2, w24
        mov w3, w26
        bl printf

	add x19, x19,1
	b test

upYmax: mov x26, x24
        mov x25,1
	
	adrp x0, print
        add x0, x0, :lo12:print
        mov w1, w19
        mov w2, w24
        mov w3, w26
        bl printf

	add x19, x19, 1

        b test


comp:   mov x0, 0
        ldp x29, x30, [sp], 16

        ret

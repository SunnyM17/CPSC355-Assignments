
print:  .string "For x-value = %d\n  y-value = %d\n The y maximum = %d\n\n"
        .balign 4

        .global main

main:   stp x29, x30, [sp, -16]!	// Save FP and LR to stack
        mov x29, sp			//Update FP to current SP

init:   mov x19, -10   //value of "x" will be stored here
        mov x24, 0      // value of "y" will be stored here
        mov x26, 0      // value of maximum "y" will be stored here
        mov x25, 0    // loop counter

test:   cmp x19, 4	// compares the value of x to 4
        b.gt comp	// branches to comp when x >= 0 to halt the execution of the loop 

        mov x20, 57   // the constant 57 is initialized here
        mov x21, 0    // temporary register

        add x21, x21, 11     //adds the coefficient 11 to the temporary register
        mul x21 , x21, x19	// multiplies the value of x with the corefficient 11
        add x20, x20, x21    // adds 11x to 57 ( 11x + 57)

        mov x21, -22		//changes the value of the temp register to -22 
        mul x21, x21, x19   //multiplies the coefficient with the value of x ( -22 * x)
        mul x21, x21, x19    // -multiplies the value of coefficient with x ( -22x * x = -22x^2)
        add x20, x20, x21     // adds the value of the temporary register to the constant ( -22x^2 + 11x + 57)

        mov x21, -2		// initializes the value of the temporary register to -2 
        mul x21, x21, x19    // multiplies the coefficient with the value of x (-2 * x)
        mul x21, x21, x19    // multiplies the value of the temp register with x (-2x*x = -2x^2)
        mul x21, x21, x19    // multiplies the value of the temp register with x ( -2x^2 * x = -2x^3)
        add x20, x20, x21    // adds the value of the temporary register to the constant (-2x^3 - 22x^2 + 11x + 57)

        mov x24, x20	// moves the value in x20 (constant) to x24(y-value)

        cmp x25, 0	//checks if the loop is being run for the first time 
        b.eq upYmax	// updates the value of x26(ymax) during the first iteration of the loop

        cmp x24, x26	// compares the x24(y value) and x26(y max)
        b.gt upYmax	// check if y-value is greater than yMax and branches to upYmax

	adrp x0, print   // address of the string
        add x0, x0, :lo12:print    //address of the string
        mov w1, w19	// initializes the x-value to the print statement
        mov w2, w24	// initializes the y-value to the print statement
        mov w3, w26	// initializes the y-max to the print statement
        bl printf	//calls the printf function

	add x19, x19,1	// adds 1 to the x-value to iterate
	b test		// branches to test

upYmax: mov x26, x24	// updates the yMax if y-value is greater
        mov x25,1	// increases the loop counter so yMax is not initialized again
	
	adrp x0, print	//address of the string
        add x0, x0, :lo12:print		//address of the string 
        mov w1, w19	//initializes the x-value to the print statement
        mov w2, w24	//intiializes the y-value to the print statement
        mov w3, w26	//initializes the y-max to the print statement
        bl printf	//calls the printf function

	add x19, x19, 1	//adds 1 to the x-value to iterate
        b test		// branches to test


comp:   mov x0, 0 // intializes the value of x0 back to 0
        ldp x29, x30, [sp], 16   //Loads FP and SR to stack

        ret      // Returns control to calling code (in OS)

/* 						CPSC355-Assignment 2b
						   Guransh Mangat
						     30061719
						Dr. Leonard Manzara

                        Integer Multiplication using Add and Shift Operations
                        Multiplicand = 522133279
                        Multiplier = 200
*/

// Begins defining registers to macros for accessibility
define(multiplier, w19)
define(multiplicand, w20)
define(product, w21)
define(negative, w22)
define(i, w23)
define(result, x24)
define(temp1, x25)
define(temp2, x26)
define(temp_r, w27)
// Ends defining registers

printa:	.string "Multiplier = 0x%08x (%d) \nMultiplicand = 0x%08x (%d) \n\n"        // Prints out initial values of variables
    .balign 4

printb: .string "Product = 0x%08x \nMultiplier = 0x%08x \n\n"                       // Prints out product and multiplier 
    .balign 4

printc: .string "64-bit Result = 0x%016lx (%ld) \n\n"                               // Prints out the 64-bit result
	.balign 4

	.global main

main:	stp x29, x30, [sp, -16]!     // Save FP and LR to stack
	mov x29, sp                      // Updates FP to current SP

    mov multiplicand, 522133279      // Changes the value of multiplicand to 522133279
    mov multiplier, 200               // Changes the value of multiplier to 200
    mov product, 0                   // Changes the value of product to 0

    adrp x0, printa
    add x0, x0, :lo12:printa     // Address of the string
	mov w1, multiplier		     // Places the multiplier (in hexadecimal) into the register to print it
	mov w2, multiplier		     // Places the multiplier into the register to print it
	mov w3, multiplicand		 // Places the value of multiplicand(in hexadecimal) into the register to print it
    mov w4, multiplicand         // Places the multiplicant into the register to print it
	bl printf                    // Prints the value of the function as output

    cmp multiplier, 0            // Compares multiplier to 0
    b.lt lessThan                // Checks if multiplier is negative and branches to lessThan
    mov negative, 0              // Sets the negative register to 0 for FALSE
    b loop                       // Unconditional branch to the loop

lessThan:   mov negative, 1      // Sets the negative register to 1 for TRUE

loop:   cmp i, 32                // Begins the while loop, compares i and 32 
    b.ge neg                     // If i is >= 32, branches to neg

test1:  and temp_r, multiplier, 0x1      // Bitwise AND: Masks out bit 0 in multiplier and stores it in temp_r
    cmp temp_r, 1                        // Compares temp_r to 1
    b.ne test3                           // Branches to test3 if temp_r is 0

test2:  add product, product, multiplicand    // Adds and replaces the value of product to product + multiplicand
    
test3:  asr multiplier, multiplier, 1       // Arithmetic Shift Right to multiplier by 1 
    and temp_r, product, 0x1                // Bitwise AND: Masks out bit 0 in product and stores it in temp_r
    cmp temp_r, 1                           // Compares the value of temp_r to 1
    b.ne test4                              // Branches to test4 if temp_r = 0
    orr multiplier, multiplier, 0x80000000  // Bitwise ORR: Masks out bit 31 in multiplier and stores it in multiplier
    b test5                                 // Branches to test5

test4:  and multiplier, multiplier, 0x7FFFFFFF  // Bitwise AND: Masks out bit 0 - 30 in multiplier and stores it in multiplier

test5:  asr product, product, 1      // Arithmetic Shift Right to product by 1
    add i, i, 1                      // Increments the loop counter "i" by 1
    b loop                           // Branches to the top of the loop 

neg:    cmp negative, 1                  // Compares negative to TRUE
    b.ne print                           // Branches to print is negative is FALSE
    sub product, product, multiplicand   // Stores the difference between product and multiplicant in product (product = product - multiplicand) 

print:  adrp x0, printb
    add x0, x0, :lo12:printb            // Address of the string
    mov w1, product                     // Places the product (in hexadecimal) into the register to print it
    mov w2, multiplier                  // Places the multiplier (in hexadecimal) into the register to print it
    bl printf                           // Prints the value of the function as output

bitC:  sxtw temp1, product              // Sign extends 32-bit product into 64-bit temp1
    and temp1, temp1, 0xFFFFFFFF        // Bitwise AND: Masks out bit 0-31 in temp1 and stores it in temp1
    lsl temp1, temp1, 32                // Logical Shift Left: Shifts 0 into the rightmost bit 32 times
    sxtw temp2, multiplier              // Sign extends 32-bit multiplier into 64-bit temp2
    and temp2, temp2, 0xFFFFFFFF        // Bitwise AND: Masks out bit 0-31 in temp2 and stores it in temp2
    add result, temp1, temp2            // Adds temp1 and temp2 and stores it in result

    adrp x0, printc
    add x0, x0, :lo12:printc            // Address of the string
    mov x1, result                      // Places the result (in hexadecimal) into the register to print it
    mov x2, result                      // Places the result into the register to print it
    bl printf                           // Prints the value of the function as output

done:	mov x0, 0		// intializes the x0 register to 0 again
	ldp x29, x30, [sp], 16	// Loads FP and SR to stack

	ret                // returns the control to the calling code (in OS)


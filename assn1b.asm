

print:	.string "x-value = %d\n y-value = %d\nThe y maximum = %d \n \n"
	.balign 4

	.global main

main:	stp x29, x30, [sp, -16]!
	mov x29, sp

	define(xVal, x19)   //defining macro for x value
	define(yVal, x20)   //defining macro for y value
	define(yMax, x21)   // defining macro for y max
	define(loopC, x22)  //loop counter
	define(tempR, x23)  // temporary register used for mathematical computation
	define(coef1, x24)  // defining x coefficient
	define(coef2, x25)  // defining x^2 coefficient
	define(coef3, x26)  // defining x^3 coefficient

	mov xVal, -10  //initializes the x value
	mov yVal, 0    // inititalizes the y value
	mov yMax, 0	// initializes the y maximum
	mov loopC, 0	// initializes the loop counter
	mov coef1, 11   // initializes the first coefficient
	mov coef2, -22  //initializes the second coefficient 
	mov coef3, -2  // intializess the third coefficient
	
	
	b test		// unconditional branch to test

top:	mov yVal, 0
	add yVal, yVal, 57	//the constant is initialized here
	
	madd yVal, coef1, xVal, yVal	// yVal = yVal + (coef1 * xVal) = 57 + (11 * x) 

	mul tempR, xVal, xVal	// tempR = xVal * xVal = (x^2)
	madd yVal, coef2, tempR, yVal   // yVal = yVal + (coef2 * tempR) = (57 + 11x) + (-22 * x^2)
	

	mul tempR, tempR, xVal   // tempR = x^2 * x = x^3
	madd yVal, coef3, tempR, yVal    // yVal = yVal + (coef3 *tempR) = (57 + 11x -22x^2) + (-2 * x^3) = 57 + 11x -22x^2 -2x^3

	cmp loopC, yMax    // checks the value of yMax and loop counter to initialize yMax to yVal during the first iteration
	b.eq upYmax		// conditional branch to upYmax for initializing yMax during the first iteration
	
	cmp yVal,yMax	// compares the yVal and yMax 
	b.lt comp	// jumps to comp if yVal is less than yMax so it doesn't update
	

upYmax:	mov yMax, yVal    // yMax is updated with the new yVal incase it is greater than yMax 
	add loopC, loopC, 1  // loop counter is increased by one so that yMax doesn't initialize again.
	
comp:	adrp x0, print		//address of the string
	add x0, x0, :lo12:print //address of the string
	mov x1, xVal		// places the x value into the register to print it
	mov x2, yVal		// places the y value into the register to print it
	mov x3, yMax		// places the value of y max into the register to print it
	bl printf		// prints the value of the function as output

	add xVal, xVal, 1	// iterates through the value of x by 1 each time
	
		
test:	cmp xVal, 4		// compares the value x value to 4
	b.le top		// branches to top if x is less than 4 inorder to keep the loop going

done:	mov x0, 0		// intializes the x0 register to 0 again
	ldp x29, x30, [sp], 16	

	ret

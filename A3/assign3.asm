/* 						CPSC355-Assignment 3
						   Guransh Mangat
						     30061719
						Dr. Leonard Manzara

                        Sorting One-Dimensional Arrays
*/
print1: .string "Unsorted Array: \n"

print2: .string "Sorted Array: \n"

print3: .string "v[%d]: %d \n"

    SIZE = 50                                  // Size of array is 50.
    v_size  = 50 * 4                           // Allocating 50 * 4 bytes in memory for array.
    i_size = 4                                 // Size of counter i = 4
    j_size = 4                                 // Size of counter j = 4
    min_size = 4                               // Size of min = 4
    temp_size = 4                              // Size of temp = 4

    alloc = -(16 + 16 + v_size + i_size)& -16  // Amount of memory to be allocated.
    dealloc = -alloc                           // Amount of memory to be deallocated.

    // Define equates for variable offsets
    v_s = 16
    i_s = 16 + v_size
    j_s = i_s + i_size
    temp_s = j_s + j_size
    min_s = temp_s + temp_size

    fp .req x29                                // Register Equate assembler directive. Alias for x29.
    lr .req x30                                // Register Equate assembler directive. Alias for x30.

define(v_base_r, x20)                          // Macro for register with the base address of the array.
define(i_r, w21)                               // Macro for register with index i.
define(j_r, w22)                               // Macro for register with index j.
define(temp_r, w23)                            // Macro for register with temp value.
define(min_r, w24)                             // Macro for register with min value index. 
define(ival_r, w25)                            // Macro for register storing value of v[i] to compare. 
define(jval_r, w26)                            // Macro for register storing value of v[j] to compare.
define(minval_r, w27)                          // Macro for register storing value of v[min] to compare.

    .balign 4
    .global main                               // Makes main visible

main: stp fp, lr, [sp, alloc]!                 // Save FP and LR to stack
    mov fp, sp                                 // Moves value of sp to fp

    mov i_r, 0                                 //Initialize i to 0
    str  i_r,[fp, i_s]                         // Store the counter at this address
    b test1

loop1:  bl rand                                // Calls rand() function
    and j_r, w0, 0xFF                          // Mod the result with 255

    add v_base_r, fp, v_s                      // Calculate array base address
    ldr i_r, [fp, i_s]                         // Load current i
    str j_r, [v_base_r, i_r, SXTW 2]           // Stores a random integer into array[i], Offset = SXTW w1 with LSL by 2.

    adrp x0, print3                            // Set 1st arg (high order bits)
    add x0, x0, :lo12:print3                   // Set 1st arg (low order bits) 
    ldr w1, [fp, i_s]                          // Arg 1: i
    add v_base_r, fp, 16                       // Calculate the array base address
    ldr w2, [v_base_r, w1, SXTW 2]             // Arg 2: v[i] 
    bl printf                                  // Calls the print function

    ldr i_r, [fp, i_s]                         // Loads current value of i
    add i_r, i_r, 1                            // Increments the i by 1
    str i_r, [fp, i_s]                         // Store the updated value of i

test1: cmp i_r, SIZE                           // Compares value of i to the size of array
    b.lt loop1                                 // Branches to loop1 if i < SIZE

    adrp x0, print2                            // Sets 1st arg (high order bits)
    add x0, x0, :lo12:print2                   // Sets 1st arg (low order bits)
    bl printf                                  // Calls the print function
    
    mov i_r, 0                                 // Initializes i to 0
    str i_r, [fp, i_s]                         // Stores counter at this address

    b test2

//----------------------------------------SORTING ALGORITHM-------------------------------------------------------------------------

loop2: ldr i_r, [fp, i_s]                      // Loads the value of i_r from stack
    str i_r, [fp, min_s]                       // Stores value of min_r to stack.
    
    ldr i_r, [fp, i_s]                         // Loads value of i_r from stack
    add j_r, i_r, 1                            // Adds value of j_r = i_r + 1
    str j_r, [fp, j_s]                         // Stores value of j_r to stack
    
    b test3                                    // Unconditional branch to test3

loop3: ldr j_r, [fp, j_s]                      // Loads the value of j index from the stack.
    ldr jval_r, [v_base_r, j_r, SXTW 2]        // Loads the value of v[j] from the array in memory.
    ldr min_r, [fp, min_s]                     // Loads value of min index from the stack.
    ldr minval_r, [v_base_r, min_r, SXTW 2]    // Loads the value of v[min] from the array in memory.
    
    cmp jval_r, minval_r                       // Compares the value of v[j] and v[min]
    b.ge skip                                  // Branches to skip if v[j] >= v[min]

    ldr j_r, [fp, j_s]                         // Loads value of index j from the stack
    mov min_r, j_r                             // Replaces value of min with j
    str min_r, [fp, min_s]                     // Stores the new value of min in stack.

skip:
    ldr j_r, [fp, j_s]                         // Loads the value of index j from the stack.
    add j_r, j_r, 1                            // Increments the value of index j by 1.
    str j_r, [fp, j_s]                         // Stores the incremented value of index j in stack.

test3: 
    ldr j_r, [fp, j_s]                         // Loads the value of index j from the stack
    cmp j_r, SIZE                              // Compares value of index j to the size of array.
    b.lt loop3                                 // Branches back to loop3 if j < SIZE

    ldr min_r, [fp, min_s]                     // Loads the value of index min from the stack.
    ldr minval_r, [v_base_r, min_r, SXTW 2]    // Loads the value of v[min] from the stack.
    mov temp_r, minval_r                       // Moves the value of v[min] to temp.
    str temp_r, [fp, temp_s]                   // Stores the value of temp in the stack.

    ldr i_r, [fp, i_s]                         // Loads the index i from the stack.
    ldr ival_r, [v_base_r, i_r, SXTW 2]        // Loads the value of v[i] from the stack.
    str ival_r, [v_base_r, min_r, SXTW 2]      // Stores the value of v[i] into the stack memory for v[min]

    str temp_r, [v_base_r, i_r, SXTW 2]        // Stores the value of temp into the stack memory for v[i]
     
    adrp x0, print3                            // Sets 1st arg (high order bits)
    add x0, x0, :lo12:print3                   // Sets 1st arg (low oder bits)
    ldr w1, [fp, i_s]                          // Arg1 = i
    ldr w2, [v_base_r, w1, SXTW 2]             // Arg2 = v[i]
    bl printf                                  // Calls the print function
    
    add i_r, i_r, 1                            // Increments the index i by 1
    str i_r, [fp, i_s]                         // Stores the incremented index into the stack memory.

test2:
    cmp i_r, SIZE                              // Compares the index i to the size of the array.
    b.lt loop2                                 // Branches to loop2 if i < SIZE

    mov w0, 0                                  // Initializes the value of w0 to 0
    ldp fp, lr, [sp], dealloc                  // Restores FP and LR
    ret                                        // Return to caller (OS)

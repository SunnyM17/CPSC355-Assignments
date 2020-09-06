/* 						CPSC355-Assignment 4
						   Guransh Mangat
						     30061719
						Dr. Leonard Manzara

                    Structures and Subroutines
*/

print1: .string "Cuboid %s origin = (%d, %d) \n"

print2: .string "\tBase Width = %d Base Length = %d \n"

print3: .string "\tHeight = %d \n"

print4: .string "\tVolume = %d \n\n"

print_init: .string "Initial Cuboid Values:\n"

print_change: .string "\nChanged Cuboid Values:\n"

print_f: .string "first"

print_s: .string "second"

    .balign 4

    fp .req x29
    lr .req x30

    define(cuboid_1, x19)
    define(cuboid_2, x20)

    FALSE = 0                                                          // Defining False to be 0.
    TRUE = 1                                                           // Defining True to be 1. 

// --------------------------------- STRUCT: POINT ----------------------

    pt_x = 0                                                           // Offset of point x from the base of the struct.
    pt_y = 4                                                           // Offset of point y from the base of the struct.
    pt_size = 8                                                        // Size of the struct point. (4 + 4)

// ------------------------------- END STRUCT: POINT --------------------

// ------------------------------- STRUCT: DIMENSION --------------------

    width_s = 0                                                        // Offset of width from the base of the struct.
    length_s = 4                                                       // Offset of length from the base of the struct.
    dimension_size = 8                                                 // Size of the struct dimension. (4 + 4)

// ----------------------------- END STRUCT: DIMENSION ------------------

// ----------------------------- STRUCT: CUBOID -------------------------

    origin_s = 0                                                       // Offset of origin from the base of the struct.
    base_s = 8                                                         // Offset of base from the base of the struct.   
    height_s = 16                                                      // Offset of height from the base of the struct.
    volume_s = 20                                                      // Offset of volume from the base of the struct.
    cuboid_size = 24                                                   // Size of the struct cuboid. (8 + 8 + 4 + 4)

// -------------------------- END STRUCT: CUBOID ------------------------

    cuboid_1_size = cuboid_size                                        // Allocating 24 bytes of memory for cuboid 1.
    cuboid_2_size = cuboid_size                                        // Allocating 24 bytes of memory for cuboid 2.
    alloc = -(16 + cuboid_1_size + cuboid_2_size) & -16                // Amount of memory to be allocated.
    dealloc = -alloc                                                   // Amount of memory to be deallocated.

    cuboid_1_s = 16                                                    // Offset of cuboid 1 from the frame record.
    cuboid_2_s = 16 + cuboid_2_size                                    // Offset of cuboid 2 from the frame record.



// ---------------------------- MAIN METHOD -----------------------------
    
    .global main                                                      // Makes main visible to the OS.
main:
    stp fp, lr, [sp, alloc]!
    mov fp, sp

    add cuboid_1, fp, cuboid_1_s                                      // Calculates the base address of cuboid_1. 
    add cuboid_2, fp, cuboid_2_s                                      // Calculates the base address of cuboid_2.

    mov x0, cuboid_1                                                  // Moves cuboid_1 into x0.
    bl newCuboid                                                      // Branches to newCuboid.

    mov x0, cuboid_2                                                  // Moves cuboid_2 into x0.
    bl newCuboid                                                      // Branches to newCuboid.

    adrp x0, print_init                                               // Sets 1st arg. (high order bits)
    add x0, x0, :lo12:print_init                                      // Sets 1st arg. (low order bits)
    bl printf                                                         // Calls the print function.

    mov x0, cuboid_1                                                  // Moves cuboid_1 into x0.    
    adrp x1, print_f                                                  // Sets 1st arg. (high order bits)
    add x1, x1, :lo12:print_f                                         // Sets 1st arg. (low order bits)
    bl printCuboid                                                    // Branches to printCuboid.

    mov x0, cuboid_2                                                  // Moves cuboid_2 into x0.
    adrp x1, print_s                                                  // Sets 1st arg. (high order bits)
    add x1, x1, :lo12:print_s                                         // Sets 1st arg. (low order bits)
    bl printCuboid                                                    // Branches to printCuboid.

    mov x0, cuboid_1                                                  // Moves cuboid_1 into x0.
    mov x1, cuboid_2                                                  // Moves cuboid_2 into x1.
    bl equalSize                                                      // Branches to equalSize.

    mov x21, x0                                                       // Moves x0 into x21.
    cmp x21, xzr                                                      // Compares x21 and xzr.
    b.eq next                                                         // Branches to next if equal.

    mov x0, cuboid_1                                                  // Moves cuboid_1 into x0.
    mov w1, 3                                                         // Moves 3 into w1. (deltaX = 3)
    mov w2, -6                                                        // Moves -6 into w2. (deltaY = -6)
    bl move                                                           // Branches to move.

    mov x0, cuboid_2                                                  // Moves cuboid_2 into x0.
    mov w1, 4                                                         // Moves 4 into w1. (factor = 4)
    bl scale                                                          // Branches to scale.

next:
    adrp x0, print_change                                             // Sets 1st arg. (high order bits)
    add x0, x0, :lo12:print_change                                    // Sets 1st arg. (low order bits)
    bl printf                                                         // Calls the print function.

    mov x0, cuboid_1                                                  // Moves cuboid_1 into x0.
    adrp x1, print_f                                                  // Sets 1st arg. (high order bits)
    add x1, x1, :lo12:print_f                                         // Sets 1st arg. (low order bits)
    bl printCuboid                                                    // Branches to printCuboid.

    mov x0, cuboid_2                                                  // Moves cuboid_2 into x0.
    adrp x1, print_s                                                  // Sets 1st arg. (high order bits)
    add x1, x1, :lo12:print_s                                         // Sets 1st arg. (low order bits)
    bl printCuboid                                                    // Branches to printCuboid.

done:
    ldp fp, lr, [sp], dealloc           
    ret    

// ---------------------- END MAIN METHOD -------------------------------

// ------------------------ SUBROUTINE: NEWCUBOID -----------------------

newCuboid:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov w10, 2                                                         // Moving 2 in w10 for base_width and base_length.
    mov w11, 3                                                         // Moving 3 in w11 for height.

    str xzr, [x0, origin_s + pt_x]                                     // Storing the value of c.origin.x in the stack.
    str xzr, [x0, origin_s + pt_y]                                     // Storing the value of c.origin.y in the stack.

    str w10, [x0, base_s + width_s]                                    // Storing the value of c.base.width in the stack.
    str w10, [x0, base_s + length_s]                                   // Storing the value of c.base.length in the stack.

    str w11, [x0, height_s]                                            // Storing the value of c.height in the stack.

    mul w10, w10, w10                                                  // w10 = w10 * w10
    mul w10, w10, w11                                                  // c.volume = w10 = w10 * w11 = w10 * w10 * w11 = 2 * 2 * 3 

    str w10, [x0, volume_s]                                            // Storing the value of c.volume in the stack.

    
    ldp fp, lr, [sp] , 16
    ret

// ----------------------- END SUBROUTINE: NEWCUBOID ---------------------

// ----------------------- SUBROUTINE: MOVE ------------------------------

move:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x21, x0                                                        // Moves the address of struct cuboid *c into x21.
    mov w22, w1                                                        // Moves the value of deltaX.
    mov w23, w2                                                        // Moves the value of deltaY.

    ldr w11, [x21, origin_s + pt_x]                                    // Loads the value of point_x from the address of struct cube.
    add w11, w11, w22                                                  // Adds deltaX to point_x.
    str w11, [x21, origin_s + pt_x]                                    // Stores the value of point_x using the address of the struct cube.

    ldr w11, [x21, origin_s + pt_y]                                    // Loads the value of point_y from the address of struct cube.
    add w11, w11, w23                                                  // Adds deltaY to point_y.
    str w11, [x21, origin_s + pt_y]                                    // Stores the value of point_y using the address of the struct cube.

    ldp fp, lr, [sp], 16
    ret

// ------------------- END SUBROUTINE: MOVE ------------------------------

// ---------------------- SUBROUTINE: SCALE ------------------------------

scale:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x24, x0                                                       // Stores the address of cuboid *c in x24.
    mov w25, w1                                                       // Moves the value of factor.

    ldr w21, [x24, base_s + width_s]                                  // Loads the value of c.base.width in w21 from the stack.
    mul w21, w21, w25                                                 // Multiplies the value of c.base.width with the factor. (w21 = w21 * w20)
    str w21, [x24, base_s + width_s]                                  // Stores the factored value of c.base.width into the stack.

    ldr w22, [x24, base_s + length_s]                                 // Loads the value of c.base.length in w22 from the stack.
    mul w22, w22, w25                                                 // Multiplies the value of c.base.length with the factor. (w22 = w22 * w20)
    str w22, [x24, base_s + length_s]                                 // Stores the factored value of c.base.length into the stack.

    ldr w23, [x24, height_s]                                          // Loads the value of c.height in w23 from the stack. 
    mul w23, w23, w25                                                 // Multiplies the value of c.height with the factor. (w23 = w23 * 20)
    str w23, [x24, height_s]                                          // Stores the factored value of c.height into the stack. 

    mul w21, w21, w22                                                 // Multiplies c.base.length with c.base.width. (w21 = w21 * w22)
    mul w21, w21, w23                                                 // Multiplies w21 with c.height. (w21 = w21 * w22 * w23)

    str w21, [x24, volume_s]                                          // Stores the factored value of c.volume into the stack. 


    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: SCALE ---------------------------

// ------------------------ SUBROUTINE: PRINTCUBOID -----------------------

printCuboid:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x21, x0                                                       // Stores the address of cuboid *c in x21.
    mov x22, x1                                                       // Moves the address of string *name in x22. (Arg 1 = "name")

    adrp x0, print1                                                   // Set 1st arg. (high order bits)
    add x0, x0, :lo12:print1                                          // Set 1st arg. (low order bits)
    ldr w2, [x21, origin_s + pt_x]                                    // Arg 2 = point_x.
    ldr w3, [x21, origin_s + pt_y]                                    // Arg 3 = point_y.
    bl printf                                                         // Calls the print function.

    adrp x0, print2                                                   // Set 1st arg. (high order bits)
    add x0, x0, :lo12:print2                                          // Set 1st arg. (low order bits)
    ldr w1, [x21, base_s + width_s]                                   // Arg 1 = width.
    ldr w2, [x21, base_s + length_s]                                  // Arg 2 = length.
    bl printf                                                         // Calls the print function. 

    adrp x0, print3                                                   // Set 1st arg. (high order bits)
    add x0, x0, :lo12:print3                                          // Set 1st arg. (low order bits)
    ldr w1, [x21, height_s]                                           // Arg 1 = height.
    bl printf                                                         // Calls the print function. 

    adrp x0, print4                                                   // Set 1st arg. (high order bits)
    add x0, x0, :lo12:print4                                          // Set 1st arg. (low order bits)
    ldr w1, [x21, volume_s]                                           // Arg 1 = volume.
    bl printf                                                         // Calls the print function.

    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: PRINTCUBOID ---------------------

// ---------------------- SUBROUTINE: EQUALSIZE ---------------------------

equalSize:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x21, x0                                                       // Stores the address of cuboid *c1 in x21.
    mov x22, x1                                                       // Stores the address of cuboid *c2 in x22.

    ldr w12, [x21, base_s + width_s]                                  // Loads the value of c1.base.width from the stack.
    ldr w13, [x22, base_s+ width_s]                                   // Loads the value of c2.base.width from the stack.
    cmp w12, w13                                                      // Compares c1.base.width and c2.base.width.
    b.ne resultF                                                      // Branches to resultF if not equal.

    ldr w12, [x21, base_s + length_s]                                 // Loads the value of c1.base.length from the stack.
    ldr w13, [x22, base_s + length_s]                                 // Loads the value of c2.base.length from the stack.
    cmp w12, w13                                                      // Compares c1.base.length and c2.base.length.
    b.ne resultF                                                      // Branches to resultF if not equal.

    ldr w12, [x21, height_s]                                          // Loads the value of c1.height from the stack.
    ldr w13, [x22, height_s]                                          // Loads the value of c2.height from the stack.
    cmp w12, w13                                                      // Compares the value of c1.height and c2.height.
    b.ne resultF                                                      // Branches to resultF if not equal.

    mov x0, TRUE                                                      // Returns true.
    b ret1                                                            // Branches to ret1.

resultF:
    mov x0, FALSE                                                     // Returns false.

ret1:
    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: EQUALSIZE ------------------------- 


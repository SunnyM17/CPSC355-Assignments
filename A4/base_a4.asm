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

    cuboid_1 = cuboid_size                                             // Allocating 24 bytes of memory for cuboid 1.
    cuboid_2 = cuboid_size                                             // Allocating 24 bytes of memory for cuboid 2.
    alloc = -(16 + cuboid_1 + cuboid_2) & -16                          // Amount of memory to be allocated.
    dealloc = -alloc                                                   // Amount of memory to be deallocated.

    cuboid_1_s = 16                                                    // Offset of cuboid 1 from the frame record.
    cuboid_2_s = 16 + cuboid_2                                         // Offset of cuboid 2 from the frame record.

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

// ------------------------ SUBROUTINE: NEWCUBOID -----------------------

newCuboid:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov w9, 0                                                          // Moving 0 in w9 for origin_x and origin_y.
    mov w10, 2                                                         // Moving 2 in w10 for base_width and base_length.
    mov w11, 3                                                         // Moving 3 in w11 for height.

    str w9, [x0, origin_s + pt_x]                                       // Storing the value of c.origin.x in the stack.
    str w9, [x0, origin_s + pt_y]                                       // Storing the value of c.origin.y in the stack.

    str w10, [x0, base_s + width_s]                                     // Storing the value of c.base.width in the stack.
    str w10, [x0, base_s + length_s]                                    // Storing the value of c.base.length in the stack.

    str w11, [x0, height_s]                                            // Storing the value of c.height in the stack.

    mul w9, w10, w10                                                   // w9 = w10 * w10
    mul w9, w9, w11                                                    // c.volume = w9 = w9 * w11 = w10 * w10 * w11 = 2 * 2 * 3 

    str w9, [x0, volume_s]                                             // Storing the value of c.volume in the stack.

    
    ldp fp, lr, [sp] , 16
    ret

// ----------------------- END SUBROUTINE: NEWCUBOID ---------------------

// ----------------------- SUBROUTINE: MOVE ------------------------------

move:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x22, x0                                                       // Moves the address of struct cuboid *c into x19.
    mov w23, w1                                                       // Moves the value of deltaX.
    mov w24, w2                                                       // Moves the value of deltaY.

    ldr w11, [x22, origin_s + pt_x]                                    // Loads the value of point_x from the address of struct cube.
    add w11, w11, w23                                                 // Adds deltaX to point_x.
    str w11, [x22, origin_s + pt_x]                                    // Stores the value of point_x using the address of the struct cube.

    ldr w11, [x22, origin_s + pt_y]                                    // Loads the value of point_y from the address of struct cube.
    add w11, w11, w24                                                 // Adds deltaY to point_y.
    str w11, [x22, origin_s + pt_y]                                    // Stores the value of point_y using the address of the struct cube.

    ldp fp, lr, [sp], 16
    ret

// ------------------- END SUBROUTINE: MOVE ------------------------------

// ---------------------- SUBROUTINE: SCALE ------------------------------

scale:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x27, x0                                                     // Stores the address of cuboid *c in x19.
    mov w28, w1                                                     // Moves the value of factor.

    ldr w21, [x27, base_s + width_s]                                 // Loads the value of c.base.width in w21 from the stack.
    mul w21, w21, w28                                               // Multiplies the value of c.base.width with the factor. (w21 = w21 * w20)
    str w21, [x27, base_s + width_s]                                 // Stores the factored value of c.base.width into the stack.

    ldr w22, [x27, base_s + length_s]                                // Loads the value of c.base.length in w22 from the stack.
    mul w22, w22, w28                                               // Multiplies the value of c.base.length with the factor. (w22 = w22 * w20)
    str w22, [x27, base_s + length_s]                                // Stores the factored value of c.base.length into the stack.

    ldr w23, [x27, height_s]                                        // Loads the value of c.height in w23 from the stack. 
    mul w23, w23, w28                                               // Multiplies the value of c.height with the factor. (w23 = w23 * 20)
    str w23, [x27, height_s]                                        // Stores the factored value of c.height into the stack. 

    mul w21, w21, w22                                               // Multiplies c.base.length with c.base.width. (w21 = w21 * w22)
    mul w21, w21, w23                                               // Multiplies w21 with c.height. (w21 = w21 * w22 * w23)

    str w21, [x27, volume_s]                                        // Stores the factored value of c.volume into the stack. 


    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: SCALE ---------------------------

// ------------------------ SUBROUTINE: PRINTCUBOID -----------------------

printCuboid:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x21, x0
    mov x22, x1

    adrp x0, print1
    add x0, x0, :lo12:print1
    ldr w2, [x21, origin_s + pt_x]
    ldr w3, [x21, origin_s + pt_y]
    bl printf

    adrp x0, print2
    add x0, x0, :lo12:print2
    ldr w1, [x21, base_s + width_s]
    ldr w2, [x21, base_s + length_s]
    bl printf

    adrp x0, print3
    add x0, x0, :lo12:print3
    ldr w1, [x21, height_s]
    bl printf

    adrp x0, print4
    add x0, x0, :lo12:print4
    ldr w1, [x21, volume_s]
    bl printf

    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: PRINTCUBOID ---------------------

// ---------------------- SUBROUTINE: EQUALSIZE ---------------------------

equalSize:
    stp fp, lr, [sp, -16]!
    mov fp, sp

    mov x25, x0
    mov x26, x1

    ldr w12, [x25, base_s + width_s]
    ldr w13, [x26, base_s+ width_s]
    cmp w12, w13
    b.ne resultF

    ldr w12, [x25, base_s + length_s]
    ldr w13, [x26, base_s + length_s]
    cmp w12, w13
    b.ne resultF

    ldr w12, [x25, height_s]
    ldr w13, [x26, height_s]
    cmp w12, w13
    b.ne resultF

    mov x0, TRUE
    b ret1

resultF:
    mov x0, FALSE

ret1:
    ldp fp, lr, [sp], 16
    ret

// ---------------------- END SUBROUTINE: EQUALSIZE ------------------------- 

// ---------------------------- MAIN METHOD ---------------------------------
    
    .global main
main:
    stp fp, lr, [sp, alloc]!
    mov fp, sp

    add x19, fp, cuboid_1_s
    add x20, fp, cuboid_2_s

    mov x0, x19
    bl newCuboid

    mov x0, x20
    bl newCuboid

    adrp x0, print_init
    add x0, x0, :lo12:print_init
    bl printf

    mov x0, x19
    adrp x1, print_f
    add x1, x1, :lo12:print_f
    bl printCuboid

    mov x0, x20
    adrp x1, print_s
    add x1, x1, :lo12:print_s
    bl printCuboid

    mov x0, x19
    mov x1, x20
    bl equalSize

    mov x21, x0
    cmp x21, xzr
    b.eq next

    mov x0, x19
    mov w1, 3
    mov w2, -6
    bl move

    mov x0, x20
    mov w1, 4
    bl scale

next:
    adrp x0, print_change
    add x0, x0, :lo12:print_change
    bl printf

    mov x0, x19
    adrp x1, print_f
    add x1, x1, :lo12:print_f
    bl printCuboid

    mov x0, x20
    adrp x1, print_s
    add x1, x1, :lo12:print_s
    bl printCuboid

done:
    ldp fp, lr, [sp], dealloc
    ret    

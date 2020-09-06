/*
                        CPSC355-Assignment 6
						   Guransh Mangat
						     30061719
						Dr. Leonard Manzara

                    File I/O and Floating-Point Numbers
*/


//============= DEFINING SP REGISTERS ======================
define(fd, w19)
define(byte_read, x20)
define(buf_base, x21)
define(argc_r, w22)
define(argv_r, x23)

//============= DEFINING FP REGISTERS ======================
define(numerator, d19)
define(denominator, d20)
define(exponent, d21)
define(accumulator, d22)
define(const, d23)
define(increment, d24)
define(i, d25)
define(fraction, d26)
define(exp_frac, d27)
define(const_frac, d28)
define(term, d29)

//================ ASSEMBLER EQUATES ========================
buf_size = 8
alloc = -(16 + buf_size) & -16
dealloc = -alloc
buf_s = 16

    .data 
constant: .double 0r1.0e-13
float_0: .double 0r0.0

    .text

header: .string "\tx: \t      ln(x):\n"
values: .string "%13.10f \t %13.10f\n"
error: .string "Error: ./a6 input.bin\n"

//=========================== BEGIN MAIN METHOD ==================
    .global main                               // Globalize main
    .balign 4                                  // Sets Alignment
main:
    stp x29, x30, [sp, alloc]!
    mov x29, sp


    mov argc_r, w0                             // Moves number of arguments from w0 to argc_r                  
    mov argv_r, x1                             // Moves the argument string from x1 to argv_r

    cmp argc_r, 2                              // Check if number of arguments == 2
    b.ne err                                   // Error if not equal

    mov w0, -100                               // Sets 1st arg (use cwd)
    ldr x1, [argv_r, 8]                        // Places the input string in x1
    mov w2, 0                                  // Sets 3rd arg (read-only)
    mov w3, 0                                  // Sets 4th arg (not used)
    mov x8, 56                                 // openat I/O request
    svc 0                                      // calls system function
    mov fd, w0                                 // moves w0 to fd
    cmp fd, 0                                  // error check
    b.ge open_ok                               // opens the file if no error

err:
    adrp x0, error                             // Sets 1st arg (error)
    add x0, x0, :lo12:error                    // Sets 1st arg (low order bits)
    bl printf                                  // Calls the print function
    b done                                     // Branches to done

open_ok:
    adrp x0, header                            // Sets 1st arg
    add x0, x0, :lo12:header                   // Sets 1st arg (low order bits)
    bl printf                                  // Calls the print function
    
    add buf_base, x29, buf_s                   // Stores the base address to buf_base

loop:
    mov w0, fd                                 // Sets 1st arg (fd)
    mov x1, buf_base                           // Sets 2nd arg (pointer to the buf_base)
    mov x2, buf_size                           // Sets 3rd arg (n)
    mov x8, 63                                 // read I/O request
    svc 0                                      // calls system function
    mov byte_read, x0                          // stores the file info in byte_read


    cmp byte_read, buf_size                    // checks for end of file
    b.ne end                                   // branches to end if end of file

    ldr d0, [buf_base]                         // Sets 1st arg (input)
    bl ln                                      // Calls the ln function
    fmov d1, d0                                // Stores the returned value of ln in d1

    adrp x0, values                            // Sets 1st arg (print statement)
    add x0, x0, :lo12:values                   // Sets 1st arg (low order bits)
    ldr d0, [buf_base]                         // Sets 2nd arg
    bl printf                                  // Calls the print fucntion
    b loop                                     // Loops till the end of file is reached

end:
    mov w0, fd                                 // Sets 1st arg (fd)
    mov x8, 57                                 // close I/O request
    svc 0                                      // calls system function
    mov w0, 0                                  // Returns 0

done:
    ldp x29, x30, [sp], dealloc
    ret


// =================== BEGIN LN METHOD =============================
    .global ln                                 // Globalize ln
    .balign 4                                  // Sets alignment
ln:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    adrp x23, constant                         // Sets 1st arg
    add x23, x23, :lo12:constant               // Sets 1st arg (low order bits)
    ldr const, [x23]                           // Loads value of constant in const (const = 1.0)

    adrp x24, float_0                          // Sets 1st arg
    add x24, x24, :lo12:float_0                // Sets 1st arg (low order bits)                        
    ldr accumulator, [x24]                     // accumulator - 0.0

    fmov exponent, 1.0                         // exponent = 1.0
    fmov increment, 1.0                        // increment = 1.0
    fmov i, 1.0                                // i = 1.0
    fmov const_frac, 1.0                       // const_frac = 1.0
    
    fmov denominator, d0                       // denominator = x
    fsub numerator, denominator, increment     // numerator = denominator -1 = x - 1
    fdiv fraction, numerator, denominator      // fraction = numerator/denominator
    fmov exp_frac, fraction                    // exp_frac = fraction (to be used when nultiplying exponentially)
    fmul term, exp_frac, const_frac            // term = exp_frac * const_ frac
    fadd accumulator, accumulator, term        // accumulator += term
    b test                                     // branches to test


top:
    fadd exponent, exponent, increment         // increases exponent by 1

top1:
    fmul exp_frac, exp_frac, fraction          // exp_frac *= frac
    fadd i, i, increment                       // increments i by 1
test1:
    fcmp i, exponent                           // compares i < exponent
    b.lt top1                                  // branches to top1
    fdiv const_frac, increment, exponent       // const_frac = 1/exponent
    fmul term, exp_frac, const_frac            // term = exp_frac * const_frac
    fadd accumulator, accumulator, term        // accumulator += term

test:
    fabs term, term                            // term = abs(term)
    fcmp term, const                           // if term >= const
    b.ge top                                   // branches to top
    
done1:
    fmov d0, accumulator                       // Returns accumulator
    stp x29, x30, [sp], 16                 
    ret


    
    


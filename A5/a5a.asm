/*
                        CPSC355-Assignment 5A
						   Guransh Mangat
						     30061719
						Dr. Leonard Manzara

                    Global Variables and Separate Compilations
*/

//============================ ASSEMBLER EQUATES =======================================

MAXOP = 20                                     
NUMBER = '0'
TOOBIG = '9'

MAXVAL = 100
BUFSIZE = 100

//=========================== END ASSEMBLER EQUATES ====================================

//=========================== DEFINING MACROS ==========================================

define(f_r, w19)
define(i_r, w20)
define(c_r, w21)
define(sp_a, w22)
define(lim_r, w23)
define(base_s, x27)

//========================== END DEFINING MACROS ========================================


stack_full: .string "error: stack full\n"
stack_empty: .string "error: stack empty\n"
many_chars: .string "ungetch: too many characters\n"

//================================ INITIALIZING GLOBAL VARIABLES =========================
    .data
    .global sp_m                                                    // globalize sp
sp_m: .word 0                                                       // sp = 0

    .global bufp                                                    // globalize bufp
bufp: .word 0                                                       // bufp = 0

    .bss
    .global val_m                                                   // globalize val[MAXVAL]
val_m: .skip MAXVAL * 4                                             // Allocates 400 bytes of stack memory


    .global buf                                                     // globalize buf
buf: .skip BUFSIZE * 4                                              // Allocates 400 bytes of stack memory

//=============================== END INITIALIZING GLOBAL VARIABLES ======================


    .text
    .balign 4                                                       // Sets alignment

//==================================== PUSH ==============================================

    .global push                                                    // Globalize push
push: 
    stp x29, x30, [sp, -16]!                                        //
    mov x29, sp                                                     // moves sp to fp

    mov f_r, w0                                                     // takes the parameter f from main and stores it in f_r

    
    adrp x24, sp_m                                                  // Sets 1st arg
    add x24, x24, :lo12:sp_m                                        // Sets 1st arg (low order bits)
    ldr sp_a, [x24]                                                 // Loads sp_a from stack
    
    cmp sp_a, MAXVAL                                                // sp_a >= MAXVAL
    b.ge else                                                       // jumps to else

    adrp x25, val_m                                                 // Sets 1st arg
    add x25, x25, :lo12:val_m                                       // Sets 1st arg (low order bits)
    str f_r, [x25, sp_a, SXTW 2]                                    // stores f_r to stack (val[sp++] = f)

    adrp x25, val_m                                                 // Sets 1st arg
    add x25, x25, :lo12:val_m                                       // Sets 1st arg (low order bits)
    ldr w0, [x25, sp_a, SXTW 2]                                     // returns f_r

    add sp_a, sp_a, 1                                               // increments sp by 1
    str sp_a, [x24]                                                 // stores the incremented sp to stack
    
    b done                                                          // branches to done

else: 
    adrp x0, stack_full                                             // Sets 1st arg
    add x0, x0, :lo12:stack_full                                    // Sets 1st arg (low order bits)
    bl printf                                                       // Calls the print function
    bl clear                                                        // Calls the clear function
    mov w0, 0                                                       // Returns 0

done:
    ldp x29, x30, [sp], 16  
    ret
 
//======================================= END PUSH ====================================

//================================= POP ================================================

    .global pop                                                     // globalize pop
    .balign 4                                                       // memory alignment
pop:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    adrp x9, sp_m                                                   // Sets 1st arg
    add x9, x9, :lo12:sp_m                                          // Sets 1st arg (low order bits)
    ldr sp_a, [x9]                                                  // Loads sp from stack

    cmp sp_a, 0                                                     // sp_a <= 0
    b.le else2                                                      // Branches to else 2

    sub sp_a, sp_a, 1                                              // Decrements sp_a by 1
    str sp_a, [x9]                                                 // Stores the decremented sp_a to stack

    adrp x9, sp_m                                                  // Sets 1st arg
    add x9, x9, :lo12:sp_m                                         // Sets 1st arg (low order bits)
    ldr sp_a, [x9]                                                 // Loads sp_a from stack

    adrp x9, val_m                                                 // Sets 1st arg
    add x9, x9, :lo12:val_m                                        // Sets 1st arg (low order bits)
    SXTW x22, sp_a                                                 // Sign extends sp_a to x22
    ldr w0, [x9, x22, LSL 2]                                       // returns val[--sp]

    b done2                                                        // branches to done

else2:
    adrp x0, stack_empty                                           // sets 1st arg
    add x0, x0, :lo12:stack_empty                                  // Sets 1st arg (low order bits)
    bl printf                                                      // Calls the print function
    bl clear                                                       // Calls the clear function
    mov w0, 0                                                      // Returns 0

done2:
    ldp x29, x30, [sp], 16
    ret

//============================================= END POP ==================================

// ======================================= CLEAR =========================================

    .global clear                                                  // Globalize clear
clear:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov sp_a, 0                                                    // sp_a = 0
    adrp x24, sp_m                                                 // Sets 1st arg
    add x24, x24, :lo12:sp_m                                       // Sets 1st arg (low order bits)
    str sp_a, [x24]                                                // Stores sp_a = 0 to stack

    ldp x29, x30, [sp], 16
    ret

// ======================================== END CLEAR =====================================

//=========================================== GETOP =======================================

    .global getop                                                   // globalize getop
getop:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov base_s, x0                                                  // stores first parameter char *s to base_s
    mov lim_r, w1                                                   // stores second parameter int lim to lim_r

test1:                                                              // while loop begins
    bl getch                                                        // Calls the getch function
    mov c_r, w0                                                     // Stores the return value from getch to c_r

    cmp c_r, ' '                                                    // c_r == ' '
    b.eq test1                                                      // branches to test1
    
    cmp c_r, '\t'                                                   // c_r == '\t'
    b.eq test1                                                      // branches to test1

    cmp c_r, '\n'                                                   // c_r == '\n'
    b.eq test1                                                      // branches to test1

if1:                                                                 // if statement begins
    cmp c_r, '0'                                                     // c_r < '0'
    b.lt cond                                                        // branches to cond

    cmp c_r, '9'                                                     // c <= '9'
    b.le next1                                                       // branches to next1

cond:
    mov w0, c_r                                                      // returns c
    b done3                                                          // branches to done3

next1:
    
    str c_r, [base_s]                                                // s[0] = c    

loop1:                                                               // begins for loop
    mov i_r, 0                                                       // i = 0
    b for1                                                           // branches to for1

if2:                                                                 // begins if statement inside for loop
    cmp i_r, lim_r                                                   // i_r >= lim_r
    b.ge for1                                                        // branches to for1

    str c_r, [base_s, i_r, SXTW 2]                                   // s[i] = c

for1:                                                                // begins for loop test

    add i_r, i_r, 1                                                  // increments i by 1
    bl getchar                                                       // calls the getchar function
    mov c_r, w0                                                      // stores the return value from getchar to c_r

    cmp c_r, '0'                                                     // c < '0'
    b.lt if3                                                         // branches to if3

    cmp c_r, '9'                                                     // c <= '9'
    b.le if2                                                         // branches to if2

if3:                                                                 // begins if statement after for loop
    cmp i_r, lim_r                                                   // i >= lim
    b.ge else3                                                       // branches to else3

    mov w0, c_r                                                      // returns c
    bl ungetch                                                       // calls the ungetch function with c as parameter
    
                                                       
    str wzr, [base_s, i_r, SXTW 2]                                   // s[i] = '\0'
    mov x0, NUMBER                                                   // returns NUMBER
    b done3                                                          // branches to done3
 
else3:                                                               // begins else statement

while1:                                                              // begins while test inside the else statement
    cmp c_r, '\n'                                                    // c_r == '\n'
    b.eq  next2                                                      // branches to next2
    
    cmp c_r, -1                                                      // c_r == EOF
    b.eq next2                                                       // branches to next2

    bl getchar                                                       // Calls the getchar function
    mov c_r, w0                                                      // Stores the return value of getchar in c_r
    b while1                                                         // Branches to while1

next2:
    sub lim_r , lim_r, 1                                             // Decrements lim by 1
                                                        
    str wzr, [base_s, lim_r, SXTW 2]                                 // s[lim-1] = '\0'

    mov w0, TOOBIG                                                   // Returns TOOBIG

done3:
    ldp x29, x30, [sp], 16
    ret

//================================ END GETOP ==============================================

//=================================== GETCH ===============================================

    .global getch                                                    // globalize getch
getch:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    adrp x11, bufp                                                   // Sets 1st arg
    add x11, x11, :lo12:bufp                                         // Sets 1st arg (low order bits)
    ldr w12, [x11]                                                   // Loads bufp into register

if4:
    cmp w12, 0                                                       // bufp <= 0
    b.le else4                                                       // Branches to else4

    sub w12, w12, 1                                                  // Decrements bufp by 1
    str w12, [x11]                                                   // Stores the decremented bufp to stack

    adrp x11, buf                                                    // Sets 1st arg
    add x11, x11, :lo12:buf                                          // Sets 1st arg (low order bits)
    SXTW x12, w12                                                    // Sign extends bufp
    ldrb w0, [x11, x12]                                              // returns buf[--bufp]
    b done4                                                          // branches done4

else4:
    bl getchar                                                       // returns getchar
    
done4:
    ldp x29, x30, [sp], 16
    ret

//================================= END GETCH =========================================

//======================================= UNGETCH =====================================

    .global ungetch                                                  // globalize ungetch
ungetch:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov c_r, w0                                                      // stores the parameter c to c_r

    adrp x11, bufp                                                   // Sets 1st arg
    add x11, x11, :lo12:bufp                                         // Sets 1st arg (low order bits)
    ldr w12, [x11]                                                   // Loads w12 with bufp from stack

    cmp w12, BUFSIZE                                                 // bufp <= BUFSIZE
    b.le else5                                                       // branches to else5

    adrp x0, many_chars                                              // Sets 1st arg
    add x0, x0, :lo12:many_chars                                     // Sets 1st arg (low order bits)
    bl printf                                                        // Calls the print function
    
    b done5                                                          // Branches to done5

else5:
    
    adrp x13, buf                                                    // Sets 1st arg
    add x13, x13, :lo12:buf                                          // Sets 1st arg (low order bits)
    str c_r, [x13, w12, SXTW 2]                                      // buf[bufp++] = c
    
    add w12, w12, 1                                                  // increments bufp by 1
    str w12, [x11]                                                   // stores incremented bufp to stack

done5:
    ldp x29, x30, [sp], 16
    ret
    
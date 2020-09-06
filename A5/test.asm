define(i_r, w19)
define(argc_r, w20)
define(argv_r, x21)

fmt: .string "%s\n"
    
        .balign 4
        .global main
    
main: 
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov argc_r, w0          // copy argc
    mov argv_r, x1          // copy argv
    
    mov i_r, 0                   // i = 0
    b test
    
top: adrp x0, fmt
    add x0, x0, :lo12:fmt          // set up 1st argument
    
    ldr x1, [argv_r, i_r, SXTW 3]  // set up 2nd argument
    bl printf                                    // calls printf
    
    add i_r, i_r, 1
    
test: 
    cmp i_r, argc_r           // loop while i < argc
    b.lt top
    
    ldp x29, x30, [sp], 16
    ret

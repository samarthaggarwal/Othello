@@@ Print Hello on standard output (STDOUT)

    .data
msg:
    .ascii      "Hello World!!\nHi i am samarth\0"
    .text
   .globl _start
_start:
    ldr     r0, =msg	@ R0 = Address of a Null terminated ASCII string
    swi     0x02	@ invoke syscall to display string on stdout
    mov     r0, #0     	@ status -> 0
    swi     0x11	@ invoke syscall

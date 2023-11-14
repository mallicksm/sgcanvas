.section BOOT,"ax"
.align 3
.equ SH_TRAP_INST_A32, 0x123456
.equ SYS_WRITE0, 0x4
.equ SYS_EXIT, 0x18

.global start
.type start, "function"

// Clear registers
// ---------------
start:
   mov r0, #0
   mov r1, #0
// ------------------------------------------------------------
// Main of your bare-metal software
// ------------------------------------------------------------
main:
   ldr r1, =print_hello
   bl semihost_print
   // Semihosting exit
   mov r0, #SYS_EXIT
   svc #SH_TRAP_INST_A32
// ------------------------------------------------------------
// Semihost call
// ------------------------------------------------------------
semihost_print:
   mov r0, #SYS_WRITE0
   svc #SH_TRAP_INST_A32
   bx lr
// ------------------------------------------------------------
// String literals
// ------------------------------------------------------------
print_hello:
.string "Hello world from the Cortex-R52 Fast Model!\n"

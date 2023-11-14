.section BOOT,"ax"
.align 3
.equ SH_TRAP_INST_A32, 0x123456
.equ SYS_WRITE0, 0x4
.equ SYS_EXIT, 0x18

.global start
.type start, "function"
start:
// Clear registers
// ---------------
MOV R0, #0
MOV R1, #0
// ------------------------------------------------------------
// Main of your bare-metal software
// ------------------------------------------------------------
main:
LDR R1, =print_hello
BL semihost_print
// Semihosting exit
MOV R0, #SYS_EXIT
SVC #SH_TRAP_INST_A32
// ------------------------------------------------------------
// Semihost call
// ------------------------------------------------------------
semihost_print:
MOV R0, #SYS_WRITE0
SVC #SH_TRAP_INST_A32
BX LR
// ------------------------------------------------------------
// String literals
// ------------------------------------------------------------
print_hello:
.string "Hello world from the Cortex-R52 Fast Model!\n"

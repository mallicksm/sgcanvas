.section BOOT,"ax"
.align 3
.equ SH_TRAP_INST_A64, 0xF000
.equ SYS_WRITE0, 0x4
.equ SYS_EXIT, 0x18

.global start64
.type start64, @function
start64:
   // Clear registers
   // ---------------
   mov x0, #0
   mov x1, #0
   mov x2, #0
   // Which core am I
   // ----------------
   mrs x0, mpidr_el1
   and x0, x0, #0xFF // Mask off to leave Aff0 - this assumes
   // a pre v8.4 processor
   cbz x0, primary // If core 0, run the primary core code
   b secondary // Else, run secondary cores code
// ------------------------------------------------------------
// Primary core
// ------------------------------------------------------------
primary:
   ldr x1, =print_msg0
   bl semihost_print
   // Semihosting exit
   moV w0, #SYS_EXIT
   hlt #SH_TRAP_INST_A64
1:
   wfi
   b 1b
// ------------------------------------------------------------
// Secondary core
// ------------------------------------------------------------
secondary:
   ldr x1, =print_msg1
   bl semihost_print
   // Semihosting exit
   mov w0, #SYS_EXIT
   hlt #SH_TRAP_INST_A64
2:
   wfi
   b 2b
// ------------------------------------------------------------
// Semihost call
// ------------------------------------------------------------
semihost_print:
   mov w0, #SYS_WRITE0
   hlt #SH_TRAP_INST_A64
   ret
// ------------------------------------------------------------
// String literals
// ------------------------------------------------------------
print_msg0:
   .string "Hello from core 0!\n"
print_msg1:
   .string "Hello from core 1!\n"

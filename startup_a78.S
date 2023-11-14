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
   MOV x0, #0
   MOV x1, #0
   MOV x2, #0
   // Which core am I
   // ----------------
   MRS x0, MPIDR_EL1
   AND x0, x0, #0xFF // Mask off to leave Aff0 - this assumes
   // a pre v8.4 processor
   CBZ x0, primary // If core 0, run the primary core code
   B secondary // Else, run secondary cores code
// ------------------------------------------------------------
// Primary core
// ------------------------------------------------------------
primary:
   LDR x1, =print_msg0
   BL semihost_print
   // Semihosting exit
   MOV w0, #SYS_EXIT
   HLT #SH_TRAP_INST_A64
1:
   WFI
   B 1b
// ------------------------------------------------------------
// Secondary core
// ------------------------------------------------------------
secondary:
   LDR x1, =print_msg1
   BL semihost_print
   // Semihosting exit
   MOV w0, #SYS_EXIT
   HLT #SH_TRAP_INST_A64
2:
   WFI
   B 2b
// ------------------------------------------------------------
// Semihost call
// ------------------------------------------------------------
semihost_print:
   MOV w0, #SYS_WRITE0
   HLT #SH_TRAP_INST_A64
   RET
// ------------------------------------------------------------
// String literals
// ------------------------------------------------------------
print_msg0:
   .string "Hello from core 0!\n"
print_msg1:
   .string "Hello from core 1!\n"

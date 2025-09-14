; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: DES test vector encryption and print (confidence=0.92). Evidence: call to des_encrypt; format and expected ciphertext strings
; Preconditions: None
; Postconditions: Prints computed and expected ciphertext; returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare dso_local i64 @des_encrypt(i64, i64)

declare dso_local i32 @_printf(i8*, ...)
declare dso_local i32 @_puts(i8*)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  %0 = call i64 @des_encrypt(i64 0x0123456789ABCDEF, i64 0x133457799BBCDFF1)
  %1 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %2 = call i32 (i8*, ...) @_printf(i8* %1, i64 %0)
  %3 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %4 = call i32 @_puts(i8* %3)
  ret i32 0
}
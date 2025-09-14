; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: search for an element in an array and report index (confidence=0.95). Evidence: call to linear_search; printf/puts messages about found/not found.
; Preconditions: none
; Postconditions: returns 0; prints search result

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00"
@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() noreturn
declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %res.slot = alloca i32, align 4
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %5, align 4
  %6 = call i32 @linear_search(i32* %1, i32 5, i32 4)
  store i32 %6, i32* %res.slot, align 4
  %7 = icmp eq i32 %6, -1
  br i1 %7, label %notfound, label %found

found:                                            ; preds = %entry
  %8 = load i32, i32* %res.slot, align 4
  %9 = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* %9, i32 %8)
  br label %check

notfound:                                         ; preds = %entry
  %11 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %12 = call i32 @puts(i8* %11)
  br label %check

check:                                            ; preds = %notfound, %found
  %13 = load i64, i64* %canary.slot, align 8
  %14 = load i64, i64* @__stack_chk_guard, align 8
  %15 = icmp eq i64 %13, %14
  br i1 %15, label %ret, label %stackfail

stackfail:                                        ; preds = %check
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %check
  ret i32 0
}
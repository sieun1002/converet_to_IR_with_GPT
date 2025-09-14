; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Demonstrate linear search and print result (confidence=0.86). Evidence: call to linear_search; messages via printf/puts
; Preconditions: None
; Postconditions: Returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @puts(i8*)
; (declare only other externs that are needed)
@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00"

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)
declare dso_local i32 @linear_search(i32*, i32, i32)
declare dso_local void @__stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8
  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.elem4, align 4
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arr.ptr, i32 5, i32 4)
  %cmpnotfound = icmp eq i32 %call, -1
  br i1 %cmpnotfound, label %notfound, label %found

found:                                            ; preds = %entry
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %pr = call i32 (i8*, ...) @printf(i8* %fmt, i32 %call)
  br label %afterprint

notfound:                                         ; preds = %entry
  %s = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %ps = call i32 @puts(i8* %s)
  br label %afterprint

afterprint:                                       ; preds = %notfound, %found
  %canary.saved = load i64, i64* %canary.slot, align 8
  %canary.cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary.saved, %canary.cur
  br i1 %ok, label %ret, label %stkfail

stkfail:                                          ; preds = %afterprint
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %afterprint
  ret i32 0
}
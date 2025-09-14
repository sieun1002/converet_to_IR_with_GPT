; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: Sort and print an integer array using quick_sort (confidence=0.75). Evidence: quick_sort(arr, 0, len-1); prints "%d " in a loop, then newline.
; Preconditions: none
; Postconditions: prints the (sorted) array elements followed by a newline to stdout

@format = private unnamed_addr constant [4 x i8] c"%d \00"
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i32, i64)
declare void @__stack_chk_fail()

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  ; stack canary setup
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %canary.slot, align 8

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %len, align 8

  ; if (len > 1) quick_sort(arr, 0, len-1)
  %len.val = load i64, i64* %len, align 8
  %len.le1 = icmp ule i64 %len.val, 1
  br i1 %len.le1, label %print.init, label %do.sort

do.sort:
  %last = add i64 %len.val, -1
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr.base, i32 0, i64 %last)
  br label %print.init

print.init:
  store i64 0, i64* %i, align 8
  br label %print.loop

print.loop:
  %it = load i64, i64* %i, align 8
  %n = load i64, i64* %len, align 8
  %cont = icmp ult i64 %it, %n
  br i1 %cont, label %print.body, label %print.done

print.body:
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %it
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elt)
  %next = add i64 %it, 1
  store i64 %next, i64* %i, align 8
  br label %print.loop

print.done:
  %call.putchar = call i32 @putchar(i32 10)

  ; stack canary check
  %saved = load i64, i64* %canary.slot, align 8
  %now = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %now
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}
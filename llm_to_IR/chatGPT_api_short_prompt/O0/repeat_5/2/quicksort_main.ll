; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: Sort and print a fixed array using quick_sort (confidence=0.90). Evidence: call to quick_sort with bounds; loop printing elements via printf.
; Preconditions: quick_sort has signature void quick_sort(int*, int, int) and sorts in-place within [left, right].
; Postconditions: Prints the (sorted) array elements followed by a newline.

; Only the necessary external declarations:
declare void @quick_sort(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %arr = alloca [10 x i32], align 16

  ; stack canary setup
  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %canary, align 8

  ; initialize array: 9,1,5,3,7,2,8,6,4,0
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

  store i64 10, i64* %n, align 8

  ; if (n > 1) quick_sort(arr, 0, n-1);
  %nv = load i64, i64* %n, align 8
  %cmp.le1 = icmp ule i64 %nv, 1
  br i1 %cmp.le1, label %after.sort, label %do.sort

do.sort:
  %nv2 = load i64, i64* %n, align 8
  %right64 = add i64 %nv2, -1
  %right = trunc i64 %right64 to i32
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i32 0, i32 %right)
  br label %after.sort

after.sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %lt = icmp ult i64 %iv, %ncur
  br i1 %lt, label %body, label %after.loop

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

after.loop:
  %call.putchar = call i32 @putchar(i32 10)

  ; stack canary check
  %old.canary = load i64, i64* %canary, align 8
  %cur.guard = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %old.canary, %cur.guard
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}
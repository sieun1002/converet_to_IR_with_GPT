; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an array, heap-sort it, and print again (confidence=0.92). Evidence: local int array, two print-loops around a call to heap_sort with (int*, len)
; Preconditions: heap_sort sorts the array in-place; n = 9
; Postconditions: returns 0

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary.slot, align 8
  ; initialize array: [7,3,9,1,4,8,2,6,5]
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  ; print "Before: "
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @printf(i8* %before.ptr)
  br label %loop.pre

loop.pre:
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cond = icmp ult i64 %i, 9
  br i1 %cond, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt_d, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %inc = add i64 %i, 1
  br label %loop.pre

loop.end:
  %nl1 = call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 9)
  ; print "After: "
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @printf(i8* %after.ptr)
  br label %loop2.pre

loop2.pre:
  %j = phi i64 [ 0, %loop.end ], [ %inc2, %loop2.body ]
  %cond2 = icmp ult i64 %j, 9
  br i1 %cond2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt_d, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %elem2)
  %inc2 = add i64 %j, 1
  br label %loop2.pre

loop2.end:
  %nl2 = call i32 @putchar(i32 10)
  %g1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %saved, %g1
  br i1 %ok, label %ret.ok, label %ret.fail

ret.fail:
  call void @__stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}
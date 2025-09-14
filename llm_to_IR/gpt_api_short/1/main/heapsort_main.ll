; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an array before and after sorting with heap_sort (confidence=0.86). Evidence: printf of "%d " in loops; call to heap_sort with base pointer and length
; Preconditions: none
; Postconditions: returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [1 x i8] c"\00"
@aD = private unnamed_addr constant [4 x i8] c"%d \00"
@byte_2011 = private unnamed_addr constant [1 x i8] c"\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary, align 8

  ; Initialize arr = {7,3,9,1,4,8,2,6,5}
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4

  ; printf(format)
  %fmt0 = getelementptr inbounds [1 x i8], [1 x i8]* @format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  ; for (i = 0; i < 9; ++i) printf("%d ", arr[i]);
  br label %loop1

loop1:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body.end ]
  %cond1 = icmp ult i64 %i, 9
  br i1 %cond1, label %loop1.body, label %after_loop1

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtd = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtd, i32 %val)
  br label %loop1.body.end

loop1.body.end:
  %i.next = add i64 %i, 1
  br label %loop1

after_loop1:
  %pc0 = call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], 9)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  ; printf(byte_2011)
  %fmt1 = getelementptr inbounds [1 x i8], [1 x i8]* @byte_2011, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1)

  ; for (j = 0; j < 9; ++j) printf("%d ", arr[j]);
  br label %loop2

loop2:
  %j = phi i64 [ 0, %after_loop1 ], [ %j.next, %loop2.body.end ]
  %cond2 = icmp ult i64 %j, 9
  br i1 %cond2, label %loop2.body, label %after_loop2

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmtd2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtd2, i32 %val2)
  br label %loop2.body.end

loop2.body.end:
  %j.next = add i64 %j, 1
  br label %loop2

after_loop2:
  %pc1 = call i32 @putchar(i32 10)

  ; stack canary check
  %g1 = load i64, i64* @__stack_chk_guard, align 8
  %g.saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %g1, %g.saved
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}
; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: Initialize an array, sort it with merge_sort, and print elements (confidence=0.86). Evidence: call to merge_sort, printf with "%d ", loop over array length
; Preconditions: None
; Postconditions: Prints array contents followed by newline; returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @merge_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guardslot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %guardslot, align 8

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

  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* %base, i64 10)

  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elt.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %elt = load i32, i32* %elt.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elt)
  br label %for.inc

for.inc:
  %inc = add i64 %i, 1
  br label %for.cond

for.end:
  %pc = call i32 @putchar(i32 10)
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %guardslot, align 8
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}
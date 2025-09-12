; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144b
; Intent: Print an integer array, sort it with heap_sort, then print the sorted array (confidence=0.90). Evidence: call to heap_sort with base pointer and length=9; two print loops using "%d ".
; Preconditions: heap_sort expects a valid pointer to i32 elements and length (i64) 9; it may modify the array in place.
; Postconditions: returns 0

@format = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_2011 = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %idx8, align 4

  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @format, i64 0, i64 0
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @byte_2011, i64 0, i64 0

  %call_print0 = call i32 @printf(i8* %fmt0)
  br label %for1.cond

for1.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for1.inc ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %for1.body, label %for1.end

for1.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem.val = load i32, i32* %elem.ptr, align 4
  %call_num0 = call i32 @printf(i8* %fmt_num, i32 %elem.val)
  br label %for1.inc

for1.inc:
  %inc = add i64 %i, 1
  br label %for1.cond

for1.end:
  %nl0 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* %arr0, i64 9)
  %call_print1 = call i32 @printf(i8* %fmt1)
  br label %for2.cond

for2.cond:
  %j = phi i64 [ 0, %for1.end ], [ %jinc, %for2.inc ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %for2.body, label %for2.end

for2.body:
  %elem2.ptr = getelementptr inbounds i32, i32* %arr0, i64 %j
  %elem2.val = load i32, i32* %elem2.ptr, align 4
  %call_num1 = call i32 @printf(i8* %fmt_num, i32 %elem2.val)
  br label %for2.inc

for2.inc:
  %jinc = add i64 %j, 1
  br label %for2.cond

for2.end:
  %nl1 = call i32 @putchar(i32 10)
  br i1 true, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}
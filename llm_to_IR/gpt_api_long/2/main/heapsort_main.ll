; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an integer array before and after in-place heap sort (confidence=0.95). Evidence: call to heap_sort(a, n); two loops printing with "%d ".
; Preconditions: heap_sort sorts n 32-bit integers at the pointer given.
; Postconditions: Returns 0.

@.str_init = private unnamed_addr constant [16 x i8] c"Original array:\00", align 1
@.str_sorted = private unnamed_addr constant [14 x i8] c"Sorted array:\00", align 1
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [9 x i32], align 16
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %base, align 4
  %idx1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 5, i32* %idx8, align 4
  %n = add i64 0, 9
  %fmt0 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_init, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i.0, %n
  br i1 %cmp1, label %loop1.body, label %after1

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr1 = getelementptr inbounds i32, i32* %base, i64 %i.0
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmtd1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd1, i32 %elem1)
  %i.next = add i64 %i.0, 1
  br label %loop1.cond

after1:                                           ; preds = %loop1.cond
  call i32 @putchar(i32 10)
  call void @heap_sort(i32* %base, i64 %n)
  %fmt1 = getelementptr inbounds [14 x i8], [14 x i8]* @.str_sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %after1
  %j.0 = phi i64 [ 0, %after1 ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j.0, %n
  br i1 %cmp2, label %loop2.body, label %after2

loop2.body:                                      ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds i32, i32* %base, i64 %j.0
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmtd2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd2, i32 %elem2)
  %j.next = add i64 %j.0, 1
  br label %loop2.cond

after2:                                           ; preds = %loop2.cond
  call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stkfail

ret:                                              ; preds = %after2
  ret i32 0

stkfail:                                          ; preds = %after2
  call void @__stack_chk_fail()
  unreachable
}
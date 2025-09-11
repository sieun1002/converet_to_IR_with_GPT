; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x40141B
; Intent: Print an i32 array before and after in-place heapsort (confidence=0.95). Evidence: stack array init, two print loops with "%d ", newline via putchar, call to heap_sort(a,n).
; Preconditions: heap_sort is available as void @heap_sort(i32*, i64).
; Postconditions: Returns 0 after printing unsorted and sorted arrays.

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00"
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00"
@.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
%arr = alloca [9 x i32], align 16
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

%before_s = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
call i32 (i8*, ...) @printf(i8* %before_s)

br label %print1.loop

print1.loop:
%i1 = phi i64 [ 0, %entry ], [ %i1.next, %print1.body ]
%i1.cmp = icmp ult i64 %i1, 9
br i1 %i1.cmp, label %print1.body, label %print1.end

print1.body:
%elem1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
%elem1 = load i32, i32* %elem1.ptr, align 4
%fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem1)
%i1.next = add i64 %i1, 1
br label %print1.loop

print1.end:
call i32 @putchar(i32 10)

%a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
call void @heap_sort(i32* %a0, i64 9)

%after_s = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
call i32 (i8*, ...) @printf(i8* %after_s)

br label %print2.loop

print2.loop:
%i2 = phi i64 [ 0, %print1.end ], [ %i2.next, %print2.body ]
%i2.cmp = icmp ult i64 %i2, 9
br i1 %i2.cmp, label %print2.body, label %print2.end

print2.body:
%elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
%elem2 = load i32, i32* %elem2.ptr, align 4
%fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem2)
%i2.next = add i64 %i2, 1
br label %print2.loop

print2.end:
call i32 @putchar(i32 10)
ret i32 0
}
; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an array, heap-sort it, then print it again (confidence=0.95). Evidence: two print loops around a call to heap_sort
; Preconditions:
; Postconditions:

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

@.str = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
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
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)
  br label %print_loop

print_loop:
  %i = phi i64 [ 0, %entry ], [ %inc, %print_body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %print_body, label %after_print

print_body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem)
  %inc = add nuw nsw i64 %i, 1
  br label %print_loop

after_print:
  call i32 @putchar(i32 10)
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arrdecay, i64 9)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str2, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)
  br label %print_loop2

print_loop2:
  %j = phi i64 [ 0, %after_print ], [ %inc2, %print_body2 ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %print_body2, label %after_print2

print_body2:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_d2, i32 %elem2)
  %inc2 = add nuw nsw i64 %j, 1
  br label %print_loop2

after_print2:
  call i32 @putchar(i32 10)
  ret i32 0
}
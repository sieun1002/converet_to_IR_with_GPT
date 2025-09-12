; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an array before and after sorting it with heap_sort (confidence=0.86). Evidence: loops printing "%d ", call to heap_sort with base pointer and length.
; Preconditions: None
; Postconditions: Returns 0 after printing arrays before and after sorting.

@.str_before = private unnamed_addr constant [18 x i8] c"Before sorting: \00", align 1
@.str_after = private unnamed_addr constant [17 x i8] c"After sorting: \00", align 1
@.str_int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  ; initialize array: [7,3,9,1,4,8,2,6,5]
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 16
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 8
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 16
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 8
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 16

  ; print "Before sorting: "
  %before_ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_before, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @printf(i8* %before_ptr)

  ; print elements before sort
  br label %loop.pre

loop.pre:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_int, i64 0, i64 0
  %call_print = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop.pre

loop.end:
  ; newline
  %nl = call i32 @putchar(i32 10)

  ; sort
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 9)

  ; print "After sorting: "
  %after_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str_after, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @printf(i8* %after_ptr)

  ; print elements after sort
  br label %loop2.pre

loop2.pre:
  %j = phi i64 [ 0, %loop.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call_print2 = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem2)
  %j.next = add nuw nsw i64 %j, 1
  br label %loop2.pre

loop2.end:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
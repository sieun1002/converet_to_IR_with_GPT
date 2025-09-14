; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x144B
; Intent: Print an integer array, heap-sort it via external heap_sort(int*,size_t), then print sorted array (confidence=0.95). Evidence: call to heap_sort with int* and length; two printf loops around it.
; Preconditions: heap_sort follows C-ABI: void heap_sort(i32* a, i64 n)
; Postconditions: None

@.str_before = private unnamed_addr constant [17 x i8] c"Original array: \00"
@.str_after = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00"

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
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
  %before_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str_before, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %before_ptr)
  br label %pre_loop.cond

pre_loop.cond:                                   ; preds = %pre_loop.body, %entry
  %i.pre = phi i64 [ 0, %entry ], [ %inc.pre, %pre_loop.body ]
  %cmp.pre = icmp ult i64 %i.pre, 9
  br i1 %cmp.pre, label %pre_loop.body, label %pre_loop.end

pre_loop.body:                                   ; preds = %pre_loop.cond
  %elem.pre = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.pre
  %val.pre = load i32, i32* %elem.pre, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %val.pre)
  %inc.pre = add nuw nsw i64 %i.pre, 1
  br label %pre_loop.cond

pre_loop.end:                                    ; preds = %pre_loop.cond
  call i32 @putchar(i32 10)
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %base, i64 9)
  %after_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_after, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %after_ptr)
  br label %post_loop.cond

post_loop.cond:                                  ; preds = %post_loop.body, %pre_loop.end
  %i.post = phi i64 [ 0, %pre_loop.end ], [ %inc.post, %post_loop.body ]
  %cmp.post = icmp ult i64 %i.post, 9
  br i1 %cmp.post, label %post_loop.body, label %post_loop.end

post_loop.body:                                  ; preds = %post_loop.cond
  %elem.post = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.post
  %val.post = load i32, i32* %elem.post, align 4
  %fmt_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_ptr2, i32 %val.post)
  %inc.post = add nuw nsw i64 %i.post, 1
  br label %post_loop.cond

post_loop.end:                                   ; preds = %post_loop.cond
  call i32 @putchar(i32 10)
  ret i32 0
}
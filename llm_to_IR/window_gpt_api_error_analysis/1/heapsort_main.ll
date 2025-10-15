; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [17 x i8] c"Original array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_14000400D = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @sift_down(i32* %arr, i64 %n, i64 %start) {
entry:
  %root = alloca i64, align 8
  store i64 %start, i64* %root, align 8
  br label %loop

loop:
  %rootv = load i64, i64* %root, align 8
  %mul = mul i64 %rootv, 2
  %l1 = add i64 %mul, 1
  %has_left = icmp ult i64 %l1, %n
  br i1 %has_left, label %check_children, label %done

check_children:
  %p_root = getelementptr inbounds i32, i32* %arr, i64 %rootv
  %v_root = load i32, i32* %p_root, align 4
  %p_left = getelementptr inbounds i32, i32* %arr, i64 %l1
  %v_left = load i32, i32* %p_left, align 4
  %cmp_left = icmp sgt i32 %v_left, %v_root
  br i1 %cmp_left, label %left_larger, label %left_not_larger

left_larger:
  br label %after_left

left_not_larger:
  br label %after_left

after_left:
  %largest_index = phi i64 [ %l1, %left_larger ], [ %rootv, %left_not_larger ]
  %largest_value = phi i32 [ %v_left, %left_larger ], [ %v_root, %left_not_larger ]
  %r = add i64 %l1, 1
  %has_right = icmp ult i64 %r, %n
  br i1 %has_right, label %check_right, label %after_right

check_right:
  %p_right = getelementptr inbounds i32, i32* %arr, i64 %r
  %v_right = load i32, i32* %p_right, align 4
  %cmp_right = icmp sgt i32 %v_right, %largest_value
  br i1 %cmp_right, label %right_larger, label %right_not_larger

right_larger:
  br label %after_right

right_not_larger:
  br label %after_right

after_right:
  %largest_index2 = phi i64 [ %r, %right_larger ], [ %largest_index, %right_not_larger ], [ %largest_index, %after_left ]
  %largest_value2 = phi i32 [ %v_right, %right_larger ], [ %largest_value, %right_not_larger ], [ %largest_value, %after_left ]
  %cmp_root_largest = icmp eq i64 %largest_index2, %rootv
  br i1 %cmp_root_largest, label %done, label %do_swap

do_swap:
  %p_root2 = getelementptr inbounds i32, i32* %arr, i64 %rootv
  %p_largest = getelementptr inbounds i32, i32* %arr, i64 %largest_index2
  %val_root2 = load i32, i32* %p_root2, align 4
  %val_largest2 = load i32, i32* %p_largest, align 4
  store i32 %val_largest2, i32* %p_root2, align 4
  store i32 %val_root2, i32* %p_largest, align 4
  store i64 %largest_index2, i64* %root, align 8
  br label %loop

done:
  ret void
}

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp = icmp ult i64 %n, 2
  br i1 %cmp, label %ret, label %heapify

heapify:
  %half = udiv i64 %n, 2
  %start = sub i64 %half, 1
  br label %heapify_loop

heapify_loop:
  %i = phi i64 [ %start, %heapify ], [ %i_dec, %heapify_iter_end ]
  call void @sift_down(i32* %arr, i64 %n, i64 %i)
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %sort_init, label %heapify_iter_end

heapify_iter_end:
  %i_dec = add i64 %i, -1
  br label %heapify_loop

sort_init:
  %end = sub i64 %n, 1
  br label %sort_loop

sort_loop:
  %e = phi i64 [ %end, %sort_init ], [ %e_dec, %sort_iter_end ]
  %zero_cmp = icmp eq i64 %e, 0
  br i1 %zero_cmp, label %ret, label %sort_body

sort_body:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %pe = getelementptr inbounds i32, i32* %arr, i64 %e
  %v0 = load i32, i32* %p0, align 4
  %ve = load i32, i32* %pe, align 4
  store i32 %ve, i32* %p0, align 4
  store i32 %v0, i32* %pe, align 4
  call void @sift_down(i32* %arr, i64 %e, i64 0)
  br label %sort_iter_end

sort_iter_end:
  %e_dec = add i64 %e, -1
  br label %sort_loop

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %len = alloca i64, align 8
  store i64 9, i64* %len, align 8
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
  %fmt1 = getelementptr inbounds [17 x i8], [17 x i8]* @_Format, i64 0, i64 0
  %call0 = call i32 @printf(i8* %fmt1)
  store i64 0, i64* %i, align 8
  br label %loop_print

loop_print:
  %iv = load i64, i64* %i, align 8
  %n1 = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %n1
  br i1 %cond, label %body_print, label %after_print

body_print:
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %gepelem = getelementptr inbounds i32, i32* %arrptr, i64 %iv
  %val = load i32, i32* %gepelem, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %pr = call i32 @printf(i8* %fmt2, i32 %val)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_print

after_print:
  %call_putchar1 = call i32 @putchar(i32 10)
  %arrptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arrptr2, i64 %n2)
  %fmt3 = getelementptr inbounds [15 x i8], [15 x i8]* @byte_14000400D, i64 0, i64 0
  %call1 = call i32 @printf(i8* %fmt3)
  store i64 0, i64* %j, align 8
  br label %loop_print2

loop_print2:
  %jv = load i64, i64* %j, align 8
  %n3 = load i64, i64* %len, align 8
  %cond2 = icmp ult i64 %jv, %n3
  br i1 %cond2, label %body_print2, label %after_print2

body_print2:
  %arrptr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %gepelem2 = getelementptr inbounds i32, i32* %arrptr3, i64 %jv
  %val2 = load i32, i32* %gepelem2, align 4
  %fmt4 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %pr2 = call i32 @printf(i8* %fmt4, i32 %val2)
  %inc2 = add i64 %jv, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop_print2

after_print2:
  %call_putchar2 = call i32 @putchar(i32 10)
  ret i32 0
}
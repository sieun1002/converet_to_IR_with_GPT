; ModuleID = 'merged_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %tmp = alloca i32, i64 %n, align 4
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %recurse

recurse:
  %mid = lshr i64 %n, 1
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %n_right = sub i64 %n, %mid
  call void @merge_sort(i32* %arr, i64 %mid)
  call void @merge_sort(i32* %right_ptr, i64 %n_right)
  br label %merge.cond

merge.cond:
  %li = phi i64 [ 0, %recurse ], [ %li2, %merge.next ]
  %ri = phi i64 [ 0, %recurse ], [ %ri2, %merge.next ]
  %ki = phi i64 [ 0, %recurse ], [ %ki2, %merge.next ]
  %li_lt = icmp ult i64 %li, %mid
  %ri_lt = icmp ult i64 %ri, %n_right
  %both = and i1 %li_lt, %ri_lt
  br i1 %both, label %merge.body, label %merge.tail

merge.body:
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %li
  %lv = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %right_ptr, i64 %ri
  %rv = load i32, i32* %rptr, align 4
  %cmp_le = icmp sle i32 %lv, %rv
  br i1 %cmp_le, label %take_left, label %take_right

take_left:
  %dst_l = getelementptr inbounds i32, i32* %tmp, i64 %ki
  store i32 %lv, i32* %dst_l, align 4
  %li.next = add i64 %li, 1
  br label %merge.next

take_right:
  %dst_r = getelementptr inbounds i32, i32* %tmp, i64 %ki
  store i32 %rv, i32* %dst_r, align 4
  %ri.next = add i64 %ri, 1
  br label %merge.next

merge.next:
  %li2 = phi i64 [ %li.next, %take_left ], [ %li, %take_right ]
  %ri2 = phi i64 [ %ri, %take_left ], [ %ri.next, %take_right ]
  %ki2 = add i64 %ki, 1
  br label %merge.cond

merge.tail:
  %li3 = phi i64 [ %li, %merge.cond ]
  %ri3 = phi i64 [ %ri, %merge.cond ]
  %ki3 = phi i64 [ %ki, %merge.cond ]
  br label %left.loop.cond

left.loop.cond:
  %li4 = phi i64 [ %li3, %merge.tail ], [ %li4.next, %left.loop.body ]
  %ki4 = phi i64 [ %ki3, %merge.tail ], [ %ki4.next, %left.loop.body ]
  %li_rem = icmp ult i64 %li4, %mid
  br i1 %li_rem, label %left.loop.body, label %after.left

left.loop.body:
  %lptr.rem = getelementptr inbounds i32, i32* %arr, i64 %li4
  %lv.rem = load i32, i32* %lptr.rem, align 4
  %dst.rem.l = getelementptr inbounds i32, i32* %tmp, i64 %ki4
  store i32 %lv.rem, i32* %dst.rem.l, align 4
  %li4.next = add i64 %li4, 1
  %ki4.next = add i64 %ki4, 1
  br label %left.loop.cond

after.left:
  %ki5 = phi i64 [ %ki3, %merge.tail ], [ %ki4, %left.loop.cond ]
  %ri5 = phi i64 [ %ri3, %merge.tail ], [ %ri3, %left.loop.cond ]
  br label %right.loop.cond

right.loop.cond:
  %ri6 = phi i64 [ %ri5, %after.left ], [ %ri6.next, %right.loop.body ]
  %ki6 = phi i64 [ %ki5, %after.left ], [ %ki6.next, %right.loop.body ]
  %ri_rem = icmp ult i64 %ri6, %n_right
  br i1 %ri_rem, label %right.loop.body, label %copy.back

right.loop.body:
  %rptr.rem = getelementptr inbounds i32, i32* %right_ptr, i64 %ri6
  %rv.rem = load i32, i32* %rptr.rem, align 4
  %dst.rem.r = getelementptr inbounds i32, i32* %tmp, i64 %ki6
  store i32 %rv.rem, i32* %dst.rem.r, align 4
  %ri6.next = add i64 %ri6, 1
  %ki6.next = add i64 %ki6, 1
  br label %right.loop.cond

copy.back:
  br label %back.cond

back.cond:
  %t = phi i64 [ 0, %copy.back ], [ %t.next, %back.body ]
  %t_lt = icmp ult i64 %t, %n
  br i1 %t_lt, label %back.body, label %ret

back.body:
  %src.t = getelementptr inbounds i32, i32* %tmp, i64 %t
  %val.t = load i32, i32* %src.t, align 4
  %dst.t = getelementptr inbounds i32, i32* %arr, i64 %t
  store i32 %val.t, i32* %dst.t, align 4
  %t.next = add i64 %t, 1
  br label %back.cond

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* %arr0, i64 10)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, 10
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop.cond

after.loop:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}
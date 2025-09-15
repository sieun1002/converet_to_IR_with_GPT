; ModuleID = 'quicksort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  %len_le1 = icmp ule i64 %lenv, 1
  br i1 %len_le1, label %loop_init, label %do_sort

do_sort:                                          ; preds = %entry
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high = add i64 %lenv, -1
  call void bitcast (void (i32*, i64, i64)* @quick_sort to void (i32*, i32, i64)*)(i32* noundef %baseptr, i32 noundef 0, i64 noundef %high)
  br label %loop_init

loop_init:                                        ; preds = %do_sort, %entry
  br label %loop

loop:                                             ; preds = %after_print, %loop_init
  %i = phi i64 [ 0, %loop_init ], [ %next, %after_print ]
  %cur_len = load i64, i64* %len, align 8
  %cond = icmp ult i64 %i, %cur_len
  br i1 %cond, label %print, label %done

print:                                            ; preds = %loop
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %elem)
  br label %after_print

after_print:                                      ; preds = %print
  %next = add i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %call_putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %cont.right, %cont.left, %entry
  %left.ph = phi i64 [ %left, %entry ], [ %left.next.left, %cont.left ], [ %left.next.right, %cont.right ]
  %right.ph = phi i64 [ %right, %entry ], [ %right.next.left, %cont.left ], [ %right.next.right, %cont.right ]
  %cmp.outer = icmp slt i64 %left.ph, %right.ph
  br i1 %cmp.outer, label %partition.init, label %return

partition.init:                                   ; preds = %outer.header
  %i.init = add i64 %left.ph, 0
  %j.init = add i64 %right.ph, 0
  %diff = sub i64 %right.ph, %left.ph
  %half = sdiv i64 %diff, 2
  %mid = add i64 %left.ph, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %inner.iter

inner.iter:                                       ; preds = %swap.cont, %partition.init
  %i.cur = phi i64 [ %i.init, %partition.init ], [ %i.after, %swap.cont ]
  %j.cur = phi i64 [ %j.init, %partition.init ], [ %j.after, %swap.cont ]
  br label %inc_i.loop

inc_i.loop:                                       ; preds = %inc_i.body, %inner.iter
  %i.c = phi i64 [ %i.cur, %inner.iter ], [ %i.inc, %inc_i.body ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.c
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.body, label %inc_i.exit

inc_i.body:                                       ; preds = %inc_i.loop
  %i.inc = add i64 %i.c, 1
  br label %inc_i.loop

inc_i.exit:                                       ; preds = %inc_i.loop
  %i.out = phi i64 [ %i.c, %inc_i.loop ]
  br label %dec_j.loop

dec_j.loop:                                       ; preds = %dec_j.body, %inc_i.exit
  %i.keep = phi i64 [ %i.out, %inc_i.exit ], [ %i.keep, %dec_j.body ]
  %j.c = phi i64 [ %j.cur, %inc_i.exit ], [ %j.dec, %dec_j.body ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.body, label %dec_j.exit

dec_j.body:                                       ; preds = %dec_j.loop
  %j.dec = add i64 %j.c, -1
  br label %dec_j.loop

dec_j.exit:                                       ; preds = %dec_j.loop
  br label %cmp.swap

cmp.swap:                                         ; preds = %dec_j.exit
  %cmp.ij = icmp sgt i64 %i.keep, %j.c
  br i1 %cmp.ij, label %after.partition, label %do.swap

do.swap:                                          ; preds = %cmp.swap
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.keep
  %val.i.swap = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %val.j.swap = load i32, i32* %ptr.j.swap, align 4
  store i32 %val.j.swap, i32* %ptr.i.swap, align 4
  store i32 %val.i.swap, i32* %ptr.j.swap, align 4
  %i.after = add i64 %i.keep, 1
  %j.after = add i64 %j.c, -1
  br label %swap.cont

swap.cont:                                        ; preds = %do.swap
  br label %inner.iter

after.partition:                                  ; preds = %cmp.swap
  %size.left = sub i64 %j.c, %left.ph
  %size.right = sub i64 %right.ph, %i.keep
  %left.smaller = icmp slt i64 %size.left, %size.right
  br i1 %left.smaller, label %left.case, label %right.case

left.case:                                        ; preds = %after.partition
  %cond.left = icmp slt i64 %left.ph, %j.c
  br i1 %cond.left, label %left.call, label %left.skip

left.call:                                        ; preds = %left.case
  call void @quick_sort(i32* %arr, i64 %left.ph, i64 %j.c)
  br label %cont.left

left.skip:                                        ; preds = %left.case
  br label %cont.left

cont.left:                                        ; preds = %left.skip, %left.call
  %left.next.left = add i64 %i.keep, 0
  %right.next.left = add i64 %right.ph, 0
  br label %outer.header

right.case:                                       ; preds = %after.partition
  %cond.right = icmp slt i64 %i.keep, %right.ph
  br i1 %cond.right, label %right.call, label %right.skip

right.call:                                       ; preds = %right.case
  call void @quick_sort(i32* %arr, i64 %i.keep, i64 %right.ph)
  br label %cont.right

right.skip:                                       ; preds = %right.case
  br label %cont.right

cont.right:                                       ; preds = %right.skip, %right.call
  %left.next.right = add i64 %left.ph, 0
  %right.next.right = add i64 %j.c, 0
  br label %outer.header

return:                                           ; preds = %outer.header
  ret void
}

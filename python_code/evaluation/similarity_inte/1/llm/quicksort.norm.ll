; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/1/quicksort.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 16
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 8
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 16
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 8
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 16
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  call void bitcast (void (i32*, i64, i64)* @quick_sort to void (i32*, i32, i64)*)(i32* noundef nonnull %gep0, i32 noundef 0, i64 noundef 9)
  br label %loop

loop:                                             ; preds = %print, %entry
  %i = phi i64 [ 0, %entry ], [ %next, %print ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %print, label %done

print:                                            ; preds = %loop
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem_ptr, align 4
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
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
  %left.ph = phi i64 [ %left, %entry ], [ %i.c, %cont.left ], [ %left.ph, %cont.right ]
  %right.ph = phi i64 [ %right, %entry ], [ %right.ph, %cont.left ], [ %j.c, %cont.right ]
  %cmp.outer = icmp sgt i64 %right.ph, %left.ph
  br i1 %cmp.outer, label %partition.init, label %return

partition.init:                                   ; preds = %outer.header
  %diff = sub i64 %right.ph, %left.ph
  %half = sdiv i64 %diff, 2
  %mid = add i64 %left.ph, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %inner.iter

inner.iter:                                       ; preds = %do.swap, %partition.init
  %i.cur = phi i64 [ %left.ph, %partition.init ], [ %i.after, %do.swap ]
  %j.cur = phi i64 [ %right.ph, %partition.init ], [ %j.after, %do.swap ]
  br label %inc_i.loop

inc_i.loop:                                       ; preds = %inc_i.body, %inner.iter
  %i.c = phi i64 [ %i.cur, %inner.iter ], [ %i.inc, %inc_i.body ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.c
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.body, label %dec_j.loop

inc_i.body:                                       ; preds = %inc_i.loop
  %i.inc = add i64 %i.c, 1
  br label %inc_i.loop

dec_j.loop:                                       ; preds = %inc_i.loop, %dec_j.body
  %j.c = phi i64 [ %j.dec, %dec_j.body ], [ %j.cur, %inc_i.loop ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.c
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.body, label %cmp.swap

dec_j.body:                                       ; preds = %dec_j.loop
  %j.dec = add i64 %j.c, -1
  br label %dec_j.loop

cmp.swap:                                         ; preds = %dec_j.loop
  %cmp.ij = icmp sgt i64 %i.c, %j.c
  br i1 %cmp.ij, label %after.partition, label %do.swap

do.swap:                                          ; preds = %cmp.swap
  store i32 %j.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %j.ptr, align 4
  %j.after = add i64 %j.c, -1
  %i.after = add i64 %i.c, 1
  br label %inner.iter

after.partition:                                  ; preds = %cmp.swap
  %size.left = sub i64 %j.c, %left.ph
  %size.right = sub i64 %right.ph, %i.c
  %left.smaller = icmp slt i64 %size.left, %size.right
  br i1 %left.smaller, label %left.case, label %right.case

left.case:                                        ; preds = %after.partition
  %cond.left = icmp sgt i64 %j.c, %left.ph
  br i1 %cond.left, label %left.call, label %cont.left

left.call:                                        ; preds = %left.case
  call void @quick_sort(i32* %arr, i64 %left.ph, i64 %j.c)
  br label %cont.left

cont.left:                                        ; preds = %left.case, %left.call
  br label %outer.header

right.case:                                       ; preds = %after.partition
  %cond.right = icmp sgt i64 %right.ph, %i.c
  br i1 %cond.right, label %right.call, label %cont.right

right.call:                                       ; preds = %right.case
  call void @quick_sort(i32* %arr, i64 %i.c, i64 %right.ph)
  br label %cont.right

cont.right:                                       ; preds = %right.case, %right.call
  br label %outer.header

return:                                           ; preds = %outer.header
  ret void
}

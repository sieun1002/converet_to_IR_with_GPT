; ModuleID = 'quicksort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  %cmp_n = icmp ugt i64 10, 1
  br i1 %cmp_n, label %qs, label %after_qs

qs:                                               ; preds = %entry
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high = add i64 10, -1
  call void @quick_sort(i32* noundef %base, i64 noundef 0, i64 noundef %high)
  br label %after_qs

after_qs:                                         ; preds = %qs, %entry
  br label %loop

loop:                                             ; preds = %inc, %after_qs
  %i = phi i64 [ 0, %after_qs ], [ %i.next, %inc ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %elem)
  br label %inc

inc:                                              ; preds = %body
  %i.next = add i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %call_putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @quick_sort(i32* noundef %arr, i64 noundef %low, i64 noundef %high) {
entry:
  br label %loop.check

loop.check:                                       ; preds = %after.right.call, %after.left.call, %entry
  %low.cur = phi i64 [ %low, %entry ], [ %i.for.j, %after.left.call ], [ %low.cur, %after.right.call ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.cur, %after.left.call ], [ %j.cur2, %after.right.call ]
  %cmp.lh = icmp slt i64 %low.cur, %high.cur
  br i1 %cmp.lh, label %part.init, label %exit

part.init:                                        ; preds = %loop.check
  %diff = sub i64 %high.cur, %low.cur
  %sign = lshr i64 %diff, 63
  %diff.adj = add i64 %diff, %sign
  %half = ashr i64 %diff.adj, 1
  %mid = add i64 %low.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %i.scan

i.scan:                                           ; preds = %after.swap, %i.inc, %part.init
  %i.cur = phi i64 [ %low.cur, %part.init ], [ %i.inc.val, %i.inc ], [ %i.after.swap, %after.swap ]
  %j.hold = phi i64 [ %high.cur, %part.init ], [ %j.hold, %i.inc ], [ %j.after.swap, %after.swap ]
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i.cur = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp sgt i32 %pivot, %val.i.cur
  br i1 %cmp.i, label %i.inc, label %j.scan

i.inc:                                            ; preds = %i.scan
  %i.inc.val = add nsw i64 %i.cur, 1
  br label %i.scan

j.scan:                                           ; preds = %j.dec, %i.scan
  %i.for.j = phi i64 [ %i.cur, %i.scan ], [ %i.for.j, %j.dec ]
  %j.cur2 = phi i64 [ %j.hold, %i.scan ], [ %j.dec.val, %j.dec ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur2
  %val.j.cur = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp slt i32 %pivot, %val.j.cur
  br i1 %cmp.j, label %j.dec, label %compare

j.dec:                                            ; preds = %j.scan
  %j.dec.val = add nsw i64 %j.cur2, -1
  br label %j.scan

compare:                                          ; preds = %j.scan
  %le.ij = icmp sle i64 %i.for.j, %j.cur2
  br i1 %le.ij, label %swap, label %part.done

swap:                                             ; preds = %compare
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.for.j
  %a.i = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.cur2
  %a.j = load i32, i32* %ptr.j.swap, align 4
  store i32 %a.j, i32* %ptr.i.swap, align 4
  store i32 %a.i, i32* %ptr.j.swap, align 4
  br label %after.swap

after.swap:                                       ; preds = %swap
  %i.after.swap = add nsw i64 %i.for.j, 1
  %j.after.swap = add nsw i64 %j.cur2, -1
  br label %i.scan

part.done:                                        ; preds = %compare
  %left.size = sub nsw i64 %j.cur2, %low.cur
  %right.size = sub nsw i64 %high.cur, %i.for.j
  %choose.right = icmp sge i64 %left.size, %right.size
  br i1 %choose.right, label %cont.right, label %cont.left

cont.left:                                        ; preds = %part.done
  %do.left = icmp slt i64 %low.cur, %j.cur2
  br i1 %do.left, label %call.left, label %after.left.call

call.left:                                        ; preds = %cont.left
  call void @quick_sort(i32* noundef %arr, i64 noundef %low.cur, i64 noundef %j.cur2)
  br label %after.left.call

after.left.call:                                  ; preds = %call.left, %cont.left
  br label %loop.check

cont.right:                                       ; preds = %part.done
  %do.right = icmp slt i64 %i.for.j, %high.cur
  br i1 %do.right, label %call.right, label %after.right.call

call.right:                                       ; preds = %cont.right
  call void @quick_sort(i32* noundef %arr, i64 noundef %i.for.j, i64 noundef %high.cur)
  br label %after.right.call

after.right.call:                                 ; preds = %call.right, %cont.right
  br label %loop.check

exit:                                             ; preds = %loop.check
  ret void
}

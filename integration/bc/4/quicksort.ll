; ModuleID = 'quicksort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds i32, i32* %arr.gep0, i64 1
  store i32 1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds i32, i32* %arr.gep0, i64 2
  store i32 5, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds i32, i32* %arr.gep0, i64 3
  store i32 3, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds i32, i32* %arr.gep0, i64 4
  store i32 7, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds i32, i32* %arr.gep0, i64 5
  store i32 2, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds i32, i32* %arr.gep0, i64 6
  store i32 8, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds i32, i32* %arr.gep0, i64 7
  store i32 6, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds i32, i32* %arr.gep0, i64 8
  store i32 4, i32* %arr.gep8, align 4
  %arr.gep9 = getelementptr inbounds i32, i32* %arr.gep0, i64 9
  store i32 0, i32* %arr.gep9, align 4
  %cmp.init = icmp ugt i64 10, 1
  br i1 %cmp.init, label %do.sort, label %after.sort

do.sort:                                          ; preds = %entry
  %high = add i64 10, -1
  call void @quick_sort(i32* nonnull %arr.gep0, i64 0, i64 %high)
  br label %after.sort

after.sort:                                       ; preds = %do.sort, %entry
  br label %loop.header

loop.header:                                      ; preds = %loop.body, %after.sort
  %i = phi i64 [ 0, %after.sort ], [ %i.next, %loop.body ]
  %cmp.loop = icmp ult i64 %i, 10
  br i1 %cmp.loop, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.header
  %elem.ptr = getelementptr inbounds i32, i32* %arr.gep0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* nonnull %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop.header

loop.end:                                         ; preds = %loop.header
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %left, i64 %right) {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %right.update, %left.update, %entry
  %left.cur = phi i64 [ %left, %entry ], [ %left.next.L, %left.update ], [ %left.next.R, %right.update ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.next.L, %left.update ], [ %right.next.R, %right.update ]
  %cmp.outer = icmp slt i64 %left.cur, %right.cur
  br i1 %cmp.outer, label %partition.entry, label %return

partition.entry:                                  ; preds = %outer.loop
  %i.init = add i64 %left.cur, 0
  %j.init = add i64 %right.cur, 0
  %diff = sub i64 %right.cur, %left.cur
  %sign = lshr i64 %diff, 63
  %sum = add i64 %diff, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %left.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %inc.i.check

inc.i.check:                                      ; preds = %do.swap, %inc.i.body, %partition.entry
  %i.cur = phi i64 [ %i.init, %partition.entry ], [ %i.next, %inc.i.body ], [ %i.inc, %do.swap ]
  %j.forinc = phi i64 [ %j.init, %partition.entry ], [ %j.init, %inc.i.body ], [ %j.dec, %do.swap ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot.val
  br i1 %cmp.i, label %inc.i.body, label %dec.j.check

inc.i.body:                                       ; preds = %inc.i.check
  %i.next = add i64 %i.cur, 1
  br label %inc.i.check

dec.j.check:                                      ; preds = %dec.j.body, %inc.i.check
  %i.afterinc = phi i64 [ %i.cur, %inc.i.check ], [ %i.cur, %dec.j.body ]
  %j.cur = phi i64 [ %j.forinc, %inc.i.check ], [ %j.next, %dec.j.body ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot.val
  br i1 %cmp.j, label %dec.j.body, label %partition.compare

dec.j.body:                                       ; preds = %dec.j.check
  %j.next = add i64 %j.cur, -1
  br label %dec.j.check

partition.compare:                                ; preds = %dec.j.check
  %cmp.le = icmp sle i64 %i.afterinc, %j.cur
  br i1 %cmp.le, label %do.swap, label %after.partition

do.swap:                                          ; preds = %partition.compare
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.afterinc
  %val.i.swap = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j.swap = load i32, i32* %ptr.j.swap, align 4
  store i32 %val.j.swap, i32* %ptr.i.swap, align 4
  store i32 %val.i.swap, i32* %ptr.j.swap, align 4
  %i.inc = add i64 %i.afterinc, 1
  %j.dec = add i64 %j.cur, -1
  br label %inc.i.check

after.partition:                                  ; preds = %partition.compare
  %i.final = add i64 %i.afterinc, 0
  %j.final = add i64 %j.cur, 0
  %left.span = sub i64 %j.final, %left.cur
  %right.span = sub i64 %right.cur, %i.final
  %cmp.sizes = icmp sge i64 %left.span, %right.span
  br i1 %cmp.sizes, label %right.branch, label %left.branch

left.branch:                                      ; preds = %after.partition
  %need.left = icmp slt i64 %left.cur, %j.final
  br i1 %need.left, label %left.recurse, label %left.update

left.recurse:                                     ; preds = %left.branch
  call void @quick_sort(i32* %arr, i64 %left.cur, i64 %j.final)
  br label %left.update

left.update:                                      ; preds = %left.recurse, %left.branch
  %left.next.L = add i64 %i.final, 0
  %right.next.L = add i64 %right.cur, 0
  br label %outer.loop

right.branch:                                     ; preds = %after.partition
  %need.right = icmp slt i64 %i.final, %right.cur
  br i1 %need.right, label %right.recurse, label %right.update

right.recurse:                                    ; preds = %right.branch
  call void @quick_sort(i32* %arr, i64 %i.final, i64 %right.cur)
  br label %right.update

right.update:                                     ; preds = %right.recurse, %right.branch
  %left.next.R = add i64 %left.cur, 0
  %right.next.R = add i64 %j.final, 0
  br label %outer.loop

return:                                           ; preds = %outer.loop
  ret void
}

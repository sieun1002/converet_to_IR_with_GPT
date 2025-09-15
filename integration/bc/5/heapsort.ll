; ModuleID = 'heapsort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str_num = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  store [9 x i32] [i32 7, i32 3, i32 9, i32 1, i32 4, i32 8, i32 2, i32 6, i32 5], [9 x i32]* %arr, align 16
  %0 = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0)
  br label %for.check

for.check:                                        ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %2 = icmp ult i64 %i, 9
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.check
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %4 = load i32, i32* %3, align 4
  %5 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %6 = call i32 (i8*, ...) @printf(i8* %5, i32 %4)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i.next = add i64 %i, 1
  br label %for.check

for.end:                                          ; preds = %for.check
  %7 = call i32 @putchar(i32 10)
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %8, i64 9)
  %9 = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* %9)
  br label %for2.check

for2.check:                                       ; preds = %for2.inc, %for.end
  %j = phi i64 [ 0, %for.end ], [ %j.next, %for2.inc ]
  %11 = icmp ult i64 %j, 9
  br i1 %11, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.check
  %12 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %13 = load i32, i32* %12, align 4
  %14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_num, i64 0, i64 0
  %15 = call i32 (i8*, ...) @printf(i8* %14, i32 %13)
  br label %for2.inc

for2.inc:                                         ; preds = %for2.body
  %j.next = add i64 %j, 1
  br label %for2.check

for2.end:                                         ; preds = %for2.check
  %16 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.loop.check

build.loop.check:                                 ; preds = %build.loop.body.end, %build.init
  %i.phi = phi i64 [ %half, %build.init ], [ %i.next, %build.loop.body.end ]
  %old_nonzero = icmp ne i64 %i.phi, 0
  br i1 %old_nonzero, label %build.loop.body.start, label %build.done

build.loop.body.start:                            ; preds = %build.loop.check
  %start = add i64 %i.phi, -1
  br label %sift1.header

sift1.header:                                     ; preds = %sift1.iter.end, %build.loop.body.start
  %root1.phi = phi i64 [ %start, %build.loop.body.start ], [ %root1.next, %sift1.iter.end ]
  %twice1 = shl i64 %root1.phi, 1
  %child1 = add i64 %twice1, 1
  %child_in1 = icmp ult i64 %child1, %n
  br i1 %child_in1, label %sift1.child.check, label %sift1.done

sift1.child.check:                                ; preds = %sift1.header
  %right1 = add i64 %child1, 1
  %has_right1 = icmp ult i64 %right1, %n
  br i1 %has_right1, label %sift1.lr, label %sift1.no_right

sift1.lr:                                         ; preds = %sift1.child.check
  %ptr_right1 = getelementptr inbounds i32, i32* %arr, i64 %right1
  %val_right1 = load i32, i32* %ptr_right1, align 4
  %ptr_child1 = getelementptr inbounds i32, i32* %arr, i64 %child1
  %val_child1 = load i32, i32* %ptr_child1, align 4
  %right_gt1 = icmp sgt i32 %val_right1, %val_child1
  %maxIdx_lr1 = select i1 %right_gt1, i64 %right1, i64 %child1
  br label %sift1.after.select

sift1.no_right:                                   ; preds = %sift1.child.check
  br label %sift1.after.select

sift1.after.select:                               ; preds = %sift1.no_right, %sift1.lr
  %maxChild1 = phi i64 [ %maxIdx_lr1, %sift1.lr ], [ %child1, %sift1.no_right ]
  %ptr_root1 = getelementptr inbounds i32, i32* %arr, i64 %root1.phi
  %val_root1 = load i32, i32* %ptr_root1, align 4
  %ptr_max1 = getelementptr inbounds i32, i32* %arr, i64 %maxChild1
  %val_max1 = load i32, i32* %ptr_max1, align 4
  %ge1 = icmp sge i32 %val_root1, %val_max1
  br i1 %ge1, label %sift1.done, label %sift1.do.swap

sift1.do.swap:                                    ; preds = %sift1.after.select
  store i32 %val_max1, i32* %ptr_root1, align 4
  store i32 %val_root1, i32* %ptr_max1, align 4
  %root1.next = add i64 %maxChild1, 0
  br label %sift1.iter.end

sift1.iter.end:                                   ; preds = %sift1.do.swap
  br label %sift1.header

sift1.done:                                       ; preds = %sift1.after.select, %sift1.header
  br label %build.loop.body.end

build.loop.body.end:                              ; preds = %sift1.done
  %i.next = add i64 %i.phi, -1
  br label %build.loop.check

build.done:                                       ; preds = %build.loop.check
  %end.init = add i64 %n, -1
  br label %outer.check

outer.check:                                      ; preds = %after.inner, %build.done
  %end.phi = phi i64 [ %end.init, %build.done ], [ %end.next, %after.inner ]
  %cond2 = icmp ne i64 %end.phi, 0
  br i1 %cond2, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.check
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end.phi
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2.header

sift2.header:                                     ; preds = %sift2.iter.end, %outer.body
  %root2.phi = phi i64 [ 0, %outer.body ], [ %root2.next, %sift2.iter.end ]
  %twice2 = shl i64 %root2.phi, 1
  %child2 = add i64 %twice2, 1
  %child_in2 = icmp ult i64 %child2, %end.phi
  br i1 %child_in2, label %sift2.child.check, label %after.inner

sift2.child.check:                                ; preds = %sift2.header
  %right2 = add i64 %child2, 1
  %has_right2 = icmp ult i64 %right2, %end.phi
  br i1 %has_right2, label %sift2.lr, label %sift2.no_right

sift2.lr:                                         ; preds = %sift2.child.check
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %right_gt2 = icmp sgt i32 %val_right2, %val_child2
  %maxIdx_lr2 = select i1 %right_gt2, i64 %right2, i64 %child2
  br label %sift2.after.select

sift2.no_right:                                   ; preds = %sift2.child.check
  br label %sift2.after.select

sift2.after.select:                               ; preds = %sift2.no_right, %sift2.lr
  %maxChild2 = phi i64 [ %maxIdx_lr2, %sift2.lr ], [ %child2, %sift2.no_right ]
  %ptr_root2 = getelementptr inbounds i32, i32* %arr, i64 %root2.phi
  %val_root2 = load i32, i32* %ptr_root2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %maxChild2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %ge2 = icmp sge i32 %val_root2, %val_max2
  br i1 %ge2, label %after.inner, label %sift2.do.swap

sift2.do.swap:                                    ; preds = %sift2.after.select
  store i32 %val_max2, i32* %ptr_root2, align 4
  store i32 %val_root2, i32* %ptr_max2, align 4
  %root2.next = add i64 %maxChild2, 0
  br label %sift2.iter.end

sift2.iter.end:                                   ; preds = %sift2.do.swap
  br label %sift2.header

after.inner:                                      ; preds = %sift2.after.select, %sift2.header
  %end.next = add i64 %end.phi, -1
  br label %outer.check

ret:                                              ; preds = %outer.check, %entry
  ret void
}

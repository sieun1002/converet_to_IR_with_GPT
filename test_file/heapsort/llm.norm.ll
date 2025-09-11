; ModuleID = 'llm.ll'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.orig = private unnamed_addr constant [9 x i8] c"\EC\9B\90\EB\B3\B8: \00", align 1
@.str.sorted = private unnamed_addr constant [13 x i8] c"\EC\A0\95\EB\A0\AC \ED\9B\84: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 16
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
  %0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str.orig, i64 0, i64 0))
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %loop1.body ]
  %cmp = icmp ult i64 %i.0, 9
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elem)
  %inc = add i64 %i.0, 1
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %2 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %arr0, i64 9)
  %3 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.sorted, i64 0, i64 0))
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %i2.0 = phi i64 [ 0, %loop1.end ], [ %inc2, %loop2.body ]
  %cmp2 = icmp ult i64 %i2.0, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.0
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elem2)
  %inc2 = add i64 %i2.0, 1
  br label %loop2.cond

loop2.end:                                        ; preds = %loop2.cond
  %5 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* %a, i64 %n) {
entry:
  %n_le1 = icmp ult i64 %n, 2
  br i1 %n_le1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %i0 = lshr i64 %n, 1
  br label %build.loop

build.loop:                                       ; preds = %build.after, %build.init
  %i = phi i64 [ %i0, %build.init ], [ %i.dec, %build.after ]
  %cond.not = icmp eq i64 %i, 0
  br i1 %cond.not, label %extract.loop, label %sb.head

sb.head:                                          ; preds = %sb.swap, %build.loop
  %root.b = phi i64 [ %i, %build.loop ], [ %swap.idx.b, %sb.swap ]
  %root2x = shl i64 %root.b, 1
  %left.b = or i64 %root2x, 1
  %left.ok = icmp ult i64 %left.b, %n
  br i1 %left.ok, label %sb.has.left, label %build.after

sb.has.left:                                      ; preds = %sb.head
  %right.b = add i64 %root2x, 2
  %right.in = icmp ult i64 %right.b, %n
  br i1 %right.in, label %sb.cmp.right, label %sb.cmp.root

sb.cmp.right:                                     ; preds = %sb.has.left
  %left.ptr.b = getelementptr inbounds i32, i32* %a, i64 %left.b
  %left.val.b = load i32, i32* %left.ptr.b, align 4
  %right.ptr.b = getelementptr inbounds i32, i32* %a, i64 %right.b
  %right.val.b = load i32, i32* %right.ptr.b, align 4
  %right.gt = icmp sgt i32 %right.val.b, %left.val.b
  %spec.select = select i1 %right.gt, i64 %right.b, i64 %left.b
  br label %sb.cmp.root

sb.cmp.root:                                      ; preds = %sb.cmp.right, %sb.has.left
  %swap.idx.b = phi i64 [ %left.b, %sb.has.left ], [ %spec.select, %sb.cmp.right ]
  %root.ptr.b = getelementptr inbounds i32, i32* %a, i64 %root.b
  %root.val.b = load i32, i32* %root.ptr.b, align 4
  %swap.ptr.b = getelementptr inbounds i32, i32* %a, i64 %swap.idx.b
  %swap.val.b = load i32, i32* %swap.ptr.b, align 4
  %need.swap.b = icmp slt i32 %root.val.b, %swap.val.b
  br i1 %need.swap.b, label %sb.swap, label %build.after

sb.swap:                                          ; preds = %sb.cmp.root
  store i32 %swap.val.b, i32* %root.ptr.b, align 4
  store i32 %root.val.b, i32* %swap.ptr.b, align 4
  br label %sb.head

build.after:                                      ; preds = %sb.cmp.root, %sb.head
  %i.dec = add i64 %i, -1
  br label %build.loop

extract.loop:                                     ; preds = %build.loop, %after.sift
  %end.in = phi i64 [ %end, %after.sift ], [ %n, %build.loop ]
  %end = add i64 %end.in, -1
  %keep.not = icmp eq i64 %end, 0
  br i1 %keep.not, label %ret, label %extract.body

extract.body:                                     ; preds = %extract.loop
  %a0.val = load i32, i32* %a, align 4
  %end.ptr = getelementptr inbounds i32, i32* %a, i64 %end
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %a, align 4
  store i32 %a0.val, i32* %end.ptr, align 4
  br label %se.head

se.head:                                          ; preds = %se.swap, %extract.body
  %root.e = phi i64 [ 0, %extract.body ], [ %swap.idx.e, %se.swap ]
  %root2x.e = shl i64 %root.e, 1
  %left.e = or i64 %root2x.e, 1
  %left.le.not = icmp ugt i64 %left.e, %end
  br i1 %left.le.not, label %after.sift, label %se.has.left

se.has.left:                                      ; preds = %se.head
  %right.e = add i64 %root2x.e, 2
  %right.le.not = icmp ugt i64 %right.e, %end
  br i1 %right.le.not, label %se.cmp.root, label %se.cmp.right

se.cmp.right:                                     ; preds = %se.has.left
  %left.ptr.e = getelementptr inbounds i32, i32* %a, i64 %left.e
  %left.val.e = load i32, i32* %left.ptr.e, align 4
  %right.ptr.e = getelementptr inbounds i32, i32* %a, i64 %right.e
  %right.val.e = load i32, i32* %right.ptr.e, align 4
  %right.gt.e = icmp sgt i32 %right.val.e, %left.val.e
  %spec.select1 = select i1 %right.gt.e, i64 %right.e, i64 %left.e
  br label %se.cmp.root

se.cmp.root:                                      ; preds = %se.cmp.right, %se.has.left
  %swap.idx.e = phi i64 [ %left.e, %se.has.left ], [ %spec.select1, %se.cmp.right ]
  %root.ptr.e = getelementptr inbounds i32, i32* %a, i64 %root.e
  %root.val.e = load i32, i32* %root.ptr.e, align 4
  %swap.ptr.e = getelementptr inbounds i32, i32* %a, i64 %swap.idx.e
  %swap.val.e = load i32, i32* %swap.ptr.e, align 4
  %need.swap.e = icmp slt i32 %root.val.e, %swap.val.e
  br i1 %need.swap.e, label %se.swap, label %after.sift

se.swap:                                          ; preds = %se.cmp.root
  store i32 %swap.val.e, i32* %root.ptr.e, align 4
  store i32 %root.val.e, i32* %swap.ptr.e, align 4
  br label %se.head

after.sift:                                       ; preds = %se.cmp.root, %se.head
  br label %extract.loop

ret:                                              ; preds = %extract.loop, %entry
  ret void
}

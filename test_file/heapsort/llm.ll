; ModuleID = 'heapsort_llm.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.orig = private unnamed_addr constant [9 x i8] c"\EC\9B\90\EB\B3\B8: \00", align 1
@.str.sorted = private unnamed_addr constant [13 x i8] c"\EC\A0\95\EB\A0\AC \ED\9B\84: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %i2 = alloca i64, align 8
  %fmt1 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.orig, i64 0, i64 0
  %fmt2 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.sorted, i64 0, i64 0
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %p8, align 4
  store i64 9, i64* %n, align 8
  %0 = call i32 (i8*, ...) @printf(i8* %fmt1)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.val, %n.val
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %1 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %2 = call i32 @putchar(i32 10)
  %n2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arr0, i64 %n2)
  %3 = call i32 (i8*, ...) @printf(i8* %fmt2)
  store i64 0, i64* %i2, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %i2.val = load i64, i64* %i2, align 8
  %n3 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %i2.val, %n3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %4 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %elem2)
  %inc2 = add i64 %i2.val, 1
  store i64 %inc2, i64* %i2, align 8
  br label %loop2.cond

loop2.end:                                        ; preds = %loop2.cond
  %5 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* %a, i64 %n) {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %i0 = lshr i64 %n, 1
  br label %build.loop

build.loop:                                       ; preds = %build.after, %build.init
  %i = phi i64 [ %i0, %build.init ], [ %i.dec, %build.after ]
  %cond = icmp ne i64 %i, 0
  br i1 %cond, label %sb.head, label %extract.init

sb.head:                                          ; preds = %sb.swap, %build.loop
  %root.b = phi i64 [ %i, %build.loop ], [ %swap.idx.b, %sb.swap ]
  %root2x = shl i64 %root.b, 1
  %left.b = add i64 %root2x, 1
  %left.ok = icmp ult i64 %left.b, %n
  br i1 %left.ok, label %sb.has.left, label %build.after

sb.has.left:                                      ; preds = %sb.head
  %right.b = add i64 %left.b, 1
  %right.in = icmp ult i64 %right.b, %n
  %left.ptr.b = getelementptr inbounds i32, i32* %a, i64 %left.b
  %left.val.b = load i32, i32* %left.ptr.b, align 4
  br i1 %right.in, label %sb.cmp.right, label %sb.pick.left

sb.cmp.right:                                     ; preds = %sb.has.left
  %right.ptr.b = getelementptr inbounds i32, i32* %a, i64 %right.b
  %right.val.b = load i32, i32* %right.ptr.b, align 4
  %right.gt = icmp sgt i32 %right.val.b, %left.val.b
  br i1 %right.gt, label %sb.pick.right, label %sb.pick.left

sb.pick.left:                                     ; preds = %sb.cmp.right, %sb.has.left
  %swap.idx.b.l = phi i64 [ %left.b, %sb.has.left ], [ %left.b, %sb.cmp.right ]
  br label %sb.cmp.root

sb.pick.right:                                    ; preds = %sb.cmp.right
  %swap.idx.b.r = phi i64 [ %right.b, %sb.cmp.right ]
  br label %sb.cmp.root

sb.cmp.root:                                      ; preds = %sb.pick.right, %sb.pick.left
  %swap.idx.b = phi i64 [ %swap.idx.b.l, %sb.pick.left ], [ %swap.idx.b.r, %sb.pick.right ]
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

extract.init:                                     ; preds = %build.loop
  %end0 = add i64 %n, -1
  br label %extract.loop

extract.loop:                                     ; preds = %after.sift, %extract.init
  %end = phi i64 [ %end0, %extract.init ], [ %end.dec, %after.sift ]
  %keep = icmp ne i64 %end, 0
  br i1 %keep, label %extract.body, label %ret

extract.body:                                     ; preds = %extract.loop
  %a0.ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0.val = load i32, i32* %a0.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %a, i64 %end
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %a0.ptr, align 4
  store i32 %a0.val, i32* %end.ptr, align 4
  br label %se.head

se.head:                                          ; preds = %se.swap, %extract.body
  %root.e = phi i64 [ 0, %extract.body ], [ %swap.idx.e, %se.swap ]
  %root2x.e = shl i64 %root.e, 1
  %left.e = add i64 %root2x.e, 1
  %left.le = icmp ule i64 %left.e, %end
  br i1 %left.le, label %se.has.left, label %after.sift

se.has.left:                                      ; preds = %se.head
  %right.e = add i64 %left.e, 1
  %right.le = icmp ule i64 %right.e, %end
  %left.ptr.e = getelementptr inbounds i32, i32* %a, i64 %left.e
  %left.val.e = load i32, i32* %left.ptr.e, align 4
  br i1 %right.le, label %se.cmp.right, label %se.pick.left

se.cmp.right:                                     ; preds = %se.has.left
  %right.ptr.e = getelementptr inbounds i32, i32* %a, i64 %right.e
  %right.val.e = load i32, i32* %right.ptr.e, align 4
  %right.gt.e = icmp sgt i32 %right.val.e, %left.val.e
  br i1 %right.gt.e, label %se.pick.right, label %se.pick.left

se.pick.left:                                     ; preds = %se.cmp.right, %se.has.left
  %swap.idx.e.l = phi i64 [ %left.e, %se.has.left ], [ %left.e, %se.cmp.right ]
  br label %se.cmp.root

se.pick.right:                                    ; preds = %se.cmp.right
  %swap.idx.e.r = phi i64 [ %right.e, %se.cmp.right ]
  br label %se.cmp.root

se.cmp.root:                                      ; preds = %se.pick.right, %se.pick.left
  %swap.idx.e = phi i64 [ %swap.idx.e.l, %se.pick.left ], [ %swap.idx.e.r, %se.pick.right ]
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
  %end.dec = add i64 %end, -1
  br label %extract.loop

ret:                                              ; preds = %extract.loop, %entry
  ret void
}

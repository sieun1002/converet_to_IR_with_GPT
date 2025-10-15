; Target: Linux x86-64 System V
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16

  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 10, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 9, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 7, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 6, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 5, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 4, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 3, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 2, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 1, i32* %p9, align 4

  br label %outer.header

outer.header:
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.latch ]
  %i.cmp = icmp slt i32 %i, 10
  br i1 %i.cmp, label %outer.body, label %print.init

outer.body:
  %i.sext = sext i32 %i to i64
  %key.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.sext
  %key = load i32, i32* %key.ptr, align 4
  %j.init = add nsw i32 %i, -1
  br label %inner.header

inner.header:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.shift ]
  %j.ge0 = icmp sge i32 %j, 0
  br i1 %j.ge0, label %inner.cmp, label %inner.insert

inner.cmp:
  %j.sext = sext i32 %j to i64
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.sext
  %elt = load i32, i32* %elt.ptr, align 4
  %elt.gt.key = icmp sgt i32 %elt, %key
  br i1 %elt.gt.key, label %inner.shift, label %inner.insert

inner.shift:
  %j.plus1 = add nsw i32 %j, 1
  %j.plus1.sext = sext i32 %j.plus1 to i64
  %dest.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.plus1.sext
  store i32 %elt, i32* %dest.ptr, align 4
  %j.next = add nsw i32 %j, -1
  br label %inner.header

inner.insert:
  %ins.pos = add nsw i32 %j, 1
  %ins.pos.sext = sext i32 %ins.pos to i64
  %ins.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %ins.pos.sext
  store i32 %key, i32* %ins.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.header

print.init:
  br label %print.loop

print.loop:
  %p = phi i32 [ 0, %print.init ], [ %p.next, %print.body ]
  %p.cmp = icmp slt i32 %p, 10
  br i1 %p.cmp, label %print.body, label %done

print.body:
  %p.sext = sext i32 %p to i64
  %pptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %p.sext
  %val = load i32, i32* %pptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %p.next = add nuw nsw i32 %p, 1
  br label %print.loop

done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %nl.ptr)
  ret i32 0
}
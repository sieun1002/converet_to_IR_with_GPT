; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 6, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 5, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  br label %outer.header

outer.header:                                      ; preds = %entry, %outer.header.cont
  %upper = phi i64 [ 10, %entry ], [ %last, %outer.header.cont ]
  br label %inner.header

inner.header:                                      ; preds = %inner.body, %outer.header
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.body ]
  %last.ph = phi i64 [ 0, %outer.header ], [ %last.cand, %inner.body ]
  %cmp.i = icmp slt i64 %i, %upper
  br i1 %cmp.i, label %inner.body, label %outer.tail

inner.body:                                        ; preds = %inner.header
  %im1 = add nsw i64 %i, -1
  %pl = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %im1
  %pr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %vl = load i32, i32* %pl, align 4
  %vr = load i32, i32* %pr, align 4
  %gt = icmp sgt i32 %vl, %vr
  %newL = select i1 %gt, i32 %vr, i32 %vl
  %newR = select i1 %gt, i32 %vl, i32 %vr
  store i32 %newL, i32* %pl, align 4
  store i32 %newR, i32* %pr, align 4
  %last.cand = select i1 %gt, i64 %i, i64 %last.ph
  %i.next = add nuw nsw i64 %i, 1
  br label %inner.header

outer.tail:                                        ; preds = %inner.header
  %last = phi i64 [ %last.ph, %inner.header ]
  %is0 = icmp eq i64 %last, 0
  %is1 = icmp eq i64 %last, 1
  %stop = or i1 %is0, %is1
  br i1 %stop, label %print.loop, label %outer.header.cont

outer.header.cont:                                 ; preds = %outer.tail
  br label %outer.header

print.loop:                                        ; preds = %outer.tail, %print.body
  %idx = phi i64 [ 0, %outer.tail ], [ %idx.next, %print.body ]
  %eltp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %elt = load i32, i32* %eltp, align 4
  %fmtp = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtp, i32 %elt)
  br label %print.body

print.body:                                        ; preds = %print.loop
  %idx.next = add nuw nsw i64 %idx, 1
  %done = icmp eq i64 %idx.next, 10
  br i1 %done, label %print.end, label %print.loop

print.end:                                         ; preds = %print.body
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %nlp)
  ret i32 0
}
; ModuleID = 'main'
source_filename = "main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare dso_local i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 16
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 7, i32* %p2, align 8
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 8, i32* %p4, align 16
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 6, i32* %p6, align 8
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 5, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %p9, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %outer.end, %entry
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.end ]
  %outer.cmp = icmp slt i32 %i, 10
  br i1 %outer.cmp, label %outer.body, label %print.cond

outer.body:                                       ; preds = %outer.cond
  %i.sext = sext i32 %i to i64
  %ai.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.sext
  %key = load i32, i32* %ai.ptr, align 4
  %j.init = add nsw i32 %i, -1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.shift, %outer.body
  %j = phi i32 [ %j.init, %outer.body ], [ %j.dec, %inner.shift ]
  %j.nonneg = icmp sge i32 %j, 0
  br i1 %j.nonneg, label %inner.cmp, label %insert

inner.cmp:                                        ; preds = %inner.cond
  %j.sext = sext i32 %j to i64
  %aj.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %j.sext
  %aj = load i32, i32* %aj.ptr, align 4
  %gt = icmp sgt i32 %aj, %key
  br i1 %gt, label %inner.shift, label %insert

inner.shift:                                      ; preds = %inner.cmp
  %jp1 = add nsw i32 %j, 1
  %jp1.sext = sext i32 %jp1 to i64
  %ajp1.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %jp1.sext
  store i32 %aj, i32* %ajp1.ptr, align 4
  %j.dec = add nsw i32 %j, -1
  br label %inner.cond

insert:                                           ; preds = %inner.cmp, %inner.cond
  %j.sel = phi i32 [ %j, %inner.cmp ], [ %j, %inner.cond ]
  %dst.index = add nsw i32 %j.sel, 1
  %dst.index.sext = sext i32 %dst.index to i64
  %dst.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %dst.index.sext
  store i32 %key, i32* %dst.ptr, align 4
  br label %outer.end

outer.end:                                        ; preds = %insert
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

print.cond:                                       ; preds = %outer.cond
  %k = phi i32 [ 0, %outer.cond ]
  %print.cmp = icmp slt i32 %k, 10
  br i1 %print.cmp, label %print.body, label %after.print

print.body:                                       ; preds = %print.cond
  %k.sext = sext i32 %k to i64
  %ak.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %k.sext
  %val = load i32, i32* %ak.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* nonnull %fmt, i32 %val)
  %k.next = add nuw nsw i32 %k, 1
  br label %print.cond

after.print:                                      ; preds = %print.cond
  %fmt.nl = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* nonnull %fmt.nl)
  ret i32 0
}
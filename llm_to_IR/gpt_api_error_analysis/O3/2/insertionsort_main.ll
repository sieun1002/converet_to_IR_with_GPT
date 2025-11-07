; ModuleID = 'insertion_sort_print'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  store [10 x i32] [i32 9, i32 1, i32 8, i32 4, i32 7, i32 2, i32 6, i32 3, i32 5, i32 0], [10 x i32]* %arr, align 16
  br label %outer

outer:                                            ; preds = %outer.end, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.end ]
  %cmp.i = icmp slt i32 %i, 9
  br i1 %cmp.i, label %outer.body, label %print

outer.body:                                       ; preds = %outer
  %ip1 = add nsw i32 %i, 1
  %idx.ip1 = sext i32 %ip1 to i64
  %gep.ip1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx.ip1
  %key = load i32, i32* %gep.ip1, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i32 [ %i, %outer.body ], [ %j.next, %inner.body ]
  %ge0 = icmp sge i32 %j, 0
  br i1 %ge0, label %check, label %insert

check:                                            ; preds = %inner.cond
  %j.idx64 = sext i32 %j to i64
  %gep.j = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.idx64
  %val.j = load i32, i32* %gep.j, align 4
  %gt = icmp sgt i32 %val.j, %key
  br i1 %gt, label %inner.body, label %insert

inner.body:                                       ; preds = %check
  %j.plus1 = add nsw i32 %j, 1
  %j.plus1.idx64 = sext i32 %j.plus1 to i64
  %gep.j1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j.plus1.idx64
  store i32 %val.j, i32* %gep.j1, align 4
  %j.next = add nsw i32 %j, -1
  br label %inner.cond

insert:                                           ; preds = %check, %inner.cond
  %j.cur = phi i32 [ %j, %inner.cond ], [ %j, %check ]
  %ins.idx = add nsw i32 %j.cur, 1
  %ins.idx64 = sext i32 %ins.idx to i64
  %gep.ins = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %ins.idx64
  store i32 %key, i32* %gep.ins, align 4
  br label %outer.end

outer.end:                                        ; preds = %insert
  %i.next = add nsw i32 %i, 1
  br label %outer

print:                                            ; preds = %outer
  br label %print.loop

print.loop:                                       ; preds = %print.loop.body, %print
  %k = phi i32 [ 0, %print ], [ %k.next, %print.loop.body ]
  %cond.k = icmp slt i32 %k, 10
  br i1 %cond.k, label %print.loop.body, label %print.end

print.loop.body:                                  ; preds = %print.loop
  %k.idx64 = sext i32 %k to i64
  %gep.k = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k.idx64
  %val.k = load i32, i32* %gep.k, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val.k)
  %k.next = add nsw i32 %k, 1
  br label %print.loop

print.end:                                        ; preds = %print.loop
  %call.nl = call i32 (i8*, ...) @printf(i8* %nlptr)
  ret i32 0
}
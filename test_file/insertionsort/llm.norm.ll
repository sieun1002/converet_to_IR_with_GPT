; ModuleID = 'cases/insertionsort/llm.ll'
source_filename = "cases/insertionsort/llm.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00"
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00"

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  br label %outer

outer:                                            ; preds = %inner.exit, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %inner.exit ]
  %done = icmp sgt i64 %i, 9
  br i1 %done, label %print.loop, label %outer.body

outer.body:                                       ; preds = %outer
  %iptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %key = load i32, i32* %iptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %jm1, %inner.shift ]
  %j.gt0 = icmp sgt i64 %j, 0
  br i1 %j.gt0, label %inner.cmp, label %inner.exit

inner.cmp:                                        ; preds = %inner.cond
  %jm1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %jm1
  %prev = load i32, i32* %prev.ptr, align 4
  %ge.not = icmp slt i32 %key, %prev
  br i1 %ge.not, label %inner.shift, label %inner.exit

inner.shift:                                      ; preds = %inner.cmp
  %j.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j
  store i32 %prev, i32* %j.ptr, align 4
  br label %inner.cond

inner.exit:                                       ; preds = %inner.cmp, %inner.cond
  %ins.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add i64 %i, 1
  br label %outer

print.loop:                                       ; preds = %outer, %print.loop.body
  %k = phi i64 [ %k.next, %print.loop.body ], [ 0, %outer ]
  %end = icmp eq i64 %k, 10
  br i1 %end, label %print.done, label %print.loop.body

print.loop.body:                                  ; preds = %print.loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %k.next = add i64 %k, 1
  br label %print.loop

print.done:                                       ; preds = %print.loop
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
  ret i32 0
}

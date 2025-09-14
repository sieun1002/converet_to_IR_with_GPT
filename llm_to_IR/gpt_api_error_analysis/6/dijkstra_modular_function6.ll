; target: SysV x86-64, LLVM 14
target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  %i.addr = alloca i32, align 4
  store i32 0, i32* %i.addr, align 4
  br label %loop

loop:
  %i.load = load i32, i32* %i.addr, align 4
  %cmp = icmp slt i32 %i.load, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i.load to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:
  %fmtptr1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %i.load)
  br label %inc

print_val:
  %fmtptr2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %i.load, i32 %val)
  br label %inc

inc:
  %i.next = add nsw i32 %i.load, 1
  store i32 %i.next, i32* %i.addr, align 4
  br label %loop

exit:
  ret void
}
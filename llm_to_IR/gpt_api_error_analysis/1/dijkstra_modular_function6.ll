; Target: System V x86_64 Linux
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %after_print ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idxext = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %dist, i64 %idxext
  %val = load i32, i32* %eltptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:
  %fmt_inf_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call_inf = call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i32 %i)
  br label %after_print

print_val:
  %fmt_val_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call_val = call i32 (i8*, ...) @printf(i8* %fmt_val_ptr, i32 %i, i32 %val)
  br label %after_print

after_print:
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}
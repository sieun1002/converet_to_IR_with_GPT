; ModuleID = 'print_distances.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* noundef %dist, i32 noundef %n) local_unnamed_addr {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %lt = icmp slt i32 %i, %n
  br i1 %lt, label %body, label %exit

body:
  %idxprom = sext i32 %i to i64
  %elem_ptr = getelementptr inbounds i32, i32* %dist, i64 %idxprom
  %val = load i32, i32* %elem_ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* noundef %fmt1, i32 noundef %i)
  br label %inc

print_val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* noundef %fmt2, i32 noundef %i, i32 noundef %val)
  br label %inc

inc:
  %i.next = add nsw i32 %i, 1
  br label %cond

exit:
  ret void
}
; ModuleID = 'print_distances.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* nocapture readonly %dist, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idxprom = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idxprom
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i)
  br label %latch

print_val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i, i32 %val)
  br label %latch

latch:
  %i.next = add nsw i32 %i, 1
  br label %loop

end:
  ret void
}
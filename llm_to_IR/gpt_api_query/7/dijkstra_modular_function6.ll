; ModuleID = 'print_distances'
source_filename = "print_distances"
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %elem, 2147483647
  br i1 %isinf, label %if.inf, label %if.val

if.inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i)
  br label %cont

if.val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i, i32 %elem)
  br label %cont

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

end:
  ret void
}
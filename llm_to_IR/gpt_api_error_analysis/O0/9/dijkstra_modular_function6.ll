; ModuleID = 'print_distances.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.dd  = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %afterprint ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %is.inf = icmp eq i32 %val, 2147483647
  br i1 %is.inf, label %then, label %else

then:
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i)
  br label %afterprint

else:
  %fmt.dd.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.dd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt.dd.ptr, i32 %i, i32 %val)
  br label %afterprint

afterprint:
  %inc = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}
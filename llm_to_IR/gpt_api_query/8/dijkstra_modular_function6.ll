; ModuleID = 'print_distances'
source_filename = "print_distances"

@.str = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* nocapture readonly %dist, i32 %n) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cond = icmp slt i32 %i.val, %n
  br i1 %cond, label %body, label %end

body:
  %idxprom = sext i32 %i.val to i64
  %elem = getelementptr inbounds i32, i32* %dist, i64 %idxprom
  %val = load i32, i32* %elem, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %printInf, label %printVal

printInf:
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i32 %i.val)
  br label %inc

printVal:
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i32 %i.val, i32 %val)
  br label %inc

inc:
  %next = add nsw i32 %i.val, 1
  store i32 %next, i32* %i, align 4
  br label %loop

end:
  ret void
}
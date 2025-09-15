; ModuleID = 'print_distances.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* nocapture readonly %dist, i32 %n) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, %n
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %iv2 = load i32, i32* %i, align 4
  %idx = sext i32 %iv2 to i64
  %elem_ptr = getelementptr inbounds i32, i32* %dist, i64 %idx
  %val = load i32, i32* %elem_ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %call_inf, label %call_val

call_inf:                                         ; preds = %body
  %iv3 = load i32, i32* %i, align 4
  %fmt_inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_inf, i32 %iv3)
  br label %inc

call_val:                                         ; preds = %body
  %iv4 = load i32, i32* %i, align 4
  %fmt_val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_val, i32 %iv4, i32 %val)
  br label %inc

inc:                                              ; preds = %call_val, %call_inf
  %iv5 = load i32, i32* %i, align 4
  %next = add nsw i32 %iv5, 1
  store i32 %next, i32* %i, align 4
  br label %loop

end:                                              ; preds = %loop
  ret void
}
; ModuleID = 'print_distances.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8* noundef, ...)

define void @print_distances(i32* noundef %dist, i32 noundef %n) local_unnamed_addr {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, %n
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %idx.ext = sext i32 %iv to i64
  %elt.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %elt.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %fmt_inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %iv.inf = load i32, i32* %i, align 4
  %call_inf = call i32 (i8*, ...) @printf(i8* noundef %fmt_inf, i32 noundef %iv.inf)
  br label %inc

print_val:                                        ; preds = %body
  %fmt_val = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  %iv.val = load i32, i32* %i, align 4
  %call_val = call i32 (i8*, ...) @printf(i8* noundef %fmt_val, i32 noundef %iv.val, i32 noundef %val)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %iv2 = load i32, i32* %i, align 4
  %incv = add nsw i32 %iv2, 1
  store i32 %incv, i32* %i, align 4
  br label %loop

end:                                              ; preds = %loop
  ret void
}
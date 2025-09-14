; ModuleID = 'print_distances'
source_filename = "print_distances.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [17 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %after_print, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %after_print ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idxprom = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %dist, i64 %idxprom
  %val = load i32, i32* %eltptr, align 4
  %is_inf = icmp eq i32 %val, 2147483647
  br i1 %is_inf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %fmt_inf_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i32 %i)
  br label %after_print

print_val:                                        ; preds = %body
  %fmt_val_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_val_ptr, i32 %i, i32 %val)
  br label %after_print

after_print:                                      ; preds = %print_val, %print_inf
  %inc = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}
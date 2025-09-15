; ModuleID = 'print_distances'
source_filename = "print_distances.c"
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.dd  = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* nocapture readonly %dist, i32 %n) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %n
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %elem, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.val)
  br label %inc

print_val:                                        ; preds = %body
  %fmt.dd.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.dd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt.dd.ptr, i32 %i.val, i32 %elem)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

end:                                              ; preds = %loop
  ret void
}
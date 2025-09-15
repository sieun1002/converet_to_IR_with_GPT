; ModuleID = 'recovered.ll'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @bubble_sort(i32* noundef, i64 noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* noundef %arr0, i64 noundef 10)
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull %fmtptr, i32 %val)
  %inc = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}
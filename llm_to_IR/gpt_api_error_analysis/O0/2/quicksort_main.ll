; ModuleID = 'qs_main.ll'
source_filename = "qs_main.c"
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %idx9, align 4
  %len = add i64 10, 0
  %cmp.len = icmp ule i64 %len, 1
  br i1 %cmp.len, label %skip.sort, label %do.sort

do.sort:
  %high = add i64 %len, -1
  call void @quick_sort(i32* noundef %arr.base, i64 noundef 0, i64 noundef %high)
  br label %skip.sort

skip.sort:
  br label %loop

loop:
  %i = phi i64 [ 0, %skip.sort ], [ %inc, %loop.body.end ]
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %loop.body, label %after.loop

loop.body:
  %eltptr = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %val = load i32, i32* %eltptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %val)
  br label %loop.body.end

loop.body.end:
  %inc = add i64 %i, 1
  br label %loop

after.loop:
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}
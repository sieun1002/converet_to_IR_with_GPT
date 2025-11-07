; ModuleID = 'recovered_main'
target triple = "x86_64-unknown-linux-gnu"

declare void @quick_sort(i32* nocapture, i32, i32)
declare i32 @__printf_chk(i32, i8*, ...)

@.fmt_d_space = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.fmt_nl      = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 7, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 3, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 8, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 6, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 0, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 5, i32* %arr9, align 4
  %baseptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %baseptr, i32 0, i32 9)
  br label %for.header

for.header:                                           ; preds = %for.body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                             ; preds = %for.header
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d_space, i64 0, i64 0
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %elem)
  %inc = add nuw nsw i64 %i, 1
  br label %for.header

for.end:                                              ; preds = %for.header
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.fmt_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0
}
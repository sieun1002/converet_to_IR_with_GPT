; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrptr, align 4
  %idx1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arrptr, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arrptr, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arrptr, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arrptr, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arrptr, i64 9
  store i32 0, i32* %idx9, align 4
  call void @bubble_sort(i32* %arrptr, i64 10)
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrptr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %inc = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}
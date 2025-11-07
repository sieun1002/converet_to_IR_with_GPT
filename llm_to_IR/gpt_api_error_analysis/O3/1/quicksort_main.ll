; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @__printf_chk(i32 noundef, i8* noundef, ...)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0.ptr, align 16
  %arr1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 7, i32* %arr2.ptr, align 8
  %arr3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 5, i32* %arr4.ptr, align 16
  %arr5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 6, i32* %arr6.ptr, align 8
  %arr7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 0, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8.ptr, align 16
  %arr9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 8, i32* %arr9.ptr, align 4
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* noundef %arr.base, i32 noundef 0, i32 noundef 9)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 noundef 2, i8* noundef %fmt.ptr, i32 noundef %elem)
  %i.next = add i64 %i, 1
  br label %loop

done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 noundef 2, i8* noundef %nl.ptr)
  ret i32 0
}
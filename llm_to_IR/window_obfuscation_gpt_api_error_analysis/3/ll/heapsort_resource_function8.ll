; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@Format = internal constant [9 x i8] c"Before: \00", align 1
@aD = internal constant [4 x i8] c"%d \00", align 1
@byte_14000400D = internal constant [8 x i8] c"After: \00", align 1

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140001450(i32*, i64)
declare i32 @putchar(i32)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  call void @sub_1400018F0()
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4
  %fmt_before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %fmt_d_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %fmt_after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call_print_before = call i32 (i8*, ...) @sub_140002960(i8* %fmt_before_ptr)
  br label %loop1.cond

loop1.cond:
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %eltptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %eltptr1, align 4
  %call_print_val1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d_ptr, i32 %val1)
  %i1.next = add nuw nsw i64 %i1, 1
  br label %loop1.cond

loop1.end:
  %call_nl1 = call i32 @putchar(i32 10)
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @sub_140001450(i32* %arrdecay, i64 9)
  %call_print_after = call i32 (i8*, ...) @sub_140002960(i8* %fmt_after_ptr)
  br label %loop2.cond

loop2.cond:
  %i2 = phi i64 [ 0, %loop1.end ], [ %i2.next, %loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %eltptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %eltptr2, align 4
  %call_print_val2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_d_ptr, i32 %val2)
  %i2.next = add nuw nsw i64 %i2, 1
  br label %loop2.cond

loop2.end:
  %call_nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define dso_local i32 @main() local_unnamed_addr sspstrong {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  ; arr initialization: {9,1,5,3,7,2,8,6,4,0}
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9,  i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1,  i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5,  i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3,  i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7,  i32* %arr4, align 16
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2,  i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8,  i32* %arr6, align 8
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6,  i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4,  i32* %arr8, align 16
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0,  i32* %arr9, align 4

  store i64 10, i64* %n, align 8

  ; call insertion_sort(&arr[0], n)
  %n.val = load i64, i64* %n, align 8
  call void @insertion_sort(i32* noundef %arr0, i64 noundef %n.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.cur, %n.cur
  br i1 %cmp, label %body, label %done

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %elem)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  call i32 @putchar(i32 noundef 10)
  ret i32 0
}
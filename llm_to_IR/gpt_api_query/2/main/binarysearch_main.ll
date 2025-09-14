; ModuleID = 'recovered.ll'
target triple = "x86_64-pc-linux-gnu"

@.fmt_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.fmt_not   = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32* %arr, i64 %n, i32 %key)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8

  ; initialize arr = [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4

  ; initialize keys = {2, 5, -5}
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, 3
  br i1 %cmp, label %body, label %done

body:
  %keyptr = getelementptr inbounds i32, i32* %keys0, i64 %iv
  %key = load i32, i32* %keyptr, align 4
  %res = call i64 @binary_search(i32* %arr0, i64 9, i32 %key)
  %notfound = icmp slt i64 %res, 0
  br i1 %notfound, label %print_not, label %print_found

print_found:
  %fmt_found_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_found, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_found_ptr, i32 %key, i64 %res)
  br label %inc

print_not:
  %fmt_not_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_not, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_not_ptr, i32 %key)
  br label %inc

inc:
  %iv.next = add i64 %iv, 1
  store i64 %iv.next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}
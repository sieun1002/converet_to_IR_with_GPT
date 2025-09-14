; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x144B
; Intent: Print an array, heap-sort it, then print it again (confidence=0.86). Evidence: two print loops around a call to heap_sort; strings "%d " and banners.
; Preconditions: None
; Postconditions: Returns 0; array sorted in-place via heap_sort

@__stack_chk_guard = external global i64
@format = private unnamed_addr constant [17 x i8] c"Original array:\0A\00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_2011 = private unnamed_addr constant [15 x i8] c"Sorted array:\0A\00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)
declare dso_local void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %len = alloca i64, align 8
  %canary.save = alloca i64, align 8

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.save, align 8

  ; initialize array: 7,3,9,1,4,8,2,6,5
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

  store i64 9, i64* %len, align 8

  ; print header
  %fmt0 = getelementptr inbounds [17 x i8], [17 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  ; first print loop
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %iv = load i64, i64* %i, align 8
  %n1 = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %iv, %n1
  br i1 %cmp1, label %body1, label %after1

body1:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %iv
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmtD1 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtD1, i32 %elem1)
  %inc1 = add i64 %iv, 1
  store i64 %inc1, i64* %i, align 8
  br label %loop1

after1:
  call i32 @putchar(i32 10)

  ; sort: heap_sort(&arr[0], len)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.base, i64 %n2)

  ; print header for sorted
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)

  ; second print loop
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %jv = load i64, i64* %j, align 8
  %n3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %jv, %n3
  br i1 %cmp2, label %body2, label %after2

body2:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %jv
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmtD2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtD2, i32 %elem2)
  %inc2 = add i64 %jv, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:
  call i32 @putchar(i32 10)

  ; stack protector epilogue
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.save, align 8
  %ok = icmp eq i64 %guard.saved, %guard.end
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}
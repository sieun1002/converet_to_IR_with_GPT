; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir"

@__stack_chk_guard = external global i64
@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_after  = private unnamed_addr constant [8 x i8] c"After: \00",  align 1
@.str_d      = private unnamed_addr constant [4 x i8] c"%d \00",       align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  %guard.init = load i64, i64* @__stack_chk_guard
  store i64 %guard.init, i64* %canary, align 8

  ; Initialize array: {7,3,9,1,4,8,2,6,5}
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

  ; printf(format)
  %before.p = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %before.p)

  ; for (i = 0; i < 9; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %body1, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp1 = icmp ult i64 %i.val, 9
  br i1 %cmp1, label %body1, label %after1

body1:                                            ; preds = %loop1
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.p = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.p, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], 9)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  ; printf(byte_2011)
  %after.p = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %after.p)

  ; for (j = 0; j < 9; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %body2, %after1
  %j.val = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %j.val, 9
  br i1 %cmp2, label %body2, label %after2

body2:                                            ; preds = %loop2
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt.p2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.p2, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  call i32 @putchar(i32 10)

  ; stack protector check
  %canary.val = load i64, i64* %canary, align 8
  %guard.fin = load i64, i64* @__stack_chk_guard
  %mismatch = icmp ne i64 %canary.val, %guard.fin
  br i1 %mismatch, label %fail, label %ret

fail:                                             ; preds = %after2
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after2
  ret i32 0
}
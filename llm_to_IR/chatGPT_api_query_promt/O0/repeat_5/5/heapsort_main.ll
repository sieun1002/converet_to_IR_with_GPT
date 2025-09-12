; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
; These two are strings in the binary's data section (unknown contents here).
@format = external global i8
@byte_2011 = external global i8

@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %retval = alloca i32, align 4
  %saved_canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; stack protector prologue
  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %saved_canary, align 8

  ; initialize local array: {7,3,9,1,4,8,2,6,5}
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

  ; printf(format)
  call i32 (i8*, ...) @printf(i8* @format)

  ; for (i = 0; i < len; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %n
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtd = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                       ; preds = %loop1.cond
  call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], len)
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arrdecay, i64 %n2)

  ; printf(byte_2011)
  call i32 (i8*, ...) @printf(i8* @byte_2011)

  ; for (j = 0; j < len; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %loop1.end
  %j.val = load i64, i64* %j, align 8
  %n3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %n3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                      ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmtd2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtd2, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                       ; preds = %loop2.cond
  call i32 @putchar(i32 10)

  store i32 0, i32* %retval, align 4

  ; stack protector epilogue
  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %saved_canary, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %loop2.end
  call void @__stack_chk_fail()
  br label %ret

ret:                                              ; preds = %stackfail, %loop2.end
  %rv = load i32, i32* %retval, align 4
  ret i32 %rv
}
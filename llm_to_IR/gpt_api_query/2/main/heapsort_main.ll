; ModuleID = 'main.ll'
source_filename = "main.ll"
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@format = external global i8
@byte_2011 = external global i8
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; allocas
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %canary.slot = alloca i64, align 8

  ; stack canary prologue
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  ; n = 9
  store i64 9, i64* %n, align 8

  ; initialize arr = {7,3,9,1,4,8,2,6,5}
  %arr0 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4

  ; printf(format)
  call i32 (i8*, ...) @printf(i8* @format)

  ; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
loop1.cond:
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %lt1 = icmp ult i64 %i.val, %n.val
  br i1 %lt1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.d = getelementptr [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.d, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], n)
  %arr.base = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.sort = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arr.base, i64 %n.sort)

  ; printf(byte_2011)
  call i32 (i8*, ...) @printf(i8* @byte_2011)

  ; for (j = 0; j < n; ++j) printf("%d ", arr[j]);
  store i64 0, i64* %j, align 8
loop2.cond:
  %j.val = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %lt2 = icmp ult i64 %j.val, %n.val2
  br i1 %lt2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt.d2 = getelementptr [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.d2, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; stack canary epilogue
  %guard.end = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %guard.saved, %guard.end
  br i1 %ok, label %ret.ok, label %stack.fail

stack.fail:
  call void @__stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}
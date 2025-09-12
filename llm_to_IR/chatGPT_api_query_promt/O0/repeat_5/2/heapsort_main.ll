; ModuleID = 'main.ll'
source_filename = "main.ll"

@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@format = external dso_local global i8
@byte_2011 = external dso_local global i8
@__stack_chk_guard = external thread_local local_unnamed_addr global i64

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)
declare dso_local void @__stack_chk_fail()

define dso_local i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  ; stack canary setup
  %canary.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary.init, i64* %canary.slot, align 8

  ; initialize array: [7, 3, 9, 1, 4, 8, 2, 6, 5]
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4

  store i64 9, i64* %n, align 8

  ; printf(format)
  call i32 (i8*, ...) @printf(i8* @format)

  ; first loop: print elements
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %body1, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cond1 = icmp ult i64 %i.val, %n.val
  br i1 %cond1, label %body1, label %after1

body1:                                            ; preds = %loop1
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.d = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.d, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  call i32 @putchar(i32 10)

  ; heap_sort(&arr[0], n)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val2 = load i64, i64* %n, align 8
  call void @heap_sort(i32* %arr.ptr, i64 %n.val2)

  ; printf(byte_2011)
  call i32 (i8*, ...) @printf(i8* @byte_2011)

  ; second loop: print elements
  store i64 0, i64* %i, align 8
  br label %loop2

loop2:                                            ; preds = %body2, %after1
  %i2.val = load i64, i64* %i, align 8
  %n2.val = load i64, i64* %n, align 8
  %cond2 = icmp ult i64 %i2.val, %n2.val
  br i1 %cond2, label %body2, label %after2

body2:                                            ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt.d2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.d2, i32 %elem2)
  %inc2 = add i64 %i2.val, 1
  store i64 %inc2, i64* %i, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  call i32 @putchar(i32 10)

  ; stack canary check
  %canary.end = load i64, i64* %canary.slot, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %canary.end, %guard.cur
  br i1 %canary.ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after2
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after2
  ret i32 0
}
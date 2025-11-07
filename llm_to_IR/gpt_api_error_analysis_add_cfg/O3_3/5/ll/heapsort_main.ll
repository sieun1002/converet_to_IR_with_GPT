; ModuleID = 'recovered_main'
source_filename = "recovered_main.c"
target triple = "x86_64-unknown-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
loc_144B:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %canary = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8
  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8.ptr, align 4
  store i64 9, i64* %len, align 8
  store i64 0, i64* %idx1, align 8
  br label %loc_14DA

loc_14B7:
  %i1.load = load i64, i64* %idx1, align 8
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1.load
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call.printf.1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i1.next = add i64 %i1.load, 1
  store i64 %i1.next, i64* %idx1, align 8
  br label %loc_14DA

loc_14DA:
  %i1.cmp.load = load i64, i64* %idx1, align 8
  %len.cmp.load = load i64, i64* %len, align 8
  %cond.jb = icmp ult i64 %i1.cmp.load, %len.cmp.load
  br i1 %cond.jb, label %loc_14B7, label %bb_14E4

bb_14E4:
  %putchar.nl.1 = call i32 @putchar(i32 10)
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.hs.load = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.decay, i64 %len.hs.load)
  store i64 0, i64* %idx2, align 8
  br label %loc_152E

loc_150B:
  %i2.load = load i64, i64* %idx2, align 8
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.load
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call.printf.2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %elem2)
  %i2.next = add i64 %i2.load, 1
  store i64 %i2.next, i64* %idx2, align 8
  br label %loc_152E

loc_152E:
  %i2.cmp.load = load i64, i64* %idx2, align 8
  %len2.cmp.load = load i64, i64* %len, align 8
  %cond2.jb = icmp ult i64 %i2.cmp.load, %len2.cmp.load
  br i1 %cond2.jb, label %loc_150B, label %bb_1538

bb_1538:
  %putchar.nl.2 = call i32 @putchar(i32 10)
  %saved.canary = load i64, i64* %canary, align 8
  %cur.canary = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %saved.canary, %cur.canary
  br i1 %canary.ok, label %locret_155B, label %bb_1556

bb_1556:
  call void @__stack_chk_fail()
  br label %locret_155B

locret_155B:
  ret i32 0
}
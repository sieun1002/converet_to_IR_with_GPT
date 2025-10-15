; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare void @heap_sort(i32*, i64)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %idx = alloca i64, align 8
  %count = alloca i64, align 8
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
  store i64 9, i64* %count, align 8
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %cnt.ld = load i64, i64* %count, align 8
  call void @heap_sort(i32* %arrdecay, i64 %cnt.ld)
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.body:                                        ; preds = %loop.cond
  %i0 = load i64, i64* %idx, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i0
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i1 = load i64, i64* %idx, align 8
  %iinc = add i64 %i1, 1
  store i64 %iinc, i64* %idx, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i2 = load i64, i64* %idx, align 8
  %n = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i2, %n
  br i1 %cmp, label %loop.body, label %ret

ret:                                              ; preds = %loop.cond
  ret i32 0
}
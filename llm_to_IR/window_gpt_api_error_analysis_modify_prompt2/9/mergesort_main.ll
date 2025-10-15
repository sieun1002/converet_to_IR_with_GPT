; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32*, i64)
declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %idx1ptr = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %idx1ptr, align 4
  %idx2ptr = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %idx2ptr, align 4
  %idx3ptr = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %idx3ptr, align 4
  %idx4ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %idx4ptr, align 4
  %idx5ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %idx5ptr, align 4
  %idx6ptr = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %idx6ptr, align 4
  %idx7ptr = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7ptr, align 4
  %idx8ptr = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8ptr, align 4
  %idx9ptr = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %idx9ptr, align 4
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  call void @merge_sort(i32* %arr.base, i64 %lenv)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %next = add i64 %i.cur, 1
  store i64 %next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}
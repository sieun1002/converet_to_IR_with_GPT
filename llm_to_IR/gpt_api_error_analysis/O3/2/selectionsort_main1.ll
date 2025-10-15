; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 4, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 2, i32* %p2, align 8
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 8, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 13, i32* %p4, align 16
  call void @selection_sort(i32* %arr.base, i32 5)
  %hdr.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %next, %loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.elem = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %next = add nuw nsw i64 %i, 1
  %cond = icmp ult i64 %next, 5
  br i1 %cond, label %loop, label %exit

exit:
  ret i32 0
}
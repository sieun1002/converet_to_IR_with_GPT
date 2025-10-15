; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@FormatStr = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@NotFoundStr = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local i32 @linear_search(i32* %arr, i32 %target, i32 %length) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cmp0 = icmp slt i32 %i.val, %length
  br i1 %cmp0, label %body, label %exit

body:
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %match = icmp eq i32 %elem, %target
  br i1 %match, label %found, label %inc

found:
  ret i32 %i.val

inc:
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

exit:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %arr.ptr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.ptr0, align 4
  %arr.ptr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.ptr2, align 4
  %arr.ptr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.ptr4, align 4
  %arr.asptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %res = call i32 @linear_search(i32* %arr.asptr, i32 5, i32 4)
  %cmp = icmp eq i32 %res, -1
  br i1 %cmp, label %notfound, label %found2

found2:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @FormatStr, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %res)
  br label %retblk

notfound:
  %nf.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @NotFoundStr, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nf.ptr)
  br label %retblk

retblk:
  ret i32 0
}
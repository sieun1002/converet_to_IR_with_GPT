; ModuleID = 'main_module'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %arr.ptr, i64 0
  store i32 5, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 8, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 4, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 2, i32* %idx4, align 4
  %call = call i32 @linear_search(i32* noundef %arr.ptr, i32 noundef 5, i32 noundef 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %call)
  br label %exit

notfound:
  %notptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not, i64 0, i64 0
  %callputs = call i32 @puts(i8* noundef %notptr)
  br label %exit

exit:
  ret i32 0
}
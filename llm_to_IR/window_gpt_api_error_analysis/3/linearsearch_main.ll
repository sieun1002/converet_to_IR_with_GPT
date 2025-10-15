; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.found = private unnamed_addr constant [28 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %key) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.cur = load i32, i32* %i, align 4
  %cmp.range = icmp slt i32 %i.cur, %len
  br i1 %cmp.range, label %body, label %retneg1

body:                                             ; preds = %loop
  %i64 = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp.eq = icmp eq i32 %elem, %key
  br i1 %cmp.eq, label %found, label %inc

found:                                            ; preds = %body
  ret i32 %i.cur

inc:                                              ; preds = %body
  %incv = add nsw i32 %i.cur, 1
  store i32 %incv, i32* %i, align 4
  br label %loop

retneg1:                                          ; preds = %loop
  ret i32 -1
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %key = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4
  store i32 5, i32* %len, align 4
  store i32 4, i32* %key, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %lenv = load i32, i32* %len, align 4
  %keyv = load i32, i32* %key, align 4
  %res = call i32 @linear_search(i32* %arrptr, i32 %lenv, i32 %keyv)
  %cmp = icmp eq i32 %res, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.found, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %res)
  br label %ret

notfound:                                         ; preds = %entry
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %ret

ret:                                              ; preds = %notfound, %found
  ret i32 0
}
; ModuleID = 'linear_search_module'
source_filename = "linear_search.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:
  %idxprom = sext i32 %i to i64
  %elem_ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %elem_ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %cont

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

found:
  ret i32 %i

notfound:
  ret i32 -1
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arrptr, i32 5, i32 4)
  %cmpres = icmp eq i32 %call, -1
  br i1 %cmpres, label %not_found, label %found_lbl

found_lbl:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %end

not_found:
  %msgptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %msgptr)
  br label %end

end:
  ret i32 0
}
; ModuleID = 'linear_search_main'
target triple = "x86_64-pc-linux-gnu"

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 8

  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %idx = call i32 @linear_search(i32* noundef %arrdecay, i32 noundef 5, i32 noundef 4)

  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 %idx)
  br label %ret

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* noundef %sptr)
  br label %ret

ret:
  ret i32 0
}
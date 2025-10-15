; ModuleID = 'linear_search_main'
source_filename = "linear_search_main"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not   = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main() #0 {
entry:
  %arr = alloca [5 x i32], align 16
  %len.addr = alloca i32, align 4
  %key.addr = alloca i32, align 4
  %idx.addr = alloca i32, align 4
  %gep0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %gep4, align 4
  store i32 5, i32* %len.addr, align 4
  store i32 4, i32* %key.addr, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len = load i32, i32* %len.addr, align 4
  %key = load i32, i32* %key.addr, align 4
  %call = call i32 @linear_search(i32* %arrptr, i32 %len, i32 %key)
  store i32 %call, i32* %idx.addr, align 4
  %idx = load i32, i32* %idx.addr, align 4
  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %exit

notfound:
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %exit

exit:
  ret i32 0
}

attributes #0 = { sspstrong }
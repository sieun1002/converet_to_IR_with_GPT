; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4

  ; Initialize array: {5, 3, 8, 4, 2}
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

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %keyval = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arrdecay, i32 %nval, i32 %keyval)
  %isneg1 = icmp eq i32 %call, -1
  br i1 %isneg1, label %notfound, label %found

found:
  %format = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %printf_call = call i32 (i8*, ...) @printf(i8* %format, i32 %call)
  br label %ret

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %puts_call = call i32 @puts(i8* %msg)
  br label %ret

ret:
  ret i32 0
}
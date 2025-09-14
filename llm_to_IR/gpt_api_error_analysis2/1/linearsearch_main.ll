; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %key = alloca i32, align 4
  %len = alloca i32, align 4
  %res = alloca i32, align 4
  %arr.gep0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds i32, i32* %arr.gep0, i64 1
  store i32 3, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds i32, i32* %arr.gep0, i64 2
  store i32 8, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds i32, i32* %arr.gep0, i64 3
  store i32 4, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds i32, i32* %arr.gep0, i64 4
  store i32 2, i32* %arr.gep4, align 4
  store i32 5, i32* %key, align 4
  store i32 4, i32* %len, align 4
  %key.load = load i32, i32* %key, align 4
  %len.load = load i32, i32* %len, align 4
  %call = call i32 @linear_search(i32* %arr.gep0, i32 %key.load, i32 %len.load)
  store i32 %call, i32* %res, align 4
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmt.gep = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %res.load = load i32, i32* %res, align 4
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.gep, i32 %res.load)
  br label %ret

notfound:
  %nf.gep = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %nf.gep)
  br label %ret

ret:
  ret i32 0
}
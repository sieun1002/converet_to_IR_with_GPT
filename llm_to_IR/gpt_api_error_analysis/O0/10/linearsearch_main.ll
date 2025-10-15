; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %p4, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arrdecay, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %printres = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %ret

notfound:
  %msgptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %putsres = call i32 @puts(i8* %msgptr)
  br label %ret

ret:
  ret i32 0
}
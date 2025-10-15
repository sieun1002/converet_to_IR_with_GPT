; ModuleID: linear_search_module
target triple = "x86_64-pc-windows-msvc"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str_not_found = private unnamed_addr constant [18 x i8] c"Element not found\00"

declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @linear_search(i32* %arr, i32 %key, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %ret.notfound

loop.body:
  %i.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %ret.found, label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i, 1
  br label %loop

ret.found:
  ret i32 %i

ret.notfound:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %printf_call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %end

notfound:
  %msgptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not_found, i64 0, i64 0
  %puts_call = call i32 @puts(i8* %msgptr)
  br label %end

end:
  ret i32 0
}
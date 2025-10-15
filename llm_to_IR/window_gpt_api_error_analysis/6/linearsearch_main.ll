; ModuleID = 'linear_search_module'
source_filename = "linear_search.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@arr.const = private unnamed_addr constant [5 x i32] [i32 5, i32 3, i32 8, i32 4, i32 2], align 16

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @linear_search(i32* %arr, i32 %target, i32 %size) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %size
  br i1 %cmp, label %body, label %end

body:
  %idx64 = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %inc

inc:
  %next = add nsw i32 %i.val, 1
  store i32 %next, i32* %i, align 4
  br label %loop

found:
  ret i32 %i.val

end:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* @arr.const, i64 0, i64 0
  %res = call i32 @linear_search(i32* %arrptr, i32 5, i32 4)
  %notfound = icmp eq i32 %res, -1
  br i1 %notfound, label %nf, label %ff

nf:
  %s2 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.not, i64 0, i64 0
  %callputs = call i32 @puts(i8* %s2)
  br label %ret

ff:
  %s1 = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %s1, i32 %res)
  br label %ret

ret:
  ret i32 0
}
; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-windows-msvc"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %ret.notfound

loop.body:
  %i.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %ret.found, label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

ret.found:
  ret i32 %i

ret.notfound:
  ret i32 -1
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
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
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arr.ptr, i32 5, i32 4)
  %cmpres = icmp ne i32 %call, -1
  br i1 %cmpres, label %if.found, label %if.notfound

if.found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %print = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %end

if.notfound:
  %msgptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %putsret = call i32 @puts(i8* %msgptr)
  br label %end

end:
  ret i32 0
}
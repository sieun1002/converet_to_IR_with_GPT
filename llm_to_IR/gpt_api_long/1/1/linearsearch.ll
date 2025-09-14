; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00"
@__stack_chk_guard = external global i64

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard, align 4
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

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %afterprint

notfound:                                         ; preds = %entry
  %strptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %strptr)
  br label %afterprint

afterprint:                                       ; preds = %notfound, %found
  %guard1 = load i64, i64* @__stack_chk_guard, align 4
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %ret, label %stackfail

ret:                                              ; preds = %afterprint
  ret i32 0

stackfail:                                        ; preds = %afterprint
  call void @__stack_chk_fail()
  unreachable
}

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

declare void @__stack_chk_fail()

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.next, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.next ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %end.notfound

loop.body:                                        ; preds = %loop.cond
  %idx.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %loop.next

loop.next:                                        ; preds = %loop.body
  %i.next = add i32 %i, 1
  br label %loop.cond

found:                                            ; preds = %loop.body
  ret i32 %i

end.notfound:                                     ; preds = %loop.cond
  ret i32 -1
}

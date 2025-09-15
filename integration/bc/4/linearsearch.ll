; ModuleID = 'linearsearch.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %target = alloca i32, align 4
  %n = alloca i32, align 4
  %idx = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4
  store i32 5, i32* %target, align 4
  store i32 4, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %tval = load i32, i32* %target, align 4
  %nval = load i32, i32* %n, align 4
  %call = call i32 @linear_search(i32* %arrdecay, i32 %tval, i32 %nval)
  store i32 %call, i32* %idx, align 4
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %idxval = load i32, i32* %idx, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idxval)
  br label %ret

notfound:                                         ; preds = %entry
  %spptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %spptr)
  br label %ret

ret:                                              ; preds = %notfound, %found
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %key) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %notfound

loop.body:                                        ; preds = %loop.header
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %key, %elem
  br i1 %eq, label %found, label %loop.latch

loop.latch:                                       ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.header

found:                                            ; preds = %loop.body
  ret i32 %i

notfound:                                         ; preds = %loop.header
  ret i32 -1
}

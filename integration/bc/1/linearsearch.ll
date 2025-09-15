; ModuleID = 'linearsearch.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

; Function Attrs: sspstrong
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

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %exit

notfound:                                         ; preds = %entry
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %exit

exit:                                             ; preds = %notfound, %found
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

; Function Attrs: nounwind
define i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %target) #1 {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp.bound = icmp slt i32 %i, %len
  br i1 %cmp.bound, label %loop.body, label %exit.notfound

loop.body:                                        ; preds = %loop.header
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %cmp.eq = icmp eq i32 %elem.val, %target
  br i1 %cmp.eq, label %found, label %loop.latch

found:                                            ; preds = %loop.body
  ret i32 %i

loop.latch:                                       ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit.notfound:                                    ; preds = %loop.header
  ret i32 -1
}

attributes #0 = { sspstrong }
attributes #1 = { nounwind }

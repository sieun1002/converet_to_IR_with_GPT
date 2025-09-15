; ModuleID = 'linearsearch.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.elem4, align 4
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arr.base, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %not_found, label %found

found:                                            ; preds = %entry
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %call)
  br label %ret

not_found:                                        ; preds = %entry
  %s.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %s.ptr)
  br label %ret

ret:                                              ; preds = %not_found, %found
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*)

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %cont

cont:                                             ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

found:                                            ; preds = %body
  ret i32 %i

notfound:                                         ; preds = %loop
  ret i32 -1
}

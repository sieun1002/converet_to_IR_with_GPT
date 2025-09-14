; ModuleID = 'linear_search_module'
target triple = "x86_64-unknown-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @linear_search(i32* noalias nocapture readonly %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %loop.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %not_found

loop.body:                                        ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop

found:                                            ; preds = %loop.body
  ret i32 %i

not_found:                                        ; preds = %loop
  ret i32 -1
}

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.ptr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.ptr0, align 4
  %arr.ptr1 = getelementptr inbounds i32, i32* %arr.ptr0, i64 1
  store i32 3, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds i32, i32* %arr.ptr0, i64 2
  store i32 8, i32* %arr.ptr2, align 4
  %arr.ptr3 = getelementptr inbounds i32, i32* %arr.ptr0, i64 3
  store i32 4, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds i32, i32* %arr.ptr0, i64 4
  store i32 2, i32* %arr.ptr4, align 4
  %call = call i32 @linear_search(i32* %arr.ptr0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notf, label %yesf

yesf:                                             ; preds = %entry
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %prt = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %call)
  br label %ret

notf:                                             ; preds = %entry
  %s.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %s.ptr)
  br label %ret

ret:                                              ; preds = %yesf, %notf
  ret i32 0
}
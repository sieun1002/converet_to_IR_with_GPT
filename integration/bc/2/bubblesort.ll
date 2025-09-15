; ModuleID = 'bubblesort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i64, align 8
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  store i64 10, i64* %len, align 8
  store i64 0, i64* %idx, align 8
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len, align 8
  call void @bubble_sort(i32* noundef %arrptr, i64 noundef %lenval)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %idx, align 8
  %n.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %loop.exit

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem.val)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %idx, align 8
  br label %loop.cond

loop.exit:                                        ; preds = %loop.cond
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.header

outer.header:                                     ; preds = %outer.update, %entry
  %limit = phi i64 [ %n, %entry ], [ %limit.next, %outer.update ]
  %gt1 = icmp ugt i64 %limit, 1
  br i1 %gt1, label %outer.body.init, label %ret

outer.body.init:                                  ; preds = %outer.header
  br label %inner.header

inner.header:                                     ; preds = %inc, %outer.body.init
  %j = phi i64 [ 1, %outer.body.init ], [ %j.next, %inc ]
  %last = phi i64 [ 0, %outer.body.init ], [ %last.updated, %inc ]
  %j_lt_limit = icmp ult i64 %j, %limit
  br i1 %j_lt_limit, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %jm1 = add i64 %j, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %j
  %v.prev = load i32, i32* %ptr.prev, align 4
  %v.cur = load i32, i32* %ptr.cur, align 4
  %need.swap = icmp sgt i32 %v.prev, %v.cur
  br i1 %need.swap, label %swap, label %no.swap

swap:                                             ; preds = %inner.body
  store i32 %v.cur, i32* %ptr.prev, align 4
  store i32 %v.prev, i32* %ptr.cur, align 4
  br label %inc

no.swap:                                          ; preds = %inner.body
  br label %inc

inc:                                              ; preds = %no.swap, %swap
  %last.updated = phi i64 [ %j, %swap ], [ %last, %no.swap ]
  %j.next = add i64 %j, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %ret, label %outer.update

outer.update:                                     ; preds = %after.inner
  %limit.next = phi i64 [ %last, %after.inner ]
  br label %outer.header

ret:                                              ; preds = %after.inner, %outer.header, %entry
  ret void
}

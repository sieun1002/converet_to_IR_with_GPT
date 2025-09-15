; ModuleID = 'bubblesort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
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
  %len.load0 = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr.base, i64 %len.load0)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %len.load1 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.load1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %print = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i.next = add nuw i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %return, label %init

init:                                             ; preds = %entry
  br label %outer.header

outer.header:                                     ; preds = %update.bound, %init
  %bound = phi i64 [ %n, %init ], [ %last, %update.bound ]
  %cond_outer = icmp ugt i64 %bound, 1
  br i1 %cond_outer, label %outer.body, label %return

outer.body:                                       ; preds = %outer.header
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %outer.body
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.body ], [ %last.updated, %inner.latch ]
  %cond_inner = icmp ult i64 %i, %bound
  br i1 %cond_inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %im1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %a = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr_i, align 4
  %cmp_gt = icmp sgt i32 %a, %b
  br i1 %cmp_gt, label %do.swap, label %no.swap

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %ptr_im1, align 4
  store i32 %a, i32* %ptr_i, align 4
  br label %inner.latch

no.swap:                                          ; preds = %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %no.swap, %do.swap
  %last.updated = select i1 %cmp_gt, i64 %i, i64 %last
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %had.swap = icmp ne i64 %last, 0
  br i1 %had.swap, label %update.bound, label %return

update.bound:                                     ; preds = %after.inner
  br label %outer.header

return:                                           ; preds = %after.inner, %outer.header, %entry
  ret void
}

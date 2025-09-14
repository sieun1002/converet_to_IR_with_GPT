; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %9, align 4
  call void @bubble_sort(i32* %0, i64 10)
  br label %loop.init

loop.init:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.init
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop.init

loop.end:                                         ; preds = %loop.init
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.header

outer.header:                                     ; preds = %sethigh, %entry
  %high = phi i64 [ %n, %entry ], [ %high.next, %sethigh ]
  %cond.high.gt1 = icmp ugt i64 %high, 1
  br i1 %cond.high.gt1, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.header
  br label %inner.header

inner.header:                                     ; preds = %inc, %outer.body
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inc ]
  %last = phi i64 [ 0, %outer.body ], [ %last.next, %inc ]
  %cmp.i.lt.high = icmp ult i64 %i, %high
  br i1 %cmp.i.lt.high, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %idxm1 = add i64 %i, -1
  %p.prev = getelementptr inbounds i32, i32* %a, i64 %idxm1
  %p.cur = getelementptr inbounds i32, i32* %a, i64 %i
  %v.prev = load i32, i32* %p.prev, align 4
  %v.cur = load i32, i32* %p.cur, align 4
  %need.swap = icmp sgt i32 %v.prev, %v.cur
  br i1 %need.swap, label %swap, label %noswap

swap:                                             ; preds = %inner.body
  store i32 %v.cur, i32* %p.prev, align 4
  store i32 %v.prev, i32* %p.cur, align 4
  br label %inc

noswap:                                           ; preds = %inner.body
  br label %inc

inc:                                              ; preds = %noswap, %swap
  %last.next = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %nochange = icmp eq i64 %last, 0
  br i1 %nochange, label %ret, label %sethigh

sethigh:                                          ; preds = %after.inner
  %high.next = add i64 %last, 0
  br label %outer.header

ret:                                              ; preds = %after.inner, %outer.header, %entry
  ret void
}

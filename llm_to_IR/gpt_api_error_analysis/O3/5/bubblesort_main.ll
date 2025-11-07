; ModuleID = 'bubble_sort_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 4
  store i32 7, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 6
  store i32 6, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 7
  store i32 5, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 9
  store i32 0, i32* %arr9, align 4
  br label %outer

outer:
  %bound = phi i32 [ 10, %entry ], [ %last.exit, %inner.end ]
  br label %inner.header

inner.header:
  %i = phi i32 [ 1, %outer ], [ %i.next, %body.cont ]
  %last.cur = phi i32 [ 0, %outer ], [ %last.next, %body.cont ]
  %cmp.i.bound = icmp slt i32 %i, %bound
  br i1 %cmp.i.bound, label %inner.body, label %inner.end

inner.body:
  %i.minus1 = add nsw i32 %i, -1
  %ptr.prev = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %i.minus1
  %ptr.curr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %i
  %val.prev = load i32, i32* %ptr.prev, align 4
  %val.curr = load i32, i32* %ptr.curr, align 4
  %gt = icmp sgt i32 %val.prev, %val.curr
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %val.curr, i32* %ptr.prev, align 4
  store i32 %val.prev, i32* %ptr.curr, align 4
  br label %body.cont

noswap:
  br label %body.cont

body.cont:
  %last.next = phi i32 [ %i, %swap ], [ %last.cur, %noswap ]
  %i.next = add nsw i32 %i, 1
  br label %inner.header

inner.end:
  %last.exit = phi i32 [ %last.cur, %inner.header ]
  %is0 = icmp eq i32 %last.exit, 0
  %is1 = icmp eq i32 %last.exit, 1
  %stop = or i1 %is0, %is1
  br i1 %stop, label %print.init, label %outer

print.init:
  br label %print.loop

print.loop:
  %idx = phi i32 [ 0, %print.init ], [ %idx.next, %print.body ]
  %done = icmp eq i32 %idx, 10
  br i1 %done, label %print.nl, label %print.body

print.body:
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %idx
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %elt)
  %idx.next = add nsw i32 %idx, 1
  br label %print.loop

print.nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0
}
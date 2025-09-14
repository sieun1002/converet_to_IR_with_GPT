; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr #0 {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %bound = alloca i64, align 8
  %i = alloca i64, align 8
  %lastSwap = alloca i64, align 8
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %return, label %init

init:
  %n.load = load i64, i64* %n.addr, align 8
  store i64 %n.load, i64* %bound, align 8
  br label %outer.cond

outer.cond:
  %bound.load = load i64, i64* %bound, align 8
  %cmp1 = icmp ugt i64 %bound.load, 1
  br i1 %cmp1, label %outer.body, label %return

outer.body:
  store i64 0, i64* %lastSwap, align 8
  store i64 1, i64* %i, align 8
  br label %inner.cond

inner.cond:
  %i.load = load i64, i64* %i, align 8
  %bound.load2 = load i64, i64* %bound, align 8
  %cmp2 = icmp ult i64 %i.load, %bound.load2
  br i1 %cmp2, label %inner.body, label %after.inner

inner.body:
  %arr.load = load i32*, i32** %arr.addr, align 8
  %idx.prev = sub i64 %i.load, 1
  %ptr.prev = getelementptr inbounds i32, i32* %arr.load, i64 %idx.prev
  %val.prev = load i32, i32* %ptr.prev, align 4
  %ptr.cur = getelementptr inbounds i32, i32* %arr.load, i64 %i.load
  %val.cur = load i32, i32* %ptr.cur, align 4
  %cmp.swap = icmp sgt i32 %val.prev, %val.cur
  br i1 %cmp.swap, label %do.swap, label %inc.i

do.swap:
  store i32 %val.prev, i32* %tmp, align 4
  store i32 %val.cur, i32* %ptr.prev, align 4
  %tmp.load = load i32, i32* %tmp, align 4
  store i32 %tmp.load, i32* %ptr.cur, align 4
  store i64 %i.load, i64* %lastSwap, align 8
  br label %inc.i

inc.i:
  %i.plus1 = add i64 %i.load, 1
  store i64 %i.plus1, i64* %i, align 8
  br label %inner.cond

after.inner:
  %lastSwap.load = load i64, i64* %lastSwap, align 8
  %no.swap = icmp eq i64 %lastSwap.load, 0
  br i1 %no.swap, label %return, label %set.bound

set.bound:
  store i64 %lastSwap.load, i64* %bound, align 8
  br label %outer.cond

return:
  ret void
}

attributes #0 = { nounwind uwtable "frame-pointer"="all" "target-cpu"="x86-64" }
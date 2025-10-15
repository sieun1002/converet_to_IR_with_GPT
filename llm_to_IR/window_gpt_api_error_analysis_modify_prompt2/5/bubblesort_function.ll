target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var8 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var1C = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %nload0 = load i64, i64* %n.addr, align 8
  %cmp0 = icmp ule i64 %nload0, 1
  br i1 %cmp0, label %exit, label %init_limit

init_limit:
  %nload1 = load i64, i64* %n.addr, align 8
  store i64 %nload1, i64* %var8, align 8
  br label %outer_check

outer_check:
  %limit.load = load i64, i64* %var8, align 8
  %cond1 = icmp ugt i64 %limit.load, 1
  br i1 %cond1, label %outer_body_init, label %exit

outer_body_init:
  store i64 0, i64* %var10, align 8
  store i64 1, i64* %var18, align 8
  br label %inner_check

inner_check:
  %i.load = load i64, i64* %var18, align 8
  %limit.load2 = load i64, i64* %var8, align 8
  %cmp2 = icmp ult i64 %i.load, %limit.load2
  br i1 %cmp2, label %inner_body, label %after_inner

inner_body:
  %i.val = load i64, i64* %var18, align 8
  %im1 = sub i64 %i.val, 1
  %arr.base = load i32*, i32** %arr.addr, align 8
  %ptr.prev = getelementptr inbounds i32, i32* %arr.base, i64 %im1
  %val.prev = load i32, i32* %ptr.prev, align 4
  %i.val2 = load i64, i64* %var18, align 8
  %arr.base2 = load i32*, i32** %arr.addr, align 8
  %ptr.cur = getelementptr inbounds i32, i32* %arr.base2, i64 %i.val2
  %val.cur = load i32, i32* %ptr.cur, align 4
  %cmp.le = icmp sle i32 %val.prev, %val.cur
  br i1 %cmp.le, label %inner_increment, label %swap_block

swap_block:
  store i32 %val.prev, i32* %var1C, align 4
  store i32 %val.cur, i32* %ptr.prev, align 4
  %tmp.saved = load i32, i32* %var1C, align 4
  store i32 %tmp.saved, i32* %ptr.cur, align 4
  %i.for.last = load i64, i64* %var18, align 8
  store i64 %i.for.last, i64* %var10, align 8
  br label %inner_increment

inner_increment:
  %i.old = load i64, i64* %var18, align 8
  %i.next = add i64 %i.old, 1
  store i64 %i.next, i64* %var18, align 8
  br label %inner_check

after_inner:
  %last.load = load i64, i64* %var10, align 8
  %is.zero = icmp eq i64 %last.load, 0
  br i1 %is.zero, label %exit, label %setlimit

setlimit:
  store i64 %last.load, i64* %var8, align 8
  br label %outer_check

exit:
  ret void
}
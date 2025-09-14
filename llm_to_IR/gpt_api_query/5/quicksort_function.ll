; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort.ll"

define dso_local void @quick_sort(i32* %base, i64 %low, i64 %high) {
entry:
  %base.addr = alloca i32*, align 8
  %low.addr = alloca i64, align 8
  %high.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %base, i32** %base.addr, align 8
  store i64 %low, i64* %low.addr, align 8
  store i64 %high, i64* %high.addr, align 8
  br label %while.cond

while.cond:                                       ; preds = %skip.right, %skip.left, %entry
  %low.val = load i64, i64* %low.addr, align 8
  %high.val = load i64, i64* %high.addr, align 8
  %cond = icmp slt i64 %low.val, %high.val
  br i1 %cond, label %loop.body, label %return

loop.body:                                        ; preds = %while.cond
  store i64 %low.val, i64* %i, align 8
  store i64 %high.val, i64* %j, align 8
  %diff = sub i64 %high.val, %low.val
  %sign = ashr i64 %diff, 63
  %adj = add i64 %diff, %sign
  %half = ashr i64 %adj, 1
  %mid = add i64 %low.val, %half
  %base.ld = load i32*, i32** %base.addr, align 8
  %pidx = getelementptr i32, i32* %base.ld, i64 %mid
  %pval = load i32, i32* %pidx, align 4
  store i32 %pval, i32* %pivot, align 4
  br label %i.loop

i.loop:                                           ; preds = %i.inc, %loop.body
  %i.cur = load i64, i64* %i, align 8
  %base.ld2 = load i32*, i32** %base.addr, align 8
  %iptr = getelementptr i32, i32* %base.ld2, i64 %i.cur
  %ival = load i32, i32* %iptr, align 4
  %pivot.ld = load i32, i32* %pivot, align 4
  %cmp_i = icmp sgt i32 %pivot.ld, %ival
  br i1 %cmp_i, label %i.inc, label %j.loop

i.inc:                                            ; preds = %i.loop
  %i.cur2 = load i64, i64* %i, align 8
  %i.next = add i64 %i.cur2, 1
  store i64 %i.next, i64* %i, align 8
  br label %i.loop

j.loop:                                           ; preds = %i.loop, %j.dec
  %j.cur = load i64, i64* %j, align 8
  %base.ld3 = load i32*, i32** %base.addr, align 8
  %jptr = getelementptr i32, i32* %base.ld3, i64 %j.cur
  %jval = load i32, i32* %jptr, align 4
  %pivot.ld2 = load i32, i32* %pivot, align 4
  %cmp_j = icmp slt i32 %pivot.ld2, %jval
  br i1 %cmp_j, label %j.dec, label %compare

j.dec:                                            ; preds = %j.loop
  %j.cur2 = load i64, i64* %j, align 8
  %j.next = add i64 %j.cur2, -1
  store i64 %j.next, i64* %j, align 8
  br label %j.loop

compare:                                          ; preds = %j.loop
  %i.c = load i64, i64* %i, align 8
  %j.c = load i64, i64* %j, align 8
  %ilej = icmp sle i64 %i.c, %j.c
  br i1 %ilej, label %do.swap, label %after.partition

do.swap:                                          ; preds = %compare
  %base.ld4 = load i32*, i32** %base.addr, align 8
  %iptr2 = getelementptr i32, i32* %base.ld4, i64 %i.c
  %ival2 = load i32, i32* %iptr2, align 4
  store i32 %ival2, i32* %tmp, align 4
  %base.ld5 = load i32*, i32** %base.addr, align 8
  %jptr2 = getelementptr i32, i32* %base.ld5, i64 %j.c
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  %tmpval = load i32, i32* %tmp, align 4
  store i32 %tmpval, i32* %jptr2, align 4
  %i.c2 = add i64 %i.c, 1
  store i64 %i.c2, i64* %i, align 8
  %j.c2 = add i64 %j.c, -1
  store i64 %j.c2, i64* %j, align 8
  br label %check_again

check_again:                                      ; preds = %do.swap
  %i.ca = load i64, i64* %i, align 8
  %j.ca = load i64, i64* %j, align 8
  %le2 = icmp sle i64 %i.ca, %j.ca
  br i1 %le2, label %i.loop, label %after.partition

after.partition:                                  ; preds = %check_again, %compare
  %low.ld3 = load i64, i64* %low.addr, align 8
  %i.ld = load i64, i64* %i, align 8
  %j.ld = load i64, i64* %j, align 8
  %high.ld3 = load i64, i64* %high.addr, align 8
  %left.size = sub i64 %j.ld, %low.ld3
  %right.size = sub i64 %high.ld3, %i.ld
  %left_lt_right = icmp slt i64 %left.size, %right.size
  br i1 %left_lt_right, label %recurse.left, label %recurse.right

recurse.left:                                     ; preds = %after.partition
  %condL = icmp slt i64 %low.ld3, %j.ld
  br i1 %condL, label %call.left, label %skip.left

call.left:                                        ; preds = %recurse.left
  %base.ld6 = load i32*, i32** %base.addr, align 8
  call void @quick_sort(i32* %base.ld6, i64 %low.ld3, i64 %j.ld)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %recurse.left
  store i64 %i.ld, i64* %low.addr, align 8
  br label %while.cond

recurse.right:                                    ; preds = %after.partition
  %condR = icmp slt i64 %i.ld, %high.ld3
  br i1 %condR, label %call.right, label %skip.right

call.right:                                       ; preds = %recurse.right
  %base.ld7 = load i32*, i32** %base.addr, align 8
  call void @quick_sort(i32* %base.ld7, i64 %i.ld, i64 %high.ld3)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %recurse.right
  store i64 %j.ld, i64* %high.addr, align 8
  br label %while.cond

return:                                           ; preds = %while.cond
  ret void
}
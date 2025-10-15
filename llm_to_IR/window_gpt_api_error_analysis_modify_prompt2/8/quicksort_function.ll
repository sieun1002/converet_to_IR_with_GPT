; ModuleID = 'quick_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* noundef %arr, i32 noundef %left, i32 noundef %right) {
entry:
  %arr.addr = alloca i32*, align 8
  %left.addr = alloca i32, align 4
  %right.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %left, i32* %left.addr, align 4
  store i32 %right, i32* %right.addr, align 4
  br label %outer.cond

outer.cond:                                       ; loc_1400015B7
  %left.cur = load i32, i32* %left.addr, align 4
  %right.cur = load i32, i32* %right.addr, align 4
  %cmp.lr = icmp slt i32 %left.cur, %right.cur
  br i1 %cmp.lr, label %outer.body, label %ret

outer.body:                                       ; loc_140001468
  store i32 %left.cur, i32* %i, align 4
  store i32 %right.cur, i32* %j, align 4
  %t0 = sub nsw i32 %right.cur, %left.cur
  %t1 = ashr i32 %t0, 31
  %t2 = add nsw i32 %t0, %t1
  %t3 = ashr i32 %t2, 1
  %mid = add nsw i32 %left.cur, %t3
  %mid64 = sext i32 %mid to i64
  %arr0 = load i32*, i32** %arr.addr, align 8
  %pivot.ptr = getelementptr inbounds i32, i32* %arr0, i64 %mid64
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  store i32 %pivot.val, i32* %pivot, align 4
  br label %scan.i

scan.i:                                           ; loc_1400014A6
  %i.val = load i32, i32* %i, align 4
  %i64 = sext i32 %i.val to i64
  %arr1 = load i32*, i32** %arr.addr, align 8
  %elem.i.ptr = getelementptr inbounds i32, i32* %arr1, i64 %i64
  %elem.i = load i32, i32* %elem.i.ptr, align 4
  %pivot.cur0 = load i32, i32* %pivot, align 4
  %cmp.i = icmp sgt i32 %pivot.cur0, %elem.i
  br i1 %cmp.i, label %inc.i, label %scan.j

inc.i:                                            ; loc_1400014A2
  %i.val2 = load i32, i32* %i, align 4
  %i.inc = add nsw i32 %i.val2, 1
  store i32 %i.inc, i32* %i, align 4
  br label %scan.i

scan.j:                                           ; loc_1400014C7
  %j.val = load i32, i32* %j, align 4
  %j64 = sext i32 %j.val to i64
  %arr2 = load i32*, i32** %arr.addr, align 8
  %elem.j.ptr = getelementptr inbounds i32, i32* %arr2, i64 %j64
  %elem.j = load i32, i32* %elem.j.ptr, align 4
  %pivot.cur1 = load i32, i32* %pivot, align 4
  %cmp.j = icmp slt i32 %pivot.cur1, %elem.j
  br i1 %cmp.j, label %dec.j, label %check.swap

dec.j:                                            ; loc_1400014C3
  %j.val2 = load i32, i32* %j, align 4
  %j.dec = add nsw i32 %j.val2, -1
  store i32 %j.dec, i32* %j, align 4
  br label %scan.j

check.swap:                                       ; loc_1400014E2
  %i.cur = load i32, i32* %i, align 4
  %j.cur = load i32, i32* %j, align 4
  %cmp.ij = icmp sgt i32 %i.cur, %j.cur
  br i1 %cmp.ij, label %post.swap, label %do.swap

do.swap:                                          ; loc_1400014EA .. 0x14000154D
  %i.cur2 = load i32, i32* %i, align 4
  %i64b = sext i32 %i.cur2 to i64
  %arr3 = load i32*, i32** %arr.addr, align 8
  %ptr.i = getelementptr inbounds i32, i32* %arr3, i64 %i64b
  %val.i = load i32, i32* %ptr.i, align 4
  store i32 %val.i, i32* %tmp, align 4
  %j.cur2 = load i32, i32* %j, align 4
  %j64b = sext i32 %j.cur2 to i64
  %arr4 = load i32*, i32** %arr.addr, align 8
  %ptr.j = getelementptr inbounds i32, i32* %arr4, i64 %j64b
  %val.j = load i32, i32* %ptr.j, align 4
  store i32 %val.j, i32* %ptr.i, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %ptr.j, align 4
  %i.cur3 = load i32, i32* %i, align 4
  %i.inc2 = add nsw i32 %i.cur3, 1
  store i32 %i.inc2, i32* %i, align 4
  %j.cur3 = load i32, i32* %j, align 4
  %j.dec2 = add nsw i32 %j.cur3, -1
  store i32 %j.dec2, i32* %j, align 4
  br label %post.swap

post.swap:                                        ; loc_140001551
  %i.cur4 = load i32, i32* %i, align 4
  %j.cur4 = load i32, i32* %j, align 4
  %cmp.cont = icmp sle i32 %i.cur4, %j.cur4
  br i1 %cmp.cont, label %scan.i, label %after.partition

after.partition:                                  ; 0x14000155D ..
  %j.end = load i32, i32* %j, align 4
  %left.cur2 = load i32, i32* %left.addr, align 4
  %l.len = sub nsw i32 %j.end, %left.cur2
  %right.cur2 = load i32, i32* %right.addr, align 4
  %i.end = load i32, i32* %i, align 4
  %r.len = sub nsw i32 %right.cur2, %i.end
  %cmp.len = icmp sge i32 %l.len, %r.len
  br i1 %cmp.len, label %right.rec, label %left.rec

left.rec:                                         ; loc_14000156F
  %left.cur3 = load i32, i32* %left.addr, align 4
  %j.end2 = load i32, i32* %j, align 4
  %cmp.left.nonempty = icmp slt i32 %left.cur3, %j.end2
  br i1 %cmp.left.nonempty, label %do.left.call, label %left.update

do.left.call:                                     ; loc_140001577 .. 0x140001587
  %arr.ld1 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld1, i32 %left.cur3, i32 %j.end2)
  br label %left.update

left.update:                                      ; loc_14000158C .. 0x140001592
  %i.end2 = load i32, i32* %i, align 4
  store i32 %i.end2, i32* %left.addr, align 4
  br label %outer.cond

right.rec:                                        ; loc_140001594
  %i.end3 = load i32, i32* %i, align 4
  %right.cur3 = load i32, i32* %right.addr, align 4
  %cmp.right.nonempty = icmp slt i32 %i.end3, %right.cur3
  br i1 %cmp.right.nonempty, label %do.right.call, label %right.update

do.right.call:                                    ; loc_14000159C .. 0x1400015AC
  %arr.ld2 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld2, i32 %i.end3, i32 %right.cur3)
  br label %right.update

right.update:                                     ; loc_1400015B1 .. 0x1400015B4
  %j.end3 = load i32, i32* %j, align 4
  store i32 %j.end3, i32* %right.addr, align 4
  br label %outer.cond

ret:
  ret void
}
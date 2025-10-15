target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.load = load i32, i32* %n.addr, align 4
  %n.minus1 = add i32 %n.load, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:                                       ; preds = %outer.cond
  %i.plus.one = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.latch, %outer.body
  %min.phi = phi i32 [ %i, %outer.body ], [ %min.next, %inner.latch ]
  %j = phi i32 [ %i.plus.one, %outer.body ], [ %j.next, %inner.latch ]
  %n.load.j = load i32, i32* %n.addr, align 4
  %cmp.j = icmp slt i32 %j, %n.load.j
  br i1 %cmp.j, label %inner.body, label %post.inner

inner.body:                                       ; preds = %inner.cond
  %arr.load1 = load i32*, i32** %arr.addr, align 8
  %j.sext = sext i32 %j to i64
  %j.gep = getelementptr inbounds i32, i32* %arr.load1, i64 %j.sext
  %val.j = load i32, i32* %j.gep, align 4
  %arr.load2 = load i32*, i32** %arr.addr, align 8
  %min.sext = sext i32 %min.phi to i64
  %min.gep = getelementptr inbounds i32, i32* %arr.load2, i64 %min.sext
  %val.min = load i32, i32* %min.gep, align 4
  %cond.update = icmp slt i32 %val.j, %val.min
  br i1 %cond.update, label %updateMin, label %noUpdate

updateMin:                                        ; preds = %inner.body
  br label %inner.latch

noUpdate:                                         ; preds = %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %noUpdate, %updateMin
  %min.next = phi i32 [ %j, %updateMin ], [ %min.phi, %noUpdate ]
  %j.next = add i32 %j, 1
  br label %inner.cond

post.inner:                                       ; preds = %inner.cond
  %min.final = phi i32 [ %min.phi, %inner.cond ]
  %arr.load3 = load i32*, i32** %arr.addr, align 8
  %i.sext = sext i32 %i to i64
  %i.gep = getelementptr inbounds i32, i32* %arr.load3, i64 %i.sext
  %tmp = load i32, i32* %i.gep, align 4
  %arr.load4 = load i32*, i32** %arr.addr, align 8
  %min.final.sext = sext i32 %min.final to i64
  %min.final.gep = getelementptr inbounds i32, i32* %arr.load4, i64 %min.final.sext
  %val.min.final = load i32, i32* %min.final.gep, align 4
  store i32 %val.min.final, i32* %i.gep, align 4
  %arr.load5 = load i32*, i32** %arr.addr, align 8
  %min.final.gep2 = getelementptr inbounds i32, i32* %arr.load5, i64 %min.final.sext
  store i32 %tmp, i32* %min.final.gep2, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %post.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

return:                                           ; preds = %outer.cond
  ret void
}
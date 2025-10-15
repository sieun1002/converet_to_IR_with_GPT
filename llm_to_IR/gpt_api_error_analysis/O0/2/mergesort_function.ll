; target triple may need adjustment to your environment
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %buf.i8 = call i8* @malloc(i64 %size.bytes)
  %buf.isnull = icmp eq i8* %buf.i8, null
  br i1 %buf.isnull, label %ret, label %start

start:
  %buf = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:
  %src.phi = phi i32* [ %dest, %start ], [ %tmp.swap, %after_inner ]
  %tmp.phi = phi i32* [ %buf, %start ], [ %src.swap, %after_inner ]
  %width.phi = phi i64 [ 1, %start ], [ %width.next, %after_inner ]
  %cond.width = icmp ult i64 %width.phi, %n
  br i1 %cond.width, label %inner.preheader, label %after_outer

inner.preheader:
  %twoW = add i64 %width.phi, %width.phi
  br label %inner

inner:
  %i.phi = phi i64 [ 0, %inner.preheader ], [ %i.next, %after_merge ]
  %cond.i = icmp ult i64 %i.phi, %n
  br i1 %cond.i, label %merge.init, label %after_inner

merge.init:
  %istart = add i64 %i.phi, 0
  %t1 = add i64 %i.phi, %width.phi
  %t1.lt.n = icmp ult i64 %t1, %n
  %mid = select i1 %t1.lt.n, i64 %t1, i64 %n
  %t2 = add i64 %i.phi, %twoW
  %t2.lt.n = icmp ult i64 %t2, %n
  %end = select i1 %t2.lt.n, i64 %t2, i64 %n
  br label %k.loop

k.loop:
  %a.phi = phi i64 [ %istart, %merge.init ], [ %a.next, %k.next ]
  %b.phi = phi i64 [ %mid, %merge.init ], [ %b.next, %k.next ]
  %k.phi = phi i64 [ %istart, %merge.init ], [ %k.next, %k.next ]
  %k.lt.end = icmp ult i64 %k.phi, %end
  br i1 %k.lt.end, label %checkLeft, label %after_merge

checkLeft:
  %a.lt.mid = icmp ult i64 %a.phi, %mid
  br i1 %a.lt.mid, label %checkRight, label %takeRight_fromALeFalse

checkRight:
  %b.lt.end = icmp ult i64 %b.phi, %end
  br i1 %b.lt.end, label %compareAB, label %takeLeft_fromBGeEnd

compareAB:
  %ptrA = getelementptr inbounds i32, i32* %src.phi, i64 %a.phi
  %valA = load i32, i32* %ptrA, align 4
  %ptrB = getelementptr inbounds i32, i32* %src.phi, i64 %b.phi
  %valB = load i32, i32* %ptrB, align 4
  %a_le_b = icmp sle i32 %valA, %valB
  br i1 %a_le_b, label %takeLeft_fromCompare, label %takeRight_fromCompare

takeLeft_fromBGeEnd:
  %ptrA.2 = getelementptr inbounds i32, i32* %src.phi, i64 %a.phi
  %valA.2 = load i32, i32* %ptrA.2, align 4
  br label %doTakeLeft

takeLeft_fromCompare:
  br label %doTakeLeft

doTakeLeft:
  %valL = phi i32 [ %valA.2, %takeLeft_fromBGeEnd ], [ %valA, %takeLeft_fromCompare ]
  %tmp.k.L = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %valL, i32* %tmp.k.L, align 4
  %a.next.L = add i64 %a.phi, 1
  %k.next.L = add i64 %k.phi, 1
  br label %k.next

takeRight_fromALeFalse:
  %ptrB.2 = getelementptr inbounds i32, i32* %src.phi, i64 %b.phi
  %valB.2 = load i32, i32* %ptrB.2, align 4
  br label %doTakeRight

takeRight_fromCompare:
  br label %doTakeRight

doTakeRight:
  %valR = phi i32 [ %valB.2, %takeRight_fromALeFalse ], [ %valB, %takeRight_fromCompare ]
  %tmp.k.R = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %valR, i32* %tmp.k.R, align 4
  %b.next.R = add i64 %b.phi, 1
  %k.next.R = add i64 %k.phi, 1
  br label %k.next

k.next:
  %a.next = phi i64 [ %a.next.L, %doTakeLeft ], [ %a.phi, %doTakeRight ]
  %b.next = phi i64 [ %b.phi, %doTakeLeft ], [ %b.next.R, %doTakeRight ]
  %k.next = phi i64 [ %k.next.L, %doTakeLeft ], [ %k.next.R, %doTakeRight ]
  br label %k.loop

after_merge:
  %i.next = add i64 %i.phi, %twoW
  br label %inner

after_inner:
  %src.swap = phi i32* [ %src.phi, %inner ], [ undef, %merge.init ] ; not used
  %tmp.swap = phi i32* [ %tmp.phi, %inner ], [ undef, %merge.init ] ; not used
  %src.next = bitcast i32* %tmp.phi to i32*
  %tmp.next = bitcast i32* %src.phi to i32*
  %width.next = shl i64 %width.phi, 1
  br label %outer

after_outer:
  %src.final = phi i32* [ %src.phi, %outer ]
  %src.eq.dest = icmp eq i32* %src.final, %dest
  br i1 %src.eq.dest, label %do_free, label %do_memcpy

do_memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size.bytes)
  br label %do_free

do_free:
  call void @free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}
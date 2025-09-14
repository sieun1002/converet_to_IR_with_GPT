; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: In-place bottom-up merge sort of signed 32-bit integers (confidence=0.98). Evidence: 4-byte element size (shl by 2) and signed compare (jg).
; Preconditions: dest points to at least n 32-bit ints; if n <= 1, does nothing.
; Postconditions: If n > 1 and malloc succeeds, dest is sorted ascending; if malloc fails, dest remains unchanged.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  ; if (n <= 1) return;
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:
  ; bytes = n * 4
  %bytes = shl i64 %n, 2
  %tmp.i8 = call noalias i8* @malloc(i64 %bytes)
  %malloc.null = icmp eq i8* %tmp.i8, null
  br i1 %malloc.null, label %ret, label %init

init:
  %buf0 = bitcast i8* %tmp.i8 to i32*
  %src0 = %dest
  br label %outer.loop

outer.loop:
  ; phis for each pass
  %run = phi i64 [ 1, %init ], [ %run.next, %pass.end ]
  %src = phi i32* [ %src0, %init ], [ %buf, %pass.end ]
  %buf = phi i32* [ %buf0, %init ], [ %src, %pass.end ]
  ; while (run < n)
  %cont = icmp ult i64 %run, %n
  br i1 %cont, label %base.loop, label %after.passes

base.loop:
  ; for (base = 0; base < n; base += 2*run)
  %base = phi i64 [ 0, %outer.loop ], [ %base.next, %merged.done ]
  %base.lt.n = icmp ult i64 %base, %n
  br i1 %base.lt.n, label %compute.bounds, label %pass.end

compute.bounds:
  ; mid = min(base + run, n)
  %mid.cand = add i64 %base, %run
  %mid.sel = icmp ule i64 %mid.cand, %n
  %mid = select i1 %mid.sel, i64 %mid.cand, i64 %n
  ; end = min(base + 2*run, n)
  %two.run = add i64 %run, %run
  %end.cand = add i64 %base, %two.run
  %end.sel = icmp ule i64 %end.cand, %n
  %end = select i1 %end.sel, i64 %end.cand, i64 %n
  ; i = base, j = mid, out = base
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %base, %compute.bounds ], [ %i.next.l, %take.left ], [ %i, %take.right ]
  %j = phi i64 [ %mid,  %compute.bounds ], [ %j, %take.left ], [ %j.next.r, %take.right ]
  %out = phi i64 [ %base, %compute.bounds ], [ %out.next.l, %take.left ], [ %out.next.r, %take.right ]
  ; while (out < end)
  %out.lt.end = icmp ult i64 %out, %end
  br i1 %out.lt.end, label %choose, label %merged.done

choose:
  ; if (i < mid)
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %check.right, label %take.right

check.right:
  ; if (j < end) { compare src[i] and src[j] } else take.left
  %j.lt.end = icmp ult i64 %j, %end
  br i1 %j.lt.end, label %cmp.values, label %take.left

cmp.values:
  ; load src[i] and src[j] and compare signed
  %gep.li = getelementptr inbounds i32, i32* %src, i64 %i
  %li = load i32, i32* %gep.li, align 4
  %gep.rj = getelementptr inbounds i32, i32* %src, i64 %j
  %rj = load i32, i32* %gep.rj, align 4
  %li.gt.rj = icmp sgt i32 %li, %rj
  br i1 %li.gt.rj, label %take.right, label %take.left

take.left:
  ; buf[out] = src[i]; i++; out++
  %gep.src.l = getelementptr inbounds i32, i32* %src, i64 %i
  %val.l = load i32, i32* %gep.src.l, align 4
  %gep.buf.l = getelementptr inbounds i32, i32* %buf, i64 %out
  store i32 %val.l, i32* %gep.buf.l, align 4
  %i.next.l = add i64 %i, 1
  %out.next.l = add i64 %out, 1
  br label %merge.loop

take.right:
  ; buf[out] = src[j]; j++; out++
  %gep.src.r = getelementptr inbounds i32, i32* %src, i64 %j
  %val.r = load i32, i32* %gep.src.r, align 4
  %gep.buf.r = getelementptr inbounds i32, i32* %buf, i64 %out
  store i32 %val.r, i32* %gep.buf.r, align 4
  %j.next.r = add i64 %j, 1
  %out.next.r = add i64 %out, 1
  br label %merge.loop

merged.done:
  ; base += 2*run
  %base.next = add i64 %base, %two.run
  br label %base.loop

pass.end:
  ; swap src and buf; run <<= 1
  %run.next = shl i64 %run, 1
  br label %outer.loop

after.passes:
  ; if (src != dest) memcpy(dest, src, bytes)
  %src.eq.dest = icmp eq i32* %src, %dest
  br i1 %src.eq.dest, label %do.free, label %do.copy

do.copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src to i8*
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes)
  br label %do.free

do.free:
  call void @free(i8* %tmp.i8)
  br label %ret

ret:
  ret void
}
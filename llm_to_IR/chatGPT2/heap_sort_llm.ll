; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x401156
; Intent: in-place ascending heap sort of a 32-bit int array (confidence=0.94). Evidence: build max-heap using left=2root+1/right=left+1, pick larger child, sift-down, then swap a[0] with a[end] and shrink heap.
; Preconditions: %S.RDI holds the address of the first int element within %MEM; %S.RSI is the element count n. Memory at [%S.RDI, %S.RDI+4(n-1)] is valid and little-endian 32-bit ints.
; Postconditions: a[0..n-1] sorted nondecreasing; in-place; not stable. RIP is set to the caller’s return address and RSP += 8 on return.

%Regs = type {
  i64, i64, i64, i64, i64, i64, i64, i64,
  i64, i64, i64, i64, i64, i64, i64, i64,
  i64, i1, i1, i1, i1, i1, i1, i1
}

declare void @llvm.trap()

define dso_local void @heap_sort(i8* nocapture %MEM, %Regs* nocapture %S) local_unnamed_addr {
entry:
  ; load arguments: a (RDI), n (RSI)
  %RDI.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 5
  %RSI.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 4
  %a.addr = load i64, i64* %RDI.p, align 8
  %n = load i64, i64* %RSI.p, align 8

  ; if (n <= 1) return
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %prep

prep:
  ; materialize int* base inside %MEM
  %a.mem.i8 = getelementptr inbounds i8, i8* %MEM, i64 %a.addr
  %a.base = bitcast i8* %a.mem.i8 to i32*

  ; build max-heap: for (i = n>>1; i > 0; --i) siftDown(root=i-1, limit=n)
  %i.init = lshr i64 %n, 1
  br label %build.check

build.check:
  %i.cur = phi i64 [ %i.init, %prep ], [ %i.next, %build.next ]
  %has.more = icmp ne i64 %i.cur, 0
  br i1 %has.more, label %build.iter, label %build.done

build.iter:
  %root.start = add i64 %i.cur, -1
  br label %sift1.check

sift1.check:
  %root.1 = phi i64 [ %root.start, %build.iter ], [ %root.next, %sift1.swap ]
  %t0 = shl i64 %root.1, 1
  %left.1 = add i64 %t0, 1
  ; while (left < n) ...
  %left_ge_n = icmp uge i64 %left.1, %n
  br i1 %left_ge_n, label %build.next, label %sift1.have_left

sift1.have_left:
  %right.1 = add i64 %left.1, 1
  %right_lt_n = icmp ult i64 %right.1, %n
  br i1 %right_lt_n, label %sift1.choose.cmp, label %sift1.choose.left

sift1.choose.cmp:
  %pr1 = getelementptr inbounds i32, i32* %a.base, i64 %right.1
  %vr1 = load i32, i32* %pr1, align 4
  %pl1 = getelementptr inbounds i32, i32* %a.base, i64 %left.1
  %vl1 = load i32, i32* %pl1, align 4
  %rgtl1 = icmp sgt i32 %vr1, %vl1
  %swap.idx.sel1 = select i1 %rgtl1, i64 %right.1, i64 %left.1
  br label %sift1.compare

sift1.choose.left:
  br label %sift1.compare

sift1.compare:
  %swap.idx.1 = phi i64 [ %swap.idx.sel1, %sift1.choose.cmp ], [ %left.1, %sift1.choose.left ]
  %proot1 = getelementptr inbounds i32, i32* %a.base, i64 %root.1
  %vroot1 = load i32, i32* %proot1, align 4
  %ps1 = getelementptr inbounds i32, i32* %a.base, i64 %swap.idx.1
  %vs1 = load i32, i32* %ps1, align 4
  %root_lt_sw1 = icmp slt i32 %vroot1, %vs1
  br i1 %root_lt_sw1, label %sift1.swap, label %build.next

sift1.swap:
  ; SSA fix: define next root via phi (must be first in block)
  %root.next = phi i64 [ %swap.idx.1, %sift1.compare ]
  ; swap a[root] <-> a[swap_idx]
  store i32 %vs1, i32* %proot1, align 4
  store i32 %vroot1, i32* %ps1, align 4
  br label %sift1.check

build.next:
  %i.next = add i64 %i.cur, -1
  br label %build.check

; sorting phase
build.done:
  %end0 = add i64 %n, -1
  br label %phase2.loop

; Outer loop:
; do { swap(a[0], a[end]); siftDown(root=0, limit=end); --end; } while (end != 0);
phase2.loop:
  %end = phi i64 [ %end0, %build.done ], [ %end.dec, %after.sift2 ]
  ; swap a[0] and a[end]
  %p0 = getelementptr inbounds i32, i32* %a.base, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %a.base, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2.check

; Sift with inclusive end index: continue while left < end
sift2.check:
  %root2 = phi i64 [ 0, %phase2.loop ], [ %root2.next, %sift2.swap ]
  %t2 = shl i64 %root2, 1
  %left2 = add i64 %t2, 1
  %left_ge_end = icmp uge i64 %left2, %end
  br i1 %left_ge_end, label %after.sift2, label %s2.have_left

s2.have_left:
  %right2 = add i64 %left2, 1
  %right_lt_end = icmp ult i64 %right2, %end
  br i1 %right_lt_end, label %s2.choose.cmp, label %s2.choose.left

s2.choose.cmp:
  %pr2 = getelementptr inbounds i32, i32* %a.base, i64 %right2
  %vr2 = load i32, i32* %pr2, align 4
  %pl2 = getelementptr inbounds i32, i32* %a.base, i64 %left2
  %vl2 = load i32, i32* %pl2, align 4
  %rgtl2 = icmp sgt i32 %vr2, %vl2
  %swap.idx.sel2 = select i1 %rgtl2, i64 %right2, i64 %left2
  br label %sift2.compare

s2.choose.left:
  br label %sift2.compare

sift2.compare:
  %swap.idx2 = phi i64 [ %swap.idx.sel2, %s2.choose.cmp ], [ %left2, %s2.choose.left ]
  %proot2 = getelementptr inbounds i32, i32* %a.base, i64 %root2
  %vroot2 = load i32, i32* %proot2, align 4
  %ps2 = getelementptr inbounds i32, i32* %a.base, i64 %swap.idx2
  %vs2 = load i32, i32* %ps2, align 4
  %root_lt_sw2 = icmp slt i32 %vroot2, %vs2
  br i1 %root_lt_sw2, label %sift2.swap, label %after.sift2

sift2.swap:
  ; SSA fix: define next root via phi (must be first in block)
  %root2.next = phi i64 [ %swap.idx2, %sift2.compare ]
  store i32 %vs2, i32* %proot2, align 4
  store i32 %vroot2, i32* %ps2, align 4
  br label %sift2.check

after.sift2:
  %end.dec = add i64 %end, -1
  %more = icmp ne i64 %end.dec, 0
  br i1 %more, label %phase2.loop, label %ret

; standard x86-64 'ret' epilogue: RIP=[RSP], RSP+=8
ret:
  %RSP.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 7
  %rsp0 = load i64, i64* %RSP.p, align 8
  %retaddr.i8 = getelementptr inbounds i8, i8* %MEM, i64 %rsp0
  %retaddr.p = bitcast i8* %retaddr.i8 to i64*
  %retaddr = load i64, i64* %retaddr.p, align 8
  %RIP.p = getelementptr inbounds %Regs, %Regs* %S, i32 0, i32 16
  store i64 %retaddr, i64* %RIP.p, align 8
  %rsp1 = add i64 %rsp0, 8
  store i64 %rsp1, i64* %RSP.p, align 8
  ret void
}

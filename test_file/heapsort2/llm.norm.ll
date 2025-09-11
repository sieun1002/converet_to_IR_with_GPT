; ModuleID = 'cases/heapsort2/llm.ll'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

%Regs = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i1, i1, i1, i1, i1, i1, i1 }

define dso_local void @main(i8* nocapture %MEM, %Regs* nocapture %S) local_unnamed_addr {
entry:
  %RAX.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 0
  %RSI.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 4
  %RDI.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 5
  %RSP.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 7
  %RSP0 = load i64, i64* %RSP.p, align 8
  %arr.addr = add i64 %RSP0, -64
  %arr.base.i8 = getelementptr inbounds i8, i8* %MEM, i64 %arr.addr
  %arr.base = bitcast i8* %arr.base.i8 to i32*
  store i32 7, i32* %arr.base, align 4
  %p1 = getelementptr inbounds i8, i8* %arr.base.i8, i64 4
  %0 = bitcast i8* %p1 to i32*
  store i32 3, i32* %0, align 4
  %p2 = getelementptr inbounds i8, i8* %arr.base.i8, i64 8
  %1 = bitcast i8* %p2 to i32*
  store i32 9, i32* %1, align 4
  %p3 = getelementptr inbounds i8, i8* %arr.base.i8, i64 12
  %2 = bitcast i8* %p3 to i32*
  store i32 1, i32* %2, align 4
  %p4 = getelementptr inbounds i8, i8* %arr.base.i8, i64 16
  %3 = bitcast i8* %p4 to i32*
  store i32 4, i32* %3, align 4
  %p5 = getelementptr inbounds i8, i8* %arr.base.i8, i64 20
  %4 = bitcast i8* %p5 to i32*
  store i32 8, i32* %4, align 4
  %p6 = getelementptr inbounds i8, i8* %arr.base.i8, i64 24
  %5 = bitcast i8* %p6 to i32*
  store i32 2, i32* %5, align 4
  %p7 = getelementptr inbounds i8, i8* %arr.base.i8, i64 28
  %6 = bitcast i8* %p7 to i32*
  store i32 6, i32* %6, align 4
  %p8 = getelementptr inbounds i8, i8* %arr.base.i8, i64 32
  %7 = bitcast i8* %p8 to i32*
  store i32 5, i32* %7, align 4
  store i64 0, i64* %RAX.p, align 8
  store i64 4202500, i64* %RDI.p, align 8
  call void @_printf(i8* %MEM, %Regs* %S)
  br label %print1.loop

print1.loop:                                      ; preds = %print1.body, %entry
  %i0 = phi i64 [ 0, %entry ], [ %i0.next, %print1.body ]
  %cond0 = icmp ult i64 %i0, 9
  br i1 %cond0, label %print1.body, label %after.print1

print1.body:                                      ; preds = %print1.loop
  %elem.ptr0 = getelementptr inbounds i32, i32* %arr.base, i64 %i0
  %elem0 = load i32, i32* %elem.ptr0, align 4
  %elem0.sext = sext i32 %elem0 to i64
  store i64 0, i64* %RAX.p, align 8
  store i64 4202509, i64* %RDI.p, align 8
  store i64 %elem0.sext, i64* %RSI.p, align 8
  call void @_printf(i8* %MEM, %Regs* %S)
  %i0.next = add i64 %i0, 1
  br label %print1.loop

after.print1:                                     ; preds = %print1.loop
  store i64 10, i64* %RDI.p, align 8
  call void @_putchar(i8* %MEM, %Regs* %S)
  store i64 %arr.addr, i64* %RDI.p, align 8
  store i64 9, i64* %RSI.p, align 8
  call void @heap_sort(i8* %MEM, %Regs* %S)
  store i64 0, i64* %RAX.p, align 8
  store i64 4202513, i64* %RDI.p, align 8
  call void @_printf(i8* %MEM, %Regs* %S)
  br label %print2.loop

print2.loop:                                      ; preds = %print2.body, %after.print1
  %i1 = phi i64 [ 0, %after.print1 ], [ %i1.next, %print2.body ]
  %cond1 = icmp ult i64 %i1, 9
  br i1 %cond1, label %print2.body, label %after.print2

print2.body:                                      ; preds = %print2.loop
  %elem.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %i1
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %elem1.sext = sext i32 %elem1 to i64
  store i64 0, i64* %RAX.p, align 8
  store i64 4202509, i64* %RDI.p, align 8
  store i64 %elem1.sext, i64* %RSI.p, align 8
  call void @_printf(i8* %MEM, %Regs* %S)
  %i1.next = add i64 %i1, 1
  br label %print2.loop

after.print2:                                     ; preds = %print2.loop
  store i64 10, i64* %RDI.p, align 8
  call void @_putchar(i8* %MEM, %Regs* %S)
  store i64 0, i64* %RAX.p, align 8
  %RSP.now = load i64, i64* %RSP.p, align 8
  %retaddr.i8 = getelementptr inbounds i8, i8* %MEM, i64 %RSP.now
  %retaddr.p = bitcast i8* %retaddr.i8 to i64*
  %retaddr = load i64, i64* %retaddr.p, align 8
  %RIP.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 16
  store i64 %retaddr, i64* %RIP.p, align 8
  %RSP.next = add i64 %RSP.now, 8
  store i64 %RSP.next, i64* %RSP.p, align 8
  ret void
}

declare dso_local void @_printf(i8* nocapture, %Regs* nocapture) local_unnamed_addr

declare dso_local void @_putchar(i8* nocapture, %Regs* nocapture) local_unnamed_addr

define dso_local void @heap_sort(i8* nocapture %MEM, %Regs* nocapture %S) local_unnamed_addr {
entry:
  %RSI.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 4
  %n = load i64, i64* %RSI.p, align 8
  %n_le1 = icmp ult i64 %n, 2
  br i1 %n_le1, label %ret, label %prep

prep:                                             ; preds = %entry
  %RDI.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 5
  %a.addr = load i64, i64* %RDI.p, align 8
  %a.mem.i8 = getelementptr inbounds i8, i8* %MEM, i64 %a.addr
  %a.base = bitcast i8* %a.mem.i8 to i32*
  %i.init = lshr i64 %n, 1
  br label %build.check

build.check:                                      ; preds = %build.next, %prep
  %i.cur = phi i64 [ %i.init, %prep ], [ %root.start, %build.next ]
  %has.more.not = icmp eq i64 %i.cur, 0
  br i1 %has.more.not, label %build.done, label %build.iter

build.iter:                                       ; preds = %build.check
  %root.start = add i64 %i.cur, -1
  br label %sift1.check

sift1.check:                                      ; preds = %sift1.swap, %build.iter
  %root.1 = phi i64 [ %root.start, %build.iter ], [ %swap.idx.1, %sift1.swap ]
  %t0 = shl i64 %root.1, 1
  %left.1 = or i64 %t0, 1
  %left_ge_n.not = icmp ult i64 %left.1, %n
  br i1 %left_ge_n.not, label %sift1.have_left, label %build.next

sift1.have_left:                                  ; preds = %sift1.check
  %right.1 = add i64 %t0, 2
  %right_lt_n = icmp ult i64 %right.1, %n
  br i1 %right_lt_n, label %sift1.choose.cmp, label %sift1.compare

sift1.choose.cmp:                                 ; preds = %sift1.have_left
  %pr1 = getelementptr inbounds i32, i32* %a.base, i64 %right.1
  %vr1 = load i32, i32* %pr1, align 4
  %pl1 = getelementptr inbounds i32, i32* %a.base, i64 %left.1
  %vl1 = load i32, i32* %pl1, align 4
  %rgtl1 = icmp sgt i32 %vr1, %vl1
  %swap.idx.sel1 = select i1 %rgtl1, i64 %right.1, i64 %left.1
  br label %sift1.compare

sift1.compare:                                    ; preds = %sift1.have_left, %sift1.choose.cmp
  %swap.idx.1 = phi i64 [ %swap.idx.sel1, %sift1.choose.cmp ], [ %left.1, %sift1.have_left ]
  %proot1 = getelementptr inbounds i32, i32* %a.base, i64 %root.1
  %vroot1 = load i32, i32* %proot1, align 4
  %ps1 = getelementptr inbounds i32, i32* %a.base, i64 %swap.idx.1
  %vs1 = load i32, i32* %ps1, align 4
  %root_lt_sw1 = icmp slt i32 %vroot1, %vs1
  br i1 %root_lt_sw1, label %sift1.swap, label %build.next

sift1.swap:                                       ; preds = %sift1.compare
  store i32 %vs1, i32* %proot1, align 4
  store i32 %vroot1, i32* %ps1, align 4
  br label %sift1.check

build.next:                                       ; preds = %sift1.compare, %sift1.check
  br label %build.check

build.done:                                       ; preds = %build.check
  %end0 = add i64 %n, -1
  br label %phase2.loop

phase2.loop:                                      ; preds = %after.sift2, %build.done
  %end = phi i64 [ %end0, %build.done ], [ %end.dec, %after.sift2 ]
  %v0 = load i32, i32* %a.base, align 4
  %pend = getelementptr inbounds i32, i32* %a.base, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %a.base, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2.check

sift2.check:                                      ; preds = %sift2.swap, %phase2.loop
  %root2 = phi i64 [ 0, %phase2.loop ], [ %swap.idx2, %sift2.swap ]
  %t2 = shl i64 %root2, 1
  %left2 = or i64 %t2, 1
  %left_ge_end.not = icmp ult i64 %left2, %end
  br i1 %left_ge_end.not, label %s2.have_left, label %after.sift2

s2.have_left:                                     ; preds = %sift2.check
  %right2 = add i64 %t2, 2
  %right_lt_end = icmp ult i64 %right2, %end
  br i1 %right_lt_end, label %s2.choose.cmp, label %sift2.compare

s2.choose.cmp:                                    ; preds = %s2.have_left
  %pr2 = getelementptr inbounds i32, i32* %a.base, i64 %right2
  %vr2 = load i32, i32* %pr2, align 4
  %pl2 = getelementptr inbounds i32, i32* %a.base, i64 %left2
  %vl2 = load i32, i32* %pl2, align 4
  %rgtl2 = icmp sgt i32 %vr2, %vl2
  %swap.idx.sel2 = select i1 %rgtl2, i64 %right2, i64 %left2
  br label %sift2.compare

sift2.compare:                                    ; preds = %s2.have_left, %s2.choose.cmp
  %swap.idx2 = phi i64 [ %swap.idx.sel2, %s2.choose.cmp ], [ %left2, %s2.have_left ]
  %proot2 = getelementptr inbounds i32, i32* %a.base, i64 %root2
  %vroot2 = load i32, i32* %proot2, align 4
  %ps2 = getelementptr inbounds i32, i32* %a.base, i64 %swap.idx2
  %vs2 = load i32, i32* %ps2, align 4
  %root_lt_sw2 = icmp slt i32 %vroot2, %vs2
  br i1 %root_lt_sw2, label %sift2.swap, label %after.sift2

sift2.swap:                                       ; preds = %sift2.compare
  store i32 %vs2, i32* %proot2, align 4
  store i32 %vroot2, i32* %ps2, align 4
  br label %sift2.check

after.sift2:                                      ; preds = %sift2.compare, %sift2.check
  %end.dec = add i64 %end, -1
  %more.not = icmp eq i64 %end.dec, 0
  br i1 %more.not, label %ret, label %phase2.loop

ret:                                              ; preds = %after.sift2, %entry
  %RSP.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 7
  %rsp0 = load i64, i64* %RSP.p, align 8
  %retaddr.i8 = getelementptr inbounds i8, i8* %MEM, i64 %rsp0
  %retaddr.p = bitcast i8* %retaddr.i8 to i64*
  %retaddr = load i64, i64* %retaddr.p, align 8
  %RIP.p = getelementptr inbounds %Regs, %Regs* %S, i64 0, i32 16
  store i64 %retaddr, i64* %RIP.p, align 8
  %rsp1 = add i64 %rsp0, 8
  store i64 %rsp1, i64* %RSP.p, align 8
  ret void
}

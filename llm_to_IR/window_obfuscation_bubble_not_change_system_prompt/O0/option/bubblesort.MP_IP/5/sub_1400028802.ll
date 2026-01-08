; ModuleID = 'sub_140002880.ll'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8
@loc_14000272D = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define dso_local i32 @sub_140002880() {
entry:
  call void @sub_140001520()

  %arr = alloca [10 x i32], align 16
  %arr.vec0.ptr = bitcast [10 x i32]* %arr to <4 x i32>*
  %g1 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  store <4 x i32> %g1, <4 x i32>* %arr.vec0.ptr, align 16

  %arr.idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr.vec1.ptr = bitcast i32* %arr.idx4 to <4 x i32>*
  %g2 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  store <4 x i32> %g2, <4 x i32>* %arr.vec1.ptr, align 16

  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4

  %base.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %outer.start

outer.start:                                      ; preds = %entry, %outer.iter
  %r9.phi = phi i64 [ 10, %entry ], [ %r9.next, %outer.iter ]
  %rax.init = add i64 0, 1
  %rdx.init = ptrtoint i32* %base.ptr to i64
  %rdx.init.ptr = inttoptr i64 %rdx.init to i32*
  %r10.init = add i64 0, 0
  br label %inner.loop

inner.loop:                                       ; preds = %outer.start, %inner.latch
  %rax.phi = phi i64 [ %rax.init, %outer.start ], [ %rax.next, %inner.latch ]
  %rdx.phi = phi i32* [ %rdx.init.ptr, %outer.start ], [ %rdx.next, %inner.latch ]
  %r10.carry = phi i64 [ %r10.init, %outer.start ], [ %r10.upd, %inner.latch ]

  %a = load i32, i32* %rdx.phi, align 4
  %b.ptr = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %b = load i32, i32* %b.ptr, align 4
  %cmp.ge = icmp sge i32 %b, %a
  br i1 %cmp.ge, label %noswap, label %doswap

doswap:                                           ; preds = %inner.loop
  store i32 %b, i32* %rdx.phi, align 4
  store i32 %a, i32* %b.ptr, align 4
  br label %inner.latch

noswap:                                           ; preds = %inner.loop
  br label %inner.latch

inner.latch:                                      ; preds = %noswap, %doswap
  %r10.upd = phi i64 [ %rax.phi, %doswap ], [ %r10.carry, %noswap ]
  %rax.next = add i64 %rax.phi, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %cont = icmp ne i64 %rax.next, %r9.phi
  br i1 %cont, label %inner.loop, label %outer.cont

outer.cont:                                       ; preds = %inner.latch
  %r10.cmp = icmp ugt i64 %r10.upd, 1
  br i1 %r10.cmp, label %outer.iter, label %after.sort

outer.iter:                                       ; preds = %outer.cont
  %r9.next = add i64 %r10.upd, 0
  br label %outer.start

after.sort:                                       ; preds = %outer.cont
  %end.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  %it.start = add i64 0, 0
  %it.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 %it.start
  br label %print.loop

print.loop:                                       ; preds = %after.sort, %print.call
  %p.cur = phi i32* [ %it.ptr, %after.sort ], [ %p.next, %print.call ]
  %done = icmp eq i32* %p.cur, %end.ptr
  br i1 %done, label %after.print, label %print.call

print.call:                                       ; preds = %print.loop
  %val = load i32, i32* %p.cur, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  br label %print.loop

after.print:                                      ; preds = %print.loop
  %loc.plus3 = getelementptr inbounds i8, i8* @loc_14000272D, i64 3
  %fp = bitcast i8* %loc.plus3 to void ()*
  call void %fp()
  ret i32 0
}
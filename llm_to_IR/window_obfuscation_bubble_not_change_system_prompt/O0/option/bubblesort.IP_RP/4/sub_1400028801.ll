; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global [16 x i8]
@xmmword_140004020 = external global [16 x i8]
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define void @sub_140002880() {
entry:
  call void @sub_140001520()
  %arr = alloca [10 x i32], align 4
  %arr.vec0 = bitcast [10 x i32]* %arr to <4 x i32>*
  %g1.vec.ptr = bitcast [16 x i8]* @xmmword_140004010 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* %g1.vec.ptr, align 1
  store <4 x i32> %v1, <4 x i32>* %arr.vec0, align 4
  %arr.vec1 = getelementptr inbounds <4 x i32>, <4 x i32>* %arr.vec0, i64 1
  %g2.vec.ptr = bitcast [16 x i8]* @xmmword_140004020 to <4 x i32>*
  %v2 = load <4 x i32>, <4 x i32>* %g2.vec.ptr, align 1
  store <4 x i32> %v2, <4 x i32>* %arr.vec1, align 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %outer

outer:                                            ; preds = %entry, %after_inner
  %r9.phi = phi i32 [ 10, %entry ], [ %r10.phi, %after_inner ]
  br label %inner

inner:                                            ; preds = %outer, %inner.next
  %rax.phi = phi i32 [ 1, %outer ], [ %rax.next, %inner.next ]
  %p.phi = phi i32* [ %arr.base, %outer ], [ %p.next, %inner.next ]
  %r10.phi = phi i32 [ 0, %outer ], [ %r10.upd, %inner.next ]
  %cmp.enter = icmp eq i32 %rax.phi, %r9.phi
  br i1 %cmp.enter, label %after_inner, label %inner.body

inner.body:                                       ; preds = %inner
  %lhs = load i32, i32* %p.phi, align 4
  %p.plus1 = getelementptr inbounds i32, i32* %p.phi, i64 1
  %rhs = load i32, i32* %p.plus1, align 4
  %cmp.sge = icmp sge i32 %rhs, %lhs
  br i1 %cmp.sge, label %no.swap, label %do.swap

do.swap:                                          ; preds = %inner.body
  store i32 %rhs, i32* %p.phi, align 4
  store i32 %lhs, i32* %p.plus1, align 4
  br label %after.swap

no.swap:                                          ; preds = %inner.body
  br label %after.swap

after.swap:                                       ; preds = %no.swap, %do.swap
  %r10.sel = phi i32 [ %rax.phi, %do.swap ], [ %r10.phi, %no.swap ]
  %rax.next = add i32 %rax.phi, 1
  %p.next = getelementptr inbounds i32, i32* %p.phi, i64 1
  br label %inner.next

inner.next:                                       ; preds = %after.swap
  %r10.upd = phi i32 [ %r10.sel, %after.swap ]
  br label %inner

after_inner:                                      ; preds = %inner
  %cmp.r10.le1 = icmp ule i32 %r10.phi, 1
  br i1 %cmp.r10.le1, label %after.sort, label %outer

after.sort:                                       ; preds = %after_inner
  %rsi.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  %first = load i32, i32* %arr.base, align 4
  %rcx.ptr = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  call void @sub_1400025A0(i8* %rcx.ptr, i32 %first)
  ret void
}
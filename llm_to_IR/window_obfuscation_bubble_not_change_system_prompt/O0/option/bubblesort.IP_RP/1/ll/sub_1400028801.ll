; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global [16 x i8], align 16
@xmmword_140004020 = external global [16 x i8], align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define void @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  call void @sub_140001520()
  %g0.p0 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_140004010, i64 0, i64 0
  %g0.vp = bitcast i8* %g0.p0 to <16 x i8>*
  %v0 = load <16 x i8>, <16 x i8>* %g0.vp, align 16
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %dst0.vp = bitcast i8* %arr.i8 to <16 x i8>*
  store <16 x i8> %v0, <16 x i8>* %dst0.vp, align 16
  %g1.p0 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_140004020, i64 0, i64 0
  %g1.vp = bitcast i8* %g1.p0 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* %g1.vp, align 16
  %dst1.i8 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %dst1.vp = bitcast i8* %dst1.i8 to <16 x i8>*
  store <16 x i8> %v1, <16 x i8>* %dst1.vp, align 16
  %elem8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elem8ptr, align 4
  store i64 10, i64* %len, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %outer.setup

outer.setup:                                      ; preds = %outer.cont, %entry
  %rdx.start = phi i32* [ %arr.base, %entry ], [ %arr.base, %outer.cont ]
  br label %inner

inner:                                            ; preds = %after.cmp, %outer.setup
  %rax.phi = phi i64 [ 1, %outer.setup ], [ %rax.next, %after.cmp ]
  %rdx.phi = phi i32* [ %rdx.start, %outer.setup ], [ %rdx.next, %after.cmp ]
  %r10.phi = phi i64 [ 0, %outer.setup ], [ %r10.sel, %after.cmp ]
  %a = load i32, i32* %rdx.phi, align 4
  %rdx.next.i32ptr = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %b = load i32, i32* %rdx.next.i32ptr, align 4
  %cmp.swap = icmp slt i32 %b, %a
  br i1 %cmp.swap, label %do.swap, label %no.swap

do.swap:                                          ; preds = %inner
  store i32 %b, i32* %rdx.phi, align 4
  store i32 %a, i32* %rdx.next.i32ptr, align 4
  br label %after.cmp

no.swap:                                          ; preds = %inner
  br label %after.cmp

after.cmp:                                        ; preds = %no.swap, %do.swap
  %r10.sel = phi i64 [ %rax.phi, %do.swap ], [ %r10.phi, %no.swap ]
  %rax.next = add i64 %rax.phi, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %r9.cur = load i64, i64* %len, align 8
  %inner.cond = icmp ne i64 %rax.next, %r9.cur
  br i1 %inner.cond, label %inner, label %after.inner

after.inner:                                      ; preds = %after.cmp
  %r10.final = add i64 %r10.sel, 0
  %r10.le1 = icmp ule i64 %r10.final, 1
  br i1 %r10.le1, label %after.loops, label %outer.cont

outer.cont:                                       ; preds = %after.inner
  store i64 %r10.final, i64* %len, align 8
  br label %outer.setup

after.loops:                                      ; preds = %after.inner
  %rsi.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  %first.val = load i32, i32* %arr.base, align 4
  %rbx.inc = getelementptr inbounds i32, i32* %arr.base, i64 1
  call void @sub_1400025A0(i8* @unk_140004000, i32 %first.val)
  ret void
}
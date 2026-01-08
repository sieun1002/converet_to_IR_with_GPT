; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global [16 x i8], align 16
@xmmword_140004020 = external global [16 x i8], align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define void @sub_140002880() {
entry:
  %arr = alloca [40 x i8], align 16
  %var20 = alloca [8 x i8], align 8
  call void @sub_140001520()
  %arr.i8 = bitcast [40 x i8]* %arr to i8*
  %g1.i8 = bitcast [16 x i8]* @xmmword_140004010 to i8*
  %g1.i64p = bitcast i8* %g1.i8 to i64*
  %v1.lo = load i64, i64* %g1.i64p, align 1
  %g1.i64p.hi = getelementptr i64, i64* %g1.i64p, i64 1
  %v1.hi = load i64, i64* %g1.i64p.hi, align 1
  %arr.i64p = bitcast i8* %arr.i8 to i64*
  store i64 %v1.lo, i64* %arr.i64p, align 1
  %arr.i64p.1 = getelementptr i64, i64* %arr.i64p, i64 1
  store i64 %v1.hi, i64* %arr.i64p.1, align 1
  %g2.i8 = bitcast [16 x i8]* @xmmword_140004020 to i8*
  %g2.i64p = bitcast i8* %g2.i8 to i64*
  %v2.lo = load i64, i64* %g2.i64p, align 1
  %g2.i64p.hi = getelementptr i64, i64* %g2.i64p, i64 1
  %v2.hi = load i64, i64* %g2.i64p.hi, align 1
  %arr.off16 = getelementptr i8, i8* %arr.i8, i64 16
  %arr.off16.i64p = bitcast i8* %arr.off16 to i64*
  store i64 %v2.lo, i64* %arr.off16.i64p, align 1
  %arr.off24.i64p = getelementptr i64, i64* %arr.off16.i64p, i64 1
  store i64 %v2.hi, i64* %arr.off24.i64p, align 1
  %arr.i32p = bitcast i8* %arr.i8 to i32*
  %elem8.p = getelementptr i32, i32* %arr.i32p, i64 8
  store i32 4, i32* %elem8.p, align 1
  br label %outer

outer:                                            ; preds = %outer.back, %entry
  %r9.cur = phi i64 [ 10, %entry ], [ %r9.next, %outer.back ]
  br label %inner

inner:                                            ; preds = %inner.cont, %outer
  %rax = phi i64 [ 1, %outer ], [ %rax.next, %inner.cont ]
  %rdx = phi i8* [ %arr.i8, %outer ], [ %rdx.next, %inner.cont ]
  %r10 = phi i64 [ 0, %outer ], [ %r10.new, %inner.cont ]
  %rdx.i32p = bitcast i8* %rdx to i32*
  %a = load i32, i32* %rdx.i32p, align 1
  %b.p = getelementptr i32, i32* %rdx.i32p, i64 1
  %b = load i32, i32* %b.p, align 1
  %cmp.ge = icmp sge i32 %b, %a
  br i1 %cmp.ge, label %no.swap, label %do.swap

do.swap:                                          ; preds = %inner
  store i32 %b, i32* %rdx.i32p, align 1
  store i32 %a, i32* %b.p, align 1
  br label %inner.cont

no.swap:                                          ; preds = %inner
  br label %inner.cont

inner.cont:                                       ; preds = %no.swap, %do.swap
  %r10.new = phi i64 [ %rax, %do.swap ], [ %r10, %no.swap ]
  %rax.next = add i64 %rax, 1
  %rdx.next = getelementptr i8, i8* %rdx, i64 4
  %cmp.ne = icmp ne i64 %rax.next, %r9.cur
  br i1 %cmp.ne, label %inner, label %after.inner

after.inner:                                      ; preds = %inner.cont
  %cmp.r10 = icmp ule i64 %r10.new, 1
  br i1 %cmp.r10, label %final, label %outer.back

outer.back:                                       ; preds = %after.inner
  %r9.next = phi i64 [ %r10.new, %after.inner ]
  br label %outer

final:                                            ; preds = %after.inner
  %rsi.ptr = getelementptr [8 x i8], [8 x i8]* %var20, i64 0, i64 0
  %base.i32p = bitcast i8* %arr.i8 to i32*
  %first = load i32, i32* %base.i32p, align 1
  %rbx.plus4 = getelementptr i8, i8* %arr.i8, i64 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %first)
  ret void
}
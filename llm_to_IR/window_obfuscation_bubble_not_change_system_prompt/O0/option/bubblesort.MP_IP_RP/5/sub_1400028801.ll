; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <16 x i8>, align 16
@xmmword_140004020 = external global <16 x i8>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define void @sub_140002880() {
entry:
  %arr = alloca [40 x i8], align 16
  %arr_i8 = bitcast [40 x i8]* %arr to i8*
  call void @sub_140001520()
  %g1 = load <16 x i8>, <16 x i8>* @xmmword_140004010, align 1
  %p0.v = bitcast [40 x i8]* %arr to <16 x i8>*
  store <16 x i8> %g1, <16 x i8>* %p0.v, align 1
  %g2 = load <16 x i8>, <16 x i8>* @xmmword_140004020, align 1
  %p16_i8 = getelementptr inbounds i8, i8* %arr_i8, i64 16
  %p16.v = bitcast i8* %p16_i8 to <16 x i8>*
  store <16 x i8> %g2, <16 x i8>* %p16.v, align 1
  %p32_i8 = getelementptr inbounds i8, i8* %arr_i8, i64 32
  %p32_i32 = bitcast i8* %p32_i8 to i32*
  store i32 4, i32* %p32_i32, align 4
  br label %outer.header

outer.header:                                     ; preds = %outer.loopend, %entry
  %r9.phi = phi i64 [ 10, %entry ], [ %r9.next, %outer.loopend ]
  br label %inner.loop

inner.loop:                                       ; preds = %inner.iter, %outer.header
  %i.phi = phi i64 [ 1, %outer.header ], [ %i.next, %inner.iter ]
  %rdx.phi = phi i8* [ %arr_i8, %outer.header ], [ %rdx.next, %inner.iter ]
  %lastSwap.phi = phi i64 [ 0, %outer.header ], [ %lastSwap.next, %inner.iter ]
  %rdx64 = bitcast i8* %rdx.phi to i64*
  %q = load i64, i64* %rdx64, align 1
  %low32.tr = trunc i64 %q to i32
  %highshift = lshr i64 %q, 32
  %high32.tr = trunc i64 %highshift to i32
  %cmp = icmp sge i32 %high32.tr, %low32.tr
  br i1 %cmp, label %noswap, label %doswap

doswap:                                           ; preds = %inner.loop
  %lowz = zext i32 %low32.tr to i64
  %highz = zext i32 %high32.tr to i64
  %lowz.shl = shl i64 %lowz, 32
  %newq = or i64 %lowz.shl, %highz
  store i64 %newq, i64* %rdx64, align 1
  br label %aftercmp

noswap:                                           ; preds = %inner.loop
  br label %aftercmp

aftercmp:                                         ; preds = %noswap, %doswap
  %lastSwap.next = phi i64 [ %i.phi, %doswap ], [ %lastSwap.phi, %noswap ]
  %i.next = add i64 %i.phi, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.phi, i64 4
  %cont = icmp ne i64 %i.next, %r9.phi
  br i1 %cont, label %inner.iter, label %inner.end

inner.iter:                                       ; preds = %aftercmp
  br label %inner.loop

inner.end:                                        ; preds = %aftercmp
  %r10 = add i64 %lastSwap.next, 0
  %exit = icmp ule i64 %r10, 1
  br i1 %exit, label %outer.done, label %outer.loopend

outer.loopend:                                    ; preds = %inner.end
  %r9.next = add i64 %r10, 0
  br label %outer.header

outer.done:                                       ; preds = %inner.end
  %rsi.ptr = getelementptr inbounds i8, i8* %arr_i8, i64 40
  %rbx.base.i32 = bitcast i8* %arr_i8 to i32*
  %first = load i32, i32* %rbx.base.i32, align 4
  %rbx.plus4 = getelementptr inbounds i8, i8* %arr_i8, i64 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %first)
  ret void
}
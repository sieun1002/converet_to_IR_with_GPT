target triple = "x86_64-pc-windows-msvc"

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

@xmmword_140004010 = external global <16 x i8>
@xmmword_140004020 = external global <16 x i8>
@unk_140004000 = external global i8

define void @sub_140002880() local_unnamed_addr {
entry:
  %var_48 = alloca [16 x i8], align 16
  %var_38 = alloca [16 x i8], align 16
  %var_28 = alloca i32, align 4
  %var_20 = alloca [8 x i8], align 8
  call void @sub_140001520()
  %g1 = load <16 x i8>, <16 x i8>* @xmmword_140004010, align 1
  %var_48.vecptr = bitcast [16 x i8]* %var_48 to <16 x i8>*
  store <16 x i8> %g1, <16 x i8>* %var_48.vecptr, align 1
  store i32 4, i32* %var_28, align 4
  %g2 = load <16 x i8>, <16 x i8>* @xmmword_140004020, align 1
  %var_38.vecptr = bitcast [16 x i8]* %var_38 to <16 x i8>*
  store <16 x i8> %g2, <16 x i8>* %var_38.vecptr, align 1
  %rbx.base = getelementptr inbounds [16 x i8], [16 x i8]* %var_48, i64 0, i64 0
  br label %outer

outer:                                            ; 0x1400028C0
  %r9 = phi i64 [ 10, %entry ], [ %r10.fin, %reduce ]
  br label %inner

inner:                                            ; 0x140002900
  %rax.i = phi i64 [ 1, %outer ], [ %rax.next, %cont ]
  %rdx.i = phi i8* [ %rbx.base, %outer ], [ %rdx.next, %cont ]
  %r10.i = phi i64 [ 0, %outer ], [ %r10.next, %cont ]
  %ld.ptr = bitcast i8* %rdx.i to i64*
  %q = load i64, i64* %ld.ptr, align 1
  %v2 = bitcast i64 %q to <2 x i32>
  %V4 = shufflevector <2 x i32> %v2, <2 x i32> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %W = shufflevector <4 x i32> %V4, <4 x i32> %V4, <4 x i32> <i32 1, i32 1, i32 2, i32 3>
  %ecx.val = extractelement <4 x i32> %V4, i32 0
  %r8.val = extractelement <4 x i32> %W, i32 0
  %cmp.ge = icmp sge i32 %r8.val, %ecx.val
  br i1 %cmp.ge, label %no_swap, label %do_swap

no_swap:
  br label %cont

do_swap:
  %S = shufflevector <4 x i32> %V4, <4 x i32> %V4, <4 x i32> <i32 1, i32 0, i32 2, i32 3>
  %S.lo = shufflevector <4 x i32> %S, <4 x i32> %S, <2 x i32> <i32 0, i32 1>
  %i64.swapped = bitcast <2 x i32> %S.lo to i64
  store i64 %i64.swapped, i64* %ld.ptr, align 1
  br label %cont

cont:
  %r10.next = phi i64 [ %r10.i, %no_swap ], [ %rax.i, %do_swap ]
  %rax.next = add i64 %rax.i, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.i, i64 4
  %cmp.ne = icmp ne i64 %rax.next, %r9
  br i1 %cmp.ne, label %inner, label %after_inner

after_inner:
  %r10.fin = add i64 %r10.next, 0
  %cmp.jbe = icmp ule i64 %r10.fin, 1
  br i1 %cmp.jbe, label %print_prep, label %reduce

reduce:
  br label %outer

print_prep:                                       ; 0x14000293B
  %rsi.addr = getelementptr inbounds [8 x i8], [8 x i8]* %var_20, i64 0, i64 0
  %rbx.i32ptr = bitcast i8* %rbx.base to i32*
  %edx.load = load i32, i32* %rbx.i32ptr, align 4
  %rbx.plus4 = getelementptr inbounds i8, i8* %rbx.base, i64 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %edx.load)
  ret void
}
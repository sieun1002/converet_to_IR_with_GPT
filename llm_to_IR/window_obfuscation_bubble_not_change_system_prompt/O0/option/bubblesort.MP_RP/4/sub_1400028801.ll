; ModuleID = 'sub_140002880.ll'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external constant [16 x i8]
@xmmword_140004020 = external constant [16 x i8]
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @sub_140002730(i32)

define i32 @sub_140002880() {
entry:
  call void @sub_140001520()
  %arr = alloca [10 x i32], align 16
  %arr_i8 = bitcast [10 x i32]* %arr to i8*
  %g0vptr = bitcast [16 x i8]* @xmmword_140004010 to <16 x i8>*
  %v0 = load <16 x i8>, <16 x i8>* %g0vptr, align 1
  %arr_vptr0 = bitcast i8* %arr_i8 to <16 x i8>*
  store <16 x i8> %v0, <16 x i8>* %arr_vptr0, align 1
  %g1vptr = bitcast [16 x i8]* @xmmword_140004020 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* %g1vptr, align 1
  %arr_off16 = getelementptr inbounds i8, i8* %arr_i8, i64 16
  %arr_vptr16 = bitcast i8* %arr_off16 to <16 x i8>*
  store <16 x i8> %v1, <16 x i8>* %arr_vptr16, align 1
  %idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 4
  br label %outer.header

outer.header:                                       ; preds = %outer.loopback, %entry
  %r9 = phi i64 [ 10, %entry ], [ %r10_exit, %outer.loopback ]
  br label %inner.loop

inner.loop:                                         ; preds = %inner.cont, %outer.header
  %rax = phi i64 [ 1, %outer.header ], [ %rax_next, %inner.cont ]
  %rdx = phi i8* [ %arr_i8, %outer.header ], [ %rdx_next, %inner.cont ]
  %r10 = phi i64 [ 0, %outer.header ], [ %r10_next, %inner.cont ]
  %rdx_i64ptr = bitcast i8* %rdx to i64*
  %q = load i64, i64* %rdx_i64ptr, align 1
  %lo32_tr = trunc i64 %q to i32
  %q_shr = lshr i64 %q, 32
  %hi32_tr = trunc i64 %q_shr to i32
  %cmp_noswap = icmp sge i32 %hi32_tr, %lo32_tr
  br i1 %cmp_noswap, label %no_swap, label %do_swap

no_swap:                                            ; preds = %inner.loop
  %r10_keep = add i64 %r10, 0
  br label %after_swap

do_swap:                                            ; preds = %inner.loop
  %lo_z = zext i32 %lo32_tr to i64
  %hi_z = zext i32 %hi32_tr to i64
  %lo_shl = shl i64 %lo_z, 32
  %swapped = or i64 %hi_z, %lo_shl
  store i64 %swapped, i64* %rdx_i64ptr, align 1
  br label %after_swap

after_swap:                                         ; preds = %do_swap, %no_swap
  %r10_new = phi i64 [ %rax, %do_swap ], [ %r10_keep, %no_swap ]
  %rax_next = add i64 %rax, 1
  %rdx_next = getelementptr inbounds i8, i8* %rdx, i64 4
  %r10_next = add i64 %r10_new, 0
  %cont = icmp ne i64 %rax_next, %r9
  br i1 %cont, label %inner.cont, label %after.inner

inner.cont:                                         ; preds = %after_swap
  br label %inner.loop

after.inner:                                        ; preds = %after_swap
  %r10_exit = add i64 %r10_next, 0
  %break_cond = icmp ule i64 %r10_exit, 1
  br i1 %break_cond, label %print.init, label %outer.loopback

outer.loopback:                                     ; preds = %after.inner
  br label %outer.header

print.init:                                         ; preds = %after.inner
  %endptr = getelementptr inbounds i8, i8* %arr_i8, i64 40
  br label %print.loop

print.loop:                                         ; preds = %print.loop, %print.init
  %rbx_cur = phi i8* [ %arr_i8, %print.init ], [ %rbx_next2, %print.loop ]
  %rbx_i32ptr = bitcast i8* %rbx_cur to i32*
  %val = load i32, i32* %rbx_i32ptr, align 4
  %fmtptr = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  call void @sub_1400025A0(i8* %fmtptr, i32 %val)
  %rbx_next2 = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %more = icmp ne i8* %rbx_next2, %endptr
  br i1 %more, label %print.loop, label %print.end

print.end:                                          ; preds = %print.loop
  call void @sub_140002730(i32 10)
  ret i32 0
}
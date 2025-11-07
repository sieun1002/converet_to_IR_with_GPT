; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant [16 x i8]
@xmmword_2020 = external constant [16 x i8]
@unk_2004 = external global i8
@unk_2008 = external global i8

declare i8* @_malloc(i64)
declare void @_free(i8*)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
bb10c0:
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %g0 = bitcast [10 x i32]* %arr to i8*
  %src0 = bitcast i32* %base to i8*
  %c0 = bitcast [16 x i8]* @xmmword_2010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %src0, i8* %c0, i64 16, i1 false)
  %base_plus4 = getelementptr inbounds i32, i32* %base, i64 4
  %src1 = bitcast i32* %base_plus4 to i8*
  %c1 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %src1, i8* %c1, i64 16, i1 false)
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %idx9, align 4
  %buf = call i8* @_malloc(i64 40)
  %buf_is_null = icmp eq i8* %buf, null
  br i1 %buf_is_null, label %bb142e, label %bb1118

bb1118:
  %rsi_dst = bitcast i8* %buf to i32*
  %malloc_saved = alloca i8*, align 8
  store i8* %buf, i8** %malloc_saved, align 8
  %src_ptr = alloca i32*, align 8
  %dst_ptr = alloca i32*, align 8
  %runLen = alloca i64, align 8
  %nextRunLen = alloca i64, align 8
  %passes = alloca i32, align 4
  %r8_idx = alloca i64, align 8
  %r10_idx = alloca i64, align 8
  %r11_len = alloca i64, align 8
  %r12_idx = alloca i64, align 8
  %r13_tmp = alloca i64, align 8
  %rdi_tmp = alloca i64, align 8
  %rax_idx = alloca i64, align 8
  %rdx_end = alloca i64, align 8
  %rbx_rightStart = alloca i64, align 8
  store i32 4, i32* %passes, align 4
  store i32* %base, i32** %src_ptr, align 8
  store i32* %rsi_dst, i32** %dst_ptr, align 8
  store i64 1, i64* %runLen, align 8
  store i64 2, i64* %nextRunLen, align 8
  store i64 0, i64* %r8_idx, align 8
  br label %bb1140

bb1140:
  %rl = load i64, i64* %runLen, align 8
  store i64 %rl, i64* %r11_len, align 8
  %rl2 = shl i64 %rl, 1
  store i64 %rl2, i64* %runLen, align 8
  store i64 0, i64* %r8_idx, align 8
  br label %bb128a

bb128a:
  %r8v = load i64, i64* %r8_idx, align 8
  %r11v = load i64, i64* %r11_len, align 8
  %rdx_tmp = add i64 %r11v, %r8v
  %raxv = add i64 %r8v, 0
  %ten = add i64 0, 10
  %rbx_min = call i64 @llvm.umin.i64(i64 %rdx_tmp, i64 %ten)
  %r8_new = add i64 %rdx_tmp, %r11v
  %rdx_endv = call i64 @llvm.umin.i64(i64 %r8_new, i64 %ten)
  store i64 %rbx_min, i64* %rbx_rightStart, align 8
  store i64 %r8_new, i64* %r8_idx, align 8
  store i64 %rdx_endv, i64* %rdx_end, align 8
  store i64 %raxv, i64* %rax_idx, align 8
  store i64 %raxv, i64* %r10_idx, align 8
  store i64 %rbx_min, i64* %r12_idx, align 8
  %cmp_left_end = icmp uge i64 %raxv, %rdx_endv
  br i1 %cmp_left_end, label %bb1280, label %bb12b8

bb12b8:
  %r10cur = load i64, i64* %r10_idx, align 8
  %rbx_rs = load i64, i64* %rbx_rightStart, align 8
  %left_ge_rightStart = icmp uge i64 %r10cur, %rbx_rs
  br i1 %left_ge_rightStart, label %bb1158, label %bb12c1

bb12c1:
  %srcp = load i32*, i32** %src_ptr, align 8
  %dstp = load i32*, i32** %dst_ptr, align 8
  %raxcur = load i64, i64* %rax_idx, align 8
  %lptr = getelementptr inbounds i32, i32* %srcp, i64 %raxcur
  %lval = load i32, i32* %lptr, align 4
  %r12cur = load i64, i64* %r12_idx, align 8
  %rdxend = load i64, i64* %rdx_end, align 8
  %right_done = icmp uge i64 %r12cur, %rdxend
  br i1 %right_done, label %bb12d7, label %bb12ca

bb12ca:
  %rptr = getelementptr inbounds i32, i32* %srcp, i64 %r12cur
  %rval = load i32, i32* %rptr, align 4
  %take_right = icmp slt i32 %rval, %lval
  br i1 %take_right, label %bb115c, label %bb12d7

bb12d7:
  %dstp1 = load i32*, i32** %dst_ptr, align 8
  %raxcur1 = load i64, i64* %rax_idx, align 8
  %dstcurptr = getelementptr inbounds i32, i32* %dstp1, i64 %raxcur1
  store i32 %lval, i32* %dstcurptr, align 4
  %raxnext = add i64 %raxcur1, 1
  store i64 %raxnext, i64* %rax_idx, align 8
  %rdxend1 = load i64, i64* %rdx_end, align 8
  %done_seg = icmp eq i64 %raxnext, %rdxend1
  br i1 %done_seg, label %bb1280, label %bb12e3

bb12e3:
  %r10n = load i64, i64* %r10_idx, align 8
  %r10nn = add i64 %r10n, 1
  store i64 %r10nn, i64* %r10_idx, align 8
  br label %bb12b8

bb1158:
  %srcp2 = load i32*, i32** %src_ptr, align 8
  %r12c2 = load i64, i64* %r12_idx, align 8
  %rptr2 = getelementptr inbounds i32, i32* %srcp2, i64 %r12c2
  %rval2 = load i32, i32* %rptr2, align 4
  %dstp2 = load i32*, i32** %dst_ptr, align 8
  %raxc2 = load i64, i64* %rax_idx, align 8
  %dptr2 = getelementptr inbounds i32, i32* %dstp2, i64 %raxc2
  store i32 %rval2, i32* %dptr2, align 4
  %rdxend2 = load i64, i64* %rdx_end, align 8
  %raxnext2 = add i64 %raxc2, 1
  store i64 %raxnext2, i64* %rax_idx, align 8
  %done2 = icmp eq i64 %rdxend2, %raxnext2
  br i1 %done2, label %bb1280, label %bb1158_cont

bb1158_cont:
  %r12n2 = add i64 %r12c2, 1
  store i64 %r12n2, i64* %r12_idx, align 8
  br label %bb12b8

bb115c:
  %dstp3 = load i32*, i32** %dst_ptr, align 8
  %raxc3 = load i64, i64* %rax_idx, align 8
  %dptr3 = getelementptr inbounds i32, i32* %dstp3, i64 %raxc3
  store i32 %rval, i32* %dptr3, align 4
  %raxnext3 = add i64 %raxc3, 1
  store i64 %raxnext3, i64* %rax_idx, align 8
  %rdxend3 = load i64, i64* %rdx_end, align 8
  %done3 = icmp eq i64 %rdxend3, %raxnext3
  br i1 %done3, label %bb1280, label %bb115c_cont

bb115c_cont:
  %r12inc = add i64 %r12cur, 1
  store i64 %r12inc, i64* %r12_idx, align 8
  br label %bb12b8

bb1280:
  %r8v2 = load i64, i64* %r8_idx, align 8
  %cmp_more = icmp ugt i64 %r8v2, 9
  br i1 %cmp_more, label %bb1380, label %bb128a

bb1380:
  %passes_cur = load i32, i32* %passes, align 4
  %passes_next = add i32 %passes_cur, -1
  store i32 %passes_next, i32* %passes, align 4
  %is_done = icmp eq i32 %passes_next, 0
  br i1 %is_done, label %bb13ad, label %bb138b

bb138b:
  %src_old = load i32*, i32** %src_ptr, align 8
  %dst_old = load i32*, i32** %dst_ptr, align 8
  store i32* %dst_old, i32** %src_ptr, align 8
  store i32* %src_old, i32** %dst_ptr, align 8
  br label %bb1140

bb13ad:
  %dst_final = load i32*, i32** %dst_ptr, align 8
  %cmp_need_copy = icmp eq i32* %dst_final, %base
  br i1 %cmp_need_copy, label %bb13c6, label %bb13bc

bb13bc:
  %dst_bytes = bitcast i32* %dst_final to i8*
  %base_bytes = bitcast i32* %base to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %base_bytes, i8* %dst_bytes, i64 40, i1 false)
  br label %bb13c6

bb13c6:
  %malloc_saved_val = load i8*, i8** %malloc_saved, align 8
  call void @_free(i8* %malloc_saved_val)
  br label %bb13ce

bb142e:
  br label %bb13ce

bb13ce:
  %endptr = getelementptr inbounds i32, i32* %base, i64 10
  %iter = alloca i32*, align 8
  store i32* %base, i32** %iter, align 8
  %fmt1 = getelementptr inbounds i8, i8* @unk_2004, i64 0
  br label %bb13e0

bb13e0:
  %it = load i32*, i32** %iter, align 8
  %at_end = icmp eq i32* %it, %endptr
  br i1 %at_end, label %bb13fa, label %bb13e0_body

bb13e0_body:
  %val = load i32, i32* %it, align 4
  %it_next = getelementptr inbounds i32, i32* %it, i64 1
  store i32* %it_next, i32** %iter, align 8
  %fmt1_use = getelementptr inbounds i8, i8* %fmt1, i64 0
  %callp = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1_use, i32 %val)
  br label %bb13e0

bb13fa:
  %fmt2 = getelementptr inbounds i8, i8* @unk_2008, i64 0
  %callp2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  br label %bb1421

bb1435:
  call void @___stack_chk_fail()
  unreachable

bb1421:
  ret i32 0
}

declare i64 @llvm.umin.i64(i64, i64) nounwind readnone
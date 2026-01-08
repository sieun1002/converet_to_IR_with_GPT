; ModuleID = 'sub_1400018D0_module'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare i32 @sub_140001700(i8*, ...)
declare void @sub_14049615F()

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

define void @sub_1400018D0() {
entry:
  %var48 = alloca i64, align 8
  %var50 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n32 = call i32 @sub_1400022D0()
  %n64 = sext i32 %n32 to i64
  %mul5 = mul i64 %n64, 5
  %mul40 = mul i64 %mul5, 8
  %plus15 = add i64 %mul40, 15
  %align16 = and i64 %plus15, -16
  %call_2520 = call i64 @sub_140002520()
  %dyn = alloca i8, i64 %call_2520, align 16
  %rdi0 = load i8*, i8** @off_1400043D0, align 8
  %rbx0 = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var50_i8 = bitcast i64* %var50 to i8*
  store i8* %var50_i8, i8** @qword_1400070A8, align 8
  %rdi_i = ptrtoint i8* %rdi0 to i64
  %rbx_i = ptrtoint i8* %rbx0 to i64
  %diff = sub i64 %rdi_i, %rbx_i
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %chk_range

chk_range:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %proto_v2_prep, label %proto_v1_header

proto_v1_header:
  %rbx_h = phi i8* [ %rbx0, %chk_range ], [ %rbx_advance, %v1_hdr_advance ], [ %rbx_p3, %v2_chk3 ]
  %edx0_ptr = bitcast i8* %rbx_h to i32*
  %edx0 = load i32, i32* %edx0_ptr, align 4
  %edx0_nz = icmp ne i32 %edx0, 0
  br i1 %edx0_nz, label %proto_v2_entry, label %v1_chk2

v1_chk2:
  %rbx_h2 = phi i8* [ %rbx_h, %proto_v1_header ]
  %eax1_ptr = getelementptr i8, i8* %rbx_h2, i64 4
  %eax1_ip = bitcast i8* %eax1_ptr to i32*
  %eax1 = load i32, i32* %eax1_ip, align 4
  %eax1_nz = icmp ne i32 %eax1, 0
  br i1 %eax1_nz, label %proto_v2_entry, label %v1_chk3

v1_chk3:
  %rbx_h3 = phi i8* [ %rbx_h2, %v1_chk2 ]
  %edx2_ptr = getelementptr i8, i8* %rbx_h3, i64 8
  %edx2_ip = bitcast i8* %edx2_ptr to i32*
  %edx2 = load i32, i32* %edx2_ip, align 4
  %edx2_is1 = icmp eq i32 %edx2, 1
  br i1 %edx2_is1, label %v1_init, label %unknown_proto

v1_init:
  %rbx_v1 = getelementptr i8, i8* %rbx_h3, i64 12
  %r14_base = load i8*, i8** @off_1400043C0, align 8
  %r12_ptr = bitcast i64* %var48 to i8*
  %rbx_cmp = icmp ult i8* %rbx_v1, %rdi0
  br i1 %rbx_cmp, label %v1_loop_head, label %ret

v1_loop_head:
  %rbx_cur = phi i8* [ %rbx_v1, %v1_init ], [ %rbx_next, %v1_iter_end ]
  %r14_cur = phi i8* [ %r14_base, %v1_init ], [ %r14_base, %v1_iter_end ]
  %r12_cur = phi i8* [ %r12_ptr, %v1_init ], [ %r12_ptr, %v1_iter_end ]
  %end_ptr = icmp uge i8* %rbx_cur, %rdi0
  br i1 %end_ptr, label %after_loop_check, label %v1_load

v1_load:
  %r8_off_ptr = bitcast i8* %rbx_cur to i32*
  %r8_off = load i32, i32* %r8_off_ptr, align 4
  %ecx_ptr = getelementptr i8, i8* %rbx_cur, i64 8
  %ecx_ip = bitcast i8* %ecx_ptr to i32*
  %ecx_val = load i32, i32* %ecx_ip, align 4
  %r15_off_ptr = getelementptr i8, i8* %rbx_cur, i64 4
  %r15_off_ip = bitcast i8* %r15_off_ptr to i32*
  %r15_off = load i32, i32* %r15_off_ip, align 4
  %r8_off_z = zext i32 %r8_off to i64
  %r14_int = ptrtoint i8* %r14_cur to i64
  %r8_abs_i = add i64 %r14_int, %r8_off_z
  %r8_abs = inttoptr i64 %r8_abs_i to i8*
  %r9_q_ptr = bitcast i8* %r8_abs to i64*
  %r9_val = load i64, i64* %r9_q_ptr, align 8
  %r15_off_z = zext i32 %r15_off to i64
  %r15_abs_i = add i64 %r14_int, %r15_off_z
  %r15_abs = inttoptr i64 %r15_abs_i to i8*
  %cl8 = and i32 %ecx_val, 255
  %is_32 = icmp eq i32 %cl8, 32
  %le_32 = icmp ule i32 %cl8, 32
  br i1 %is_32, label %case32, label %chk_8_16

chk_8_16:
  %le_32_t = phi i1 [ %le_32, %v1_load ]
  br i1 %le_32_t, label %case8_or16, label %chk_64

chk_64:
  %is_64 = icmp eq i32 %cl8, 64
  br i1 %is_64, label %case64, label %unknown_bits

case64:
  %r15_qptr = bitcast i8* %r15_abs to i64*
  %q = load i64, i64* %r15_qptr, align 8
  %tmp_sub_i = sub i64 %q, %r8_abs_i
  %adj = add i64 %tmp_sub_i, %r9_val
  %maskc0_64 = and i32 %ecx_val, 192
  store i64 %adj, i64* %var48, align 8
  %maskc0nz_64 = icmp ne i32 %maskc0_64, 0
  br i1 %maskc0nz_64, label %do_write_64, label %chk_neg_64

chk_neg_64:
  %adj_nonneg = icmp sge i64 %adj, 0
  br i1 %adj_nonneg, label %range_error, label %do_write_64

do_write_64:
  call void @sub_140001760(i8* %r15_abs)
  %fnptr_i = inttoptr i64 5368719288 to void (i8*, i8*, i32)*
  call void %fnptr_i(i8* %r15_abs, i8* %r12_cur, i32 8)
  %rbx_next64 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %v1_iter_end

case32:
  %r15_ip32 = bitcast i8* %r15_abs to i32*
  %d32 = load i32, i32* %r15_ip32, align 4
  %d32_sext = sext i32 %d32 to i64
  %tmp32 = sub i64 %d32_sext, %r8_abs_i
  %adj32 = add i64 %tmp32, %r9_val
  %maskc0_32 = and i32 %ecx_val, 192
  store i64 %adj32, i64* %var48, align 8
  %maskc0nz_32 = icmp ne i32 %maskc0_32, 0
  br i1 %maskc0nz_32, label %do_write_32, label %chk_range_32

chk_range_32:
  %cmp_hi = icmp sgt i64 %adj32, 4294967295
  br i1 %cmp_hi, label %range_error, label %chk_lo_32

chk_lo_32:
  %adj32_lo = icmp slt i64 %adj32, -2147483648
  br i1 %adj32_lo, label %range_error, label %do_write_32

do_write_32:
  call void @sub_140001760(i8* %r15_abs)
  %fnptr_i2 = inttoptr i64 5368719288 to void (i8*, i8*, i32)*
  call void %fnptr_i2(i8* %r15_abs, i8* %r12_cur, i32 4)
  %rbx_next32 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %v1_iter_end

case8_or16:
  %is8 = icmp eq i32 %cl8, 8
  br i1 %is8, label %case8, label %case16_chk

case16_chk:
  %is16 = icmp eq i32 %cl8, 16
  br i1 %is16, label %case16, label %unknown_bits

case16:
  %r15_wptr = bitcast i8* %r15_abs to i16*
  %w16 = load i16, i16* %r15_wptr, align 2
  %w16_sext = sext i16 %w16 to i64
  %tmp16 = sub i64 %w16_sext, %r8_abs_i
  %adj16 = add i64 %tmp16, %r9_val
  %maskc0_16 = and i32 %ecx_val, 192
  store i64 %adj16, i64* %var48, align 8
  %maskc0nz_16 = icmp ne i32 %maskc0_16, 0
  br i1 %maskc0nz_16, label %do_write_16, label %chk_range_16

chk_range_16:
  %cmp_hi16 = icmp sgt i64 %adj16, 65535
  br i1 %cmp_hi16, label %range_error, label %chk_lo16

chk_lo16:
  %adj16_lo = icmp slt i64 %adj16, -32768
  br i1 %adj16_lo, label %range_error, label %do_write_16

do_write_16:
  call void @sub_140001760(i8* %r15_abs)
  %fnptr_i3 = inttoptr i64 5368719288 to void (i8*, i8*, i32)*
  call void %fnptr_i3(i8* %r15_abs, i8* %r12_cur, i32 2)
  %rbx_next16 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %v1_iter_end

case8:
  %r15_bptr = bitcast i8* %r15_abs to i8*
  %b8 = load i8, i8* %r15_bptr, align 1
  %b8_sext = sext i8 %b8 to i64
  %tmp8 = sub i64 %b8_sext, %r8_abs_i
  %adj8 = add i64 %tmp8, %r9_val
  %maskc0_8 = and i32 %ecx_val, 192
  store i64 %adj8, i64* %var48, align 8
  %maskc0nz_8 = icmp ne i32 %maskc0_8, 0
  br i1 %maskc0nz_8, label %do_write_8, label %chk_range_8

chk_range_8:
  %cmp_hi8 = icmp sgt i64 %adj8, 255
  br i1 %cmp_hi8, label %range_error, label %chk_lo8

chk_lo8:
  %adj8_lo = icmp slt i64 %adj8, -128
  br i1 %adj8_lo, label %range_error, label %do_write_8

do_write_8:
  call void @sub_140001760(i8* %r15_abs)
  %fnptr_i4 = inttoptr i64 5368719288 to void (i8*, i8*, i32)*
  call void %fnptr_i4(i8* %r15_abs, i8* %r12_cur, i32 1)
  %rbx_next8 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %v1_iter_end

unknown_bits:
  %fmt_unkbits = bitcast i8* @aUnknownPseudoR to i8*
  store i64 0, i64* %var48, align 8
  %call_unkbits = call i32 (i8*, ...) @sub_140001700(i8* %fmt_unkbits)
  br label %ret

range_error:
  %adj_phi = phi i64 [ %adj, %chk_neg_64 ], [ %adj32, %chk_range_32 ], [ %adj32, %chk_lo_32 ], [ %adj16, %chk_range_16 ], [ %adj16, %chk_lo16 ], [ %adj8, %chk_range_8 ], [ %adj8, %chk_lo8 ]
  store i64 %adj_phi, i64* %var60, align 8
  %fmt_range = bitcast i8* @aDBitPseudoRelo to i8*
  %adj_val = load i64, i64* %var60, align 8
  %_err = call i32 (i8*, ...) @sub_140001700(i8* %fmt_range, i64 %adj_val, i8* %r15_abs)
  br label %ret

v1_iter_end:
  %rbx_next = phi i8* [ %rbx_next64, %do_write_64 ], [ %rbx_next32, %do_write_32 ], [ %rbx_next16, %do_write_16 ], [ %rbx_next8, %do_write_8 ]
  %cont = icmp ult i8* %rbx_next, %rdi0
  br i1 %cont, label %v1_loop_head, label %after_loop_check

after_loop_check:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_pos = icmp sgt i32 %cnt, 0
  br i1 %cnt_pos, label %call_49615F, label %ret

call_49615F:
  call void @sub_14049615F()
  br label %ret

proto_v2_prep:
  %rbx_p = phi i8* [ %rbx0, %chk_range ]
  %r9d_ptr = bitcast i8* %rbx_p to i32*
  %r9d_val = load i32, i32* %r9d_ptr, align 4
  %r9d_nz = icmp ne i32 %r9d_val, 0
  br i1 %r9d_nz, label %proto_v2_entry, label %v2_chk2

v2_chk2:
  %rbx_p2 = phi i8* [ %rbx_p, %proto_v2_prep ]
  %r8d_ptr = getelementptr i8, i8* %rbx_p2, i64 4
  %r8d_ip = bitcast i8* %r8d_ptr to i32*
  %r8d_val = load i32, i32* %r8d_ip, align 4
  %r8d_nz = icmp ne i32 %r8d_val, 0
  br i1 %r8d_nz, label %proto_v2_entry, label %v2_chk3

v2_chk3:
  %rbx_p3 = phi i8* [ %rbx_p2, %v2_chk2 ]
  %ecx3_ptr = getelementptr i8, i8* %rbx_p3, i64 8
  %ecx3_ip = bitcast i8* %ecx3_ptr to i32*
  %ecx3_val = load i32, i32* %ecx3_ip, align 4
  %ecx3_nz = icmp ne i32 %ecx3_val, 0
  br i1 %ecx3_nz, label %proto_v1_header, label %v1_hdr_advance

v1_hdr_advance:
  %rbx_advance = getelementptr i8, i8* %rbx_p3, i64 12
  br label %proto_v1_header

proto_v2_entry:
  %rbx_v2 = phi i8* [ %rbx_h, %proto_v1_header ], [ %rbx_h2, %v1_chk2 ], [ %rbx_p, %proto_v2_prep ], [ %rbx_p2, %v2_chk2 ]
  %at_end = icmp uge i8* %rbx_v2, %rdi0
  br i1 %at_end, label %ret, label %v2_loop_prep

v2_loop_prep:
  %r14_b = load i8*, i8** @off_1400043C0, align 8
  %r13_ptr = bitcast i64* %var48 to i8*
  br label %v2_loop

v2_loop:
  %rbx_v2_cur = phi i8* [ %rbx_v2, %v2_loop_prep ], [ %rbx_v2_next, %v2_loop ]
  %r14_v2 = phi i8* [ %r14_b, %v2_loop_prep ], [ %r14_v2, %v2_loop ]
  %r13_v2 = phi i8* [ %r13_ptr, %v2_loop_prep ], [ %r13_v2, %v2_loop ]
  %r12off_ptr = getelementptr i8, i8* %rbx_v2_cur, i64 4
  %r12off_ip = bitcast i8* %r12off_ptr to i32*
  %r12off = load i32, i32* %r12off_ip, align 4
  %eax_v2_ip = bitcast i8* %rbx_v2_cur to i32*
  %eax_v2 = load i32, i32* %eax_v2_ip, align 4
  %rbx_v2_next = getelementptr i8, i8* %rbx_v2_cur, i64 8
  %r12off_z = zext i32 %r12off to i64
  %r14_v2_i = ptrtoint i8* %r14_v2 to i64
  %idx_i = add i64 %r14_v2_i, %r12off_z
  %base_ptr = inttoptr i64 %idx_i to i8*
  %base_i32_ptr = bitcast i8* %base_ptr to i32*
  %base_val = load i32, i32* %base_i32_ptr, align 4
  %add_eax = add i32 %eax_v2, %base_val
  %add_eax_zext = zext i32 %add_eax to i64
  %var48_i32p = bitcast i64* %var48 to i32*
  store i32 %add_eax, i32* %var48_i32p, align 4
  call void @sub_140001760(i8* %base_ptr)
  %fnptr_i5 = inttoptr i64 5368719288 to void (i8*, i8*, i32)*
  call void %fnptr_i5(i8* %base_ptr, i8* %r13_v2, i32 4)
  %cont_v2 = icmp ult i8* %rbx_v2_next, %rdi0
  br i1 %cont_v2, label %v2_loop, label %after_loop_check

unknown_proto:
  %fmt_unkproto = bitcast i8* @aUnknownPseudoR_0 to i8*
  %_up = call i32 (i8*, ...) @sub_140001700(i8* %fmt_unkproto)
  br label %ret

ret:
  ret void
}
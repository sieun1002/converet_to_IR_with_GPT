; ModuleID = 'sub_1400018D0.ll'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare i32 @sub_140001700(i8*, ...)

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@qword_140008290 = external global i8*

@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

define void @sub_1400018D0() {
entry:
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %var48_i8 = bitcast i64* %var48 to i8*
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %cnt32 = call i32 @sub_1400022D0()
  %cnt64 = sext i32 %cnt32 to i64
  %mul5 = mul i64 %cnt64, 5
  %mul8 = shl i64 %mul5, 3
  %addf = add i64 %mul8, 15
  %aligned = and i64 %addf, -16
  %allocsz = call i64 @sub_140002520()
  %dyn = alloca i8, i64 %allocsz, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %dyn, i8** @qword_1400070A8, align 8
  %endptr = load i8*, i8** @off_1400043D0, align 8
  %startptr = load i8*, i8** @off_1400043E0, align 8
  %end_i = ptrtoint i8* %endptr to i64
  %start_i = ptrtoint i8* %startptr to i64
  %diff = sub i64 %end_i, %start_i
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %cmpB

cmpB:
  %gtB = icmp sgt i64 %diff, 11
  br i1 %gtB, label %ver2_check, label %ver1_hdr

ver1_hdr:
  %rbx0 = phi i8* [ %startptr, %cmpB ], [ %rbx2, %ver2_chk3 ], [ %rbx2_adv, %ver1_from_v2_advance ]
  %w0p = bitcast i8* %rbx0 to i32*
  %w0 = load i32, i32* %w0p, align 4
  %w0_nz = icmp ne i32 %w0, 0
  br i1 %w0_nz, label %ver2_loop_entry, label %ver1_chk2

ver1_chk2:
  %w1p = getelementptr i8, i8* %rbx0, i64 4
  %w1pi = bitcast i8* %w1p to i32*
  %w1 = load i32, i32* %w1pi, align 4
  %w1_nz = icmp ne i32 %w1, 0
  br i1 %w1_nz, label %ver2_loop_entry, label %ver1_chk3

ver1_chk3:
  %w2p = getelementptr i8, i8* %rbx0, i64 8
  %w2pi = bitcast i8* %w2p to i32*
  %w2 = load i32, i32* %w2pi, align 4
  %w2_is1 = icmp eq i32 %w2, 1
  br i1 %w2_is1, label %ver1_setup, label %unk_proto

ver1_setup:
  %rbx1 = getelementptr i8, i8* %rbx0, i64 12
  %r14 = load i8*, i8** @off_1400043C0, align 8
  %r12 = getelementptr i8, i8* %var48_i8, i64 0
  %cmp_init = icmp ult i8* %rbx1, %endptr
  br i1 %cmp_init, label %ver1_loop, label %finalize

ver1_loop:
  %rbx_cur = phi i8* [ %rbx1, %ver1_setup ], [ %rbx_next_from_case, %ver1_check ]
  %off0p = bitcast i8* %rbx_cur to i32*
  %off0 = load i32, i32* %off0p, align 4
  %off1p = getelementptr i8, i8* %rbx_cur, i64 4
  %off1pi = bitcast i8* %off1p to i32*
  %off1 = load i32, i32* %off1pi, align 4
  %flagp = getelementptr i8, i8* %rbx_cur, i64 8
  %flagpi = bitcast i8* %flagp to i32*
  %flags = load i32, i32* %flagpi, align 4
  %off0_z = zext i32 %off0 to i64
  %off1_z = zext i32 %off1 to i64
  %r8ptr = getelementptr i8, i8* %r14, i64 %off0_z
  %r15ptr = getelementptr i8, i8* %r14, i64 %off1_z
  %r9p = bitcast i8* %r8ptr to i64*
  %r9 = load i64, i64* %r9p, align 1
  %flags_low = and i32 %flags, 255
  %is32 = icmp eq i32 %flags_low, 32
  %le32 = icmp ule i32 %flags_low, 32
  br i1 %is32, label %case32, label %chk_small

chk_small:
  br i1 %le32, label %smallcases, label %chk64

smallcases:
  %is8 = icmp eq i32 %flags_low, 8
  br i1 %is8, label %case8, label %chk16

chk16:
  %is16 = icmp eq i32 %flags_low, 16
  br i1 %is16, label %case16, label %unk_bits

chk64:
  %is64 = icmp eq i32 %flags_low, 64
  br i1 %is64, label %case64, label %unk_bits

case8:
  %v8p = bitcast i8* %r15ptr to i8*
  %v8 = load i8, i8* %v8p, align 1
  %v8se = sext i8 %v8 to i64
  %r8int_8 = ptrtoint i8* %r8ptr to i64
  %t8sub = sub i64 %v8se, %r8int_8
  %t8 = add i64 %t8sub, %r9
  %maskC0_8 = and i32 %flags, 192
  store i64 %t8, i64* %var48, align 8
  %nzC0_8 = icmp ne i32 %maskC0_8, 0
  br i1 %nzC0_8, label %do8, label %rng8

rng8:
  %gt255 = icmp sgt i64 %t8, 255
  %ltm128 = icmp slt i64 %t8, -128
  %oor8 = or i1 %gt255, %ltm128
  br i1 %oor8, label %out_of_range, label %do8

do8:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12, i32 1)
  %rbx_next8 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %ver1_check

case16:
  %v16p = bitcast i8* %r15ptr to i16*
  %v16 = load i16, i16* %v16p, align 1
  %v16se = sext i16 %v16 to i64
  %r8int_16 = ptrtoint i8* %r8ptr to i64
  %t16sub = sub i64 %v16se, %r8int_16
  %t16 = add i64 %t16sub, %r9
  %maskC0_16 = and i32 %flags, 192
  store i64 %t16, i64* %var48, align 8
  %nzC0_16 = icmp ne i32 %maskC0_16, 0
  br i1 %nzC0_16, label %do16, label %rng16

rng16:
  %gtFFFF = icmp sgt i64 %t16, 65535
  %ltneg32768 = icmp slt i64 %t16, -32768
  %oor16 = or i1 %gtFFFF, %ltneg32768
  br i1 %oor16, label %out_of_range, label %do16

do16:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12, i32 2)
  %rbx_next16 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %ver1_check

case32:
  %v32p = bitcast i8* %r15ptr to i32*
  %v32 = load i32, i32* %v32p, align 1
  %v32se = sext i32 %v32 to i64
  %r8int_32 = ptrtoint i8* %r8ptr to i64
  %t32sub = sub i64 %v32se, %r8int_32
  %t32 = add i64 %t32sub, %r9
  %maskC0_32 = and i32 %flags, 192
  store i64 %t32, i64* %var48, align 8
  %nzC0_32 = icmp ne i32 %maskC0_32, 0
  br i1 %nzC0_32, label %do32, label %rng32

rng32:
  %thresh_hi = icmp sgt i64 %t32, 4294967295
  %thresh_lo = icmp slt i64 %t32, -2147483648
  %oor32 = or i1 %thresh_hi, %thresh_lo
  br i1 %oor32, label %out_of_range, label %do32

do32:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12, i32 4)
  %rbx_next32 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %ver1_check

case64:
  %v64p = bitcast i8* %r15ptr to i64*
  %v64 = load i64, i64* %v64p, align 1
  %r8int_64 = ptrtoint i8* %r8ptr to i64
  %t64sub = sub i64 %v64, %r8int_64
  %t64 = add i64 %t64sub, %r9
  %maskC0_64 = and i32 %flags, 192
  store i64 %t64, i64* %var48, align 8
  %nzC0_64 = icmp ne i32 %maskC0_64, 0
  br i1 %nzC0_64, label %do64, label %rng64

rng64:
  %nonneg64 = icmp sge i64 %t64, 0
  br i1 %nonneg64, label %out_of_range, label %do64

do64:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12, i32 8)
  %rbx_next64 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %ver1_check

unk_bits:
  %msg_unk_bits = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  store i64 0, i64* %var48, align 8
  %_ = call i32 (i8*, ...) @sub_140001700(i8* %msg_unk_bits)
  br label %finalize

out_of_range:
  %t_oor = load i64, i64* %var48, align 8
  store i64 %t_oor, i64* %var60, align 8
  %fmt_oor = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  %t_pass = load i64, i64* %var60, align 8
  %t_pass_val = add i64 %t_pass, 0
  %r15_for_call = getelementptr i8, i8* %r15ptr, i64 0
  %_2 = call i32 (i8*, ...) @sub_140001700(i8* %fmt_oor, i64 %t_pass_val, i8* %r15_for_call)
  br label %finalize

ver1_check:
  %rbx_next_from_case = phi i8* [ %rbx_next8, %do8 ], [ %rbx_next16, %do16 ], [ %rbx_next32, %do32 ], [ %rbx_next64, %do64 ]
  %cont = icmp ult i8* %rbx_next_from_case, %endptr
  br i1 %cont, label %ver1_loop, label %finalize

unk_proto:
  %msg_unk_proto = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  %_3 = call i32 (i8*, ...) @sub_140001700(i8* %msg_unk_proto)
  br label %finalize

ver2_check:
  %rbx2 = phi i8* [ %startptr, %cmpB ]
  %v2w0p = bitcast i8* %rbx2 to i32*
  %v2w0 = load i32, i32* %v2w0p, align 4
  %v2w0_nz = icmp ne i32 %v2w0, 0
  br i1 %v2w0_nz, label %ver2_loop_entry, label %ver2_chk2

ver2_chk2:
  %v2w1p = getelementptr i8, i8* %rbx2, i64 4
  %v2w1pi = bitcast i8* %v2w1p to i32*
  %v2w1 = load i32, i32* %v2w1pi, align 4
  %v2w1_nz = icmp ne i32 %v2w1, 0
  br i1 %v2w1_nz, label %ver2_loop_entry, label %ver2_chk3

ver2_chk3:
  %v2w2p = getelementptr i8, i8* %rbx2, i64 8
  %v2w2pi = bitcast i8* %v2w2p to i32*
  %v2w2 = load i32, i32* %v2w2pi, align 4
  %v2w2_nz = icmp ne i32 %v2w2, 0
  br i1 %v2w2_nz, label %ver1_hdr, label %ver1_from_v2_advance

ver1_from_v2_advance:
  %rbx2_adv = getelementptr i8, i8* %rbx2, i64 12
  br label %ver1_hdr

ver2_loop_entry:
  %rbxv = phi i8* [ %rbx0, %ver1_chk2 ], [ %rbx2, %ver2_check ], [ %rbx2, %ver2_chk2 ], [ %rbx0, %ver1_hdr ]
  %cond_done = icmp uge i8* %rbxv, %endptr
  br i1 %cond_done, label %finalize, label %ver2_loop

ver2_loop:
  %rbx_it = phi i8* [ %rbxv, %ver2_loop_entry ], [ %rbx_it_next, %ver2_loop ]
  %r14_v2 = load i8*, i8** @off_1400043C0, align 8
  %r13_v2 = getelementptr i8, i8* %var48_i8, i64 0
  %v2o1p = getelementptr i8, i8* %rbx_it, i64 4
  %v2o1pi = bitcast i8* %v2o1p to i32*
  %off_idx = load i32, i32* %v2o1pi, align 4
  %v2o0p = bitcast i8* %rbx_it to i32*
  %addend = load i32, i32* %v2o0p, align 4
  %rbx_it_next = getelementptr i8, i8* %rbx_it, i64 8
  %off_i64 = sext i32 %off_idx to i64
  %base_plus = getelementptr i8, i8* %r14_v2, i64 %off_i64
  %base_plus_i32p = bitcast i8* %base_plus to i32*
  %base_val = load i32, i32* %base_plus_i32p, align 1
  %sum32 = add i32 %addend, %base_val
  %sum64 = sext i32 %sum32 to i64
  store i64 %sum64, i64* %var48, align 8
  call void @sub_140001760(i8* %base_plus)
  call void @sub_1400027B8(i8* %base_plus, i8* %r13_v2, i32 4)
  %more = icmp ult i8* %rbx_it_next, %endptr
  br i1 %more, label %ver2_loop, label %finalize

finalize:
  %cnt_fin = load i32, i32* @dword_1400070A4, align 4
  %has_any = icmp sgt i32 %cnt_fin, 0
  br i1 %has_any, label %call_handlers, label %ret

call_handlers:
  %fnptr_i8 = load i8*, i8** @qword_140008290, align 8
  %fnptr = bitcast i8* %fnptr_i8 to void (i8*, i8*, i32, i8*)*
  %basearr = load i8*, i8** @qword_1400070A8, align 8
  %i0 = add i32 %cnt_fin, 0
  %zero_i = add i32 0, 0
  br label %loop_calls

loop_calls:
  %i = phi i32 [ 0, %call_handlers ], [ %i_next, %loop_cont ]
  %ofs = mul i32 %i, 40
  %ofs64 = sext i32 %ofs to i64
  %elem = getelementptr i8, i8* %basearr, i64 %ofs64
  %typ_p = bitcast i8* %elem to i32*
  %typ = load i32, i32* %typ_p, align 4
  %nonzero_typ = icmp ne i32 %typ, 0
  br i1 %nonzero_typ, label %do_call, label %skip_call

do_call:
  %rcx_p = getelementptr i8, i8* %elem, i64 8
  %rdx_p = getelementptr i8, i8* %elem, i64 16
  %rcx64p = bitcast i8* %rcx_p to i64*
  %rdx64p = bitcast i8* %rdx_p to i64*
  %rcx_val = load i64, i64* %rcx64p, align 8
  %rdx_val = load i64, i64* %rdx64p, align 8
  %rcx_ptr = inttoptr i64 %rcx_val to i8*
  %rdx_ptr = inttoptr i64 %rdx_val to i8*
  call void %fnptr(i8* %rcx_ptr, i8* %rdx_ptr, i32 %typ, i8* %var48_i8)
  br label %loop_cont

skip_call:
  br label %loop_cont

loop_cont:
  %i_next = add i32 %i, 1
  %cond_more = icmp slt i32 %i_next, %cnt_fin
  br i1 %cond_more, label %loop_calls, label %ret

ret:
  ret void
}
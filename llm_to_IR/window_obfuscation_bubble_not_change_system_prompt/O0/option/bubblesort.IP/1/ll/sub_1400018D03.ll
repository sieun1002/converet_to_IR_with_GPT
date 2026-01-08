; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043D0 = external dso_local global i8*
@off_1400043E0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*

@aUnknownPseudoR = external dso_local global i8
@aDBitPseudoRelo = external dso_local global i8
@aUnknownPseudoR_0 = external dso_local global i8

declare dso_local i32 @sub_1400022D0()
declare dso_local void @sub_140002520()
declare dso_local void @sub_140001760(i8*)
declare dso_local i32 @sub_1400BF822()
declare dso_local void @sub_140001700(i8*, ...)

declare dso_local i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define dso_local void @sub_1400018D0() local_unnamed_addr {
entry:
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %flag0 = load i32, i32* @dword_1400070A0, align 4
  %tst0 = icmp eq i32 %flag0, 0
  br i1 %tst0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n0 = call i32 @sub_1400022D0()
  %n0_sext = sext i32 %n0 to i64
  %mul5 = mul i64 %n0_sext, 5
  %mul40 = shl i64 %mul5, 3
  %add15 = add i64 %mul40, 15
  %mask = and i64 %add15, -16
  call void @sub_140002520()
  %endp = load i8*, i8** @off_1400043D0, align 8
  %startp = load i8*, i8** @off_1400043E0, align 8
  %end_i = ptrtoint i8* %endp to i64
  %start_i = ptrtoint i8* %startp to i64
  %diff = sub i64 %end_i, %start_i
  store i32 0, i32* @dword_1400070A4, align 4
  %var48_i8p = bitcast i64* %var48 to i8*
  store i8* %var48_i8p, i8** @qword_1400070A8, align 8
  %cmp_le_7 = icmp sle i64 %diff, 7
  br i1 %cmp_le_7, label %ret, label %cmp_11

cmp_11:
  %cmp_gt_11 = icmp sgt i64 %diff, 11
  br i1 %cmp_gt_11, label %ext_check, label %proto2_check

proto2_check:
  %rbx0 = ptrtoint i8* %startp to i64
  %edx0_ptr = getelementptr i8, i8* %startp, i64 0
  %edx0_ptr_i32 = bitcast i8* %edx0_ptr to i32*
  %edx0_i32 = load i32, i32* %edx0_ptr_i32, align 4
  %tst_edx0 = icmp ne i32 %edx0_i32, 0
  br i1 %tst_edx0, label %ext_loop_prep, label %p2_chk2

p2_chk2:
  %eax1_ptr = getelementptr i8, i8* %startp, i64 4
  %eax1_ptr_i32 = bitcast i8* %eax1_ptr to i32*
  %eax1_i32 = load i32, i32* %eax1_ptr_i32, align 4
  %tst_eax1 = icmp ne i32 %eax1_i32, 0
  br i1 %tst_eax1, label %ext_loop_prep, label %p2_ver

p2_ver:
  %edx2_ptr = getelementptr i8, i8* %startp, i64 8
  %edx2_ptr_i32 = bitcast i8* %edx2_ptr to i32*
  %edx2_i32 = load i32, i32* %edx2_ptr_i32, align 4
  %ver_is1 = icmp eq i32 %edx2_i32, 1
  br i1 %ver_is1, label %p2_init, label %err_proto

p2_init:
  %rbx1 = add i64 %rbx0, 12
  %endcmp0 = icmp ult i64 %rbx1, %end_i
  br i1 %endcmp0, label %p2_loop, label %ret

ext_check:
  br label %ext_loop_prep

ext_loop_prep:
  %endptr_ext = load i8*, i8** @off_1400043D0, align 8
  %startptr_ext = load i8*, i8** @off_1400043E0, align 8
  %rbx_ext_init = ptrtoint i8* %startptr_ext to i64
  %end_ext_i = ptrtoint i8* %endptr_ext to i64
  %baseC0_ext = load i8*, i8** @off_1400043C0, align 8
  br label %ext_loop

ext_loop:
  %rbx_ext = phi i64 [ %rbx_ext_init, %ext_loop_prep ], [ %rbx_ext_next, %ext_body ]
  %cmp_end_ext = icmp uge i64 %rbx_ext, %end_ext_i
  br i1 %cmp_end_ext, label %post_loops, label %ext_body

ext_body:
  %symoff_ptr = inttoptr i64 %rbx_ext to i8*
  %symoff_ptr_i32p = bitcast i8* %symoff_ptr to i32*
  %sym_add_i32 = load i32, i32* %symoff_ptr_i32p, align 4
  %targoff_ptr = getelementptr i8, i8* %symoff_ptr, i64 4
  %targoff_ptr_i32p = bitcast i8* %targoff_ptr to i32*
  %targ_off_i32 = load i32, i32* %targoff_ptr_i32p, align 4
  %rbx_ext_next = add i64 %rbx_ext, 8
  %targ_off_i64 = sext i32 %targ_off_i32 to i64
  %baseC0_ext_i = ptrtoint i8* %baseC0_ext to i64
  %targ_addr_i = add i64 %baseC0_ext_i, %targ_off_i64
  %targ_addr = inttoptr i64 %targ_addr_i to i8*
  %sym_val_ptr_i8 = getelementptr i8, i8* %baseC0_ext, i64 %targ_off_i64
  %sym_val_ptr2 = bitcast i8* %sym_val_ptr_i8 to i32*
  %sym_val32 = load i32, i32* %sym_val_ptr2, align 4
  %sum32 = add i32 %sym_val32, %sym_add_i32
  %sum64 = sext i32 %sum32 to i64
  store i64 %sum64, i64* %var48, align 8
  call void @sub_140001760(i8* %targ_addr)
  %copy_src = bitcast i64* %var48 to i8*
  %_ext = call i8* @memcpy(i8* noundef %targ_addr, i8* noundef %copy_src, i64 noundef 4)
  br label %ext_loop

p2_loop:
  %rbx_cur = phi i64 [ %rbx1, %p2_init ], [ %rbx_next, %p2_iter ]
  %baseC0 = load i8*, i8** @off_1400043C0, align 8
  %end_cond = icmp uge i64 %rbx_cur, %end_i
  br i1 %end_cond, label %post_loops, label %p2_body

p2_body:
  %entry_ptr = inttoptr i64 %rbx_cur to i8*
  %r8off_i32_ptr = bitcast i8* %entry_ptr to i32*
  %r8off_i32 = load i32, i32* %r8off_i32_ptr, align 4
  %r15off_ptr = getelementptr i8, i8* %entry_ptr, i64 4
  %r15off_i32_ptr = bitcast i8* %r15off_ptr to i32*
  %r15off_i32 = load i32, i32* %r15off_i32_ptr, align 4
  %ecx_ptr = getelementptr i8, i8* %entry_ptr, i64 8
  %ecx_i32_ptr = bitcast i8* %ecx_ptr to i32*
  %ecx_i32 = load i32, i32* %ecx_i32_ptr, align 4
  %rbx_next = add i64 %rbx_cur, 12
  %r8off_i64 = sext i32 %r8off_i32 to i64
  %r15off_i64 = sext i32 %r15off_i32 to i64
  %r8ptr = getelementptr i8, i8* %baseC0, i64 %r8off_i64
  %r15ptr = getelementptr i8, i8* %baseC0, i64 %r15off_i64
  %r8ptr_i64p = bitcast i8* %r8ptr to i64*
  %r9_val = load i64, i64* %r8ptr_i64p, align 8
  %edx_masked = and i32 %ecx_i32, 255
  %is32 = icmp eq i32 %edx_masked, 32
  %le32 = icmp ule i32 %edx_masked, 32
  br i1 %is32, label %case32, label %chk_small

chk_small:
  br i1 %le32, label %small_sizes, label %chk_64

chk_64:
  %is64 = icmp eq i32 %edx_masked, 64
  br i1 %is64, label %case64, label %err_bitsize

small_sizes:
  %is8 = icmp eq i32 %edx_masked, 8
  br i1 %is8, label %case8, label %chk16

chk16:
  %is16 = icmp eq i32 %edx_masked, 16
  br i1 %is16, label %case16, label %err_bitsize

case16:
  %r15ptr_i16p = bitcast i8* %r15ptr to i16*
  %w16 = load i16, i16* %r15ptr_i16p, align 2
  %w16_sext = sext i16 %w16 to i64
  %r8addr_i = ptrtoint i8* %r8ptr to i64
  %tmp16 = sub i64 %w16_sext, %r8addr_i
  %val16 = add i64 %tmp16, %r9_val
  store i64 %val16, i64* %var48, align 8
  %flags16 = and i32 %ecx_i32, 192
  %nzflags16 = icmp ne i32 %flags16, 0
  br i1 %nzflags16, label %write16, label %rng16

rng16:
  %cmp_hi16 = icmp sgt i64 %val16, 65535
  br i1 %cmp_hi16, label %err_range, label %rng16_lo

rng16_lo:
  %cmp_lo16 = icmp slt i64 %val16, -32768
  br i1 %cmp_lo16, label %err_range, label %write16

write16:
  call void @sub_140001760(i8* %r15ptr)
  %src16 = bitcast i64* %var48 to i8*
  %_m16 = call i8* @memcpy(i8* noundef %r15ptr, i8* noundef %src16, i64 noundef 2)
  br label %p2_iter

case32:
  %r15ptr_i32p = bitcast i8* %r15ptr to i32*
  %d32 = load i32, i32* %r15ptr_i32p, align 4
  %d32_sext = sext i32 %d32 to i64
  %r8addr_i2 = ptrtoint i8* %r8ptr to i64
  %tmp32 = sub i64 %d32_sext, %r8addr_i2
  %val32 = add i64 %tmp32, %r9_val
  store i64 %val32, i64* %var48, align 8
  %flags32 = and i32 %ecx_i32, 192
  %nzflags32 = icmp ne i32 %flags32, 0
  br i1 %nzflags32, label %write32, label %rng32

rng32:
  %cmp_hi32 = icmp sgt i64 %val32, 2147483647
  br i1 %cmp_hi32, label %err_range, label %rng32_lo

rng32_lo:
  %cmp_lo32 = icmp slt i64 %val32, -2147483648
  br i1 %cmp_lo32, label %err_range, label %write32

write32:
  call void @sub_140001760(i8* %r15ptr)
  %src32 = bitcast i64* %var48 to i8*
  %_m32 = call i8* @memcpy(i8* noundef %r15ptr, i8* noundef %src32, i64 noundef 4)
  br label %p2_iter

case64:
  %r15ptr_i64p = bitcast i8* %r15ptr to i64*
  %q64 = load i64, i64* %r15ptr_i64p, align 8
  %r8addr_i3 = ptrtoint i8* %r8ptr to i64
  %tmp64 = sub i64 %q64, %r8addr_i3
  %val64 = add i64 %tmp64, %r9_val
  store i64 %val64, i64* %var48, align 8
  %flags64 = and i32 %ecx_i32, 192
  %nzflags64 = icmp ne i32 %flags64, 0
  br i1 %nzflags64, label %write64, label %rng64

rng64:
  %nonneg = icmp sge i64 %val64, 0
  br i1 %nonneg, label %err_range, label %write64

write64:
  call void @sub_140001760(i8* %r15ptr)
  %src64 = bitcast i64* %var48 to i8*
  %_m64 = call i8* @memcpy(i8* noundef %r15ptr, i8* noundef %src64, i64 noundef 8)
  br label %p2_iter

case8:
  %b8 = load i8, i8* %r15ptr, align 1
  %b8_sext = sext i8 %b8 to i64
  %r8addr_i4 = ptrtoint i8* %r8ptr to i64
  %tmp8 = sub i64 %b8_sext, %r8addr_i4
  %val8 = add i64 %tmp8, %r9_val
  store i64 %val8, i64* %var48, align 8
  %flags8 = and i32 %ecx_i32, 192
  %nzflags8 = icmp ne i32 %flags8, 0
  br i1 %nzflags8, label %write8, label %rng8

rng8:
  %cmp_hi8 = icmp sgt i64 %val8, 255
  br i1 %cmp_hi8, label %err_range, label %rng8_lo

rng8_lo:
  %cmp_lo8 = icmp slt i64 %val8, -128
  br i1 %cmp_lo8, label %err_range, label %write8

write8:
  call void @sub_140001760(i8* %r15ptr)
  %src8 = bitcast i64* %var48 to i8*
  %_m8 = call i8* @memcpy(i8* noundef %r15ptr, i8* noundef %src8, i64 noundef 1)
  br label %p2_iter

p2_iter:
  %cont = icmp ult i64 %rbx_next, %end_i
  br i1 %cont, label %p2_loop, label %post_loops

post_loops:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %le0 = icmp sle i32 %cnt, 0
  br i1 %le0, label %ret, label %ret

err_bitsize:
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR)
  br label %ret

err_range:
  %err_val = phi i64 [ %val16, %rng16 ], [ %val16, %rng16_lo ], [ %val32, %rng32 ], [ %val32, %rng32_lo ], [ %val64, %rng64 ], [ %val8, %rng8 ], [ %val8, %rng8_lo ]
  %err_ptr = phi i8* [ %r15ptr, %rng16 ], [ %r15ptr, %rng16_lo ], [ %r15ptr, %rng32 ], [ %r15ptr, %rng32_lo ], [ %r15ptr, %rng64 ], [ %r15ptr, %rng8 ], [ %r15ptr, %rng8_lo ]
  store i64 %err_val, i64* %var60, align 8
  %valloaded = load i64, i64* %var60, align 8
  call void (i8*, ...) @sub_140001700(i8* @aDBitPseudoRelo, i64 %valloaded, i8* %err_ptr)
  br label %ret

err_proto:
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR_0)
  br label %ret

ret:
  ret void
}
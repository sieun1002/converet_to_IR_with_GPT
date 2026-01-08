; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043D0 = external global i8*, align 8
@off_1400043E0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@qword_140008290 = external global void (i8*, i8*, i32, i8*)*, align 8

@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare void @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare void @sub_140001700(i8*, ...)

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %tst0 = icmp eq i32 %g0, 0
  br i1 %tst0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_1400022D0()
  %n64 = sext i32 %n to i64
  %mul5 = mul i64 %n64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %size = and i64 %add15, -16
  call void @sub_140002520()
  %endp = load i8*, i8** @off_1400043D0, align 8
  %begp = load i8*, i8** @off_1400043E0, align 8
  %buf = alloca i8, i64 %size, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  %end = ptrtoint i8* %endp to i64
  %beg = ptrtoint i8* %begp to i64
  %diff = sub i64 %end, %beg
  %cmp_le7 = icmp sle i64 %diff, 7
  br i1 %cmp_le7, label %ret, label %chk11

chk11:
  %cmp_gt11 = icmp sgt i64 %diff, 11
  br i1 %cmp_gt11, label %proto2_hdr, label %proto1_hdr

proto1_hdr:
  %hdr0p = bitcast i8* %begp to i32*
  %hdr0 = load i32, i32* %hdr0p, align 4
  %hdr0z = icmp eq i32 %hdr0, 0
  br i1 %hdr0z, label %p1hdr1, label %proto2_AFD

p1hdr1:
  %hdr1p = getelementptr i8, i8* %begp, i64 4
  %hdr1pi = bitcast i8* %hdr1p to i32*
  %hdr1 = load i32, i32* %hdr1pi, align 4
  %hdr1z = icmp eq i32 %hdr1, 0
  br i1 %hdr1z, label %p1hdr2, label %proto2_AFD

p1hdr2:
  %hdr2p = getelementptr i8, i8* %begp, i64 8
  %hdr2pi = bitcast i8* %hdr2p to i32*
  %hdr2 = load i32, i32* %hdr2pi, align 4
  %cmp_hdr2 = icmp eq i32 %hdr2, 1
  br i1 %cmp_hdr2, label %p1setup, label %unknown_proto

p1setup:
  %rbx0 = getelementptr i8, i8* %begp, i64 12
  %base = load i8*, i8** @off_1400043C0, align 8
  %var48 = alloca i64, align 8
  %r12 = bitcast i64* %var48 to i8*
  %jb = icmp ult i8* %rbx0, %endp
  br i1 %jb, label %loop_p1, label %after_loops

loop_p1:
  %rbx_cur = phi i8* [ %rbx0, %p1setup ], [ %rbx_next, %loop_back ]
  %r8off_ptr = bitcast i8* %rbx_cur to i32*
  %r8off = load i32, i32* %r8off_ptr, align 4
  %r15off_ptr = getelementptr i8, i8* %rbx_cur, i64 4
  %r15off_p32 = bitcast i8* %r15off_ptr to i32*
  %r15off = load i32, i32* %r15off_p32, align 4
  %bits_ptr = getelementptr i8, i8* %rbx_cur, i64 8
  %bits_p32 = bitcast i8* %bits_ptr to i32*
  %bits32 = load i32, i32* %bits_p32, align 4
  %edx_byte = trunc i32 %bits32 to i8
  %edx_z = zext i8 %edx_byte to i32
  %r8off64 = sext i32 %r8off to i64
  %r8ptr = getelementptr i8, i8* %base, i64 %r8off64
  %r9p = bitcast i8* %r8ptr to i64*
  %r9 = load i64, i64* %r9p, align 8
  %r15off64 = sext i32 %r15off to i64
  %r15ptr = getelementptr i8, i8* %base, i64 %r15off64
  %is32 = icmp eq i32 %edx_z, 32
  %le32 = icmp ule i32 %edx_z, 32
  br i1 %is32, label %case32, label %check_le32

check_le32:
  br i1 %le32, label %case_le32, label %check64

check64:
  %is64 = icmp eq i32 %edx_z, 64
  br i1 %is64, label %case64, label %unknown_bits

case64:
  %val64p = bitcast i8* %r15ptr to i64*
  %val64 = load i64, i64* %val64p, align 8
  %r8int = ptrtoint i8* %r8ptr to i64
  %sub64 = sub i64 %val64, %r8int
  %sum64 = add i64 %sub64, %r9
  %maskc = and i32 %bits32, 192
  store i64 %sum64, i64* %var48, align 8
  %masknz = icmp ne i32 %maskc, 0
  br i1 %masknz, label %do64, label %range64

range64:
  %nonneg = icmp sge i64 %sum64, 0
  br i1 %nonneg, label %range_error, label %do64

do64:
  call void @sub_140001760(i8* %r15ptr)
  %p_var48 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %r15ptr, i8* %p_var48, i32 8)
  br label %loop_back

case32:
  %val32p = bitcast i8* %r15ptr to i32*
  %val32 = load i32, i32* %val32p, align 4
  %val32_sext = sext i32 %val32 to i64
  %r8int2 = ptrtoint i8* %r8ptr to i64
  %sub32 = sub i64 %val32_sext, %r8int2
  %sum32 = add i64 %sub32, %r9
  %maskc32 = and i32 %bits32, 192
  store i64 %sum32, i64* %var48, align 8
  %masknz32 = icmp ne i32 %maskc32, 0
  br i1 %masknz32, label %do32, label %range32

range32:
  %nonneg32 = icmp sge i64 %sum32, 0
  br i1 %nonneg32, label %range_error, label %check_min32

check_min32:
  %min32 = icmp slt i64 %sum32, -2147483648
  br i1 %min32, label %range_error, label %do32

do32:
  call void @sub_140001760(i8* %r15ptr)
  %p_var48b = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %r15ptr, i8* %p_var48b, i32 4)
  br label %loop_back

case_le32:
  %is8 = icmp eq i32 %edx_z, 8
  br i1 %is8, label %case8, label %case16_or_unknown

case16_or_unknown:
  %is16 = icmp eq i32 %edx_z, 16
  br i1 %is16, label %case16, label %unknown_bits

case16:
  %val16p = bitcast i8* %r15ptr to i16*
  %val16 = load i16, i16* %val16p, align 2
  %val16_sext = sext i16 %val16 to i64
  %r8int16 = ptrtoint i8* %r8ptr to i64
  %sub16 = sub i64 %val16_sext, %r8int16
  %sum16 = add i64 %sub16, %r9
  %maskc16 = and i32 %bits32, 192
  store i64 %sum16, i64* %var48, align 8
  %masknz16 = icmp ne i32 %maskc16, 0
  br i1 %masknz16, label %do16, label %range16

range16:
  %gt65535 = icmp sgt i64 %sum16, 65535
  br i1 %gt65535, label %range_error, label %check_min16

check_min16:
  %ltmin16 = icmp slt i64 %sum16, -32768
  br i1 %ltmin16, label %range_error, label %do16

do16:
  call void @sub_140001760(i8* %r15ptr)
  %p_var48c = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %r15ptr, i8* %p_var48c, i32 2)
  br label %loop_back

case8:
  %val8p = bitcast i8* %r15ptr to i8*
  %val8 = load i8, i8* %val8p, align 1
  %val8_sext = sext i8 %val8 to i64
  %r8int8 = ptrtoint i8* %r8ptr to i64
  %sub8 = sub i64 %val8_sext, %r8int8
  %sum8 = add i64 %sub8, %r9
  %maskc8 = and i32 %bits32, 192
  store i64 %sum8, i64* %var48, align 8
  %masknz8 = icmp ne i32 %maskc8, 0
  br i1 %masknz8, label %do8, label %range8

range8:
  %gt255 = icmp sgt i64 %sum8, 255
  br i1 %gt255, label %range_error, label %check_min8

check_min8:
  %ltmin8 = icmp slt i64 %sum8, -128
  br i1 %ltmin8, label %range_error, label %do8

do8:
  call void @sub_140001760(i8* %r15ptr)
  %p_var48d = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %r15ptr, i8* %p_var48d, i32 1)
  br label %loop_back

loop_back:
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 12
  %cont = icmp ult i8* %rbx_next, %endp
  br i1 %cont, label %loop_p1, label %after_loops

unknown_bits:
  %fmt1 = bitcast i8* @aUnknownPseudoR to i8*
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt1)
  unreachable

range_error:
  %fmt2 = bitcast i8* @aDBitPseudoRelo to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt2)
  unreachable

after_loops:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %has = icmp sgt i32 %cnt, 0
  br i1 %has, label %dispatch, label %ret

dispatch:
  %fp = load void (i8*, i8*, i32, i8*)*, void (i8*, i8*, i32, i8*)** @qword_140008290, align 8
  %basearr = load i8*, i8** @qword_1400070A8, align 8
  br label %dispatch_loop

dispatch_loop:
  %i = phi i32 [ 0, %dispatch ], [ %inext, %cont_after_call ]
  %off = mul i32 %i, 40
  %off64 = sext i32 %off to i64
  %item = getelementptr i8, i8* %basearr, i64 %off64
  %typep = bitcast i8* %item to i32*
  %type = load i32, i32* %typep, align 4
  %iszero = icmp eq i32 %type, 0
  br i1 %iszero, label %skip_call, label %do_call

do_call:
  %rcxp = getelementptr i8, i8* %item, i64 8
  %rcxvalp = bitcast i8* %rcxp to i8**
  %rcxval = load i8*, i8** %rcxvalp, align 8
  %rdxp = getelementptr i8, i8* %item, i64 16
  %rdxvalp = bitcast i8* %rdxp to i8**
  %rdxval = load i8*, i8** %rdxvalp, align 8
  %arg3 = alloca i64, align 8
  %arg3p = bitcast i64* %arg3 to i8*
  call void %fp(i8* %rcxval, i8* %rdxval, i32 %type, i8* %arg3p)
  br label %cont_after_call

skip_call:
  br label %cont_after_call

cont_after_call:
  %inext = add i32 %i, 1
  %cmp_loop = icmp slt i32 %inext, %cnt
  br i1 %cmp_loop, label %dispatch_loop, label %ret

proto2_hdr:
  %p2h0p = bitcast i8* %begp to i32*
  %p2h0 = load i32, i32* %p2h0p, align 4
  %p2h0z = icmp eq i32 %p2h0, 0
  br i1 %p2h0z, label %p2hdr1, label %proto2_AFD

p2hdr1:
  %p2h1p = getelementptr i8, i8* %begp, i64 4
  %p2h1pi = bitcast i8* %p2h1p to i32*
  %p2h1 = load i32, i32* %p2h1pi, align 4
  %p2h1z = icmp eq i32 %p2h1, 0
  br i1 %p2h1z, label %p2hdr2, label %proto2_AFD

p2hdr2:
  %p2h2p = getelementptr i8, i8* %begp, i64 8
  %p2h2pi = bitcast i8* %p2h2p to i32*
  %p2h2 = load i32, i32* %p2h2pi, align 4
  %p2h2nz = icmp ne i32 %p2h2, 0
  br i1 %p2h2nz, label %p1hdr2, label %p2hdr_done

p2hdr_done:
  %rbx2 = getelementptr i8, i8* %begp, i64 12
  %ge2 = icmp uge i8* %rbx2, %endp
  br i1 %ge2, label %ret, label %proto2_AFD_start_from_done

proto2_AFD:
  %ge = icmp uge i8* %begp, %endp
  br i1 %ge, label %ret, label %proto2_AFD_start

proto2_AFD_start_from_done:
  %base2a = load i8*, i8** @off_1400043C0, align 8
  %var48b_a = alloca i64, align 8
  br label %p2body

proto2_AFD_start:
  %base2 = load i8*, i8** @off_1400043C0, align 8
  %var48b = alloca i64, align 8
  br label %p2body

p2body:
  %rbx_phi = phi i8* [ %rbx2, %proto2_AFD_start_from_done ], [ %begp, %proto2_AFD ], [ %rbx_next, %p2body ]
  %base_sel = phi i8* [ %base2a, %proto2_AFD_start_from_done ], [ %base2, %proto2_AFD ], [ %base_sel, %p2body ]
  %var48_sel = phi i64* [ %var48b_a, %proto2_AFD_start_from_done ], [ %var48b, %proto2_AFD ], [ %var48_sel, %p2body ]
  %off_p = getelementptr i8, i8* %rbx_phi, i64 4
  %off_p32 = bitcast i8* %off_p to i32*
  %off_val = load i32, i32* %off_p32, align 4
  %addp32 = bitcast i8* %rbx_phi to i32*
  %add_val = load i32, i32* %addp32, align 4
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 8
  %off64 = sext i32 %off_val to i64
  %addr = getelementptr i8, i8* %base_sel, i64 %off64
  %addr_i32p = bitcast i8* %addr to i32*
  %mem32 = load i32, i32* %addr_i32p, align 4
  %sum32b = add i32 %add_val, %mem32
  %sum32b_sext = sext i32 %sum32b to i64
  store i64 %sum32b_sext, i64* %var48_sel, align 8
  call void @sub_140001760(i8* %addr)
  %p_var48e = bitcast i64* %var48_sel to i8*
  call void @sub_1400027B8(i8* %addr, i8* %p_var48e, i32 4)
  %cont2 = icmp ult i8* %rbx_next, %endp
  br i1 %cont2, label %p2body, label %after_loops

unknown_proto:
  %fmt3 = bitcast i8* @aUnknownPseudoR_0 to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt3)
  unreachable

ret:
  ret void
}
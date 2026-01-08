; ModuleID = 'sub_1400018D0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*

@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare i64 @sub_140002520(i64)
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare void @sub_140001700(i8*)

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %var48 = alloca i64, align 8
  %var50 = alloca [1 x i8], align 8
  %t0 = load i32, i32* @dword_1400070A0, align 4
  %t1 = icmp eq i32 %t0, 0
  br i1 %t1, label %init, label %exit

init:                                             ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %c0 = call i32 @sub_1400022D0()
  %c0ext = sext i32 %c0 to i64
  %mul5 = mul i64 %c0ext, 5
  %mul8 = shl i64 %mul5, 3
  %add15 = add i64 %mul8, 15
  %align = and i64 %add15, -16
  %allocsz = call i64 @sub_140002520(i64 %align)
  %dyn = alloca i8, i64 %allocsz, align 16
  %off_end = load i8*, i8** @off_1400043D0, align 8
  %off_beg = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var50.ptr = getelementptr inbounds [1 x i8], [1 x i8]* %var50, i64 0, i64 0
  store i8* %var50.ptr, i8** @qword_1400070A8, align 8
  %endint = ptrtoint i8* %off_end to i64
  %begint = ptrtoint i8* %off_beg to i64
  %delta = sub i64 %endint, %begint
  %cmp7 = icmp sle i64 %delta, 7
  br i1 %cmp7, label %exit, label %checkRange

checkRange:                                       ; preds = %init
  %cmp11 = icmp sgt i64 %delta, 11
  br i1 %cmp11, label %ver2, label %ver1hdr

ver1hdr:                                          ; preds = %checkRange
  %off_beg_i32p = bitcast i8* %off_beg to i32*
  %v1_hdr0 = load i32, i32* %off_beg_i32p, align 4
  %v1_hdr0_nz = icmp ne i32 %v1_hdr0, 0
  br i1 %v1_hdr0_nz, label %afdbad, label %v1_hdr1

v1_hdr1:                                          ; preds = %ver1hdr
  %beg_p4 = getelementptr i8, i8* %off_beg, i64 4
  %beg_p4_i32p = bitcast i8* %beg_p4 to i32*
  %v1_hdr1v = load i32, i32* %beg_p4_i32p, align 4
  %v1_hdr1_nz = icmp ne i32 %v1_hdr1v, 0
  br i1 %v1_hdr1_nz, label %afdbad, label %v1_hdr2

v1_hdr2:                                          ; preds = %v1_hdr1
  %beg_p8 = getelementptr i8, i8* %off_beg, i64 8
  %beg_p8_i32p = bitcast i8* %beg_p8 to i32*
  %v1_hdr2v = load i32, i32* %beg_p8_i32p, align 4
  %v1_proto_ok = icmp eq i32 %v1_hdr2v, 1
  br i1 %v1_proto_ok, label %ver1_afterhdr, label %proto_unknown

ver1_afterhdr:                                    ; preds = %v1_hdr2
  %rbx_after = getelementptr i8, i8* %off_beg, i64 12
  %r14 = load i8*, i8** @off_1400043C0, align 8
  %r12 = bitcast i64* %var48 to i8*
  %rbx_int = ptrtoint i8* %rbx_after to i64
  %lt_end = icmp slt i64 %rbx_int, %endint
  br i1 %lt_end, label %ver1_loop_entry, label %exit

ver1_loop_entry:                                  ; preds = %ver1_afterhdr
  br label %exit

ver2:                                             ; preds = %checkRange
  %off_beg_i32p.v2 = bitcast i8* %off_beg to i32*
  %v2_0 = load i32, i32* %off_beg_i32p.v2, align 4
  %v2_0_nz = icmp ne i32 %v2_0, 0
  br i1 %v2_0_nz, label %afdbad, label %v2_chk1

v2_chk1:                                          ; preds = %ver2
  %beg_p4v2 = getelementptr i8, i8* %off_beg, i64 4
  %beg_p4v2_i32p = bitcast i8* %beg_p4v2 to i32*
  %v2_1 = load i32, i32* %beg_p4v2_i32p, align 4
  %v2_1_nz = icmp ne i32 %v2_1, 0
  br i1 %v2_1_nz, label %ver2_loop, label %ver2_c17

ver2_c17:                                         ; preds = %v2_chk1
  %beg_p8v2 = getelementptr i8, i8* %off_beg, i64 8
  %beg_p8v2_i32p = bitcast i8* %beg_p8v2 to i32*
  %ecx_v = load i32, i32* %beg_p8v2_i32p, align 4
  %ecx_nz = icmp ne i32 %ecx_v, 0
  br i1 %ecx_nz, label %proto_unknown_1978, label %v1hdr_restart

v1hdr_restart:                                    ; preds = %ver2_c17
  %rbx12 = getelementptr i8, i8* %off_beg, i64 12
  %rbx12_i32p = bitcast i8* %rbx12 to i32*
  %v1r0 = load i32, i32* %rbx12_i32p, align 4
  %v1r0nz = icmp ne i32 %v1r0, 0
  br i1 %v1r0nz, label %afdbad, label %v1r1chk

v1r1chk:                                          ; preds = %v1hdr_restart
  %rbx12p4 = getelementptr i8, i8* %rbx12, i64 4
  %rbx12p4_i32p = bitcast i8* %rbx12p4 to i32*
  %v1r1 = load i32, i32* %rbx12p4_i32p, align 4
  %v1r1nz = icmp ne i32 %v1r1, 0
  br i1 %v1r1nz, label %afdbad, label %v1r2chk

v1r2chk:                                          ; preds = %v1r1chk
  %rbx12p8 = getelementptr i8, i8* %rbx12, i64 8
  %rbx12p8_i32p = bitcast i8* %rbx12p8 to i32*
  %v1r2 = load i32, i32* %rbx12p8_i32p, align 4
  %v1r2ok = icmp eq i32 %v1r2, 1
  br i1 %v1r2ok, label %exit, label %proto_unknown

ver2_loop:                                        ; preds = %v2_chk1
  br label %exit

afdbad:                                           ; preds = %v1r1chk, %v1hdr_restart, %ver2, %v1_hdr1, %ver1hdr
  br label %exit

proto_unknown:                                    ; preds = %v1r2chk, %v1_hdr2
  call void @sub_140001700(i8* @aUnknownPseudoR_0)
  br label %exit

proto_unknown_1978:                               ; preds = %ver2_c17
  br label %exit

exit:                                             ; preds = %proto_unknown_1978, %proto_unknown, %afdbad, %ver2_loop, %v1r2chk, %ver1_loop_entry, %ver1_afterhdr, %init, %entry
  ret void
}
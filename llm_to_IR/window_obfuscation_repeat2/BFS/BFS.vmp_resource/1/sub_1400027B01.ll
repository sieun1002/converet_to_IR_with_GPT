; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_1400027B0(i64 %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mzval = load i16, i16* %mzptr, align 2
  %isMZ = icmp eq i16 %mzval, 23117
  br i1 %isMZ, label %checkPE, label %ret0

checkPE:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %sig_ptr, align 4
  %isPE = icmp eq i32 %pe_sig, 17744
  br i1 %isPE, label %checkMagic, label %ret0

checkMagic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %isPE32Plus = icmp eq i16 %magic, 523
  br i1 %isPE32Plus, label %readSections, label %ret0

readSections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 2
  %hasSections = icmp ne i16 %numsec, 0
  br i1 %hasSections, label %setupLoop, label %ret0

setupLoop:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 2
  %soh_zext_i64 = zext i16 %soh to i64
  %first_sect_offset = add i64 %soh_zext_i64, 24
  %first_sect_ptr = getelementptr i8, i8* %nt_ptr, i64 %first_sect_offset
  %numsec_i32 = zext i16 %numsec to i32
  %numsec_minus1 = add i32 %numsec_i32, -1
  %mul5 = mul i32 %numsec_minus1, 5
  %mul5_i64 = zext i32 %mul5 to i64
  %scaled = shl i64 %mul5_i64, 3
  %end_offset = add i64 %scaled, 40
  %end_ptr = getelementptr i8, i8* %first_sect_ptr, i64 %end_offset
  br label %loop

loop:
  %curptr = phi i8* [ %first_sect_ptr, %setupLoop ], [ %next_ptr, %advance_or_flagged_cont ]
  %rem = phi i64 [ %rcx, %setupLoop ], [ %rem_next, %advance_or_flagged_cont ]
  %char_byte_ptr = getelementptr i8, i8* %curptr, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %masked = and i8 %char_byte, 32
  %isFlagged = icmp ne i8 %masked, 0
  br i1 %isFlagged, label %if_flagged, label %advance

if_flagged:
  %rem_is_zero = icmp eq i64 %rem, 0
  br i1 %rem_is_zero, label %ret0, label %decrement

decrement:
  %rem_dec = add i64 %rem, -1
  br label %advance_cont

advance:
  br label %advance_cont

advance_cont:
  %rem_next = phi i64 [ %rem_dec, %decrement ], [ %rem, %advance ]
  %next_ptr = getelementptr i8, i8* %curptr, i64 40
  %cmp_end = icmp ne i8* %next_ptr, %end_ptr
  br i1 %cmp_end, label %advance_or_flagged_cont, label %exit

advance_or_flagged_cont:
  br label %loop

exit:
  ret i32 0

ret0:
  ret i32 0
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002790(i8* %rcx) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nthdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %after_magic, label %ret_zero

after_magic:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_is_zero = icmp eq i32 %numsec32, 0
  br i1 %numsec_is_zero, label %ret_zero, label %sections_prep

sections_prep:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %offs = add i64 %soh64, 24
  %startsec = getelementptr inbounds i8, i8* %nthdr, i64 %offs
  %numsec_minus1 = add i32 %numsec32, -1
  %mul5 = mul i32 %numsec_minus1, 5
  %mul5_zext64 = zext i32 %mul5 to i64
  %times8 = shl i64 %mul5_zext64, 3
  %end_offset = add i64 %times8, 40
  %sections_end = getelementptr inbounds i8, i8* %startsec, i64 %end_offset
  br label %loop

loop:
  %curr = phi i8* [ %startsec, %sections_prep ], [ %next, %loop_next ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %lt_start = icmp ult i64 %rva, %va64
  br i1 %lt_start, label %loop_next, label %check_upper

check_upper:
  %size_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 8
  %size_ptr = bitcast i8* %size_ptr_i8 to i32*
  %size32 = load i32, i32* %size_ptr, align 1
  %sum32 = add i32 %va32, %size32
  %sum64 = zext i32 %sum32 to i64
  %lt_end = icmp ult i64 %rva, %sum64
  br i1 %lt_end, label %found, label %loop_next

loop_next:
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  %done = icmp eq i8* %next, %sections_end
  br i1 %done, label %ret_zero, label %loop

found:
  %chr_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 36
  %chr_ptr = bitcast i8* %chr_ptr_i8 to i32*
  %chr = load i32, i32* %chr_ptr, align 1
  %not = xor i32 %chr, -1
  %shr = lshr i32 %not, 31
  ret i32 %shr

ret_zero:
  ret i32 0
}
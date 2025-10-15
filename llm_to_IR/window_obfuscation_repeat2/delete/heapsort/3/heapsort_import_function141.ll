; ModuleID = 'pe_section_check'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %rcx) {
entry:
  %baseptr.addr = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %baseptr.addr to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %calc_nt, label %ret0

calc_nt:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %baseptr.addr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr_ptr = getelementptr i8, i8* %baseptr.addr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_hdr_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %cmp_pe = icmp eq i32 %sig, 17744
  br i1 %cmp_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr.i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret0

check_sections:
  %numsec_ptr.i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numzero = icmp eq i16 %numsec, 0
  br i1 %numzero, label %ret0, label %prep_loop

prep_loop:
  %opt_size_ptr.i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr.i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 1
  %opt_size64 = zext i16 %opt_size16 to i64
  %after_filehdr = getelementptr i8, i8* %nt_hdr_ptr, i64 24
  %first_sec = getelementptr i8, i8* %after_filehdr, i64 %opt_size64
  %numsec64 = zext i16 %numsec to i64
  %total_secs_size = mul i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %first_sec, i64 %total_secs_size
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr.addr to i64
  %rva = sub i64 %rcx_int, %base_int
  br label %loop

loop:
  %sec.cur = phi i8* [ %first_sec, %prep_loop ], [ %next_sec, %loop_advance ]
  %va_ptr.i8 = getelementptr i8, i8* %sec.cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_advance, label %check_within

check_within:
  %vsize_ptr.i8 = getelementptr i8, i8* %sec.cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %inrange = icmp ult i64 %rva, %end64
  br i1 %inrange, label %ret0, label %loop_advance

loop_advance:
  %next_sec = getelementptr i8, i8* %sec.cur, i64 40
  %done = icmp eq i8* %next_sec, %end_ptr
  br i1 %done, label %final_ret, label %loop

ret0:
  ret i32 0

final_ret:
  ret i32 0
}
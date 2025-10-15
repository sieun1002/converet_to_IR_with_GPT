; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_1400026F0(i8* %rcx_param) local_unnamed_addr {
entry:
  %base_ptr_ptr = bitcast i8** @off_1400043C0 to i8**
  %base_ptr = load i8*, i8** @off_1400043C0, align 8

  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew64

  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_numsec, label %ret0

check_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %prepare_loop

prepare_loop:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64

  %rcx_int = ptrtoint i8* %rcx_param to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %rcx_int, %base_int

  %sec_start_pre = getelementptr i8, i8* %nt_ptr, i64 24
  %sec_start = getelementptr i8, i8* %sec_start_pre, i64 %sizeopt64

  %numsec64 = zext i16 %numsec16 to i64
  %mul40 = mul i64 %numsec64, 40
  %sec_end = getelementptr i8, i8* %sec_start, i64 %mul40
  br label %loop

loop:
  %cur = phi i8* [ %sec_start, %prepare_loop ], [ %next, %latch ]

  %done = icmp eq i8* %cur, %sec_end
  br i1 %done, label %ret0, label %check_section

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %latch, label %check_range

check_range:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %end_rva = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %end_rva
  br i1 %in_range, label %ret0, label %latch

latch:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}
; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_1400026F0(i8* %rcx) {
entry:
  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_nt, label %ret0

check_nt:
  %off3C = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %off3C to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew_z
  %sigptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigptr, align 4
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %isPE32p = icmp eq i16 %magic, 523
  br i1 %isPE32p, label %check_sections, label %ret0

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %calc_sec_tbl

calc_sec_tbl:
  %opt_size_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 2
  %opt_size64 = zext i16 %opt_size16 to i64
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %base_i64 = ptrtoint i8* %base to i64
  %rva = sub i64 %rcx_i64, %base_i64
  %sec_start_off = add i64 %opt_size64, 24
  %sec_start = getelementptr i8, i8* %nt, i64 %sec_start_off
  %numsec64 = zext i16 %numsec16 to i64
  %size_all = mul i64 %numsec64, 40
  %sec_end = getelementptr i8, i8* %sec_start, i64 %size_all
  br label %loop

loop:
  %cur = phi i8* [ %sec_start, %calc_sec_tbl ], [ %next, %loop_cont ]
  %at_end = icmp eq i8* %cur, %sec_end
  br i1 %at_end, label %after_loop, label %loop_body

loop_body:
  %vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vsize = load i32, i32* %vs_ptr, align 4
  %vsize64 = zext i32 %vsize to i64
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %vaddr = load i32, i32* %va_ptr, align 4
  %vaddr64 = zext i32 %vaddr to i64
  %lt_va = icmp ult i64 %rva, %vaddr64
  br i1 %lt_va, label %loop_cont, label %check_in

check_in:
  %end_rva = add i64 %vaddr64, %vsize64
  %inrng = icmp ult i64 %rva, %end_rva
  br i1 %inrng, label %ret0, label %loop_cont

loop_cont:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

after_loop:
  ret i32 0

ret0:
  ret i32 0
}
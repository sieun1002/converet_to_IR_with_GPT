; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16p = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16p, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_nt, label %ret0

check_nt:
  %p_3c = getelementptr i8, i8* %baseptr, i64 60
  %p_3c_i32p = bitcast i8* %p_3c to i32*
  %e_lfanew32 = load i32, i32* %p_3c_i32p, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_sections, label %ret0

load_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %calc_section_start

calc_section_start:
  %size_opt_ptr_i8 = getelementptr i8, i8* %nthdr, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr_i8 to i16*
  %size_opt = load i16, i16* %size_opt_ptr, align 1
  %size_opt_zext = zext i16 %size_opt to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_minus1 = add i32 %numsec32, 4294967295
  %t_mul5 = mul i32 %numsec_minus1, 5
  %sec_start_off = add i64 %size_opt_zext, 24
  %sec_start = getelementptr i8, i8* %nthdr, i64 %sec_start_off
  %t_mul5_zext64 = zext i32 %t_mul5 to i64
  %rdx_times8 = shl i64 %t_mul5_zext64, 3
  %end_off = add i64 %rdx_times8, 40
  %sec_end = getelementptr i8, i8* %sec_start, i64 %end_off
  br label %loop

loop:
  %cur = phi i8* [ %sec_start, %calc_section_start ], [ %cur_next, %loop_continue ]
  %at_end = icmp eq i8* %cur, %sec_end
  br i1 %at_end, label %after_loop, label %process

process:
  %vaddr_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %vaddr_ptr = bitcast i8* %vaddr_ptr_i8 to i32*
  %vaddr_i32 = load i32, i32* %vaddr_ptr, align 1
  %vaddr_z64 = zext i32 %vaddr_i32 to i64
  %cond1 = icmp ult i64 %rva, %vaddr_z64
  br i1 %cond1, label %loop_continue, label %check_second

check_second:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize_i32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %vaddr_i32, %vsize_i32
  %sum64 = zext i32 %sum32 to i64
  %cond2 = icmp ult i64 %rva, %sum64
  br i1 %cond2, label %ret0, label %loop_continue

loop_continue:
  %cur_next = getelementptr i8, i8* %cur, i64 40
  br label %loop

after_loop:
  br label %ret0

ret0:
  ret i32 0
}
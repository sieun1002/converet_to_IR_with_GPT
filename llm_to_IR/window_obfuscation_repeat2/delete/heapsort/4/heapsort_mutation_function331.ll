; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i8* @sub_140002820(i64 %rva, i32 %index) local_unnamed_addr nounwind {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %base, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_dir, label %ret0

check_dir:
  %dir_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir_val = load i32, i32* %dir_ptr, align 4
  %dir_zero = icmp eq i32 %dir_val, 0
  br i1 %dir_zero, label %ret0, label %check_sections

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec_val16 = load i16, i16* %numsec_ptr, align 2
  %numsec_zero = icmp eq i16 %numsec_val16, 0
  br i1 %numsec_zero, label %ret0, label %setup_sections

setup_sections:
  %szopt_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr_i8 to i16*
  %szopt_val16 = load i16, i16* %szopt_ptr, align 2
  %szopt_zext = zext i16 %szopt_val16 to i64
  %first_sect_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %sections_start = getelementptr i8, i8* %first_sect_ptr_i8, i64 %szopt_zext
  %numsec_i32 = zext i16 %numsec_val16 to i32
  %numsec_minus1 = add i32 %numsec_i32, -1
  %numsec_minus1_i64 = sext i32 %numsec_minus1 to i64
  %mul4 = mul i64 %numsec_minus1_i64, 4
  %sum5 = add i64 %mul4, %numsec_minus1_i64
  %mul8 = mul i64 %sum5, 8
  %plus_mul8 = getelementptr i8, i8* %sections_start, i64 %mul8
  %r10_end = getelementptr i8, i8* %plus_mul8, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %sections_start, %setup_sections ], [ %next, %loop_advance ]
  %va_ptr = getelementptr i8, i8* %cur, i64 12
  %va_i32ptr = bitcast i8* %va_ptr to i32*
  %va = load i32, i32* %va_i32ptr, align 4
  %va_zext64 = zext i32 %va to i64
  %cmp_below = icmp ult i64 %rva, %va_zext64
  br i1 %cmp_below, label %loop_advance, label %check_in_section

check_in_section:
  %vsize_ptr = getelementptr i8, i8* %cur, i64 8
  %vsize_i32ptr = bitcast i8* %vsize_ptr to i32*
  %vsize = load i32, i32* %vsize_i32ptr, align 4
  %va_plus_vsize_i32 = add i32 %va, %vsize
  %va_plus_vsize = zext i32 %va_plus_vsize_i32 to i64
  %inrange = icmp ult i64 %rva, %va_plus_vsize
  br i1 %inrange, label %found_section, label %loop_advance

loop_advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %cmp_end = icmp ne i8* %r10_end, %next
  br i1 %cmp_end, label %loop, label %ret0

found_section:
  %addr = getelementptr i8, i8* %base, i64 %rva
  br label %scan

scan:
  %curaddr = phi i8* [ %addr, %found_section ], [ %next_entry, %advance_entry ]
  %idx = phi i32 [ %index, %found_section ], [ %idx_dec, %advance_entry ]
  %field4_ptr = getelementptr i8, i8* %curaddr, i64 4
  %field4_i32ptr = bitcast i8* %field4_ptr to i32*
  %field4 = load i32, i32* %field4_i32ptr, align 4
  %field4_nonzero = icmp ne i32 %field4, 0
  br i1 %field4_nonzero, label %test_index, label %check_fieldC

check_fieldC:
  %fieldC_ptr = getelementptr i8, i8* %curaddr, i64 12
  %fieldC_i32ptr = bitcast i8* %fieldC_ptr to i32*
  %fieldC = load i32, i32* %fieldC_i32ptr, align 4
  %fieldC_zero = icmp eq i32 %fieldC, 0
  br i1 %fieldC_zero, label %ret0, label %test_index

test_index:
  %gt0 = icmp sgt i32 %idx, 0
  br i1 %gt0, label %advance_entry, label %final_return

advance_entry:
  %idx_dec = add i32 %idx, -1
  %next_entry = getelementptr i8, i8* %curaddr, i64 20
  br label %scan

final_return:
  %fieldC_ptr_fr = getelementptr i8, i8* %curaddr, i64 12
  %fieldC_i32ptr_fr = bitcast i8* %fieldC_ptr_fr to i32*
  %fieldC2 = load i32, i32* %fieldC_i32ptr_fr, align 4
  %fieldC_zext = zext i32 %fieldC2 to i64
  %retptr = getelementptr i8, i8* %base, i64 %fieldC_zext
  ret i8* %retptr

ret0:
  ret i8* null
}
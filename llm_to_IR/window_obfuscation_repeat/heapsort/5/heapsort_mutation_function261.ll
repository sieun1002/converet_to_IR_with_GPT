; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i32 %rva) local_unnamed_addr nounwind {
entry:
  %e_lfanew_ptr = getelementptr i8, i8* %base, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr i8, i8* %base, i64 %e_lfanew64
  %numsec_ptr = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec_i16ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %is_zero = icmp eq i32 %numsec32, 0
  br i1 %is_zero, label %ret_zero, label %have_sections

have_sections:
  %sizeopt_ptr = getelementptr i8, i8* %nt_ptr, i64 20
  %sizeopt_i16ptr = bitcast i8* %sizeopt_ptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt_i16ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %filehdr_end = getelementptr i8, i8* %nt_ptr, i64 24
  %first_section = getelementptr i8, i8* %filehdr_end, i64 %sizeopt64
  %numsec64 = zext i16 %numsec16 to i64
  %nbytes = mul i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %first_section, i64 %nbytes
  br label %loop

loop:
  %cur = phi i8* [ %first_section, %have_sections ], [ %next, %loop_continue ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %rva_lt_va = icmp ult i32 %rva, %va
  br i1 %rva_lt_va, label %loop_continue, label %check_upper

check_upper:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %sum = add i32 %va, %vsize
  %in_range = icmp ult i32 %rva, %sum
  br i1 %in_range, label %found, label %loop_continue

loop_continue:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_ptr
  br i1 %done, label %ret_zero, label %loop

found:
  ret i8* %cur

ret_zero:
  ret i8* null
}
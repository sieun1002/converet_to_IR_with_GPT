; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %pe_off_ptr.i8 = getelementptr i8, i8* %base, i64 60
  %pe_off_ptr = bitcast i8* %pe_off_ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %pe_off_ptr, align 4
  %e_lfanew = sext i32 %e_lfanew.i32 to i64
  %nt_ptr = getelementptr i8, i8* %base, i64 %e_lfanew

  %numsec_ptr.i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_zero, label %cont

ret_zero:
  ret i8* null

cont:
  %soh_ptr.i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr.i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh = zext i16 %soh16 to i64
  %start_off = add i64 %soh, 24
  %start = getelementptr i8, i8* %nt_ptr, i64 %start_off

  %numsec64 = zext i16 %numsec16 to i64
  %total_bytes = mul i64 %numsec64, 40
  %end = getelementptr i8, i8* %start, i64 %total_bytes
  br label %loop

loop:
  %curr = phi i8* [ %start, %cont ], [ %next, %loop_continue ]
  %at_end = icmp eq i8* %curr, %end
  br i1 %at_end, label %ret_zero2, label %check

ret_zero2:
  ret i8* null

check:
  %va_ptr.i8 = getelementptr i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_continue, label %after_ge

after_ge:
  %vs_ptr.i8 = getelementptr i8, i8* %curr, i64 8
  %vs_ptr = bitcast i8* %vs_ptr.i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 4
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %sum64
  br i1 %in_range, label %found, label %loop_continue

found:
  ret i8* %curr

loop_continue:
  %next = getelementptr i8, i8* %curr, i64 40
  br label %loop
}
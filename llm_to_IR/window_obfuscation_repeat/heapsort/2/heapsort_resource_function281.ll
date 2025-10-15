; ModuleID = 'pe_section_find'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %dos_e_lfanew_ptr.i8 = getelementptr i8, i8* %base, i64 60
  %dos_e_lfanew_ptr = bitcast i8* %dos_e_lfanew_ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %dos_e_lfanew_ptr, align 4
  %e_lfanew.i64 = zext i32 %e_lfanew.i32 to i64
  %pe_ptr = getelementptr i8, i8* %base, i64 %e_lfanew.i64
  %numsec_ptr.i8 = getelementptr i8, i8* %pe_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec.i16 = load i16, i16* %numsec_ptr, align 2
  %numsec.nonzero = icmp ne i16 %numsec.i16, 0
  br i1 %numsec.nonzero, label %nonzero, label %return_zero

nonzero:
  %sizeopt_ptr.i8 = getelementptr i8, i8* %pe_ptr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr.i8 to i16*
  %sizeopt.i16 = load i16, i16* %sizeopt_ptr, align 2
  %sizeopt.i64 = zext i16 %sizeopt.i16 to i64
  %sectable.off = add i64 %sizeopt.i64, 24
  %sectable = getelementptr i8, i8* %pe_ptr, i64 %sectable.off
  %numsec.i64 = zext i16 %numsec.i16 to i64
  %nbytes = mul nuw i64 %numsec.i64, 40
  %end_ptr = getelementptr i8, i8* %sectable, i64 %nbytes
  br label %loop

loop:
  %curr = phi i8* [ %sectable, %nonzero ], [ %next, %loop_continue ]
  %va_ptr.i8 = getelementptr i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va.i32 = load i32, i32* %va_ptr, align 4
  %va.i64 = zext i32 %va.i32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va.i64
  br i1 %rva.lt.va, label %loop_continue, label %check_end

check_end:
  %vsize_ptr.i8 = getelementptr i8, i8* %curr, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize_ptr, align 4
  %end.i32 = add i32 %va.i32, %vsize.i32
  %end.i64 = zext i32 %end.i32 to i64
  %in.range = icmp ult i64 %rva, %end.i64
  br i1 %in.range, label %ret_curr, label %loop_continue

loop_continue:
  %next = getelementptr i8, i8* %curr, i64 40
  %cmp_end = icmp ne i8* %next, %end_ptr
  br i1 %cmp_end, label %loop, label %return_zero

ret_curr:
  ret i8* %curr

return_zero:
  ret i8* null
}
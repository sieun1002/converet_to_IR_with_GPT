; ModuleID = 'pe_section_lookup'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %base_gep_3c = getelementptr i8, i8* %base, i64 60
  %efl_ptr = bitcast i8* %base_gep_3c to i32*
  %efl = load i32, i32* %efl_ptr, align 1
  %efl_sext = sext i32 %efl to i64
  %pehdr_ptr = getelementptr i8, i8* %base, i64 %efl_sext
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec = zext i16 %numsec16 to i32
  %numsec_is_zero = icmp eq i32 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %cont

ret_zero:
  ret i8* null

cont:
  %soh_ptr_i8 = getelementptr i8, i8* %pehdr_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %start_i8_18 = getelementptr i8, i8* %pehdr_ptr, i64 24
  %start = getelementptr i8, i8* %start_i8_18, i64 %soh
  %numsec64 = zext i32 %numsec to i64
  %numsec_mul_40 = mul nuw i64 %numsec64, 40
  %end = getelementptr i8, i8* %start, i64 %numsec_mul_40
  br label %loop

loop:
  %curr = phi i8* [ %start, %cont ], [ %next, %loop_cont ]
  %done = icmp eq i8* %curr, %end
  br i1 %done, label %ret_zero2, label %check_section

ret_zero2:
  ret i8* null

check_section:
  %va_ptr_i8 = getelementptr i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_cont, label %check_end

loop_cont:
  %next = getelementptr i8, i8* %curr, i64 40
  br label %loop

check_end:
  %size_ptr_i8 = getelementptr i8, i8* %curr, i64 8
  %size_ptr = bitcast i8* %size_ptr_i8 to i32*
  %size = load i32, i32* %size_ptr, align 1
  %endv32 = add i32 %va, %size
  %endv64 = zext i32 %endv32 to i64
  %rva_lt_end = icmp ult i64 %rva, %endv64
  br i1 %rva_lt_end, label %ret_curr, label %loop_cont

ret_curr:
  ret i8* %curr
}
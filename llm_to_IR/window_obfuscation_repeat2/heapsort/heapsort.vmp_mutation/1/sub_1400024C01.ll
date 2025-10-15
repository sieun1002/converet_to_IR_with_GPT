; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_1400024C0(i8* %rcx, i64 %rdx) {
entry:
  %e_lfanew_ptr = getelementptr i8, i8* %rcx, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew = sext i32 %e_lfanew_i32 to i64
  %nt_ptr = getelementptr i8, i8* %rcx, i64 %e_lfanew
  %ns_ptr = getelementptr i8, i8* %nt_ptr, i64 6
  %ns_i16ptr = bitcast i8* %ns_ptr to i16*
  %ns_i16 = load i16, i16* %ns_i16ptr, align 2
  %ns_is_zero = icmp eq i16 %ns_i16, 0
  br i1 %ns_is_zero, label %ret_zero, label %not_zero

ret_zero:
  ret i8* null

not_zero:
  %soh_ptr = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_i16ptr = bitcast i8* %soh_ptr to i16*
  %soh_i16 = load i16, i16* %soh_i16ptr, align 2
  %soh_i64 = zext i16 %soh_i16 to i64
  %base_plus_24 = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sec = getelementptr i8, i8* %base_plus_24, i64 %soh_i64
  %ns_i64 = zext i16 %ns_i16 to i64
  %ns_minus1 = add i64 %ns_i64, -1
  %mul5 = mul i64 %ns_minus1, 5
  %mul5x8 = shl i64 %mul5, 3
  %after_scaled = getelementptr i8, i8* %first_sec, i64 %mul5x8
  %r9 = getelementptr i8, i8* %after_scaled, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %not_zero ], [ %next, %advance ]
  %cur_va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %cur_va_ptr = bitcast i8* %cur_va_ptr_i8 to i32*
  %va_i32 = load i32, i32* %cur_va_ptr, align 4
  %va_i64 = zext i32 %va_i32 to i64
  %rdx_lt_va = icmp ult i64 %rdx, %va_i64
  br i1 %rdx_lt_va, label %advance, label %check_end

check_end:
  %cur_vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %cur_vs_ptr = bitcast i8* %cur_vs_ptr_i8 to i32*
  %vs_i32 = load i32, i32* %cur_vs_ptr, align 4
  %vs_i64 = zext i32 %vs_i32 to i64
  %end_i64 = add i64 %va_i64, %vs_i64
  %in_range = icmp ult i64 %rdx, %end_i64
  br i1 %in_range, label %ret_cur, label %advance

ret_cur:
  ret i8* %cur

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %at_end = icmp eq i8* %next, %r9
  br i1 %at_end, label %ret_zero2, label %loop

ret_zero2:
  ret i8* null
}
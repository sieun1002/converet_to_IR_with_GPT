; ModuleID = 'sub_140002520'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %e_lfanew_ptr = getelementptr i8, i8* %rcx, i64 60
  %e_lfanew_ptr_i32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr_i32
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %rcx, i64 %e_lfanew_sext
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_zero, label %has_sections

has_sections:                                      ; preds = %entry
  %opthdr_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %opthdr_ptr = bitcast i8* %opthdr_ptr_i8 to i16*
  %opthdr16 = load i16, i16* %opthdr_ptr
  %opthdr64 = zext i16 %opthdr16 to i64
  %base_sec_off = add i64 %opthdr64, 24
  %sec_base = getelementptr i8, i8* %nt_ptr, i64 %base_sec_off
  %numsec64 = zext i16 %numsec16 to i64
  %count_bytes = mul nuw i64 %numsec64, 40
  %sec_end = getelementptr i8, i8* %sec_base, i64 %count_bytes
  br label %loop

loop:                                              ; preds = %advance, %has_sections
  %cur = phi i8* [ %sec_base, %has_sections ], [ %next, %advance ]
  %at_end = icmp eq i8* %cur, %sec_end
  br i1 %at_end, label %ret_zero, label %check_va

check_va:                                          ; preds = %loop
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr
  %va64 = zext i32 %va32 to i64
  %rdx_lt_va = icmp ult i64 %rdx, %va64
  br i1 %rdx_lt_va, label %advance, label %check_in

check_in:                                          ; preds = %check_va
  %sz_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %sz_ptr = bitcast i8* %sz_ptr_i8 to i32*
  %sz32 = load i32, i32* %sz_ptr
  %sum32 = add i32 %va32, %sz32
  %sum64 = zext i32 %sum32 to i64
  %rdx_lt_sum = icmp ult i64 %rdx, %sum64
  br i1 %rdx_lt_sum, label %ret_found, label %advance

advance:                                           ; preds = %check_in, %check_va
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret_found:                                         ; preds = %check_in
  ret i8* %cur

ret_zero:                                          ; preds = %loop, %entry
  ret i8* null
}
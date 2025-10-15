; ModuleID = 'pe_section_lookup'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) local_unnamed_addr {
entry:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr_i32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_ptr_i32, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_i64
  %numsec_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %numsec_ptr_i16 = bitcast i8* %numsec_ptr to i16*
  %numsec_i16 = load i16, i16* %numsec_ptr_i16, align 1
  %is_zero = icmp eq i16 %numsec_i16, 0
  br i1 %is_zero, label %ret_zero, label %nonzero

nonzero:
  %opt_size_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %opt_size_ptr_i16 = bitcast i8* %opt_size_ptr to i16*
  %opt_size_i16 = load i16, i16* %opt_size_ptr_i16, align 1
  %opt_size_i64 = zext i16 %opt_size_i16 to i64
  %nt_plus_0x18 = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %sections0 = getelementptr inbounds i8, i8* %nt_plus_0x18, i64 %opt_size_i64
  %numsec_i32 = zext i16 %numsec_i16 to i32
  %numsec_i64 = zext i32 %numsec_i32 to i64
  %mul40 = mul nuw i64 %numsec_i64, 40
  %end = getelementptr inbounds i8, i8* %sections0, i64 %mul40
  br label %loop

loop:
  %s = phi i8* [ %sections0, %nonzero ], [ %s_next, %loop_next ]
  %done = icmp eq i8* %s, %end
  br i1 %done, label %ret_zero, label %check

check:
  %va_ptr = getelementptr inbounds i8, i8* %s, i64 12
  %va_ptr_i32 = bitcast i8* %va_ptr to i32*
  %va_i32 = load i32, i32* %va_ptr_i32, align 1
  %va_i64 = zext i32 %va_i32 to i64
  %lt_va = icmp ult i64 %rva, %va_i64
  br i1 %lt_va, label %loop_next, label %range_upper

range_upper:
  %vsize_ptr = getelementptr inbounds i8, i8* %s, i64 8
  %vsize_ptr_i32 = bitcast i8* %vsize_ptr to i32*
  %vsize_i32 = load i32, i32* %vsize_ptr_i32, align 1
  %vsize_i64 = zext i32 %vsize_i32 to i64
  %end_va = add nuw i64 %va_i64, %vsize_i64
  %inrange = icmp ult i64 %rva, %end_va
  br i1 %inrange, label %ret_s, label %loop_next

loop_next:
  %s_next = getelementptr inbounds i8, i8* %s, i64 40
  br label %loop

ret_zero:
  ret i8* null

ret_s:
  ret i8* %s
}
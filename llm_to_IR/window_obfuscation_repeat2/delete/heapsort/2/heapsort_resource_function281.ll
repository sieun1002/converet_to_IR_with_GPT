; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %dos_off_ptr0 = getelementptr inbounds i8, i8* %rcx, i64 60
  %dos_off_ptr = bitcast i8* %dos_off_ptr0 to i32*
  %e_lfanew32 = load i32, i32* %dos_off_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pe_ptr0 = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew64
  %num_ptr0 = getelementptr inbounds i8, i8* %pe_ptr0, i64 6
  %num_ptr = bitcast i8* %num_ptr0 to i16*
  %num16 = load i16, i16* %num_ptr, align 1
  %iszero = icmp eq i16 %num16, 0
  br i1 %iszero, label %ret_zero, label %cont

cont:
  %opt_ptr0 = getelementptr inbounds i8, i8* %pe_ptr0, i64 20
  %opt_ptr = bitcast i8* %opt_ptr0 to i16*
  %opt16 = load i16, i16* %opt_ptr, align 1
  %opt64 = zext i16 %opt16 to i64
  %pe_after_hdr = getelementptr inbounds i8, i8* %pe_ptr0, i64 24
  %sec_start = getelementptr inbounds i8, i8* %pe_after_hdr, i64 %opt64
  %num64 = zext i16 %num16 to i64
  %count_bytes = mul nuw i64 %num64, 40
  %sec_end = getelementptr inbounds i8, i8* %sec_start, i64 %count_bytes
  br label %loop

loop:
  %p = phi i8* [ %sec_start, %cont ], [ %p_next, %inc ]
  %vaddr_ptr0 = getelementptr inbounds i8, i8* %p, i64 12
  %vaddr_ptr = bitcast i8* %vaddr_ptr0 to i32*
  %vaddr32 = load i32, i32* %vaddr_ptr, align 1
  %vaddr64 = zext i32 %vaddr32 to i64
  %rva_lt_vaddr = icmp ult i64 %rdx, %vaddr64
  br i1 %rva_lt_vaddr, label %inc, label %check_vsize

check_vsize:
  %vsize_ptr0 = getelementptr inbounds i8, i8* %p, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr0 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %sum = add nuw i64 %vaddr64, %vsize64
  %rva_lt_sum = icmp ult i64 %rdx, %sum
  br i1 %rva_lt_sum, label %ret_found, label %inc

inc:
  %p_next = getelementptr inbounds i8, i8* %p, i64 40
  %at_end = icmp eq i8* %p_next, %sec_end
  br i1 %at_end, label %ret_zero, label %loop

ret_found:
  ret i8* %p

ret_zero:
  ret i8* null
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %e_lfanew_ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew_sext
  %numsec_ptr.i8 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_iszero = icmp eq i16 %numsec, 0
  br i1 %numsec_iszero, label %ret_zero, label %sec_nonzero

sec_nonzero:
  %sizeopt_ptr.i8 = getelementptr inbounds i8, i8* %nthdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr.i8 to i16*
  %sizeopt = load i16, i16* %sizeopt_ptr, align 1
  %numsec_zext = zext i16 %numsec to i32
  %numsec_minus1 = add i32 %numsec_zext, -1
  %mul5 = mul i32 %numsec_minus1, 5
  %mul5_zext = zext i32 %mul5 to i64
  %mul5_times8 = shl i64 %mul5_zext, 3
  %sizeopt_zext = zext i16 %sizeopt to i64
  %firstSection.pre = getelementptr inbounds i8, i8* %nthdr, i64 %sizeopt_zext
  %firstSection = getelementptr inbounds i8, i8* %firstSection.pre, i64 24
  %tmpend = getelementptr inbounds i8, i8* %firstSection, i64 %mul5_times8
  %endptr = getelementptr inbounds i8, i8* %tmpend, i64 40
  br label %loop

loop:
  %curr = phi i8* [ %firstSection, %sec_nonzero ], [ %next, %incr ]
  %va_ptr.i8 = getelementptr inbounds i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %rdx, %va64
  br i1 %cmp1, label %incr, label %check_range

check_range:
  %vsize_ptr.i8 = getelementptr inbounds i8, i8* %curr, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %rdx, %sum64
  br i1 %cmp2, label %ret_found, label %incr

incr:
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  %cmpend = icmp ne i8* %next, %endptr
  br i1 %cmpend, label %loop, label %ret_zero

ret_zero:
  ret i8* null

ret_found:
  ret i8* %curr
}
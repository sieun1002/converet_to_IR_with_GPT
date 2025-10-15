; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %rcx, i64 %rdx) local_unnamed_addr {
entry:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %rcx, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %nt_off = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %rcx, i64 %nt_off
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %notfound, label %has_sections

has_sections:                                     ; preds = %entry
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh16 to i64
  %numsec64 = zext i16 %numsec16 to i64
  %minus1 = add i64 %numsec64, -1
  %times5 = mul i64 %minus1, 5
  %secstart_off = add i64 %soh_zext, 24
  %secstart = getelementptr inbounds i8, i8* %nt, i64 %secstart_off
  %times5x8 = shl i64 %times5, 3
  %end_off_tmp = add i64 %times5x8, 40
  %endptr = getelementptr inbounds i8, i8* %secstart, i64 %end_off_tmp
  br label %loop

loop:                                             ; preds = %advance, %has_sections
  %cursec = phi i8* [ %secstart, %has_sections ], [ %nextsec, %advance ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cursec, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rdx_lt_va = icmp ult i64 %rdx, %va64
  br i1 %rdx_lt_va, label %advance, label %check_upper

check_upper:                                      ; preds = %loop
  %vsize_ptr_i8 = getelementptr inbounds i8, i8* %cursec, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %rdx_lt_sum = icmp ult i64 %rdx, %sum64
  br i1 %rdx_lt_sum, label %found, label %advance

advance:                                          ; preds = %check_upper, %loop
  %nextsec = getelementptr inbounds i8, i8* %cursec, i64 40
  %cmp_end = icmp ne i8* %nextsec, %endptr
  br i1 %cmp_end, label %loop, label %notfound

found:                                            ; preds = %check_upper
  ret i8* %cursec

notfound:                                         ; preds = %advance, %entry
  ret i8* null
}
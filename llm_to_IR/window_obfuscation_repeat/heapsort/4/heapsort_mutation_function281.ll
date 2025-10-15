; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:64:64-p271:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx_in) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr.bc = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr.bc, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %ret0

after_mz:                                           ; preds = %entry
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr.bc = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr.bc, align 4
  %e_lfanew.ext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew.ext
  %sig.ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:                                          ; preds = %after_mz
  %opt_magic_ptr.i8 = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_64 = icmp eq i16 %opt_magic, 523
  br i1 %is_64, label %after_magic, label %ret0

after_magic:                                        ; preds = %check_opt
  %numsec_ptr.i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont1

cont1:                                              ; preds = %after_magic
  %soh_ptr.i8 = getelementptr i8, i8* %nthdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr.i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %rcx.int = ptrtoint i8* %rcx_in to i64
  %base.int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec.minus1 = add i32 %numsec32, -1
  %mul5 = mul i32 %numsec.minus1, 5
  %opt_hdr_start = getelementptr i8, i8* %nthdr, i64 24
  %first_shdr = getelementptr i8, i8* %opt_hdr_start, i64 %soh64
  %mul5.z = zext i32 %mul5 to i64
  %rdx8 = mul i64 %mul5.z, 8
  %endptr.pre = getelementptr i8, i8* %first_shdr, i64 %rdx8
  %endptr = getelementptr i8, i8* %endptr.pre, i64 40
  br label %loop

loop:                                               ; preds = %loop_continue, %cont1
  %hdr.cur = phi i8* [ %first_shdr, %cont1 ], [ %next_hdr, %loop_continue ]
  %is_done = icmp eq i8* %hdr.cur, %endptr
  br i1 %is_done, label %ret_zero2, label %in_loop

in_loop:                                            ; preds = %loop
  %va_ptr.i8 = getelementptr i8, i8* %hdr.cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %cmp1 = icmp ult i64 %rva, %va64
  br i1 %cmp1, label %loop_continue, label %range_check

range_check:                                        ; preds = %in_loop
  %srd_ptr.i8 = getelementptr i8, i8* %hdr.cur, i64 8
  %srd_ptr = bitcast i8* %srd_ptr.i8 to i32*
  %srd = load i32, i32* %srd_ptr, align 4
  %srd64 = zext i32 %srd to i64
  %end_rva = add i64 %va64, %srd64
  %in_range = icmp ult i64 %rva, %end_rva
  br i1 %in_range, label %ret0, label %loop_continue

loop_continue:                                      ; preds = %range_check, %in_loop
  %next_hdr = getelementptr i8, i8* %hdr.cur, i64 40
  br label %loop

ret_zero2:                                          ; preds = %loop
  ret i32 0

ret0:                                               ; preds = %range_check, %after_magic, %check_opt, %after_mz, %entry
  ret i32 0
}
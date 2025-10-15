; ModuleID = 'pe_section_check'
source_filename = "pe_section_check"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr.bc = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr.bc, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %after_mz, label %ret0

after_mz:                                         ; preds = %entry
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr_i8 = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nthdr_i8 to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %after_sig, label %ret0

after_sig:                                        ; preds = %after_mz
  %opt_magic_ptr = getelementptr i8, i8* %nthdr_i8, i64 24
  %opt_magic_ptrw = bitcast i8* %opt_magic_ptr to i16*
  %magic = load i16, i16* %opt_magic_ptrw, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %after_magic, label %ret0

after_magic:                                      ; preds = %after_sig
  %numsec_ptr_i8 = getelementptr i8, i8* %nthdr_i8, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec_w = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec_w, 0
  br i1 %numsec_zero, label %ret0, label %cont1

cont1:                                            ; preds = %after_magic
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nthdr_i8, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt_w = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt_zext = zext i16 %sizeopt_w to i64
  %p_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva64 = sub i64 %p_int, %base_int
  %numsec = zext i16 %numsec_w to i64
  %sect_first_i8 = getelementptr i8, i8* %nthdr_i8, i64 24
  %after_opt_i8 = getelementptr i8, i8* %sect_first_i8, i64 %sizeopt_zext
  %numsec_40 = mul i64 %numsec, 40
  %r9end_i8 = getelementptr i8, i8* %after_opt_i8, i64 %numsec_40
  br label %loop

loop:                                             ; preds = %cont_loop, %cont1
  %cur = phi i8* [ %after_opt_i8, %cont1 ], [ %cur_next, %cont_loop ]
  %done = icmp eq i8* %cur, %r9end_i8
  br i1 %done, label %ret0, label %check

check:                                            ; preds = %loop
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva64, %va64
  br i1 %rva_lt_va, label %cont_loop, label %check2

check2:                                           ; preds = %check
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %va_plus_vsize_64 = zext i32 %va to i64
  %vsize64 = zext i32 %vsize to i64
  %end_va64 = add i64 %va_plus_vsize_64, %vsize64
  %in_range = icmp ult i64 %rva64, %end_va64
  br i1 %in_range, label %found, label %cont_loop

cont_loop:                                        ; preds = %check2, %check
  %cur_next = getelementptr i8, i8* %cur, i64 40
  br label %loop

found:                                            ; preds = %check2
  %ch_ptr_i8 = getelementptr i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 1
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res

ret0:                                             ; preds = %loop, %after_magic, %after_sig, %after_mz, %entry
  ret i32 0
}
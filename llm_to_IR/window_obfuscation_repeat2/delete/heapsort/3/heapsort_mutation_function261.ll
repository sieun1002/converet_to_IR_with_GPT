; ModuleID: 'pe_section_lookup'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rdx) {
entry:
  %p_e_lfanew.i8 = getelementptr i8, i8* %base, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew.i8 to i32*
  %e_lfanew32 = load i32, i32* %p_e_lfanew, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %base, i64 %e_lfanew64
  %p_numsec.i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %p_numsec = bitcast i8* %p_numsec.i8 to i16*
  %numsec16 = load i16, i16* %p_numsec, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %ret_zero, label %nonzero

nonzero:                                          ; preds = %entry
  %p_optsz.i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %p_optsz = bitcast i8* %p_optsz.i8 to i16*
  %optsz16 = load i16, i16* %p_optsz, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %num_minus1 = add i32 %numsec32, -1
  %times5 = mul i32 %num_minus1, 5
  %times5_64 = zext i32 %times5 to i64
  %optsz64 = zext i16 %optsz16 to i64
  %after_filehdr = getelementptr i8, i8* %nt_hdr, i64 24
  %start0 = getelementptr i8, i8* %after_filehdr, i64 %optsz64
  %scaled = mul i64 %times5_64, 8
  %end_tmp = getelementptr i8, i8* %start0, i64 %scaled
  %end = getelementptr i8, i8* %end_tmp, i64 40
  br label %loop

loop:                                             ; preds = %cont, %nonzero
  %cur = phi i8* [ %start0, %nonzero ], [ %next, %cont ]
  %va_ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %rdx, %va64
  br i1 %cmp1, label %cont, label %check_end

check_end:                                        ; preds = %loop
  %size_ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %size_ptr = bitcast i8* %size_ptr.i8 to i32*
  %size32 = load i32, i32* %size_ptr, align 1
  %sum32 = add i32 %va32, %size32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %rdx, %sum64
  br i1 %cmp2, label %ret_found, label %cont

cont:                                             ; preds = %check_end, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %has_more = icmp ne i8* %next, %end
  br i1 %has_more, label %loop, label %ret_zero

ret_zero:                                         ; preds = %cont, %entry
  ret i8* null

ret_found:                                        ; preds = %check_end
  ret i8* %cur
}
; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* %rcx) {
entry:
  %imagebase_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %imagebase_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %imagebase_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %imagebase_ptr, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %isPE32plus = icmp eq i16 %magic, 523
  br i1 %isPE32plus, label %cont1, label %ret0

cont1:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %cont2

cont2:
  %szhdr_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %szhdr_ptr = bitcast i8* %szhdr_ptr_i8 to i16*
  %szhdr16 = load i16, i16* %szhdr_ptr, align 1
  %szhdr32 = zext i16 %szhdr16 to i32
  %szhdr64 = zext i32 %szhdr32 to i64
  %param_addr = ptrtoint i8* %rcx to i64
  %image_addr = ptrtoint i8* %imagebase_ptr to i64
  %rva = sub i64 %param_addr, %image_addr
  %first_sect_base = getelementptr i8, i8* %nt_hdr, i64 24
  %first_sect = getelementptr i8, i8* %first_sect_base, i64 %szhdr64
  %numsec64 = zext i16 %numsec16 to i64
  %numsec_bytes = mul nuw i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %first_sect, i64 %numsec_bytes
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %cont2 ], [ %next, %loop_inc ]
  %at_end = icmp eq i8* %cur, %end_ptr
  br i1 %at_end, label %ret0, label %loop_body

loop_body:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_inc, label %check_end

check_end:
  %vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %end32 = add i32 %va32, %vs32
  %end64 = zext i32 %end32 to i64
  %rva_lt_end = icmp ult i64 %rva, %end64
  br i1 %rva_lt_end, label %success, label %loop_inc

loop_inc:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

success:
  %ch_ptr_i8 = getelementptr i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 1
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res

ret0:
  ret i32 0
}
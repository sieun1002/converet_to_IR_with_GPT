; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002790(i8* %rcx_param) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt_i8 = getelementptr i8, i8* %base_ptr, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %nt_i8 to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_opt, label %ret0

check_opt:
  %magic_i8 = getelementptr i8, i8* %nt_i8, i64 24
  %magic_ptr = bitcast i8* %magic_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %load_nsect, label %ret0

load_nsect:
  %nsect_i8 = getelementptr i8, i8* %nt_i8, i64 6
  %nsect_ptr = bitcast i8* %nsect_i8 to i16*
  %nsect = load i16, i16* %nsect_ptr, align 1
  %nsect_is_zero = icmp eq i16 %nsect, 0
  br i1 %nsect_is_zero, label %ret0, label %prep

prep:
  %sizeopt_i8 = getelementptr i8, i8* %nt_i8, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_i8 to i16*
  %sizeopt = load i16, i16* %sizeopt_ptr, align 1
  %rcx_int = ptrtoint i8* %rcx_param to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %offset = sub i64 %rcx_int, %base_int
  %nsect_z = zext i16 %nsect to i64
  %sizeopt_z = zext i16 %sizeopt to i64
  %hdrs_off = add i64 %sizeopt_z, 24
  %sect_start = getelementptr i8, i8* %nt_i8, i64 %hdrs_off
  %nsect_bytes = mul i64 %nsect_z, 40
  %sect_end = getelementptr i8, i8* %sect_start, i64 %nsect_bytes
  br label %loop

loop:
  %cur = phi i8* [ %sect_start, %prep ], [ %next, %cont ]
  %done = icmp eq i8* %cur, %sect_end
  br i1 %done, label %ret0, label %check_section

check_section:
  %va_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va_z = zext i32 %va to i64
  %off_lt_va = icmp ult i64 %offset, %va_z
  br i1 %off_lt_va, label %cont, label %check_range

check_range:
  %vs_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %sum32 = add i32 %va, %vs
  %sum64 = zext i32 %sum32 to i64
  %off_lt_sum = icmp ult i64 %offset, %sum64
  br i1 %off_lt_sum, label %found, label %cont

cont:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

found:
  %ch_i8 = getelementptr i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 1
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res

ret0:
  ret i32 0
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %p) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmpmz = icmp eq i16 %mz, 23117
  br i1 %cmpmz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %nt_i8 = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_z
  %nt_sig_ptr = bitcast i8* %nt_i8 to i32*
  %sig = load i32, i32* %nt_sig_ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_counts, label %ret0

get_counts:
  %nos_ptr_i8 = getelementptr inbounds i8, i8* %nt_i8, i64 6
  %nos_ptr = bitcast i8* %nos_ptr_i8 to i16*
  %nos16 = load i16, i16* %nos_ptr, align 1
  %nos = zext i16 %nos16 to i32
  %nos_is_zero = icmp eq i32 %nos, 0
  br i1 %nos_is_zero, label %ret0, label %have_sections

have_sections:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_i8, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva64 = sub i64 %p_int, %base_int
  %nt_plus_24 = getelementptr inbounds i8, i8* %nt_i8, i64 24
  %sec_start = getelementptr inbounds i8, i8* %nt_plus_24, i64 %soh
  %nos64 = zext i32 %nos to i64
  %sec_size = mul nuw nsw i64 %nos64, 40
  %sec_end = getelementptr inbounds i8, i8* %sec_start, i64 %sec_size
  br label %loop

loop:
  %cur = phi i8* [ %sec_start, %have_sections ], [ %next, %loop_continue ]
  %done = icmp eq i8* %cur, %sec_end
  br i1 %done, label %ret0, label %check_section

check_section:
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %is_before = icmp ult i64 %rva64, %va64
  br i1 %is_before, label %loop_continue, label %check_within

check_within:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %end_va = add i64 %va64, %vs64
  %is_within = icmp ult i64 %rva64, %end_va
  br i1 %is_within, label %inside, label %loop_continue

inside:
  %ch_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch32 = load i32, i32* %ch_ptr, align 1
  %ch_not = xor i32 %ch32, -1
  %shifted = lshr i32 %ch_not, 31
  ret i32 %shifted

loop_continue:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}
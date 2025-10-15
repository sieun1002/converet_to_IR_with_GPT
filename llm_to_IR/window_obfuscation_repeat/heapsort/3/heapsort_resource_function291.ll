; ModuleID = 'pe_section_finder'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare dso_local i64 @strlen(i8* noundef)
declare dso_local i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %name) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %name)
  %oklen = icmp ule i64 %len, 8
  br i1 %oklen, label %check_base, label %ret_null

check_base:
  %base_load = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_load to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %loc_5A8, label %ret_null

loc_5A8:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_load, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_ptr = getelementptr i8, i8* %base_load, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %opt_magic_ptr8 = getelementptr i8, i8* %pehdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr8 to i16*
  %magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret_null

check_sections:
  %numsec_ptr8 = getelementptr i8, i8* %pehdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %setup_loop

setup_loop:
  %soh_ptr8 = getelementptr i8, i8* %pehdr_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %first_section_off = add i64 %soh64, 24
  %first_section_ptr = getelementptr i8, i8* %pehdr_ptr, i64 %first_section_off
  br label %loop

loop:
  %cur = phi i8* [ %first_section_ptr, %setup_loop ], [ %next, %loop_next ]
  %idx = phi i32 [ 0, %setup_loop ], [ %idx_next, %loop_next ]
  %cmpcall = call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %is_zero = icmp eq i32 %cmpcall, 0
  br i1 %is_zero, label %ret_found, label %loop_next

loop_next:
  %numsec32 = zext i16 %numsec16 to i32
  %idx_next = add i32 %idx, 1
  %next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i32 %idx_next, %numsec32
  br i1 %cont, label %loop, label %ret_null

ret_found:
  ret i8* %cur

ret_null:
  ret i8* null
}
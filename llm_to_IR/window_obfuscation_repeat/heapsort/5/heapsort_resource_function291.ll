; ModuleID = 'pe_section_lookup'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare dllimport i64 @strlen(i8* noundef)
declare dllimport i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %name) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %name)
  %too_long = icmp ugt i64 %len, 8
  br i1 %too_long, label %ret_null, label %check_mz

check_mz:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_word_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_word_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_hdr, label %ret_null

pe_hdr:
  %lfanew_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew_sext = sext i32 %lfanew to i64
  %pe = getelementptr inbounds i8, i8* %baseptr, i64 %lfanew_sext
  %pe_sig_ptr = bitcast i8* %pe to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %opt_magic_i8 = getelementptr inbounds i8, i8* %pe, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_64 = icmp eq i16 %opt_magic, 523
  br i1 %is_64, label %check_sections_nonzero, label %ret_null

check_sections_nonzero:
  %numsec_i8 = getelementptr inbounds i8, i8* %pe, i64 6
  %numsec_ptr = bitcast i8* %numsec_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %calc_first_section

calc_first_section:
  %soh_i8 = getelementptr inbounds i8, i8* %pe, i64 20
  %soh_ptr = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %pe_plus_24 = getelementptr inbounds i8, i8* %pe, i64 24
  %sect = getelementptr inbounds i8, i8* %pe_plus_24, i64 %soh64
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %calc_first_section ], [ %i_next, %loop_next ]
  %sect_cur = phi i8* [ %sect, %calc_first_section ], [ %sect_next, %loop_next ]
  %cmpres = call i32 @strncmp(i8* %sect_cur, i8* %name, i64 8)
  %is_eq = icmp eq i32 %cmpres, 0
  br i1 %is_eq, label %ret_found, label %loop_next

loop_next:
  %i_next = add i32 %i, 1
  %sect_next = getelementptr inbounds i8, i8* %sect_cur, i64 40
  %cont = icmp ult i32 %i_next, %numsec32
  br i1 %cont, label %loop, label %ret_null

ret_found:
  ret i8* %sect_cur

ret_null:
  ret i8* null
}
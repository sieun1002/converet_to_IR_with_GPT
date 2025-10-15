; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

declare dso_local dllimport i64 @strlen(i8* nocapture) #1
declare dso_local dllimport i32 @strncmp(i8* nocapture, i8* nocapture, i64) #1

define dso_local i8* @sub_140002570(i8* %name) local_unnamed_addr #0 {
entry:
  %len = tail call i64 @strlen(i8* %name)
  %too_long = icmp ugt i64 %len, 8
  br i1 %too_long, label %ret_null, label %check_base

check_base:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %dos_ptr16 = bitcast i8* %base_ptr to i16*
  %dos_magic = load i16, i16* %dos_ptr16, align 2
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %after_mz_ok, label %ret_null

after_mz_ok:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %lfanew_ptr_i32 = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew32 = load i32, i32* %lfanew_ptr_i32, align 4
  %lfanew = sext i32 %lfanew32 to i64
  %nt_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %lfanew
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %check_numsec, label %ret_null

check_numsec:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %compute_first

compute_first:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %first_section_off = add i64 %soh64, 24
  %first_section_ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 %first_section_off
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %idx = phi i32 [ 0, %compute_first ], [ %idx_next, %loop_continue ]
  %cur = phi i8* [ %first_section_ptr, %compute_first ], [ %next_ptr, %loop_continue ]
  %cmpcall = tail call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %eq = icmp eq i32 %cmpcall, 0
  br i1 %eq, label %found, label %loop_continue

found:
  ret i8* %cur

loop_continue:
  %idx_next = add i32 %idx, 1
  %next_ptr = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ult i32 %idx_next, %numsec32
  br i1 %cont, label %loop, label %ret_null

ret_null:
  ret i8* null
}

attributes #0 = { nounwind }
attributes #1 = { nounwind }
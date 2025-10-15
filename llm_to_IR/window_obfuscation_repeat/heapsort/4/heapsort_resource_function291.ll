; ModuleID = 'pe_section_find.ll'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

declare dllimport i64 @strlen(i8* noundef)
declare dllimport i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %name) {
entry:
  %len = call i64 @strlen(i8* %name)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %fail, label %check_mz

check_mz:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %p_i16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %p_i16ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %pe_hdr, label %fail

pe_hdr:
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr_i32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr_i32, align 1
  %e_lfanew_ext = sext i32 %e_lfanew to i64
  %pe_base = getelementptr i8, i8* %baseptr, i64 %e_lfanew_ext
  %sig_i32ptr = bitcast i8* %pe_base to i32*
  %sig = load i32, i32* %sig_i32ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %opt_magic_ptr = getelementptr i8, i8* %pe_base, i64 24
  %opt_magic_i16ptr = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections_nonzero, label %fail

check_sections_nonzero:
  %numsec_ptr8 = getelementptr i8, i8* %pe_base, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %fail, label %calc_first_section

calc_first_section:
  %size_opt_ptr8 = getelementptr i8, i8* %pe_base, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr8 to i16*
  %size_opt16 = load i16, i16* %size_opt_ptr, align 1
  %size_opt64 = zext i16 %size_opt16 to i64
  %base_plus_24 = getelementptr i8, i8* %pe_base, i64 24
  %first_sec = getelementptr i8, i8* %base_plus_24, i64 %size_opt64
  %numsec64 = zext i16 %numsec16 to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %calc_first_section ], [ %i.next, %loop_continue ]
  %cur = phi i8* [ %first_sec, %calc_first_section ], [ %next_sec, %loop_continue ]
  %cmpres = call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %is_equal = icmp eq i32 %cmpres, 0
  br i1 %is_equal, label %found, label %loop_continue

loop_continue:
  %i.next = add nuw nsw i64 %i, 1
  %next_sec = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i64 %i.next, %numsec64
  br i1 %cont, label %loop, label %fail

found:
  ret i8* %cur

fail:
  ret i8* null
}
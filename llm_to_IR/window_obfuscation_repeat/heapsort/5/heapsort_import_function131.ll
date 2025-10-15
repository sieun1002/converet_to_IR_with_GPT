; ModuleID = 'pe_section_find'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %name) {
entry:
  %len = call i64 @sub_140002AC0(i8* %name)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %ret_zero, label %after_len

after_len:
  %base_load = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_load to i16*
  %mz_val = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %have_mz, label %ret_zero

have_mz:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_load, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base_load, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret_zero

check_sections:
  %nsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec_w = load i16, i16* %nsec_ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec_w, 0
  br i1 %nsec_is_zero, label %ret_zero, label %calc_sections_base

calc_sections_base:
  %szopt_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr_i8 to i16*
  %szopt_w = load i16, i16* %szopt_ptr, align 1
  %szopt_zx = zext i16 %szopt_w to i64
  %sections_start = getelementptr i8, i8* %nt_hdr, i64 24
  %sections_base = getelementptr i8, i8* %sections_start, i64 %szopt_zx
  %nsec = zext i16 %nsec_w to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %calc_sections_base ], [ %i.next, %loop_continue ]
  %cur = phi i8* [ %sections_base, %calc_sections_base ], [ %next_ptr, %loop_continue ]
  %cmpcall = call i32 @sub_140002AC8(i8* %cur, i8* %name, i32 8)
  %is_match = icmp eq i32 %cmpcall, 0
  br i1 %is_match, label %return_cur, label %loop_continue

return_cur:
  ret i8* %cur

loop_continue:
  %i.next = add i32 %i, 1
  %next_ptr = getelementptr i8, i8* %cur, i64 40
  %more = icmp ult i32 %i.next, %nsec
  br i1 %more, label %loop, label %ret_zero

ret_zero:
  ret i8* null
}
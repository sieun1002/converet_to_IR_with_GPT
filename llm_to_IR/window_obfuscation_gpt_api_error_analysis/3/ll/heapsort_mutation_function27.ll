; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

declare dso_local i64 @strlen(i8* noundef)
declare dso_local i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %str) {
entry:
  %len = call i64 @strlen(i8* noundef %str)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %fail, label %check_mz

check_mz:
  %image_base = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %image_base to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %parse_pe, label %fail

parse_pe:
  %e_lfanew_i8 = getelementptr i8, i8* %image_base, i64 60
  %e_lfanew_i32p = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32p, align 1
  %e_lfanew = sext i32 %e_lfanew_i32 to i64
  %nt = getelementptr i8, i8* %image_base, i64 %e_lfanew
  %pe_sig_p = bitcast i8* %nt to i32*
  %pe_sig = load i32, i32* %pe_sig_p, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %magic_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_p = bitcast i8* %magic_i8 to i16*
  %magic = load i16, i16* %magic_p, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_numsec, label %fail

check_numsec:
  %numsec_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_p = bitcast i8* %numsec_i8 to i16*
  %numsec16 = load i16, i16* %numsec_p, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %fail, label %prepare_loop

prepare_loop:
  %soh_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_p = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_p, align 1
  %soh64 = zext i16 %soh16 to i64
  %firstsec_off = add i64 %soh64, 24
  %firstsec = getelementptr i8, i8* %nt, i64 %firstsec_off
  %numsec = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prepare_loop ], [ %i_next, %loop_latch ]
  %cur = phi i8* [ %firstsec, %prepare_loop ], [ %cur_next, %loop_latch ]
  %cmpres = call i32 @strncmp(i8* noundef %cur, i8* noundef %str, i64 noundef 8)
  %is_zero = icmp eq i32 %cmpres, 0
  br i1 %is_zero, label %ret_match, label %loop_latch

loop_latch:
  %i_next = add i32 %i, 1
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i_next, %numsec
  br i1 %cont, label %loop, label %fail

ret_match:
  ret i8* %cur

fail:
  ret i8* null
}
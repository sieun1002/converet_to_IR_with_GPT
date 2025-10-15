; ModuleID = 'pe_section_find'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

declare dso_local i64 @strlen(i8* noundef)
declare dso_local i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %s) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* noundef %s)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %fail, label %check_mz

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %parse_nt, label %fail

parse_nt:
  %e_lfanew_i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_p = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_sext
  %sig_p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %opt_magic_i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %opt_magic_p = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_p, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections_nonzero, label %fail

check_sections_nonzero:
  %numsec_i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec_p = bitcast i8* %numsec_i8 to i16*
  %numsec = load i16, i16* %numsec_p, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %fail, label %prep_loop

prep_loop:
  %sizopt_i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %sizopt_p = bitcast i8* %sizopt_i8 to i16*
  %sizopt = load i16, i16* %sizopt_p, align 1
  %sizopt_zext = zext i16 %sizopt to i64
  %first_off = add i64 %sizopt_zext, 24
  %first_sec = getelementptr inbounds i8, i8* %nt, i64 %first_off
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i.next, %loop_latch ]
  %sec = phi i8* [ %first_sec, %prep_loop ], [ %sec.next, %loop_latch ]
  %cmp = call i32 @strncmp(i8* noundef %sec, i8* noundef %s, i64 noundef 8)
  %eq = icmp eq i32 %cmp, 0
  br i1 %eq, label %success, label %loop_latch

loop_latch:
  %numsec_z32 = zext i16 %numsec to i32
  %i.next = add i32 %i, 1
  %sec.next = getelementptr inbounds i8, i8* %sec, i64 40
  %cont = icmp ult i32 %i.next, %numsec_z32
  br i1 %cont, label %loop, label %fail

success:
  ret i8* %sec

fail:
  ret i8* null
}
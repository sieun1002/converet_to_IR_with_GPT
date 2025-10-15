target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

declare dso_local i64 @strlen(i8* noundef)
declare dso_local i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %name) {
entry:
  %len = call i64 @strlen(i8* %name)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %fail, label %check_mz

check_mz:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %get_pe, label %fail

get_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pesig_ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %fail

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %fail, label %prep_loop

prep_loop:
  %soh_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %sectoff_base = add i64 %soh_zext, 24
  %sectbase = getelementptr i8, i8* %pehdr, i64 %sectoff_base
  %numsec_zext = zext i16 %numsec to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_next ]
  %cur = phi i8* [ %sectbase, %prep_loop ], [ %cur_next, %loop_next ]
  %cmpcall = call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %is_match = icmp eq i32 %cmpcall, 0
  br i1 %is_match, label %ret_match, label %loop_next

loop_next:
  %i_next = add i32 %i, 1
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %i_lt_num = icmp ult i32 %i_next, %numsec_zext
  br i1 %i_lt_num, label %loop, label %fail

ret_match:
  ret i8* %cur

fail:
  ret i8* null
}
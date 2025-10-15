; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare dllimport i64 @strlen(i8*)
declare dllimport i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %str) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %str)
  %cmp = icmp ugt i64 %len, 8
  br i1 %cmp, label %ret_zero, label %check_mz

ret_zero:
  ret i8* null

check_mz:
  %base_ptr = load i8*, i8** @off_1400043A0
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %have_mz, label %ret_zero

have_mz:
  %ofs_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %ofs_ptr_i32 = bitcast i8* %ofs_ptr to i32*
  %ofs = load i32, i32* %ofs_ptr_i32
  %ofs_sext = sext i32 %ofs to i64
  %nt_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 %ofs_sext
  %pe_sig_ptr = bitcast i8* %nt_ptr_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr = getelementptr i8, i8* %nt_ptr_i8, i64 24
  %magic_ptr_i16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_ptr_i16
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %check_numsec, label %ret_zero

check_numsec:
  %numsec_ptr = getelementptr i8, i8* %nt_ptr_i8, i64 6
  %numsec_ptr_i16 = bitcast i8* %numsec_ptr to i16*
  %numsec = load i16, i16* %numsec_ptr_i16
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %compute_first_section

compute_first_section:
  %soh_ptr = getelementptr i8, i8* %nt_ptr_i8, i64 20
  %soh_ptr_i16 = bitcast i8* %soh_ptr to i16*
  %soh = load i16, i16* %soh_ptr_i16
  %soh_zext64 = zext i16 %soh to i64
  %offs_oh = add i64 %soh_zext64, 24
  %first_sec = getelementptr i8, i8* %nt_ptr_i8, i64 %offs_oh
  %numsec_i64 = zext i16 %numsec to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %compute_first_section ], [ %i.next, %next ]
  %cur_ptr = phi i8* [ %first_sec, %compute_first_section ], [ %next_ptr, %next ]
  %cmpres = call i32 @strncmp(i8* %cur_ptr, i8* %str, i64 8)
  %is_zero = icmp eq i32 %cmpres, 0
  br i1 %is_zero, label %found, label %next

found:
  ret i8* %cur_ptr

next:
  %i.next = add i64 %i, 1
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %cond = icmp ult i64 %i.next, %numsec_i64
  br i1 %cond, label %loop, label %ret_zero
}
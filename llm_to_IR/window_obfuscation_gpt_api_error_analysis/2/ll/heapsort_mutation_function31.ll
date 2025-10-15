; ModuleID = 'sub_140002750.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002750() local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base16p = bitcast i8* %base to i16*
  %mz = load i16, i16* %base16p, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %nt_sig_ptr = bitcast i8* %nt_hdr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %opt_magic_ptr.i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_64 = icmp eq i16 %opt_magic, 523
  %retval = select i1 %is_64, i8* %base, i8* null
  ret i8* %retval

ret_null:
  ret i8* null
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043C0 = external global i8*, align 8

define dso_local i8* @sub_140002830() local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043C0, align 8
  %ptr_mz = bitcast i8* %base to i16*
  %mz = load i16, i16* %ptr_mz, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret_zero

check_pe:
  %ofs_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %ofs_ptr = bitcast i8* %ofs_ptr_i8 to i32*
  %ofs32 = load i32, i32* %ofs_ptr, align 1
  %ofs64 = sext i32 %ofs32 to i64
  %peptr = getelementptr i8, i8* %base, i64 %ofs64
  %sig_ptr = bitcast i8* %peptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %peptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is64 = icmp eq i16 %magic, 523
  %res = select i1 %is64, i8* %base, i8* null
  ret i8* %res

ret_zero:
  ret i8* null
}
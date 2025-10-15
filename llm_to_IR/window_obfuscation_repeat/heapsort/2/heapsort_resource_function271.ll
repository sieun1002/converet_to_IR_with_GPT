; ModuleID = 'pecheck.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* nocapture readonly %base) local_unnamed_addr {
entry:
  %p16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %p16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

ret_zero:
  ret i32 0

check_pe:
  %ofs_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %ofs_i32ptr = bitcast i8* %ofs_ptr to i32*
  %ofs = load i32, i32* %ofs_i32ptr, align 1
  %ofs_sext = sext i32 %ofs to i64
  %nt_ptr = getelementptr inbounds i8, i8* %base, i64 %ofs_sext
  %nt32ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %nt32ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr8 = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_20b = icmp eq i16 %magic, 523
  %res = zext i1 %is_20b to i32
  ret i32 %res
}
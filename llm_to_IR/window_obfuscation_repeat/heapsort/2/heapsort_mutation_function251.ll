; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* nocapture readonly %p) local_unnamed_addr {
entry:
  %p_i16 = bitcast i8* %p to i16*
  %mzw = load i16, i16* %p_i16, align 1
  %is_mz = icmp eq i16 %mzw, 23117
  br i1 %is_mz, label %check_pe, label %ret0

ret0:                                             ; preds = %entry, %check_pe
  ret i32 0

check_pe:                                         ; preds = %entry
  %ofs_ptr = getelementptr i8, i8* %p, i64 60
  %ofs_ptr_i32 = bitcast i8* %ofs_ptr to i32*
  %ofs_val = load i32, i32* %ofs_ptr_i32, align 1
  %ofs_sext = sext i32 %ofs_val to i64
  %nt_ptr = getelementptr i8, i8* %p, i64 %ofs_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %opt_magic_ptr = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr_i16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr_i16, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %res8 = zext i1 %is_pe32plus to i8
  %res32 = zext i8 %res8 to i32
  ret i32 %res32
}
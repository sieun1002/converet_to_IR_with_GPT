target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400024F0(i8* %rcx) {
entry:
  %p_mz = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %p_mz, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %p_e_lfanew_i8 = getelementptr i8, i8* %rcx, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew_i8 to i32*
  %e_lfanew32 = load i32, i32* %p_e_lfanew, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %rcx, i64 %e_lfanew
  %p_sig = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %p_sig, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %p_magic_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %p_magic = bitcast i8* %p_magic_i8 to i16*
  %magic = load i16, i16* %p_magic, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  %res = zext i1 %is_pe32p to i32
  ret i32 %res

ret0:
  ret i32 0
}
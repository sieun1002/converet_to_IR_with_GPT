; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %rcx) {
entry:
  %p0 = bitcast i8* %rcx to i16*
  %w0 = load i16, i16* %p0, align 1
  %cmp_mz = icmp eq i16 %w0, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

ret0:
  ret i32 0

check_pe:
  %base_plus_3c = getelementptr i8, i8* %rcx, i64 60
  %p3c32 = bitcast i8* %base_plus_3c to i32*
  %off32 = load i32, i32* %p3c32, align 1
  %off64 = sext i32 %off32 to i64
  %pehdr = getelementptr i8, i8* %rcx, i64 %off64
  %p_pe_sig32ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %p_pe_sig32ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret0

check_magic:
  %pe_plus_18 = getelementptr i8, i8* %pehdr, i64 24
  %p_magic = bitcast i8* %pe_plus_18 to i16*
  %magic = load i16, i16* %p_magic, align 1
  %cmp_magic = icmp eq i16 %magic, 523
  %res = zext i1 %cmp_magic to i32
  ret i32 %res
}
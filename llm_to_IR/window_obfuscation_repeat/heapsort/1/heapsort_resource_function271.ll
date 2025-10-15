; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400024F0(i8* %p) {
entry:
  %mzptr.bc = bitcast i8* %p to i16*
  %mz = load i16, i16* %mzptr.bc, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr.i8 = getelementptr inbounds i8, i8* %p, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %off64 = sext i32 %e_lfanew to i64
  %pe_hdr = getelementptr inbounds i8, i8* %p, i64 %off64
  %sigptr = bitcast i8* %pe_hdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %opt_ptr.i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 24
  %opt_ptr = bitcast i8* %opt_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %res = zext i1 %is_pe32plus to i32
  ret i32 %res

ret0:
  ret i32 0
}
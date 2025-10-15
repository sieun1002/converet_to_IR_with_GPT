; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* %rcx) {
entry:
  %mzh_ptr = bitcast i8* %rcx to i16*
  %mzh = load i16, i16* %mzh_ptr, align 1
  %cmp_mz = icmp eq i16 %mzh, 23117
  br i1 %cmp_mz, label %mz_ok, label %ret0

mz_ok:
  %offs_ptr = getelementptr inbounds i8, i8* %rcx, i64 60
  %offs_i32ptr = bitcast i8* %offs_ptr to i32*
  %offs = load i32, i32* %offs_i32ptr, align 1
  %offs_sext = sext i32 %offs to i64
  %pehdr = getelementptr inbounds i8, i8* %rcx, i64 %offs_sext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %cmp_pe = icmp eq i32 %pe_sig, 17744
  br i1 %cmp_pe, label %pe_ok, label %ret0

pe_ok:
  %magic_ptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_i16ptr = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  %res = zext i1 %is_pe32plus to i32
  ret i32 %res

ret0:
  ret i32 0
}
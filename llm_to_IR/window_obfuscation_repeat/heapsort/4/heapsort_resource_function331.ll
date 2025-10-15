; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002750() local_unnamed_addr {
entry:
  %g = load i8*, i8** @off_1400043A0, align 8
  %dos_ptr = bitcast i8* %g to i16*
  %dos = load i16, i16* %dos_ptr, align 1
  %is_mz = icmp eq i16 %dos, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

ret_null:
  ret i8* null

check_pe:
  %offptr = getelementptr inbounds i8, i8* %g, i64 60
  %e_lfanew_ptr = bitcast i8* %offptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %g, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %opt_ptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %opt_ptr to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %ret_base, label %ret_null

ret_base:
  ret i8* %g
}
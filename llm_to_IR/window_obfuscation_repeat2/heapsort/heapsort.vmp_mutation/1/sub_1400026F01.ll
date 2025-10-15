; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_1400026F0() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret_zero

check_pe:
  %base_gep_3c = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %base_gep_3c to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_ext = sext i32 %e_lfanew to i64
  %nt_ptr_i8 = getelementptr i8, i8* %base, i64 %e_lfanew_ext
  %nt_sign_ptr = bitcast i8* %nt_ptr_i8 to i32*
  %nt_sig = load i32, i32* %nt_sign_ptr, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %res = select i1 %is_pe32plus, i8* %base, i8* null
  br label %ret

ret_zero:
  br label %ret

ret:
  %result_phi = phi i8* [ null, %ret_zero ], [ %res, %check_opt ]
  ret i8* %result_phi
}
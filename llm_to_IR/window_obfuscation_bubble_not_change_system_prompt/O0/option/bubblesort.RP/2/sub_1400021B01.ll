target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_1400021B0(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %ret0, label %load_base

ret0:
  ret i8* null

load_base:
  %baseptr = load i8*, i8** @off_1400043C0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %calc_pe, label %ret0

calc_pe:
  %e_lfanew_ptr8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_magic, label %ret0

check_magic:
  %magic_ptr8 = getelementptr i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr8 to i16*
  %magic = load i16, i16* %magic_ptr
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %check_numsec, label %ret0

check_numsec:
  %numsec_ptr8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %ret0, label %prep_loop

prep_loop:
  %opt_size_ptr8 = getelementptr i8, i8* %pehdr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr
  %opt_size64 = zext i16 %opt_size16 to i64
  %sections_base = getelementptr i8, i8* %pehdr, i64 24
  %first_section = getelementptr i8, i8* %sections_base, i64 %opt_size64
  br label %loop

loop:
  %idx = phi i32 [ 0, %prep_loop ], [ %idx_next, %cont ]
  %curr = phi i8* [ %first_section, %prep_loop ], [ %curr_next, %cont ]
  %call = call i32 @strncmp(i8* %curr, i8* %str, i64 8)
  %eq = icmp eq i32 %call, 0
  br i1 %eq, label %found, label %cont

found:
  ret i8* %curr

cont:
  %numsec_ptr8.2 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr.2 = bitcast i8* %numsec_ptr8.2 to i16*
  %numsec16.2 = load i16, i16* %numsec_ptr.2
  %numsec32 = zext i16 %numsec16.2 to i32
  %idx_next = add i32 %idx, 1
  %curr_next = getelementptr i8, i8* %curr, i64 40
  %more = icmp ult i32 %idx_next, %numsec32
  br i1 %more, label %loop, label %ret0
}
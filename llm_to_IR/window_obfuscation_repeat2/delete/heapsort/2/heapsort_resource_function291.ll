target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* %rcx) {
entry:
  %len = call i64 @strlen(i8* %rcx)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %ret_zero, label %check_off

check_off:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %have_mz, label %ret_zero

have_mz:
  %lfanew_ptr = getelementptr i8, i8* %base, i64 60
  %lfanew_p32 = bitcast i8* %lfanew_ptr to i32*
  %lfanew32 = load i32, i32* %lfanew_p32, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %nt = getelementptr i8, i8* %base, i64 %lfanew64
  %sigp = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigp, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_magic, label %ret_zero

check_magic:
  %magic_p_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_p = bitcast i8* %magic_p_i8 to i16*
  %magic = load i16, i16* %magic_p, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %check_numsec_nonzero, label %ret_zero

check_numsec_nonzero:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %compute_first

compute_first:
  %soh_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh to i64
  %opt_start = getelementptr i8, i8* %nt, i64 24
  %first = getelementptr i8, i8* %opt_start, i64 %soh64
  br label %loop

loop:
  %i = phi i32 [ 0, %compute_first ], [ %i_next, %cont_loop ]
  %sect = phi i8* [ %first, %compute_first ], [ %sect_next, %cont_loop ]
  %call = call i32 @strncmp(i8* %sect, i8* %rcx, i64 8)
  %eq = icmp eq i32 %call, 0
  br i1 %eq, label %found, label %not_found

found:
  ret i8* %sect

not_found:
  %i_next = add i32 %i, 1
  %sect_next = getelementptr i8, i8* %sect, i64 40
  %numsec_i32 = zext i16 %numsec to i32
  %cont = icmp ult i32 %i_next, %numsec_i32
  br i1 %cont, label %cont_loop, label %ret_zero

cont_loop:
  br label %loop

ret_zero:
  ret i8* null
}
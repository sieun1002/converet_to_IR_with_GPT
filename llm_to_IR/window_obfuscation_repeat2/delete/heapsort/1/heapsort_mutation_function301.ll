; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i64 @sub_1400026D0(i64 %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %p_mz = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %p_mz, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %p_lfanew = getelementptr i8, i8* %baseptr, i64 60
  %p_lfanew_i32 = bitcast i8* %p_lfanew to i32*
  %lfanew_i32 = load i32, i32* %p_lfanew_i32, align 1
  %lfanew = sext i32 %lfanew_i32 to i64
  %nt = getelementptr i8, i8* %baseptr, i64 %lfanew
  %p_sig_i32 = bitcast i8* %nt to i32*
  %sig = load i32, i32* %p_sig_i32, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %p_magic = getelementptr i8, i8* %nt, i64 24
  %p_magic_i16 = bitcast i8* %p_magic to i16*
  %magic = load i16, i16* %p_magic_i16, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %read_sections, label %ret0

read_sections:
  %p_num = getelementptr i8, i8* %nt, i64 6
  %p_num_i16 = bitcast i8* %p_num to i16*
  %num16 = load i16, i16* %p_num_i16, align 1
  %numz = zext i16 %num16 to i64
  %is_zero = icmp eq i64 %numz, 0
  br i1 %is_zero, label %ret0, label %compute_first

compute_first:
  %p_soh = getelementptr i8, i8* %nt, i64 20
  %p_soh_i16 = bitcast i8* %p_soh to i16*
  %soh16 = load i16, i16* %p_soh_i16, align 1
  %soh = zext i16 %soh16 to i64
  %plus_24 = add i64 %soh, 24
  %first = getelementptr i8, i8* %nt, i64 %plus_24
  %numminus1 = add i64 %numz, -1
  %times5 = mul i64 %numminus1, 5
  %times40 = mul i64 %times5, 8
  %end_off_tmp = add i64 %times40, 40
  %endptr = getelementptr i8, i8* %first, i64 %end_off_tmp
  br label %loop

loop:
  %p.cur = phi i8* [ %first, %compute_first ], [ %p.next, %after_flag ]
  %rcx.cur = phi i64 [ %rcx, %compute_first ], [ %rcx.next, %after_flag ]
  %char_byte_ptr = getelementptr i8, i8* %p.cur, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %mask = and i8 %char_byte, 32
  %hasflag = icmp ne i8 %mask, 0
  br i1 %hasflag, label %flag_set, label %after_flag

flag_set:
  %iszero = icmp eq i64 %rcx.cur, 0
  br i1 %iszero, label %early_ret, label %dec

dec:
  %rcx.dec = add i64 %rcx.cur, -1
  br label %after_flag

after_flag:
  %rcx.next = phi i64 [ %rcx.cur, %loop ], [ %rcx.dec, %dec ]
  %p.next = getelementptr i8, i8* %p.cur, i64 40
  %done = icmp eq i8* %p.next, %endptr
  br i1 %done, label %ret0, label %loop

early_ret:
  %retval = ptrtoint i8* %p.cur to i64
  ret i64 %retval

ret0:
  ret i64 0
}
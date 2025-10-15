; ModuleID = 'sub_140002570.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* noundef %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %ret_null, label %check_mz

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %nt_headers, label %ret_null

nt_headers:
  %e_lfanew_off = getelementptr i8, i8* %base, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_off to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew64
  %sigp = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigp, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_off = getelementptr i8, i8* %nt, i64 24
  %magic_p = bitcast i8* %magic_off to i16*
  %magic = load i16, i16* %magic_p, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_numsects, label %ret_null

check_numsects:
  %nsects_off = getelementptr i8, i8* %nt, i64 6
  %nsects_p = bitcast i8* %nsects_off to i16*
  %nsects16 = load i16, i16* %nsects_p, align 1
  %nsects_zero = icmp eq i16 %nsects16, 0
  br i1 %nsects_zero, label %ret_null, label %compute_first_section

compute_first_section:
  %szopt_off = getelementptr i8, i8* %nt, i64 20
  %szopt_p = bitcast i8* %szopt_off to i16*
  %szopt16 = load i16, i16* %szopt_p, align 1
  %szopt64 = zext i16 %szopt16 to i64
  %sect_start_pre = getelementptr i8, i8* %nt, i64 24
  %sect_start = getelementptr i8, i8* %sect_start_pre, i64 %szopt64
  %nsects32 = zext i16 %nsects16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %compute_first_section ], [ %i_next, %loop_latch ]
  %p = phi i8* [ %sect_start, %compute_first_section ], [ %p_next, %loop_latch ]
  %cmpcall = call i32 @strncmp(i8* %p, i8* %str, i64 8)
  %eq = icmp eq i32 %cmpcall, 0
  br i1 %eq, label %ret_ptr, label %loop_latch

loop_latch:
  %i_next = add i32 %i, 1
  %p_next = getelementptr i8, i8* %p, i64 40
  %cont = icmp ult i32 %i_next, %nsects32
  br i1 %cont, label %loop, label %ret_null

ret_ptr:
  ret i8* %p

ret_null:
  ret i8* null
}
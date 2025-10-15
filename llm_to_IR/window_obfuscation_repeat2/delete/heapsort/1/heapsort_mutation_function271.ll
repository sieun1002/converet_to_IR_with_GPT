; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail, label %check_mz

check_mz:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %fail

after_mz:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_i8 = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_64 = icmp eq i16 %magic, 523
  br i1 %is_64, label %check_nsec, label %fail

check_nsec:
  %nsec_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_is_zero, label %fail, label %compute_start

compute_start:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %sections_base = getelementptr i8, i8* %nt_i8, i64 24
  %start_ptr = getelementptr i8, i8* %sections_base, i64 %soh64
  %nsec32 = zext i16 %nsec16 to i32
  br label %loop

loop:
  %idx = phi i32 [ 0, %compute_start ], [ %idx_next, %loop_inc ]
  %cur_ptr = phi i8* [ %start_ptr, %compute_start ], [ %next_ptr, %loop_inc ]
  %cmpres = call i32 @strncmp(i8* %cur_ptr, i8* %str, i64 8)
  %is_eq = icmp eq i32 %cmpres, 0
  br i1 %is_eq, label %found, label %loop_inc

loop_inc:
  %idx_next = add i32 %idx, 1
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %cont = icmp ult i32 %idx_next, %nsec32
  br i1 %cont, label %loop, label %fail

found:
  ret i8* %cur_ptr

fail:
  ret i8* null
}
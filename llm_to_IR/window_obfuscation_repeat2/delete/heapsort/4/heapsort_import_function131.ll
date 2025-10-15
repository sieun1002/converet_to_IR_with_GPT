; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002AC0()
declare i32 @sub_140002AC8(i8*, i8*, i32)

@off_1400043A0 = external global i8*

define i8* @sub_140002570(i8* %arg) {
entry:
  %len = call i64 @sub_140002AC0()
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %ret_zero, label %check_mz

check_mz:
  %base_ptr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %have_mz, label %ret_zero

have_mz:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_i64
  %nt_sig_ptr = bitcast i8* %nt to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %check_sections_nonzero, label %ret_zero

check_sections_nonzero:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %compute_sections_start

compute_sections_start:
  %szopt_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr_i8 to i16*
  %szopt_u16 = load i16, i16* %szopt_ptr, align 1
  %szopt_i64 = zext i16 %szopt_u16 to i64
  %sum = add i64 %szopt_i64, 24
  %sect_base = getelementptr i8, i8* %nt, i64 %sum
  br label %loop

loop:
  %curptr = phi i8* [ %sect_base, %compute_sections_start ], [ %nextptr, %cont ]
  %i = phi i32 [ 0, %compute_sections_start ], [ %i_next, %cont ]
  %call = call i32 @sub_140002AC8(i8* %curptr, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %return_ptr, label %cont

cont:
  %numsec_ptr2_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr2 = bitcast i8* %numsec_ptr2_i8 to i16*
  %numsec2_u16 = load i16, i16* %numsec_ptr2, align 1
  %numsec2 = zext i16 %numsec2_u16 to i32
  %i_next = add i32 %i, 1
  %nextptr = getelementptr i8, i8* %curptr, i64 40
  %has_more = icmp ult i32 %i_next, %numsec2
  br i1 %has_more, label %loop, label %ret_zero

return_ptr:
  ret i8* %curptr

ret_zero:
  ret i8* null
}
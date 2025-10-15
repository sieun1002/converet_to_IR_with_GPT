; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i64)

define i8* @sub_140002570(i8* %name) {
entry:
  %len = call i64 @sub_140002AC0(i8* %name)
  %too_long = icmp ugt i64 %len, 8
  br i1 %too_long, label %ret_null, label %len_ok

ret_null:
  ret i8* null

len_ok:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_null

mz_ok:
  %e_lfanew_ptr8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pe = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %pesig_ptr = bitcast i8* %pe to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_null

pe_ok:
  %magic_ptr8 = getelementptr i8, i8* %pe, i64 24
  %magic_ptr = bitcast i8* %magic_ptr8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %magic_ok, label %ret_null

magic_ok:
  %numsec_ptr8 = getelementptr i8, i8* %pe, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_null, label %sections_setup

sections_setup:
  %soh_ptr8 = getelementptr i8, i8* %pe, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %opt_start = getelementptr i8, i8* %pe, i64 24
  %firstsec = getelementptr i8, i8* %opt_start, i64 %soh_zext
  %numsec_zext = zext i16 %numsec to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %sections_setup ], [ %i_next, %cont ]
  %cur = phi i8* [ %firstsec, %sections_setup ], [ %cur_next, %cont ]
  %nsec = phi i32 [ %numsec_zext, %sections_setup ], [ %nsec, %cont ]
  %cmpres = call i32 @sub_140002AC8(i8* %cur, i8* %name, i64 8)
  %is_equal = icmp eq i32 %cmpres, 0
  br i1 %is_equal, label %found, label %cont

found:
  ret i8* %cur

cont:
  %i_next = add i32 %i, 1
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ult i32 %i_next, %nsec
  br i1 %more, label %loop, label %ret_null
}
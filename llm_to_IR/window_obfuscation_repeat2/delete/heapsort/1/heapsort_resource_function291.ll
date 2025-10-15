; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %0) {
entry:
  %len = call i64 @strlen(i8* %0)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %ret_zero, label %afterlen

afterlen:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr16 = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pehdr, label %ret_zero

pehdr:
  %e_lfanew_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_headers = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_headers to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %checkMagic, label %ret_zero

checkMagic:
  %opt_magic_i8 = getelementptr i8, i8* %nt_headers, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %checkNumSections, label %ret_zero

checkNumSections:
  %numsec_i8 = getelementptr i8, i8* %nt_headers, i64 6
  %numsec_ptr = bitcast i8* %numsec_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %setupLoop

setupLoop:
  %soh_i8 = getelementptr i8, i8* %nt_headers, i64 20
  %soh_ptr = bitcast i8* %soh_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %sect_base = getelementptr i8, i8* %nt_headers, i64 24
  %sect0_ptr = getelementptr i8, i8* %sect_base, i64 %soh_zext
  br label %loop

loop:
  %cur = phi i8* [ %sect0_ptr, %setupLoop ], [ %next_cur, %loop_continue ]
  %i = phi i32 [ 0, %setupLoop ], [ %i_next, %loop_continue ]
  %cmpres = call i32 @strncmp(i8* %cur, i8* %0, i64 8)
  %eq = icmp eq i32 %cmpres, 0
  br i1 %eq, label %found, label %loop_continue

found:
  ret i8* %cur

loop_continue:
  %i_next = add i32 %i, 1
  %next_cur = getelementptr i8, i8* %cur, i64 40
  %numsec_zext = zext i16 %numsec to i32
  %cont = icmp ult i32 %i_next, %numsec_zext
  br i1 %cont, label %loop, label %ret_zero

ret_zero:
  ret i8* null
}
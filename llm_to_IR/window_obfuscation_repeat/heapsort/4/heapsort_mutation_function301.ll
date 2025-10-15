; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_1400026D0(i64 %rcx) nounwind {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_mz_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_mz_ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %after_mz, label %ret

after_mz:
  %e_off_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_off_ptr32 = bitcast i8* %e_off_ptr to i32*
  %e_off32 = load i32, i32* %e_off_ptr32, align 1
  %e_off64 = sext i32 %e_off32 to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_off64
  %nt_pe_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %nt_pe_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret

check_magic:
  %opt_magic_ptr = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr16, align 1
  %is_20b = icmp eq i16 %opt_magic, 523
  br i1 %is_20b, label %cont1, label %ret

cont1:
  %num_sec_ptr = getelementptr i8, i8* %nt_ptr, i64 6
  %num_sec_ptr16 = bitcast i8* %num_sec_ptr to i16*
  %num_sec16 = load i16, i16* %num_sec_ptr16, align 1
  %is_zero_sections = icmp eq i16 %num_sec16, 0
  br i1 %is_zero_sections, label %ret, label %cont2

cont2:
  %size_opt_ptr = getelementptr i8, i8* %nt_ptr, i64 20
  %size_opt_ptr16 = bitcast i8* %size_opt_ptr to i16*
  %size_opt16 = load i16, i16* %size_opt_ptr16, align 1
  %size_opt_zext = zext i16 %size_opt16 to i64
  %sect_start_pre = getelementptr i8, i8* %nt_ptr, i64 %size_opt_zext
  %sect_start = getelementptr i8, i8* %sect_start_pre, i64 24
  %num_sec64 = zext i16 %num_sec16 to i64
  %total_bytes = mul i64 %num_sec64, 40
  %sect_end = getelementptr i8, i8* %sect_start, i64 %total_bytes
  br label %loop

loop:
  %cur = phi i8* [ %sect_start, %cont2 ], [ %next, %after_iter ]
  %rcx_count = phi i64 [ %rcx, %cont2 ], [ %rcx_next, %after_iter ]
  %char_byte_ptr = getelementptr i8, i8* %cur, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %masked = and i8 %char_byte, 32
  %bit_zero = icmp eq i8 %masked, 0
  br i1 %bit_zero, label %after_check, label %check_rcx

check_rcx:
  %rcx_is_zero = icmp eq i64 %rcx_count, 0
  br i1 %rcx_is_zero, label %ret, label %dec_rcx

dec_rcx:
  %rcx_dec = add i64 %rcx_count, -1
  br label %after_check

after_check:
  %rcx_next = phi i64 [ %rcx_count, %loop ], [ %rcx_dec, %dec_rcx ]
  %next = getelementptr i8, i8* %cur, i64 40
  %is_end = icmp eq i8* %next, %sect_end
  br i1 %is_end, label %exit_end, label %after_iter

after_iter:
  br label %loop

exit_end:
  br label %ret

ret:
  ret i32 0
}
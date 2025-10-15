; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %count) local_unnamed_addr nounwind {
entry:
  %base_ptr.ptr = load i8*, i8** @off_1400043A0, align 8
  %dos_hdr_ptr = bitcast i8* %base_ptr.ptr to i16*
  %mz_val = load i16, i16* %dos_hdr_ptr, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_byteptr = getelementptr i8, i8* %base_ptr.ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_byteptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %base_ptr.ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic_byteptr = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_byteptr to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe_plus = icmp eq i16 %magic, 523
  br i1 %is_pe_plus, label %load_nsect, label %ret0

load_nsect:
  %nsect_byteptr = getelementptr i8, i8* %nt_ptr, i64 6
  %nsect_ptr = bitcast i8* %nsect_byteptr to i16*
  %nsect16 = load i16, i16* %nsect_ptr, align 1
  %nsect64 = zext i16 %nsect16 to i64
  %nsect_is_zero = icmp eq i64 %nsect64, 0
  br i1 %nsect_is_zero, label %ret0, label %calc_start

calc_start:
  %sizeopt_byteptr = getelementptr i8, i8* %nt_ptr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_byteptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %opt_hdr_ptr = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sect = getelementptr i8, i8* %opt_hdr_ptr, i64 %sizeopt64
  %nsect_x40 = mul i64 %nsect64, 40
  %end_ptr = getelementptr i8, i8* %first_sect, i64 %nsect_x40
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %calc_start ], [ %next, %loop2 ]
  %cnt = phi i64 [ %count, %calc_start ], [ %cnt2, %loop2 ]
  %at_end = icmp eq i8* %cur, %end_ptr
  br i1 %at_end, label %done, label %check_char

check_char:
  %char_byte_ptr = getelementptr i8, i8* %cur, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %masked = and i8 %char_byte, 32
  %has_exec = icmp ne i8 %masked, 0
  br i1 %has_exec, label %exec_case, label %loop2

exec_case:
  %cnt_is_zero = icmp eq i64 %cnt, 0
  br i1 %cnt_is_zero, label %ret0, label %dec_cnt

dec_cnt:
  %cnt_dec = add i64 %cnt, -1
  br label %loop2

loop2:
  %cnt2 = phi i64 [ %cnt, %check_char ], [ %cnt_dec, %dec_cnt ]
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

done:
  br label %ret0

ret0:
  ret i32 0
}
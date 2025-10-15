; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i8* @sub_1400026D0(i64 %count) {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %pe = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_i64
  %pe_sig_ptr = bitcast i8* %pe to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %magic_ptr = getelementptr inbounds i8, i8* %pe, i64 24
  %magic_i16ptr = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret_zero

get_sections:
  %numsec_ptr = getelementptr inbounds i8, i8* %pe, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_ptr to i16*
  %numsec = load i16, i16* %numsec_i16ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %cont1

cont1:
  %szopt_ptr = getelementptr inbounds i8, i8* %pe, i64 20
  %szopt_i16ptr = bitcast i8* %szopt_ptr to i16*
  %szopt = load i16, i16* %szopt_i16ptr, align 1
  %szopt_z = zext i16 %szopt to i64
  %firstSec_off = add i64 %szopt_z, 24
  %firstSec = getelementptr inbounds i8, i8* %pe, i64 %firstSec_off
  %numsec_z = zext i16 %numsec to i64
  %totalbytes = mul i64 %numsec_z, 40
  %end = getelementptr inbounds i8, i8* %firstSec, i64 %totalbytes
  br label %loop

loop:
  %cur = phi i8* [ %firstSec, %cont1 ], [ %next, %loop_end ]
  %cnt = phi i64 [ %count, %cont1 ], [ %cnt_next, %loop_end ]
  %flag_ptr = getelementptr inbounds i8, i8* %cur, i64 39
  %flag = load i8, i8* %flag_ptr, align 1
  %masked = and i8 %flag, 32
  %is_set = icmp ne i8 %masked, 0
  br i1 %is_set, label %check_count, label %loop_end

check_count:
  %is_zero = icmp eq i64 %cnt, 0
  br i1 %is_zero, label %ret_cur, label %dec_count

dec_count:
  %dec = add i64 %cnt, -1
  br label %loop_end

loop_end:
  %cnt_next = phi i64 [ %dec, %dec_count ], [ %cnt, %loop ]
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %not_done = icmp ne i8* %next, %end
  br i1 %not_done, label %loop, label %ret_zero

ret_cur:
  ret i8* %cur

ret_zero:
  ret i8* null
}
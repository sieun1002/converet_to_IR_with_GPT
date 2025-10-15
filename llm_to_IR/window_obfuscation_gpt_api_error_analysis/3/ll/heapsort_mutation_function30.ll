@off_1400043A0 = external global i8*, align 8

define i32 @sub_1400026D0(i64 %count) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %chk_nt, label %ret0

chk_nt:
  %elfanew_ptr8 = getelementptr i8, i8* %base_ptr, i64 60
  %elfanew_ptr = bitcast i8* %elfanew_ptr8 to i32*
  %elfanew32 = load i32, i32* %elfanew_ptr, align 1
  %elfanew = sext i32 %elfanew32 to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %elfanew
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %chk_peplus, label %ret0

chk_peplus:
  %magic_ptr8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_peplus = icmp eq i16 %magic, 523
  br i1 %is_peplus, label %load_sections, label %ret0

load_sections:
  %numsec_ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %has_sections = icmp ne i16 %numsec16, 0
  br i1 %has_sections, label %calc_first, label %ret0

calc_first:
  %sooh_ptr8 = getelementptr i8, i8* %nt, i64 20
  %sooh_ptr = bitcast i8* %sooh_ptr8 to i16*
  %sooh16 = load i16, i16* %sooh_ptr, align 1
  %sooh = zext i16 %sooh16 to i64
  %first_off = getelementptr i8, i8* %nt, i64 24
  %first_sec = getelementptr i8, i8* %first_off, i64 %sooh
  %numsec = zext i16 %numsec16 to i64
  %ns_minus1 = add i64 %numsec, -1
  %mul5 = mul i64 %ns_minus1, 5
  %mul40 = shl i64 %mul5, 3
  %end_pre = getelementptr i8, i8* %first_sec, i64 %mul40
  %endptr = getelementptr i8, i8* %end_pre, i64 40
  br label %loop

loop:
  %ptr = phi i8* [ %first_sec, %calc_first ], [ %nextptr, %loop_latch ]
  %cnt = phi i64 [ %count, %calc_first ], [ %cnt_next, %loop_latch ]
  %char_ptr8 = getelementptr i8, i8* %ptr, i64 39
  %char = load i8, i8* %char_ptr8, align 1
  %mask = and i8 %char, 32
  %is_exec = icmp ne i8 %mask, 0
  br i1 %is_exec, label %check_count, label %advance_from_loop

check_count:
  %is_zero = icmp eq i64 %cnt, 0
  br i1 %is_zero, label %ret0, label %advance_from_decr

advance_from_decr:
  %cnt_dec = add i64 %cnt, -1
  br label %advance

advance_from_loop:
  br label %advance

advance:
  %cnt_next = phi i64 [ %cnt, %advance_from_loop ], [ %cnt_dec, %advance_from_decr ]
  %nextptr = getelementptr i8, i8* %ptr, i64 40
  %more = icmp ne i8* %nextptr, %endptr
  br i1 %more, label %loop_latch, label %after

loop_latch:
  br label %loop

after:
  ret i32 0

ret0:
  ret i32 0
}
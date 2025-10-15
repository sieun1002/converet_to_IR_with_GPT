; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external dso_local global i32*, align 8
@qword_1400070D0 = external dso_local global i32 (i8*)*, align 8

declare dso_local void @sub_140001010()
declare dso_local void @sub_1400024E0()
declare dso_local i8* @signal(i32, i8*)

define dso_local void @start() local_unnamed_addr {
entry:
  %p0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p0, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @TopLevelExceptionFilter(i8* %pEP) local_unnamed_addr {
entry:
  %excRecPtr.p = bitcast i8* %pEP to i8**
  %excRec.p = load i8*, i8** %excRecPtr.p, align 8
  %code.ptr = bitcast i8* %excRec.p to i32*
  %code = load i32, i32* %code.ptr, align 4
  %masked = and i32 %code, 553648127
  %isCGC = icmp eq i32 %masked, 541414467
  br i1 %isCGC, label %check_flag, label %range_check

check_flag:
  %flag.ptr = getelementptr inbounds i8, i8* %excRec.p, i64 4
  %flag.b = load i8, i8* %flag.ptr, align 1
  %flag1 = and i8 %flag.b, 1
  %flag1nz = icmp ne i8 %flag1, 0
  br i1 %flag1nz, label %range_check, label %ret_m1

range_check:
  %cmp_hi = icmp ugt i32 %code, 3221225622
  br i1 %cmp_hi, label %fallback, label %range_le

range_le:
  %le_8B = icmp ule i32 %code, 3221225611
  br i1 %le_8B, label %le_path, label %mid_range

mid_range:
  %is_int_div0 = icmp eq i32 %code, 3221225620
  br i1 %is_int_div0, label %sig8_div0, label %sig8_other

le_path:
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %sig11, label %gt_av_check

gt_av_check:
  %gt_av = icmp ugt i32 %code, 3221225477
  br i1 %gt_av, label %after_av_gt, label %lt_eq_av_path

after_av_gt:
  %is_invalid_handle = icmp eq i32 %code, 3221225480
  br i1 %is_invalid_handle, label %ret_m1, label %check_illegal

check_illegal:
  %is_illegal = icmp eq i32 %code, 3221225501
  br i1 %is_illegal, label %sig4, label %fallback

lt_eq_av_path:
  %is_dbg_datamisalign = icmp eq i32 %code, 2147483650
  br i1 %is_dbg_datamisalign, label %ret_m1, label %fallback

sig8_other:
  %prev_s8o = call i8* @signal(i32 8, i8* null)
  %prev_is_ign_s8o = icmp eq i8* %prev_s8o, inttoptr (i64 1 to i8*)
  br i1 %prev_is_ign_s8o, label %set_ign_call_sub_and_ret_m1, label %s8o_test_prev

s8o_test_prev:
  %prev_nonnull_s8o = icmp ne i8* %prev_s8o, null
  br i1 %prev_nonnull_s8o, label %call_prev_s8o, label %fallback

call_prev_s8o:
  %prev_fn_s8o = bitcast i8* %prev_s8o to void (i32)*
  call void %prev_fn_s8o(i32 8)
  br label %ret_m1

set_ign_call_sub_and_ret_m1:
  %rsi_s8o = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  call void @sub_1400024E0()
  br label %ret_m1

sig8_div0:
  %prev_s8d = call i8* @signal(i32 8, i8* null)
  %prev_is_ign_s8d = icmp eq i8* %prev_s8d, inttoptr (i64 1 to i8*)
  br i1 %prev_is_ign_s8d, label %set_ign_and_ret_m1, label %s8d_test_prev

s8d_test_prev:
  %prev_nonnull_s8d = icmp ne i8* %prev_s8d, null
  br i1 %prev_nonnull_s8d, label %call_prev_s8d, label %fallback

call_prev_s8d:
  %prev_fn_s8d = bitcast i8* %prev_s8d to void (i32)*
  call void %prev_fn_s8d(i32 8)
  br label %ret_m1

set_ign_and_ret_m1:
  %rsi_s8d = call i8* @signal(i32 8, i8* inttoptr (i64 1 to i8*))
  br label %ret_m1

sig4:
  %prev_s4 = call i8* @signal(i32 4, i8* null)
  %prev_is_ign_s4 = icmp eq i8* %prev_s4, inttoptr (i64 1 to i8*)
  br i1 %prev_is_ign_s4, label %set_ign4_and_ret_m1, label %s4_test_prev

s4_test_prev:
  %prev_nonnull_s4 = icmp ne i8* %prev_s4, null
  br i1 %prev_nonnull_s4, label %call_prev_s4, label %fallback

call_prev_s4:
  %prev_fn_s4 = bitcast i8* %prev_s4 to void (i32)*
  call void %prev_fn_s4(i32 4)
  br label %ret_m1

set_ign4_and_ret_m1:
  %rsi_s4 = call i8* @signal(i32 4, i8* inttoptr (i64 1 to i8*))
  br label %ret_m1

sig11:
  %prev_s11 = call i8* @signal(i32 11, i8* null)
  %prev_is_ign_s11 = icmp eq i8* %prev_s11, inttoptr (i64 1 to i8*)
  br i1 %prev_is_ign_s11, label %set_ign11_and_ret_m1, label %s11_test_prev

s11_test_prev:
  %prev_nonnull_s11 = icmp ne i8* %prev_s11, null
  br i1 %prev_nonnull_s11, label %call_prev_s11, label %fallback

call_prev_s11:
  %prev_fn_s11 = bitcast i8* %prev_s11 to void (i32)*
  call void %prev_fn_s11(i32 11)
  br label %ret_m1

set_ign11_and_ret_m1:
  %rsi_s11 = call i8* @signal(i32 11, i8* inttoptr (i64 1 to i8*))
  br label %ret_m1

fallback:
  %cb = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %cb_null = icmp eq i32 (i8*)* %cb, null
  br i1 %cb_null, label %ret_0, label %tail_call

tail_call:
  %res = tail call i32 %cb(i8* %pEP)
  ret i32 %res

ret_0:
  ret i32 0

ret_m1:
  ret i32 -1
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*, align 8

declare i64 @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %pctx) {
entry:
  %rdx_ptr = load i8*, i8** %pctx, align 8
  %rdx_i32ptr = bitcast i8* %rdx_ptr to i32*
  %code = load i32, i32* %rdx_i32ptr, align 4
  %masked = and i32 %code, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %check_flag, label %dispatch

check_flag:
  %flags_ptr = getelementptr i8, i8* %rdx_ptr, i64 4
  %flags_val = load i8, i8* %flags_ptr, align 1
  %flags32 = zext i8 %flags_val to i32
  %hasbit = and i32 %flags32, 1
  %is_set = icmp ne i32 %hasbit, 0
  br i1 %is_set, label %dispatch, label %ret_neg1

dispatch:
  %code2 = phi i32 [ %code, %entry ], [ %code, %check_flag ]
  %cmp_gt = icmp ugt i32 %code2, 3221225622
  br i1 %cmp_gt, label %fallback, label %cmp_le_8B

cmp_le_8B:
  %cmp_le = icmp ule i32 %code2, 3221225611
  br i1 %cmp_le, label %block110, label %midrange

midrange:
  %r_m = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_m = icmp eq i64 %r_m, 1
  br i1 %is_one_m, label %block224, label %test_r_m

test_r_m:
  %is_zero_m = icmp eq i64 %r_m, 0
  br i1 %is_zero_m, label %fallback, label %call_r_m

call_r_m:
  %fp_m = inttoptr i64 %r_m to void (i32)*
  call void %fp_m(i32 8)
  br label %ret_neg1

block110:
  %cmp_eq_5 = icmp eq i32 %code2, 3221225477
  br i1 %cmp_eq_5, label %block1C0, label %gt_5

gt_5:
  %cmp_gt_5 = icmp ugt i32 %code2, 3221225477
  br i1 %cmp_gt_5, label %block150, label %check_80000002

check_80000002:
  %cmp_eq_80000002 = icmp eq i32 %code2, 2147483650
  br i1 %cmp_eq_80000002, label %ret_neg1, label %fallback

block150:
  %cmp_eq_8 = icmp eq i32 %code2, 3221225480
  br i1 %cmp_eq_8, label %ret_neg1, label %check_1D

check_1D:
  %cmp_eq_1D = icmp eq i32 %code2, 3221225501
  br i1 %cmp_eq_1D, label %block15E, label %fallback

block15E:
  %r_15 = call i64 @sub_140002B68(i32 4, i32 0)
  %is_one_15 = icmp eq i64 %r_15, 1
  br i1 %is_one_15, label %block210, label %test_r_15

test_r_15:
  %is_zero_15 = icmp eq i64 %r_15, 0
  br i1 %is_zero_15, label %fallback, label %call_r_15

call_r_15:
  %fp_15 = inttoptr i64 %r_15 to void (i32)*
  call void %fp_15(i32 4)
  br label %ret_neg1

block1C0:
  %r_1c = call i64 @sub_140002B68(i32 11, i32 0)
  %is_one_1c = icmp eq i64 %r_1c, 1
  br i1 %is_one_1c, label %block1FC, label %test_r_1c

test_r_1c:
  %is_zero_1c = icmp eq i64 %r_1c, 0
  br i1 %is_zero_1c, label %fallback, label %call_r_1c

call_r_1c:
  %fp_1c = inttoptr i64 %r_1c to void (i32)*
  call void %fp_1c(i32 11)
  br label %ret_neg1

block1FC:
  %call_set_1c = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_neg1

block210:
  %call_set_15 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_neg1

block224:
  %call_set_m = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_neg1

fallback:
  %fpglob_ptr = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %fpglob_ptr, null
  br i1 %isnull, label %ret_zero, label %tailcall

tailcall:
  %fp_tail = bitcast i8* %fpglob_ptr to i32 (i8**)*
  %ret_tc = tail call i32 %fp_tail(i8** %pctx)
  ret i32 %ret_tc

ret_neg1:
  ret i32 -1

ret_zero:
  ret i32 0
}
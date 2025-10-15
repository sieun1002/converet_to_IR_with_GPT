; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %arg) {
entry:
  %rdx = load i8*, i8** %arg, align 8
  %rec_i32ptr = bitcast i8* %rdx to i32*
  %code = load i32, i32* %rec_i32ptr, align 4
  %masked = and i32 %code, 553648127
  %sigmatch = icmp eq i32 %masked, 541541187
  br i1 %sigmatch, label %sigcheck, label %dispatch

sigcheck:
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %byte = load i8, i8* %byteptr, align 1
  %mask1 = and i8 %byte, 1
  %bitset = icmp ne i8 %mask1, 0
  br i1 %bitset, label %dispatch, label %ret_neg1

dispatch:
  %gt96 = icmp ugt i32 %code, 3221225622
  br i1 %gt96, label %fallback, label %cmp8B

cmp8B:
  %le8B = icmp ule i32 %code, 3221225611
  br i1 %le8B, label %smallcases, label %range8C_96

range8C_96:
  %is94 = icmp eq i32 %code, 3221225620
  br i1 %is94, label %case_94, label %check_96

check_96:
  %is96 = icmp eq i32 %code, 3221225622
  br i1 %is96, label %case_96, label %check_others

check_others:
  %is92 = icmp eq i32 %code, 3221225618
  br i1 %is92, label %ret_neg1, label %check95

check95:
  %is95 = icmp eq i32 %code, 3221225621
  br i1 %is95, label %ret_neg1, label %check_range

check_range:
  %is_ge_8D = icmp uge i32 %code, 3221225613
  %is_le_91 = icmp ule i32 %code, 3221225617
  %in_8D_91 = and i1 %is_ge_8D, %is_le_91
  br i1 %in_8D_91, label %case_math, label %check93

check93:
  %is93 = icmp eq i32 %code, 3221225619
  br i1 %is93, label %case_math, label %ret_neg1

smallcases:
  %is_0005 = icmp eq i32 %code, 3221225477
  br i1 %is_0005, label %case_0005, label %gt_0005

gt_0005:
  %is_gt_5 = icmp ugt i32 %code, 3221225477
  br i1 %is_gt_5, label %between_5_and_8B, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_neg1, label %fallback

between_5_and_8B:
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_neg1, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %case_96, label %fallback

case_math:
  %call_math = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_math = icmp eq i64 %call_math, 1
  br i1 %is_one_math, label %loc_224, label %test_zero_math

test_zero_math:
  %is_zero_math = icmp eq i64 %call_math, 0
  br i1 %is_zero_math, label %fallback, label %call_func_math

call_func_math:
  %fp_math = inttoptr i64 %call_math to i32 (i32)*
  %res_math = call i32 %fp_math(i32 8)
  br label %ret_neg1

case_94:
  %call_94 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_94 = icmp eq i64 %call_94, 1
  br i1 %is_one_94, label %loc_1A6, label %test_zero_94

test_zero_94:
  %is_zero_94 = icmp eq i64 %call_94, 0
  br i1 %is_zero_94, label %fallback, label %call_func_94

call_func_94:
  %fp_94 = inttoptr i64 %call_94 to i32 (i32)*
  %res_94 = call i32 %fp_94(i32 8)
  br label %ret_neg1

loc_1A6:
  %call_1A6 = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_neg1

case_96:
  %call_96 = call i64 @sub_140002B68(i32 4, i32 0)
  %is_one_96 = icmp eq i64 %call_96, 1
  br i1 %is_one_96, label %loc_210, label %test_zero_96

test_zero_96:
  %is_zero_96 = icmp eq i64 %call_96, 0
  br i1 %is_zero_96, label %fallback, label %call_func_96

call_func_96:
  %fp_96 = inttoptr i64 %call_96 to i32 (i32)*
  %res_96 = call i32 %fp_96(i32 4)
  br label %ret_neg1

loc_210:
  %call_210 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_neg1

case_0005:
  %call_0005 = call i64 @sub_140002B68(i32 11, i32 0)
  %is_one_0005 = icmp eq i64 %call_0005, 1
  br i1 %is_one_0005, label %loc_1FC, label %test_zero_0005

test_zero_0005:
  %is_zero_0005 = icmp eq i64 %call_0005, 0
  br i1 %is_zero_0005, label %fallback, label %call_func_0005

call_func_0005:
  %fp_0005 = inttoptr i64 %call_0005 to i32 (i32)*
  %res_0005 = call i32 %fp_0005(i32 11)
  br label %ret_neg1

loc_1FC:
  %call_1FC = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_neg1

loc_224:
  %call_224 = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_neg1

fallback:
  %gptr = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %gptr, null
  br i1 %isnull, label %ret_zero, label %tail

tail:
  %funptr = bitcast i8* %gptr to i32 (i8*)*
  %arg_as_i8 = bitcast i8** %arg to i8*
  %ret_from_cb = call i32 %funptr(i8* %arg_as_i8)
  ret i32 %ret_from_cb

ret_zero:
  ret i32 0

ret_neg1:
  ret i32 -1
}
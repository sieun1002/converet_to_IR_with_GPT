; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i8* @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define i32 @sub_140002080(i8** %ctx) {
entry:
  %rdx = load i8*, i8** %ctx, align 8
  %exptr = bitcast i8* %rdx to i32*
  %ex = load i32, i32* %exptr, align 4
  %mask = and i32 %ex, 553648127
  %is_ccg = icmp eq i32 %mask, 541541187
  br i1 %is_ccg, label %ccg_match, label %dispatch

ccg_match:
  %flagptr8 = getelementptr inbounds i8, i8* %rdx, i64 4
  %flagbyte = load i8, i8* %flagptr8, align 1
  %flagbit = and i8 %flagbyte, 1
  %flagzero = icmp eq i8 %flagbit, 0
  br i1 %flagzero, label %ret_neg1, label %dispatch

dispatch:
  %cmp_high = icmp ugt i32 %ex, 3221225622
  br i1 %cmp_high, label %callback_check, label %check_low

check_low:
  %cmp_le_8B = icmp ule i32 %ex, 3221225611
  br i1 %cmp_le_8B, label %low_group, label %math_group

math_group:
  br label %handle8

low_group:
  %is_av = icmp eq i32 %ex, 3221225477
  br i1 %is_av, label %handleB, label %low_more

low_more:
  %gt_av = icmp ugt i32 %ex, 3221225477
  br i1 %gt_av, label %after_150, label %pre_ef

pre_ef:
  %is_80000002 = icmp eq i32 %ex, 2147483650
  br i1 %is_80000002, label %ret_neg1, label %callback_check

after_150:
  %is_c0000008 = icmp eq i32 %ex, 3221225480
  br i1 %is_c0000008, label %ret_neg1, label %check_1D

check_1D:
  %is_c000001d = icmp eq i32 %ex, 3221225501
  br i1 %is_c000001d, label %handle4, label %callback_check

handle8:
  %p8 = call i8* @sub_140002B68(i32 8, i32 0)
  %p8_int = ptrtoint i8* %p8 to i64
  %is1_8 = icmp eq i64 %p8_int, 1
  br i1 %is1_8, label %p8_is1, label %p8_non1

p8_is1:
  %tmp8_call = call i8* @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_neg1

p8_non1:
  %p8_isnull = icmp eq i8* %p8, null
  br i1 %p8_isnull, label %callback_check, label %call_p8

call_p8:
  %fp8 = bitcast i8* %p8 to void (i32)*
  call void %fp8(i32 8)
  br label %ret_neg1

handle4:
  %p4 = call i8* @sub_140002B68(i32 4, i32 0)
  %p4_int = ptrtoint i8* %p4 to i64
  %is1_4 = icmp eq i64 %p4_int, 1
  br i1 %is1_4, label %p4_is1, label %p4_non1

p4_is1:
  %tmp4_call = call i8* @sub_140002B68(i32 4, i32 1)
  br label %ret_neg1

p4_non1:
  %p4_isnull = icmp eq i8* %p4, null
  br i1 %p4_isnull, label %callback_check, label %call_p4

call_p4:
  %fp4 = bitcast i8* %p4 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_neg1

handleB:
  %pB = call i8* @sub_140002B68(i32 11, i32 0)
  %pB_int = ptrtoint i8* %pB to i64
  %is1_B = icmp eq i64 %pB_int, 1
  br i1 %is1_B, label %pB_is1, label %pB_non1

pB_is1:
  %tmpB_call = call i8* @sub_140002B68(i32 11, i32 1)
  br label %ret_neg1

pB_non1:
  %pB_isnull = icmp eq i8* %pB, null
  br i1 %pB_isnull, label %callback_check, label %call_pB

call_pB:
  %fpB = bitcast i8* %pB to void (i32)*
  call void %fpB(i32 11)
  br label %ret_neg1

callback_check:
  %cbptr = load i8*, i8** @qword_1400070D0, align 8
  %cb_isnull = icmp eq i8* %cbptr, null
  br i1 %cb_isnull, label %ret_zero, label %do_cb

do_cb:
  %cb = bitcast i8* %cbptr to i32 (i8**)*
  %res = call i32 %cb(i8** %ctx)
  ret i32 %res

ret_zero:
  ret i32 0

ret_neg1:
  ret i32 -1
}
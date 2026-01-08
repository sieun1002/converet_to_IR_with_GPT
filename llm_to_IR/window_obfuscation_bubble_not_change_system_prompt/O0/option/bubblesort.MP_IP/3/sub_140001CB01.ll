; ModuleID = 'sub_140001CB0'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

@qword_1400070D0 = external global i32 (i8**)*

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_i32ptr, align 4
  %masked = and i32 %eax, 553648127
  %is_marker = icmp eq i32 %masked, 541541187
  br i1 %is_marker, label %marker, label %after_marker

marker:
  %flags_ptr = getelementptr inbounds i8, i8* %rdx, i64 4
  %flags = load i8, i8* %flags_ptr, align 1
  %flag1 = and i8 %flags, 1
  %flag_is_zero = icmp eq i8 %flag1, 0
  br i1 %flag_is_zero, label %ret_default, label %after_marker

after_marker:
  %cmp_ugt_0096 = icmp ugt i32 %eax, -1073741674
  br i1 %cmp_ugt_0096, label %fallback, label %cmp_le_008B

cmp_le_008B:
  %cmp_ule_008B = icmp ule i32 %eax, -1073741685
  br i1 %cmp_ule_008B, label %block_1d40, label %switch_prep

switch_prep:
  %idx = add i32 %eax, 1073741683
  %idx_ugt9 = icmp ugt i32 %idx, 9
  br i1 %idx_ugt9, label %ret_default, label %switch

switch:
  switch i32 %idx, label %ret_default [
    i32 0, label %case_1d00
    i32 1, label %case_1d00
    i32 2, label %case_1d00
    i32 3, label %case_1d00
    i32 4, label %case_1d00
    i32 5, label %ret_default
    i32 6, label %case_1d00
    i32 7, label %case_1dc0
    i32 8, label %ret_default
    i32 9, label %case_1d8e
  ]

case_1d00:
  %call1 = call i64 @sub_1400027A8(i32 8, i32 0)
  %eq1 = icmp eq i64 %call1, 1
  br i1 %eq1, label %do_8_1_then_120, label %test_nonzero1

test_nonzero1:
  %iszero1 = icmp eq i64 %call1, 0
  br i1 %iszero1, label %fallback, label %callfp_ecx8

callfp_ecx8:
  %fp8 = inttoptr i64 %call1 to void (i32)*
  call void %fp8(i32 8)
  br label %ret_default

case_1dc0:
  %call2 = call i64 @sub_1400027A8(i32 8, i32 0)
  %eq2 = icmp eq i64 %call2, 1
  br i1 %eq2, label %do_8_1_then_default, label %test_nonzero2

test_nonzero2:
  %iszero2 = icmp eq i64 %call2, 0
  br i1 %iszero2, label %fallback, label %callfp_ecx8_b

callfp_ecx8_b:
  %fp8b = inttoptr i64 %call2 to void (i32)*
  call void %fp8b(i32 8)
  br label %ret_default

case_1d8e:
  %call3 = call i64 @sub_1400027A8(i32 4, i32 0)
  %eq3 = icmp eq i64 %call3, 1
  br i1 %eq3, label %do_4_1_then_default, label %test_nonzero3

test_nonzero3:
  %iszero3 = icmp eq i64 %call3, 0
  br i1 %iszero3, label %fallback, label %callfp_ecx4

callfp_ecx4:
  %fp4 = inttoptr i64 %call3 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_default

do_8_1_then_120:
  %tmp1 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_default

do_8_1_then_default:
  %tmp2 = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_default

do_4_1_then_default:
  %tmp3 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_default

block_1d40:
  %eq_0005 = icmp eq i32 %eax, -1073741819
  br i1 %eq_0005, label %case_1df0, label %ja_after_0005

ja_after_0005:
  %ugt_0005 = icmp ugt i32 %eax, -1073741819
  br i1 %ugt_0005, label %block_1d80, label %cmp_80000002

cmp_80000002:
  %eq_80000002 = icmp eq i32 %eax, -2147483646
  br i1 %eq_80000002, label %ret_default, label %fallback

block_1d80:
  %eq_0008 = icmp eq i32 %eax, -1073741816
  br i1 %eq_0008, label %ret_default, label %cmp_001D

cmp_001D:
  %eq_001D = icmp eq i32 %eax, -1073741795
  br i1 %eq_001D, label %case_1d8e, label %fallback

case_1df0:
  %call4 = call i64 @sub_1400027A8(i32 11, i32 0)
  %eq4 = icmp eq i64 %call4, 1
  br i1 %eq4, label %do_b_1_then_default, label %test_nonzero4

test_nonzero4:
  %iszero4 = icmp eq i64 %call4, 0
  br i1 %iszero4, label %fallback, label %callfp_ecxB

callfp_ecxB:
  %fpb = inttoptr i64 %call4 to void (i32)*
  call void %fpb(i32 11)
  br label %ret_default

do_b_1_then_default:
  %tmp4 = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_default

fallback:
  %fpglob = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8**)* %fpglob, null
  br i1 %isnull, label %ret_zero, label %tailcall_glob

tailcall_glob:
  %res = tail call i32 %fpglob(i8** %rcx)
  ret i32 %res

ret_zero:
  ret i32 0

ret_default:
  ret i32 -1
}
; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002B68(i32 %ecx, i32 %edx)
declare void @sub_1400024E0()

@qword_1400070D0 = external global i32 (i8**)*, align 8

define i32 @sub_140002080(i8** %arg) local_unnamed_addr {
entry:
  %p = load i8*, i8** %arg, align 8
  %p_i32ptr = bitcast i8* %p to i32*
  %code = load i32, i32* %p_i32ptr, align 4
  %mask = and i32 %code, 553648127
  %is_magic = icmp eq i32 %mask, 541549379
  br i1 %is_magic, label %checkflag, label %flowA1

checkflag:
  %bptr = getelementptr i8, i8* %p, i64 4
  %b = load i8, i8* %bptr, align 1
  %b_and = and i8 %b, 1
  %flag_set = icmp ne i8 %b_and, 0
  br i1 %flag_set, label %flowA1, label %ret_m1

flowA1:
  %cmp_ja = icmp ugt i32 %code, 3221225622
  br i1 %cmp_ja, label %fallback, label %contA

contA:
  %cmp_jbe = icmp ule i32 %code, 3221225611
  br i1 %cmp_jbe, label %block110, label %rangeC000008C_96

block110:
  %is_0005 = icmp eq i32 %code, 3221225477
  br i1 %is_0005, label %block1C0, label %block110_cmp2

block110_cmp2:
  %gt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %gt_0005, label %block150, label %block110_low

block110_low:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_m1, label %fallback

block150:
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_m1, label %block_1D_checks

block_1D_checks:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %block15E, label %fallback

rangeC000008C_96:
  %is_0094 = icmp eq i32 %code, 3221225620
  br i1 %is_0094, label %block190, label %block0D0

block0D0:
  %call0 = call i64 @sub_140002B68(i32 8, i32 0)
  %call0_is1 = icmp eq i64 %call0, 1
  br i1 %call0_is1, label %block2224, label %block0D0_not1

block0D0_not1:
  %call0_is0 = icmp eq i64 %call0, 0
  br i1 %call0_is0, label %fallback, label %block1F0_from0D0

block1F0_from0D0:
  %fp0 = inttoptr i64 %call0 to void (i32)*
  call void %fp0(i32 8)
  br label %ret_m1

block190:
  %call1 = call i64 @sub_140002B68(i32 8, i32 0)
  %call1_is1 = icmp eq i64 %call1, 1
  br i1 %call1_is1, label %block190_eq1, label %block190_not1

block190_eq1:
  %tmp_call_set8 = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_m1

block190_not1:
  %call1_is0 = icmp eq i64 %call1, 0
  br i1 %call1_is0, label %fallback, label %block1F0_from190

block1F0_from190:
  %fp1 = inttoptr i64 %call1 to void (i32)*
  call void %fp1(i32 8)
  br label %ret_m1

block15E:
  %call2 = call i64 @sub_140002B68(i32 4, i32 0)
  %call2_is1 = icmp eq i64 %call2, 1
  br i1 %call2_is1, label %block210, label %block15E_not1

block15E_not1:
  %call2_is0 = icmp eq i64 %call2, 0
  br i1 %call2_is0, label %fallback, label %block_callrax4

block_callrax4:
  %fp2 = inttoptr i64 %call2 to void (i32)*
  call void %fp2(i32 4)
  br label %ret_m1

block1C0:
  %call3 = call i64 @sub_140002B68(i32 11, i32 0)
  %call3_is1 = icmp eq i64 %call3, 1
  br i1 %call3_is1, label %block1FC, label %block1C0_not1

block1C0_not1:
  %call3_is0 = icmp eq i64 %call3, 0
  br i1 %call3_is0, label %fallback, label %block_callraxB

block_callraxB:
  %fp3 = inttoptr i64 %call3 to void (i32)*
  call void %fp3(i32 11)
  br label %ret_m1

block1FC:
  %tmp_call_setB = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_m1

block210:
  %tmp_call_set4 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_m1

block2224:
  %tmp_call_set8_2 = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_m1

fallback:
  %fpglob = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnullg = icmp eq i32 (i8**)* %fpglob, null
  br i1 %isnullg, label %ret_zero, label %callglob

callglob:
  %retv = call i32 %fpglob(i8** %arg)
  ret i32 %retv

ret_zero:
  ret i32 0

ret_m1:
  ret i32 -1
}
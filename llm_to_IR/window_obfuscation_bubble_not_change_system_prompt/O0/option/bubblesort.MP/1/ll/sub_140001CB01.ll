; ModuleID = 'sub_140001CB0.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %codeptr = bitcast i8* %rdx to i32*
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 553648127
  %sigcmp = icmp eq i32 %masked, 541541187
  br i1 %sigcmp, label %checkflag, label %afterSig

checkflag:
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %bitset = icmp ne i8 %b1, 0
  br i1 %bitset, label %afterSig, label %ret_m1

afterSig:
  %cmp_ug_0096 = icmp ugt i32 %code, 3221225494
  br i1 %cmp_ug_0096, label %delegate, label %le_008b

le_008b:
  %cmp_ule_008b = icmp ule i32 %code, 3221225483
  br i1 %cmp_ule_008b, label %block_d40, label %range_008c_0096

range_008c_0096:
  switch i32 %code, label %ret_m1 [
    i32 3221225485, label %case_1D00
    i32 3221225486, label %case_1D00
    i32 3221225487, label %case_1D00
    i32 3221225488, label %case_1D00
    i32 3221225489, label %case_1D00
    i32 3221225491, label %case_1D00
    i32 3221225492, label %case_1DC0
    i32 3221225494, label %case_1D8E
    i32 3221225490, label %ret_m1
    i32 3221225493, label %ret_m1
  ]

case_1D00:
  %r1 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r1_is1 = icmp eq i64 %r1, 1
  br i1 %r1_is1, label %case_1D00_eq1, label %case_1D00_not1

case_1D00_not1:
  %r1_is0 = icmp eq i64 %r1, 0
  br i1 %r1_is0, label %delegate, label %case_1E20

case_1D00_eq1:
  %r1b = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

case_1E20:
  %fp1 = inttoptr i64 %r1 to void (i32)*
  call void %fp1(i32 8)
  br label %ret_m1

case_1DC0:
  %r2 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r2_is1 = icmp eq i64 %r2, 1
  br i1 %r2_is1, label %case_1DC0_eq1, label %case_1DC0_not1

case_1DC0_not1:
  %r2_is0 = icmp eq i64 %r2, 0
  br i1 %r2_is0, label %delegate, label %case_1DC0_call

case_1DC0_eq1:
  %r2b = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

case_1DC0_call:
  %fp2 = inttoptr i64 %r2 to void (i32)*
  call void %fp2(i32 8)
  br label %ret_m1

case_1D8E:
  %r3 = call i64 @sub_1400027A8(i32 4, i32 0)
  %r3_is1 = icmp eq i64 %r3, 1
  br i1 %r3_is1, label %case_1E40, label %case_1D8E_not1

case_1E40:
  %r3b = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

case_1D8E_not1:
  %r3_is0 = icmp eq i64 %r3, 0
  br i1 %r3_is0, label %delegate, label %case_1D8E_call

case_1D8E_call:
  %fp3 = inttoptr i64 %r3 to void (i32)*
  call void %fp3(i32 4)
  br label %ret_m1

case_1DF0:
  %r4 = call i64 @sub_1400027A8(i32 11, i32 0)
  %r4_is1 = icmp eq i64 %r4, 1
  br i1 %r4_is1, label %case_1E2C, label %case_1DF0_not1

case_1E2C:
  %r4b = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

case_1DF0_not1:
  %r4_is0 = icmp eq i64 %r4, 0
  br i1 %r4_is0, label %delegate, label %case_1DF0_call

case_1DF0_call:
  %fp4 = inttoptr i64 %r4 to void (i32)*
  call void %fp4(i32 11)
  br label %ret_m1

block_d40:
  %is_0005 = icmp eq i32 %code, 3221225477
  br i1 %is_0005, label %case_1DF0, label %d40_after

d40_after:
  %ug_0005 = icmp ugt i32 %code, 3221225477
  br i1 %ug_0005, label %block_1D80, label %d40_below

d40_below:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_m1, label %delegate

block_1D80:
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_m1, label %check_001d

check_001d:
  %is_001d = icmp eq i32 %code, 3221225501
  br i1 %is_001d, label %case_1D8E, label %delegate

delegate:
  %fpglob = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8**)* %fpglob, null
  br i1 %isnull, label %ret_0, label %tailcall

tailcall:
  %res = call i32 %fpglob(i8** %rcx)
  ret i32 %res

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}
; ModuleID = 'sub_140001CB0'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external dso_local global i32 (i8**)*, align 8

declare dso_local void @sub_1400027A8(i32, i32)

define dso_local i32 @sub_140001CB0(i8** %rcx) {
entry:
  %p = load i8*, i8** %rcx, align 8
  %p_i32 = bitcast i8* %p to i32*
  %code = load i32, i32* %p_i32, align 4
  %masked = and i32 %code, 50331647
  %is_magic = icmp eq i32 %masked, 38228803
  br i1 %is_magic, label %check_flag, label %cmp1

check_flag:
  %p_plus4 = getelementptr i8, i8* %p, i64 4
  %byte = load i8, i8* %p_plus4, align 1
  %bit = and i8 %byte, 1
  %nz = icmp ne i8 %bit, 0
  br i1 %nz, label %cmp1, label %ret_neg1

cmp1:
  %ugt_0096 = icmp ugt i32 %code, 3221225622
  br i1 %ugt_0096, label %tail, label %range_check2

range_check2:
  %ule_008B = icmp ule i32 %code, 3221225611
  br i1 %ule_008B, label %block1D40, label %switchrange

block1D40:
  %eq_0005 = icmp eq i32 %code, 3221225477
  br i1 %eq_0005, label %call_b, label %gt05

call_b:
  call void @sub_1400027A8(i32 11, i32 0)
  br label %tail

gt05:
  %ugt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %ugt_0005, label %block1D80, label %lt05path

lt05path:
  %eq_80000002 = icmp eq i32 %code, 2147483650
  br i1 %eq_80000002, label %ret_neg1, label %tail

block1D80:
  %eq_0008 = icmp eq i32 %code, 3221225480
  br i1 %eq_0008, label %ret_neg1, label %check_001D

check_001D:
  %eq_001D = icmp eq i32 %code, 3221225501
  br i1 %eq_001D, label %call4, label %tail

call4:
  call void @sub_1400027A8(i32 4, i32 0)
  br label %tail

switchrange:
  %is_0092 = icmp eq i32 %code, 3221225618
  %is_0095 = icmp eq i32 %code, 3221225621
  %is_def = or i1 %is_0092, %is_0095
  br i1 %is_def, label %ret_neg1, label %check_0096

check_0096:
  %is_0096 = icmp eq i32 %code, 3221225622
  br i1 %is_0096, label %call4_sr, label %call8_sr

call4_sr:
  call void @sub_1400027A8(i32 4, i32 0)
  br label %tail

call8_sr:
  call void @sub_1400027A8(i32 8, i32 0)
  br label %tail

ret_neg1:
  ret i32 -1

tail:
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8**)* %fp, null
  br i1 %isnull, label %ret_zero, label %do_tailcall

ret_zero:
  ret i32 0

do_tailcall:
  %res = musttail call i32 %fp(i8** %rcx)
  ret i32 %res
}
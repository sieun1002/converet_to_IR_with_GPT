; ModuleID = 'seh_dispatcher'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i64 (i8**)*, align 8

declare i64 @sub_140002B68(i32 %ecx, i32 %edx)
declare void @sub_1400024E0()

define i64 @sub_140002080(i8** %arg) local_unnamed_addr {
entry:
  %p = load i8*, i8** %arg, align 8
  %p32 = bitcast i8* %p to i32*
  %status = load i32, i32* %p32, align 4
  %masked = and i32 %status, 553648127
  %cmp_magic = icmp eq i32 %masked, 541475651
  br i1 %cmp_magic, label %check_flag, label %switchentry

check_flag:
  %p4 = getelementptr i8, i8* %p, i64 4
  %b = load i8, i8* %p4, align 1
  %b1 = and i8 %b, 1
  %bit = icmp ne i8 %b1, 0
  br i1 %bit, label %switchentry, label %ret_minus1

switchentry:
  %cmp_ja = icmp ugt i32 %status, 3221225622
  br i1 %cmp_ja, label %fallback, label %cmp_le_8B

cmp_le_8B:
  %cmp_jbe = icmp ule i32 %status, 3221225611
  br i1 %cmp_jbe, label %group_low, label %compute_index

compute_index:
  %idx_pre = add i32 %status, 1073741683
  %idx_ok = icmp ule i32 %idx_pre, 9
  br i1 %idx_ok, label %switch, label %ret_minus1

switch:
  switch i32 %idx_pre, label %ret_minus1 [
    i32 0, label %case_ecx8_common
    i32 1, label %case_ecx8_common
    i32 2, label %case_ecx8_common
    i32 3, label %case_ecx8_common
    i32 4, label %case_ecx8_common
    i32 5, label %ret_minus1
    i32 6, label %case_ecx8_common
    i32 7, label %case_0xC0000094
    i32 8, label %ret_minus1
    i32 9, label %case_ecx4_common
  ]

group_low:
  %is_c0000005 = icmp eq i32 %status, 3221225477
  br i1 %is_c0000005, label %case_0xC0000005, label %after_0005

after_0005:
  %ugt_0005 = icmp ugt i32 %status, 3221225477
  br i1 %ugt_0005, label %group_mid, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %status, 2147483650
  br i1 %is_80000002, label %ret_minus1, label %fallback

group_mid:
  %is_c0000008 = icmp eq i32 %status, 3221225480
  br i1 %is_c0000008, label %ret_minus1, label %check_c000001d

check_c000001d:
  %is_c000001d = icmp eq i32 %status, 3221225501
  br i1 %is_c000001d, label %case_ecx4_common, label %fallback

case_ecx8_common:
  %r0 = call i64 @sub_140002B68(i32 8, i32 0)
  %is1 = icmp eq i64 %r0, 1
  br i1 %is1, label %case_ecx8_then1, label %case_ecx8_else

case_ecx8_then1:
  %r1 = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_minus1

case_ecx8_else:
  %is0 = icmp eq i64 %r0, 0
  br i1 %is0, label %fallback, label %call_r0_ecx8

call_r0_ecx8:
  %fp8 = inttoptr i64 %r0 to void (i32)*
  call void %fp8(i32 8)
  br label %ret_minus1

case_0xC0000094:
  %r2 = call i64 @sub_140002B68(i32 8, i32 0)
  %r2_is1 = icmp eq i64 %r2, 1
  br i1 %r2_is1, label %c94_then1, label %c94_else

c94_then1:
  %r2b = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_minus1

c94_else:
  %r2_is0 = icmp eq i64 %r2, 0
  br i1 %r2_is0, label %fallback, label %c94_call

c94_call:
  %fp8b = inttoptr i64 %r2 to void (i32)*
  call void %fp8b(i32 8)
  br label %ret_minus1

case_ecx4_common:
  %r3 = call i64 @sub_140002B68(i32 4, i32 0)
  %r3_is1 = icmp eq i64 %r3, 1
  br i1 %r3_is1, label %case_ecx4_then1, label %case_ecx4_else

case_ecx4_then1:
  %r3b = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_minus1

case_ecx4_else:
  %r3_is0 = icmp eq i64 %r3, 0
  br i1 %r3_is0, label %fallback, label %call_r3_ecx4

call_r3_ecx4:
  %fp4 = inttoptr i64 %r3 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_minus1

case_0xC0000005:
  %r4 = call i64 @sub_140002B68(i32 11, i32 0)
  %r4_is1 = icmp eq i64 %r4, 1
  br i1 %r4_is1, label %case_0xC0000005_then1, label %case_0xC0000005_else

case_0xC0000005_then1:
  %r4b = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_minus1

case_0xC0000005_else:
  %r4_is0 = icmp eq i64 %r4, 0
  br i1 %r4_is0, label %fallback, label %call_r4_ecxB

call_r4_ecxB:
  %fpB = inttoptr i64 %r4 to void (i32)*
  call void %fpB(i32 11)
  br label %ret_minus1

fallback:
  %h = load i64 (i8**)*, i64 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i64 (i8**)* %h, null
  br i1 %isnull, label %ret_zero, label %call_handler

call_handler:
  %ret = tail call i64 %h(i8** %arg)
  ret i64 %ret

ret_zero:
  ret i64 0

ret_minus1:
  ret i64 4294967295
}
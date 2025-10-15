; ModuleID = 'sub_140002080.ll'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002B68(i32, i32)
declare void @sub_1400024E0()
@qword_1400070D0 = external global i32 (i8**)*

define i32 @sub_140002080(i8** %p) {
entry:
  %rdxptr = load i8*, i8** %p, align 8
  %rdx_i32ptr = bitcast i8* %rdxptr to i32*
  %eax32 = load i32, i32* %rdx_i32ptr, align 4
  %masked = and i32 %eax32, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %check_byte, label %A1

check_byte:
  %rdx_plus4 = getelementptr i8, i8* %rdxptr, i64 4
  %b = load i8, i8* %rdx_plus4, align 1
  %b1 = and i8 %b, 1
  %bnz = icmp ne i8 %b1, 0
  br i1 %bnz, label %A1, label %ret_minus1

A1:
  %cmp_ugt_0096 = icmp ugt i32 %eax32, 3221225622
  br i1 %cmp_ugt_0096, label %fallback, label %range_check1

range_check1:
  %cmp_ule_008B = icmp ule i32 %eax32, 3221225611
  br i1 %cmp_ule_008B, label %block110, label %switch_range

block110:
  %is_0005 = icmp eq i32 %eax32, 3221225477
  br i1 %is_0005, label %block1C0, label %after_0005

after_0005:
  %ugt_0005 = icmp ugt i32 %eax32, 3221225477
  br i1 %ugt_0005, label %block150, label %after_ja

after_ja:
  %eq_dbg = icmp eq i32 %eax32, 2147483650
  br i1 %eq_dbg, label %ret_minus1, label %fallback

block150:
  %eq_0008 = icmp eq i32 %eax32, 3221225480
  br i1 %eq_0008, label %ret_minus1, label %after_0008

after_0008:
  %eq_001D = icmp eq i32 %eax32, 3221225501
  br i1 %eq_001D, label %block15E, label %fallback

switch_range:
  switch i32 %eax32, label %ret_minus1 [
    i32 3221225613, label %block0D0
    i32 3221225614, label %block0D0
    i32 3221225615, label %block0D0
    i32 3221225616, label %block0D0
    i32 3221225617, label %block0D0
    i32 3221225619, label %block0D0
    i32 3221225620, label %block190
    i32 3221225622, label %block15E
  ]

block0D0:
  %c0 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one = icmp eq i64 %c0, 1
  br i1 %is_one, label %case0D0_one, label %case0D0_not_one

case0D0_not_one:
  %is_zero = icmp eq i64 %c0, 0
  br i1 %is_zero, label %fallback, label %call_handler8

call_handler8:
  %fp = inttoptr i64 %c0 to void (i32)*
  call void %fp(i32 8)
  br label %ret_minus1

case0D0_one:
  %c1 = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_minus1

block190:
  %r = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one2 = icmp eq i64 %r, 1
  br i1 %is_one2, label %case190_one, label %case190_else

case190_else:
  %is_zero2 = icmp eq i64 %r, 0
  br i1 %is_zero2, label %fallback, label %call_handler8_2

call_handler8_2:
  %fp2 = inttoptr i64 %r to void (i32)*
  call void %fp2(i32 8)
  br label %ret_minus1

case190_one:
  %c2 = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_minus1

block1C0:
  %r3 = call i64 @sub_140002B68(i32 11, i32 0)
  %is_one3 = icmp eq i64 %r3, 1
  br i1 %is_one3, label %block1FC, label %block1C0_cont

block1C0_cont:
  %is_zero3 = icmp eq i64 %r3, 0
  br i1 %is_zero3, label %fallback, label %call_handler0B

call_handler0B:
  %fp3 = inttoptr i64 %r3 to void (i32)*
  call void %fp3(i32 11)
  br label %ret_minus1

block1FC:
  %dummy = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_minus1

block15E:
  %r4 = call i64 @sub_140002B68(i32 4, i32 0)
  %is_one4 = icmp eq i64 %r4, 1
  br i1 %is_one4, label %block210, label %block15E_cont

block15E_cont:
  %is_zero4 = icmp eq i64 %r4, 0
  br i1 %is_zero4, label %fallback, label %call_handler04

call_handler04:
  %fp4 = inttoptr i64 %r4 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_minus1

block210:
  %r5 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_minus1

fallback:
  %cbptr = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %cbnull = icmp eq i32 (i8**)* %cbptr, null
  br i1 %cbnull, label %ret_zero, label %tailcall

ret_zero:
  ret i32 0

tailcall:
  %res = tail call i32 %cbptr(i8** %p)
  ret i32 %res

ret_minus1:
  ret i32 -1
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

@qword_1400070D0 = external global i32 (i8**)*

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx
  %p32 = bitcast i8* %rdx to i32*
  %eax0 = load i32, i32* %p32
  %masked = and i32 %eax0, 553648127
  %is_magic = icmp eq i32 %masked, 541541187
  br i1 %is_magic, label %checkflag, label %chain

checkflag:
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr
  %b1 = and i8 %b, 1
  %flag_set = icmp ne i8 %b1, 0
  br i1 %flag_set, label %chain, label %default_return

chain:
  %gt_0096 = icmp ugt i32 %eax0, 3221225622
  br i1 %gt_0096, label %fallback, label %chain2

chain2:
  %le_008B = icmp ule i32 %eax0, 3221225611
  br i1 %le_008B, label %blk_d40, label %switch_path

blk_d40:
  %eq_0005 = icmp eq i32 %eax0, 3221225477
  br i1 %eq_0005, label %blk_df0, label %blk_d40_after5

blk_d40_after5:
  %gt_0005 = icmp ugt i32 %eax0, 3221225477
  br i1 %gt_0005, label %blk_d80, label %blk_d40_less5

blk_d40_less5:
  %eq_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %eq_80000002, label %default_return, label %fallback

blk_d80:
  %eq_0008 = icmp eq i32 %eax0, 3221225480
  br i1 %eq_0008, label %default_return, label %d80_after8

d80_after8:
  %eq_001D = icmp eq i32 %eax0, 3221225501
  br i1 %eq_001D, label %blk_d8e, label %fallback

switch_path:
  %is_0094 = icmp eq i32 %eax0, 3221225620
  br i1 %is_0094, label %blk_dc0, label %sw_after94

sw_after94:
  %is_0096 = icmp eq i32 %eax0, 3221225622
  br i1 %is_0096, label %blk_d8e, label %sw_group

sw_group:
  %is_008D = icmp eq i32 %eax0, 3221225613
  %is_008E = icmp eq i32 %eax0, 3221225614
  %is_008F = icmp eq i32 %eax0, 3221225615
  %is_0090 = icmp eq i32 %eax0, 3221225616
  %is_0091 = icmp eq i32 %eax0, 3221225617
  %is_0093 = icmp eq i32 %eax0, 3221225619
  %or1 = or i1 %is_008D, %is_008E
  %or2 = or i1 %is_008F, %is_0090
  %or3 = or i1 %is_0091, %is_0093
  %or12 = or i1 %or1, %or2
  %org = or i1 %or12, %or3
  br i1 %org, label %blk_d00, label %default_return

blk_d00:
  %call_d00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_d00 = icmp eq i64 %call_d00, 1
  br i1 %is_one_d00, label %blk_e54, label %test_rax_ecx8

test_rax_ecx8:
  %ret_phi = phi i64 [ %call_d00, %blk_d00 ], [ %call_dc0, %dc0_else ]
  %nonzero = icmp ne i64 %ret_phi, 0
  br i1 %nonzero, label %blk_e20, label %fallback

blk_e54:
  %call_e54a = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %default_return

blk_e20:
  %fp_e20 = inttoptr i64 %ret_phi to void (i32)*
  call void %fp_e20(i32 8)
  br label %default_return

blk_dc0:
  %call_dc0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_dc0 = icmp eq i64 %call_dc0, 1
  br i1 %is_one_dc0, label %dc0_then1, label %dc0_else

dc0_then1:
  %call_dc0b = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %default_return

dc0_else:
  br label %test_rax_ecx8

blk_df0:
  %call_df0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is_one_df0 = icmp eq i64 %call_df0, 1
  br i1 %is_one_df0, label %blk_e2c, label %df0_after

blk_e2c:
  %call_e2c = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %default_return

df0_after:
  %nonzero_df0 = icmp ne i64 %call_df0, 0
  br i1 %nonzero_df0, label %df0_call, label %fallback

df0_call:
  %fp_df0 = inttoptr i64 %call_df0 to void (i32)*
  call void %fp_df0(i32 11)
  br label %default_return

blk_d8e:
  %call_d8e = call i64 @sub_1400027A8(i32 4, i32 0)
  %is_one_d8e = icmp eq i64 %call_d8e, 1
  br i1 %is_one_d8e, label %blk_e40, label %d8e_after

blk_e40:
  %call_e40 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %default_return

d8e_after:
  %nonzero_d8e = icmp ne i64 %call_d8e, 0
  br i1 %nonzero_d8e, label %d8e_call, label %fallback

d8e_call:
  %fp_d8e = inttoptr i64 %call_d8e to void (i32)*
  call void %fp_d8e(i32 4)
  br label %default_return

fallback:
  %fpglob = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %isnull = icmp eq i32 (i8**)* %fpglob, null
  br i1 %isnull, label %ret0, label %tailjmp

tailjmp:
  %res = tail call i32 %fpglob(i8** %rcx)
  ret i32 %res

ret0:
  ret i32 0

default_return:
  ret i32 -1
}
; ModuleID = 'sub_140001CB0'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i64 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx
  %rdx_i32p = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %rdx_i32p
  %masked = and i32 %eax, 541541187
  %cmp_mask = icmp eq i32 %masked, 541541187
  br i1 %cmp_mask, label %special, label %range_check

special:                                          ; corresponds to 0x140001D60 path
  %byte4.ptr = getelementptr inbounds i8, i8* %rdx, i64 4
  %byte4 = load i8, i8* %byte4.ptr
  %bit = and i8 %byte4, 1
  %nz = icmp ne i8 %bit, 0
  br i1 %nz, label %range_check, label %ret_minus1

range_check:
  %cmp_ugt_max = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_ugt_max, label %fallback, label %rc2

rc2:
  %cmp_ule_low = icmp ule i32 %eax, 3221225611
  br i1 %cmp_ule_low, label %block_d40, label %in_8c_96

in_8c_96:
  %is_div0 = icmp eq i32 %eax, 3221225618
  br i1 %is_div0, label %case_dc0, label %case_d00

; cases 0xC000008C..0xC0000096 except 0xC0000094
case_d00:                                         ; 0x140001D00
  %d00_r = call i64 @sub_1400027A8(i32 8, i32 0)
  %d00_is1 = icmp eq i64 %d00_r, 1
  br i1 %d00_is1, label %block_e54, label %d00_chk

d00_chk:
  %d00_nz = icmp ne i64 %d00_r, 0
  br i1 %d00_nz, label %callptr_ecx8, label %fallback

; case 0xC0000094
case_dc0:                                         ; 0x140001DC0
  %dc0_r = call i64 @sub_1400027A8(i32 8, i32 0)
  %dc0_is1 = icmp eq i64 %dc0_r, 1
  br i1 %dc0_is1, label %e54_pre, label %d16_path

d16_path:                                         ; corresponds to 0x140001D16 handling
  %dc0_nz = icmp ne i64 %dc0_r, 0
  br i1 %dc0_nz, label %callptr_ecx8, label %fallback

callptr_ecx8:                                     ; 0x140001E20
  %ptr_phi8 = phi i64 [ %d00_r, %d00_chk ], [ %dc0_r, %d16_path ]
  %fp8 = inttoptr i64 %ptr_phi8 to i64 (i32)*
  %res8 = call i64 %fp8(i32 8)
  br label %ret_minus1

block_e54:                                        ; 0x140001E54
  %tmp0 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_minus1

e54_pre:
  %tmp1 = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %ret_minus1

block_d40:
  %is_av = icmp eq i32 %eax, 3221225477
  br i1 %is_av, label %block_df0, label %after_d40_cmp

after_d40_cmp:
  %ugt_5 = icmp ugt i32 %eax, 3221225477
  br i1 %ugt_5, label %block_d80, label %chk_80000002

chk_80000002:
  %is_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %is_80000002, label %ret_minus1, label %fallback

block_d80:
  %is_c0000008 = icmp eq i32 %eax, 3221225480
  br i1 %is_c0000008, label %ret_minus1, label %chk_c000001d

chk_c000001d:
  %is_c000001d = icmp eq i32 %eax, 3221225501
  br i1 %is_c000001d, label %block_d8e, label %fallback

block_d8e:                                        ; 0x140001D8E
  %r4 = call i64 @sub_1400027A8(i32 4, i32 0)
  %r4_is1 = icmp eq i64 %r4, 1
  br i1 %r4_is1, label %block_e40, label %chk_r4_zero

chk_r4_zero:
  %r4_is0 = icmp eq i64 %r4, 0
  br i1 %r4_is0, label %fallback, label %callptr_ecx4

block_e40:                                        ; 0x140001E40
  %tmp2 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %ret_minus1

callptr_ecx4:
  %fp4 = inttoptr i64 %r4 to i64 (i32)*
  %res4 = call i64 %fp4(i32 4)
  br label %ret_minus1

block_df0:                                        ; 0x140001DF0
  %rB = call i64 @sub_1400027A8(i32 11, i32 0)
  %rB_is1 = icmp eq i64 %rB, 1
  br i1 %rB_is1, label %block_e2c, label %chk_rB_zero

chk_rB_zero:
  %rB_is0 = icmp eq i64 %rB, 0
  br i1 %rB_is0, label %fallback, label %callptr_ecxB

block_e2c:                                        ; 0x140001E2C
  %tmp3 = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %ret_minus1

callptr_ecxB:
  %fpB = inttoptr i64 %rB to i64 (i32)*
  %resB = call i64 %fpB(i32 11)
  br label %ret_minus1

fallback:                                         ; 0x140001D1F path
  %p = load i8*, i8** @qword_1400070D0
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret_zero, label %tailcall

tailcall:
  %fp = bitcast i8* %p to i64 (i8**)*
  %res = tail call i64 %fp(i8** %rcx)
  ret i64 %res

ret_minus1:
  ret i64 4294967295

ret_zero:
  ret i64 0
}
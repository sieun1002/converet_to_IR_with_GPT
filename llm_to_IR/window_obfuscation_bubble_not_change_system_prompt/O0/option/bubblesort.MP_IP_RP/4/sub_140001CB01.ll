; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external dso_local global i32 (i8**)*

declare dso_local void @sub_1400027A8(i32, i32)

define dso_local i32 @sub_140001CB0(i8** %rcx) local_unnamed_addr {
entry:
  %rdx.ptr = load i8*, i8** %rcx, align 8
  %rdx.i32p = bitcast i8* %rdx.ptr to i32*
  %eax0 = load i32, i32* %rdx.i32p, align 4
  %mask = and i32 %eax0, 553648127
  %cmpsig = icmp eq i32 %mask, 541541187
  br i1 %cmpsig, label %sig_ok, label %range_check

sig_ok:                                           ; corresponds to 0x140001D60
  %byte.p = getelementptr inbounds i8, i8* %rdx.ptr, i64 4
  %b = load i8, i8* %byte.p, align 1
  %b1 = and i8 %b, 1
  %bit_set = icmp ne i8 %b1, 0
  br i1 %bit_set, label %range_check, label %ret_neg1

range_check:                                      ; corresponds to 0x140001CD1
  %gt_max = icmp ugt i32 %eax0, 3221225622
  br i1 %gt_max, label %tail_fallback, label %le_upper_8B

le_upper_8B:                                      ; corresponds to 0x140001CD8 path
  %le_8B = icmp ule i32 %eax0, 3221225611
  br i1 %le_8B, label %blk_1D40, label %switch_block

blk_1D40:                                         ; corresponds to 0x140001D40
  %is_av = icmp eq i32 %eax0, 3221225477
  br i1 %is_av, label %case_1DF0, label %gt_av

gt_av:                                            ; eax > 0xC0000005?
  %ugt_av = icmp ugt i32 %eax0, 3221225477
  br i1 %ugt_av, label %blk_1D80, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %is_80000002, label %ret_neg1, label %tail_fallback

blk_1D80:                                         ; corresponds to 0x140001D80
  %is_c0000008 = icmp eq i32 %eax0, 3221225480
  br i1 %is_c0000008, label %ret_neg1, label %check_c000001d

check_c000001d:
  %is_c000001d = icmp eq i32 %eax0, 3221225501
  br i1 %is_c000001d, label %case_1D8E, label %tail_fallback

switch_block:                                     ; corresponds to 0x140001CDF..CF7
  switch i32 %eax0, label %ret_neg1 [
    i32 3221225613, label %case_1D00
    i32 3221225614, label %case_1D00
    i32 3221225615, label %case_1D00
    i32 3221225616, label %case_1D00
    i32 3221225617, label %case_1D00
    i32 3221225619, label %case_1D00
    i32 3221225620, label %case_1DC0
    i32 3221225622, label %case_1D8E
  ]

case_1D00:                                        ; corresponds to 0x140001D00
  call void @sub_1400027A8(i32 8, i32 0)
  br label %tail_fallback

case_1DC0:                                        ; corresponds to 0x140001DC0
  call void @sub_1400027A8(i32 8, i32 0)
  br label %tail_fallback

case_1D8E:                                        ; corresponds to 0x140001D8E
  call void @sub_1400027A8(i32 4, i32 0)
  br label %tail_fallback

case_1DF0:                                        ; corresponds to 0x140001DF0
  call void @sub_1400027A8(i32 11, i32 0)
  br label %tail_fallback

tail_fallback:                                    ; corresponds to 0x140001D1F
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %has_fp = icmp ne i32 (i8**)* %fp, null
  br i1 %has_fp, label %do_tail, label %ret_zero

do_tail:
  %res = call i32 %fp(i8** %rcx)
  ret i32 %res

ret_zero:                                         ; corresponds to 0x140001D70
  ret i32 0

ret_neg1:                                         ; corresponds to 0x140001D54 and default cases
  ret i32 -1
}
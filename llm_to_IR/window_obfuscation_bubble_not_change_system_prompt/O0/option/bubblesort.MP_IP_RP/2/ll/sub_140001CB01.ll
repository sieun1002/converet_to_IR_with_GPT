; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400027A8(i32, i32)
@qword_1400070D0 = external global i32 (i8**)*

define i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx.ptr = load i8*, i8** %rcx, align 8
  %code.ptr = bitcast i8* %rdx.ptr to i32*
  %code = load i32, i32* %code.ptr, align 4
  %masked = and i32 %code, 553648127
  %cmp.magic = icmp eq i32 %masked, 541541187
  br i1 %cmp.magic, label %check_flag, label %after_magic

check_flag:                                       ; loc_140001D60 path
  %byte.ptr = getelementptr i8, i8* %rdx.ptr, i64 4
  %byte = load i8, i8* %byte.ptr, align 1
  %bit.and = and i8 %byte, 1
  %bit.nz = icmp ne i8 %bit.and, 0
  br i1 %bit.nz, label %cont_cd1, label %ret_neg1

after_magic:
  br label %cont_cd1

cont_cd1:                                         ; loc_140001CD1 onward
  %cmp_hi_0096 = icmp ugt i32 %code, 3221225622
  br i1 %cmp_hi_0096, label %common_tail, label %cmp_le_008B

cmp_le_008B:
  %cmp_le_008B_res = icmp ule i32 %code, 3221225611
  br i1 %cmp_le_008B_res, label %branch_d40, label %switch_range

; Handle <= 0xC000008B cases
branch_d40:                                       ; loc_140001D40
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %call_11, label %gt_0005

gt_0005:                                          ; ja 0xC0000005
  %ugt_0005 = icmp ugt i32 %code, 3221225477
  br i1 %ugt_0005, label %branch_d80, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_neg1, label %common_tail

; Handle > 0xC0000005 cases in this branch
branch_d80:                                       ; loc_140001D80
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_neg1, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %call_4, label %common_tail

; Switch for 0xC000008C..0xC0000096 subset
switch_range:                                     ; via jumptable logic
  switch i32 %code, label %ret_neg1 [
    i32 3221225613, label %call_8        ; 0xC000008D
    i32 3221225614, label %call_8        ; 0xC000008E
    i32 3221225615, label %call_8        ; 0xC000008F
    i32 3221225616, label %call_8        ; 0xC0000090
    i32 3221225617, label %call_8        ; 0xC0000091
    i32 3221225619, label %call_8        ; 0xC0000093
    i32 3221225620, label %call_8        ; 0xC0000094
    i32 3221225622, label %call_4        ; 0xC0000096
  ]

call_11:                                          ; loc_140001DF0
  call void @sub_1400027A8(i32 11, i32 0)
  br label %common_tail

call_8:                                           ; loc_140001D00 / 0x140001DC0 style
  call void @sub_1400027A8(i32 8, i32 0)
  br label %common_tail

call_4:                                           ; loc_140001D8E
  call void @sub_1400027A8(i32 4, i32 0)
  br label %common_tail

common_tail:                                      ; loc_140001D1F
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8**)* %fp, null
  br i1 %isnull, label %ret_zero, label %tailinvoke

tailinvoke:
  %res = tail call i32 %fp(i8** %rcx)
  ret i32 %res

ret_zero:                                         ; loc_140001D70
  ret i32 0

ret_neg1:                                         ; default returns -1
  ret i32 -1
}
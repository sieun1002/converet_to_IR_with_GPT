; ModuleID = 'sub_140001CB0'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*, align 8

declare void @sub_1400027A8(i32, i32)

define i32 @sub_140001CB0(i8** %rcx) local_unnamed_addr {
entry:
  %p = load i8*, i8** %rcx, align 8
  %p_i32 = bitcast i8* %p to i32*
  %status = load i32, i32* %p_i32, align 4
  %masked = and i32 %status, 553648127
  %cmp_magic = icmp eq i32 %masked, 541541187
  br i1 %cmp_magic, label %check_flag, label %cont

check_flag:                                        ; preds = %entry
  %p_plus4 = getelementptr inbounds i8, i8* %p, i64 4
  %byte4 = load i8, i8* %p_plus4, align 1
  %bit1 = and i8 %byte4, 1
  %bitnz = icmp ne i8 %bit1, 0
  br i1 %bitnz, label %cont, label %ret_minus1

cont:                                              ; preds = %check_flag, %entry
  %cmp_ja_C0000096 = icmp ugt i32 %status, 3221225622
  br i1 %cmp_ja_C0000096, label %tailcall, label %cmp_jbe_C000008B

cmp_jbe_C000008B:                                  ; preds = %cont
  %cmp_jbe = icmp ule i32 %status, 3221225611
  br i1 %cmp_jbe, label %le_8B, label %range_mid

range_mid:                                         ; preds = %cmp_jbe_C000008B
  switch i32 %status, label %default_switch [
    i32 3221225613, label %case8
    i32 3221225614, label %case8
    i32 3221225615, label %case8
    i32 3221225616, label %case8
    i32 3221225617, label %case8
    i32 3221225618, label %default_switch
    i32 3221225619, label %case8
    i32 3221225620, label %case8
    i32 3221225621, label %default_switch
    i32 3221225622, label %case4
  ]

case8:                                             ; preds = %range_mid, %range_mid, %range_mid, %range_mid, %range_mid, %range_mid
  call void @sub_1400027A8(i32 8, i32 0)
  br label %tailcall

case4:                                             ; preds = %range_mid, %check_001D
  call void @sub_1400027A8(i32 4, i32 0)
  br label %tailcall

default_switch:                                    ; preds = %range_mid, %range_mid, %range_mid
  br label %ret_minus1

le_8B:                                             ; preds = %cmp_jbe_C000008B
  %is_0005 = icmp eq i32 %status, 3221225477
  br i1 %is_0005, label %case0B, label %le_8B_else

case0B:                                            ; preds = %le_8B
  call void @sub_1400027A8(i32 11, i32 0)
  br label %tailcall

le_8B_else:                                        ; preds = %le_8B
  %is_gt_0005 = icmp ugt i32 %status, 3221225477
  br i1 %is_gt_0005, label %block_1D80, label %check_80000002

block_1D80:                                        ; preds = %le_8B_else
  %is_0008 = icmp eq i32 %status, 3221225480
  br i1 %is_0008, label %ret_minus1, label %check_001D

check_001D:                                        ; preds = %block_1D80
  %is_001D = icmp eq i32 %status, 3221225501
  br i1 %is_001D, label %case4, label %tailcall

check_80000002:                                    ; preds = %le_8B_else
  %is_80000002 = icmp eq i32 %status, 2147483650
  br i1 %is_80000002, label %ret_minus1, label %tailcall

tailcall:                                          ; preds = %check_80000002, %check_001D, %case0B, %case4, %case8, %cont
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8**)* %fp, null
  br i1 %isnull, label %ret0, label %do_call

do_call:                                           ; preds = %tailcall
  %res = call i32 %fp(i8** %rcx)
  ret i32 %res

ret0:                                              ; preds = %tailcall
  ret i32 0

ret_minus1:                                        ; preds = %default_switch, %block_1D80, %check_80000002, %check_flag
  ret i32 -1
}
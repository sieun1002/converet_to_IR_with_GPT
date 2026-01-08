; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8*)*

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8* %rcx) {
entry:
  %rbx.save = bitcast i8* %rcx to i8*
  %rcx.as.pp = bitcast i8* %rcx to i8**
  %rdx0 = load i8*, i8** %rcx.as.pp, align 8
  %rdx.as.i32p = bitcast i8* %rdx0 to i32*
  %eax0 = load i32, i32* %rdx.as.i32p, align 4
  %masked = and i32 %eax0, 553648127
  %is.magic = icmp eq i32 %masked, 541541187
  br i1 %is.magic, label %blk_magic, label %blk_cd1

blk_magic:                                            ; preds = %entry
  %ptr.plus4 = getelementptr i8, i8* %rdx0, i64 4
  %b4 = load i8, i8* %ptr.plus4, align 1
  %b4.and1 = and i8 %b4, 1
  %nz = icmp ne i8 %b4.and1, 0
  br i1 %nz, label %blk_cd1, label %fallback

blk_cd1:                                              ; preds = %blk_magic, %entry
  %cmp_ja = icmp ugt i32 %eax0, -1073741674
  br i1 %cmp_ja, label %fallback, label %cmp_next

cmp_next:                                             ; preds = %blk_cd1
  %cmp_jbe = icmp ule i32 %eax0, -1073741685
  br i1 %cmp_jbe, label %blk_d40, label %range_check

range_check:                                          ; preds = %cmp_next
  %is_008D = icmp eq i32 %eax0, -1073741683
  %is_008E = icmp eq i32 %eax0, -1073741682
  %is_008F = icmp eq i32 %eax0, -1073741681
  %is_0090 = icmp eq i32 %eax0, -1073741680
  %is_0091 = icmp eq i32 %eax0, -1073741679
  %is_0093 = icmp eq i32 %eax0, -1073741677
  %grp1a = or i1 %is_008D, %is_008E
  %grp1b = or i1 %is_008F, %is_0090
  %grp1c = or i1 %grp1a, %grp1b
  %grp1d = or i1 %is_0091, %is_0093
  %grp1 = or i1 %grp1c, %grp1d
  br i1 %grp1, label %case_grp8, label %check_0094

check_0094:                                           ; preds = %range_check
  %is_0094 = icmp eq i32 %eax0, -1073741676
  br i1 %is_0094, label %case_0094, label %check_0096

check_0096:                                           ; preds = %check_0094
  %is_0096 = icmp eq i32 %eax0, -1073741674
  br i1 %is_0096, label %case_4, label %fallback

case_grp8:                                            ; preds = %range_check
  %r1 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r1.eq1 = icmp eq i64 %r1, 1
  br i1 %r1.eq1, label %grp8_eq1, label %grp8_not1

grp8_not1:                                            ; preds = %case_grp8
  %r1.ne0 = icmp ne i64 %r1, 0
  br i1 %r1.ne0, label %grp8_callfp, label %fallback

grp8_callfp:                                          ; preds = %grp8_not1
  %fp1 = inttoptr i64 %r1 to void (i32)*
  call void %fp1(i32 8)
  br label %fallback

grp8_eq1:                                             ; preds = %case_grp8
  %r2 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %fallback

case_0094:                                            ; preds = %check_0094
  %r3 = call i64 @sub_1400027A8(i32 8, i32 0)
  %r3.eq1 = icmp eq i64 %r3, 1
  br i1 %r3.eq1, label %case_0094_eq1, label %case_0094_not1

case_0094_not1:                                       ; preds = %case_0094
  %r3.ne0 = icmp ne i64 %r3, 0
  br i1 %r3.ne0, label %case_0094_callfp, label %fallback

case_0094_callfp:                                     ; preds = %case_0094_not1
  %fp3 = inttoptr i64 %r3 to void (i32)*
  call void %fp3(i32 8)
  br label %fallback

case_0094_eq1:                                        ; preds = %case_0094
  %r4 = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %fallback

case_4:                                               ; preds = %check_0096, %d80_else
  %r5 = call i64 @sub_1400027A8(i32 4, i32 0)
  %r5.eq1 = icmp eq i64 %r5, 1
  br i1 %r5.eq1, label %case_4_eq1, label %case_4_not1

case_4_not1:                                          ; preds = %case_4
  %r5.ne0 = icmp ne i64 %r5, 0
  br i1 %r5.ne0, label %case_4_callfp, label %fallback

case_4_callfp:                                        ; preds = %case_4_not1
  %fp5 = inttoptr i64 %r5 to void (i32)*
  call void %fp5(i32 4)
  br label %fallback

case_4_eq1:                                           ; preds = %case_4
  %r6 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %fallback

blk_d40:                                              ; preds = %cmp_next
  %is_av = icmp eq i32 %eax0, -1073741819
  br i1 %is_av, label %case_av, label %d40_else

d40_else:                                             ; preds = %blk_d40
  %ugt_av = icmp ugt i32 %eax0, -1073741819
  br i1 %ugt_av, label %blk_d80, label %d40_else2

d40_else2:                                            ; preds = %d40_else
  %is_80000002 = icmp eq i32 %eax0, -2147483646
  br i1 %is_80000002, label %ret_m1, label %fallback

ret_m1:                                               ; preds = %d40_else2
  ret i32 -1

blk_d80:                                              ; preds = %d40_else
  %is_bad_handle = icmp eq i32 %eax0, -1073741816
  br i1 %is_bad_handle, label %fallback, label %d80_else

d80_else:                                             ; preds = %blk_d80
  %is_illegal = icmp eq i32 %eax0, -1073741795
  br i1 %is_illegal, label %case_4, label %fallback

case_av:                                              ; preds = %blk_d40
  %r7 = call i64 @sub_1400027A8(i32 11, i32 0)
  %r7.eq1 = icmp eq i64 %r7, 1
  br i1 %r7.eq1, label %case_11_eq1, label %case_11_not1

case_11_not1:                                         ; preds = %case_av
  %r7.ne0 = icmp ne i64 %r7, 0
  br i1 %r7.ne0, label %case_11_callfp, label %fallback

case_11_callfp:                                       ; preds = %case_11_not1
  %fp7 = inttoptr i64 %r7 to void (i32)*
  call void %fp7(i32 11)
  br label %fallback

case_11_eq1:                                          ; preds = %case_av
  %r8 = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %fallback

fallback:                                             ; preds = %case_11_eq1, %case_11_callfp, %case_11_not1, %d80_else, %blk_d80, %d40_else2, %grp8_eq1, %grp8_callfp, %grp8_not1, %case_0094_eq1, %case_0094_callfp, %case_0094_not1, %case_4_eq1, %case_4_callfp, %case_4_not1, %check_0096, %check_0094, %blk_cd1, %blk_magic, %range_check
  %p = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8*)* %p, null
  br i1 %isnull, label %ret_zero, label %tail

ret_zero:                                             ; preds = %fallback
  ret i32 0

tail:                                                 ; preds = %fallback
  %retv = tail call i32 %p(i8* %rbx.save)
  ret i32 %retv
}
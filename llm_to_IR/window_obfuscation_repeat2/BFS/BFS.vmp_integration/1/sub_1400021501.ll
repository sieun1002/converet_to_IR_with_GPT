; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i64 @sub_140002C48(i32, i32)
declare void @sub_1400025C0()

define i32 @sub_140002150(i8* %rcx_param) {
entry:
  %rdxptr = bitcast i8* %rcx_param to i8**
  %p = load i8*, i8** %rdxptr, align 8
  %p_i32 = bitcast i8* %p to i32*
  %eax = load i32, i32* %p_i32, align 4

  ; check masked magic
  %masked = and i32 %eax, 553648127          ; 0x20FFFFFF
  %is_magic = icmp eq i32 %masked, 541409219  ; 0x20474343
  br i1 %is_magic, label %check_flag, label %cont_after_magic

check_flag:
  %p_plus4 = getelementptr i8, i8* %p, i64 4
  %b = load i8, i8* %p_plus4, align 1
  %b1 = and i8 %b, 1
  %bit_set = icmp ne i8 %b1, 0
  br i1 %bit_set, label %cont_after_magic, label %ret_neg1_from_magic

ret_neg1_from_magic:
  ret i32 -1

cont_after_magic:
  ; if (eax > 0xC0000096U) goto fallback
  %cmp_ugt_0096 = icmp ugt i32 %eax, 3221225622 ; 0xC0000096
  br i1 %cmp_ugt_0096, label %fallback_general, label %range_check1

range_check1:
  ; if (eax <= 0xC000008BU) handle low range, else handle jptable-range
  %cmp_ule_008B = icmp ule i32 %eax, 3221225611 ; 0xC000008B
  br i1 %cmp_ule_008B, label %handle_1E0_block, label %handle_jptable_range

; ---------------- 1E0-range handling ----------------
handle_1E0_block:
  ; if eax == 0xC0000005 -> handle access violation
  %is_av = icmp eq i32 %eax, 3221225477         ; 0xC0000005
  br i1 %is_av, label %case_290, label %gt_av_check

gt_av_check:
  ; if eax > 0xC0000005 -> 0x220 branch
  %gt_av = icmp ugt i32 %eax, 3221225477
  br i1 %gt_av, label %handle_220_branch, label %else_80000002

else_80000002:
  ; if eax == 0x80000002 -> return -1, else fallback
  %is_80000002 = icmp eq i32 %eax, 2147483650   ; 0x80000002
  br i1 %is_80000002, label %ret_neg1, label %fallback_general

ret_neg1:
  ret i32 -1

handle_220_branch:
  ; if eax == 0xC0000008 -> default (-1)
  %is_c0000008 = icmp eq i32 %eax, 3221225480   ; 0xC0000008
  br i1 %is_c0000008, label %ret_neg1, label %check_001D

check_001D:
  ; if eax != 0xC000001D -> fallback, else handle illegal instruction case (ecx=4)
  %is_c000001d = icmp eq i32 %eax, 3221225501   ; 0xC000001D
  br i1 %is_c000001d, label %case_22E, label %fallback_general

; case 0xC000001D handling (label 22E)
case_22E:
  ; r = sub_140002C48(4, 0)
  %r_22e = call i64 @sub_140002C48(i32 4, i32 0)
  %r_22e_eq1 = icmp eq i64 %r_22e, 1
  br i1 %r_22e_eq1, label %case_2E0, label %r_22e_test

r_22e_test:
  %r_22e_iszero = icmp eq i64 %r_22e, 0
  br i1 %r_22e_iszero, label %fallback_general, label %call_r_22e

call_r_22e:
  ; call returned function pointer with ecx=4
  %fp_22e_i8 = inttoptr i64 %r_22e to i8*
  %fp_22e_t = bitcast i8* %fp_22e_i8 to void (i32)*
  call void %fp_22e_t(i32 4)
  br label %ret_neg1

case_2E0:
  ; sub_140002C48(4,1), then default (-1)
  %tmp_2e0 = call i64 @sub_140002C48(i32 4, i32 1)
  br label %ret_neg1

; ---------------- jptable-range handling ----------------
handle_jptable_range:
  ; Values in [0xC000008C..0xC0000096]
  ; Default cases for 0xC0000092 and 0xC0000095
  %is_0092 = icmp eq i32 %eax, 3221225618       ; 0xC0000092
  %is_0095 = icmp eq i32 %eax, 3221225621       ; 0xC0000095
  %is_def = or i1 %is_0092, %is_0095
  br i1 %is_def, label %ret_neg1, label %check_0094

check_0094:
  %is_0094 = icmp eq i32 %eax, 3221225620       ; 0xC0000094
  br i1 %is_0094, label %case_260, label %case_1A0

; case 0xC0000094 (label 260)
case_260:
  ; r = sub_140002C48(8,0)
  %r_260 = call i64 @sub_140002C48(i32 8, i32 0)
  %r_260_eq1 = icmp eq i64 %r_260, 1
  br i1 %r_260_eq1, label %case_270, label %r_260_test

r_260_test:
  %r_260_iszero = icmp eq i64 %r_260, 0
  br i1 %r_260_iszero, label %fallback_general, label %call_r_260

call_r_260:
  ; call returned function pointer with ecx=8
  %fp_260_i8 = inttoptr i64 %r_260 to i8*
  %fp_260_t = bitcast i8* %fp_260_i8 to void (i32)*
  call void %fp_260_t(i32 8)
  br label %ret_neg1

case_270:
  ; sub_140002C48(8,1), then default (-1)
  %tmp_270 = call i64 @sub_140002C48(i32 8, i32 1)
  br label %ret_neg1

; group cases (label 1A0): 0xC000008D..0xC0000091, 0xC0000093, and 0xC0000096
case_1A0:
  ; r = sub_140002C48(8,0)
  %r_1a0 = call i64 @sub_140002C48(i32 8, i32 0)
  %r_1a0_eq1 = icmp eq i64 %r_1a0, 1
  br i1 %r_1a0_eq1, label %case_2F4, label %r_1a0_test

r_1a0_test:
  %r_1a0_iszero = icmp eq i64 %r_1a0, 0
  br i1 %r_1a0_iszero, label %fallback_general, label %call_r_1a0

call_r_1a0:
  ; call returned function pointer with ecx=8
  %fp_1a0_i8 = inttoptr i64 %r_1a0 to i8*
  %fp_1a0_t = bitcast i8* %fp_1a0_i8 to void (i32)*
  call void %fp_1a0_t(i32 8)
  br label %ret_neg1

case_2F4:
  ; sub_140002C48(8,1); call sub_1400025C0(); default (-1)
  %tmp_2f4 = call i64 @sub_140002C48(i32 8, i32 1)
  call void @sub_1400025C0()
  br label %ret_neg1

; ---------------- 0xC0000005 handling (label 290) ----------------
case_290:
  ; r = sub_140002C48(11,0)
  %r_290 = call i64 @sub_140002C48(i32 11, i32 0)
  %r_290_eq1 = icmp eq i64 %r_290, 1
  br i1 %r_290_eq1, label %case_2CC, label %r_290_test

r_290_test:
  %r_290_iszero = icmp eq i64 %r_290, 0
  br i1 %r_290_iszero, label %fallback_general, label %call_r_290

call_r_290:
  ; call returned function pointer with ecx=11
  %fp_290_i8 = inttoptr i64 %r_290 to i8*
  %fp_290_t = bitcast i8* %fp_290_i8 to void (i32)*
  call void %fp_290_t(i32 11)
  br label %ret_neg1

case_2CC:
  ; sub_140002C48(11,1), then default (-1)
  %tmp_2cc = call i64 @sub_140002C48(i32 11, i32 1)
  br label %ret_neg1

; ---------------- fallback general (label 1BF) ----------------
fallback_general:
  %fp_global = load i8*, i8** @qword_1400070D0, align 8
  %fp_isnull = icmp eq i8* %fp_global, null
  br i1 %fp_isnull, label %ret_zero, label %call_fp_global

call_fp_global:
  %fp_cast = bitcast i8* %fp_global to i32 (i8*)*
  %ret_from_fp = call i32 %fp_cast(i8* %rcx_param)
  ret i32 %ret_from_fp

ret_zero:
  ret i32 0
}
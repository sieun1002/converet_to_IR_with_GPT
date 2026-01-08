; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i64, align 8

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) local_unnamed_addr {
entry:
  %rdxptr = load i8*, i8** %rcx, align 8
  %codeptr = bitcast i8* %rdxptr to i32*
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 545259519
  %sigcmp = icmp eq i32 %masked, 541939779
  br i1 %sigcmp, label %sigcheck, label %range_check

sigcheck:                                             ; corresponds to loc_140001D60 path
  %flagptr = getelementptr inbounds i8, i8* %rdxptr, i64 4
  %flagsb = load i8, i8* %flagptr, align 1
  %flag1 = and i8 %flagsb, 1
  %isSet = icmp ne i8 %flag1, 0
  br i1 %isSet, label %range_check, label %handler

range_check:                                          ; corresponds to loc_140001CD1 and following decisions
  %cmp_high = icmp ugt i32 %code, 3221225622          ; 0xC0000096
  br i1 %cmp_high, label %handler, label %range_low

range_low:
  %cmp_low = icmp ule i32 %code, 3221225611           ; 0xC000008B
  br i1 %cmp_low, label %D40, label %switch_entry

switch_entry:
  %idx = add i32 %code, 1073741683                    ; +0x3FFFFF73
  switch i32 %idx, label %handler [
    i32 0, label %D00
    i32 1, label %D00
    i32 2, label %D00
    i32 3, label %D00
    i32 4, label %D00
    i32 6, label %D00
    i32 7, label %DC0
    i32 9, label %D8E
  ]

D40:                                                  ; corresponds to loc_140001D40
  %eq_5 = icmp eq i32 %code, 3221225477               ; 0xC0000005
  br i1 %eq_5, label %DF0, label %D40_after_eq

D40_after_eq:
  %ugt_5 = icmp ugt i32 %code, 3221225477             ; 0xC0000005
  br i1 %ugt_5, label %D80, label %D40_below

D40_below:
  %eq_80000002 = icmp eq i32 %code, 2147483650        ; 0x80000002
  br i1 %eq_80000002, label %ret_minus1, label %handler

; D00: xor edx,edx; ecx=8; call sub_1400027A8
D00:                                                  ; cases -1073741683..-1073741679 and -1073741677
  %call_D00 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_D00 = icmp eq i64 %call_D00, 1
  br i1 %is_one_D00, label %E54, label %D00_not_one

D00_not_one:
  %is_zero_D00 = icmp eq i64 %call_D00, 0
  br i1 %is_zero_D00, label %handler, label %E20

; DC0: xor edx,edx; ecx=8; call sub_1400027A8; if rax==1 -> E40; else if rax==0 -> handler; else call
DC0:                                                  ; case -1073741676
  %call_DC0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %is_one_DC0 = icmp eq i64 %call_DC0, 1
  br i1 %is_one_DC0, label %E40, label %DC0_not_one

DC0_not_one:
  %is_zero_DC0 = icmp eq i64 %call_DC0, 0
  br i1 %is_zero_DC0, label %handler, label %E20_DC0

; D8E: xor edx,edx; ecx=4; call sub_1400027A8
D8E:                                                  ; case -1073741674 and also eax==0xC000001D path
  %call_D8E = call i64 @sub_1400027A8(i32 4, i32 0)
  %is_one_D8E = icmp eq i64 %call_D8E, 1
  br i1 %is_one_D8E, label %E40, label %D8E_not_one

D8E_not_one:
  %is_zero_D8E = icmp eq i64 %call_D8E, 0
  br i1 %is_zero_D8E, label %handler, label %call_fp_4

; DF0: xor edx,edx; ecx=0xB; call sub_1400027A8
DF0:                                                  ; eax == 0xC0000005
  %call_DF0 = call i64 @sub_1400027A8(i32 11, i32 0)
  %is_one_DF0 = icmp eq i64 %call_DF0, 1
  br i1 %is_one_DF0, label %E2C, label %DF0_not_one

DF0_not_one:
  %is_zero_DF0 = icmp eq i64 %call_DF0, 0
  br i1 %is_zero_DF0, label %handler, label %call_fp_11

; D80: cmp eax, 0xC0000008; jz handler; cmp eax, 0xC000001D; jnz handler; else -> D8E
D80:
  %eq_8 = icmp eq i32 %code, 3221225480               ; 0xC0000008
  br i1 %eq_8, label %handler, label %D80_after_8

D80_after_8:
  %eq_1D = icmp eq i32 %code, 322122549D              ; 0xC000001D
  br i1 %eq_1D, label %D8E, label %handler

; E54: edx=1; ecx=8; call sub_1400027A8; call sub_140002120; then handler
E54:
  %call_E54 = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %handler

; E40: edx=1; ecx=4; call sub_1400027A8; then handler
E40:
  %call_E40 = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %handler

; E2C: edx=1; ecx=0xB; call sub_1400027A8; then handler
E2C:
  %call_E2C = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %handler

; E20: call rax(ecx=8); then handler
E20:
  %fp8 = inttoptr i64 %call_D00 to void (i32)*
  call void %fp8(i32 8)
  br label %handler

; E20 path for DC0 when rax!=0 && rax!=1
E20_DC0:
  %fp8_dc0 = inttoptr i64 %call_DC0 to void (i32)*
  call void %fp8_dc0(i32 8)
  br label %handler

; call rax(ecx=4); then handler
call_fp_4:
  %fp4 = inttoptr i64 %call_D8E to void (i32)*
  call void %fp4(i32 4)
  br label %handler

; call rax(ecx=0xB); then handler
call_fp_11:
  %fp11 = inttoptr i64 %call_DF0 to void (i32)*
  call void %fp11(i32 11)
  br label %handler

ret_minus1:
  ret i32 -1

handler:                                              ; corresponds to loc_140001D1F fallback
  %hptr = load i64, i64* @qword_1400070D0, align 8
  %has_handler = icmp ne i64 %hptr, 0
  br i1 %has_handler, label %tailcall, label %ret0

ret0:
  ret i32 0

tailcall:
  %handler_fp = inttoptr i64 %hptr to i32 (i8*)*
  %rcx_as_i8 = bitcast i8** %rcx to i8*
  %res = tail call i32 %handler_fp(i8* %rcx_as_i8)
  ret i32 %res
}
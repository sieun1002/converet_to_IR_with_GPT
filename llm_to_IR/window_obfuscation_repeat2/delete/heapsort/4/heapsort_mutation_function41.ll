; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %p0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %p) {
entry:
  ; rdx = [rcx]
  %erptrptr = bitcast i8* %p to i8**
  %erptr = load i8*, i8** %erptrptr, align 8
  ; eax = [rdx] (ExceptionCode)
  %codeptr = bitcast i8* %erptr to i32*
  %code = load i32, i32* %codeptr, align 4
  ; mask and compare with 0x20474343
  %masked = and i32 %code, 0x20FFFFFF
  %is_cgc = icmp eq i32 %masked, 0x20474343
  br i1 %is_cgc, label %cgc_check, label %range_entry

cgc_check:
  ; test byte ptr [rdx+4], 1
  %flags_ptr_i8 = getelementptr i8, i8* %erptr, i64 4
  %flags = load i8, i8* %flags_ptr_i8, align 1
  %flag_and = and i8 %flags, 1
  %flag_nz = icmp ne i8 %flag_and, 0
  br i1 %flag_nz, label %range_entry, label %ret_m1

range_entry:
  ; if (code > 0xC0000096) goto fallback
  %ugt_96 = icmp ugt i32 %code, 0xC0000096
  br i1 %ugt_96, label %fallback, label %le_96

le_96:
  ; if (code <= 0xC000008B) goto loc_2110 else handle 0xC000008D..0xC0000096 switch subset
  %ule_8B = icmp ule i32 %code, 0xC000008B
  br i1 %ule_8B, label %loc_2110, label %mid_switch

mid_switch:
  ; Handle codes 0xC000008D..0xC0000096 (10 cases)
  ; Cases:
  ;  - 0xC000008D,8E,8F,90,91,93 -> loc_0D0 (signal 8)
  ;  - 0xC0000094 -> loc_0190 (signal 8 special)
  ;  - 0xC0000096 -> loc_015E (signal 4)
  ;  - 0xC0000092,0xC0000095 -> default -> ret -1
  %is_8d = icmp eq i32 %code, 0xC000008D
  %is_8e = icmp eq i32 %code, 0xC000008E
  %is_8f = icmp eq i32 %code, 0xC000008F
  %is_90 = icmp eq i32 %code, 0xC0000090
  %is_91 = icmp eq i32 %code, 0xC0000091
  %is_93 = icmp eq i32 %code, 0xC0000093
  %grp_d0_a = or i1 %is_8d, %is_8e
  %grp_d0_b = or i1 %is_8f, %is_90
  %grp_d0_c = or i1 %is_91, %is_93
  %grp_d0_ab = or i1 %grp_d0_a, %grp_d0_b
  %grp_d0 = or i1 %grp_d0_ab, %grp_d0_c
  br i1 %grp_d0, label %loc_0D0, label %mid_switch_cont

mid_switch_cont:
  %is_94 = icmp eq i32 %code, 0xC0000094
  br i1 %is_94, label %loc_0190, label %mid_switch_cont2

mid_switch_cont2:
  %is_96 = icmp eq i32 %code, 0xC0000096
  br i1 %is_96, label %loc_015E, label %ret_m1

loc_2110:
  ; cmp code, 0xC0000005
  %eq_05 = icmp eq i32 %code, 0xC0000005
  br i1 %eq_05, label %loc_01C0, label %after_eq05

after_eq05:
  ; ja 0x150 if code > 0xC0000005
  %ugt_05 = icmp ugt i32 %code, 0xC0000005
  br i1 %ugt_05, label %loc_0150, label %le_05

le_05:
  ; cmp code, 0x80000002; if equal -> ret -1 else fallback
  %eq_80000002 = icmp eq i32 %code, 0x80000002
  br i1 %eq_80000002, label %ret_m1, label %fallback

loc_0150:
  ; cmp code, 0xC0000008 -> ret -1
  %eq_08 = icmp eq i32 %code, 0xC0000008
  br i1 %eq_08, label %ret_m1, label %cont_0150

cont_0150:
  ; cmp code, 0xC000001D -> loc_015E else fallback
  %eq_1D = icmp eq i32 %code, 0xC000001D
  br i1 %eq_1D, label %loc_015E, label %fallback

; loc_0D0: signal(8, 0), then check return
loc_0D0:
  %sig_null = inttoptr i64 0 to void (i32)*
  %h0 = call void (i32)* @signal(i32 8, void (i32)* %sig_null)
  %h0_int = ptrtoint void (i32)* %h0 to i64
  %h0_is1 = icmp eq i64 %h0_int, 1
  br i1 %h0_is1, label %loc_0224, label %loc_0D0_after

loc_0D0_after:
  %h0_isnull = icmp eq void (i32)* %h0, null
  br i1 %h0_isnull, label %fallback, label %loc_01F0_h0

loc_01F0_h0:
  call void %h0(i32 8)
  br label %ret_m1

; loc_0190: signal(8, 0); if return == 1 -> signal(8,1) and ret -1
; else if return != 0 -> call handler(8) and ret -1
; else fallback
loc_0190:
  %h1 = call void (i32)* @signal(i32 8, void (i32)* %sig_null)
  %h1_int = ptrtoint void (i32)* %h1 to i64
  %h1_is1 = icmp eq i64 %h1_int, 1
  br i1 %h1_is1, label %loc_0210, label %loc_0190_after

loc_0190_after:
  %h1_isnull = icmp eq void (i32)* %h1, null
  br i1 %h1_isnull, label %fallback, label %loc_01F0_h1

loc_01F0_h1:
  call void %h1(i32 8)
  br label %ret_m1

; loc_015E: signal(4, 0); if return == 1 -> signal(4,1) and ret -1
; else if return == 0 -> fallback
; else call handler(4) and ret -1
loc_015E:
  %h2 = call void (i32)* @signal(i32 4, void (i32)* %sig_null)
  %h2_int = ptrtoint void (i32)* %h2 to i64
  %h2_is1 = icmp eq i64 %h2_int, 1
  br i1 %h2_is1, label %loc_0210_4, label %loc_015E_after

loc_015E_after:
  %h2_isnull = icmp eq void (i32)* %h2, null
  br i1 %h2_isnull, label %fallback, label %loc_015E_call

loc_015E_call:
  call void %h2(i32 4)
  br label %ret_m1

; loc_01C0: signal(11, 0); if return == 1 -> signal(11,1) and ret -1
; else if return == 0 -> fallback
; else call handler(11) and ret -1
loc_01C0:
  %h3 = call void (i32)* @signal(i32 11, void (i32)* %sig_null)
  %h3_int = ptrtoint void (i32)* %h3 to i64
  %h3_is1 = icmp eq i64 %h3_int, 1
  br i1 %h3_is1, label %loc_01FC, label %loc_01C0_after

loc_01C0_after:
  %h3_isnull = icmp eq void (i32)* %h3, null
  br i1 %h3_isnull, label %fallback, label %loc_01C0_call

loc_01C0_call:
  call void %h3(i32 11)
  br label %ret_m1

; loc_0224: signal(8, 1); call sub_1400024E0; ret -1
loc_0224:
  %sig_ign = inttoptr i64 1 to void (i32)*
  %h_set_8 = call void (i32)* @signal(i32 8, void (i32)* %sig_ign)
  call void @sub_1400024E0()
  br label %ret_m1

; loc_0210: signal(8, 1); ret -1
loc_0210:
  %h_set_8_2 = call void (i32)* @signal(i32 8, void (i32)* %sig_ign)
  br label %ret_m1

; loc_0210_4: signal(4, 1); ret -1
loc_0210_4:
  %h_set_4 = call void (i32)* @signal(i32 4, void (i32)* %sig_ign)
  br label %ret_m1

; loc_01FC: signal(11, 1); ret -1
loc_01FC:
  %h_set_11 = call void (i32)* @signal(i32 11, void (i32)* %sig_ign)
  br label %ret_m1

fallback:
  ; rax = qword_1400070D0; if null -> return 0; else tailcall and return result
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %fp_isnull = icmp eq i32 (i8*)* %fp, null
  br i1 %fp_isnull, label %ret_0, label %tailcall_fp

tailcall_fp:
  %res = tail call i32 %fp(i8* %p)
  ret i32 %res

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}
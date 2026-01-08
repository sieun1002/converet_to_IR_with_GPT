; ModuleID = 'sub_140001CB0.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*

declare i8* @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define dso_local i32 @sub_140001CB0(i8** %rcx) local_unnamed_addr {
entry:
  %rbx.save = bitcast i8** %rcx to i8**                        ; save original RCX
  %rdx.ptr = load i8*, i8** %rcx, align 8
  %rdx.i32ptr = bitcast i8* %rdx.ptr to i32*
  %eax.val = load i32, i32* %rdx.i32ptr, align 4
  %masked = and i32 %eax.val, 553648127                         ; 0x20FFFFFF
  %magic.cmp = icmp eq i32 %masked, 541803843                   ; 0x20474343
  br i1 %magic.cmp, label %check_flag, label %cmp_chain

check_flag:                                           ; loc_140001D60
  %byteptr = getelementptr i8, i8* %rdx.ptr, i64 4
  %flagbyte = load i8, i8* %byteptr, align 1
  %flagbit = and i8 %flagbyte, 1
  %flag.nz = icmp ne i8 %flagbit, 0
  br i1 %flag.nz, label %cmp_chain, label %ret_m1

cmp_chain:                                            ; loc_140001CD1
  %cmp_hi = icmp ugt i32 %eax.val, 3221225622                 ; 0xC0000096
  br i1 %cmp_hi, label %fallback, label %range_lo

range_lo:                                             ; part of 1CD1 path
  %cmp_le_8B = icmp ule i32 %eax.val, 3221225611             ; 0xC000008B
  br i1 %cmp_le_8B, label %block_1D40, label %jt_range

jt_range:
  %idx.add = add i32 %eax.val, 1073741683                    ; +0x3FFFFF73
  %in.range = icmp ule i32 %idx.add, 9
  br i1 %in.range, label %switch, label %ret_m1

switch:
  switch i32 %idx.add, label %ret_m1 [
    i32 0, label %case_1D00      ; 0xC000008D
    i32 1, label %case_1D00      ; 0xC000008E
    i32 2, label %case_1D00      ; 0xC000008F
    i32 3, label %case_1D00      ; 0xC0000090
    i32 4, label %case_1D00      ; 0xC0000091
    i32 5, label %ret_m1         ; 0xC0000092 (default)
    i32 6, label %case_1D00      ; 0xC0000093
    i32 7, label %case_1DC0      ; 0xC0000094
    i32 8, label %ret_m1         ; 0xC0000095 (default)
    i32 9, label %case_1D8E      ; 0xC0000096
  ]

block_1D40:                                          ; loc_140001D40
  %is_av = icmp eq i32 %eax.val, 3221225477                  ; 0xC0000005
  br i1 %is_av, label %case_1DF0, label %cmp_after_0005

cmp_after_0005:
  %gt_0005 = icmp ugt i32 %eax.val, 3221225477               ; > 0xC0000005
  br i1 %gt_0005, label %block_1D80, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %eax.val, 2147483650            ; 0x80000002
  br i1 %is_80000002, label %ret_m1, label %fallback

block_1D80:                                          ; loc_140001D80
  %is_0008 = icmp eq i32 %eax.val, 3221225496                ; 0xC0000008
  br i1 %is_0008, label %ret_m1, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %eax.val, 3221225501                ; 0xC000001D
  br i1 %is_001D, label %case_1D8E, label %fallback

case_1D00:                                           ; loc_140001D00
  %h_1D00 = call i8* @sub_1400027A8(i32 8, i32 0)
  %h_is_one_1D00 = icmp eq i8* %h_1D00, inttoptr (i64 1 to i8*)
  br i1 %h_is_one_1D00, label %case_1E54, label %test_h_1D00

test_h_1D00:                                         ; loc_140001D16 pathway
  %h_nz_1D00 = icmp ne i8* %h_1D00, null
  br i1 %h_nz_1D00, label %case_1E20, label %fallback

case_1DC0:                                           ; loc_140001DC0 (index 7)
  %h_1DC0 = call i8* @sub_1400027A8(i32 8, i32 0)
  %h_is_one_1DC0 = icmp eq i8* %h_1DC0, inttoptr (i64 1 to i8*)
  br i1 %h_is_one_1DC0, label %case_1DE0, label %test_h_1DC0

test_h_1DC0:                                         ; falls into 1D16 logic
  %h_nz_1DC0 = icmp ne i8* %h_1DC0, null
  br i1 %h_nz_1DC0, label %case_1E20, label %fallback

case_1DF0:                                           ; loc_140001DF0 (access violation)
  %h_1DF0 = call i8* @sub_1400027A8(i32 11, i32 0)
  %h_is_one_1DF0 = icmp eq i8* %h_1DF0, inttoptr (i64 1 to i8*)
  br i1 %h_is_one_1DF0, label %case_1E2C, label %test_h_1DF0

test_h_1DF0:
  %h_nz_1DF0 = icmp ne i8* %h_1DF0, null
  br i1 %h_nz_1DF0, label %call_h_0xB, label %fallback

call_h_0xB:
  %fn_0xB = bitcast i8* %h_1DF0 to void (i32)*
  call void %fn_0xB(i32 11)
  br label %ret_m1

case_1D8E:                                           ; loc_140001D8E
  %h_1D8E = call i8* @sub_1400027A8(i32 4, i32 0)
  %h_is_one_1D8E = icmp eq i8* %h_1D8E, inttoptr (i64 1 to i8*)
  br i1 %h_is_one_1D8E, label %case_1E40, label %test_h_1D8E

test_h_1D8E:
  %h_nz_1D8E = icmp ne i8* %h_1D8E, null
  br i1 %h_nz_1D8E, label %call_h_4, label %fallback

call_h_4:
  %fn_4 = bitcast i8* %h_1D8E to void (i32)*
  call void %fn_4(i32 4)
  br label %ret_m1

case_1E20:                                           ; loc_140001E20
  %h_phi = phi i8* [ %h_1D00, %test_h_1D00 ], [ %h_1DC0, %test_h_1DC0 ]
  %fn_8 = bitcast i8* %h_phi to void (i32)*
  call void %fn_8(i32 8)
  br label %ret_m1

case_1E54:                                           ; loc_140001E54
  %call1_1E54 = call i8* @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

case_1DE0:                                           ; continuation of 1DC0 when rax==1
  %call1_1DE0 = call i8* @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

case_1E2C:                                           ; loc_140001E2C
  %call1_1E2C = call i8* @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

case_1E40:                                           ; loc_140001E40
  %call1_1E40 = call i8* @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

ret_m1:                                              ; default case returns -1
  ret i32 -1

fallback:                                            ; loc_140001D1F
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %fp.null = icmp eq i32 (i8**)* %fp, null
  br i1 %fp.null, label %ret_0, label %tailcall

ret_0:                                               ; loc_140001D70
  ret i32 0

tailcall:                                            ; tail jump to function pointer
  %ret = call i32 %fp(i8** %rbx.save)
  ret i32 %ret
}
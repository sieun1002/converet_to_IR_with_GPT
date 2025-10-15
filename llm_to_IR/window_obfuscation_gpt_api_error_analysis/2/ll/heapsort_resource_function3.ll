; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define dso_local void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %excp32.ptr = bitcast i8* %rdx to i32*
  %eax.val = load i32, i32* %excp32.ptr, align 4
  %masked = and i32 %eax.val, 553648127
  %cmp.magic = icmp eq i32 %masked, 541541187
  br i1 %cmp.magic, label %magic_check, label %after_magic

magic_check:                                      ; corresponds to 0x140002130
  %flag.ptr = getelementptr inbounds i8, i8* %rdx, i64 4
  %flag.byte = load i8, i8* %flag.ptr, align 1
  %flag.lsb = and i8 %flag.byte, 1
  %flag.nz = icmp ne i8 %flag.lsb, 0
  br i1 %flag.nz, label %after_magic, label %default_return

after_magic:                                      ; corresponds to 0x1400020A1 onward
  %cmp_0096 = icmp ugt i32 %eax.val, 3221225622
  br i1 %cmp_0096, label %fallback_call, label %cmp_008B_block

cmp_008B_block:
  %cmp_008B = icmp ule i32 %eax.val, 3221225611
  br i1 %cmp_008B, label %block_110, label %switch_region

block_110:                                        ; corresponds to 0x140002110
  %is_0005 = icmp eq i32 %eax.val, 3221225477
  br i1 %is_0005, label %access_violation, label %block_150_prep

block_150_prep:
  %gt_0005 = icmp ugt i32 %eax.val, 3221225477
  br i1 %gt_0005, label %block_150, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %eax.val, 2147483650
  br i1 %is_80000002, label %ret_minus_one, label %fallback_call

block_150:                                        ; corresponds to 0x140002150
  %is_0008 = icmp eq i32 %eax.val, 3221225480
  br i1 %is_0008, label %default_return, label %chk_001D

chk_001D:
  %is_001D = icmp eq i32 %eax.val, 3221225501
  br i1 %is_001D, label %illegal_instruction, label %fallback_call

switch_region:                                    ; simplified decoding of jump-table cases
  %in_8D = icmp uge i32 %eax.val, 3221225613
  %le_91 = icmp ule i32 %eax.val, 3221225617
  %range_8D_91 = and i1 %in_8D, %le_91
  %is_93 = icmp eq i32 %eax.val, 3221225619
  %use_fpe_group = or i1 %range_8D_91, %is_93
  br i1 %use_fpe_group, label %fpe_group, label %switch_else1

switch_else1:
  %is_94 = icmp eq i32 %eax.val, 3221225620
  br i1 %is_94, label %fpe_div_zero, label %switch_else2

switch_else2:
  %is_96 = icmp eq i32 %eax.val, 3221225622
  br i1 %is_96, label %illegal_instruction, label %default_return

fpe_group:                                        ; corresponds to 0x1400020D0
  %prev_fpe = call i8* @signal(i32 8, i8* null)
  %sig_ign_ptr = inttoptr i64 1 to i8*
  %is_ign = icmp eq i8* %prev_fpe, %sig_ign_ptr
  br i1 %is_ign, label %fpe_set_ign_and_extra, label %fpe_group_cont

fpe_group_cont:
  %is_null_prev = icmp eq i8* %prev_fpe, null
  br i1 %is_null_prev, label %fallback_call, label %call_prev_fpe

call_prev_fpe:                                    ; corresponds to 0x1400021F0
  %prev_fpe_fn = bitcast i8* %prev_fpe to void (i32)*
  call void %prev_fpe_fn(i32 8)
  br label %default_return

fpe_set_ign_and_extra:                            ; corresponds to 0x140002224
  %_tmp1 = call i8* @signal(i32 8, i8* %sig_ign_ptr)
  call void @sub_1400024E0()
  br label %default_return

fpe_div_zero:                                     ; corresponds to 0x140002190
  %prev_fpe_dz = call i8* @signal(i32 8, i8* null)
  %is_ign_dz = icmp eq i8* %prev_fpe_dz, %sig_ign_ptr
  br i1 %is_ign_dz, label %fpe_dz_set_ign, label %fpe_dz_cont

fpe_dz_set_ign:                                   ; corresponds to path where cmp == 1
  %_tmp2 = call i8* @signal(i32 8, i8* %sig_ign_ptr)
  br label %default_return

fpe_dz_cont:                                      ; corresponds to 0x1400020E6
  %is_null_prev_dz = icmp eq i8* %prev_fpe_dz, null
  br i1 %is_null_prev_dz, label %fallback_call, label %call_prev_fpe_dz

call_prev_fpe_dz:                                 ; corresponds to 0x1400021F0
  %prev_fpe_dz_fn = bitcast i8* %prev_fpe_dz to void (i32)*
  call void %prev_fpe_dz_fn(i32 8)
  br label %default_return

illegal_instruction:                              ; corresponds to 0x14000215E (SIGILL)
  %prev_ill = call i8* @signal(i32 4, i8* null)
  %is_ign_ill = icmp eq i8* %prev_ill, %sig_ign_ptr
  br i1 %is_ign_ill, label %ill_set_ign, label %ill_cont

ill_cont:
  %is_null_prev_ill = icmp eq i8* %prev_ill, null
  br i1 %is_null_prev_ill, label %fallback_call, label %call_prev_ill

ill_set_ign:                                      ; corresponds to 0x140002210
  %_tmp3 = call i8* @signal(i32 4, i8* %sig_ign_ptr)
  br label %default_return

call_prev_ill:
  %prev_ill_fn = bitcast i8* %prev_ill to void (i32)*
  call void %prev_ill_fn(i32 4)
  br label %default_return

access_violation:                                 ; corresponds to 0x1400021C0 (SIGSEGV)
  %prev_segv = call i8* @signal(i32 11, i8* null)
  %is_ign_segv = icmp eq i8* %prev_segv, %sig_ign_ptr
  br i1 %is_ign_segv, label %segv_set_ign, label %segv_cont

segv_cont:
  %is_null_prev_segv = icmp eq i8* %prev_segv, null
  br i1 %is_null_prev_segv, label %fallback_call, label %call_prev_segv

segv_set_ign:                                     ; corresponds to 0x1400021FC
  %_tmp4 = call i8* @signal(i32 11, i8* %sig_ign_ptr)
  br label %default_return

call_prev_segv:
  %prev_segv_fn = bitcast i8* %prev_segv to void (i32)*
  call void %prev_segv_fn(i32 11)
  br label %default_return

fallback_call:                                     ; corresponds to 0x1400020EF
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %fp_null = icmp eq i32 (i8**)* %fp, null
  br i1 %fp_null, label %ret_zero, label %do_tail

do_tail:
  %ret.tail = tail call i32 %fp(i8** %rcx)
  ret i32 %ret.tail

ret_zero:                                          ; corresponds to 0x140002140
  ret i32 0

default_return:                                     ; unified default/return -1
  ret i32 -1

ret_minus_one:
  ret i32 -1
}
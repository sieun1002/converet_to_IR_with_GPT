; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@qword_140008290 = external global void (i8*, i8*, i32, i8*)*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare void @sub_140002520(i64)
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i64*, i32)
declare void @sub_140001700(i8*, ...)

define void @sub_1400018D0() {
entry:
  %init = load i32, i32* @dword_1400070A0, align 4
  %init_is_zero = icmp eq i32 %init, 0
  br i1 %init_is_zero, label %proceed, label %ret

ret:                                              ; preds = %after_loops_A90_end, %path_AFD_ret, %v2_ret, %entry
  ret void

proceed:                                          ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_1400022D0()
  %n64 = sext i32 %n to i64
  %n5 = mul i64 %n64, 5
  %n40 = mul i64 %n5, 8
  %plus15 = add i64 %n40, 15
  %aligned = and i64 %plus15, -16
  call void @sub_140002520(i64 %aligned)
  %buf = alloca i8, i64 %aligned, align 16
  %rdi_ptr = load i8*, i8** @off_1400043D0, align 8
  %rbx_ptr0 = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  %rdi_int = ptrtoint i8* %rdi_ptr to i64
  %rbx_int0 = ptrtoint i8* %rbx_ptr0 to i64
  %diff = sub i64 %rdi_int, %rbx_int0
  %cmp_le_7 = icmp sle i64 %diff, 7
  br i1 %cmp_le_7, label %v2_ret, label %check_B_le_0xB

v2_ret:                                           ; preds = %proceed
  br label %ret

check_B_le_0xB:                                   ; preds = %proceed
  %cmp_gt_0xB = icmp sgt i64 %diff, 11
  br i1 %cmp_gt_0xB, label %path_AE8, label %hdr_check

hdr_check:                                        ; preds = %path_1C17_loop, %check_B_le_0xB
  %rbx_hdr = phi i8* [ %rbx_ptr0, %check_B_le_0xB ], [ %rbx_inc, %path_1C17_loop ]
  %p0 = bitcast i8* %rbx_hdr to i32*
  %edx0 = load i32, i32* %p0, align 4
  %edx0_is_zero = icmp eq i32 %edx0, 0
  br i1 %edx0_is_zero, label %check_hdr_second, label %path_AFD_start

check_hdr_second:                                 ; preds = %hdr_check
  %p4 = getelementptr i8, i8* %rbx_hdr, i64 4
  %p4i32 = bitcast i8* %p4 to i32*
  %eax1 = load i32, i32* %p4i32, align 4
  %eax1_is_zero = icmp eq i32 %eax1, 0
  br i1 %eax1_is_zero, label %check_hdr_third, label %path_AFD_start

check_hdr_third:                                  ; preds = %check_hdr_second
  %p8 = getelementptr i8, i8* %rbx_hdr, i64 8
  %p8i32 = bitcast i8* %p8 to i32*
  %edx2 = load i32, i32* %p8i32, align 4
  %edx2_is_one = icmp eq i32 %edx2, 1
  br i1 %edx2_is_one, label %start_v2_loop_setup, label %unknown_protocol_1C53

start_v2_loop_setup:                              ; preds = %check_hdr_third, %goto_1978
  %rbx_hdr_sel = phi i8* [ %rbx_hdr, %check_hdr_third ], [ %rbx_ptr0, %goto_1978 ]
  %rbx_after_hdr = getelementptr i8, i8* %rbx_hdr_sel, i64 12
  %base = load i8*, i8** @off_1400043C0, align 8
  %var48 = alloca i64, align 8
  br label %v2_loop_check

v2_loop_check:                                    ; preds = %v2_iter_end, %start_v2_loop_setup
  %rbx_curr = phi i8* [ %rbx_after_hdr, %start_v2_loop_setup ], [ %rbx_next, %v2_iter_end ]
  %rbx_curr_int = ptrtoint i8* %rbx_curr to i64
  %cmp_jb = icmp ult i64 %rbx_curr_int, %rdi_int
  br i1 %cmp_jb, label %v2_iter, label %after_loops_A90_from_v2

v2_iter:                                          ; preds = %v2_loop_check
  %off_field_ptr = bitcast i8* %rbx_curr to i32*
  %off_field = load i32, i32* %off_field_ptr, align 4
  %rva2_ptr = getelementptr i8, i8* %rbx_curr, i64 4
  %rva2_i32ptr = bitcast i8* %rva2_ptr to i32*
  %rva2 = load i32, i32* %rva2_i32ptr, align 4
  %type_ptr = getelementptr i8, i8* %rbx_curr, i64 8
  %type_i32ptr = bitcast i8* %type_ptr to i32*
  %type_full = load i32, i32* %type_i32ptr, align 4
  %off_z = zext i32 %off_field to i64
  %targ_addr = getelementptr i8, i8* %base, i64 %off_z
  %r9_val_ptr = bitcast i8* %targ_addr to i64*
  %r9_val = load i64, i64* %r9_val_ptr, align 8
  %rva2_z = zext i32 %rva2 to i64
  %patch_ptr = getelementptr i8, i8* %base, i64 %rva2_z
  %type_byte = trunc i32 %type_full to i8
  %type_u32 = zext i8 %type_byte to i32
  %is_32 = icmp eq i32 %type_u32, 32
  br i1 %is_32, label %case32, label %check_le_32

check_le_32:                                      ; preds = %v2_iter
  %lt_32 = icmp ult i32 %type_u32, 32
  br i1 %lt_32, label %switch_8_16, label %check_is_64

switch_8_16:                                      ; preds = %check_le_32
  %is_8 = icmp eq i32 %type_u32, 8
  br i1 %is_8, label %case8, label %check_is_16

check_is_16:                                      ; preds = %switch_8_16
  %is_16 = icmp eq i32 %type_u32, 16
  br i1 %is_16, label %case16, label %unknown_bitsize_1C2B

check_is_64:                                      ; preds = %check_le_32
  %is_64 = icmp eq i32 %type_u32, 64
  br i1 %is_64, label %case64, label %unknown_bitsize_1C2B

case8:                                            ; preds = %switch_8_16
  %p8val = load i8, i8* %patch_ptr, align 1
  %val8_sext = sext i8 %p8val to i64
  %tmp8_sub = ptrtoint i8* %targ_addr to i64
  %tmpcalc8 = sub i64 %val8_sext, %tmp8_sub
  %newval8 = add i64 %tmpcalc8, %r9_val
  %maskC0_8 = and i32 %type_full, 192
  %is_mask_nonzero_8 = icmp ne i32 %maskC0_8, 0
  store i64 %newval8, i64* %var48, align 8
  br i1 %is_mask_nonzero_8, label %do_patch8, label %bounds8

bounds8:                                          ; preds = %case8
  %gt_ff = icmp sgt i64 %newval8, 255
  br i1 %gt_ff, label %errorC3F_from8, label %check_low8

check_low8:                                       ; preds = %bounds8
  %lowbound8 = icmp slt i64 %newval8, -128
  br i1 %lowbound8, label %errorC3F_from8, label %do_patch8

do_patch8:                                        ; preds = %check_low8, %case8
  call void @sub_140001760(i8* %patch_ptr)
  call void @sub_1400027B8(i8* %patch_ptr, i64* %var48, i32 1)
  br label %v2_iter_end

case16:                                           ; preds = %check_is_16
  %p16ptr = bitcast i8* %patch_ptr to i16*
  %val16 = load i16, i16* %p16ptr, align 2
  %val16_sext = sext i16 %val16 to i64
  %tmp16_sub = ptrtoint i8* %targ_addr to i64
  %tmpcalc16 = sub i64 %val16_sext, %tmp16_sub
  %newval16 = add i64 %tmpcalc16, %r9_val
  %maskC0_16 = and i32 %type_full, 192
  %is_mask_nonzero_16 = icmp ne i32 %maskC0_16, 0
  store i64 %newval16, i64* %var48, align 8
  br i1 %is_mask_nonzero_16, label %do_patch16, label %bounds16

bounds16:                                         ; preds = %case16
  %gt_ffff = icmp sgt i64 %newval16, 65535
  br i1 %gt_ffff, label %errorC3F_from16, label %check_low16

check_low16:                                      ; preds = %bounds16
  %lowbound16 = icmp slt i64 %newval16, -32768
  br i1 %lowbound16, label %errorC3F_from16, label %do_patch16

do_patch16:                                       ; preds = %check_low16, %case16
  call void @sub_140001760(i8* %patch_ptr)
  call void @sub_1400027B8(i8* %patch_ptr, i64* %var48, i32 2)
  br label %v2_iter_end

case32:                                           ; preds = %v2_iter
  %p32ptr = bitcast i8* %patch_ptr to i32*
  %val32 = load i32, i32* %p32ptr, align 4
  %val32_sext = sext i32 %val32 to i64
  %tmp32_sub = ptrtoint i8* %targ_addr to i64
  %tmpcalc32 = sub i64 %val32_sext, %tmp32_sub
  %newval32 = add i64 %tmpcalc32, %r9_val
  %maskC0_32 = and i32 %type_full, 192
  %is_mask_nonzero_32 = icmp ne i32 %maskC0_32, 0
  store i64 %newval32, i64* %var48, align 8
  br i1 %is_mask_nonzero_32, label %do_patch32, label %bounds32

bounds32:                                         ; preds = %case32
  %cmp_hi = icmp sgt i64 %newval32, 4294967295
  br i1 %cmp_hi, label %errorC3F_from32, label %check_lo32

check_lo32:                                       ; preds = %bounds32
  %cmp_lo = icmp slt i64 %newval32, -2147483648
  br i1 %cmp_lo, label %errorC3F_from32, label %do_patch32

do_patch32:                                       ; preds = %check_lo32, %case32
  call void @sub_140001760(i8* %patch_ptr)
  call void @sub_1400027B8(i8* %patch_ptr, i64* %var48, i32 4)
  br label %v2_iter_end

case64:                                           ; preds = %check_is_64
  %p64ptr = bitcast i8* %patch_ptr to i64*
  %val64 = load i64, i64* %p64ptr, align 8
  %tmp64_sub = ptrtoint i8* %targ_addr to i64
  %tmpcalc64 = sub i64 %val64, %tmp64_sub
  %newval64 = add i64 %tmpcalc64, %r9_val
  %maskC0_64 = and i32 %type_full, 192
  %is_mask_nonzero_64 = icmp ne i32 %maskC0_64, 0
  store i64 %newval64, i64* %var48, align 8
  br i1 %is_mask_nonzero_64, label %do_patch64, label %bounds64

bounds64:                                         ; preds = %case64
  %is_nonneg = icmp sge i64 %newval64, 0
  br i1 %is_nonneg, label %errorC3F_from64, label %do_patch64

do_patch64:                                       ; preds = %bounds64, %case64
  call void @sub_140001760(i8* %patch_ptr)
  call void @sub_1400027B8(i8* %patch_ptr, i64* %var48, i32 8)
  br label %v2_iter_end

unknown_bitsize_1C2B:                             ; preds = %check_is_16, %check_is_64
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR)
  br label %errorC3F_merge

errorC3F_from8:                                   ; preds = %bounds8
  br label %errorC3F_merge

errorC3F_from16:                                  ; preds = %check_low16, %bounds16
  br label %errorC3F_merge

errorC3F_from32:                                  ; preds = %check_lo32, %bounds32
  br label %errorC3F_merge

errorC3F_from64:                                  ; preds = %bounds64
  br label %errorC3F_merge

errorC3F_merge:                                   ; preds = %errorC3F_from64, %errorC3F_from32, %errorC3F_from16, %errorC3F_from8, %unknown_bitsize_1C2B
  %err_bits = phi i32 [ %type_u32, %errorC3F_from8 ], [ %type_u32, %errorC3F_from16 ], [ %type_u32, %errorC3F_from32 ], [ %type_u32, %errorC3F_from64 ], [ %type_u32, %unknown_bitsize_1C2B ]
  %err_patch = phi i8* [ %patch_ptr, %errorC3F_from8 ], [ %patch_ptr, %errorC3F_from16 ], [ %patch_ptr, %errorC3F_from32 ], [ %patch_ptr, %errorC3F_from64 ], [ %patch_ptr, %unknown_bitsize_1C2B ]
  %err_val_sel0 = phi i64 [ %newval8, %errorC3F_from8 ], [ %newval16, %errorC3F_from16 ], [ %newval32, %errorC3F_from32 ], [ %newval64, %errorC3F_from64 ], [ 0, %unknown_bitsize_1C2B ]
  call void (i8*, ...) @sub_140001700(i8* @aDBitPseudoRelo, i32 %err_bits, i8* %err_patch, i64 %err_val_sel0)
  br label %unknown_protocol_1C53

v2_iter_end:                                      ; preds = %do_patch64, %do_patch32, %do_patch16, %do_patch8
  %rbx_next = getelementptr i8, i8* %rbx_curr, i64 12
  br label %v2_loop_check

unknown_protocol_1C53:                            ; preds = %errorC3F_merge, %check_hdr_third, %goto_1978
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR_0)
  br label %ret

path_AE8:                                         ; preds = %check_B_le_0xB
  %p0b = bitcast i8* %rbx_ptr0 to i32*
  %r9d = load i32, i32* %p0b, align 4
  %r9d_zero = icmp eq i32 %r9d, 0
  br i1 %r9d_zero, label %ae8_check_r8d, label %path_AFD_start_from_ae8

ae8_check_r8d:                                    ; preds = %path_AE8
  %p4b = getelementptr i8, i8* %rbx_ptr0, i64 4
  %p4b_i32 = bitcast i8* %p4b to i32*
  %r8d_val = load i32, i32* %p4b_i32, align 4
  %r8d_zero = icmp eq i32 %r8d_val, 0
  br i1 %r8d_zero, label %path_1C17, label %path_AFD_start_from_ae8

path_AFD_start_from_ae8:                          ; preds = %ae8_check_r8d, %path_AE8
  br label %path_AFD_start

path_1C17:                                        ; preds = %ae8_check_r8d
  %p8b = getelementptr i8, i8* %rbx_ptr0, i64 8
  %p8b_i32 = bitcast i8* %p8b to i32*
  %ecx_val = load i32, i32* %p8b_i32, align 4
  %ecx_zero = icmp eq i32 %ecx_val, 0
  br i1 %ecx_zero, label %path_1C17_loop, label %goto_1978

path_1C17_loop:                                   ; preds = %path_1C17
  %rbx_inc = getelementptr i8, i8* %rbx_ptr0, i64 12
  br label %hdr_check

goto_1978:                                        ; preds = %path_1C17
  %edxX = load i32, i32* %p8b_i32, align 4
  %edxX_is_one = icmp eq i32 %edxX, 1
  br i1 %edxX_is_one, label %start_v2_loop_setup, label %unknown_protocol_1C53

path_AFD_start:                                   ; preds = %check_hdr_second, %hdr_check, %path_AFD_start_from_ae8
  %rbx_sel = phi i8* [ %rbx_ptr0, %path_AFD_start_from_ae8 ], [ %rbx_hdr, %hdr_check ], [ %rbx_hdr, %check_hdr_second ]
  %rbx_sel_int = ptrtoint i8* %rbx_sel to i64
  %rbx_ge_rdi = icmp uge i64 %rbx_sel_int, %rdi_int
  br i1 %rbx_ge_rdi, label %path_AFD_ret, label %setup_V1

path_AFD_ret:                                     ; preds = %path_AFD_start
  br label %ret

setup_V1:                                         ; preds = %path_AFD_start
  %base2 = load i8*, i8** @off_1400043C0, align 8
  %var48_b = alloca i64, align 8
  br label %v1_loop

v1_loop:                                          ; preds = %v1_iter_end, %setup_V1
  %rbx_v1 = phi i8* [ %rbx_sel, %setup_V1 ], [ %rbx_v1_next, %v1_iter_end ]
  %add_off_ptr = bitcast i8* %rbx_v1 to i32*
  %addend = load i32, i32* %add_off_ptr, align 4
  %rva_ptr_v1 = getelementptr i8, i8* %rbx_v1, i64 4
  %rva_v1_i32ptr = bitcast i8* %rva_ptr_v1 to i32*
  %rva_v1 = load i32, i32* %rva_v1_i32ptr, align 4
  %rbx_v1_next = getelementptr i8, i8* %rbx_v1, i64 8
  %rva_z_v1 = zext i32 %rva_v1 to i64
  %patch_ptr_v1 = getelementptr i8, i8* %base2, i64 %rva_z_v1
  %ref32ptr = bitcast i8* %patch_ptr_v1 to i32*
  %ref32 = load i32, i32* %ref32ptr, align 4
  %sum32 = add i32 %addend, %ref32
  %sum64 = sext i32 %sum32 to i64
  store i64 %sum64, i64* %var48_b, align 8
  call void @sub_140001760(i8* %patch_ptr_v1)
  call void @sub_1400027B8(i8* %patch_ptr_v1, i64* %var48_b, i32 4)
  %rbx_v1_next_int = ptrtoint i8* %rbx_v1_next to i64
  %cont_v1 = icmp ult i64 %rbx_v1_next_int, %rdi_int
  br i1 %cont_v1, label %v1_iter_end, label %after_loops_A90_from_v1

v1_iter_end:                                      ; preds = %v1_loop
  br label %v1_loop

after_loops_A90_from_v2:                          ; preds = %v2_loop_check
  br label %after_loops_A90

after_loops_A90_from_v1:                          ; preds = %v1_loop
  br label %after_loops_A90

after_loops_A90:                                  ; preds = %after_loops_A90_from_v1, %after_loops_A90_from_v2
  %cb_arg_ptr = phi i64* [ %var48_b, %after_loops_A90_from_v1 ], [ %var48, %after_loops_A90_from_v2 ]
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_pos = icmp sgt i32 %cnt, 0
  br i1 %cnt_pos, label %cb_loop_init, label %after_loops_A90_end

after_loops_A90_end:                              ; preds = %after_loops_A90
  br label %ret

cb_loop_init:                                     ; preds = %after_loops_A90
  %cbfn = load void (i8*, i8*, i32, i8*)*, void (i8*, i8*, i32, i8*)** @qword_140008290, align 8
  br label %cb_loop

cb_loop:                                          ; preds = %cb_loop_body, %cb_loop_init
  %i = phi i32 [ 0, %cb_loop_init ], [ %i_next, %cb_loop_body ]
  %ofs = phi i64 [ 0, %cb_loop_init ], [ %ofs_next, %cb_loop_body ]
  %base_entries = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr = getelementptr i8, i8* %base_entries, i64 %ofs
  %flag_ptr = bitcast i8* %entry_ptr to i32*
  %flag = load i32, i32* %flag_ptr, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %skip_cb, label %do_cb

do_cb:                                            ; preds = %cb_loop
  %rcx_arg_ptr = getelementptr i8, i8* %entry_ptr, i64 8
  %rcx_arg_i64p = bitcast i8* %rcx_arg_ptr to i8**
  %rcx_arg = load i8*, i8** %rcx_arg_i64p, align 8
  %rdx_arg_ptr = getelementptr i8, i8* %entry_ptr, i64 16
  %rdx_arg_i64p = bitcast i8* %rdx_arg_ptr to i8**
  %rdx_arg = load i8*, i8** %rdx_arg_i64p, align 8
  %cb_arg_i8 = bitcast i64* %cb_arg_ptr to i8*
  call void %cbfn(i8* %rcx_arg, i8* %rdx_arg, i32 %flag, i8* %cb_arg_i8)
  br label %cb_loop_next

skip_cb:                                          ; preds = %cb_loop
  br label %cb_loop_next

cb_loop_next:                                     ; preds = %skip_cb, %do_cb
  %i_next = add i32 %i, 1
  %ofs_next = add i64 %ofs, 40
  %cnt_now = load i32, i32* @dword_1400070A4, align 4
  %cont = icmp slt i32 %i_next, %cnt_now
  br i1 %cont, label %cb_loop_body, label %cb_done

cb_loop_body:                                     ; preds = %cb_loop_next
  br label %cb_loop

cb_done:                                          ; preds = %cb_loop_next
  br label %ret
}
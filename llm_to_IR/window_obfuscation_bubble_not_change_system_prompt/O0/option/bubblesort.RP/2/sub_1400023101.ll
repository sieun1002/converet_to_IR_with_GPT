target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002310(i64 %rcx) {
entry:
  %r8 = load i8*, i8** @off_1400043C0, align 8
  %p0 = bitcast i8* %r8 to i16*
  %val0 = load i16, i16* %p0, align 1
  %cond0 = icmp eq i16 %val0, 23117
  br i1 %cond0, label %L_after_dos, label %ret0

L_after_dos:
  %p_e_lfanew_addr = getelementptr i8, i8* %r8, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew_addr to i32*
  %e_lfanew32 = load i32, i32* %p_e_lfanew, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr i8, i8* %r8, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %cond1 = icmp eq i32 %pe_sig, 17744
  br i1 %cond1, label %L_check_magic, label %ret0

L_check_magic:
  %p_magic = getelementptr i8, i8* %pehdr, i64 24
  %p_magic_w = bitcast i8* %p_magic to i16*
  %magic = load i16, i16* %p_magic_w, align 1
  %cond2 = icmp eq i16 %magic, 523
  br i1 %cond2, label %L_numsections, label %ret0

L_numsections:
  %p_numsec = getelementptr i8, i8* %pehdr, i64 6
  %p_numsec_w = bitcast i8* %p_numsec to i16*
  %numsec16 = load i16, i16* %p_numsec_w, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %ret0, label %L_compute

L_compute:
  %p_optSize = getelementptr i8, i8* %pehdr, i64 20
  %p_optSize_w = bitcast i8* %p_optSize to i16*
  %optSize16 = load i16, i16* %p_optSize_w, align 1
  %optSize64 = zext i16 %optSize16 to i64
  %first_off = add i64 %optSize64, 24
  %first = getelementptr i8, i8* %pehdr, i64 %first_off
  %numsec64 = zext i16 %numsec16 to i64
  %sections_size = mul i64 %numsec64, 40
  %end = getelementptr i8, i8* %first, i64 %sections_size
  br label %L_loop

L_loop:
  %cur = phi i8* [ %first, %L_compute ], [ %cur_next, %L_advance ]
  %rcx_cur = phi i64 [ %rcx, %L_compute ], [ %rcx_next, %L_advance ]
  %baddr = getelementptr i8, i8* %cur, i64 39
  %b = load i8, i8* %baddr, align 1
  %masked = and i8 %b, 32
  %flag_set = icmp ne i8 %masked, 0
  br i1 %flag_set, label %L_check_rcx, label %L_skip_rcx

L_check_rcx:
  %isrcxzero = icmp eq i64 %rcx_cur, 0
  br i1 %isrcxzero, label %ret0, label %L_decrement

L_decrement:
  %rcx_dec = add i64 %rcx_cur, -1
  br label %L_advance

L_skip_rcx:
  br label %L_advance

L_advance:
  %rcx_next = phi i64 [ %rcx_dec, %L_decrement ], [ %rcx_cur, %L_skip_rcx ]
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %end, %cur_next
  br i1 %cont, label %L_loop, label %ret0

ret0:
  ret i32 0
}
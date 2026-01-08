; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043D0 = external dso_local global i8*
@off_1400043E0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@__imp_VirtualProtect = external dso_local global i32 (i8*, i64, i32, i32*)*

@aUnknownPseudoR = external dso_local constant i8
@aDBitPseudoRelo = external dso_local constant i8
@aUnknownPseudoR_0 = external dso_local constant i8

declare dso_local i32 @sub_1400022D0()
declare dso_local i64 @sub_140002520()
declare dso_local void @sub_140001760(i8*)
declare dso_local void @sub_140001700(i8*, ...)
declare dso_local i8* @memcpy(i8*, i8*, i64)

define dso_local void @sub_1400018D0() {
entry:
  %Src = alloca i64, align 8
  %oldProtect = alloca i32, align 4
  %var60 = alloca i64, align 8
  %rbx = alloca i8*, align 8
  %rdi = alloca i8*, align 8
  %r14 = alloca i8*, align 8
  %r15 = alloca i8*, align 8
  %r12 = alloca i8*, align 8
  %r13 = alloca i8*, align 8
  %esi = alloca i32, align 4
  %g0 = load i32, i32* @dword_1400070A0, align 4
  store i32 %g0, i32* %esi, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %L1900, label %ret

ret:                                              ; preds = %VP_AfterCall, %L1C53, %L1984, %Lcmp11, %entry, %L1AFD, %L1A90, %UnknownSize, %RangeError
  ret void

L1900:                                            ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %call1 = call i32 @sub_1400022D0()
  %raxext = sext i32 %call1 to i64
  %mul5 = mul i64 %raxext, 5
  %mul8 = shl i64 %mul5, 3
  %add15 = add i64 %mul8, 15
  %aligned = and i64 %add15, -16
  %szcall = call i64 @sub_140002520()
  %end = load i8*, i8** @off_1400043D0, align 8
  %beg = load i8*, i8** @off_1400043E0, align 8
  store i8* %end, i8** %rdi, align 8
  store i8* %beg, i8** %rbx, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %src_i8 = bitcast i64* %Src to i8*
  store i8* %src_i8, i8** @qword_1400070A8, align 8
  %end1 = load i8*, i8** %rdi, align 8
  %beg1 = load i8*, i8** %rbx, align 8
  %endI = ptrtoint i8* %end1 to i64
  %begI = ptrtoint i8* %beg1 to i64
  %diff = sub i64 %endI, %begI
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %Lcmp11

Lcmp11:                                           ; preds = %L1900
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %L1AE8, label %L1963

L1963:                                            ; preds = %L1C17_zero, %Lcmp11
  %rbx_cur1963 = load i8*, i8** %rbx, align 8
  %p_rbx_i32 = bitcast i8* %rbx_cur1963 to i32*
  %edx0 = load i32, i32* %p_rbx_i32, align 1
  %edx0_iszero = icmp eq i32 %edx0, 0
  br i1 %edx0_iszero, label %L196d, label %L1AFD

L196d:                                            ; preds = %L1963
  %p_rbx4 = getelementptr i8, i8* %rbx_cur1963, i64 4
  %p_rbx4_i32 = bitcast i8* %p_rbx4 to i32*
  %eax0 = load i32, i32* %p_rbx4_i32, align 1
  %eax0_iszero = icmp eq i32 %eax0, 0
  br i1 %eax0_iszero, label %L1978, label %L1AFD

L1978:                                            ; preds = %L196d, %L1C17
  %rbxL1978 = load i8*, i8** %rbx, align 8
  %p_rbx8 = getelementptr i8, i8* %rbxL1978, i64 8
  %p_rbx8_i32 = bitcast i8* %p_rbx8 to i32*
  %edx1 = load i32, i32* %p_rbx8_i32, align 1
  %cmp_edx1 = icmp eq i32 %edx1, 1
  br i1 %cmp_edx1, label %L1984, label %L1C53

L1984:                                            ; preds = %L1978
  %rbx_nowX = load i8*, i8** %rbx, align 8
  %rbx_plusC = getelementptr i8, i8* %rbx_nowX, i64 12
  store i8* %rbx_plusC, i8** %rbx, align 8
  %base = load i8*, i8** @off_1400043C0, align 8
  store i8* %base, i8** %r14, align 8
  store i8* %src_i8, i8** %r12, align 8
  %rbx3 = load i8*, i8** %rbx, align 8
  %rdi3 = load i8*, i8** %rdi, align 8
  %cmp_b_jb = icmp ult i8* %rbx3, %rdi3
  br i1 %cmp_b_jb, label %L1A14, label %ret

L1A14:                                            ; preds = %Case8_Write, %Case32_Write, %Case16_Write, %Case64_Write, %L1984
  %rbx4 = load i8*, i8** %rbx, align 8
  %r8d_ptr = bitcast i8* %rbx4 to i32*
  %r8d_val = load i32, i32* %r8d_ptr, align 1
  %rbx4_p8 = getelementptr i8, i8* %rbx4, i64 8
  %ecx_ptr = bitcast i8* %rbx4_p8 to i32*
  %ecx_val = load i32, i32* %ecx_ptr, align 1
  %rbx4_p4 = getelementptr i8, i8* %rbx4, i64 4
  %r15d_ptr = bitcast i8* %rbx4_p4 to i32*
  %r15d_val = load i32, i32* %r15d_ptr, align 1
  %base2 = load i8*, i8** %r14, align 8
  %r8_off = zext i32 %r8d_val to i64
  %r8_ptr = getelementptr i8, i8* %base2, i64 %r8_off
  %r9_ptr = bitcast i8* %r8_ptr to i64*
  %r9_val = load i64, i64* %r9_ptr, align 1
  %r15_off = zext i32 %r15d_val to i64
  %r15_ptr_val = getelementptr i8, i8* %base2, i64 %r15_off
  store i8* %r15_ptr_val, i8** %r15, align 8
  %cl = trunc i32 %ecx_val to i8
  %edx_zx = zext i8 %cl to i32
  %is32 = icmp eq i32 %edx_zx, 32
  br i1 %is32, label %Case32, label %AfterCheck32

AfterCheck32:                                     ; preds = %L1A14
  %le32 = icmp ule i32 %edx_zx, 32
  br i1 %le32, label %Check8_16, label %Check64

Check8_16:                                        ; preds = %AfterCheck32
  %is8 = icmp eq i32 %edx_zx, 8
  br i1 %is8, label %Case8, label %Check16

Check16:                                          ; preds = %Check8_16
  %is16 = icmp eq i32 %edx_zx, 16
  br i1 %is16, label %Case16, label %UnknownSize

Check64:                                          ; preds = %AfterCheck32
  %is64 = icmp eq i32 %edx_zx, 64
  br i1 %is64, label %Case64, label %UnknownSize

Case16:                                           ; preds = %Check16
  %r15_cur = load i8*, i8** %r15, align 8
  %wptr = bitcast i8* %r15_cur to i16*
  %wval = load i16, i16* %wptr, align 1
  %wext = sext i16 %wval to i64
  %r8_addr = ptrtoint i8* %r8_ptr to i64
  %t_sub = sub i64 %wext, %r8_addr
  %t_add = add i64 %t_sub, %r9_val
  %flags = and i32 %ecx_val, 192
  %flags_zero = icmp eq i32 %flags, 0
  br i1 %flags_zero, label %Case16_RangeCheck, label %Case16_Write

Case16_RangeCheck:                                ; preds = %Case16
  %gtFFFF = icmp sgt i64 %t_add, 65535
  br i1 %gtFFFF, label %RangeError, label %Case16_LowCheck

Case16_LowCheck:                                  ; preds = %Case16_RangeCheck
  %ltNeg = icmp slt i64 %t_add, -32768
  br i1 %ltNeg, label %RangeError, label %Case16_Write

Case16_Write:                                     ; preds = %Case16_LowCheck, %Case16
  store i64 %t_add, i64* %Src, align 8
  %r12v = load i8*, i8** %r12, align 8
  store i8* %r12v, i8** %r13, align 8
  %r15_forcall = load i8*, i8** %r15, align 8
  call void @sub_140001760(i8* %r15_forcall)
  %src8 = load i8*, i8** %r12, align 8
  call i8* @memcpy(i8* %r15_forcall, i8* %src8, i64 2)
  %rbx_now = load i8*, i8** %rbx, align 8
  %rbx_next = getelementptr i8, i8* %rbx_now, i64 12
  store i8* %rbx_next, i8** %rbx, align 8
  %rdi_val = load i8*, i8** %rdi, align 8
  %cont = icmp ult i8* %rbx_next, %rdi_val
  br i1 %cont, label %L1A14, label %L1A90

Case32:                                           ; preds = %L1A14
  %r15_c2 = load i8*, i8** %r15, align 8
  %dptr = bitcast i8* %r15_c2 to i32*
  %dval = load i32, i32* %dptr, align 1
  %dext = sext i32 %dval to i64
  %r8addr2 = ptrtoint i8* %r8_ptr to i64
  %t_sub32 = sub i64 %dext, %r8addr2
  %t_add32 = add i64 %t_sub32, %r9_val
  %flags32 = and i32 %ecx_val, 192
  %flags32_zero = icmp eq i32 %flags32, 0
  br i1 %flags32_zero, label %Case32_RangeCheck, label %Case32_Write

Case32_RangeCheck:                                ; preds = %Case32
  %gtMax32 = icmp sgt i64 %t_add32, 4294967295
  br i1 %gtMax32, label %RangeError, label %Case32_LowCheck

Case32_LowCheck:                                  ; preds = %Case32_RangeCheck
  %ltMin32 = icmp slt i64 %t_add32, -2147483648
  br i1 %ltMin32, label %RangeError, label %Case32_Write

Case32_Write:                                     ; preds = %Case32_LowCheck, %Case32
  store i64 %t_add32, i64* %Src, align 8
  %r12v32 = load i8*, i8** %r12, align 8
  store i8* %r12v32, i8** %r13, align 8
  %r15_forcall32 = load i8*, i8** %r15, align 8
  call void @sub_140001760(i8* %r15_forcall32)
  %src832 = load i8*, i8** %r12, align 8
  call i8* @memcpy(i8* %r15_forcall32, i8* %src832, i64 4)
  %rbx_now32 = load i8*, i8** %rbx, align 8
  %rbx_next32 = getelementptr i8, i8* %rbx_now32, i64 12
  store i8* %rbx_next32, i8** %rbx, align 8
  %rdi_val32 = load i8*, i8** %rdi, align 8
  %cont32 = icmp ult i8* %rbx_next32, %rdi_val32
  br i1 %cont32, label %L1A14, label %L1A90

Case8:                                            ; preds = %Check8_16
  %r15_c8 = load i8*, i8** %r15, align 8
  %bptr = bitcast i8* %r15_c8 to i8*
  %bval = load i8, i8* %bptr, align 1
  %bext = sext i8 %bval to i64
  %r8addr8 = ptrtoint i8* %r8_ptr to i64
  %t_sub8 = sub i64 %bext, %r8addr8
  %t_add8 = add i64 %t_sub8, %r9_val
  %flags8 = and i32 %ecx_val, 192
  %flags8_zero = icmp eq i32 %flags8, 0
  br i1 %flags8_zero, label %Case8_RangeCheck, label %Case8_Write

Case8_RangeCheck:                                 ; preds = %Case8
  %gt255 = icmp sgt i64 %t_add8, 255
  br i1 %gt255, label %RangeError, label %Case8_LowCheck

Case8_LowCheck:                                   ; preds = %Case8_RangeCheck
  %ltNeg128 = icmp slt i64 %t_add8, -128
  br i1 %ltNeg128, label %RangeError, label %Case8_Write

Case8_Write:                                      ; preds = %Case8_LowCheck, %Case8
  store i64 %t_add8, i64* %Src, align 8
  %r12v8 = load i8*, i8** %r12, align 8
  store i8* %r12v8, i8** %r13, align 8
  %r15_forcall8 = load i8*, i8** %r15, align 8
  call void @sub_140001760(i8* %r15_forcall8)
  %src88 = load i8*, i8** %r12, align 8
  call i8* @memcpy(i8* %r15_forcall8, i8* %src88, i64 1)
  %rbx_now8 = load i8*, i8** %rbx, align 8
  %rbx_next8 = getelementptr i8, i8* %rbx_now8, i64 12
  store i8* %rbx_next8, i8** %rbx, align 8
  %rdi_val8 = load i8*, i8** %rdi, align 8
  %cont8 = icmp ult i8* %rbx_next8, %rdi_val8
  br i1 %cont8, label %L1A14, label %L1A90

Case64:                                           ; preds = %Check64
  %r15_c64 = load i8*, i8** %r15, align 8
  %qptr = bitcast i8* %r15_c64 to i64*
  %qval = load i64, i64* %qptr, align 1
  %r8addr64 = ptrtoint i8* %r8_ptr to i64
  %t_sub64 = sub i64 %qval, %r8addr64
  %t_add64 = add i64 %t_sub64, %r9_val
  %flags64 = and i32 %ecx_val, 192
  %flags64_zero = icmp eq i32 %flags64, 0
  br i1 %flags64_zero, label %Case64_CheckSign, label %Case64_Write

Case64_CheckSign:                                 ; preds = %Case64
  %nonneg = icmp sge i64 %t_add64, 0
  br i1 %nonneg, label %RangeError, label %Case64_Write

Case64_Write:                                     ; preds = %Case64_CheckSign, %Case64
  store i64 %t_add64, i64* %Src, align 8
  %r12v64 = load i8*, i8** %r12, align 8
  store i8* %r12v64, i8** %r13, align 8
  %r15_forcall64 = load i8*, i8** %r15, align 8
  call void @sub_140001760(i8* %r15_forcall64)
  %src864 = load i8*, i8** %r12, align 8
  call i8* @memcpy(i8* %r15_forcall64, i8* %src864, i64 8)
  %rbx_now64 = load i8*, i8** %rbx, align 8
  %rbx_next64 = getelementptr i8, i8* %rbx_now64, i64 12
  store i8* %rbx_next64, i8** %rbx, align 8
  %rdi_val64 = load i8*, i8** %rdi, align 8
  %cont64 = icmp ult i8* %rbx_next64, %rdi_val64
  br i1 %cont64, label %L1A14, label %L1A90

UnknownSize:                                      ; preds = %Check16, %Check64
  store i64 0, i64* %Src, align 8
  %pU = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  call void (i8*, ...) @sub_140001700(i8* %pU)
  br label %RangeError

RangeError:                                       ; preds = %Case16_RangeCheck, %Case16_LowCheck, %Case32_RangeCheck, %Case32_LowCheck, %Case8_RangeCheck, %Case8_LowCheck, %Case64_CheckSign, %UnknownSize
  store i64 0, i64* %var60, align 8
  %r15_valRE = load i8*, i8** %r15, align 8
  %pFmt = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  call void (i8*, ...) @sub_140001700(i8* %pFmt, i8* %r15_valRE)
  br label %ret

L1AE8:                                            ; preds = %Lcmp11
  %rbx_a = load i8*, i8** %rbx, align 8
  %p_rbx_i32a = bitcast i8* %rbx_a to i32*
  %r9d0 = load i32, i32* %p_rbx_i32a, align 1
  %r9d0_zero = icmp eq i32 %r9d0, 0
  br i1 %r9d0_zero, label %L1AE8_b, label %L1AFD

L1AE8_b:                                          ; preds = %L1AE8
  %p_rbx4a = getelementptr i8, i8* %rbx_a, i64 4
  %p_rbx4a_i32 = bitcast i8* %p_rbx4a to i32*
  %r8d0 = load i32, i32* %p_rbx4a_i32, align 1
  %r8d0_zero = icmp eq i32 %r8d0, 0
  br i1 %r8d0_zero, label %L1C17, label %L1AFD

L1AFD:                                            ; preds = %L1AE8_b, %L1963, %L196d
  %rbx_b = load i8*, i8** %rbx, align 8
  %rdi_b = load i8*, i8** %rdi, align 8
  %cond_b = icmp uge i8* %rbx_b, %rdi_b
  br i1 %cond_b, label %ret, label %L1B06

L1B06:                                            ; preds = %L1AFD
  %base_b = load i8*, i8** @off_1400043C0, align 8
  store i8* %base_b, i8** %r14, align 8
  store i8* %src_i8, i8** %r13, align 8
  br label %L1B20

L1B20:                                            ; preds = %L1B20, %L1B06
  %rbx_c = load i8*, i8** %rbx, align 8
  %p_rbx4c = getelementptr i8, i8* %rbx_c, i64 4
  %p_rbx4c_i32 = bitcast i8* %p_rbx4c to i32*
  %r12d_val = load i32, i32* %p_rbx4c_i32, align 1
  %eax_ptr_c = bitcast i8* %rbx_c to i32*
  %eax_val_c = load i32, i32* %eax_ptr_c, align 1
  %rbx_c_next = getelementptr i8, i8* %rbx_c, i64 8
  store i8* %rbx_c_next, i8** %rbx, align 8
  %base_c = load i8*, i8** %r14, align 8
  %r12_off64 = zext i32 %r12d_val to i64
  %ptr_sym = getelementptr i8, i8* %base_c, i64 %r12_off64
  %dptr_sym = bitcast i8* %ptr_sym to i32*
  %sym_val = load i32, i32* %dptr_sym, align 1
  %sum = add i32 %eax_val_c, %sym_val
  %dest_ptr = getelementptr i8, i8* %base_c, i64 %r12_off64
  %sum64 = sext i32 %sum to i64
  store i64 %sum64, i64* %Src, align 8
  call void @sub_140001760(i8* %dest_ptr)
  %src_v1 = load i8*, i8** %r13, align 8
  call i8* @memcpy(i8* %dest_ptr, i8* %src_v1, i64 4)
  %rbx_after = load i8*, i8** %rbx, align 8
  %rdi_after = load i8*, i8** %rdi, align 8
  %cont_b = icmp ult i8* %rbx_after, %rdi_after
  br i1 %cont_b, label %L1B20, label %L1A90

L1A90:                                            ; preds = %Case64_Write, %Case8_Write, %Case32_Write, %Case16_Write, %L1B20
  %countA = load i32, i32* @dword_1400070A4, align 4
  %leZero = icmp sle i32 %countA, 0
  br i1 %leZero, label %ret, label %VP_Init

VP_Init:                                          ; preds = %L1A90
  %vp_off = alloca i64, align 8
  store i64 0, i64* %vp_off, align 8
  br label %VP_Loop

VP_Loop:                                          ; preds = %VP_AfterCall, %VP_Init
  %base_vp = load i8*, i8** @qword_1400070A8, align 8
  %offs = load i64, i64* %vp_off, align 8
  %entry_ptr = getelementptr i8, i8* %base_vp, i64 %offs
  %fl_ptr = bitcast i8* %entry_ptr to i32*
  %fl_val = load i32, i32* %fl_ptr, align 1
  %fl_zero = icmp eq i32 %fl_val, 0
  br i1 %fl_zero, label %VP_AfterCall, label %VP_DoCall

VP_DoCall:                                        ; preds = %VP_Loop
  %lp_ptrptr = getelementptr i8, i8* %entry_ptr, i64 8
  %lp_ptr = bitcast i8* %lp_ptrptr to i8**
  %lp_val = load i8*, i8** %lp_ptr, align 1
  %size_ptr = getelementptr i8, i8* %entry_ptr, i64 16
  %size64ptr = bitcast i8* %size_ptr to i64*
  %size_val = load i64, i64* %size64ptr, align 1
  %oldprot_i8 = load i8*, i8** %r13, align 8
  %oldprot_i32ptr = bitcast i8* %oldprot_i8 to i32*
  %fpptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %callvp = call i32 %fpptr(i8* %lp_val, i64 %size_val, i32 %fl_val, i32* %oldprot_i32ptr)
  br label %VP_AfterCall

VP_AfterCall:                                     ; preds = %VP_DoCall, %VP_Loop
  %esi_val = load i32, i32* %esi, align 4
  %esi_inc = add i32 %esi_val, 1
  store i32 %esi_inc, i32* %esi, align 4
  %offs2 = load i64, i64* %vp_off, align 8
  %offs_next = add i64 %offs2, 40
  store i64 %offs_next, i64* %vp_off, align 8
  %countB = load i32, i32* @dword_1400070A4, align 4
  %lt = icmp slt i32 %esi_inc, %countB
  br i1 %lt, label %VP_Loop, label %ret

L1C17:                                            ; preds = %L1AE8_b
  %rbx_c17 = load i8*, i8** %rbx, align 8
  %p8_c17 = getelementptr i8, i8* %rbx_c17, i64 8
  %p8_c17_i32 = bitcast i8* %p8_c17 to i32*
  %ecx_c17 = load i32, i32* %p8_c17_i32, align 1
  %ecx_c17_zero = icmp eq i32 %ecx_c17, 0
  br i1 %ecx_c17_zero, label %L1C17_zero, label %L1978

L1C17_zero:                                       ; preds = %L1C17
  %rbx_plusC2 = getelementptr i8, i8* %rbx_c17, i64 12
  store i8* %rbx_plusC2, i8** %rbx, align 8
  br label %L1963

L1C53:                                            ; preds = %L1978
  %pProto = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %pProto)
  br label %ret
}
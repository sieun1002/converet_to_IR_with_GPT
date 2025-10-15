; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_140007004 = internal global i32 0, align 4
@dword_140007008 = internal global i32 0, align 4
@qword_140007010 = internal global i8* null, align 8
@qword_140007018 = internal global i8** null, align 8
@dword_140007020 = internal global i32 0, align 4

@off_140004450 = external global i8**, align 8
@__imp_Sleep = external dllimport global void (i32)*, align 8
@off_140004460 = external global i32*, align 8
@off_1400043D0 = external global i8**, align 8
@off_140004400 = external global i32*, align 8
@off_140004410 = external global i32*, align 8
@off_140004420 = external global i32*, align 8
@off_140004430 = external global i32*, align 8
@off_1400043A0 = external global i8*, align 8
@__imp_SetUnhandledExceptionFilter = external dllimport global i8* (i8*)*, align 8
@off_140004440 = external global i8**, align 8
@off_1400044D0 = external global i32*, align 8
@off_1400044B0 = external global i32*, align 8
@off_140004380 = external global i32*, align 8
@off_1400043E0 = external global i32*, align 8
@First = external global i8*, align 8
@Last = external global i8*, align 8
@off_140004500 = external global i32*, align 8
@off_1400044C0 = external global i32*, align 8
@off_140004470 = external global i8*, align 8
@off_140004480 = external global i8*, align 8

declare i8** @sub_140002A20()
declare i32 @sub_14000171D(i32, i8**, i8*)
declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32 @sub_140001910()
declare i32 @sub_140002A60(i32*, i8***, i8**, i32, i32*)
declare i32 @sub_140002A30(i32)
declare void @_cexit()
declare i32 @_configthreadlocale(i32)
declare void @sub_140002070(i8*)
declare void @sub_1400019D0()
declare void @sub_1400018F0()
declare void @exit(i32)
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_initterm_e(i8*, i8*)
declare void @_initterm(i8*, i8*)
declare i32 @_set_app_type(i32)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @TopLevelExceptionFilter(i8*)
declare void @Handler(i8*, i8*, i8*, i32, i64)

define void @sub_140001010() local_unnamed_addr {
entry:
  %var_4C = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %r14slot = alloca i32, align 4
  %teb = call i8* asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r"()
  %pplus8 = getelementptr i8, i8* %teb, i64 8
  %pplus8p = bitcast i8* %pplus8 to i8**
  %rsi_owner = load i8*, i8** %pplus8p, align 8
  %lockptrptr_ptr = load i8**, i8*** @off_140004450
  %imp_sleep = load void (i32)*, void (i32)** @__imp_Sleep, align 8
  br label %acquire

acquire:                                          ; preds = %sleep_then_retry, %entry
  %cmpxchg = cmpxchg i8** %lockptrptr_ptr, i8* null, i8* %rsi_owner seq_cst seq_cst
  %old = extractvalue { i8*, i1 } %cmpxchg, 0
  %success = extractvalue { i8*, i1 } %cmpxchg, 1
  br i1 %success, label %acq_success, label %acq_fail

acq_fail:                                         ; preds = %acquire
  %same = icmp eq i8* %old, %rsi_owner
  br i1 %same, label %owned_by_self, label %sleep_then_retry

sleep_then_retry:                                 ; preds = %acq_fail
  call void %imp_sleep(i32 1000)
  br label %acquire

owned_by_self:                                    ; preds = %acq_fail
  store i32 1, i32* %r14slot, align 4
  br label %after_lock

acq_success:                                      ; preds = %acquire
  store i32 0, i32* %r14slot, align 4
  br label %after_lock

after_lock:                                       ; preds = %acq_success, %owned_by_self
  %stateptr = load i32*, i32** @off_140004460, align 8
  %state1 = load i32, i32* %stateptr, align 4
  %cmp1 = icmp eq i32 %state1, 1
  br i1 %cmp1, label %bb_13C8, label %bb_after_cmp1

bb_after_cmp1:                                    ; preds = %after_lock
  %state2 = load i32, i32* %stateptr, align 4
  %iszero_state = icmp eq i32 %state2, 0
  br i1 %iszero_state, label %bb_1110, label %bb_107A

bb_13C8:                                          ; preds = %after_lock
  %retA30_31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %retA30_31)
  ret void

bb_1110:                                          ; preds = %bb_after_cmp1
  store i32 1, i32* %stateptr, align 4
  call void @sub_140001CA0()
  %tlexc_fn = bitcast void (i8*)* @TopLevelExceptionFilter to i8*
  %pSetUEF = load i8* (i8*)*, i8* (i8*)** @__imp_SetUnhandledExceptionFilter, align 8
  %prevUEF = call i8* %pSetUEF(i8* %tlexc_fn)
  %pPrevLoc = load i8**, i8*** @off_140004440, align 8
  store i8* %prevUEF, i8** %pPrevLoc, align 8
  %handler = bitcast void (i8*, i8*, i8*, i32, i64)* @Handler to i8*
  %oldInv = call i8* @_set_invalid_parameter_handler(i8* %handler)
  call void @sub_1400024E0()
  %p0410 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p0410, align 4
  %p0420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p0420, align 4
  %p0430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p0430, align 4
  %imgbase = load i8*, i8** @off_1400043A0, align 8
  %imgbase_i16ptr = bitcast i8* %imgbase to i16*
  %sig1 = load i16, i16* %imgbase_i16ptr, align 2
  %is_mz = icmp eq i16 %sig1, 23117
  br i1 %is_mz, label %pe_check, label %ecx_zero_path

pe_check:                                         ; preds = %bb_1110
  %e_lfanew_ptr = getelementptr i8, i8* %imgbase, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 4
  %e_lfanew_i64 = sext i32 %e_lfanew to i64
  %peptr = getelementptr i8, i8* %imgbase, i64 %e_lfanew_i64
  %pe_sig_ptr = bitcast i8* %peptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %opt_hdr_check, label %ecx_zero_path

opt_hdr_check:                                    ; preds = %pe_check
  %opt_magic_ptr_i8 = getelementptr i8, i8* %peptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %dx = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32 = icmp eq i16 %dx, 267
  br i1 %is_pe32, label %path_13AA, label %check_pe32plus

check_pe32plus:                                   ; preds = %opt_hdr_check
  %is_pe64 = icmp eq i16 %dx, 523
  br i1 %is_pe64, label %pe64_fields, label %ecx_zero_path

pe64_fields:                                      ; preds = %check_pe32plus
  %off84 = getelementptr i8, i8* %peptr, i64 132
  %val84p = bitcast i8* %off84 to i32*
  %val84 = load i32, i32* %val84p, align 4
  %cond = icmp ugt i32 %val84, 14
  br i1 %cond, label %read_0F8, label %ecx_zero_path

read_0F8:                                         ; preds = %pe64_fields
  %offF8 = getelementptr i8, i8* %peptr, i64 248
  %vF8p = bitcast i8* %offF8 to i32*
  %vF8 = load i32, i32* %vF8p, align 4
  %nz = icmp ne i32 %vF8, 0
  br label %set_ecx

path_13AA:                                        ; preds = %opt_hdr_check
  %off74 = getelementptr i8, i8* %peptr, i64 116
  %v74p = bitcast i8* %off74 to i32*
  %v74 = load i32, i32* %v74p, align 4
  %cond74 = icmp ugt i32 %v74, 14
  br i1 %cond74, label %read_0E8_pe32, label %ecx_zero_path

read_0E8_pe32:                                    ; preds = %path_13AA
  %off0E8 = getelementptr i8, i8* %peptr, i64 232
  %v0E8p = bitcast i8* %off0E8 to i32*
  %v0E8 = load i32, i32* %v0E8p, align 4
  %nz32 = icmp ne i32 %v0E8, 0
  br label %set_ecx

ecx_zero_path:                                    ; preds = %check_pe32plus, %pe64_fields, %pe_check, %bb_1110, %path_13AA
  br label %store_ecx

set_ecx:                                          ; preds = %read_0E8_pe32, %read_0F8
  %nz_phi = phi i1 [ %nz, %read_0F8 ], [ %nz32, %read_0E8_pe32 ]
  %ecx_val = select i1 %nz_phi, i32 1, i32 0
  br label %store_ecx

store_ecx:                                        ; preds = %set_ecx, %ecx_zero_path
  %ecx_final = phi i32 [ 0, %ecx_zero_path ], [ %ecx_val, %set_ecx ]
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %p0400 = load i32*, i32** @off_140004400, align 8
  %r8dval = load i32, i32* %p0400, align 4
  %r8d_nonzero = icmp ne i32 %r8dval, 0
  br i1 %r8d_nonzero, label %bb_1338, label %bb_1D9

bb_1338:                                          ; preds = %store_ecx
  %oldtype2 = call i32 @_set_app_type(i32 2)
  br label %bb_1E3

bb_1D9:                                           ; preds = %store_ecx
  %oldtype1 = call i32 @_set_app_type(i32 1)
  br label %bb_1E3

bb_1E3:                                           ; preds = %bb_1D9, %bb_1338
  %pfmode = call i32* @__p__fmode()
  %p4D0 = load i32*, i32** @off_1400044D0, align 8
  %val4D0 = load i32, i32* %p4D0, align 4
  store i32 %val4D0, i32* %pfmode, align 4
  %pcommode = call i32* @__p__commode()
  %p4B0 = load i32*, i32** @off_1400044B0, align 8
  %val4B0 = load i32, i32* %p4B0, align 4
  store i32 %val4B0, i32* %pcommode, align 4
  %ret1910 = call i32 @sub_140001910()
  %neg = icmp slt i32 %ret1910, 0
  br i1 %neg, label %bb_1301, label %bb_1210_after

bb_1301:                                          ; preds = %bb_1E3, %loop_copy, %bb_28A
  %code_from_1301 = call i32 @sub_140002A30(i32 8)
  br label %bb_1310

bb_1210_after:                                    ; preds = %bb_1E3
  %p4380 = load i32*, i32** @off_140004380, align 8
  %val4380 = load i32, i32* %p4380, align 4
  %is1 = icmp eq i32 %val4380, 1
  br i1 %is1, label %bb_1399, label %bb_1220

bb_1399:                                          ; preds = %bb_1210_after
  %fp = bitcast void ()* @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %fp)
  br label %bb_1220

bb_1220:                                          ; preds = %bb_1399, %bb_1210_after
  %p43E0 = load i32*, i32** @off_1400043E0, align 8
  %v43E0 = load i32, i32* %p43E0, align 4
  %isneg1 = icmp eq i32 %v43E0, -1
  br i1 %isneg1, label %bb_138A, label %bb_1230

bb_138A:                                          ; preds = %bb_1220
  %ctl = call i32 @_configthreadlocale(i32 -1)
  br label %bb_1230

bb_1230:                                          ; preds = %bb_138A, %bb_1220
  %FirstVal = load i8*, i8** @First, align 8
  %LastVal = load i8*, i8** @Last, align 8
  %retInitE = call i32 @_initterm_e(i8* %FirstVal, i8* %LastVal)
  %testRet = icmp ne i32 %retInitE, 0
  br i1 %testRet, label %bb_1380, label %bb_124B

bb_1380:                                          ; preds = %bb_1230
  ret void

bb_124B:                                          ; preds = %bb_1230
  %p4500 = load i32*, i32** @off_140004500, align 8
  %v4500 = load i32, i32* %p4500, align 4
  store i32 %v4500, i32* %var_4C, align 4
  %p4C0 = load i32*, i32** @off_1400044C0, align 8
  %v4C0 = load i32, i32* %p4C0, align 4
  %res_a60 = call i32 @sub_140002A60(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %v4C0, i32* %var_4C)
  %neg2 = icmp slt i32 %res_a60, 0
  br i1 %neg2, label %bb_1301, label %bb_28A

bb_28A:                                           ; preds = %bb_124B
  %argc = load i32, i32* @dword_140007020, align 4
  %r12 = sext i32 %argc to i64
  %plus1 = add nsw i64 %r12, 1
  %size = shl i64 %plus1, 3
  %arr = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %arr, null
  br i1 %isnull, label %bb_1301, label %bb_2AA

bb_2AA:                                           ; preds = %bb_28A
  %arrv = bitcast i8* %arr to i8**
  %leZero = icmp sle i64 %r12, 0
  br i1 %leZero, label %bb_134C, label %bb_setup_loop

bb_setup_loop:                                    ; preds = %bb_2AA
  %argv_base = load i8**, i8*** @qword_140007018, align 8
  br label %loop_header

loop_header:                                      ; preds = %loop_continue, %bb_setup_loop
  %i = phi i64 [ 1, %bb_setup_loop ], [ %i_next, %loop_continue ]
  %index = add i64 %i, -1
  %srcptrptr = getelementptr inbounds i8*, i8** %argv_base, i64 %index
  %src = load i8*, i8** %srcptrptr, align 8
  %len = call i64 @strlen(i8* %src)
  %sz1 = add i64 %len, 1
  %dst = call i8* @malloc(i64 %sz1)
  %dstslotptr = getelementptr inbounds i8*, i8** %arrv, i64 %index
  store i8* %dst, i8** %dstslotptr, align 8
  %dst_isnull = icmp eq i8* %dst, null
  br i1 %dst_isnull, label %bb_1301, label %loop_copy

loop_copy:                                        ; preds = %loop_header
  call i8* @memcpy(i8* %dst, i8* %src, i64 %sz1)
  %end = icmp eq i64 %r12, %i
  br i1 %end, label %bb_1347, label %loop_continue

loop_continue:                                    ; preds = %loop_copy
  %i_next = add i64 %i, 1
  br label %loop_header

bb_1347:                                          ; preds = %loop_copy
  %end_slot = getelementptr inbounds i8*, i8** %arrv, i64 %r12
  br label %bb_134C

bb_134C:                                          ; preds = %bb_1347, %bb_2AA
  %slot = phi i8** [ %end_slot, %bb_1347 ], [ %arrv, %bb_2AA ]
  store i8* null, i8** %slot, align 8
  %p0480 = load i8*, i8** @off_140004480, align 8
  %p0470 = load i8*, i8** @off_140004470, align 8
  store i8** %arrv, i8*** @qword_140007018, align 8
  call void @_initterm(i8* %p0470, i8* %p0480)
  call void @sub_1400018F0()
  store i32 2, i32* %stateptr, align 4
  br label %bb_1084

bb_107A:                                          ; preds = %bb_after_cmp1
  store i32 1, i32* @dword_140007004, align 4
  br label %bb_1084

bb_1328:                                          ; preds = %bb_1084
  store atomic i8* null, i8** %lockptrptr_ptr seq_cst, align 8
  br label %bb_108D

bb_1084:                                          ; preds = %bb_134C, %bb_107A
  %r14val = load i32, i32* %r14slot, align 4
  %iszero_r14 = icmp eq i32 %r14val, 0
  br i1 %iszero_r14, label %bb_1328, label %bb_108D

bb_108D:                                          ; preds = %bb_1328, %bb_1084
  %pp = load i8**, i8*** @off_1400043D0, align 8
  %funp = load i8*, i8** %pp, align 8
  %isnullfun = icmp eq i8* %funp, null
  br i1 %isnullfun, label %bb_10A8, label %bb_109C

bb_109C:                                          ; preds = %bb_108D
  %funptr = bitcast i8* %funp to void (i32, i32, i32)*
  call void %funptr(i32 0, i32 2, i32 0)
  br label %bb_10A8

bb_10A8:                                          ; preds = %bb_109C, %bb_108D
  %pA20 = call i8** @sub_140002A20()
  %r8val = load i8*, i8** @qword_140007010, align 8
  store i8* %r8val, i8** %pA20, align 8
  %ecxval = load i32, i32* @dword_140007020, align 4
  %rdxval = load i8**, i8*** @qword_140007018, align 8
  %ret171D = call i32 @sub_14000171D(i32 %ecxval, i8** %rdxval, i8* %r8val)
  %ecx2 = load i32, i32* @dword_140007008, align 4
  %iszeroecx2 = icmp eq i32 %ecx2, 0
  br i1 %iszeroecx2, label %bb_13D2, label %bb_10D7

bb_10D7:                                          ; preds = %bb_10A8
  %edx = load i32, i32* @dword_140007004, align 4
  %iszeroedx = icmp eq i32 %edx, 0
  br i1 %iszeroedx, label %bb_1310, label %epilogue

bb_13D2:                                          ; preds = %bb_10A8
  call void @exit(i32 %ret171D)
  ret void

bb_1310:                                          ; preds = %bb_10D7, %bb_1301
  %code = phi i32 [ %code_from_1301, %bb_1301 ], [ %ret171D, %bb_10D7 ]
  store i32 %code, i32* %var_5C, align 4
  call void @_cexit()
  %retcode = load i32, i32* %var_5C, align 4
  ret void

epilogue:                                         ; preds = %bb_10D7
  ret void
}
; ModuleID = 'recovered'
source_filename = "recovered.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.EXCEPTION_RECORD = type { i32, i32 }
%struct.EXCEPTION_POINTERS = type { %struct.EXCEPTION_RECORD*, i8* }

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (%struct.EXCEPTION_POINTERS*)*, align 8

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define dso_local void @start() {
entry:
  %paddr = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %paddr, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @TopLevelExceptionFilter(%struct.EXCEPTION_POINTERS* %excinfo) {
entry:
  %recptrptr = getelementptr %struct.EXCEPTION_POINTERS, %struct.EXCEPTION_POINTERS* %excinfo, i32 0, i32 0
  %recptr = load %struct.EXCEPTION_RECORD*, %struct.EXCEPTION_RECORD** %recptrptr, align 8
  %codeptr = getelementptr %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %recptr, i32 0, i32 0
  %code = load i32, i32* %codeptr, align 4
  %masked = and i32 %code, 553648127
  %isgcc = icmp eq i32 %masked, 541216067
  br i1 %isgcc, label %gcc_check, label %after_magic

gcc_check:
  %flagsptr = getelementptr %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %recptr, i32 0, i32 1
  %flags = load i32, i32* %flagsptr, align 4
  %flag1 = and i32 %flags, 1
  %hasflag = icmp ne i32 %flag1, 0
  br i1 %hasflag, label %after_magic, label %ret_minus1

after_magic:
  %cmp_ja = icmp ugt i32 %code, 3221225622
  br i1 %cmp_ja, label %vectored_attempt, label %le_96

le_96:
  %cmp_jbe = icmp ule i32 %code, 3221225611
  br i1 %cmp_jbe, label %range_small, label %range_switch

range_small:
  %is_segv = icmp eq i32 %code, 3221225477
  br i1 %is_segv, label %sigsegv, label %gt_segv

gt_segv:
  %gt_5 = icmp ugt i32 %code, 3221225477
  br i1 %gt_5, label %check_150, label %check_80000002

check_80000002:
  %is_misal = icmp eq i32 %code, 2147483650
  br i1 %is_misal, label %ret_minus1, label %vectored_attempt

check_150:
  %is_0008 = icmp eq i32 %code, 3221225480
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_0008, label %ret_minus1, label %check_001d

check_001d:
  br i1 %is_001D, label %sigill, label %vectored_attempt

range_switch:
  switch i32 %code, label %ret_minus1 [
    i32 3221225613, label %fpe_common
    i32 3221225614, label %fpe_common
    i32 3221225615, label %fpe_common
    i32 3221225616, label %fpe_common
    i32 3221225617, label %fpe_common
    i32 3221225619, label %fpe_common
    i32 3221225620, label %fpe_intdiv
    i32 3221225622, label %sigill
  ]

fpe_common:
  %prev0 = call void (i32)* @signal(i32 8, void (i32)* null)
  %prev0_i8 = bitcast void (i32)* %prev0 to i8*
  %ign_i8_0 = inttoptr i64 1 to i8*
  %is_ign0 = icmp eq i8* %prev0_i8, %ign_i8_0
  br i1 %is_ign0, label %fpe_set_and_cleanup, label %fpe_common_checkprev

fpe_common_checkprev:
  %is_null0 = icmp eq void (i32)* %prev0, null
  br i1 %is_null0, label %vectored_attempt, label %call_prev_fpe

call_prev_fpe:
  call void %prev0(i32 8)
  br label %ret_minus1

fpe_set_and_cleanup:
  %ign_func_0 = bitcast i8* %ign_i8_0 to void (i32)*
  %tmp_sig0 = call void (i32)* @signal(i32 8, void (i32)* %ign_func_0)
  call void @sub_1400024E0()
  br label %ret_minus1

fpe_intdiv:
  %prev1 = call void (i32)* @signal(i32 8, void (i32)* null)
  %prev1_i8 = bitcast void (i32)* %prev1 to i8*
  %ign_i8_1 = inttoptr i64 1 to i8*
  %is_ign1 = icmp eq i8* %prev1_i8, %ign_i8_1
  br i1 %is_ign1, label %fpe_set_ignore_only, label %fpe_intdiv_checkprev

fpe_intdiv_checkprev:
  %is_null1 = icmp eq void (i32)* %prev1, null
  br i1 %is_null1, label %vectored_attempt, label %call_prev_fpe2

call_prev_fpe2:
  call void %prev1(i32 8)
  br label %ret_minus1

fpe_set_ignore_only:
  %ign_func_1 = bitcast i8* %ign_i8_1 to void (i32)*
  %tmp_sig1 = call void (i32)* @signal(i32 8, void (i32)* %ign_func_1)
  br label %ret_minus1

sigill:
  %prev2 = call void (i32)* @signal(i32 4, void (i32)* null)
  %prev2_i8 = bitcast void (i32)* %prev2 to i8*
  %ign_i8_2 = inttoptr i64 1 to i8*
  %is_ign2 = icmp eq i8* %prev2_i8, %ign_i8_2
  br i1 %is_ign2, label %sigill_set_ignore, label %sigill_checkprev

sigill_checkprev:
  %is_null2 = icmp eq void (i32)* %prev2, null
  br i1 %is_null2, label %vectored_attempt, label %call_prev_ill

call_prev_ill:
  call void %prev2(i32 4)
  br label %ret_minus1

sigill_set_ignore:
  %ign_func_2 = bitcast i8* %ign_i8_2 to void (i32)*
  %tmp_sig2 = call void (i32)* @signal(i32 4, void (i32)* %ign_func_2)
  br label %ret_minus1

sigsegv:
  %prev3 = call void (i32)* @signal(i32 11, void (i32)* null)
  %prev3_i8 = bitcast void (i32)* %prev3 to i8*
  %ign_i8_3 = inttoptr i64 1 to i8*
  %is_ign3 = icmp eq i8* %prev3_i8, %ign_i8_3
  br i1 %is_ign3, label %sigsegv_set_ignore, label %sigsegv_checkprev

sigsegv_checkprev:
  %is_null3 = icmp eq void (i32)* %prev3, null
  br i1 %is_null3, label %vectored_attempt, label %call_prev_segv

call_prev_segv:
  call void %prev3(i32 11)
  br label %ret_minus1

sigsegv_set_ignore:
  %ign_func_3 = bitcast i8* %ign_i8_3 to void (i32)*
  %tmp_sig3 = call void (i32)* @signal(i32 11, void (i32)* %ign_func_3)
  br label %ret_minus1

vectored_attempt:
  %vhptr = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %isnullvh = icmp eq i32 (%struct.EXCEPTION_POINTERS*)* %vhptr, null
  br i1 %isnullvh, label %ret_zero, label %call_vh

call_vh:
  %res = call i32 %vhptr(%struct.EXCEPTION_POINTERS* %excinfo)
  ret i32 %res

ret_zero:
  ret i32 0

ret_minus1:
  ret i32 -1
}
; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8** %rcx) {
entry:
  %pRecord = load i8*, i8** %rcx, align 8
  %rec_i32ptr = bitcast i8* %pRecord to i32*
  %exc = load i32, i32* %rec_i32ptr, align 4
  %rbxval = bitcast i8** %rcx to i8*
  %masked = and i32 %exc, 553648127
  %cmpmasked = icmp eq i32 %masked, 541541187
  br i1 %cmpmasked, label %maskhit, label %main

maskhit:
  %flags_ptr = getelementptr i8, i8* %pRecord, i32 4
  %flags = load i8, i8* %flags_ptr, align 1
  %flag1 = and i8 %flags, 1
  %flag1nz = icmp ne i8 %flag1, 0
  br i1 %flag1nz, label %main, label %ret_minus1

main:
  %cmp_ugt_96 = icmp ugt i32 %exc, 3221225622
  br i1 %cmp_ugt_96, label %fallback, label %le_96

le_96:
  %cmp_ule_8B = icmp ule i32 %exc, 3221225611
  br i1 %cmp_ule_8B, label %group1, label %switchRange

group1:
  %is_av = icmp eq i32 %exc, 3221225477
  br i1 %is_av, label %case_access_violation, label %group1_else

group1_else:
  %ugt_5 = icmp ugt i32 %exc, 3221225477
  br i1 %ugt_5, label %group2, label %group1_low

group1_low:
  %is_misalign = icmp eq i32 %exc, 2147483650
  br i1 %is_misalign, label %ret_minus1, label %fallback

group2:
  %is_invalid_handle = icmp eq i32 %exc, 3221225480
  br i1 %is_invalid_handle, label %ret_minus1, label %group2_else

group2_else:
  %is_illegal_inst = icmp eq i32 %exc, 3221225501
  br i1 %is_illegal_inst, label %case_illegal_instruction, label %fallback

switchRange:
  %is_0094 = icmp eq i32 %exc, 3221225620
  br i1 %is_0094, label %case_0094, label %switch_else1

switch_else1:
  %is_0096 = icmp eq i32 %exc, 3221225622
  br i1 %is_0096, label %case_illegal_instruction, label %switch_else2

switch_else2:
  %is_0092 = icmp eq i32 %exc, 3221225618
  %is_0095 = icmp eq i32 %exc, 3221225621
  %or_def = or i1 %is_0092, %is_0095
  br i1 %or_def, label %ret_minus1, label %switch_else3

switch_else3:
  %cmp_ge_8D = icmp uge i32 %exc, 3221225613
  %cmp_le_91 = icmp ule i32 %exc, 3221225617
  %in_8D_91 = and i1 %cmp_ge_8D, %cmp_le_91
  %is_0093 = icmp eq i32 %exc, 3221225619
  %do_fpe = or i1 %in_8D_91, %is_0093
  br i1 %do_fpe, label %case_fpe_generic, label %fallback

case_fpe_generic:
  %sigdef = inttoptr i64 0 to void (i32)*
  %old_fpe = call void (i32)* @signal(i32 8, void (i32)* %sigdef)
  %is_one_fpe = icmp eq void (i32)* %old_fpe, inttoptr (i64 1 to void (i32)*)
  br i1 %is_one_fpe, label %case_224, label %fpe_check_old

fpe_check_old:
  %is_null_fpe = icmp eq void (i32)* %old_fpe, null
  br i1 %is_null_fpe, label %fallback, label %call_old_fpe

call_old_fpe:
  call void %old_fpe(i32 8)
  br label %ret_minus1

case_0094:
  %sigdef2 = inttoptr i64 0 to void (i32)*
  %old_fpe2 = call void (i32)* @signal(i32 8, void (i32)* %sigdef2)
  %is_not_one = icmp ne void (i32)* %old_fpe2, inttoptr (i64 1 to void (i32)*)
  br i1 %is_not_one, label %e6_path, label %set_ign_and_ret

e6_path:
  %is_null2 = icmp eq void (i32)* %old_fpe2, null
  br i1 %is_null2, label %fallback, label %call_old_fpe2

call_old_fpe2:
  call void %old_fpe2(i32 8)
  br label %ret_minus1

set_ign_and_ret:
  %sigign = inttoptr i64 1 to void (i32)*
  %tmp3 = call void (i32)* @signal(i32 8, void (i32)* %sigign)
  br label %ret_minus1

case_illegal_instruction:
  %sigdef3 = inttoptr i64 0 to void (i32)*
  %old_ill = call void (i32)* @signal(i32 4, void (i32)* %sigdef3)
  %is_one_ill = icmp eq void (i32)* %old_ill, inttoptr (i64 1 to void (i32)*)
  br i1 %is_one_ill, label %set_ign_ill, label %ill_check_old

ill_check_old:
  %is_null_ill = icmp eq void (i32)* %old_ill, null
  br i1 %is_null_ill, label %fallback, label %call_old_ill

call_old_ill:
  call void %old_ill(i32 4)
  br label %ret_minus1

set_ign_ill:
  %sigign2 = inttoptr i64 1 to void (i32)*
  %tmp4 = call void (i32)* @signal(i32 4, void (i32)* %sigign2)
  br label %ret_minus1

case_access_violation:
  %sigdef4 = inttoptr i64 0 to void (i32)*
  %old_segv = call void (i32)* @signal(i32 11, void (i32)* %sigdef4)
  %is_one_segv = icmp eq void (i32)* %old_segv, inttoptr (i64 1 to void (i32)*)
  br i1 %is_one_segv, label %set_ign_segv, label %segv_check_old

segv_check_old:
  %is_null_segv = icmp eq void (i32)* %old_segv, null
  br i1 %is_null_segv, label %fallback, label %call_old_segv

call_old_segv:
  call void %old_segv(i32 11)
  br label %ret_minus1

set_ign_segv:
  %sigign3 = inttoptr i64 1 to void (i32)*
  %tmp5 = call void (i32)* @signal(i32 11, void (i32)* %sigign3)
  br label %ret_minus1

case_224:
  %sigign4 = inttoptr i64 1 to void (i32)*
  %tmp6 = call void (i32)* @signal(i32 8, void (i32)* %sigign4)
  call void @sub_1400024E0()
  br label %ret_minus1

fallback:
  %cbptr = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %is_null_cb = icmp eq i32 (i8*)* %cbptr, null
  br i1 %is_null_cb, label %ret_zero, label %tailcb

tailcb:
  %res = tail call i32 %cbptr(i8* %rbxval)
  ret i32 %res

ret_minus1:
  ret i32 -1

ret_zero:
  ret i32 0
}
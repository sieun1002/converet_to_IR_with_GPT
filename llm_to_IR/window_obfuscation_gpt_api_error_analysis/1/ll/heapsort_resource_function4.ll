; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8*)*

declare dso_local void @sub_140001010()
declare dso_local void @sub_1400024E0()
declare dso_local void (i32)* @signal(i32, void (i32)*)

define dso_local void @start() {
entry:
  %p.ptr = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p.ptr, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @TopLevelExceptionFilter(i8* %exc_ptrs) {
entry:
  %exrec_ptr_ptr = bitcast i8* %exc_ptrs to i8**
  %exrec = load i8*, i8** %exrec_ptr_ptr, align 8
  %excode_ptr = bitcast i8* %exrec to i32*
  %code = load i32, i32* %excode_ptr, align 4
  %masked = and i32 %code, 0x20FFFFFF
  %match = icmp eq i32 %masked, 0x20474343
  br i1 %match, label %check_flag, label %main_dispatch

check_flag:
  %flags_byte_ptr = getelementptr i8, i8* %exrec, i64 4
  %flags_b = load i8, i8* %flags_byte_ptr, align 1
  %bit1 = and i8 %flags_b, 1
  %flag_set = icmp ne i8 %bit1, 0
  br i1 %flag_set, label %main_dispatch, label %default_ret

main_dispatch:
  %is_flt_008D = icmp eq i32 %code, 0xC000008D
  %is_flt_008E = icmp eq i32 %code, 0xC000008E
  %is_flt_008F = icmp eq i32 %code, 0xC000008F
  %is_flt_0090 = icmp eq i32 %code, 0xC0000090
  %is_flt_0091 = icmp eq i32 %code, 0xC0000091
  %is_int_overflow = icmp eq i32 %code, 0xC0000093
  %fpe_any1 = or i1 %is_flt_008D, %is_flt_008E
  %fpe_any2 = or i1 %is_flt_008F, %is_flt_0090
  %fpe_any3 = or i1 %is_flt_0091, %is_int_overflow
  %fpe_tmp = or i1 %fpe_any1, %fpe_any2
  %fpe_all = or i1 %fpe_tmp, %fpe_any3
  br i1 %fpe_all, label %block_0D0, label %check_div0

check_div0:
  %is_int_div0 = icmp eq i32 %code, 0xC0000094
  br i1 %is_int_div0, label %block_0190, label %check_access

check_access:
  %is_access = icmp eq i32 %code, 0xC0000005
  br i1 %is_access, label %block_01C0, label %check_illegal

check_illegal:
  %is_illegal = icmp eq i32 %code, 0xC000001D
  br i1 %is_illegal, label %block_015E, label %check_default_codes

check_default_codes:
  %is_datamis = icmp eq i32 %code, 0x80000002
  %is_invalid_handle = icmp eq i32 %code, 0xC0000008
  %either_default = or i1 %is_datamis, %is_invalid_handle
  br i1 %either_default, label %default_ret, label %handler_ptr

block_0D0:
  %sig_dfl_ptr0 = inttoptr i64 0 to void (i32)*
  %prev0 = call void (i32)* @signal(i32 8, void (i32)* %sig_dfl_ptr0)
  %is_prev_ign0 = icmp eq void (i32)* %prev0, inttoptr (i64 1 to void (i32)*)
  br i1 %is_prev_ign0, label %set_ign_and_abort_fpe, label %check_prev0

check_prev0:
  %is_prev_null0 = icmp eq void (i32)* %prev0, null
  br i1 %is_prev_null0, label %handler_ptr, label %call_prev0

call_prev0:
  call void %prev0(i32 8)
  br label %default_ret

set_ign_and_abort_fpe:
  %sig_ign_ptr0 = inttoptr i64 1 to void (i32)*
  %tmpcall0 = call void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr0)
  call void @sub_1400024E0()
  br label %default_ret

block_0190:
  %sig_dfl_ptr1 = inttoptr i64 0 to void (i32)*
  %prev1 = call void (i32)* @signal(i32 8, void (i32)* %sig_dfl_ptr1)
  %is_prev_ign1 = icmp eq void (i32)* %prev1, inttoptr (i64 1 to void (i32)*)
  br i1 %is_prev_ign1, label %set_ign_only_fpe, label %check_prev1

check_prev1:
  %is_prev_null1 = icmp eq void (i32)* %prev1, null
  br i1 %is_prev_null1, label %handler_ptr, label %call_prev1

call_prev1:
  call void %prev1(i32 8)
  br label %default_ret

set_ign_only_fpe:
  %sig_ign_ptr1 = inttoptr i64 1 to void (i32)*
  %tmpcall1 = call void (i32)* @signal(i32 8, void (i32)* %sig_ign_ptr1)
  br label %default_ret

block_015E:
  %sig_dfl_ptr2 = inttoptr i64 0 to void (i32)*
  %prev2 = call void (i32)* @signal(i32 4, void (i32)* %sig_dfl_ptr2)
  %is_prev_ign2 = icmp eq void (i32)* %prev2, inttoptr (i64 1 to void (i32)*)
  br i1 %is_prev_ign2, label %set_ign_only_ill, label %check_prev2

check_prev2:
  %is_prev_null2 = icmp eq void (i32)* %prev2, null
  br i1 %is_prev_null2, label %handler_ptr, label %call_prev2

call_prev2:
  call void %prev2(i32 4)
  br label %default_ret

set_ign_only_ill:
  %sig_ign_ptr2 = inttoptr i64 1 to void (i32)*
  %tmpcall2 = call void (i32)* @signal(i32 4, void (i32)* %sig_ign_ptr2)
  br label %default_ret

block_01C0:
  %sig_dfl_ptr3 = inttoptr i64 0 to void (i32)*
  %prev3 = call void (i32)* @signal(i32 11, void (i32)* %sig_dfl_ptr3)
  %is_prev_ign3 = icmp eq void (i32)* %prev3, inttoptr (i64 1 to void (i32)*)
  br i1 %is_prev_ign3, label %set_ign_only_segv, label %check_prev3

check_prev3:
  %is_prev_null3 = icmp eq void (i32)* %prev3, null
  br i1 %is_prev_null3, label %handler_ptr, label %call_prev3

call_prev3:
  call void %prev3(i32 11)
  br label %default_ret

set_ign_only_segv:
  %sig_ign_ptr3 = inttoptr i64 1 to void (i32)*
  %tmpcall3 = call void (i32)* @signal(i32 11, void (i32)* %sig_ign_ptr3)
  br label %default_ret

handler_ptr:
  %handler = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %handler_null = icmp eq i32 (i8*)* %handler, null
  br i1 %handler_null, label %ret_zero, label %call_handler

call_handler:
  %retv = call i32 %handler(i8* %exc_ptrs)
  ret i32 %retv

ret_zero:
  ret i32 0

default_ret:
  ret i32 -1
}
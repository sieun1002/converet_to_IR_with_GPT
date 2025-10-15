; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i8*
@qword_1400070D0 = external global i8*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare i8* @signal(i32, i8*)

define void @sub_1400013E0() {
entry:
  %p = load i8*, i8** @off_140004400, align 8
  %p32 = bitcast i8* %p to i32*
  store i32 1, i32* %p32, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %rcx) {
entry:
  %rbx = ptrtoint i8** %rcx to i64
  %rdx = load i8*, i8** %rcx, align 8
  %codeptr = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %codeptr, align 4
  %masked = and i32 %eax, 553648127
  %ccg.cmp = icmp eq i32 %masked, 541541187
  br i1 %ccg.cmp, label %ccg_check, label %range_check

ccg_check:
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %b1z = icmp ne i8 %b1, 0
  br i1 %b1z, label %range_check, label %def_ret

range_check:
  %cmp_ugta = icmp ugt i32 %eax, -1073741674
  br i1 %cmp_ugta, label %fallback, label %le_8B

le_8B:
  %cmp_le_8B = icmp ule i32 %eax, -1073741797
  br i1 %cmp_le_8B, label %block_2110, label %switch_group

block_2110:
  %is_0005 = icmp eq i32 %eax, -1073741819
  br i1 %is_0005, label %sig11_case, label %gt_0005

gt_0005:
  %cmp_ugta_0005 = icmp ugt i32 %eax, -1073741819
  br i1 %cmp_ugta_0005, label %block_2150, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %eax, -2147483646
  br i1 %is_80000002, label %def_ret, label %fallback

block_2150:
  %is_0008 = icmp eq i32 %eax, -1073741816
  br i1 %is_0008, label %def_ret, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %eax, -1073741795
  br i1 %is_001D, label %sig4_case, label %fallback

switch_group:
  switch i32 %eax, label %def_ret [
    i32 -1073741683, label %sig8_case
    i32 -1073741682, label %sig8_case
    i32 -1073741681, label %sig8_case
    i32 -1073741680, label %sig8_case
    i32 -1073741679, label %sig8_case
    i32 -1073741677, label %sig8_case
    i32 -1073741676, label %sig8_special
    i32 -1073741674, label %sig4_case
  ]

sig8_case:
  %s8_prev = call i8* @signal(i32 8, i8* null)
  %s8_prev_int = ptrtoint i8* %s8_prev to i64
  %is_sig_ign_8 = icmp eq i64 %s8_prev_int, 1
  br i1 %is_sig_ign_8, label %sig8_set_ign_and_abort, label %sig8_check_call

sig8_check_call:
  %is_null_8 = icmp eq i8* %s8_prev, null
  br i1 %is_null_8, label %fallback, label %call_prev_8

call_prev_8:
  %handler8 = bitcast i8* %s8_prev to void (i32)*
  call void %handler8(i32 8)
  br label %def_ret

sig8_set_ign_and_abort:
  %sig_ign_ptr_8 = inttoptr i64 1 to i8*
  %s8_set = call i8* @signal(i32 8, i8* %sig_ign_ptr_8)
  call void @sub_1400024E0()
  br label %def_ret

sig8_special:
  %s8_prev2 = call i8* @signal(i32 8, i8* null)
  %s8_prev2_int = ptrtoint i8* %s8_prev2 to i64
  %is_sig_ign_8b = icmp eq i64 %s8_prev2_int, 1
  br i1 %is_sig_ign_8b, label %sig8_set_ign_only, label %sig8_special_check_call

sig8_special_check_call:
  %is_null_8b = icmp eq i8* %s8_prev2, null
  br i1 %is_null_8b, label %fallback, label %call_prev_8b

call_prev_8b:
  %handler8b = bitcast i8* %s8_prev2 to void (i32)*
  call void %handler8b(i32 8)
  br label %def_ret

sig8_set_ign_only:
  %sig_ign_ptr_8c = inttoptr i64 1 to i8*
  %s8_set2 = call i8* @signal(i32 8, i8* %sig_ign_ptr_8c)
  br label %def_ret

sig4_case:
  %s4_prev = call i8* @signal(i32 4, i8* null)
  %s4_prev_int = ptrtoint i8* %s4_prev to i64
  %is_sig_ign_4 = icmp eq i64 %s4_prev_int, 1
  br i1 %is_sig_ign_4, label %sig4_set_ign, label %sig4_check_call

sig4_check_call:
  %is_null_4 = icmp eq i8* %s4_prev, null
  br i1 %is_null_4, label %fallback, label %call_prev_4

call_prev_4:
  %handler4 = bitcast i8* %s4_prev to void (i32)*
  call void %handler4(i32 4)
  br label %def_ret

sig4_set_ign:
  %sig_ign_ptr_4 = inttoptr i64 1 to i8*
  %s4_set = call i8* @signal(i32 4, i8* %sig_ign_ptr_4)
  br label %def_ret

sig11_case:
  %s11_prev = call i8* @signal(i32 11, i8* null)
  %s11_prev_int = ptrtoint i8* %s11_prev to i64
  %is_sig_ign_11 = icmp eq i64 %s11_prev_int, 1
  br i1 %is_sig_ign_11, label %sig11_set_ign, label %sig11_check_call

sig11_check_call:
  %is_null_11 = icmp eq i8* %s11_prev, null
  br i1 %is_null_11, label %fallback, label %call_prev_11

call_prev_11:
  %handler11 = bitcast i8* %s11_prev to void (i32)*
  call void %handler11(i32 11)
  br label %def_ret

sig11_set_ign:
  %sig_ign_ptr_11 = inttoptr i64 1 to i8*
  %s11_set = call i8* @signal(i32 11, i8* %sig_ign_ptr_11)
  br label %def_ret

fallback:
  %fp_ptr = load i8*, i8** @qword_1400070D0, align 8
  %isnullfp = icmp eq i8* %fp_ptr, null
  br i1 %isnullfp, label %ret0, label %tailcall

tailcall:
  %fp = bitcast i8* %fp_ptr to i32 (i8**)* 
  %rbx_ptr = inttoptr i64 %rbx to i8**
  %res = tail call i32 %fp(i8** %rbx_ptr)
  ret i32 %res

ret0:
  ret i32 0

def_ret:
  ret i32 -1
}
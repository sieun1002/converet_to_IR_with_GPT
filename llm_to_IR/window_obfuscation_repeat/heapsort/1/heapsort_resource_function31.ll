; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@__gvar_140004404 = internal global i32 0, align 4
@off_140004400 = global i32* @__gvar_140004404, align 8
@qword_1400070D0 = global i32 (i8**)* null, align 8

declare void @sub_140001010()
declare void @sub_1400024E0()
declare void (i32)* @signal(i32, void (i32)*)

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %ctx) {
entry:
  %rdx = load i8*, i8** %ctx, align 8
  %p32 = bitcast i8* %rdx to i32*
  %eax = load i32, i32* %p32, align 4
  %masked = and i32 %eax, 553648127
  %isMagic = icmp eq i32 %masked, 541541187
  br i1 %isMagic, label %magic, label %cont_a1

magic:
  %byteptr = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %byteptr, align 1
  %b1 = and i8 %b, 1
  %isnz = icmp ne i8 %b1, 0
  br i1 %isnz, label %cont_a1, label %ret_m1

ret_m1:
  ret i32 -1

cont_a1:
  %cmp_ugt_0096 = icmp ugt i32 %eax, 3221225622
  br i1 %cmp_ugt_0096, label %loc_20EF, label %range_check

range_check:
  %cmp_ule_008B = icmp ule i32 %eax, 3221225611
  br i1 %cmp_ule_008B, label %loc_2110, label %jt_region

loc_2110:
  %is_segv = icmp eq i32 %eax, 3221225477
  br i1 %is_segv, label %handle_segv, label %after_segv_cmp

after_segv_cmp:
  %cmp_ugt_after = icmp ugt i32 %eax, 3221225477
  br i1 %cmp_ugt_after, label %loc_2150, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %eax, 2147483650
  br i1 %is_80000002, label %ret_m1, label %loc_20EF

loc_2150:
  %is_0008 = icmp eq i32 %eax, 3221225480
  br i1 %is_0008, label %ret_m1, label %check_illegal_instruction

check_illegal_instruction:
  %is_001D = icmp eq i32 %eax, 3221225501
  br i1 %is_001D, label %handle_sigill, label %loc_20EF

jt_region:
  %is_group1_008D = icmp eq i32 %eax, 3221225613
  %is_group1_008E = icmp eq i32 %eax, 3221225614
  %is_group1_008F = icmp eq i32 %eax, 3221225615
  %is_group1_0090 = icmp eq i32 %eax, 3221225616
  %is_group1_0091 = icmp eq i32 %eax, 3221225617
  %is_group1_0093 = icmp eq i32 %eax, 3221225619
  %or1 = or i1 %is_group1_008D, %is_group1_008E
  %or2 = or i1 %is_group1_008F, %is_group1_0090
  %or3 = or i1 %is_group1_0091, %is_group1_0093
  %or12 = or i1 %or1, %or2
  %or123 = or i1 %or12, %or3
  br i1 %or123, label %handle_sigfpe_group, label %check_div0

check_div0:
  %is_div0 = icmp eq i32 %eax, 3221225620
  br i1 %is_div0, label %handle_div0, label %check_0096

check_0096:
  %is_0096 = icmp eq i32 %eax, 3221225622
  br i1 %is_0096, label %handle_sigill, label %ret_m1

handle_sigfpe_group:
  %sigfpe_old = call void (i32)* @signal(i32 8, void (i32)* null)
  %old_int = ptrtoint void (i32)* %sigfpe_old to i64
  %is_ign = icmp eq i64 %old_int, 1
  br i1 %is_ign, label %sigfpe_set_ign_and_call_extra, label %sigfpe_check_old

sigfpe_check_old:
  %is_null = icmp eq void (i32)* %sigfpe_old, null
  br i1 %is_null, label %loc_20EF, label %call_old_sigfpe

call_old_sigfpe:
  call void %sigfpe_old(i32 8)
  br label %ret_m1

sigfpe_set_ign_and_call_extra:
  %ign_ptr = inttoptr i64 1 to void (i32)*
  %tmp_set = call void (i32)* @signal(i32 8, void (i32)* %ign_ptr)
  call void @sub_1400024E0()
  br label %ret_m1

handle_div0:
  %sigfpe_old2 = call void (i32)* @signal(i32 8, void (i32)* null)
  %old2_int = ptrtoint void (i32)* %sigfpe_old2 to i64
  %is_not_ign = icmp ne i64 %old2_int, 1
  br i1 %is_not_ign, label %path_20E6, label %div0_set_ign

path_20E6:
  %is_null2 = icmp eq void (i32)* %sigfpe_old2, null
  br i1 %is_null2, label %loc_20EF, label %call_old_sigfpe2

call_old_sigfpe2:
  call void %sigfpe_old2(i32 8)
  br label %ret_m1

div0_set_ign:
  %ign_ptr2 = inttoptr i64 1 to void (i32)*
  %tmp_set2 = call void (i32)* @signal(i32 8, void (i32)* %ign_ptr2)
  br label %ret_m1

handle_sigill:
  %old_sigill = call void (i32)* @signal(i32 4, void (i32)* null)
  %old_sigill_int = ptrtoint void (i32)* %old_sigill to i64
  %is_ign_ill = icmp eq i64 %old_sigill_int, 1
  br i1 %is_ign_ill, label %sigill_set_ign, label %sigill_check_old

sigill_check_old:
  %is_null_ill = icmp eq void (i32)* %old_sigill, null
  br i1 %is_null_ill, label %loc_20EF, label %call_old_sigill

call_old_sigill:
  call void %old_sigill(i32 4)
  br label %ret_m1

sigill_set_ign:
  %ign_ptr3 = inttoptr i64 1 to void (i32)*
  %tmp_set3 = call void (i32)* @signal(i32 4, void (i32)* %ign_ptr3)
  br label %ret_m1

handle_segv:
  %old_segv = call void (i32)* @signal(i32 11, void (i32)* null)
  %old_segv_int = ptrtoint void (i32)* %old_segv to i64
  %is_ign_segv = icmp eq i64 %old_segv_int, 1
  br i1 %is_ign_segv, label %segv_set_ign, label %segv_check_old

segv_check_old:
  %is_null_segv = icmp eq void (i32)* %old_segv, null
  br i1 %is_null_segv, label %loc_20EF, label %call_old_segv

call_old_segv:
  call void %old_segv(i32 11)
  br label %ret_m1

segv_set_ign:
  %ign_ptr4 = inttoptr i64 1 to void (i32)*
  %tmp_set4 = call void (i32)* @signal(i32 11, void (i32)* %ign_ptr4)
  br label %ret_m1

loc_20EF:
  %h = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %is_null_h = icmp eq i32 (i8**)* %h, null
  br i1 %is_null_h, label %loc_2140, label %tailcall_handler

tailcall_handler:
  %ret = call i32 %h(i8** %ctx)
  ret i32 %ret

loc_2140:
  ret i32 0
}
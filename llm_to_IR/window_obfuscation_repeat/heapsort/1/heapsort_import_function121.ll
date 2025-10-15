; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = dso_local global i8* null, align 8
@dword_1400070E8 = dso_local global i32 0, align 4
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

define dso_local i32 @sub_1400023D0(i8* %hinst, i32 %reason, i8* %reserved) {
entry:
  %cmp_is2 = icmp eq i32 %reason, 2
  br i1 %cmp_is2, label %thread_attach, label %not2

thread_attach:                                      ; reason == 2
  call void @sub_1400024E0()
  br label %ret1

not2:
  %ugt2 = icmp ugt i32 %reason, 2
  br i1 %ugt2, label %gt2, label %le2

gt2:                                                ; reason > 2
  %is3 = icmp eq i32 %reason, 3
  br i1 %is3, label %thread_detach, label %ret1

thread_detach:                                      ; reason == 3
  %g_td = load i32, i32* @dword_1400070E8, align 4
  %g_td_nz = icmp ne i32 %g_td, 0
  br i1 %g_td_nz, label %call_2240_td, label %ret1

call_2240_td:
  call void @sub_140002240()
  br label %ret1

le2:                                                ; reason <= 2
  %is_zero = icmp eq i32 %reason, 0
  br i1 %is_zero, label %proc_detach, label %proc_attach

proc_attach:                                        ; reason == 1
  %g_pa = load i32, i32* @dword_1400070E8, align 4
  %g_pa_z = icmp eq i32 %g_pa, 0
  br i1 %g_pa_z, label %init_block, label %set1_and_ret

init_block:
  %p_ib = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  %call_init = call i32 @sub_1400E06D5(i8* %p_ib)
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

set1_and_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

proc_detach:                                        ; reason == 0
  %g_pd = load i32, i32* @dword_1400070E8, align 4
  %g_pd_nz = icmp ne i32 %g_pd, 0
  br i1 %g_pd_nz, label %call_2240_pd, label %after_pre_cleanup

call_2240_pd:
  call void @sub_140002240()
  br label %after_pre_cleanup

after_pre_cleanup:
  %g_chk = load i32, i32* @dword_1400070E8, align 4
  %g_is1 = icmp eq i32 %g_chk, 1
  br i1 %g_is1, label %do_cleanup_loop, label %ret1

do_cleanup_loop:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %after_loop, label %loop

loop:
  %node = phi i8* [ %head, %do_cleanup_loop ], [ %next, %after_call_bb ]
  %next_addr_i8 = getelementptr i8, i8* %node, i64 16
  %next_ptrptr = bitcast i8* %next_addr_i8 to i8**
  %next = load i8*, i8** %next_ptrptr, align 8
  call void @sub_140002BB0(i8* %node)
  %more = icmp ne i8* %next, null
  br i1 %more, label %after_call_bb, label %after_loop

after_call_bb:
  br label %loop

after_loop:
  %p_al = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* %p_al)
  br label %ret1

ret1:
  ret i32 1
}

define dso_local void @sub_140002240() {
entry:
  ret void
}

define dso_local void @sub_140002BB0(i8* %p) {
entry:
  ret void
}

define dso_local void @sub_1403DDA29(i8* %p) {
entry:
  ret void
}

define dso_local i32 @sub_1400E06D5(i8* %p) {
entry:
  ret i32 0
}

define dso_local void @sub_1400024E0() {
entry:
  ret void
}
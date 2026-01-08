; ModuleID = 'sub_140002010.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8

@__imp_DeleteCriticalSection = external dllimport global void (i8*)*
@__imp_InitializeCriticalSection = external dllimport global void (i8*)*

declare void @sub_140001E80()
declare void @sub_140002120()
declare dllimport void @free(i8*)

define dso_local i32 @sub_140002010(i32 %edx) {
entry:
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %case2, label %after_eq2

after_eq2:
  %cmp_ugt_2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt_2, label %gt2, label %le2

case2:
  call void @sub_140002120()
  br label %ret1

gt2:
  %cmp_ne_3 = icmp ne i32 %edx, 3
  br i1 %cmp_ne_3, label %ret1, label %case3

case3:
  %g_load_c3 = load i32, i32* @dword_1400070E8, align 4
  %g_zero_c3 = icmp eq i32 %g_load_c3, 0
  br i1 %g_zero_c3, label %ret1, label %call_e80_c3

call_e80_c3:
  call void @sub_140001E80()
  br label %ret1

le2:
  %cmp_eq_0 = icmp eq i32 %edx, 0
  br i1 %cmp_eq_0, label %case0, label %case1

case1:
  %g_load_c1 = load i32, i32* @dword_1400070E8, align 4
  %g_zero_c1 = icmp eq i32 %g_load_c1, 0
  br i1 %g_zero_c1, label %init_cs, label %set_g1_ret

init_cs:
  %init_fp = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection, align 8
  call void %init_fp(i8* @CriticalSection)
  br label %set_g1_ret

set_g1_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

case0:
  %g_load_c0 = load i32, i32* @dword_1400070E8, align 4
  %g_nz_c0 = icmp ne i32 %g_load_c0, 0
  br i1 %g_nz_c0, label %call_e80_then_chk, label %chk_g_eq1

call_e80_then_chk:
  call void @sub_140001E80()
  br label %chk_g_eq1

chk_g_eq1:
  %g_load_chk = load i32, i32* @dword_1400070E8, align 4
  %g_is_one = icmp eq i32 %g_load_chk, 1
  br i1 %g_is_one, label %free_loop_entry, label %ret1

free_loop_entry:
  %blk0 = load i8*, i8** @Block, align 8
  %blk_is_null = icmp eq i8* %blk0, null
  br i1 %blk_is_null, label %after_free, label %free_loop

free_loop:
  %cur = phi i8* [ %blk0, %free_loop_entry ], [ %next, %free_loop_continue ]
  %next_gep = getelementptr inbounds i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %next_gep to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @free(i8* %cur)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %free_loop_continue, label %after_free

free_loop_continue:
  br label %free_loop

after_free:
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %del_fp = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection, align 8
  call void %del_fp(i8* @CriticalSection)
  br label %ret1

ret1:
  ret i32 1
}
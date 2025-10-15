; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = global i32 0, align 4
@Block = global i8* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

declare dllimport void @free(i8*)
declare dllimport void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i8* %hinstDLL, i32 %fdwReason, i8* %lpReserved) {
entry:
  %cmp_edx_2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_edx_2, label %case_thread_attach, label %after_cmp_2

after_cmp_2:                                       ; edx != 2
  %ugt2 = icmp ugt i32 %fdwReason, 2
  br i1 %ugt2, label %loc_408, label %loc_3DF

loc_3DF:                                           ; edx == 0 or 1
  %is_zero = icmp eq i32 %fdwReason, 0
  br i1 %is_zero, label %loc_420, label %loc_3E3

loc_3E3:                                           ; edx == 1
  %flag_load_1 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero_1 = icmp eq i32 %flag_load_1, 0
  br i1 %flag_is_zero_1, label %loc_4C0, label %loc_3F1

loc_3F1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_408:                                           ; edx > 2
  %is_three = icmp eq i32 %fdwReason, 3
  br i1 %is_three, label %loc_40D, label %ret1

loc_40D:                                           ; edx == 3
  %flag_load_2 = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero_2 = icmp eq i32 %flag_load_2, 0
  br i1 %flag_is_zero_2, label %ret1, label %call_2240

call_2240:
  call void @sub_140002240()
  br label %ret1

loc_420:                                           ; edx == 0
  %flag_load_3 = load i32, i32* @dword_1400070E8, align 4
  %flag_ne_zero_3 = icmp ne i32 %flag_load_3, 0
  br i1 %flag_ne_zero_3, label %loc_4B0, label %loc_42E

loc_4B0:
  call void @sub_140002240()
  br label %loc_42E

loc_42E:
  %flag_load_4 = load i32, i32* @dword_1400070E8, align 4
  %flag_ne_one = icmp ne i32 %flag_load_4, 1
  br i1 %flag_ne_one, label %ret1, label %cleanup

cleanup:
  %blk0 = load i8*, i8** @Block, align 8
  br label %loop_head

loop_head:
  %curr = phi i8* [ %blk0, %cleanup ], [ %next2, %loop_body ]
  %isnull_curr = icmp eq i8* %curr, null
  br i1 %isnull_curr, label %loc_46B, label %loop_body

loop_body:
  %next_gep2 = getelementptr i8, i8* %curr, i64 16
  %next_ptrptr2 = bitcast i8* %next_gep2 to i8**
  %next2 = load i8*, i8** %next_ptrptr2, align 8
  call void @free(i8* %curr)
  br label %loop_head

loc_46B:
  %cs_ptr_i8 = getelementptr [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  %cs_ptr = bitcast i8* %cs_ptr_i8 to %struct._RTL_CRITICAL_SECTION*
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(%struct._RTL_CRITICAL_SECTION* %cs_ptr)
  br label %ret1

case_thread_attach:
  call void @sub_1400024E0()
  br label %ret1

loc_4C0:
  %cs_ptr_i8_init = getelementptr [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  %cs_ptr_init = bitcast i8* %cs_ptr_i8_init to %struct._RTL_CRITICAL_SECTION*
  call void @InitializeCriticalSection(%struct._RTL_CRITICAL_SECTION* %cs_ptr_init)
  br label %loc_3F1

ret1:
  ret i32 1
}
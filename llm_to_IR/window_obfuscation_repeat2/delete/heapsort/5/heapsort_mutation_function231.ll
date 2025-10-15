; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i8*, i8*, %struct.Block* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Block* null, align 8
@CriticalSection = global [40 x i8] zeroinitializer, align 8

@__imp_DeleteCriticalSection = external dllimport global void (i8*)*, align 8
@__imp_InitializeCriticalSection = external dllimport global void (i8*)*, align 8

declare void @free(i8*)
declare void @sub_140002240()
declare void @sub_1400024E0()

define i32 @sub_1400023D0(i32 %arg1, i32 %arg2) {
entry:
  %cmp_eq2 = icmp eq i32 %arg2, 2
  br i1 %cmp_eq2, label %loc_2498, label %after_cmp2

after_cmp2:                                       ; preds = %entry
  %cmp_above = icmp ugt i32 %arg2, 2
  br i1 %cmp_above, label %loc_2408, label %loc_23DF

loc_23DF:                                         ; preds = %after_cmp2
  %is_zero = icmp eq i32 %arg2, 0
  br i1 %is_zero, label %loc_2420, label %loc_23E3

loc_23E3:                                         ; preds = %loc_23DF
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1t = icmp eq i32 %g1, 0
  br i1 %g1t, label %loc_24C0, label %loc_23F1

loc_23F1:                                         ; preds = %loc_24C0, %loc_23E3
  store i32 1, i32* @dword_1400070E8, align 4
  br label %loc_23FB

loc_23FB:                                         ; preds = %loc_2417, %loc_240D, %loc_242E, %loc_246B, %loc_2408, %loc_23F1
  ret i32 1

loc_2408:                                         ; preds = %after_cmp2
  %cmp3 = icmp ne i32 %arg2, 3
  br i1 %cmp3, label %loc_23FB, label %loc_240D

loc_240D:                                         ; preds = %loc_2408
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2z = icmp eq i32 %g2, 0
  br i1 %g2z, label %loc_23FB, label %loc_2417

loc_2417:                                         ; preds = %loc_240D
  call void @sub_140002240()
  br label %loc_23FB

loc_2420:                                         ; preds = %loc_23DF
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nz = icmp ne i32 %g3, 0
  br i1 %g3nz, label %loc_24B0, label %loc_242E

loc_242E:                                         ; preds = %loc_24B0, %loc_2420
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp ne i32 %g4, 1
  br i1 %is1, label %loc_23FB, label %loc_2439

loc_2439:                                         ; preds = %loc_242E
  %cur = load %struct.Block*, %struct.Block** @Block, align 8
  %cur_is_null = icmp eq %struct.Block* %cur, null
  br i1 %cur_is_null, label %loc_246B, label %loc_2450

loc_2450:                                         ; preds = %loc_2450, %loc_2439
  %cur_phi = phi %struct.Block* [ %cur, %loc_2439 ], [ %next_val, %loc_2450 ]
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur_phi, i64 0, i32 2
  %next_val = load %struct.Block*, %struct.Block** %nextptr, align 8
  %cur_i8 = bitcast %struct.Block* %cur_phi to i8*
  call void @free(i8* %cur_i8)
  %has_next = icmp ne %struct.Block* %next_val, null
  br i1 %has_next, label %loc_2450, label %loc_246B

loc_246B:                                         ; preds = %loc_2450, %loc_2439
  %cs_ptr = getelementptr [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  store %struct.Block* null, %struct.Block** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %pf_del = load void (i8*)*, void (i8*)** @__imp_DeleteCriticalSection, align 8
  call void %pf_del(i8* %cs_ptr)
  br label %loc_23FB

loc_2498:                                         ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

loc_24B0:                                         ; preds = %loc_2420
  call void @sub_140002240()
  br label %loc_242E

loc_24C0:                                         ; preds = %loc_23E3
  %cs_ptr2 = getelementptr [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  %pf_init = load void (i8*)*, void (i8*)** @__imp_InitializeCriticalSection, align 8
  call void %pf_init(i8* %cs_ptr2)
  br label %loc_23F1
}
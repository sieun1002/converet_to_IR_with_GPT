; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = dso_local global i8* null, align 8
@dword_1400070E8 = dso_local global i32 0, align 4
@unk_140007100 = external dso_local global i8

declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()
declare dso_local void @sub_140002BB0(i8* noundef)
declare dso_local void @sub_1403DDA29(i8* noundef)
declare dso_local i32 @sub_1400E06D5(i8* noundef)

define dso_local i32 @sub_1400023D0(i8* noundef %hinstDLL, i32 noundef %fdwReason, i8* noundef %lpvReserved) local_unnamed_addr {
entry:
  %cmp_edx_2 = icmp eq i32 %fdwReason, 2
  br i1 %cmp_edx_2, label %case_2, label %not2

case_2:                                           ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

not2:
  %gt2 = icmp ugt i32 %fdwReason, 2
  br i1 %gt2, label %gt2_block, label %le2_block

le2_block:                                        ; edx <= 2
  %is_zero = icmp eq i32 %fdwReason, 0
  br i1 %is_zero, label %loc_420, label %case_1

case_1:                                           ; edx == 1
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %loc_4C0, label %set_and_return

set_and_return:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

gt2_block:                                        ; edx > 2
  %is3 = icmp eq i32 %fdwReason, 3
  br i1 %is3, label %case_3, label %ret_true

ret_true:
  ret i32 1

case_3:                                           ; edx == 3
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_is_zero = icmp eq i32 %g2, 0
  br i1 %g2_is_zero, label %ret_true2, label %call_2240_then_420

ret_true2:
  ret i32 1

call_2240_then_420:
  call void @sub_140002240()
  br label %loc_420

loc_420:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nonzero = icmp ne i32 %g3, 0
  br i1 %g3_nonzero, label %loc_4B0, label %loc_42E

loc_4B0:
  call void @sub_140002240()
  br label %loc_4C0

loc_42E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_ne1 = icmp ne i32 %g4, 1
  br i1 %g4_ne1, label %ret_true3, label %loc_439

ret_true3:
  ret i32 1

loc_439:
  %head0 = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head0, null
  br i1 %head_is_null, label %after_loop, label %loop

loop:
  %curr = phi i8* [ %head0, %loc_439 ], [ %next, %loop_cont ]
  %next_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @sub_140002BB0(i8* %curr)
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %loop_cont, label %after_loop

loop_cont:
  br label %loop

after_loop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* @unk_140007100)
  ret i32 1

loc_4C0:
  %ret_i32 = call i32 @sub_1400E06D5(i8* @unk_140007100)
  %subval = sub i32 %ret_i32, 4294830857
  %zext = zext i32 %subval to i64
  %addr = sub i64 %zext, 1877990768
  %mem_ptr = inttoptr i64 %addr to i8**
  %fnptr_i8 = load i8*, i8** %mem_ptr, align 8
  %fnptr = bitcast i8* %fnptr_i8 to void ()*
  call void %fnptr()
  unreachable
}
; Target: Windows x86_64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = dso_local global i32 0, align 4
@qword_1400070E0 = dso_local global i8* null, align 8
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()
declare dso_local void @sub_140002BB0(i8* noundef)
declare dso_local void @sub_1403DDA29(i8* noundef)
declare dso_local i32 @sub_1400E06D5(i8* noundef)

define dso_local i32 @sub_1400023D0(i8* noundef %arg0, i32 noundef %arg1, i8* noundef %arg2) local_unnamed_addr {
entry:
  %cmp_eq2 = icmp eq i32 %arg1, 2
  br i1 %cmp_eq2, label %case2, label %check_gt2

check_gt2:
  %cmp_gt2 = icmp ugt i32 %arg1, 2
  br i1 %cmp_gt2, label %ge3, label %le2

le2:
  %cmp_eq0 = icmp eq i32 %arg1, 0
  br i1 %cmp_eq0, label %L420_entry, label %case1

case1:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_is_zero = icmp eq i32 %g1, 0
  br i1 %g1_is_zero, label %L4C0, label %set1_return

set1_return:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

ge3:
  %cmp_eq3 = icmp eq i32 %arg1, 3
  br i1 %cmp_eq3, label %case3, label %ret1

case3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_is_zero = icmp eq i32 %g3, 0
  br i1 %g3_is_zero, label %ret1, label %call_240_then_L420

call_240_then_L420:
  call void @sub_140002240()
  br label %L420_entry

L420_entry:
  %g420 = load i32, i32* @dword_1400070E8, align 4
  %g420_nz = icmp ne i32 %g420, 0
  br i1 %g420_nz, label %call_240_maybe, label %after_maybe

call_240_maybe:
  call void @sub_140002240()
  br label %after_maybe

after_maybe:
  %g_after = load i32, i32* @dword_1400070E8, align 4
  %g_is_one = icmp eq i32 %g_after, 1
  br i1 %g_is_one, label %loop_prep, label %ret1

loop_prep:
  %head = load i8*, i8** @qword_1400070E0, align 8
  br label %loop_check

loop_check:
  %node = phi i8* [ %head, %loop_prep ], [ %next, %loop_body ]
  %has_node = icmp ne i8* %node, null
  br i1 %has_node, label %loop_body, label %cleanup

loop_body:
  %node_as_i8 = bitcast i8* %node to i8*
  %next_ptr_i8 = getelementptr i8, i8* %node_as_i8, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  call void @sub_140002BB0(i8* noundef %node)
  br label %loop_check

cleanup:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %p100 = bitcast [1 x i8]* @unk_140007100 to i8*
  call void @sub_1403DDA29(i8* noundef %p100)
  br label %ret1

case2:
  call void @sub_1400024E0()
  br label %ret1

L4C0:
  %p100b = bitcast [1 x i8]* @unk_140007100 to i8*
  %eax = call i32 @sub_1400E06D5(i8* noundef %p100b)
  %eax_add = add i32 %eax, 57367
  %rax64 = zext i32 %eax_add to i64
  %addr_adj = sub i64 %rax64, 1869573232
  %mem_ptr = inttoptr i64 %addr_adj to i8**
  %fn_ptr_i8 = load i8*, i8** %mem_ptr, align 8
  %fn = bitcast i8* %fn_ptr_i8 to void ()*
  call void %fn()
  unreachable

ret1:
  ret i32 1
}
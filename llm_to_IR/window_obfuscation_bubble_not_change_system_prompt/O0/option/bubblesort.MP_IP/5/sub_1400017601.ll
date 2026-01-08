; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140612B3A(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %arg) {
entry:
  %var48 = alloca [48 x i8], align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %cond_le = icmp sle i32 %count32, 0
  br i1 %cond_le, label %not_found_zero, label %loop_init

loop_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  br label %loop

loop:
  %i = phi i32 [ 0, %loop_init ], [ %i.next, %loop_inc ]
  %i64 = sext i32 %i to i64
  %mul40 = mul nsw i64 %i64, 40
  %off = add i64 %mul40, 24
  %entryPtr = getelementptr inbounds i8, i8* %base0, i64 %off
  %entryPtr_ptr = bitcast i8* %entryPtr to i8**
  %start = load i8*, i8** %entryPtr_ptr, align 8
  %rbx_int = ptrtoint i8* %arg to i64
  %start_int = ptrtoint i8* %start to i64
  %cmp1 = icmp ult i64 %rbx_int, %start_int
  br i1 %cmp1, label %loop_inc, label %check_second

check_second:
  %entry_plus8 = getelementptr inbounds i8, i8* %entryPtr, i64 8
  %p_ptr = bitcast i8* %entry_plus8 to i8**
  %p = load i8*, i8** %p_ptr, align 8
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %len32_ptr = bitcast i8* %p_plus8 to i32*
  %len32 = load i32, i32* %len32_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %cmp2 = icmp ult i64 %rbx_int, %end_int
  br i1 %cmp2, label %ret_void, label %loop_inc

loop_inc:
  %i.next = add i32 %i, 1
  %cont = icmp ne i32 %i.next, %count32
  br i1 %cont, label %loop, label %not_found

not_found:
  br label %call_query

not_found_zero:
  br label %call_query

call_query:
  %idxPhi = phi i32 [ %count32, %not_found ], [ 0, %not_found_zero ]
  %res = call i8* @sub_140002250(i8* %arg)
  %isnull = icmp eq i8* %res, null
  br i1 %isnull, label %error, label %have_res

error:
  %str = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %str, i8* %arg)
  br label %ret_void

have_res:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idxPhi to i64
  %mul5 = mul nsw i64 %idx64, 5
  %offset = shl i64 %mul5, 3
  %entry0 = getelementptr inbounds i8, i8* %base1, i64 %offset
  %field20 = getelementptr inbounds i8, i8* %entry0, i64 32
  %field20_ptr = bitcast i8* %field20 to i8**
  store i8* %res, i8** %field20_ptr, align 8
  %field0_ptr = bitcast i8* %entry0 to i32*
  store i32 0, i32* %field0_ptr, align 4
  %buf = call i8* @sub_140002390()
  %res_plus12 = getelementptr inbounds i8, i8* %res, i64 12
  %len2_ptr = bitcast i8* %res_plus12 to i32*
  %len2 = load i32, i32* %len2_ptr, align 4
  %len2_64 = zext i32 %len2 to i64
  %rcx_val = getelementptr inbounds i8, i8* %buf, i64 %len2_64
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entryA = getelementptr inbounds i8, i8* %base2, i64 %offset
  %field18 = getelementptr inbounds i8, i8* %entryA, i64 24
  %field18_ptr = bitcast i8* %field18 to i8**
  store i8* %rcx_val, i8** %field18_ptr, align 8
  %var48ptr = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_140612B3A(i8* %rcx_val, i8* %var48ptr, i32 48)
  br label %ret_void

ret_void:
  ret void
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@aVirtualprotect = external dso_local global i8
@aVirtualqueryFa = external dso_local global i8
@aAddressPHasNoI = external dso_local global i8

declare dso_local i8* @sub_140002250(i8* %rcx)
declare dso_local i8* @sub_140002390()
declare dso_local i32 @loc_140012A4E(i8* %rcx, i8* %rdx, i32 %r8d)
declare dso_local i32 @loc_1400D1740(i8* %rcx, i8* %rdx, i32 %r8d, i8* %r9)
declare dso_local void @sub_140001700(i8* %rcx, ...)

define dso_local void @sub_140001760(i8* %rcx) {
entry:
  %arg = bitcast i8* %rcx to i8*
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %count64 = sext i32 %count32 to i64
  %cmp_le = icmp sle i32 %count32, 0
  br i1 %cmp_le, label %callResolver, label %loop_setup

loop_setup:
  %base0_ptr = load i8*, i8** @qword_1400070A8, align 8
  %p0 = getelementptr inbounds i8, i8* %base0_ptr, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop_setup ], [ %i.next, %loop_inc ]
  %p = phi i8* [ %p0, %loop_setup ], [ %p.next, %loop_inc ]
  %start_pp = bitcast i8* %p to i8**
  %start_ptr = load i8*, i8** %start_pp, align 8
  %arg_int = ptrtoint i8* %arg to i64
  %start_int = ptrtoint i8* %start_ptr to i64
  %cmp_below = icmp ult i64 %arg_int, %start_int
  br i1 %cmp_below, label %loop_inc, label %check_end

check_end:
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %p_plus8_pp = bitcast i8* %p_plus8 to i8**
  %rdx_ptr = load i8*, i8** %p_plus8_pp, align 8
  %len_addr = getelementptr inbounds i8, i8* %rdx_ptr, i64 8
  %len32p = bitcast i8* %len_addr to i32*
  %len32 = load i32, i32* %len32p, align 4
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %cmp_in = icmp ult i64 %arg_int, %end_int
  br i1 %cmp_in, label %ret_void, label %loop_inc

loop_inc:
  %i.next = add i32 %i, 1
  %p.next = getelementptr inbounds i8, i8* %p, i64 40
  %cmp_cont = icmp ne i32 %i.next, %count32
  br i1 %cmp_cont, label %loop, label %callResolver

callResolver:
  %index64 = phi i64 [ 0, %entry ], [ %count64, %loop_inc ]
  %res = call i8* @sub_140002250(i8* %arg)
  %isnull = icmp eq i8* %res, null
  br i1 %isnull, label %err_no_image, label %have_image

have_image:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %mul5 = mul i64 %index64, 40
  %entry_ptr = getelementptr inbounds i8, i8* %base1, i64 %mul5
  %entry_p20 = getelementptr inbounds i8, i8* %entry_ptr, i64 32
  %entry_p20_pp = bitcast i8* %entry_p20 to i8**
  store i8* %res, i8** %entry_p20_pp, align 8
  %entry_p0_i32 = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_p0_i32, align 4
  %base_ret = call i8* @sub_140002390()
  %res_plus_c = getelementptr inbounds i8, i8* %res, i64 12
  %res_plus_c_i32p = bitcast i8* %res_plus_c to i32*
  %edx_val = load i32, i32* %res_plus_c_i32p, align 4
  %edx64 = zext i32 %edx_val to i64
  %rcx_ptr_calc = getelementptr inbounds i8, i8* %base_ret, i64 %edx64
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr inbounds i8, i8* %base2, i64 %mul5
  %entry_p18 = getelementptr inbounds i8, i8* %entry_ptr2, i64 24
  %entry_p18_pp = bitcast i8* %entry_p18 to i8**
  store i8* %rcx_ptr_calc, i8** %entry_p18_pp, align 8
  %buf = alloca [48 x i8], align 8
  %buf_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %callret = call i32 @loc_140012A4E(i8* %rcx_ptr_calc, i8* %buf_i8, i32 48)
  %buf_as_pp = bitcast i8* %buf_i8 to i8**
  %saved_rcx = load i8*, i8** %buf_as_pp, align 8
  %off18 = getelementptr inbounds i8, i8* %buf_i8, i64 24
  %off18_pp = bitcast i8* %off18 to i8**
  %saved_rdx = load i8*, i8** %off18_pp, align 8
  %cmp2 = icmp eq i32 %callret, 2
  %r8val = select i1 %cmp2, i32 4, i32 64
  %entry_p8 = getelementptr inbounds i8, i8* %entry_ptr2, i64 8
  %entry_p8_pp = bitcast i8* %entry_p8 to i8**
  store i8* %saved_rcx, i8** %entry_p8_pp, align 8
  %entry_p10 = getelementptr inbounds i8, i8* %entry_ptr2, i64 16
  %entry_p10_pp = bitcast i8* %entry_p10 to i8**
  store i8* %saved_rdx, i8** %entry_p10_pp, align 8
  %vpret = call i32 @loc_1400D1740(i8* %saved_rcx, i8* %saved_rdx, i32 %r8val, i8* %entry_ptr2)
  %vp_str_ptr = getelementptr inbounds i8, i8* @aVirtualprotect, i64 0
  call void (i8*, ...) @sub_140001700(i8* %vp_str_ptr, i32 %vpret)
  br label %ret_void

err_no_image:
  %str_noimg_ptr = getelementptr inbounds i8, i8* @aAddressPHasNoI, i64 0
  call void (i8*, ...) @sub_140001700(i8* %str_noimg_ptr, i8* %arg)
  br label %ret_void

ret_void:
  ret void
}
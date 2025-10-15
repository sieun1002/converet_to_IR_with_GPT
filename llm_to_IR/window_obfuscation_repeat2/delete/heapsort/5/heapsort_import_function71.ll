; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@qword_140008260 = external global i32 ()*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [1 x i8] c"\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(...)
declare i32 @loc_14000EEBA(...)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %0) {
entry:
  %buf = alloca [64 x i8], align 16
  %1 = load i32, i32* @dword_1400070A4, align 4
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %scan_setup, label %set_esi_zero

set_esi_zero:                                      ; preds = %virtprot_failed, %entry
  br label %alloc_start

scan_setup:                                        ; preds = %entry
  %3 = load i8*, i8** @qword_1400070A8, align 8
  %4 = getelementptr i8, i8* %3, i64 24
  br label %scan_loop

scan_loop:                                         ; preds = %not_match, %scan_setup
  %5 = phi i32 [ 0, %scan_setup ], [ %10, %not_match ]
  %6 = sext i32 %5 to i64
  %7 = mul i64 %6, 40
  %8 = getelementptr i8, i8* %4, i64 %7
  %9 = bitcast i8* %8 to i8**
  %seg_base = load i8*, i8** %9, align 8
  %addr_int = ptrtoint i8* %0 to i64
  %seg_base_int = ptrtoint i8* %seg_base to i64
  %cmp_lt = icmp ult i64 %addr_int, %seg_base_int
  br i1 %cmp_lt, label %not_match, label %check_within

check_within:                                      ; preds = %scan_loop
  %10ptr = getelementptr i8, i8* %8, i64 8
  %11 = bitcast i8* %10ptr to i8**
  %rdx_ptr = load i8*, i8** %11, align 8
  %12 = getelementptr i8, i8* %rdx_ptr, i64 8
  %13 = bitcast i8* %12 to i32*
  %len32 = load i32, i32* %13, align 4
  %len64 = zext i32 %len32 to i64
  %seg_end_int = add i64 %seg_base_int, %len64
  %in_range = icmp ult i64 %addr_int, %seg_end_int
  br i1 %in_range, label %ret_epilogue, label %not_match

not_match:                                         ; preds = %check_within, %scan_loop
  %10 = add i32 %5, 1
  %11cmp = icmp ne i32 %10, %1
  br i1 %11cmp, label %scan_loop, label %alloc_start

ret_epilogue:                                      ; preds = %check_within
  ret void

alloc_start:                                       ; preds = %not_match, %set_esi_zero
  %index = phi i32 [ 0, %set_esi_zero ], [ %1, %not_match ]
  %res = call i8* @sub_140002610(i8* %0)
  %rdi = ptrtoint i8* %res to i64
  %isnull = icmp eq i8* %res, null
  br i1 %isnull, label %no_image_sec, label %have_image

have_image:                                        ; preds = %alloc_start
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %index to i64
  %entry_off = mul i64 %idx64, 40
  %entry_ptr = getelementptr i8, i8* %base1, i64 %entry_off
  %entry_plus20 = getelementptr i8, i8* %entry_ptr, i64 32
  %entry_plus20_pp = bitcast i8* %entry_plus20 to i8**
  store i8* %res, i8** %entry_plus20_pp, align 8
  %entry_i32 = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_i32, align 4
  %base2 = call i8* @sub_140002750()
  %res_plus0C = getelementptr i8, i8* %res, i64 12
  %edxptr = bitcast i8* %res_plus0C to i32*
  %edx = load i32, i32* %edxptr, align 4
  %edx64b = zext i32 %edx to i64
  %rcxptr = getelementptr i8, i8* %base2, i64 %edx64b
  %base2a = load i8*, i8** @qword_1400070A8, align 8
  %entry_at_base2 = getelementptr i8, i8* %base2a, i64 %entry_off
  %entry_plus18 = getelementptr i8, i8* %entry_at_base2, i64 24
  %entry_plus18_pp = bitcast i8* %entry_plus18 to i8**
  store i8* %rcxptr, i8** %entry_plus18_pp, align 8
  %bufp = getelementptr [64 x i8], [64 x i8]* %buf, i64 0, i64 0
  %call1 = call i64 (...) @sub_14001FAD3(i8* %rcxptr, i8* %bufp, i32 48, i64 %entry_off)
  %iszero = icmp eq i64 %call1, 0
  br i1 %iszero, label %virtquery_failed, label %after_query

after_query:                                       ; preds = %have_image
  %buf_plus1C = getelementptr i8, i8* %bufp, i64 28
  %buf_plus1C_i32 = bitcast i8* %buf_plus1C to i32*
  %eax = load i32, i32* %buf_plus1C_i32, align 4
  %sub4 = add i32 %eax, -4
  %and1 = and i32 %sub4, 4294967291
  %iszero2 = icmp eq i32 %and1, 0
  br i1 %iszero2, label %inc_and_return, label %check2

check2:                                            ; preds = %after_query
  %sub64 = add i32 %eax, -64
  %and2 = and i32 %sub64, 4294967231
  %cond = icmp ne i32 %and2, 0
  br i1 %cond, label %loc_1C10, label %inc_and_return

inc_and_return:                                    ; preds = %check2, %after_query
  %oc = load i32, i32* @dword_1400070A4, align 4
  %nc = add i32 %oc, 1
  store i32 %nc, i32* @dword_1400070A4, align 4
  ret void

loc_1C10:                                          ; preds = %check2
  %cmp2 = icmp eq i32 %eax, 2
  %r8d = select i1 %cmp2, i32 4, i32 64
  %buf_as_pp = bitcast i8* %bufp to i8**
  %rcx_from_buf = load i8*, i8** %buf_as_pp, align 8
  %buf_plus10 = getelementptr i8, i8* %bufp, i64 16
  %buf_plus10_pp = bitcast i8* %buf_plus10 to i8**
  %rdx_from_buf = load i8*, i8** %buf_plus10_pp, align 8
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_at_base3 = getelementptr i8, i8* %base3, i64 %entry_off
  %entry_plus8 = getelementptr i8, i8* %entry_at_base3, i64 8
  %entry_plus8_pp = bitcast i8* %entry_plus8 to i8**
  store i8* %rcx_from_buf, i8** %entry_plus8_pp, align 8
  %entry_plus10 = getelementptr i8, i8* %entry_at_base3, i64 16
  %entry_plus10_pp = bitcast i8* %entry_plus10 to i8**
  store i8* %rdx_from_buf, i8** %entry_plus10_pp, align 8
  %call2 = call i32 (...) @loc_14000EEBA(i8* %rcx_from_buf, i8* %rdx_from_buf, i32 %r8d, i8* %entry_at_base3, i8* %rcx_from_buf)
  %nz = icmp ne i32 %call2, 0
  br i1 %nz, label %inc_and_return, label %virtprot_failed

virtprot_failed:                                   ; preds = %loc_1C10
  %fp = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %fp()
  %vpstr = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %vpstr, i32 %err)
  br label %set_esi_zero

virtquery_failed:                                  ; preds = %have_image
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %res_plus8 = getelementptr i8, i8* %res, i64 8
  %edx2ptr = bitcast i8* %res_plus8 to i32*
  %edx2 = load i32, i32* %edx2ptr, align 4
  %entry_at_base4 = getelementptr i8, i8* %base4, i64 %entry_off
  %entry_plus18_b4 = getelementptr i8, i8* %entry_at_base4, i64 24
  %entry_plus18_pp_b4 = bitcast i8* %entry_plus18_b4 to i8**
  %r8arg = load i8*, i8** %entry_plus18_pp_b4, align 8
  %vqstr = getelementptr [1 x i8], [1 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %vqstr, i32 %edx2, i8* %r8arg)
  br label %no_image_sec

no_image_sec:                                      ; preds = %virtquery_failed, %alloc_start
  %addrstr = getelementptr [1 x i8], [1 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %addrstr, i8* %0)
  ret void
}
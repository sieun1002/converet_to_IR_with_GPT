; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@qword_140008298 = external global i64 (i8*, i8*, i64)*
@qword_140008290 = external global i32 (i8*, i64, i32, i8*)*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = external constant i8
@aVirtualqueryFa = external constant i8
@aAddressPHasNoI = external constant i8

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %rcx) {
entry:
  %buf = alloca [56 x i8], align 8
  %arg = ptrtoint i8* %rcx to i64
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_le_zero = icmp sle i32 %cnt, 0
  br i1 %cnt_le_zero, label %create_new_from_empty, label %scan_init

scan_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %arr_start = getelementptr inbounds i8, i8* %base0, i64 24
  br label %scan_loop

scan_loop:
  %idx = phi i32 [ 0, %scan_init ], [ %idx.next, %scan_next ]
  %cur_off64 = sext i32 %idx to i64
  %cur_ptr = getelementptr inbounds i8, i8* %arr_start, i64 mul (i64 %cur_off64, i64 40)
  %cur_ptr_p = bitcast i8* %cur_ptr to i8**
  %entry_base_addr = load i8*, i8** %cur_ptr_p, align 8
  %entry_base_int = ptrtoint i8* %entry_base_addr to i64
  %arg_lt_base = icmp ult i64 %arg, %entry_base_int
  br i1 %arg_lt_base, label %scan_next, label %check_range

check_range:
  %cur_plus8 = getelementptr inbounds i8, i8* %cur_ptr, i64 8
  %cur_plus8_p = bitcast i8* %cur_plus8 to i8**
  %rdxptr = load i8*, i8** %cur_plus8_p, align 8
  %rdxptr_plus8 = getelementptr inbounds i8, i8* %rdxptr, i64 8
  %rdxptr_plus8_i32p = bitcast i8* %rdxptr_plus8 to i32*
  %size_i32 = load i32, i32* %rdxptr_plus8_i32p, align 4
  %size_i64 = zext i32 %size_i32 to i64
  %end_addr = add i64 %entry_base_int, %size_i64
  %arg_in_range = icmp ult i64 %arg, %end_addr
  br i1 %arg_in_range, label %ret_epilogue, label %scan_next

scan_next:
  %idx.next = add i32 %idx, 1
  %cont = icmp ne i32 %idx.next, %cnt
  br i1 %cont, label %scan_loop, label %create_new

create_new_from_empty:
  br label %create_new

create_new:
  %cnt_sel = phi i32 [ 0, %create_new_from_empty ], [ %cnt, %scan_next ]
  %new_ctx = call i8* @sub_140002250(i8* %rcx)
  %new_ctx_isnull = icmp eq i8* %new_ctx, null
  br i1 %new_ctx_isnull, label %log_no_image, label %after_alloc

after_alloc:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %cnt64 = sext i32 %cnt_sel to i64
  %entry_off = mul i64 %cnt64, 40
  %entry_ptr = getelementptr inbounds i8, i8* %base1, i64 %entry_off
  %entry_plus32 = getelementptr inbounds i8, i8* %entry_ptr, i64 32
  %entry_plus32_p = bitcast i8* %entry_plus32 to i8**
  store i8* %new_ctx, i8** %entry_plus32_p, align 8
  %entry_i32p = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_i32p, align 4
  %tmp = call i8* @sub_140002390()
  %new_ctx_plus12 = getelementptr inbounds i8, i8* %new_ctx, i64 12
  %prot_i32p = bitcast i8* %new_ctx_plus12 to i32*
  %prot_val = load i32, i32* %prot_i32p, align 4
  %prot_zext = zext i32 %prot_val to i64
  %addr_for_vq = getelementptr inbounds i8, i8* %tmp, i64 %prot_zext
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr inbounds i8, i8* %base2, i64 %entry_off
  %entry_plus24 = getelementptr inbounds i8, i8* %entry_ptr2, i64 24
  %entry_plus24_p = bitcast i8* %entry_plus24 to i8**
  store i8* %addr_for_vq, i8** %entry_plus24_p, align 8
  %bufptr = getelementptr inbounds [56 x i8], [56 x i8]* %buf, i64 0, i64 0
  %fpVQptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298, align 8
  %vqret = call i64 %fpVQptr(i8* %addr_for_vq, i8* %bufptr, i64 48)
  %vq_fail = icmp eq i64 %vqret, 0
  br i1 %vq_fail, label %vq_failed, label %vq_succeeded

vq_succeeded:
  %prot_read_ptr = getelementptr inbounds i8, i8* %bufptr, i64 36
  %prot_read_i32p = bitcast i8* %prot_read_ptr to i32*
  %prot_read = load i32, i32* %prot_read_i32p, align 4
  %t1 = sub i32 %prot_read, 4
  %t1and = and i32 %t1, -5
  %cond1 = icmp eq i32 %t1and, 0
  br i1 %cond1, label %inc_count, label %vp_check2

vp_check2:
  %t2 = sub i32 %prot_read, 64
  %t2and = and i32 %t2, -65
  %t2nz = icmp ne i32 %t2and, 0
  br i1 %t2nz, label %do_virtualprotect, label %inc_count

inc_count:
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  br label %ret_epilogue

do_virtualprotect:
  %base_addr_ptr = bitcast i8* %bufptr to i8**
  %vp_addr = load i8*, i8** %base_addr_ptr, align 8
  %size_ptr = getelementptr inbounds i8, i8* %bufptr, i64 24
  %size_i64p = bitcast i8* %size_ptr to i64*
  %vp_size = load i64, i64* %size_i64p, align 8
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr3 = getelementptr inbounds i8, i8* %base3, i64 %entry_off
  %entry_plus8 = getelementptr inbounds i8, i8* %entry_ptr3, i64 8
  %entry_plus8_p = bitcast i8* %entry_plus8 to i8**
  store i8* %vp_addr, i8** %entry_plus8_p, align 8
  %entry_plus16 = getelementptr inbounds i8, i8* %entry_ptr3, i64 16
  %entry_plus16_p = bitcast i8* %entry_plus16 to i64*
  store i64 %vp_size, i64* %entry_plus16_p, align 8
  %r8_default = i32 64
  %is2 = icmp eq i32 %prot_read, 2
  %r8_sel = select i1 %is2, i32 4, i32 %r8_default
  %fpVPptr = load i32 (i8*, i64, i32, i8*)*, i32 (i8*, i64, i32, i8*)** @qword_140008290, align 8
  %vp_res = call i32 %fpVPptr(i8* %vp_addr, i64 %vp_size, i32 %r8_sel, i8* %entry_ptr3)
  %vp_ok = icmp ne i32 %vp_res, 0
  br i1 %vp_ok, label %inc_count, label %vp_fail_log

vp_fail_log:
  %fpGLE = load i32 ()*, i32 ()** @qword_140008260, align 8
  %gle = call i32 %fpGLE()
  %fmt_vp = bitcast i8* @aVirtualprotect to i8*
  call void @sub_140001700(i8* %fmt_vp, i32 %gle)
  br label %ret_epilogue

vq_failed:
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %new_ctx_plus8 = getelementptr inbounds i8, i8* %new_ctx, i64 8
  %bytes_i32p = bitcast i8* %new_ctx_plus8 to i32*
  %bytes = load i32, i32* %bytes_i32p, align 4
  %entry_ptr4 = getelementptr inbounds i8, i8* %base4, i64 %entry_off
  %entry_plus24b = getelementptr inbounds i8, i8* %entry_ptr4, i64 24
  %entry_plus24b_p = bitcast i8* %entry_plus24b to i8**
  %addr_arg = load i8*, i8** %entry_plus24b_p, align 8
  %fmt_vq = bitcast i8* @aVirtualqueryFa to i8*
  call void @sub_140001700(i8* %fmt_vq, i32 %bytes, i8* %addr_arg)
  br label %log_no_image

log_no_image:
  %fmt_noimg = bitcast i8* @aAddressPHasNoI to i8*
  call void @sub_140001700(i8* %fmt_noimg, i8* %rcx)
  br label %ret_epilogue

ret_epilogue:
  ret void
}
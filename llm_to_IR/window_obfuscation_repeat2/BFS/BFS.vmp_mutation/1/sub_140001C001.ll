; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@.str_vprotect = private unnamed_addr constant [40 x i8] c"  VirtualProtect failed with code 0x%x\00"
@.str_vquery = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@.str_noimage = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_1400026F0(i8*)
declare i8* @sub_140002830()
declare void @sub_140001BA0(i8*, ...)
declare i32 @VirtualQuery(i8*, i8*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()

define void @sub_140001C00(i8* %addr) {
entry:
  %buf = alloca [48 x i8], align 16
  %count = load i32, i32* @dword_1400070A4, align 4
  %count_le_zero = icmp sle i32 %count, 0
  br i1 %count_le_zero, label %set_esi_zero, label %have_count

set_esi_zero:                                      ; preds = %entry
  br label %after_init

have_count:                                        ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %arrStart = getelementptr i8, i8* %base0, i64 24
  br label %loop_header

loop_header:                                       ; preds = %loop_next, %have_count
  %idx = phi i32 [ 0, %have_count ], [ %idx_next, %loop_next ]
  %idx64 = sext i32 %idx to i64
  %offset = mul i64 %idx64, 40
  %entryPtr = getelementptr i8, i8* %arrStart, i64 %offset
  %startPtr_ptr = bitcast i8* %entryPtr to i8**
  %startPtr = load i8*, i8** %startPtr_ptr, align 8
  %addr_lt_start = icmp ult i8* %addr, %startPtr
  br i1 %addr_lt_start, label %loop_next, label %check_end

check_end:                                         ; preds = %loop_header
  %p2_ptr_i8 = getelementptr i8, i8* %entryPtr, i64 8
  %p2_ptr = bitcast i8* %p2_ptr_i8 to i8**
  %p2 = load i8*, i8** %p2_ptr, align 8
  %p2_plus8 = getelementptr i8, i8* %p2, i64 8
  %len32_ptr = bitcast i8* %p2_plus8 to i32*
  %len32 = load i32, i32* %len32_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %endPtr = getelementptr i8, i8* %startPtr, i64 %len64
  %addr_lt_end = icmp ult i8* %addr, %endPtr
  br i1 %addr_lt_end, label %ret_epilogue, label %loop_next

loop_next:                                         ; preds = %check_end, %loop_header
  %idx_next = add i32 %idx, 1
  %cmp_idx = icmp ne i32 %idx_next, %count
  br i1 %cmp_idx, label %loop_header, label %after_init

after_init:                                        ; preds = %loop_next, %set_esi_zero
  %esi = phi i32 [ 0, %set_esi_zero ], [ %count, %loop_next ]
  %rdi1 = call i8* @sub_1400026F0(i8* %addr)
  %rdi1_isnull = icmp eq i8* %rdi1, null
  br i1 %rdi1_isnull, label %print_noimage, label %handle_found

after_init_2:                                      ; preds = %set_esi_zero_after_vpfail
  %rdi2 = call i8* @sub_1400026F0(i8* %addr)
  %rdi2_isnull = icmp eq i8* %rdi2, null
  br i1 %rdi2_isnull, label %print_noimage, label %handle_found_retry

handle_found_retry:                                ; preds = %after_init_2
  br label %handle_found

handle_found:                                      ; preds = %handle_found_retry, %after_init
  %rdi_in = phi i8* [ %rdi1, %after_init ], [ %rdi2, %handle_found_retry ]
  %esi_in = phi i32 [ %esi, %after_init ], [ 0, %handle_found_retry ]
  %esi64b = sext i32 %esi_in to i64
  %mul40b = mul i64 %esi64b, 40
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %entry1 = getelementptr i8, i8* %base1, i64 %mul40b
  %entry1_p20 = getelementptr i8, i8* %entry1, i64 32
  %entry1_p20_ptr = bitcast i8* %entry1_p20 to i8**
  store i8* %rdi_in, i8** %entry1_p20_ptr, align 8
  %entry1_i32ptr = bitcast i8* %entry1 to i32*
  store i32 0, i32* %entry1_i32ptr, align 4
  %baseRet = call i8* @sub_140002830()
  %rdi_plus12 = getelementptr i8, i8* %rdi_in, i64 12
  %len_q_off_ptr = bitcast i8* %rdi_plus12 to i32*
  %len_q = load i32, i32* %len_q_off_ptr, align 4
  %len_q_z = zext i32 %len_q to i64
  %rcx_addr = getelementptr i8, i8* %baseRet, i64 %len_q_z
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_for_store = getelementptr i8, i8* %base3, i64 %mul40b
  %entry_p18 = getelementptr i8, i8* %entry_for_store, i64 24
  %entry_p18_ptr = bitcast i8* %entry_p18 to i8**
  store i8* %rcx_addr, i8** %entry_p18_ptr, align 8
  %buf_i8 = bitcast [48 x i8]* %buf to i8*
  %vq_ret = call i32 @VirtualQuery(i8* %rcx_addr, i8* %buf_i8, i64 48)
  %vq_ok = icmp ne i32 %vq_ret, 0
  br i1 %vq_ok, label %vq_succeeded, label %vq_failed

vq_failed:                                         ; preds = %handle_found
  %fmt2_ptr = getelementptr [49 x i8], [49 x i8]* @.str_vquery, i64 0, i64 0
  %rdi_plus8 = getelementptr i8, i8* %rdi_in, i64 8
  %size_bytes_ptr = bitcast i8* %rdi_plus8 to i32*
  %size_bytes = load i32, i32* %size_bytes_ptr, align 4
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry_for_load = getelementptr i8, i8* %base4, i64 %mul40b
  %entry_p18_load = getelementptr i8, i8* %entry_for_load, i64 24
  %entry_p18_load_ptr = bitcast i8* %entry_p18_load to i8**
  %addr_logged = load i8*, i8** %entry_p18_load_ptr, align 8
  call void (i8*, ...) @sub_140001BA0(i8* %fmt2_ptr, i32 %size_bytes, i8* %addr_logged)
  br label %print_noimage

vq_succeeded:                                      ; preds = %handle_found
  %prot_ptr_i8 = getelementptr i8, i8* %buf_i8, i64 36
  %prot_ptr = bitcast i8* %prot_ptr_i8 to i32*
  %prot = load i32, i32* %prot_ptr, align 4
  %sub1 = sub i32 %prot, 4
  %and1 = and i32 %sub1, -5
  %isZero1 = icmp eq i32 %and1, 0
  br i1 %isZero1, label %inc_and_ret, label %check2

check2:                                            ; preds = %vq_succeeded
  %sub2 = sub i32 %prot, 64
  %and2 = and i32 %sub2, -65
  %isZero2 = icmp eq i32 %and2, 0
  br i1 %isZero2, label %inc_and_ret, label %do_vprotect

do_vprotect:                                       ; preds = %check2
  %prot_eq_2 = icmp eq i32 %prot, 2
  %newProtSel = select i1 %prot_eq_2, i32 4, i32 64
  %ba_ptr_i8 = getelementptr i8, i8* %buf_i8, i64 0
  %ba_ptr = bitcast i8* %ba_ptr_i8 to i8**
  %baseaddr = load i8*, i8** %ba_ptr, align 8
  %rs_ptr_i8 = getelementptr i8, i8* %buf_i8, i64 24
  %rs_ptr = bitcast i8* %rs_ptr_i8 to i64*
  %regionsize = load i64, i64* %rs_ptr, align 8
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry2 = getelementptr i8, i8* %base2, i64 %mul40b
  %entry2_p8 = getelementptr i8, i8* %entry2, i64 8
  %entry2_p8_ptr = bitcast i8* %entry2_p8 to i8**
  store i8* %baseaddr, i8** %entry2_p8_ptr, align 8
  %entry2_p10 = getelementptr i8, i8* %entry2, i64 16
  %entry2_p10_ptr = bitcast i8* %entry2_p10 to i64*
  store i64 %regionsize, i64* %entry2_p10_ptr, align 8
  %oldProt_ptr = bitcast i8* %entry2 to i32*
  %vp_ret = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newProtSel, i32* %oldProt_ptr)
  %vp_ok = icmp ne i32 %vp_ret, 0
  br i1 %vp_ok, label %inc_and_ret, label %vp_fail

vp_fail:                                           ; preds = %do_vprotect
  %gle = call i32 @GetLastError()
  %fmt1_ptr = getelementptr [40 x i8], [40 x i8]* @.str_vprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001BA0(i8* %fmt1_ptr, i32 %gle)
  br label %set_esi_zero_after_vpfail

set_esi_zero_after_vpfail:                         ; preds = %vp_fail
  br label %after_init_2

inc_and_ret:                                       ; preds = %do_vprotect, %check2, %vq_succeeded
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %oldc, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  br label %ret_epilogue

print_noimage:                                     ; preds = %after_init_2, %after_init, %vq_failed
  %fmt3_ptr = getelementptr [32 x i8], [32 x i8]* @.str_noimage, i64 0, i64 0
  call void (i8*, ...) @sub_140001BA0(i8* %fmt3_ptr, i8* %addr)
  br label %ret_epilogue

ret_epilogue:                                      ; preds = %print_noimage, %inc_and_ret, %check_end
  ret void
}
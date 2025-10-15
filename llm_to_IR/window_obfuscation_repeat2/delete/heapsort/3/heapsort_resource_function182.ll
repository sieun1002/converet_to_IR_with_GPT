; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@__imp_VirtualQuery = external dllimport global i8*
@__imp_VirtualProtect = external dllimport global i8*
@__imp_GetLastError = external dllimport global i8*

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i32 @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %count = load i32, i32* @dword_1400070A4, align 4
  %count_le = icmp sle i32 %count, 0
  br i1 %count_le, label %no_entries, label %have_entries

have_entries:                                      ; preds = %entry
  %base_ptr = load i8*, i8** @qword_1400070A8, align 8
  %iter0 = getelementptr i8, i8* %base_ptr, i64 24
  br label %loop

loop:                                              ; preds = %loop_latch_pre, %have_entries
  %idx = phi i32 [ 0, %have_entries ], [ %idx_next, %loop_latch_pre ]
  %cur = phi i8* [ %iter0, %have_entries ], [ %next_iter, %loop_latch_pre ]
  %cur_as_pp = bitcast i8* %cur to i8**
  %start = load i8*, i8** %cur_as_pp, align 8
  %addr_uint = ptrtoint i8* %addr to i64
  %start_uint = ptrtoint i8* %start to i64
  %addr_lt_start = icmp ult i64 %addr_uint, %start_uint
  br i1 %addr_lt_start, label %loop_latch_pre, label %check_end

check_end:                                         ; preds = %loop
  %desc_ptr_ptr = getelementptr i8, i8* %cur, i64 8
  %desc_ptr_pp = bitcast i8* %desc_ptr_ptr to i8**
  %desc_ptr = load i8*, i8** %desc_ptr_pp, align 8
  %size_ptr = getelementptr i8, i8* %desc_ptr, i64 8
  %size32_ptr = bitcast i8* %size_ptr to i32*
  %size32 = load i32, i32* %size32_ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end_uint = add i64 %start_uint, %size64
  %in_range = icmp ult i64 %addr_uint, %end_uint
  br i1 %in_range, label %ret, label %loop_latch_pre

loop_latch_pre:                                    ; preds = %check_end, %loop
  %idx_next = add i32 %idx, 1
  %next_iter = getelementptr i8, i8* %cur, i64 40
  %cmp_end = icmp ne i32 %idx_next, %count
  br i1 %cmp_end, label %loop, label %after_loop

ret:                                               ; preds = %check_end
  ret void

after_loop:                                        ; preds = %loop_latch_pre
  br label %B88

no_entries:                                        ; preds = %entry
  br label %B88

B88:                                               ; preds = %no_entries, %after_loop
  %idx_for_new = phi i32 [ 0, %no_entries ], [ %count, %after_loop ]
  %img = call i8* @sub_140002610(i8* %addr)
  %cond_null = icmp eq i8* %img, null
  br i1 %cond_null, label %C82, label %cont_nonnull

C82:                                               ; preds = %B88
  %callprint1 = call i32 (i8*, ...) @sub_140001AD0(i8* @aAddressPHasNoI, i8* %addr)
  ret void

cont_nonnull:                                      ; preds = %B88
  %idx_ext = sext i32 %idx_for_new to i64
  %mul4 = mul i64 %idx_ext, 4
  %sum5 = add i64 %idx_ext, %mul4
  %offset_bytes = shl i64 %sum5, 3
  %arr_base = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr = getelementptr i8, i8* %arr_base, i64 %offset_bytes
  %entry_f20 = getelementptr i8, i8* %entry_ptr, i64 32
  %entry_f20_pp = bitcast i8* %entry_f20 to i8**
  store i8* %img, i8** %entry_f20_pp, align 8
  %entry_f0 = getelementptr i8, i8* %entry_ptr, i64 0
  %entry_f0_p32 = bitcast i8* %entry_f0 to i32*
  store i32 0, i32* %entry_f0_p32, align 4
  %base = call i8* @sub_140002750()
  %img_plus_c = getelementptr i8, i8* %img, i64 12
  %img_plus_c_p32 = bitcast i8* %img_plus_c to i32*
  %img_off_c = load i32, i32* %img_plus_c_p32, align 4
  %img_off_c_z = zext i32 %img_off_c to i64
  %vc_addr = getelementptr i8, i8* %base, i64 %img_off_c_z
  %entry_f18 = getelementptr i8, i8* %entry_ptr, i64 24
  %entry_f18_pp = bitcast i8* %entry_f18 to i8**
  store i8* %vc_addr, i8** %entry_f18_pp, align 8
  %imp_vq_p = load i8*, i8** @__imp_VirtualQuery, align 8
  %typed_vq = bitcast i8* %imp_vq_p to i64 (i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)*
  %vq_result = call i64 %typed_vq(i8* %vc_addr, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vq_zero = icmp eq i64 %vq_result, 0
  br i1 %vq_zero, label %C67, label %after_vq

after_vq:                                          ; preds = %cont_nonnull
  %protect_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 6
  %protect = load i32, i32* %protect_ptr, align 4
  %eax_minus4 = add i32 %protect, 4294967292
  %edx_mask1 = and i32 %eax_minus4, 4294967291
  %is_zero1 = icmp eq i32 %edx_mask1, 0
  br i1 %is_zero1, label %BFE, label %cont_check

cont_check:                                        ; preds = %after_vq
  %eax_minus40 = add i32 %protect, 4294967232
  %edx_mask2 = and i32 %eax_minus40, 4294967231
  %not_zero2 = icmp ne i32 %edx_mask2, 0
  br i1 %not_zero2, label %C10, label %BFE

BFE:                                               ; preds = %cont_check, %after_vq, %C10
  %oldcount = load i32, i32* @dword_1400070A4, align 4
  %newcount = add i32 %oldcount, 1
  store i32 %newcount, i32* @dword_1400070A4, align 4
  ret void

C10:                                               ; preds = %cont_check
  %is_two = icmp eq i32 %protect, 2
  %baseaddr_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 0
  %baseaddr2 = load i8*, i8** %baseaddr_ptr, align 8
  %regionsize_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 4
  %regionsize2 = load i64, i64* %regionsize_ptr, align 8
  %flnew = select i1 %is_two, i32 4, i32 64
  %entry_f8 = getelementptr i8, i8* %entry_ptr, i64 8
  %entry_f8_pp = bitcast i8* %entry_f8 to i8**
  store i8* %baseaddr2, i8** %entry_f8_pp, align 8
  %entry_f10 = getelementptr i8, i8* %entry_ptr, i64 16
  %entry_f10_p64 = bitcast i8* %entry_f10 to i64*
  store i64 %regionsize2, i64* %entry_f10_p64, align 8
  %imp_vp_p = load i8*, i8** @__imp_VirtualProtect, align 8
  %typed_vp = bitcast i8* %imp_vp_p to i32 (i8*, i64, i32, i32*)*
  %oldprot_ptr = bitcast i8* %entry_ptr to i32*
  %ret_vp = call i32 %typed_vp(i8* %baseaddr2, i64 %regionsize2, i32 %flnew, i32* %oldprot_ptr)
  %succ = icmp ne i32 %ret_vp, 0
  br i1 %succ, label %BFE, label %vp_fail

vp_fail:                                           ; preds = %C10
  %imp_gle_p = load i8*, i8** @__imp_GetLastError, align 8
  %typed_gle = bitcast i8* %imp_gle_p to i32 ()*
  %gle = call i32 %typed_gle()
  %callprint2 = call i32 (i8*, ...) @sub_140001AD0(i8* @aVirtualprotect, i32 %gle)
  br label %C05_ret

C67:                                               ; preds = %cont_nonnull
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %img_plus_8 = getelementptr i8, i8* %img, i64 8
  %val_edx_p32 = bitcast i8* %img_plus_8 to i32*
  %val_edx = load i32, i32* %val_edx_p32, align 4
  %ptr_f18 = getelementptr i8, i8* %base2, i64 %offset_bytes
  %ptr_f18b = getelementptr i8, i8* %ptr_f18, i64 24
  %ptr_f18b_pp = bitcast i8* %ptr_f18b to i8**
  %field18 = load i8*, i8** %ptr_f18b_pp, align 8
  %callprint3 = call i32 (i8*, ...) @sub_140001AD0(i8* @aVirtualqueryFa, i32 %val_edx, i8* %field18)
  br label %C05_ret

C05_ret:                                           ; preds = %C67, %vp_fail
  ret void
}
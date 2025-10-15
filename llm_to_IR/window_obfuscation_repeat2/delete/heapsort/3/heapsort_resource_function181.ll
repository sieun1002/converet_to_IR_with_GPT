; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct.MEMORY_BASIC_INFORMATION = type { ptr, ptr, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global ptr

@__imp_VirtualQuery = external dllimport global ptr
@__imp_VirtualProtect = external dllimport global ptr
@__imp_GetLastError = external dllimport global ptr

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare ptr @sub_140002610(ptr)
declare ptr @sub_140002750()
declare i32 @sub_140001AD0(ptr, ...)

define void @sub_140001B30(ptr %addr) {
entry:
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %count = load i32, ptr @dword_1400070A4, align 4
  %count_le = icmp sle i32 %count, 0
  br i1 %count_le, label %no_entries, label %have_entries

have_entries:                                      ; preds = %entry
  %base_ptr = load ptr, ptr @qword_1400070A8, align 8
  %iter0 = getelementptr i8, ptr %base_ptr, i64 24
  br label %loop

loop:                                              ; preds = %loop_latch_pre, %have_entries
  %idx = phi i32 [ 0, %have_entries ], [ %idx_next, %loop_latch_pre ]
  %cur = phi ptr [ %iter0, %have_entries ], [ %next_iter, %loop_latch_pre ]
  %start = load ptr, ptr %cur, align 8
  %addr_uint = ptrtoint ptr %addr to i64
  %start_uint = ptrtoint ptr %start to i64
  %addr_lt_start = icmp ult i64 %addr_uint, %start_uint
  br i1 %addr_lt_start, label %loop_latch_pre, label %check_end

check_end:                                         ; preds = %loop
  %desc_ptr_ptr = getelementptr i8, ptr %cur, i64 8
  %desc_ptr = load ptr, ptr %desc_ptr_ptr, align 8
  %size_ptr = getelementptr i8, ptr %desc_ptr, i64 8
  %size32 = load i32, ptr %size_ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end_uint = add i64 %start_uint, %size64
  %in_range = icmp ult i64 %addr_uint, %end_uint
  br i1 %in_range, label %ret, label %loop_latch_pre

loop_latch_pre:                                    ; preds = %check_end, %loop
  %idx_next = add i32 %idx, 1
  %next_iter = getelementptr i8, ptr %cur, i64 40
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
  %img = call ptr @sub_140002610(ptr %addr)
  %cond_null = icmp eq ptr %img, null
  br i1 %cond_null, label %C82, label %cont_nonnull

C82:                                               ; preds = %B88
  %callprint1 = call i32 (ptr, ...) @sub_140001AD0(ptr @aAddressPHasNoI, ptr %addr)
  ret void

cont_nonnull:                                      ; preds = %B88
  %idx_ext = sext i32 %idx_for_new to i64
  %mul4 = mul i64 %idx_ext, 4
  %sum5 = add i64 %idx_ext, %mul4
  %offset_bytes = shl i64 %sum5, 3
  %arr_base = load ptr, ptr @qword_1400070A8, align 8
  %entry_ptr = getelementptr i8, ptr %arr_base, i64 %offset_bytes
  %entry_f20 = getelementptr i8, ptr %entry_ptr, i64 32
  store ptr %img, ptr %entry_f20, align 8
  %entry_f0 = getelementptr i8, ptr %entry_ptr, i64 0
  store i32 0, ptr %entry_f0, align 4
  %base = call ptr @sub_140002750()
  %img_plus_c = getelementptr i8, ptr %img, i64 12
  %img_off_c = load i32, ptr %img_plus_c, align 4
  %img_off_c_z = zext i32 %img_off_c to i64
  %vc_addr = getelementptr i8, ptr %base, i64 %img_off_c_z
  %entry_f18 = getelementptr i8, ptr %entry_ptr, i64 24
  store ptr %vc_addr, ptr %entry_f18, align 8
  %imp_vq_p = load ptr, ptr @__imp_VirtualQuery, align 8
  %typed_vq = bitcast ptr %imp_vq_p to i64 (ptr, ptr, i64)*
  %vq_result = call i64 %typed_vq(ptr %vc_addr, ptr %buf, i64 48)
  %vq_zero = icmp eq i64 %vq_result, 0
  br i1 %vq_zero, label %C67, label %after_vq

after_vq:                                          ; preds = %cont_nonnull
  %protect_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, ptr %buf, i32 0, i32 6
  %protect = load i32, ptr %protect_ptr, align 4
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
  %oldcount = load i32, ptr @dword_1400070A4, align 4
  %newcount = add i32 %oldcount, 1
  store i32 %newcount, ptr @dword_1400070A4, align 4
  ret void

C10:                                               ; preds = %cont_check
  %is_two = icmp eq i32 %protect, 2
  %baseaddr_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, ptr %buf, i32 0, i32 0
  %baseaddr2 = load ptr, ptr %baseaddr_ptr, align 8
  %regionsize_ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, ptr %buf, i32 0, i32 4
  %regionsize2 = load i64, ptr %regionsize_ptr, align 8
  %flnew = select i1 %is_two, i32 4, i32 64
  %entry_f8 = getelementptr i8, ptr %entry_ptr, i64 8
  store ptr %baseaddr2, ptr %entry_f8, align 8
  %entry_f10 = getelementptr i8, ptr %entry_ptr, i64 16
  store i64 %regionsize2, ptr %entry_f10, align 8
  %imp_vp_p = load ptr, ptr @__imp_VirtualProtect, align 8
  %typed_vp = bitcast ptr %imp_vp_p to i32 (ptr, i64, i32, ptr)*
  %ret_vp = call i32 %typed_vp(ptr %baseaddr2, i64 %regionsize2, i32 %flnew, ptr %entry_ptr)
  %succ = icmp ne i32 %ret_vp, 0
  br i1 %succ, label %BFE, label %vp_fail

vp_fail:                                           ; preds = %C10
  %imp_gle_p = load ptr, ptr @__imp_GetLastError, align 8
  %typed_gle = bitcast ptr %imp_gle_p to i32 ()*
  %gle = call i32 %typed_gle()
  %callprint2 = call i32 (ptr, ...) @sub_140001AD0(ptr @aVirtualprotect, i32 %gle)
  br label %C05_ret

C67:                                               ; preds = %cont_nonnull
  %base2 = load ptr, ptr @qword_1400070A8, align 8
  %img_plus_8 = getelementptr i8, ptr %img, i64 8
  %val_edx = load i32, ptr %img_plus_8, align 4
  %ptr_f18 = getelementptr i8, ptr %base2, i64 %offset_bytes
  %ptr_f18b = getelementptr i8, ptr %ptr_f18, i64 24
  %field18 = load ptr, ptr %ptr_f18b, align 8
  %callprint3 = call i32 (ptr, ...) @sub_140001AD0(ptr @aVirtualqueryFa, i32 %val_edx, ptr %field18)
  br label %C05_ret

C05_ret:                                           ; preds = %C67, %vp_fail
  ret void
}
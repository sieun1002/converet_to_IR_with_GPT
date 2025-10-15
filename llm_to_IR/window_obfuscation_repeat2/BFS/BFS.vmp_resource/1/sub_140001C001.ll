; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"

%struct.MBI = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aVirtualqueryFa = external constant i8
@aVirtualprotect = constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aAddressPHasNoI = constant [32 x i8] c"Address %p has no image-section\00"

@__imp_VirtualQuery = external dllimport global i64 (i8*, i8*, i64)*
@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*
@__imp_GetLastError = external dllimport global i32 ()*

declare i8* @sub_1400026F0(i8*)
declare i8* @sub_140002830()
declare void @sub_140001BA0(i8*, ...)

define void @sub_140001C00(i8* %arg) {
entry:
  %mbi = alloca %struct.MBI, align 8
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %count0, 0
  br i1 %cmp_le, label %set_count_zero, label %scan_init

scan_init:                                           ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scan_ptr0 = getelementptr i8, i8* %base0, i64 24
  br label %scan_loop

scan_loop:                                           ; preds = %scan_body_inc, %scan_init
  %idx = phi i32 [ 0, %scan_init ], [ %idx.next, %scan_body_inc ]
  %scan_ptr = phi i8* [ %scan_ptr0, %scan_init ], [ %scan_ptr.next, %scan_body_inc ]
  %idx_done = icmp eq i32 %idx, %count0
  br i1 %idx_done, label %set_count_keep, label %scan_body

scan_body:                                           ; preds = %scan_loop
  %scan_ptr_pp = bitcast i8* %scan_ptr to i8**
  %start_ptr = load i8*, i8** %scan_ptr_pp, align 8
  %arg_int = ptrtoint i8* %arg to i64
  %start_int = ptrtoint i8* %start_ptr to i64
  %cmp_jb = icmp ult i64 %arg_int, %start_int
  br i1 %cmp_jb, label %scan_body_inc, label %check_end

check_end:                                           ; preds = %scan_body
  %desc_addr_i8 = getelementptr i8, i8* %scan_ptr, i64 8
  %desc_pp = bitcast i8* %desc_addr_i8 to i8**
  %desc_ptr = load i8*, i8** %desc_pp, align 8
  %size_field_i8 = getelementptr i8, i8* %desc_ptr, i64 8
  %size_p = bitcast i8* %size_field_i8 to i32*
  %size32 = load i32, i32* %size_p, align 4
  %size64 = zext i32 %size32 to i64
  %end_int = add i64 %start_int, %size64
  %cmp_jb2 = icmp ult i64 %arg_int, %end_int
  br i1 %cmp_jb2, label %early_ret, label %scan_body_inc

scan_body_inc:                                       ; preds = %check_end, %scan_body
  %idx.next = add i32 %idx, 1
  %scan_ptr.next = getelementptr i8, i8* %scan_ptr, i64 40
  br label %scan_loop

early_ret:                                           ; preds = %check_end
  ret void

set_count_zero:                                      ; preds = %entry, %vp_error
  %count_for_new0 = phi i32 [ 0, %entry ], [ 0, %vp_error ]
  br label %prepare_new

set_count_keep:                                      ; preds = %scan_loop
  br label %prepare_new

prepare_new:                                         ; preds = %set_count_keep, %set_count_zero
  %count_for_new = phi i32 [ %count0, %set_count_keep ], [ %count_for_new0, %set_count_zero ]
  %sec_info = call i8* @sub_1400026F0(i8* %arg)
  %is_null = icmp eq i8* %sec_info, null
  br i1 %is_null, label %no_image_section, label %have_sec

have_sec:                                            ; preds = %prepare_new
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %count_for_new64 = sext i32 %count_for_new to i64
  %off40 = mul i64 %count_for_new64, 40
  %entry_ptr = getelementptr i8, i8* %base1, i64 %off40
  %entry_off20 = getelementptr i8, i8* %entry_ptr, i64 32
  %entry_off20_pp = bitcast i8* %entry_off20 to i8**
  store i8* %sec_info, i8** %entry_off20_pp, align 8
  %entry_off0 = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_off0, align 4
  %base2 = call i8* @sub_140002830()
  %off_field_i8 = getelementptr i8, i8* %sec_info, i64 12
  %off_field_p = bitcast i8* %off_field_i8 to i32*
  %off_val32 = load i32, i32* %off_field_p, align 4
  %off_val64 = zext i32 %off_val32 to i64
  %addr_query = getelementptr i8, i8* %base2, i64 %off_val64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr i8, i8* %base3, i64 %off40
  %entry_off18 = getelementptr i8, i8* %entry_ptr2, i64 24
  %entry_off18_pp = bitcast i8* %entry_off18 to i8**
  store i8* %addr_query, i8** %entry_off18_pp, align 8
  %vq_fnptr_p = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @__imp_VirtualQuery, align 8
  %mbi_i8 = bitcast %struct.MBI* %mbi to i8*
  %vq_res = call i64 %vq_fnptr_p(i8* %addr_query, i8* %mbi_i8, i64 48)
  %vq_ok = icmp ne i64 %vq_res, 0
  br i1 %vq_ok, label %check_protect, label %vq_fail

check_protect:                                       ; preds = %have_sec
  %protect_p = getelementptr %struct.MBI, %struct.MBI* %mbi, i32 0, i32 6
  %protect = load i32, i32* %protect_p, align 4
  %t1 = sub i32 %protect, 4
  %t1a = and i32 %t1, 4294967291
  %is_ok1 = icmp eq i32 %t1a, 0
  br i1 %is_ok1, label %inc_and_ret, label %check_protect2

check_protect2:                                      ; preds = %check_protect
  %t2 = sub i32 %protect, 64
  %t2a = and i32 %t2, 4294967231
  %is_ok2 = icmp eq i32 %t2a, 0
  br i1 %is_ok2, label %inc_and_ret, label %need_vp

need_vp:                                             ; preds = %check_protect2
  %cmp_two = icmp eq i32 %protect, 2
  %newprot_sel4 = select i1 %cmp_two, i32 4, i32 64
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr3 = getelementptr i8, i8* %base4, i64 %off40
  %baseaddr_p = getelementptr %struct.MBI, %struct.MBI* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr_p, align 8
  %regionsize_p = getelementptr %struct.MBI, %struct.MBI* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize_p, align 8
  %entry_off8 = getelementptr i8, i8* %entry_ptr3, i64 8
  %entry_off8_pp = bitcast i8* %entry_off8 to i8**
  store i8* %baseaddr, i8** %entry_off8_pp, align 8
  %entry_off10 = getelementptr i8, i8* %entry_ptr3, i64 16
  %entry_off10_pq = bitcast i8* %entry_off10 to i64*
  store i64 %regionsize, i64* %entry_off10_pq, align 8
  %oldprot_p = bitcast i8* %entry_ptr3 to i32*
  %vp_fnptr_p = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %vp_res = call i32 %vp_fnptr_p(i8* %baseaddr, i64 %regionsize, i32 %newprot_sel4, i32* %oldprot_p)
  %vp_ok = icmp ne i32 %vp_res, 0
  br i1 %vp_ok, label %inc_and_ret, label %vp_error

vp_error:                                            ; preds = %need_vp
  %gle_fnptr_p = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  %gle = call i32 %gle_fnptr_p()
  %fmt1_p = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001BA0(i8* %fmt1_p, i32 %gle)
  br label %set_count_zero

vq_fail:                                             ; preds = %have_sec
  %base5 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr4 = getelementptr i8, i8* %base5, i64 %off40
  %addr_stored_p_i8 = getelementptr i8, i8* %entry_ptr4, i64 24
  %addr_stored_pp = bitcast i8* %addr_stored_p_i8 to i8**
  %addr_stored = load i8*, i8** %addr_stored_pp, align 8
  %bytes_p_i8 = getelementptr i8, i8* %sec_info, i64 8
  %bytes_p = bitcast i8* %bytes_p_i8 to i32*
  %bytes = load i32, i32* %bytes_p, align 4
  %fmt2_p = bitcast i8* @aVirtualqueryFa to i8*
  call void (i8*, ...) @sub_140001BA0(i8* %fmt2_p, i32 %bytes, i8* %addr_stored)
  br label %no_image_section

no_image_section:                                    ; preds = %vq_fail, %prepare_new
  %fmt3_p = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001BA0(i8* %fmt3_p, i8* %arg)
  ret void

inc_and_ret:                                         ; preds = %need_vp, %check_protect2, %check_protect
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  ret void
}
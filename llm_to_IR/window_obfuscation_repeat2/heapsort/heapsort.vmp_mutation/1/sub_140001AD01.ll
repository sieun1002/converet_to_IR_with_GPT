; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@__imp_VirtualQuery = external dllimport global i64 (i8*, i8*, i64)*
@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*
@__imp_GetLastError = external dllimport global i32 ()*

@aVirtualprotect = internal unnamed_addr constant [40 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = internal unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = internal unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_1400025B0(i8*)
declare i8* @sub_1400026F0()
declare i32 @sub_140001A70(i8*, ...)

define void @sub_140001AD0(i8* %addr) local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 8
  %count0 = load i32, i32* @dword_1400070A4
  %count_le0 = icmp sle i32 %count0, 0
  br i1 %count_le0, label %no_sections, label %have_sections

have_sections:                                      ; preds = %entry
  %base_arr0.p = load i8*, i8** @qword_1400070A8
  %field_ptr0 = getelementptr i8, i8* %base_arr0.p, i64 24
  br label %loop

loop:                                                ; preds = %loop.inc, %have_sections
  %i = phi i32 [ 0, %have_sections ], [ %i.next, %loop.inc ]
  %field_ptr = phi i8* [ %field_ptr0, %have_sections ], [ %field_ptr.next, %loop.inc ]
  %start_ptr.ptr = bitcast i8* %field_ptr to i8**
  %start_ptr = load i8*, i8** %start_ptr.ptr
  %addr_int = ptrtoint i8* %addr to i64
  %start_int = ptrtoint i8* %start_ptr to i64
  %addr_before_start = icmp ult i64 %addr_int, %start_int
  br i1 %addr_before_start, label %loop.inc, label %check_end

check_end:                                           ; preds = %loop
  %rdi_ptr_ptr_addr = getelementptr i8, i8* %field_ptr, i64 8
  %rdi_ptr_ptr = bitcast i8* %rdi_ptr_ptr_addr to i8**
  %rdi_ptr = load i8*, i8** %rdi_ptr_ptr
  %size32_ptr_i8 = getelementptr i8, i8* %rdi_ptr, i64 8
  %size32_ptr = bitcast i8* %size32_ptr_i8 to i32*
  %size32 = load i32, i32* %size32_ptr
  %size64 = sext i32 %size32 to i64
  %end_int = add i64 %start_int, %size64
  %in_range = icmp ult i64 %addr_int, %end_int
  br i1 %in_range, label %ret_void, label %loop.inc

loop.inc:                                            ; preds = %check_end, %loop
  %i.next = add i32 %i, 1
  %field_ptr.next = getelementptr i8, i8* %field_ptr, i64 40
  %end_reached = icmp ne i32 %i.next, %count0
  br i1 %end_reached, label %loop, label %prepare_new

no_sections:                                         ; preds = %entry
  br label %prepare_new

prepare_new:                                         ; preds = %loop.inc, %no_sections
  %idx = phi i32 [ 0, %no_sections ], [ %count0, %loop.inc ]
  %newinfo = call i8* @sub_1400025B0(i8* %addr)
  %is_null = icmp eq i8* %newinfo, null
  br i1 %is_null, label %no_image_section, label %have_newinfo

have_newinfo:                                        ; preds = %prepare_new
  %arr_base = load i8*, i8** @qword_1400070A8
  %idx64 = sext i32 %idx to i64
  %elem_off = mul i64 %idx64, 40
  %elem_ptr = getelementptr i8, i8* %arr_base, i64 %elem_off
  %field20_i8 = getelementptr i8, i8* %elem_ptr, i64 32
  %field20 = bitcast i8* %field20_i8 to i8**
  store i8* %newinfo, i8** %field20
  %oldprot_ptr = bitcast i8* %elem_ptr to i32*
  store i32 0, i32* %oldprot_ptr
  %mapbase = call i8* @sub_1400026F0()
  %off_ptr_i8 = getelementptr i8, i8* %newinfo, i64 12
  %off_ptr = bitcast i8* %off_ptr_i8 to i32*
  %off_val32 = load i32, i32* %off_ptr
  %off_val64 = sext i32 %off_val32 to i64
  %addr_to_query = getelementptr i8, i8* %mapbase, i64 %off_val64
  %field18_i8 = getelementptr i8, i8* %elem_ptr, i64 24
  %field18 = bitcast i8* %field18_i8 to i8**
  store i8* %addr_to_query, i8** %field18
  %buf_i8ptr = bitcast [48 x i8]* %buf to i8*
  %impVQ.ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @__imp_VirtualQuery
  %vqret = call i64 %impVQ.ptr(i8* %addr_to_query, i8* %buf_i8ptr, i64 48)
  %vq_failed = icmp eq i64 %vqret, 0
  br i1 %vq_failed, label %virtualquery_failed, label %vq_ok

vq_ok:                                              ; preds = %have_newinfo
  %protect_ptr_i8 = getelementptr i8, i8* %buf_i8ptr, i64 36
  %protect_ptr = bitcast i8* %protect_ptr_i8 to i32*
  %protect = load i32, i32* %protect_ptr
  %t1 = sub i32 %protect, 4
  %t1and = and i32 %t1, -5
  %t1zero = icmp eq i32 %t1and, 0
  br i1 %t1zero, label %inc_and_ret, label %check_exec

check_exec:                                          ; preds = %vq_ok
  %t2 = sub i32 %protect, 64
  %t2and = and i32 %t2, -65
  %need_vp = icmp ne i32 %t2and, 0
  br i1 %need_vp, label %do_virtualprotect, label %inc_and_ret

do_virtualprotect:                                   ; preds = %check_exec
  %baseaddr_ptr_i8 = getelementptr i8, i8* %buf_i8ptr, i64 0
  %baseaddr_ptr = bitcast i8* %baseaddr_ptr_i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr_ptr
  %regionsize_ptr_i8 = getelementptr i8, i8* %buf_i8ptr, i64 24
  %regionsize_ptr = bitcast i8* %regionsize_ptr_i8 to i64*
  %regionsize = load i64, i64* %regionsize_ptr
  %fl_is_ro = icmp eq i32 %protect, 2
  %flro = select i1 %fl_is_ro, i32 2, i32 64
  %elem_base_f_i8 = getelementptr i8, i8* %elem_ptr, i64 8
  %elem_base_f = bitcast i8* %elem_base_f_i8 to i8**
  store i8* %baseaddr, i8** %elem_base_f
  %elem_size_f_i8 = getelementptr i8, i8* %elem_ptr, i64 16
  %elem_size_f = bitcast i8* %elem_size_f_i8 to i64*
  store i64 %regionsize, i64* %elem_size_f
  %impVP.ptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect
  %vpok = call i32 %impVP.ptr(i8* %baseaddr, i64 %regionsize, i32 %flro, i32* %oldprot_ptr)
  %vp_succeeded = icmp ne i32 %vpok, 0
  br i1 %vp_succeeded, label %inc_and_ret, label %virtualprotect_failed

virtualprotect_failed:                               ; preds = %do_virtualprotect
  %impGLE.ptr = load i32 ()*, i32 ()** @__imp_GetLastError
  %gle = call i32 %impGLE.ptr()
  %fmt_vp_ptr = getelementptr [40 x i8], [40 x i8]* @aVirtualprotect, i64 0, i64 0
  %call_log_vp = call i32 (i8*, ...) @sub_140001A70(i8* %fmt_vp_ptr, i32 %gle)
  br label %ret_void

virtualquery_failed:                                 ; preds = %have_newinfo
  %fmt_vq_ptr = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %size_for_log_ptr_i8 = getelementptr i8, i8* %newinfo, i64 8
  %size_for_log_ptr = bitcast i8* %size_for_log_ptr_i8 to i32*
  %size_for_log = load i32, i32* %size_for_log_ptr
  %addr_logged = load i8*, i8** %field18
  %call_log_vq = call i32 (i8*, ...) @sub_140001A70(i8* %fmt_vq_ptr, i32 %size_for_log, i8* %addr_logged)
  br label %ret_void

inc_and_ret:                                         ; preds = %do_virtualprotect, %check_exec, %vq_ok
  %oldc1 = load i32, i32* @dword_1400070A4
  %newc1 = add i32 %oldc1, 1
  store i32 %newc1, i32* @dword_1400070A4
  br label %ret_void

no_image_section:                                    ; preds = %prepare_new
  %fmt_addr_ptr = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call_log_noimg = call i32 (i8*, ...) @sub_140001A70(i8* %fmt_addr_ptr, i8* %addr)
  br label %ret_void

ret_void:                                            ; preds = %virtualprotect_failed, %no_image_section, %inc_and_ret, %virtualquery_failed, %check_end
  ret void
}
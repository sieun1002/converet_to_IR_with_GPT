; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@qword_140008298 = external global i8*
@qword_140008290 = external global i8*
@qword_140008260 = external global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %addr) {
entry:
  %mbi = alloca [48 x i8], align 8
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %count0, 0
  br i1 %cmp_le, label %set_idx_zero, label %scan_loop_init

scan_loop_init:                                   ; preds = %entry
  %base_scan = load i8*, i8** @qword_1400070A8, align 8
  %base18 = getelementptr i8, i8* %base_scan, i64 24
  br label %scan_loop

scan_loop:                                        ; preds = %scan_continue, %scan_loop_init
  %i = phi i32 [ 0, %scan_loop_init ], [ %i_next, %scan_continue ]
  %idx_i64 = sext i32 %i to i64
  %offs_bytes = mul i64 %idx_i64, 40
  %entry_ptr = getelementptr i8, i8* %base18, i64 %offs_bytes
  %pstart_ptr = bitcast i8* %entry_ptr to i8**
  %start = load i8*, i8** %pstart_ptr, align 8
  %addr_int = ptrtoint i8* %addr to i64
  %start_int = ptrtoint i8* %start to i64
  %cf1 = icmp ult i64 %addr_int, %start_int
  br i1 %cf1, label %scan_continue, label %check_end

check_end:                                        ; preds = %scan_loop
  %entry_ptr_plus8 = getelementptr i8, i8* %entry_ptr, i64 8
  %pptr = bitcast i8* %entry_ptr_plus8 to i8**
  %pval = load i8*, i8** %pptr, align 8
  %pval_plus8 = getelementptr i8, i8* %pval, i64 8
  %endlen_ptr = bitcast i8* %pval_plus8 to i32*
  %len32 = load i32, i32* %endlen_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %inrange = icmp ult i64 %addr_int, %end_int
  br i1 %inrange, label %ret_epilogue, label %scan_continue

scan_continue:                                    ; preds = %check_end, %scan_loop
  %i_next = add i32 %i, 1
  %cmp_loop = icmp ne i32 %i_next, %count0
  br i1 %cmp_loop, label %scan_loop, label %new_entry_from_count

ret_epilogue:                                     ; preds = %check_end
  ret void

new_entry_from_count:                             ; preds = %scan_continue
  %idx_from_count = add i32 %count0, 0
  br label %new_entry

set_idx_zero:                                     ; preds = %entry
  br label %new_entry

new_entry:                                        ; preds = %set_idx_zero, %new_entry_from_count, %set_idx_zero_cont
  %idx = phi i32 [ 0, %set_idx_zero ], [ %idx_from_count, %new_entry_from_count ], [ 0, %set_idx_zero_cont ]
  %rdi_ptr = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %rdi_ptr, null
  br i1 %isnull, label %no_image_section, label %alloc_record

no_image_section:                                 ; preds = %new_entry
  %fmt1 = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt1, i8* %addr)
  ret void

alloc_record:                                     ; preds = %new_entry
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx to i64
  %idx_bytes = mul i64 %idx64, 40
  %rec = getelementptr i8, i8* %base2, i64 %idx_bytes
  %rec_plus20 = getelementptr i8, i8* %rec, i64 32
  %rec_plus20_ptr = bitcast i8* %rec_plus20 to i8**
  store i8* %rdi_ptr, i8** %rec_plus20_ptr, align 8
  %rec_dword0_ptr = bitcast i8* %rec to i32*
  store i32 0, i32* %rec_dword0_ptr, align 4
  %base3 = call i8* @sub_140002390()
  %rdi_plusC = getelementptr i8, i8* %rdi_ptr, i64 12
  %edxval_ptr = bitcast i8* %rdi_plusC to i32*
  %edxval = load i32, i32* %edxval_ptr, align 4
  %edxval64 = zext i32 %edxval to i64
  %rcx_addr = getelementptr i8, i8* %base3, i64 %edxval64
  %rec_plus18 = getelementptr i8, i8* %rec, i64 24
  %rec_plus18_ptr = bitcast i8* %rec_plus18 to i8**
  store i8* %rcx_addr, i8** %rec_plus18_ptr, align 8
  %mbi_ptr = getelementptr [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %fp_vq_raw = load i8*, i8** @qword_140008298, align 8
  %fp_vq = bitcast i8* %fp_vq_raw to i64 (i8*, i8*, i64)*
  %vq_res = call i64 %fp_vq(i8* %rcx_addr, i8* %mbi_ptr, i64 48)
  %vq_zero = icmp eq i64 %vq_res, 0
  br i1 %vq_zero, label %vq_failed, label %vq_ok

vq_failed:                                        ; preds = %alloc_record
  %rdi_plus8 = getelementptr i8, i8* %rdi_ptr, i64 8
  %edx2_ptr = bitcast i8* %rdi_plus8 to i32*
  %bytes = load i32, i32* %edx2_ptr, align 4
  %addr_from_rec = load i8*, i8** %rec_plus18_ptr, align 8
  %fmt2 = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt2, i32 %bytes, i8* %addr_from_rec)
  %fmt3 = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt3, i8* %addr)
  ret void

vq_ok:                                            ; preds = %alloc_record
  %mbi_off24 = getelementptr i8, i8* %mbi_ptr, i64 36
  %prot_ptr = bitcast i8* %mbi_off24 to i32*
  %prot = load i32, i32* %prot_ptr, align 4
  %tmp1 = sub i32 %prot, 4
  %tmp1and = and i32 %tmp1, -5
  %cond1 = icmp eq i32 %tmp1and, 0
  br i1 %cond1, label %inc_and_ret, label %check_exec_rw

check_exec_rw:                                    ; preds = %vq_ok
  %tmp2 = sub i32 %prot, 64
  %tmp2and = and i32 %tmp2, -65
  %cond2 = icmp eq i32 %tmp2and, 0
  br i1 %cond2, label %inc_and_ret, label %need_protect

inc_and_ret:                                      ; preds = %check_exec_rw, %vq_ok
  %c_old = load i32, i32* @dword_1400070A4, align 4
  %c_new = add i32 %c_old, 1
  store i32 %c_new, i32* @dword_1400070A4, align 4
  ret void

need_protect:                                     ; preds = %check_exec_rw
  %is_readonly = icmp eq i32 %prot, 2
  %newprot = select i1 %is_readonly, i32 4, i32 64
  %baseaddr_ptr = bitcast i8* %mbi_ptr to i8**
  %baseaddr = load i8*, i8** %baseaddr_ptr, align 8
  %mbi_off18 = getelementptr i8, i8* %mbi_ptr, i64 24
  %regionsize_ptr = bitcast i8* %mbi_off18 to i64*
  %regionsize = load i64, i64* %regionsize_ptr, align 8
  %rec_plus8 = getelementptr i8, i8* %rec, i64 8
  %rec_plus8_ptr = bitcast i8* %rec_plus8 to i8**
  store i8* %baseaddr, i8** %rec_plus8_ptr, align 8
  %rec_plus10 = getelementptr i8, i8* %rec, i64 16
  %rec_plus10_ptr = bitcast i8* %rec_plus10 to i64*
  store i64 %regionsize, i64* %rec_plus10_ptr, align 8
  %fp_vp_raw = load i8*, i8** @qword_140008290, align 8
  %fp_vp = bitcast i8* %fp_vp_raw to i32 (i8*, i64, i32, i32*)*
  %oldprot_ptr = bitcast i8* %rec to i32*
  %vp_res = call i32 %fp_vp(i8* %baseaddr, i64 %regionsize, i32 %newprot, i32* %oldprot_ptr)
  %vp_ok = icmp ne i32 %vp_res, 0
  br i1 %vp_ok, label %inc_and_ret, label %vp_failed

vp_failed:                                        ; preds = %need_protect
  %fp_gl_raw = load i8*, i8** @qword_140008260, align 8
  %fp_gl = bitcast i8* %fp_gl_raw to i32 ()*
  %err = call i32 %fp_gl()
  %fmt4 = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt4, i32 %err)
  br label %set_idx_zero_cont

set_idx_zero_cont:                                ; preds = %vp_failed
  br label %new_entry
}
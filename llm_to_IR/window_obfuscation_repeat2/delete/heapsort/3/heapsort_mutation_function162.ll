; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%MEMINFO = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*

@.str.vprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@.str.vquery = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@.str.noimage = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare dso_local i8* @sub_140002610(i8*)
declare dso_local i8* @sub_140002750()
declare dso_local void @sub_140001AD0(i8*, ...)
declare dso_local i64 @VirtualQuery(i8*, %MEMINFO*, i64)
declare dso_local i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dso_local i32 @GetLastError()

define dso_local void @sub_140001B30(i8* %addr) {
entry:
  %buf = alloca %MEMINFO, align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %cond_le = icmp sle i32 %count32, 0
  br i1 %cond_le, label %start_new, label %loop_prep

loop_prep:                                        ; preds = %entry
  %basep.load = load i8*, i8** @qword_1400070A8, align 8
  %p0 = getelementptr i8, i8* %basep.load, i64 24
  br label %loop

loop:                                             ; preds = %loop.inc, %loop_prep
  %idx = phi i32 [ 0, %loop_prep ], [ %idx.next, %loop.inc ]
  %curp = phi i8* [ %p0, %loop_prep ], [ %p.next, %loop.inc ]
  %curp_as_ptrptr = bitcast i8* %curp to i8**
  %region_base = load i8*, i8** %curp_as_ptrptr, align 8
  %addr_int = ptrtoint i8* %addr to i64
  %region_base_int = ptrtoint i8* %region_base to i64
  %jb = icmp ult i64 %addr_int, %region_base_int
  br i1 %jb, label %loop.inc, label %check_within

check_within:                                     ; preds = %loop
  %p_plus8 = getelementptr i8, i8* %curp, i64 8
  %p_plus8_as_ptrptr = bitcast i8* %p_plus8 to i8**
  %len_struct_ptr = load i8*, i8** %p_plus8_as_ptrptr, align 8
  %len_ptr = getelementptr i8, i8* %len_struct_ptr, i64 8
  %len_ptr_i32 = bitcast i8* %len_ptr to i32*
  %len = load i32, i32* %len_ptr_i32, align 4
  %len_zext = zext i32 %len to i64
  %end_int = add i64 %region_base_int, %len_zext
  %jb2 = icmp ult i64 %addr_int, %end_int
  br i1 %jb2, label %found_in_existing, label %loop.inc

loop.inc:                                         ; preds = %check_within, %loop
  %idx.next = add i32 %idx, 1
  %p.next = getelementptr i8, i8* %curp, i64 40
  %cond_more = icmp ne i32 %idx.next, %count32
  br i1 %cond_more, label %loop, label %search_notfound

found_in_existing:                                ; preds = %check_within
  ret void

start_new:                                        ; preds = %entry, %vp_failed
  br label %search_notfound

search_notfound:                                  ; preds = %loop.inc, %start_new
  %new_index = phi i32 [ 0, %start_new ], [ %count32, %loop.inc ]
  %secptr = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %secptr, null
  br i1 %isnull, label %no_image, label %have_image

have_image:                                       ; preds = %search_notfound
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx_i64 = sext i32 %new_index to i64
  %offset = mul i64 %idx_i64, 40
  %entry_ptr = getelementptr i8, i8* %base2, i64 %offset
  %entry_plus32 = getelementptr i8, i8* %entry_ptr, i64 32
  %entry_plus32_ptrptr = bitcast i8* %entry_plus32 to i8**
  store i8* %secptr, i8** %entry_plus32_ptrptr, align 8
  %entry_as_i32ptr = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_as_i32ptr, align 4
  %mapbase = call i8* @sub_140002750()
  %rdi_plus12 = getelementptr i8, i8* %secptr, i64 12
  %rdi_plus12_i32ptr = bitcast i8* %rdi_plus12 to i32*
  %edx_val = load i32, i32* %rdi_plus12_i32ptr, align 4
  %edx64 = zext i32 %edx_val to i64
  %rcx_addr = getelementptr i8, i8* %mapbase, i64 %edx64
  %entry_plus24 = getelementptr i8, i8* %entry_ptr, i64 24
  %entry_plus24_ptrptr = bitcast i8* %entry_plus24 to i8**
  store i8* %rcx_addr, i8** %entry_plus24_ptrptr, align 8
  %vqret = call i64 @VirtualQuery(i8* %rcx_addr, %MEMINFO* %buf, i64 48)
  %vq_is_zero = icmp eq i64 %vqret, 0
  br i1 %vq_is_zero, label %vquery_failed, label %after_vquery

after_vquery:                                     ; preds = %have_image
  %protect_ptr = getelementptr inbounds %MEMINFO, %MEMINFO* %buf, i64 0, i32 6
  %protect = load i32, i32* %protect_ptr, align 4
  %sub4 = sub i32 %protect, 4
  %mask1 = and i32 %sub4, -5
  %cond1 = icmp eq i32 %mask1, 0
  br i1 %cond1, label %increment_and_return, label %check_exec

check_exec:                                       ; preds = %after_vquery
  %sub40 = sub i32 %protect, 64
  %mask2 = and i32 %sub40, -65
  %jnz = icmp ne i32 %mask2, 0
  br i1 %jnz, label %need_protect_change, label %increment_and_return

increment_and_return:                             ; preds = %check_exec, %after_vquery
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %oldcnt, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  ret void

need_protect_change:                               ; preds = %check_exec
  %is_readonly = icmp eq i32 %protect, 2
  %baseaddr_ptr = getelementptr inbounds %MEMINFO, %MEMINFO* %buf, i64 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr_ptr, align 8
  %regionsize_ptr = getelementptr inbounds %MEMINFO, %MEMINFO* %buf, i64 0, i32 4
  %regionsize = load i64, i64* %regionsize_ptr, align 8
  %flNewProtect_default = add i32 0, 64
  %flNewProtect_readwrite = add i32 0, 4
  %flNewProtect = select i1 %is_readonly, i32 %flNewProtect_readwrite, i32 %flNewProtect_default
  %entry_plus8 = getelementptr i8, i8* %entry_ptr, i64 8
  %entry_plus8_ptrptr = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr, i8** %entry_plus8_ptrptr, align 8
  %entry_plus16 = getelementptr i8, i8* %entry_ptr, i64 16
  %entry_plus16_i64ptr = bitcast i8* %entry_plus16 to i64*
  store i64 %regionsize, i64* %entry_plus16_i64ptr, align 8
  %entry_i32ptr = bitcast i8* %entry_ptr to i32*
  %vp_ret = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %flNewProtect, i32* %entry_i32ptr)
  %vp_ok = icmp ne i32 %vp_ret, 0
  br i1 %vp_ok, label %increment_and_return, label %vp_failed

vp_failed:                                        ; preds = %need_protect_change
  %gle = call i32 @GetLastError()
  %fmt1 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.vprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %gle)
  br label %start_new

vquery_failed:                                    ; preds = %have_image
  %rdi_plus8 = getelementptr i8, i8* %secptr, i64 8
  %bytes_i32ptr = bitcast i8* %rdi_plus8 to i32*
  %bytes = load i32, i32* %bytes_i32ptr, align 4
  %fmt2 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.vquery, i64 0, i64 0
  %entry_plus24b = getelementptr i8, i8* %entry_ptr, i64 24
  %entry_plus24b_ptrptr = bitcast i8* %entry_plus24b to i8**
  %addr_print = load i8*, i8** %entry_plus24b_ptrptr, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i32 %bytes, i8* %addr_print)
  ret void

no_image:                                         ; preds = %search_notfound
  %fmt3 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.noimage, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3, i8* %addr)
  ret void
}
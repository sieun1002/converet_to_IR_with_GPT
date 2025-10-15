; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

@aVirtualprotect = private unnamed_addr constant [40 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8* noundef) local_unnamed_addr
declare i8* @sub_140002750() local_unnamed_addr
declare void @sub_140001AD0(i8* noundef, ...) local_unnamed_addr

declare dllimport i64 @VirtualQuery(i8* noundef, %MEMORY_BASIC_INFORMATION* noundef, i64 noundef)
declare dllimport i32 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)
declare dllimport i32 @GetLastError()

define void @sub_140001B30(i8* noundef %addr) local_unnamed_addr {
entry:
  %buf = alloca %MEMORY_BASIC_INFORMATION, align 8
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count0, 0
  br i1 %gt0, label %loop_init, label %no_entries

loop_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %ptr0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop_init ], [ %i.next, %advance ]
  %ptr = phi i8* [ %ptr0, %loop_init ], [ %ptr.next, %advance ]
  %elem_baseaddr_ptr = bitcast i8* %ptr to i8**
  %elem_baseaddr = load i8*, i8** %elem_baseaddr_ptr, align 8
  %addr_int = ptrtoint i8* %addr to i64
  %elem_baseaddr_int = ptrtoint i8* %elem_baseaddr to i64
  %cmp_below = icmp ult i64 %addr_int, %elem_baseaddr_int
  br i1 %cmp_below, label %advance, label %check_in_range

check_in_range:
  %ptr_plus8 = getelementptr i8, i8* %ptr, i64 8
  %p2_ptr = bitcast i8* %ptr_plus8 to i8**
  %p2 = load i8*, i8** %p2_ptr, align 8
  %len_ptr_addr = getelementptr i8, i8* %p2, i64 8
  %len_ptr = bitcast i8* %len_ptr_addr to i32*
  %len = load i32, i32* %len_ptr, align 4
  %len64 = zext i32 %len to i64
  %end_int = add i64 %elem_baseaddr_int, %len64
  %cmp_inrange = icmp ult i64 %addr_int, %end_int
  br i1 %cmp_inrange, label %ret, label %advance

advance:
  %i.next = add i32 %i, 1
  %ptr.next = getelementptr i8, i8* %ptr, i64 40
  %cond = icmp ne i32 %i.next, %count0
  br i1 %cond, label %loop, label %no_entries

ret:
  ret void

no_entries:
  %sec = call i8* @sub_140002610(i8* noundef %addr)
  %sec_isnull = icmp eq i8* %sec, null
  br i1 %sec_isnull, label %print_no_section, label %have_section

print_no_section:
  %fmt_np_gep = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt_np_gep, i8* noundef %addr)
  ret void

have_section:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %count1 = load i32, i32* @dword_1400070A4, align 4
  %count64 = sext i32 %count1 to i64
  %offset_bytes = mul nsw i64 %count64, 40
  %elem_start = getelementptr i8, i8* %base1, i64 %offset_bytes
  %oldprot_ptr = bitcast i8* %elem_start to i32*
  store i32 0, i32* %oldprot_ptr, align 4
  %sec_slot_ptr_addr = getelementptr i8, i8* %elem_start, i64 32
  %sec_slot_ptr = bitcast i8* %sec_slot_ptr_addr to i8**
  store i8* %sec, i8** %sec_slot_ptr, align 8
  %mapbase = call i8* @sub_140002750()
  %len2_ptr_addr = getelementptr i8, i8* %sec, i64 12
  %len2_ptr = bitcast i8* %len2_ptr_addr to i32*
  %len2 = load i32, i32* %len2_ptr, align 4
  %len2_64 = zext i32 %len2 to i64
  %secaddr = getelementptr i8, i8* %mapbase, i64 %len2_64
  %elem_addr_field_ptr_pre = getelementptr i8, i8* %elem_start, i64 24
  %elem_addr_field_ptr = bitcast i8* %elem_addr_field_ptr_pre to i8**
  store i8* %secaddr, i8** %elem_addr_field_ptr, align 8
  %vq_res = call i64 @VirtualQuery(i8* noundef %secaddr, %MEMORY_BASIC_INFORMATION* noundef %buf, i64 noundef 48)
  %vq_zero = icmp eq i64 %vq_res, 0
  br i1 %vq_zero, label %vq_fail, label %vq_ok

vq_fail:
  %fmt_vq_gep = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %len_bytes_ptr = getelementptr i8, i8* %sec, i64 8
  %len_bytes_i32_ptr = bitcast i8* %len_bytes_ptr to i32*
  %len_bytes = load i32, i32* %len_bytes_i32_ptr, align 4
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt_vq_gep, i32 noundef %len_bytes, i8* noundef %secaddr)
  ret void

vq_ok:
  %protect_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %buf, i64 0, i32 6
  %protect = load i32, i32* %protect_ptr, align 4
  %tmp1 = sub i32 %protect, 4
  %tmp2 = and i32 %tmp1, -5
  %is_zero1 = icmp eq i32 %tmp2, 0
  br i1 %is_zero1, label %inc_and_ret, label %check_xrw

check_xrw:
  %tmp3 = sub i32 %protect, 64
  %tmp4 = and i32 %tmp3, -65
  %not_zero2 = icmp ne i32 %tmp4, 0
  br i1 %not_zero2, label %need_vprot, label %inc_and_ret

inc_and_ret:
  %oldcount = load i32, i32* @dword_1400070A4, align 4
  %newcount = add i32 %oldcount, 1
  store i32 %newcount, i32* @dword_1400070A4, align 4
  ret void

need_vprot:
  %cmp_ro = icmp eq i32 %protect, 2
  %newprot_sel = select i1 %cmp_ro, i32 4, i32 64
  %baseaddr_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %buf, i64 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr_ptr, align 8
  %regionsize_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %buf, i64 0, i32 4
  %regionsize = load i64, i64* %regionsize_ptr, align 8
  %elem_lpaddr_slot_addr = getelementptr i8, i8* %elem_start, i64 8
  %elem_lpaddr_slot = bitcast i8* %elem_lpaddr_slot_addr to i8**
  store i8* %baseaddr, i8** %elem_lpaddr_slot, align 8
  %elem_size_slot_addr = getelementptr i8, i8* %elem_start, i64 16
  %elem_size_slot = bitcast i8* %elem_size_slot_addr to i64*
  store i64 %regionsize, i64* %elem_size_slot, align 8
  %ok = call i32 @VirtualProtect(i8* noundef %baseaddr, i64 noundef %regionsize, i32 noundef %newprot_sel, i32* noundef %oldprot_ptr)
  %ok_nonzero = icmp ne i32 %ok, 0
  br i1 %ok_nonzero, label %inc_and_ret, label %vp_fail

vp_fail:
  %err = call i32 @GetLastError()
  %fmt_vp_gep = getelementptr inbounds [40 x i8], [40 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt_vp_gep, i32 noundef %err)
  ret void
}
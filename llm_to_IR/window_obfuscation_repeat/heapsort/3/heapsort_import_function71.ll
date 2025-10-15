; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@qword_140008260 = external global i8*

@.str.VirtualProtect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@.str.VirtualQuery = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@.str.NoImage = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i64)
declare i32 @loc_14000EEBA(i8*, i64, i32, i8*)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %mbi = alloca [48 x i8], align 8
  %count0 = load i32, i32* @dword_1400070A4
  %cmp_have = icmp sgt i32 %count0, 0
  br i1 %cmp_have, label %loop_prep, label %no_entries

loop_prep:
  %base1 = load i8*, i8** @qword_1400070A8
  %ptr0 = getelementptr inbounds i8, i8* %base1, i64 24
  br label %loop

loop:
  %idx = phi i32 [ 0, %loop_prep ], [ %idx.next, %loop.inc ]
  %ptr = phi i8* [ %ptr0, %loop_prep ], [ %ptr.next, %loop.inc ]
  %cmp_idx = icmp slt i32 %idx, %count0
  br i1 %cmp_idx, label %loop.body, label %loop.exit

loop.body:
  %start_ptr_ptr = bitcast i8* %ptr to i8**
  %start = load i8*, i8** %start_ptr_ptr
  %addr_int = ptrtoint i8* %addr to i64
  %start_int = ptrtoint i8* %start to i64
  %addr_lt_start = icmp ult i64 %addr_int, %start_int
  br i1 %addr_lt_start, label %loop.inc, label %check_end

check_end:
  %ptr_plus8 = getelementptr inbounds i8, i8* %ptr, i64 8
  %buf_ptr_ptr = bitcast i8* %ptr_plus8 to i8**
  %buf_ptr = load i8*, i8** %buf_ptr_ptr
  %len_field_addr = getelementptr inbounds i8, i8* %buf_ptr, i64 8
  %len32_ptr = bitcast i8* %len_field_addr to i32*
  %len32 = load i32, i32* %len32_ptr
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %addr_before_end = icmp ult i64 %addr_int, %end_int
  br i1 %addr_before_end, label %found, label %loop.inc

loop.inc:
  %idx.next = add i32 %idx, 1
  %ptr.next = getelementptr inbounds i8, i8* %ptr, i64 40
  br label %loop

loop.exit:
  br label %after_search

found:
  ret void

no_entries:
  br label %after_search

after_search:
  %rsi.sel = phi i32 [ 0, %no_entries ], [ %count0, %loop.exit ]
  %desc = call i8* @sub_140002610(i8* %addr)
  %desc_isnull = icmp eq i8* %desc, null
  br i1 %desc_isnull, label %no_image, label %have_desc

no_image:
  %fmt3 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.NoImage, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3, i8* %addr)
  ret void

have_desc:
  %base2 = load i8*, i8** @qword_1400070A8
  %rsi.wide = sext i32 %rsi.sel to i64
  %offset.bytes = mul i64 %rsi.wide, 40
  %entry.ptr = getelementptr inbounds i8, i8* %base2, i64 %offset.bytes
  %ep_20 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %ep_20_cast = bitcast i8* %ep_20 to i8**
  store i8* %desc, i8** %ep_20_cast
  %ep_00_cast = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %ep_00_cast
  %memBase = call i8* @sub_140002750()
  %desc_plus12 = getelementptr inbounds i8, i8* %desc, i64 12
  %desc_plus12_i32p = bitcast i8* %desc_plus12 to i32*
  %edx_val = load i32, i32* %desc_plus12_i32p
  %edx64 = zext i32 %edx_val to i64
  %rcx_ptr = getelementptr inbounds i8, i8* %memBase, i64 %edx64
  %ep_18 = getelementptr inbounds i8, i8* %entry.ptr, i64 24
  %ep_18_cast = bitcast i8* %ep_18 to i8**
  store i8* %rcx_ptr, i8** %ep_18_cast
  %mbi.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %mbi, i64 0, i64 0
  %vqres = call i64 @sub_14001FAD3(i8* %rcx_ptr, i8* %mbi.ptr, i64 48)
  %vq_ok = icmp ne i64 %vqres, 0
  br i1 %vq_ok, label %process_mbi, label %vquery_fail

vquery_fail:
  %desc_plus8 = getelementptr inbounds i8, i8* %desc, i64 8
  %desc_plus8_i32p = bitcast i8* %desc_plus8 to i32*
  %size_bytes_i32 = load i32, i32* %desc_plus8_i32p
  %fmt2 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.VirtualQuery, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i32 %size_bytes_i32, i8* %rcx_ptr)
  ret void

process_mbi:
  %mbi_baseaddr_ptr = bitcast i8* %mbi.ptr to i8**
  %mbi_baseaddr = load i8*, i8** %mbi_baseaddr_ptr
  %region_off = getelementptr inbounds i8, i8* %mbi.ptr, i64 24
  %region_ptr = bitcast i8* %region_off to i64*
  %region_size = load i64, i64* %region_ptr
  %protect_off = getelementptr inbounds i8, i8* %mbi.ptr, i64 36
  %protect_ptr = bitcast i8* %protect_off to i32*
  %protect_val = load i32, i32* %protect_ptr
  %cmp_prot2 = icmp eq i32 %protect_val, 2
  %newprot.sel = select i1 %cmp_prot2, i32 4, i32 64
  %ep_08 = getelementptr inbounds i8, i8* %entry.ptr, i64 8
  %ep_08_cast = bitcast i8* %ep_08 to i8**
  store i8* %mbi_baseaddr, i8** %ep_08_cast
  %ep_10 = getelementptr inbounds i8, i8* %entry.ptr, i64 16
  %ep_10_cast = bitcast i8* %ep_10 to i64*
  store i64 %region_size, i64* %ep_10_cast
  %vp_res = call i32 @loc_14000EEBA(i8* %mbi_baseaddr, i64 %region_size, i32 %newprot.sel, i8* %entry.ptr)
  %vp_ok = icmp ne i32 %vp_res, 0
  br i1 %vp_ok, label %success, label %vp_fail

success:
  %cnt_old = load i32, i32* @dword_1400070A4
  %cnt_new = add i32 %cnt_old, 1
  store i32 %cnt_new, i32* @dword_1400070A4
  ret void

vp_fail:
  %imp = load i8*, i8** @qword_140008260
  %fn = bitcast i8* %imp to i32 ()*
  %err = call i32 %fn()
  %fmt1 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.VirtualProtect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %err)
  ret void
}
; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.MBI = type { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare dso_local i8* @sub_140002610(i8*)
declare dso_local i8* @sub_140002750()
declare dso_local i32 @sub_140001AD0(i8*, ...)
declare dso_local i64 @VirtualQuery(i8*, %struct.MBI*, i64)
declare dso_local i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dso_local i32 @GetLastError()

define dso_local void @sub_140001B30(i8* %addr) {
entry:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cmp = icmp sgt i32 %cnt, 0
  br i1 %cmp, label %loop.init, label %no_entries

loop.init:
  %baseptrp = load i8*, i8** @qword_1400070A8, align 8
  %cur0 = getelementptr inbounds i8, i8* %baseptrp, i64 24
  br label %loop.header

loop.header:
  %idx = phi i32 [ 0, %loop.init ], [ %idx.next, %loop.inc ]
  %cur = phi i8* [ %cur0, %loop.init ], [ %cur.next, %loop.inc ]
  %cond1 = icmp slt i32 %idx, %cnt
  br i1 %cond1, label %loop.body, label %after_loop

loop.body:
  %p_base_ptr = bitcast i8* %cur to i8**
  %baseAddr = load i8*, i8** %p_base_ptr, align 8
  %addr_i = ptrtoint i8* %addr to i64
  %base_i = ptrtoint i8* %baseAddr to i64
  %is_below = icmp ult i64 %addr_i, %base_i
  br i1 %is_below, label %loop.inc, label %check_range

check_range:
  %cur_plus8 = getelementptr inbounds i8, i8* %cur, i64 8
  %p_ptrptr = bitcast i8* %cur_plus8 to i8**
  %p_val = load i8*, i8** %p_ptrptr, align 8
  %p_plus8 = getelementptr inbounds i8, i8* %p_val, i64 8
  %size_ptr = bitcast i8* %p_plus8 to i32*
  %size32 = load i32, i32* %size_ptr, align 4
  %size64 = sext i32 %size32 to i64
  %end_i = add i64 %base_i, %size64
  %addr_lt_end = icmp ult i64 %addr_i, %end_i
  br i1 %addr_lt_end, label %ret, label %loop.inc

loop.inc:
  %idx.next = add i32 %idx, 1
  %cur.next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop.header

ret:
  ret void

after_loop:
  br label %no_entries

no_entries:
  %lookup = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %lookup, null
  br i1 %isnull, label %print_no_image, label %have_lookup

print_no_image:
  %fmt_noimg_ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt_noimg_ptr, i8* %addr)
  ret void

have_lookup:
  %arr_base = load i8*, i8** @qword_1400070A8, align 8
  %cnt64 = sext i32 %cnt to i64
  %offset_bytes = mul i64 %cnt64, 40
  %entry = getelementptr inbounds i8, i8* %arr_base, i64 %offset_bytes
  %entry_plus32 = getelementptr inbounds i8, i8* %entry, i64 32
  %entry_p32_ptr = bitcast i8* %entry_plus32 to i8**
  store i8* %lookup, i8** %entry_p32_ptr, align 8
  %entry_i32_ptr = bitcast i8* %entry to i32*
  store i32 0, i32* %entry_i32_ptr, align 4
  %base2 = call i8* @sub_140002750()
  %lookup_plus12 = getelementptr inbounds i8, i8* %lookup, i64 12
  %val12_ptr = bitcast i8* %lookup_plus12 to i32*
  %val12 = load i32, i32* %val12_ptr, align 4
  %val12_64 = sext i32 %val12 to i64
  %rcx_calc = getelementptr inbounds i8, i8* %base2, i64 %val12_64
  %entry_plus24 = getelementptr inbounds i8, i8* %entry, i64 24
  %entry_p24_ptr = bitcast i8* %entry_plus24 to i8**
  store i8* %rcx_calc, i8** %entry_p24_ptr, align 8
  %mbi = alloca %struct.MBI, align 8
  %resVQ = call i64 @VirtualQuery(i8* %rcx_calc, %struct.MBI* %mbi, i64 48)
  %vq_ok = icmp ne i64 %resVQ, 0
  br i1 %vq_ok, label %vq_success, label %vq_fail

vq_fail:
  %lookup_plus8 = getelementptr inbounds i8, i8* %lookup, i64 8
  %val8_ptr = bitcast i8* %lookup_plus8 to i32*
  %bytes = load i32, i32* %val8_ptr, align 4
  %addr_saved_ptr = bitcast i8* %entry_plus24 to i8**
  %addr_saved = load i8*, i8** %addr_saved_ptr, align 8
  %fmt_vq_ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %call_vq = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt_vq_ptr, i32 %bytes, i8* %addr_saved)
  br label %print_no_image2

print_no_image2:
  %fmt_noimg_ptr2 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt_noimg_ptr2, i8* %addr)
  ret void

vq_success:
  %prot_ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi, i32 0, i32 6
  %protect = load i32, i32* %prot_ptr, align 4
  %is4 = icmp eq i32 %protect, 4
  %is8 = icmp eq i32 %protect, 8
  %is40 = icmp eq i32 %protect, 64
  %is80 = icmp eq i32 %protect, 128
  %ok48 = or i1 %is4, %is8
  %okx = or i1 %is40, %is80
  %ok_any = or i1 %ok48, %okx
  br i1 %ok_any, label %inc_and_ret, label %need_vp

inc_and_ret:
  %cnt_cur = load i32, i32* @dword_1400070A4, align 4
  %cnt_inc = add i32 %cnt_cur, 1
  store i32 %cnt_inc, i32* @dword_1400070A4, align 4
  ret void

need_vp:
  %is2 = icmp eq i32 %protect, 2
  %newprot = select i1 %is2, i32 4, i32 64
  %baseaddr_ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi, i32 0, i32 0
  %baseaddr2 = load i8*, i8** %baseaddr_ptr, align 8
  %regionsize_ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize_ptr, align 8
  %entry_plus8 = getelementptr inbounds i8, i8* %entry, i64 8
  %entry_p8_ptr = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr2, i8** %entry_p8_ptr, align 8
  %entry_plus16 = getelementptr inbounds i8, i8* %entry, i64 16
  %entry_p16_ptr = bitcast i8* %entry_plus16 to i64*
  store i64 %regionsize, i64* %entry_p16_ptr, align 8
  %pdword = bitcast i8* %entry to i32*
  %resVP = call i32 @VirtualProtect(i8* %baseaddr2, i64 %regionsize, i32 %newprot, i32* %pdword)
  %vp_ok = icmp ne i32 %resVP, 0
  br i1 %vp_ok, label %inc_and_ret2, label %vp_fail

inc_and_ret2:
  %cnt_cur2 = load i32, i32* @dword_1400070A4, align 4
  %cnt_inc2 = add i32 %cnt_cur2, 1
  store i32 %cnt_inc2, i32* @dword_1400070A4, align 4
  ret void

vp_fail:
  %err = call i32 @GetLastError()
  %fmt_vp_ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %call_vp = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt_vp_ptr, i32 %err)
  ret void
}
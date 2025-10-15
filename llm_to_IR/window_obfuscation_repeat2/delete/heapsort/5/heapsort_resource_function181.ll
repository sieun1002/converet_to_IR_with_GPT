; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @VirtualQuery(i8*, %MEMORY_BASIC_INFORMATION*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %arg) {
entry:
  %mbi = alloca %MEMORY_BASIC_INFORMATION, align 8
  %nptr = load i32, i32* @dword_1400070A4, align 4
  %n_gt_zero = icmp sgt i32 %nptr, 0
  br i1 %n_gt_zero, label %scan.init, label %c60

scan.init:                                        ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scanBase = getelementptr inbounds i8, i8* %base0, i64 24
  br label %scan.loop

scan.loop:                                        ; preds = %scan.next, %scan.init
  %i = phi i32 [ 0, %scan.init ], [ %i.next, %scan.next ]
  %base1 = phi i8* [ %scanBase, %scan.init ], [ %scanBase, %scan.next ]
  %ncur = phi i32 [ %nptr, %scan.init ], [ %nptr, %scan.next ]
  %i64 = sext i32 %i to i64
  %off_bytes = mul nsw i64 %i64, 40
  %entry_ptr_bytes = getelementptr inbounds i8, i8* %base1, i64 %off_bytes
  %start_ptr_ptr = bitcast i8* %entry_ptr_bytes to i8**
  %start_ptr = load i8*, i8** %start_ptr_ptr, align 8
  %addr_int = ptrtoint i8* %arg to i64
  %start_int = ptrtoint i8* %start_ptr to i64
  %addr_lt_start = icmp ult i64 %addr_int, %start_int
  br i1 %addr_lt_start, label %scan.next, label %check.end

check.end:                                        ; preds = %scan.loop
  %p_ptr_addr = getelementptr inbounds i8, i8* %entry_ptr_bytes, i64 8
  %p_ptr = bitcast i8* %p_ptr_addr to i8**
  %p = load i8*, i8** %p_ptr, align 8
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %len_ptr = bitcast i8* %p_plus8 to i32*
  %len32 = load i32, i32* %len_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %in_range = icmp ult i64 %addr_int, %end_int
  br i1 %in_range, label %early.ret, label %scan.next

scan.next:                                        ; preds = %check.end, %scan.loop
  %i.next = add nsw i32 %i, 1
  %cont = icmp ne i32 %i.next, %ncur
  br i1 %cont, label %scan.loop, label %call.setup.from.scan

early.ret:                                        ; preds = %check.end
  ret void

call.setup.from.scan:                             ; preds = %scan.next
  br label %call.setup

c60:                                              ; preds = %entry, %vp.fail.log
  br label %call.setup

call.setup:                                       ; preds = %c60, %call.setup.from.scan
  %n_for_new = phi i32 [ 0, %c60 ], [ %nptr, %call.setup.from.scan ]
  %cand = call i8* @sub_140002610(i8* %arg)
  %cand_is_null = icmp eq i8* %cand, null
  br i1 %cand_is_null, label %c82, label %alloc.path

alloc.path:                                       ; preds = %call.setup
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %n64 = sext i32 %n_for_new to i64
  %off_new = mul nsw i64 %n64, 40
  %entry_base = getelementptr inbounds i8, i8* %base2, i64 %off_new
  %entry_field20 = getelementptr inbounds i8, i8* %entry_base, i64 32
  %entry_field20_ptr = bitcast i8* %entry_field20 to i8**
  store i8* %cand, i8** %entry_field20_ptr, align 8
  %entry_field0 = bitcast i8* %entry_base to i32*
  store i32 0, i32* %entry_field0, align 4
  %v = call i8* @sub_140002750()
  %cand_plus0xC = getelementptr inbounds i8, i8* %cand, i64 12
  %off32_ptr = bitcast i8* %cand_plus0xC to i32*
  %off32 = load i32, i32* %off32_ptr, align 4
  %off64 = zext i32 %off32 to i64
  %rcxAddr = getelementptr inbounds i8, i8* %v, i64 %off64
  %entry_field18 = getelementptr inbounds i8, i8* %entry_base, i64 24
  %entry_field18_ptr = bitcast i8* %entry_field18 to i8**
  store i8* %rcxAddr, i8** %entry_field18_ptr, align 8
  %vqret = call i64 @VirtualQuery(i8* %rcxAddr, %MEMORY_BASIC_INFORMATION* %mbi, i64 48)
  %vq_zero = icmp eq i64 %vqret, 0
  br i1 %vq_zero, label %c67, label %vq.ok

vq.ok:                                            ; preds = %alloc.path
  %mbi_protect_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 6
  %protect = load i32, i32* %mbi_protect_ptr, align 4
  %t1 = sub i32 %protect, 4
  %t2 = and i32 %t1, -5
  %is_zero1 = icmp eq i32 %t2, 0
  br i1 %is_zero1, label %bfe, label %check2

check2:                                           ; preds = %vq.ok
  %t3 = sub i32 %protect, 64
  %t4 = and i32 %t3, -65
  %not_zero2 = icmp ne i32 %t4, 0
  br i1 %not_zero2, label %c10, label %bfe

bfe:                                              ; preds = %check2, %vq.ok, %vp.ok
  %oldn = load i32, i32* @dword_1400070A4, align 4
  %newn = add i32 %oldn, 1
  store i32 %newn, i32* @dword_1400070A4, align 4
  ret void

c10:                                              ; preds = %check2
  %mbi_base_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %mbi_base = load i8*, i8** %mbi_base_ptr, align 8
  %mbi_region_ptr = getelementptr inbounds %MEMORY_BASIC_INFORMATION, %MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 4
  %mbi_region = load i64, i64* %mbi_region_ptr, align 8
  %cmp_prot_2 = icmp eq i32 %protect, 2
  %fl_if = select i1 %cmp_prot_2, i32 4, i32 64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_base2 = getelementptr inbounds i8, i8* %base3, i64 %off_new
  %entry_field8 = getelementptr inbounds i8, i8* %entry_base2, i64 8
  %entry_field8_ptr = bitcast i8* %entry_field8 to i8**
  store i8* %mbi_base, i8** %entry_field8_ptr, align 8
  %entry_field10 = getelementptr inbounds i8, i8* %entry_base2, i64 16
  %entry_field10_ptr = bitcast i8* %entry_field10 to i64*
  store i64 %mbi_region, i64* %entry_field10_ptr, align 8
  %oldprot_ptr = bitcast i8* %entry_base2 to i32*
  %vp_ret = call i32 @VirtualProtect(i8* %mbi_base, i64 %mbi_region, i32 %fl_if, i32* %oldprot_ptr)
  %vp_ok = icmp ne i32 %vp_ret, 0
  br i1 %vp_ok, label %vp.ok, label %vp.fail

vp.ok:                                            ; preds = %c10
  br label %bfe

vp.fail:                                          ; preds = %c10
  %err = call i32 @GetLastError()
  %fmt_vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_vp, i32 %err)
  br label %vp.fail.log

vp.fail.log:                                      ; preds = %vp.fail
  br label %c60

c67:                                              ; preds = %alloc.path
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry_base3 = getelementptr inbounds i8, i8* %base4, i64 %off_new
  %entry_field18_b = getelementptr inbounds i8, i8* %entry_base3, i64 24
  %entry_field18_b_ptr = bitcast i8* %entry_field18_b to i8**
  %addr_saved = load i8*, i8** %entry_field18_b_ptr, align 8
  %cand_plus8 = getelementptr inbounds i8, i8* %cand, i64 8
  %bytes_ptr = bitcast i8* %cand_plus8 to i32*
  %bytes = load i32, i32* %bytes_ptr, align 4
  %fmt_vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_vq, i32 %bytes, i8* %addr_saved)
  br label %c82

c82:                                              ; preds = %c67, %call.setup
  %fmt_addr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_addr, i8* %arg)
  ret void
}
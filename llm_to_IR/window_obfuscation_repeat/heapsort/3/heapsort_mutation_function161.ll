; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070A8 = external global i8*
@dword_1400070A4 = external global i32

@.str_vprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@.str_vquery = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@.str_noimage = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare dllimport i64 @VirtualQuery(i8*, i8*, i64)
declare dllimport i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dllimport i32 @GetLastError()

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %arg_addr) {
entry:
  %idxVar = alloca i32, align 4
  %buffer = alloca [48 x i8], align 8
  %esi_loaded = load i32, i32* @dword_1400070A4, align 4
  store i32 %esi_loaded, i32* %idxVar, align 4
  %cmp_le = icmp sle i32 %esi_loaded, 0
  br i1 %cmp_le, label %loc_140001C60, label %pre_loop

pre_loop:                                            ; if esi > 0, scan existing entries
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %start_ptr0 = getelementptr i8, i8* %base0, i64 24
  br label %loc_140001B60

loc_140001B60:                                       ; loop over entries
  %i_phi = phi i32 [ 0, %pre_loop ], [ %i_next, %loc_140001B7B ]
  %cur_ptr_phi = phi i8* [ %start_ptr0, %pre_loop ], [ %cur_ptr_next, %loc_140001B7B ]
  %start_load_ptr = bitcast i8* %cur_ptr_phi to i8**
  %start_val = load i8*, i8** %start_load_ptr, align 8
  %arg_int = ptrtoint i8* %arg_addr to i64
  %start_int = ptrtoint i8* %start_val to i64
  %cmp_jb = icmp ult i64 %arg_int, %start_int
  br i1 %cmp_jb, label %loc_140001B7B, label %check_range

check_range:
  %module_ptr_addr = getelementptr i8, i8* %cur_ptr_phi, i64 8
  %module_ptr_ptr = bitcast i8* %module_ptr_addr to i8**
  %module_ptr = load i8*, i8** %module_ptr_ptr, align 8
  %mod_size_field = getelementptr i8, i8* %module_ptr, i64 8
  %mod_size_ptr = bitcast i8* %mod_size_field to i32*
  %mod_size32 = load i32, i32* %mod_size_ptr, align 4
  %mod_size64 = zext i32 %mod_size32 to i64
  %limit_ptr = getelementptr i8, i8* %start_val, i64 %mod_size64
  %limit_int = ptrtoint i8* %limit_ptr to i64
  %cmp_jb2 = icmp ult i64 %arg_int, %limit_int
  br i1 %cmp_jb2, label %loc_140001C05, label %loc_140001B7B

loc_140001B7B:
  %i_next = add i32 %i_phi, 1
  %cur_ptr_next = getelementptr i8, i8* %cur_ptr_phi, i64 40
  %esi_curr = load i32, i32* @dword_1400070A4, align 4
  %cmp_continue = icmp ne i32 %i_next, %esi_curr
  br i1 %cmp_continue, label %loc_140001B60, label %loc_140001B88

loc_140001B88:
  %idx_for_entry = load i32, i32* %idxVar, align 4
  %rdi_call = call i8* @sub_140002610(i8* %arg_addr)
  %rdi_is_null = icmp eq i8* %rdi_call, null
  br i1 %rdi_is_null, label %loc_140001C82, label %after_lookup

after_lookup:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx_for_entry to i64
  %mul5 = mul nsw i64 %idx64, 5
  %offset_bytes = mul nsw i64 %mul5, 8
  %entry_ptr = getelementptr i8, i8* %base1, i64 %offset_bytes
  %entry_ptr_plus20 = getelementptr i8, i8* %entry_ptr, i64 32
  %entry_mod_ptr = bitcast i8* %entry_ptr_plus20 to i8**
  store i8* %rdi_call, i8** %entry_mod_ptr, align 8
  %entry_oldprot_ptr = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_oldprot_ptr, align 4
  %rax_base = call i8* @sub_140002750()
  %rdi_off0C = getelementptr i8, i8* %rdi_call, i64 12
  %rdi_off0C_i32p = bitcast i8* %rdi_off0C to i32*
  %off_val = load i32, i32* %rdi_off0C_i32p, align 4
  %off_val64 = sext i32 %off_val to i64
  %lpAddress = getelementptr i8, i8* %rax_base, i64 %off_val64
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr i8, i8* %base2, i64 %offset_bytes
  %entry_ptr_plus18 = getelementptr i8, i8* %entry_ptr2, i64 24
  %entry_addr_field = bitcast i8* %entry_ptr_plus18 to i8**
  store i8* %lpAddress, i8** %entry_addr_field, align 8
  %buf_ptr = getelementptr [48 x i8], [48 x i8]* %buffer, i32 0, i32 0
  %vq_ret = call i64 @VirtualQuery(i8* %lpAddress, i8* %buf_ptr, i64 48)
  %vq_zero = icmp eq i64 %vq_ret, 0
  br i1 %vq_zero, label %loc_140001C67, label %after_vq

after_vq:
  %protect_off = getelementptr [48 x i8], [48 x i8]* %buffer, i32 0, i32 36
  %protect_i32p = bitcast i8* %protect_off to i32*
  %protect_val = load i32, i32* %protect_i32p, align 4
  %tmp_sub4 = add i32 %protect_val, -4
  %and_mask1 = and i32 %tmp_sub4, -5
  %is_writable1 = icmp eq i32 %and_mask1, 0
  br i1 %is_writable1, label %loc_140001BFE, label %check_execwrite

check_execwrite:
  %tmp_sub40 = add i32 %protect_val, -64
  %and_mask2 = and i32 %tmp_sub40, -65
  %is_writable2 = icmp eq i32 %and_mask2, 0
  br i1 %is_writable2, label %loc_140001BFE, label %loc_140001C10

loc_140001C10:
  %baseaddr_ptr = getelementptr [48 x i8], [48 x i8]* %buffer, i32 0, i32 0
  %baseaddr_valp = bitcast i8* %baseaddr_ptr to i8**
  %baseaddr_val = load i8*, i8** %baseaddr_valp, align 8
  %regionsize_ptr = getelementptr [48 x i8], [48 x i8]* %buffer, i32 0, i32 24
  %regionsize_valp = bitcast i8* %regionsize_ptr to i64*
  %regionsize_val = load i64, i64* %regionsize_valp, align 8
  %flNewProtect_default = add i32 64, 0
  %cmp_ro = icmp eq i32 %protect_val, 2
  %flNewProtect = select i1 %cmp_ro, i32 4, i32 %flNewProtect_default
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr3 = getelementptr i8, i8* %base3, i64 %offset_bytes
  %entry_plus8 = getelementptr i8, i8* %entry_ptr3, i64 8
  %entry_plus8_ptr = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr_val, i8** %entry_plus8_ptr, align 8
  %entry_plus10 = getelementptr i8, i8* %entry_ptr3, i64 16
  %entry_plus10_ptr = bitcast i8* %entry_plus10 to i64*
  store i64 %regionsize_val, i64* %entry_plus10_ptr, align 8
  %oldprot_ptr = bitcast i8* %entry_ptr3 to i32*
  %vp_ok = call i32 @VirtualProtect(i8* %baseaddr_val, i64 %regionsize_val, i32 %flNewProtect, i32* %oldprot_ptr)
  %vp_nonzero = icmp ne i32 %vp_ok, 0
  br i1 %vp_nonzero, label %loc_140001BFE, label %vp_fail

vp_fail:
  %last_err = call i32 @GetLastError()
  %fmt1_ptr = getelementptr [39 x i8], [39 x i8]* @.str_vprotect, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt1_ptr, i32 %last_err)
  br label %loc_140001C60

loc_140001C60:
  store i32 0, i32* %idxVar, align 4
  br label %loc_140001B88

loc_140001C67:
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %rdi_off8 = getelementptr i8, i8* %rdi_call, i64 8
  %rdi_off8_i32p = bitcast i8* %rdi_off8 to i32*
  %bytes_val = load i32, i32* %rdi_off8_i32p, align 4
  %entry_ptr4 = getelementptr i8, i8* %base4, i64 %offset_bytes
  %entry_plus18_2 = getelementptr i8, i8* %entry_ptr4, i64 24
  %entry_plus18_ptr2 = bitcast i8* %entry_plus18_2 to i8**
  %addr_logged = load i8*, i8** %entry_plus18_ptr2, align 8
  %fmt2_ptr = getelementptr [49 x i8], [49 x i8]* @.str_vquery, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt2_ptr, i32 %bytes_val, i8* %addr_logged)
  br label %loc_140001C82

loc_140001C82:
  %fmt3_ptr = getelementptr [32 x i8], [32 x i8]* @.str_noimage, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt3_ptr, i8* %arg_addr)
  ret void

loc_140001BFE:
  %count_old = load i32, i32* @dword_1400070A4, align 4
  %count_new = add i32 %count_old, 1
  store i32 %count_new, i32* @dword_1400070A4, align 4
  br label %loc_140001C05

loc_140001C05:
  ret void
}
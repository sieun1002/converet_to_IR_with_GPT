; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140612B3A(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %rcx) {
entry:
  %count32 = load i32, i32* @dword_1400070A4
  %cmp_le = icmp sle i32 %count32, 0
  br i1 %cmp_le, label %no_entries, label %has_entries

has_entries:                                         ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8
  %entry_ptr0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:                                                ; preds = %not_inside, %has_entries
  %loop_entry_ptr = phi i8* [ %entry_ptr0, %has_entries ], [ %entry_ptr_next, %not_inside ]
  %idx = phi i32 [ 0, %has_entries ], [ %idx_next, %not_inside ]
  %ptr_to_base_field = bitcast i8* %loop_entry_ptr to i8**
  %r8_load = load i8*, i8** %ptr_to_base_field
  %param_int = ptrtoint i8* %rcx to i64
  %r8_int = ptrtoint i8* %r8_load to i64
  %cmp_jb_base = icmp ult i64 %param_int, %r8_int
  br i1 %cmp_jb_base, label %not_inside, label %check_inside

check_inside:                                        ; preds = %loop
  %ptr_to_second_field_addr = getelementptr i8, i8* %loop_entry_ptr, i64 8
  %ptr_to_second_field = bitcast i8* %ptr_to_second_field_addr to i8**
  %second_ptr = load i8*, i8** %ptr_to_second_field
  %size_addr_i8 = getelementptr i8, i8* %second_ptr, i64 8
  %size_addr_i32 = bitcast i8* %size_addr_i8 to i32*
  %size32 = load i32, i32* %size_addr_i32
  %size64 = zext i32 %size32 to i64
  %end_int = add i64 %r8_int, %size64
  %cmp_jb_end = icmp ult i64 %param_int, %end_int
  br i1 %cmp_jb_end, label %early_return, label %not_inside

not_inside:                                          ; preds = %check_inside, %loop
  %idx_next = add i32 %idx, 1
  %entry_ptr_next = getelementptr i8, i8* %loop_entry_ptr, i64 40
  %cmp_nz = icmp ne i32 %idx_next, %count32
  br i1 %cmp_nz, label %loop, label %call_sub_from_loop

no_entries:                                          ; preds = %entry
  br label %call_sub_from_no

call_sub_from_no:                                    ; preds = %no_entries
  br label %call_sub_join

call_sub_from_loop:                                  ; preds = %not_inside
  br label %call_sub_join

call_sub_join:                                       ; preds = %call_sub_from_loop, %call_sub_from_no
  %used_count = phi i32 [ 0, %call_sub_from_no ], [ %count32, %call_sub_from_loop ]
  %rdi = call i8* @sub_140002250(i8* %rcx)
  %rdi_is_null = icmp eq i8* %rdi, null
  br i1 %rdi_is_null, label %error_path, label %success_path

error_path:                                          ; preds = %call_sub_join
  %fmt_ptr = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %fmt_ptr, i8* %rcx)
  br label %ret

success_path:                                        ; preds = %call_sub_join
  %base1 = load i8*, i8** @qword_1400070A8
  %used_count_sext = sext i32 %used_count to i64
  %offset_bytes = mul i64 %used_count_sext, 40
  %entry_base_ptr = getelementptr i8, i8* %base1, i64 %offset_bytes
  %field_20_addr_i8 = getelementptr i8, i8* %entry_base_ptr, i64 32
  %field_20_addr = bitcast i8* %field_20_addr_i8 to i8**
  store i8* %rdi, i8** %field_20_addr
  %field_00_addr = bitcast i8* %entry_base_ptr to i32*
  store i32 0, i32* %field_00_addr
  %retbase = call i8* @sub_140002390()
  %rdi_off_0C_i8 = getelementptr i8, i8* %rdi, i64 12
  %rdi_off_0C_i32p = bitcast i8* %rdi_off_0C_i8 to i32*
  %edx_val = load i32, i32* %rdi_off_0C_i32p
  %edx_zext = zext i32 %edx_val to i64
  %rcx_ptr = getelementptr i8, i8* %retbase, i64 %edx_zext
  %base2 = load i8*, i8** @qword_1400070A8
  %field_18_addr_i8_base = getelementptr i8, i8* %base2, i64 %offset_bytes
  %field_18_addr_i8 = getelementptr i8, i8* %field_18_addr_i8_base, i64 24
  %field_18_addr = bitcast i8* %field_18_addr_i8 to i8**
  store i8* %rcx_ptr, i8** %field_18_addr
  %buf = alloca [48 x i8], align 1
  %buf_ptr = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  call void @sub_140612B3A(i8* %rcx_ptr, i8* %buf_ptr, i32 48)
  br label %ret

early_return:                                        ; preds = %check_inside
  br label %ret

ret:                                                 ; preds = %early_return, %success_path, %error_path
  ret void
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32, align 4
@qword_1400070A8 = external dso_local global i8*, align 8
@aVirtualprotect = external dso_local constant i8, align 1
@aAddressPHasNoI = external dso_local constant i8, align 1

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local void @sub_140001700(i8*, ...)
declare dso_local i32 @loc_140012A4E(i8*, i8*, i64)
declare dso_local i32 @loc_1400D1740(i8*, i64, i32, i8*)

define dso_local void @sub_140001760(i8* %rcx) {
entry:
  %mem = alloca { i64, i64 }, align 8
  %dword = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %dword, 0
  br i1 %gt0, label %loop_setup, label %no_match_from_zero

loop_setup:                                       ; preds = %entry
  %arr = load i8*, i8** @qword_1400070A8, align 8
  %cell0 = getelementptr inbounds i8, i8* %arr, i64 24
  br label %loop

loop:                                             ; preds = %inc, %loop_setup
  %cell = phi i8* [ %cell0, %loop_setup ], [ %cell_next, %inc ]
  %idx = phi i32 [ 0, %loop_setup ], [ %idx_next, %inc ]
  %cell_as_ptrptr = bitcast i8* %cell to i8**
  %first_ptr = load i8*, i8** %cell_as_ptrptr, align 8
  %rcx_i64 = ptrtoint i8* %rcx to i64
  %first_i64 = ptrtoint i8* %first_ptr to i64
  %is_before = icmp ult i64 %rcx_i64, %first_i64
  br i1 %is_before, label %inc, label %check_range

check_range:                                      ; preds = %loop
  %gep8 = getelementptr inbounds i8, i8* %cell, i64 8
  %field_ptrptr = bitcast i8* %gep8 to i8**
  %ptr_loaded = load i8*, i8** %field_ptrptr, align 8
  %ptr_plus8 = getelementptr inbounds i8, i8* %ptr_loaded, i64 8
  %ptr_plus8_i32ptr = bitcast i8* %ptr_plus8 to i32*
  %len32 = load i32, i32* %ptr_plus8_i32ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_i64 = add i64 %first_i64, %len64
  %in_range = icmp ult i64 %rcx_i64, %end_i64
  br i1 %in_range, label %ret, label %inc

inc:                                              ; preds = %check_range, %loop
  %idx_next = add i32 %idx, 1
  %cell_next = getelementptr inbounds i8, i8* %cell, i64 40
  %not_done = icmp ne i32 %idx_next, %dword
  br i1 %not_done, label %loop, label %no_match

no_match_from_zero:                               ; preds = %entry
  br label %no_match

no_match:                                         ; preds = %inc, %no_match_from_zero
  %idx_final = phi i32 [ 0, %no_match_from_zero ], [ %dword, %inc ]
  %image = call i8* @sub_140002250(i8* %rcx)
  %noimg = icmp eq i8* %image, null
  br i1 %noimg, label %has_no_image, label %prepare

prepare:                                          ; preds = %no_match
  %arr2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx_final to i64
  %mul5 = mul i64 %idx64, 5
  %offset = shl i64 %mul5, 3
  %cell_base = getelementptr inbounds i8, i8* %arr2, i64 %offset
  %ptr_field_addr = getelementptr inbounds i8, i8* %cell_base, i64 32
  %ptr_field_ptr = bitcast i8* %ptr_field_addr to i8**
  store i8* %image, i8** %ptr_field_ptr, align 8
  %status_ptr = bitcast i8* %cell_base to i32*
  store i32 0, i32* %status_ptr, align 4
  %heap = call i8* @sub_140002390()
  %image_off12 = getelementptr inbounds i8, i8* %image, i64 12
  %rel_off_ptr = bitcast i8* %image_off12 to i32*
  %rel_off = load i32, i32* %rel_off_ptr, align 4
  %rel_off_z = zext i32 %rel_off to i64
  %base_plus = getelementptr inbounds i8, i8* %heap, i64 %rel_off_z
  %dest_ptr_addr = getelementptr inbounds i8, i8* %cell_base, i64 24
  %dest_ptr_ptr = bitcast i8* %dest_ptr_addr to i8**
  store i8* %base_plus, i8** %dest_ptr_ptr, align 8
  %mem_i8 = bitcast { i64, i64 }* %mem to i8*
  %copied = call i32 @loc_140012A4E(i8* %base_plus, i8* %mem_i8, i64 48)
  %mem_first_ptr = getelementptr inbounds { i64, i64 }, { i64, i64 }* %mem, i32 0, i32 0
  %mem_second_ptr = getelementptr inbounds { i64, i64 }, { i64, i64 }* %mem, i32 0, i32 1
  %mem_first = load i64, i64* %mem_first_ptr, align 8
  %mem_second = load i64, i64* %mem_second_ptr, align 8
  %is_two = icmp eq i32 %copied, 2
  %prot = select i1 %is_two, i32 4, i32 64
  %arr3 = load i8*, i8** @qword_1400070A8, align 8
  %cell_base_again = getelementptr inbounds i8, i8* %arr3, i64 %offset
  %cell_base_plus8 = getelementptr inbounds i8, i8* %cell_base_again, i64 8
  %cell_base_plus8_i64ptr = bitcast i8* %cell_base_plus8 to i64*
  store i64 %mem_first, i64* %cell_base_plus8_i64ptr, align 8
  %cell_base_plus16 = getelementptr inbounds i8, i8* %cell_base_again, i64 16
  %cell_base_plus16_i64ptr = bitcast i8* %cell_base_plus16 to i64*
  store i64 %mem_second, i64* %cell_base_plus16_i64ptr, align 8
  %addr_as_ptr = inttoptr i64 %mem_first to i8*
  %vp_res = call i32 @loc_1400D1740(i8* %addr_as_ptr, i64 %mem_second, i32 %prot, i8* %cell_base_again)
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %vp_res)
  br label %ret

has_no_image:                                     ; preds = %no_match
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %rcx)
  br label %ret

ret:                                              ; preds = %prepare, %has_no_image, %check_range
  ret void
}
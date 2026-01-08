; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@aAddressPHasNoI = internal unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define dso_local void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %var48 = alloca [48 x i8], align 8
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_le0 = icmp sle i32 %cnt, 0
  br i1 %cnt_le0, label %noentries, label %scan_init

scan_init:                                        ; preds = %entry
  %base = load i8*, i8** @qword_1400070A8, align 8
  %first_ptr = getelementptr inbounds i8, i8* %base, i64 24
  br label %loop

loop:                                             ; preds = %after_next, %scan_init
  %ptr = phi i8* [ %first_ptr, %scan_init ], [ %next_ptr, %after_next ]
  %i = phi i32 [ 0, %scan_init ], [ %i_next, %after_next ]
  %p_as_i8pp = bitcast i8* %ptr to i8**
  %entry_addr = load i8*, i8** %p_as_i8pp, align 8
  %rcx_i = ptrtoint i8* %rcx to i64
  %entry_i = ptrtoint i8* %entry_addr to i64
  %before = icmp ult i64 %rcx_i, %entry_i
  br i1 %before, label %after_next, label %check_end

check_end:                                        ; preds = %loop
  %p_plus8 = getelementptr inbounds i8, i8* %ptr, i64 8
  %p_plus8_as_ptr = bitcast i8* %p_plus8 to i8**
  %secptr = load i8*, i8** %p_plus8_as_ptr, align 8
  %len_field_ptr_i8 = getelementptr inbounds i8, i8* %secptr, i64 8
  %len_field_ptr = bitcast i8* %len_field_ptr_i8 to i32*
  %len = load i32, i32* %len_field_ptr, align 4
  %len64 = zext i32 %len to i64
  %base_i = ptrtoint i8* %entry_addr to i64
  %end = add i64 %base_i, %len64
  %inrange = icmp ult i64 %rcx_i, %end
  br i1 %inrange, label %found_return, label %after_next

after_next:                                       ; preds = %check_end, %loop
  %i_next = add i32 %i, 1
  %next_ptr = getelementptr inbounds i8, i8* %ptr, i64 40
  %cont = icmp ne i32 %i_next, %cnt
  br i1 %cont, label %loop, label %notfound_path_from_loop

found_return:                                     ; preds = %check_end
  ret void

noentries:                                        ; preds = %entry
  br label %notfound_entry

notfound_path_from_loop:                          ; preds = %after_next
  br label %notfound_entry

notfound_entry:                                   ; preds = %notfound_path_from_loop, %noentries
  %esi_final = phi i32 [ 0, %noentries ], [ %cnt, %notfound_path_from_loop ]
  %sec = call i8* @sub_140002250(i8* %rcx)
  %isnull = icmp eq i8* %sec, null
  br i1 %isnull, label %print_error, label %continue_update

continue_update:                                  ; preds = %notfound_entry
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %esi_final to i64
  %mul5 = mul i64 %idx64, 5
  %offset = shl i64 %mul5, 3
  %slot = getelementptr inbounds i8, i8* %base2, i64 %offset
  %slot_plus32 = getelementptr inbounds i8, i8* %slot, i64 32
  %slot_field_ptr = bitcast i8* %slot_plus32 to i8**
  store i8* %sec, i8** %slot_field_ptr, align 8
  %slot_as_i32 = bitcast i8* %slot to i32*
  store i32 0, i32* %slot_as_i32, align 4
  %buf = call i8* @sub_140002390()
  %sec_plus12 = getelementptr inbounds i8, i8* %sec, i64 12
  %sec_len_ptr = bitcast i8* %sec_plus12 to i32*
  %sec_len = load i32, i32* %sec_len_ptr, align 4
  %sec_len64 = zext i32 %sec_len to i64
  %buf_plus_len = getelementptr inbounds i8, i8* %buf, i64 %sec_len64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %slot2 = getelementptr inbounds i8, i8* %base3, i64 %offset
  %slot2_plus24 = getelementptr inbounds i8, i8* %slot2, i64 24
  %slot2_field = bitcast i8* %slot2_plus24 to i8**
  store i8* %buf_plus_len, i8** %slot2_field, align 8
  %tmpbuf = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_14000CFBC(i8* %buf_plus_len, i8* %tmpbuf, i32 48)
  ret void

print_error:                                      ; preds = %notfound_entry
  %msg = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %msg, i8* %rcx)
  ret void
}
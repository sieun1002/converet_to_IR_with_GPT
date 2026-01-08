; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = internal constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %rcx) {
entry:
  %var48 = alloca [48 x i8], align 8
  %cnt_i32 = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %cnt_i32, 0
  br i1 %cmp_le, label %not_found_call, label %loop_init

loop_init:
  %baseptr = load i8*, i8** @qword_1400070A8, align 8
  %scanptr = getelementptr i8, i8* %baseptr, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop_init ], [ %i.next, %loop_increment ]
  %ptr = phi i8* [ %scanptr, %loop_init ], [ %ptr.next, %loop_increment ]
  %start_ptr_ptr = bitcast i8* %ptr to i8**
  %start = load i8*, i8** %start_ptr_ptr, align 8
  %rbx_ult_start = icmp ult i8* %rcx, %start
  br i1 %rbx_ult_start, label %loop_increment, label %check_size

check_size:
  %ptr_plus8 = getelementptr i8, i8* %ptr, i64 8
  %hdr_ptr_ptr = bitcast i8* %ptr_plus8 to i8**
  %hdr = load i8*, i8** %hdr_ptr_ptr, align 8
  %size_ptr = getelementptr i8, i8* %hdr, i64 8
  %size_i32_ptr = bitcast i8* %size_ptr to i32*
  %size_i32 = load i32, i32* %size_i32_ptr, align 4
  %size_zext = zext i32 %size_i32 to i64
  %end = getelementptr i8, i8* %start, i64 %size_zext
  %in_range = icmp ult i8* %rcx, %end
  br i1 %in_range, label %found_return, label %loop_increment

loop_increment:
  %i.next = add i32 %i, 1
  %ptr.next = getelementptr i8, i8* %ptr, i64 40
  %more = icmp ne i32 %i.next, %cnt_i32
  br i1 %more, label %loop, label %not_found_call

found_return:
  ret void

not_found_call:
  %count_for_index = phi i32 [ 0, %entry ], [ %cnt_i32, %loop_increment ]
  %rdi = call i8* @sub_140002250(i8* %rcx)
  %is_null = icmp eq i8* %rdi, null
  br i1 %is_null, label %error, label %after_alloc

after_alloc:
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %count64 = sext i32 %count_for_index to i64
  %times5 = mul i64 %count64, 5
  %offset_elems = mul i64 %times5, 8
  %slot_ptr = getelementptr i8, i8* %base2, i64 %offset_elems
  %ptr_plus20 = getelementptr i8, i8* %slot_ptr, i64 32
  %field20_ptr = bitcast i8* %ptr_plus20 to i8**
  store i8* %rdi, i8** %field20_ptr, align 8
  %field0_ptr = bitcast i8* %slot_ptr to i32*
  store i32 0, i32* %field0_ptr, align 4
  %tmp = call i8* @sub_140002390()
  %rdi_plus_c = getelementptr i8, i8* %rdi, i64 12
  %edx_ptr = bitcast i8* %rdi_plus_c to i32*
  %edx_val = load i32, i32* %edx_ptr, align 4
  %edx_z = zext i32 %edx_val to i64
  %rcx_ptr2 = getelementptr i8, i8* %tmp, i64 %edx_z
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %rdx_ptr = getelementptr [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  %slot_plus18 = getelementptr i8, i8* %base3, i64 %offset_elems
  %slot_plus18b = getelementptr i8, i8* %slot_plus18, i64 24
  %field18_ptr = bitcast i8* %slot_plus18b to i8**
  store i8* %rcx_ptr2, i8** %field18_ptr, align 8
  call void @sub_14000CFBC(i8* %rcx_ptr2, i8* %rdx_ptr, i32 48)
  ret void

error:
  %msg_ptr = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %msg_ptr, i8* %rcx)
  ret void
}
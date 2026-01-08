; ModuleID = 'sub_140001760_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %addr) {
entry:
  %buf = alloca [48 x i8], align 16
  %buf_i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %nonpos = icmp sle i32 %count32, 0
  br i1 %nonpos, label %after_loop_prep, label %loop_entry_prep

loop_entry_prep:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %base_scan = getelementptr inbounds i8, i8* %base0, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop_entry_prep ], [ %i_next, %loop_continue ]
  %i64 = sext i32 %i to i64
  %off_bytes = mul i64 %i64, 40
  %entry_scan = getelementptr inbounds i8, i8* %base_scan, i64 %off_bytes
  %ptrptr = bitcast i8* %entry_scan to i8**
  %start = load i8*, i8** %ptrptr, align 8
  %addr_i64 = ptrtoint i8* %addr to i64
  %start_i64 = ptrtoint i8* %start to i64
  %below = icmp ult i64 %addr_i64, %start_i64
  br i1 %below, label %loop_continue, label %check_end

check_end:
  %entry_plus8 = getelementptr inbounds i8, i8* %entry_scan, i64 8
  %pptr = bitcast i8* %entry_plus8 to i8**
  %p = load i8*, i8** %pptr, align 8
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %sizeptr = bitcast i8* %p_plus8 to i32*
  %size32 = load i32, i32* %sizeptr, align 4
  %size64 = zext i32 %size32 to i64
  %end_i64 = add i64 %start_i64, %size64
  %inrange = icmp ult i64 %addr_i64, %end_i64
  br i1 %inrange, label %return_void, label %loop_continue

loop_continue:
  %i_next = add i32 %i, 1
  %cont = icmp slt i32 %i_next, %count32
  br i1 %cont, label %loop, label %not_found_after_loop

return_void:
  ret void

after_loop_prep:
  br label %after_loop_path

not_found_after_loop:
  br label %after_loop_path

after_loop_path:
  %idx = phi i32 [ 0, %after_loop_prep ], [ %count32, %not_found_after_loop ]
  %base0_2 = load i8*, i8** @qword_1400070A8, align 8
  %newptr = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %newptr, null
  br i1 %isnull, label %error, label %setup_new

error:
  %fmtptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %fmtptr, i8* %addr)
  ret void

setup_new:
  %idx64 = sext i32 %idx to i64
  %entry_off = mul i64 %idx64, 40
  %entry_ptr = getelementptr inbounds i8, i8* %base0_2, i64 %entry_off
  %field20 = getelementptr inbounds i8, i8* %entry_ptr, i64 32
  %field20_ptr = bitcast i8* %field20 to i8**
  store i8* %newptr, i8** %field20_ptr, align 8
  %field0_ptr = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %field0_ptr, align 4
  %base2 = call i8* @sub_140002390()
  %newptr_plusC = getelementptr inbounds i8, i8* %newptr, i64 12
  %off_ptr = bitcast i8* %newptr_plusC to i32*
  %off32 = load i32, i32* %off_ptr, align 4
  %off64z = zext i32 %off32 to i64
  %rcx_ptr = getelementptr inbounds i8, i8* %base2, i64 %off64z
  %field18_base = getelementptr inbounds i8, i8* %base0_2, i64 %entry_off
  %field18 = getelementptr inbounds i8, i8* %field18_base, i64 24
  %field18_ptr = bitcast i8* %field18 to i8**
  store i8* %rcx_ptr, i8** %field18_ptr, align 8
  call void @sub_14000CFBC(i8* %rcx_ptr, i8* %buf_i8, i32 48)
  ret void
}
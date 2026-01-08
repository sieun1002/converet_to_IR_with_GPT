; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140612B3A(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %addr) local_unnamed_addr {
entry:
  %var48 = alloca [48 x i8], align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %count32, 0
  br i1 %pos, label %loop_pre, label %cnt_nonpos

loop_pre:                                         ; preds = %entry
  %base_a = load i8*, i8** @qword_1400070A8, align 8
  %start = getelementptr inbounds i8, i8* %base_a, i64 24
  br label %loop_header

loop_header:                                      ; preds = %loop_inc, %loop_pre
  %idx_phi = phi i32 [ 0, %loop_pre ], [ %idx_next, %loop_inc ]
  %scan_phi = phi i8* [ %start, %loop_pre ], [ %scan_next, %loop_inc ]
  %cond = icmp slt i32 %idx_phi, %count32
  br i1 %cond, label %test, label %loop_exit

test:                                             ; preds = %loop_header
  %p_r8_ptr = bitcast i8* %scan_phi to i8**
  %r8val = load i8*, i8** %p_r8_ptr, align 8
  %cmp1 = icmp ult i8* %addr, %r8val
  br i1 %cmp1, label %loop_inc, label %after_cmp1

after_cmp1:                                       ; preds = %test
  %plus8 = getelementptr inbounds i8, i8* %scan_phi, i64 8
  %ptr2 = bitcast i8* %plus8 to i8**
  %rdxptr = load i8*, i8** %ptr2, align 8
  %rdx_plus8 = getelementptr inbounds i8, i8* %rdxptr, i64 8
  %size_ptr = bitcast i8* %rdx_plus8 to i32*
  %size = load i32, i32* %size_ptr, align 4
  %size64 = zext i32 %size to i64
  %end = getelementptr inbounds i8, i8* %r8val, i64 %size64
  %cmp2 = icmp ult i8* %addr, %end
  br i1 %cmp2, label %found_ret, label %loop_inc

loop_inc:                                         ; preds = %after_cmp1, %test
  %idx_next = add i32 %idx_phi, 1
  %scan_next = getelementptr inbounds i8, i8* %scan_phi, i64 40
  br label %loop_header

found_ret:                                        ; preds = %after_cmp1
  ret void

loop_exit:                                        ; preds = %loop_header
  br label %create_path_init

cnt_nonpos:                                       ; preds = %entry
  br label %create_path_init

create_path_init:                                 ; preds = %cnt_nonpos, %loop_exit
  %ins_idx = phi i32 [ 0, %cnt_nonpos ], [ %count32, %loop_exit ]
  %call1 = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %call1, null
  br i1 %isnull, label %err_path, label %have_rdi

have_rdi:                                         ; preds = %create_path_init
  %base_b = load i8*, i8** @qword_1400070A8, align 8
  %ins_idx64 = zext i32 %ins_idx to i64
  %mul40 = mul i64 %ins_idx64, 40
  %entry.ptr = getelementptr inbounds i8, i8* %base_b, i64 %mul40
  %off20 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %off20_ptr = bitcast i8* %off20 to i8**
  store i8* %call1, i8** %off20_ptr, align 8
  %entry_i32 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry_i32, align 4
  %call2 = call i8* @sub_140002390()
  %rdi_plus_c = getelementptr inbounds i8, i8* %call1, i64 12
  %edx_ptr = bitcast i8* %rdi_plus_c to i32*
  %edx_val = load i32, i32* %edx_ptr, align 4
  %edx64 = zext i32 %edx_val to i64
  %rcxval = getelementptr inbounds i8, i8* %call2, i64 %edx64
  %base_c = load i8*, i8** @qword_1400070A8, align 8
  %entry_c = getelementptr inbounds i8, i8* %base_c, i64 %mul40
  %off18 = getelementptr inbounds i8, i8* %entry_c, i64 24
  %off18_ptr = bitcast i8* %off18 to i8**
  store i8* %rcxval, i8** %off18_ptr, align 8
  %var48_ptr = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_140612B3A(i8* %rcxval, i8* %var48_ptr, i32 48)
  ret void

err_path:                                         ; preds = %create_path_init
  %fmt_ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %fmt_ptr, i8* %addr)
  ret void
}
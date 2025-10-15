; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count0, 0
  br i1 %gt0, label %loop_init, label %need

loop_init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %entrybase = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:
  %idx = phi i32 [ 0, %loop_init ], [ %idx.next, %loop_continue ]
  %ptr = phi i8* [ %entrybase, %loop_init ], [ %ptr.next, %loop_continue ]
  %pBasePtr = bitcast i8* %ptr to i8**
  %regBase = load i8*, i8** %pBasePtr, align 8
  %addr_i = ptrtoint i8* %addr to i64
  %regBase_i = ptrtoint i8* %regBase to i64
  %addr_lt_base = icmp ult i64 %addr_i, %regBase_i
  br i1 %addr_lt_base, label %loop_continue, label %check_end

loop_continue:
  %idx.next = add i32 %idx, 1
  %cmpl = icmp slt i32 %idx.next, %count0
  %ptr.next = getelementptr i8, i8* %ptr, i64 40
  br i1 %cmpl, label %loop, label %need_prep

check_end:
  %pPtrPtrI8 = getelementptr i8, i8* %ptr, i64 8
  %pPtrPtr = bitcast i8* %pPtrPtrI8 to i8**
  %pStruct = load i8*, i8** %pPtrPtr, align 8
  %lenptri8 = getelementptr i8, i8* %pStruct, i64 8
  %lenptri32 = bitcast i8* %lenptri8 to i32*
  %len32 = load i32, i32* %lenptri32, align 4
  %len64 = sext i32 %len32 to i64
  %endptr = getelementptr i8, i8* %regBase, i64 %len64
  %end_i = ptrtoint i8* %endptr to i64
  %addr_lt_end = icmp ult i64 %addr_i, %end_i
  br i1 %addr_lt_end, label %ret, label %loop_continue

need_prep:
  br label %need

need:
  %newIdx = phi i32 [ 0, %entry ], [ %count0, %need_prep ]
  %info = call i8* @sub_140002610(i8* %addr)
  %info_isnull = icmp eq i8* %info, null
  br i1 %info_isnull, label %no_image, label %have_info

have_info:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %newIdx64 = sext i32 %newIdx to i64
  %mul = mul i64 %newIdx64, 40
  %entryptr = getelementptr i8, i8* %base1, i64 %mul
  %off20 = getelementptr i8, i8* %entryptr, i64 32
  %off20ptr = bitcast i8* %off20 to i8**
  store i8* %info, i8** %off20ptr, align 8
  %entryi32ptr = bitcast i8* %entryptr to i32*
  store i32 0, i32* %entryi32ptr, align 4
  %base2 = call i8* @sub_140002750()
  %info_offC_i8 = getelementptr i8, i8* %info, i64 12
  %info_offC_ptr = bitcast i8* %info_offC_i8 to i32*
  %offC = load i32, i32* %info_offC_ptr, align 4
  %offC64 = sext i32 %offC to i64
  %rcx_ptr = getelementptr i8, i8* %base2, i64 %offC64
  %store_base = load i8*, i8** @qword_1400070A8, align 8
  %entryptr2 = getelementptr i8, i8* %store_base, i64 %mul
  %off18 = getelementptr i8, i8* %entryptr2, i64 24
  %off18ptr = bitcast i8* %off18 to i8**
  store i8* %rcx_ptr, i8** %off18ptr, align 8
  %mbi = alloca [64 x i8], align 16
  %mbi_ptr0 = getelementptr [64 x i8], [64 x i8]* %mbi, i64 0, i64 0
  %callvq = call i64 @sub_14001FAD3(i8* %rcx_ptr, i8* %mbi_ptr0, i32 48)
  %success = icmp ne i64 %callvq, 0
  br i1 %success, label %inc_and_ret, label %vq_fail

inc_and_ret:
  %oldcount2 = load i32, i32* @dword_1400070A4, align 4
  %newcount2 = add i32 %oldcount2, 1
  store i32 %newcount2, i32* @dword_1400070A4, align 4
  br label %ret

vq_fail:
  %info_off8_i8 = getelementptr i8, i8* %info, i64 8
  %info_off8_ptr = bitcast i8* %info_off8_i8 to i32*
  %bytes = load i32, i32* %info_off8_ptr, align 4
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entryptr3 = getelementptr i8, i8* %base3, i64 %mul
  %off18b = getelementptr i8, i8* %entryptr3, i64 24
  %off18bptr = bitcast i8* %off18b to i8**
  %addr_stored = load i8*, i8** %off18bptr, align 8
  %fmt1 = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %bytes, i8* %addr_stored)
  br label %ret

no_image:
  %fmt2 = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i8* %addr)
  br label %ret

ret:
  ret void
}
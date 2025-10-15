; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070A8 = external global i8*
@dword_1400070A4 = external global i32
@qword_140008260 = external global i32 ()*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare i32 @loc_14000EEBA(i8*, i64, i32, i8*)
declare i32 @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %rcx0) {
entry:
  %addr = alloca i8*, align 8
  store i8* %rcx0, i8** %addr, align 8
  %addr.load = load i8*, i8** %addr, align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %hasEntries = icmp sgt i32 %count32, 0
  br i1 %hasEntries, label %loop.init, label %alloc_pre

loop.init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %ptr0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:
  %idx = phi i32 [ 0, %loop.init ], [ %idx.next, %loop.next ]
  %ptr = phi i8* [ %ptr0, %loop.init ], [ %ptr.next, %loop.next ]
  %field0ptr = bitcast i8* %ptr to i8**
  %r8ptr = load i8*, i8** %field0ptr, align 8
  %addr_i = ptrtoint i8* %addr.load to i64
  %r8_i = ptrtoint i8* %r8ptr to i64
  %cmp_jb = icmp ult i64 %addr_i, %r8_i
  br i1 %cmp_jb, label %loop.next, label %check_end

check_end:
  %field1ptr_i8 = getelementptr i8, i8* %ptr, i64 8
  %field1ptr = bitcast i8* %field1ptr_i8 to i8**
  %rdxptr = load i8*, i8** %field1ptr, align 8
  %rdxptr_plus8 = getelementptr i8, i8* %rdxptr, i64 8
  %len32ptr = bitcast i8* %rdxptr_plus8 to i32*
  %len32 = load i32, i32* %len32ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_i = add i64 %r8_i, %len64
  %cmp_jb2 = icmp ult i64 %addr_i, %end_i
  br i1 %cmp_jb2, label %ret_early, label %loop.next

ret_early:
  ret void

loop.next:
  %idx.next = add i32 %idx, 1
  %ptr.next = getelementptr i8, i8* %ptr, i64 40
  %cmp_end = icmp ne i32 %idx.next, %count32
  br i1 %cmp_end, label %loop, label %alloc_pre

alloc_pre:
  %alloc_idx = phi i32 [ 0, %entry ], [ %count32, %loop.next ], [ 0, %retry ]
  %rdi = call i8* @sub_140002610(i8* %addr.load)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %no_image_section, label %after_lookup

no_image_section:
  %fmt1ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call i32 (i8*, ...) @sub_140001AD0(i8* %fmt1ptr, i8* %addr.load)
  ret void

after_lookup:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = zext i32 %alloc_idx to i64
  %offsetBytes = mul i64 %idx64, 40
  %entryPtr = getelementptr i8, i8* %base1, i64 %offsetBytes
  %off20 = getelementptr i8, i8* %entryPtr, i64 32
  %field5ptr = bitcast i8* %off20 to i8**
  store i8* %rdi, i8** %field5ptr, align 8
  %field0i32 = bitcast i8* %entryPtr to i32*
  store i32 0, i32* %field0i32, align 4
  %ret2 = call i8* @sub_140002750()
  %rdi_plusC = getelementptr i8, i8* %rdi, i64 12
  %edxptr = bitcast i8* %rdi_plusC to i32*
  %edxval = load i32, i32* %edxptr, align 4
  %edx64 = zext i32 %edxval to i64
  %rcxVal = getelementptr i8, i8* %ret2, i64 %edx64
  %off18 = getelementptr i8, i8* %entryPtr, i64 24
  %field4ptr = bitcast i8* %off18 to i8**
  store i8* %rcxVal, i8** %field4ptr, align 8
  %buf = alloca [48 x i8], align 8
  %buf_i8 = bitcast [48 x i8]* %buf to i8*
  %resVQ = call i64 @sub_14001FAD3(i8* %rcxVal, i8* %buf_i8, i32 48)
  %ok = icmp ne i64 %resVQ, 0
  br i1 %ok, label %check_flags, label %vq_fail

vq_fail:
  %r8_loaded = load i8*, i8** %field4ptr, align 8
  %rdi_plus8 = getelementptr i8, i8* %rdi, i64 8
  %edx2ptr = bitcast i8* %rdi_plus8 to i32*
  %edx2 = load i32, i32* %edx2ptr, align 4
  %fmt2ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call i32 (i8*, ...) @sub_140001AD0(i8* %fmt2ptr, i32 %edx2, i8* %r8_loaded)
  ret void

check_flags:
  %buf_i8_2 = bitcast [48 x i8]* %buf to i8*
  %off2c = getelementptr i8, i8* %buf_i8_2, i64 44
  %valptr = bitcast i8* %off2c to i32*
  %val = load i32, i32* %valptr, align 4
  %val_minus4 = sub i32 %val, 4
  %maskFB = and i32 %val_minus4, -5
  %cond1 = icmp eq i32 %maskFB, 0
  br i1 %cond1, label %success, label %check2

check2:
  %val_minus40 = sub i32 %val, 64
  %maskBF = and i32 %val_minus40, -65
  %cond2 = icmp eq i32 %maskBF, 0
  br i1 %cond2, label %success, label %do_protect

success:
  %oldcount = load i32, i32* @dword_1400070A4, align 4
  %inc = add i32 %oldcount, 1
  store i32 %inc, i32* @dword_1400070A4, align 4
  ret void

do_protect:
  %cmp2 = icmp eq i32 %val, 2
  %buf_as_i8p3 = bitcast [48 x i8]* %buf to i8*
  %fieldBaseAddrPtr = bitcast i8* %buf_as_i8p3 to i8**
  %baseAddress = load i8*, i8** %fieldBaseAddrPtr, align 8
  %off18b = getelementptr i8, i8* %buf_as_i8p3, i64 24
  %regionSizePtr = bitcast i8* %off18b to i64*
  %regionSize = load i64, i64* %regionSizePtr, align 8
  %off8c = getelementptr i8, i8* %entryPtr, i64 8
  %entryField8 = bitcast i8* %off8c to i8**
  store i8* %baseAddress, i8** %entryField8, align 8
  %off10c = getelementptr i8, i8* %entryPtr, i64 16
  %entryField10 = bitcast i8* %off10c to i64*
  store i64 %regionSize, i64* %entryField10, align 8
  %prot_select = select i1 %cmp2, i32 4, i32 64
  %resProt = call i32 @loc_14000EEBA(i8* %baseAddress, i64 %regionSize, i32 %prot_select, i8* %entryPtr)
  %prot_ok = icmp ne i32 %resProt, 0
  br i1 %prot_ok, label %success, label %protect_failed

protect_failed:
  %fp = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err = call i32 %fp()
  %fmt3ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call i32 (i8*, ...) @sub_140001AD0(i8* %fmt3ptr, i32 %err)
  br label %retry

retry:
  br label %alloc_pre
}
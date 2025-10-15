; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i8* null, align 8

@__imp_VirtualQuery = external dllimport global i64 (i8*, i8*, i64)*
@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*
@__imp_GetLastError = external dllimport global i32 ()*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %Buffer = alloca [48 x i8], align 8
  %count = load i32, i32* @dword_1400070A4, align 4
  %cmp = icmp sgt i32 %count, 0
  br i1 %cmp, label %loop.init, label %C60

loop.init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %curOff0 = mul i32 %i, 40
  %curOff64 = sext i32 %curOff0 to i64
  %startPtrBase = getelementptr i8, i8* %base0, i64 24
  %curPtr = getelementptr i8, i8* %startPtrBase, i64 %curOff64
  %curPtrPtr = bitcast i8* %curPtr to i8**
  %startAddr = load i8*, i8** %curPtrPtr, align 8
  %addr_i64 = ptrtoint i8* %addr to i64
  %start_i64 = ptrtoint i8* %startAddr to i64
  %lt = icmp ult i64 %addr_i64, %start_i64
  br i1 %lt, label %loop.inc, label %checkRange

checkRange:
  %ptrAt8 = getelementptr i8, i8* %curPtr, i64 8
  %ptrAt8Ptr = bitcast i8* %ptrAt8 to i8**
  %p2 = load i8*, i8** %ptrAt8Ptr, align 8
  %p2_plus8 = getelementptr i8, i8* %p2, i64 8
  %len32ptr = bitcast i8* %p2_plus8 to i32*
  %len32 = load i32, i32* %len32ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_i64 = add i64 %start_i64, %len64
  %inrange = icmp ult i64 %addr_i64, %end_i64
  br i1 %inrange, label %ret_success, label %loop.inc

loop.inc:
  %i.next = add i32 %i, 1
  %cmpi = icmp ne i32 %i.next, %count
  br i1 %cmpi, label %loop, label %B88_from_loop

ret_success:
  ret void

B88_from_loop:
  br label %B88

C60:
  br label %B88

B88:
  %count_for_ins = phi i32 [ 0, %C60 ], [ %count, %B88_from_loop ]
  %rdi = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %C82, label %after_rdi_nonnull

after_rdi_nonnull:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %count64 = sext i32 %count_for_ins to i64
  %off_mul5 = mul nsw i64 %count64, 5
  %off_bytes = shl i64 %off_mul5, 3
  %entry_ptr = getelementptr i8, i8* %base1, i64 %off_bytes
  %p_at_20 = getelementptr i8, i8* %entry_ptr, i64 32
  %p_at_20_ptr = bitcast i8* %p_at_20 to i8**
  store i8* %rdi, i8** %p_at_20_ptr, align 8
  %entry_dword0 = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_dword0, align 4
  %base2 = call i8* @sub_140002750()
  %rdi_plus_c = getelementptr i8, i8* %rdi, i64 12
  %edx_ptr = bitcast i8* %rdi_plus_c to i32*
  %edx_val = load i32, i32* %edx_ptr, align 4
  %edx_z = zext i32 %edx_val to i64
  %rcx_addr = getelementptr i8, i8* %base2, i64 %edx_z
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr i8, i8* %base3, i64 %off_bytes
  %p_at_18 = getelementptr i8, i8* %entry_ptr2, i64 24
  %p_at_18_ptr = bitcast i8* %p_at_18 to i8**
  store i8* %rcx_addr, i8** %p_at_18_ptr, align 8
  %bufptr0 = getelementptr [48 x i8], [48 x i8]* %Buffer, i64 0, i64 0
  %impVQ_ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @__imp_VirtualQuery
  %resVQ = call i64 %impVQ_ptr(i8* %rcx_addr, i8* %bufptr0, i64 48)
  %iszeroVQ = icmp eq i64 %resVQ, 0
  br i1 %iszeroVQ, label %C67, label %afterVQ

afterVQ:
  %protect_ptr = getelementptr i8, i8* %bufptr0, i64 36
  %protect32ptr = bitcast i8* %protect_ptr to i32*
  %protect = load i32, i32* %protect32ptr, align 4
  %t1 = add i32 %protect, -4
  %and1 = and i32 %t1, 4294967291
  %cond1 = icmp eq i32 %and1, 0
  br i1 %cond1, label %BFE, label %cont_prot

cont_prot:
  %t2 = add i32 %protect, -64
  %and2 = and i32 %t2, 4294967231
  %cond2 = icmp ne i32 %and2, 0
  br i1 %cond2, label %C10, label %BFE

BFE:
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  ret void

C10:
  %is2 = icmp eq i32 %protect, 2
  %newprot_sel = select i1 %is2, i32 4, i32 64
  %baseAddr_ptr = bitcast i8* %bufptr0 to i8**
  %baseAddr = load i8*, i8** %baseAddr_ptr, align 8
  %region_ptr = getelementptr i8, i8* %bufptr0, i64 24
  %region_size_ptr = bitcast i8* %region_ptr to i64*
  %region_size = load i64, i64* %region_size_ptr, align 8
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr3 = getelementptr i8, i8* %base4, i64 %off_bytes
  %ep_plus8 = getelementptr i8, i8* %entry_ptr3, i64 8
  %ep_plus8_ptr = bitcast i8* %ep_plus8 to i8**
  store i8* %baseAddr, i8** %ep_plus8_ptr, align 8
  %ep_plus10 = getelementptr i8, i8* %entry_ptr3, i64 16
  %ep_plus10_ptr = bitcast i8* %ep_plus10 to i64*
  store i64 %region_size, i64* %ep_plus10_ptr, align 8
  %oldProtPtr = bitcast i8* %entry_ptr3 to i32*
  %impVP = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect
  %resVP = call i32 %impVP(i8* %baseAddr, i64 %region_size, i32 %newprot_sel, i32* %oldProtPtr)
  %isokVP = icmp ne i32 %resVP, 0
  br i1 %isokVP, label %BFE, label %VP_fail

VP_fail:
  %impGLE = load i32 ()*, i32 ()** @__imp_GetLastError
  %err = call i32 %impGLE()
  %fmt1 = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %err)
  br label %C60

C67:
  %base5 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr4 = getelementptr i8, i8* %base5, i64 %off_bytes
  %p18_2 = getelementptr i8, i8* %entry_ptr4, i64 24
  %p18_2_ptr = bitcast i8* %p18_2 to i8**
  %val_r8 = load i8*, i8** %p18_2_ptr, align 8
  %rdi_plus8 = getelementptr i8, i8* %rdi, i64 8
  %edx2_ptr = bitcast i8* %rdi_plus8 to i32*
  %edx2 = load i32, i32* %edx2_ptr, align 4
  %fmt2 = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i32 %edx2, i8* %val_r8)
  br label %C82

C82:
  %fmt3 = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3, i8* %addr)
  ret void
}
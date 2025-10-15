; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@__imp_VirtualQuery = external global i64 (i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)*
@__imp_VirtualProtect = external global i32 (i8*, i64, i32, i32*)*
@__imp_GetLastError = external global i32 ()*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [40 x i8] c"  VirtualQuery failed for %d bytes at a\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %0) {
entry:
  %Buffer = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %argInt = ptrtoint i8* %0 to i64
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %hasEntries = icmp sgt i32 %cnt0, 0
  br i1 %hasEntries, label %loop.prep, label %loc_140001C60

loop.prep:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scanStart = getelementptr i8, i8* %base0, i64 24
  br label %loc_140001B60

loc_140001B60:
  %i = phi i32 [ 0, %loop.prep ], [ %i.next, %loc_140001B7B ]
  %ptr.cur = phi i8* [ %scanStart, %loop.prep ], [ %ptr.next, %loc_140001B7B ]
  %baseAddrPtr = bitcast i8* %ptr.cur to i8**
  %baseAddr = load i8*, i8** %baseAddrPtr, align 8
  %baseInt = ptrtoint i8* %baseAddr to i64
  %jb = icmp ult i64 %argInt, %baseInt
  br i1 %jb, label %loc_140001B7B, label %afterjb

afterjb:
  %p2ptr = getelementptr i8, i8* %ptr.cur, i64 8
  %p2ptr.as = bitcast i8* %p2ptr to i8**
  %p2 = load i8*, i8** %p2ptr.as, align 8
  %p2plus8 = getelementptr i8, i8* %p2, i64 8
  %len32ptr = bitcast i8* %p2plus8 to i32*
  %len32 = load i32, i32* %len32ptr, align 4
  %len64 = zext i32 %len32 to i64
  %endInt = add i64 %baseInt, %len64
  %jb2 = icmp ult i64 %argInt, %endInt
  br i1 %jb2, label %loc_140001C05, label %loc_140001B7B

loc_140001B7B:
  %i.next = add i32 %i, 1
  %ptr.next = getelementptr i8, i8* %ptr.cur, i64 40
  %cont = icmp ne i32 %i.next, %cnt0
  br i1 %cont, label %loc_140001B60, label %loc_140001B88

loc_140001C60:
  br label %loc_140001B88

loc_140001B88:
  %cntForNew = phi i32 [ 0, %loc_140001C60 ], [ %cnt0, %loc_140001B7B ]
  %rdi = call i8* @sub_140002610(i8* %0)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %loc_140001C82, label %after_new_entry

after_new_entry:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %cntForNew to i64
  %mul5 = mul nsw i64 %idx64, 5
  %bytes = shl i64 %mul5, 3
  %entry.base = getelementptr i8, i8* %base1, i64 %bytes
  %entry.plus20 = getelementptr i8, i8* %entry.base, i64 32
  %entry.plus20.as = bitcast i8* %entry.plus20 to i8**
  store i8* %rdi, i8** %entry.plus20.as, align 8
  %entry.i32 = bitcast i8* %entry.base to i32*
  store i32 0, i32* %entry.i32, align 4
  %call_sub_140002750 = call i8* @sub_140002750()
  %rdi.plusC = getelementptr i8, i8* %rdi, i64 12
  %valCptr = bitcast i8* %rdi.plusC to i32*
  %valC = load i32, i32* %valCptr, align 4
  %valC.z = zext i32 %valC to i64
  %rcx.address = getelementptr i8, i8* %call_sub_140002750, i64 %valC.z
  %glob2 = load i8*, i8** @qword_1400070A8, align 8
  %off.plusBytes = getelementptr i8, i8* %glob2, i64 %bytes
  %field18 = getelementptr i8, i8* %off.plusBytes, i64 24
  %field18.as = bitcast i8* %field18 to i8**
  store i8* %rcx.address, i8** %field18.as, align 8
  %vqptr = load i64 (i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)*, i64 (i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)** @__imp_VirtualQuery, align 8
  %callVQ = call i64 %vqptr(i8* %rcx.address, %struct.MEMORY_BASIC_INFORMATION* %Buffer, i64 48)
  %isZero = icmp eq i64 %callVQ, 0
  br i1 %isZero, label %loc_140001C67, label %VQsuccess

VQsuccess:
  %protptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %Buffer, i32 0, i32 6
  %eaxProt = load i32, i32* %protptr, align 4
  %eaxMinus4 = sub i32 %eaxProt, 4
  %maskFB = and i32 %eaxMinus4, 4294967291
  %isZero1 = icmp eq i32 %maskFB, 0
  br i1 %isZero1, label %loc_140001BFE, label %afterMask1

afterMask1:
  %eaxMinus40 = sub i32 %eaxProt, 64
  %maskBF = and i32 %eaxMinus40, 4294967231
  %notZero = icmp ne i32 %maskBF, 0
  br i1 %notZero, label %loc_140001C10, label %loc_140001BFE

loc_140001BFE:
  %oldCnt2 = load i32, i32* @dword_1400070A4, align 4
  %incCnt = add i32 %oldCnt2, 1
  store i32 %incCnt, i32* @dword_1400070A4, align 4
  br label %loc_140001C05

loc_140001C10:
  %eq2 = icmp eq i32 %eaxProt, 2
  %newProt = select i1 %eq2, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %Buffer, i32 0, i32 0
  %baseaddr.load = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %Buffer, i32 0, i32 4
  %regionsize.load = load i64, i64* %regionsize.ptr, align 8
  %entry.plus8 = getelementptr i8, i8* %entry.base, i64 8
  %entry.plus8.as = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr.load, i8** %entry.plus8.as, align 8
  %entry.plus16 = getelementptr i8, i8* %entry.base, i64 16
  %entry.plus16.as = bitcast i8* %entry.plus16 to i64*
  store i64 %regionsize.load, i64* %entry.plus16.as, align 8
  %vpfn = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %oldProtPtr = bitcast i8* %entry.base to i32*
  %callVP = call i32 %vpfn(i8* %baseaddr.load, i64 %regionsize.load, i32 %newProt, i32* %oldProtPtr)
  %success = icmp ne i32 %callVP, 0
  br i1 %success, label %loc_140001BFE, label %VPfail

VPfail:
  %glaPtr = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  %err = call i32 %glaPtr()
  %fmt1 = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %err)
  br label %loc_140001C60

loc_140001C67:
  %glob3 = load i8*, i8** @qword_1400070A8, align 8
  %entry3 = getelementptr i8, i8* %glob3, i64 %bytes
  %field18_3 = getelementptr i8, i8* %entry3, i64 24
  %field18_3.as = bitcast i8* %field18_3 to i8**
  %addrStored = load i8*, i8** %field18_3.as, align 8
  %rdi.plus8 = getelementptr i8, i8* %rdi, i64 8
  %val8ptr = bitcast i8* %rdi.plus8 to i32*
  %val8 = load i32, i32* %val8ptr, align 4
  %fmt2 = getelementptr inbounds [40 x i8], [40 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i32 %val8, i8* %addrStored)
  br label %loc_140001C82

loc_140001C82:
  %fmt3 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3, i8* %0)
  br label %loc_140001C05

loc_140001C05:
  ret void
}
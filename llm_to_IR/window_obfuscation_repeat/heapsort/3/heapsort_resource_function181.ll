; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i16, i16, i64, i32, i32, i32 }

@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i8* null, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8* noundef)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8* noundef, ...)
declare i64 @VirtualQuery(i8* noundef, %struct.MEMORY_BASIC_INFORMATION* noundef, i64 noundef)
declare i32 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %addr) {
entry:
  %addr_int = ptrtoint i8* %addr to i64
  %n0 = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %n0, 0
  br i1 %gt0, label %loop.init, label %no.entries

loop.init:
  %base.ptr0 = load i8*, i8** @qword_1400070A8, align 8
  %scan.start = getelementptr i8, i8* %base.ptr0, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %loop.cont ]
  %i64 = zext i32 %i to i64
  %off = mul i64 %i64, 40
  %entry.scan.ptr = getelementptr i8, i8* %scan.start, i64 %off
  %field0.ptr = bitcast i8* %entry.scan.ptr to i8**
  %base.addr = load i8*, i8** %field0.ptr, align 8
  %base.addr.int = ptrtoint i8* %base.addr to i64
  %cmp0 = icmp ult i64 %addr_int, %base.addr.int
  br i1 %cmp0, label %loop.cont, label %cmp.end

cmp.end:
  %ptr.plus8 = getelementptr i8, i8* %entry.scan.ptr, i64 8
  %ptr.plus8.cast = bitcast i8* %ptr.plus8 to i8**
  %p2 = load i8*, i8** %ptr.plus8.cast, align 8
  %p2.plus8 = getelementptr i8, i8* %p2, i64 8
  %len32.ptr = bitcast i8* %p2.plus8 to i32*
  %len32 = load i32, i32* %len32.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.addr = add i64 %base.addr.int, %len64
  %cmp1 = icmp ult i64 %addr_int, %end.addr
  br i1 %cmp1, label %ret, label %loop.cont

loop.cont:
  %i.next = add i32 %i, 1
  %cont = icmp slt i32 %i.next, %n0
  br i1 %cont, label %loop, label %not.found.from.loop

ret:
  ret void

no.entries:
  br label %not.found.setup

not.found.from.loop:
  br label %not.found.setup

not.found.setup:
  %index = phi i32 [ 0, %no.entries ], [ %n0, %not.found.from.loop ]
  %rdi = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %no.image, label %have.image

no.image:
  %fmt3.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3.ptr, i8* %addr)
  ret void

have.image:
  %base.ptr1 = load i8*, i8** @qword_1400070A8, align 8
  %index64 = zext i32 %index to i64
  %mul40b = mul i64 %index64, 40
  %entry.base = getelementptr i8, i8* %base.ptr1, i64 %mul40b
  %p20 = getelementptr i8, i8* %entry.base, i64 32
  %p20.cast = bitcast i8* %p20 to i8**
  store i8* %rdi, i8** %p20.cast, align 8
  %p0 = bitcast i8* %entry.base to i32*
  store i32 0, i32* %p0, align 4
  %base2 = call i8* @sub_140002750()
  %rdi.plus.c = getelementptr i8, i8* %rdi, i64 12
  %edx.ptr = bitcast i8* %rdi.plus.c to i32*
  %edx = load i32, i32* %edx.ptr, align 4
  %edx64 = zext i32 %edx to i64
  %rcx.addr = getelementptr i8, i8* %base2, i64 %edx64
  %p18 = getelementptr i8, i8* %entry.base, i64 24
  %p18.cast = bitcast i8* %p18 to i8**
  store i8* %rcx.addr, i8** %p18.cast, align 8
  %mbi = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vqret = call i64 @VirtualQuery(i8* %rcx.addr, %struct.MEMORY_BASIC_INFORMATION* %mbi, i64 48)
  %isZero = icmp eq i64 %vqret, 0
  br i1 %isZero, label %vq.fail, label %vq.ok

vq.fail:
  %rdi.plus8 = getelementptr i8, i8* %rdi, i64 8
  %lenForMsg.ptr = bitcast i8* %rdi.plus8 to i32*
  %lenForMsg = load i32, i32* %lenForMsg.ptr, align 4
  %p18.msg = getelementptr i8, i8* %entry.base, i64 24
  %p18.msg.cast = bitcast i8* %p18.msg to i8**
  %addr.stored = load i8*, i8** %p18.msg.cast, align 8
  %fmt2.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2.ptr, i32 %lenForMsg, i8* %addr.stored)
  ret void

vq.ok:
  %protect.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 7
  %protect = load i32, i32* %protect.ptr, align 4
  %eq4 = icmp eq i32 %protect, 4
  %eq8 = icmp eq i32 %protect, 8
  %eq64 = icmp eq i32 %protect, 64
  %eq128 = icmp eq i32 %protect, 128
  %or1 = or i1 %eq4, %eq8
  %or2 = or i1 %eq64, %eq128
  %or3 = or i1 %or1, %or2
  br i1 %or3, label %inc.and.ret, label %need.protect

inc.and.ret:
  %oldn2 = load i32, i32* @dword_1400070A4, align 4
  %newn2 = add i32 %oldn2, 1
  store i32 %newn2, i32* @dword_1400070A4, align 4
  ret void

need.protect:
  %eq2 = icmp eq i32 %protect, 2
  %flSel = select i1 %eq2, i32 4, i32 64
  %baseaddr.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 5
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %p8 = getelementptr i8, i8* %entry.base, i64 8
  %p8.cast = bitcast i8* %p8 to i8**
  store i8* %baseaddr, i8** %p8.cast, align 8
  %p10 = getelementptr i8, i8* %entry.base, i64 16
  %p10.cast = bitcast i8* %p10 to i64*
  store i64 %regionsize, i64* %p10.cast, align 8
  %oldProtPtr = bitcast i8* %entry.base to i32*
  %vpRet = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %flSel, i32* %oldProtPtr)
  %vpOK = icmp ne i32 %vpRet, 0
  br i1 %vpOK, label %inc.and.ret, label %vp.fail

vp.fail:
  %err = call i32 @GetLastError()
  %fmt1.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1.ptr, i32 %err)
  ret void
}
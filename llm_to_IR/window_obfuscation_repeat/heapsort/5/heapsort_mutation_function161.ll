; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i16, i64, i32, i32, i32 }
%struct.Rec = type { i32, i32, i8*, i64, i8*, i8* }

@qword_1400070A8 = external global i8*
@dword_1400070A4 = external global i32

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)
declare i64 @VirtualQuery(i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %addr) {
entry:
  %mbi = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_pos = icmp sgt i32 %cnt, 0
  br i1 %cnt_pos, label %loop.init, label %init_zero

loop.init:
  %baseRaw.l = load i8*, i8** @qword_1400070A8, align 8
  %baseRec.l = bitcast i8* %baseRaw.l to %struct.Rec*
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %i64 = sext i32 %i to i64
  %entryPtr = getelementptr %struct.Rec, %struct.Rec* %baseRec.l, i64 %i64
  %secStart.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr, i32 0, i32 4
  %secStart = load i8*, i8** %secStart.ptr, align 8
  %addrInt = ptrtoint i8* %addr to i64
  %startInt = ptrtoint i8* %secStart to i64
  %isBefore = icmp ult i64 %addrInt, %startInt
  br i1 %isBefore, label %loop.inc, label %notBefore

notBefore:
  %secInfo.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr, i32 0, i32 5
  %secInfo = load i8*, i8** %secInfo.ptr, align 8
  %secInfo.plus8 = getelementptr i8, i8* %secInfo, i64 8
  %sizePtr = bitcast i8* %secInfo.plus8 to i32*
  %size32 = load i32, i32* %sizePtr, align 4
  %size64 = zext i32 %size32 to i64
  %endInt = add i64 %startInt, %size64
  %isInside = icmp ult i64 %addrInt, %endInt
  br i1 %isInside, label %found_in_range, label %loop.inc

found_in_range:
  ret void

loop.inc:
  %i.next = add i32 %i, 1
  %done = icmp eq i32 %i.next, %cnt
  br i1 %done, label %after_scan, label %loop

after_scan:
  %cnt64_after = sext i32 %cnt to i64
  br label %process_new

init_zero:
  %baseRaw.z = load i8*, i8** @qword_1400070A8, align 8
  %baseRec.z = bitcast i8* %baseRaw.z to %struct.Rec*
  br label %process_new

process_new:
  %baseRec.phi = phi %struct.Rec* [ %baseRec.z, %init_zero ], [ %baseRec.l, %after_scan ]
  %idx64.phi = phi i64 [ 0, %init_zero ], [ %cnt64_after, %after_scan ]
  %entryPtr.new = getelementptr %struct.Rec, %struct.Rec* %baseRec.phi, i64 %idx64.phi
  %rdi = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %no_section, label %have_section

no_section:
  %fmt3.ptr = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3.ptr, i8* %addr)
  ret void

have_section:
  %secInfo.store.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr.new, i32 0, i32 5
  store i8* %rdi, i8** %secInfo.store.ptr, align 8
  %oldProt.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr.new, i32 0, i32 0
  store i32 0, i32* %oldProt.ptr, align 4
  %base2 = call i8* @sub_140002750()
  %off12.ptr.i8 = getelementptr i8, i8* %rdi, i64 12
  %off12.ptr = bitcast i8* %off12.ptr.i8 to i32*
  %off12.val = load i32, i32* %off12.ptr, align 4
  %off12.sext = sext i32 %off12.val to i64
  %lpAddress = getelementptr i8, i8* %base2, i64 %off12.sext
  %secStart.store.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr.new, i32 0, i32 4
  store i8* %lpAddress, i8** %secStart.store.ptr, align 8
  %vq.ret = call i64 @VirtualQuery(i8* %lpAddress, %struct.MEMORY_BASIC_INFORMATION* %mbi, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %vq_fail, label %vq_ok

vq_fail:
  %off8.ptr.i8 = getelementptr i8, i8* %rdi, i64 8
  %off8.ptr = bitcast i8* %off8.ptr.i8 to i32*
  %nbytes = load i32, i32* %off8.ptr, align 4
  %saved.addr = load i8*, i8** %secStart.store.ptr, align 8
  %fmt2.ptr = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2.ptr, i32 %nbytes, i8* %saved.addr)
  ret void

vq_ok:
  %prot.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 6
  %prot = load i32, i32* %prot.ptr, align 4
  %t1 = sub i32 %prot, 4
  %mask1 = xor i32 -1, 4
  %t1a = and i32 %t1, %mask1
  %c1 = icmp eq i32 %t1a, 0
  %t2 = sub i32 %prot, 64
  %mask2 = xor i32 -1, 64
  %t2a = and i32 %t2, %mask2
  %c2zero = icmp eq i32 %t2a, 0
  %already.ok = or i1 %c1, %c2zero
  br i1 %already.ok, label %inc_and_ret, label %need_protect

need_protect:
  %eq2 = icmp eq i32 %prot, 2
  %newprot.if2 = select i1 %eq2, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %entry.base.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr.new, i32 0, i32 2
  store i8* %baseaddr, i8** %entry.base.ptr, align 8
  %entry.size.ptr = getelementptr %struct.Rec, %struct.Rec* %entryPtr.new, i32 0, i32 3
  store i64 %regionsize, i64* %entry.size.ptr, align 8
  %vp.ret = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newprot.if2, i32* %oldProt.ptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %err = call i32 @GetLastError()
  %fmt1.ptr = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1.ptr, i32 %err)
  ret void

inc_and_ret:
  %cnt.curr = load i32, i32* @dword_1400070A4, align 4
  %cnt.next = add i32 %cnt.curr, 1
  store i32 %cnt.next, i32* @dword_1400070A4, align 4
  ret void
}
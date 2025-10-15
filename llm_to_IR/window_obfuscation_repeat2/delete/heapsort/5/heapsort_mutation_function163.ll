; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)
declare i64 @VirtualQuery(i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %rcx) {
entry:
  %mbi = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %count0 = load i32, i32* @dword_1400070A4
  %cond_jle = icmp sle i32 %count0, 0
  br i1 %cond_jle, label %loc_140001C60, label %scan_init

scan_init:                                           ; preds = %entry
  %base_ptr.load = load i8*, i8** @qword_1400070A8
  %base_plus_24 = getelementptr i8, i8* %base_ptr.load, i64 24
  br label %loop

loop:                                                ; preds = %loop_latch, %scan_init
  %i.phi = phi i32 [ 0, %scan_init ], [ %i.next, %loop_latch ]
  %ptr.phi = phi i8* [ %base_plus_24, %scan_init ], [ %ptr.next, %loop_latch ]
  %start.ptr.ptr = bitcast i8* %ptr.phi to i8**
  %start.addr = load i8*, i8** %start.ptr.ptr, align 8
  %rbx.lt.start = icmp ult i8* %rcx, %start.addr
  br i1 %rbx.lt.start, label %loop_latch, label %check_end

check_end:                                           ; preds = %loop
  %p2.ptr = getelementptr i8, i8* %ptr.phi, i64 8
  %p2 = bitcast i8* %p2.ptr to i8**
  %rdx.ptr = load i8*, i8** %p2, align 8
  %rdx.plus8 = getelementptr i8, i8* %rdx.ptr, i64 8
  %size32.ptr = bitcast i8* %rdx.plus8 to i32*
  %size32 = load i32, i32* %size32.ptr, align 4
  %size64 = zext i32 %size32 to i64
  %start.int = ptrtoint i8* %start.addr to i64
  %end.int = add i64 %start.int, %size64
  %rbx.int = ptrtoint i8* %rcx to i64
  %in.range = icmp ult i64 %rbx.int, %end.int
  br i1 %in.range, label %return_epilogue, label %loop_latch

loop_latch:                                          ; preds = %check_end, %loop
  %i.next = add i32 %i.phi, 1
  %ptr.next = getelementptr i8, i8* %ptr.phi, i64 40
  %cont = icmp ne i32 %i.next, %count0
  br i1 %cont, label %loop, label %after_loop

after_loop:                                          ; preds = %loop_latch
  br label %loc_140001B88

loc_140001C60:                                       ; preds = %entry
  br label %loc_140001B88

loc_140001B88:                                       ; preds = %loc_140001C60, %after_loop
  %idx.sel = phi i32 [ 0, %loc_140001C60 ], [ %count0, %after_loop ]
  %call.2610 = call i8* @sub_140002610(i8* %rcx)
  %rdi.isnull = icmp eq i8* %call.2610, null
  br i1 %rdi.isnull, label %loc_140001C82, label %cont_after_rdi

cont_after_rdi:                                      ; preds = %loc_140001B88
  %base.load.2 = load i8*, i8** @qword_1400070A8
  %idx.ext = sext i32 %idx.sel to i64
  %mul5 = mul i64 %idx.ext, 5
  %slot.off.units = mul i64 %mul5, 8
  %slot.ptr = getelementptr i8, i8* %base.load.2, i64 %slot.off.units
  %off20.ptr = getelementptr i8, i8* %slot.ptr, i64 32
  %off20.as.ptrptr = bitcast i8* %off20.ptr to i8**
  store i8* %call.2610, i8** %off20.as.ptrptr, align 8
  %slot.i32ptr = bitcast i8* %slot.ptr to i32*
  store i32 0, i32* %slot.i32ptr, align 4
  %call.2750 = call i8* @sub_140002750()
  %rdi.plusC = getelementptr i8, i8* %call.2610, i64 12
  %rdi.plusC.as.i32 = bitcast i8* %rdi.plusC to i32*
  %edx.val = load i32, i32* %rdi.plusC.as.i32, align 4
  %edx.z = zext i32 %edx.val to i64
  %rcx.addr = getelementptr i8, i8* %call.2750, i64 %edx.z
  %base.load.3 = load i8*, i8** @qword_1400070A8
  %slot.off.18 = add i64 %slot.off.units, 24
  %slot.ptr.18 = getelementptr i8, i8* %base.load.3, i64 %slot.off.18
  %slot.ptr.18.as.ptrptr = bitcast i8* %slot.ptr.18 to i8**
  store i8* %rcx.addr, i8** %slot.ptr.18.as.ptrptr, align 8
  %len48 = call i64 @VirtualQuery(i8* %rcx.addr, %struct.MEMORY_BASIC_INFORMATION* %mbi, i64 48)
  %vq.zero = icmp eq i64 %len48, 0
  br i1 %vq.zero, label %loc_140001C67, label %after_vq

after_vq:                                            ; preds = %cont_after_rdi
  %protect.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 6
  %protect.val = load i32, i32* %protect.ptr, align 4
  %sub4 = sub i32 %protect.val, 4
  %maskFB = and i32 %sub4, -5
  %is.zero.first = icmp eq i32 %maskFB, 0
  br i1 %is.zero.first, label %loc_140001BFE, label %check40

check40:                                             ; preds = %after_vq
  %sub40 = sub i32 %protect.val, 64
  %maskBF = and i32 %sub40, -65
  %is.zero.second = icmp eq i32 %maskBF, 0
  br i1 %is.zero.second, label %loc_140001BFE, label %loc_140001C10

loc_140001BFE:                                       ; preds = %check40, %after_vq, %vp.success
  %old.count = load i32, i32* @dword_1400070A4
  %inc = add i32 %old.count, 1
  store i32 %inc, i32* @dword_1400070A4
  br label %return_epilogue

loc_140001C10:                                       ; preds = %check40
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %newprot.default = add i32 0, 64
  %cmp.eax.2 = icmp eq i32 %protect.val, 2
  %newprot.sel = select i1 %cmp.eax.2, i32 4, i32 %newprot.default
  %base.load.4 = load i8*, i8** @qword_1400070A8
  %slot.base = getelementptr i8, i8* %base.load.4, i64 %slot.off.units
  %slot.base.plus8 = getelementptr i8, i8* %slot.base, i64 8
  %slot.base.plus8.as.ptrptr = bitcast i8* %slot.base.plus8 to i8**
  store i8* %baseaddr, i8** %slot.base.plus8.as.ptrptr, align 8
  %slot.base.plus10 = getelementptr i8, i8* %slot.base, i64 16
  %slot.base.plus10.as.i64 = bitcast i8* %slot.base.plus10 to i64*
  store i64 %regionsize, i64* %slot.base.plus10.as.i64, align 8
  %slot.as.i32ptr = bitcast i8* %slot.base to i32*
  %vp.ret = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newprot.sel, i32* %slot.as.i32ptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %vp.success, label %vp.fail

vp.success:                                          ; preds = %loc_140001C10
  br label %loc_140001BFE

vp.fail:                                             ; preds = %loc_140001C10
  %err = call i32 @GetLastError()
  call void bitcast (void (i8*, ...)* @sub_140001AD0 to void (i8*, i32)*)(i8* @aVirtualprotect, i32 %err)
  br label %loc_140001C60

loc_140001C67:                                       ; preds = %cont_after_rdi
  %base.load.5 = load i8*, i8** @qword_1400070A8
  %rdi.plus8 = getelementptr i8, i8* %call.2610, i64 8
  %rdi.plus8.as.i32 = bitcast i8* %rdi.plus8 to i32*
  %edx.vqfail = load i32, i32* %rdi.plus8.as.i32, align 4
  %slot.addr.18 = getelementptr i8, i8* %base.load.5, i64 %slot.off.18
  %slot.addr.18.as.ptrptr = bitcast i8* %slot.addr.18 to i8**
  %addr.stored = load i8*, i8** %slot.addr.18.as.ptrptr, align 8
  call void bitcast (void (i8*, ...)* @sub_140001AD0 to void (i8*, i32, i8*)*)(i8* @aVirtualqueryFa, i32 %edx.vqfail, i8* %addr.stored)
  br label %loc_140001C82

loc_140001C82:                                       ; preds = %loc_140001C67, %loc_140001B88
  call void bitcast (void (i8*, ...)* @sub_140001AD0 to void (i8*, i8*)*)(i8* @aAddressPHasNoI, i8* %rcx)
  br label %return_epilogue

return_epilogue:                                     ; preds = %loc_140001C82, %loc_140001BFE, %check_end
  ret void
}
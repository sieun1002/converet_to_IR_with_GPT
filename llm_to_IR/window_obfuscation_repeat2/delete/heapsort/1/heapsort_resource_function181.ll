; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@__imp_VirtualQuery = external dllimport global i8*
@__imp_VirtualProtect = external dllimport global i8*
@__imp_GetLastError = external dllimport global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %arg_rcx) {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %count0, 0
  br i1 %pos, label %loop.prelude, label %no_entries

loop.prelude:
  %base_ptr.p = load i8*, i8** @qword_1400070A8, align 8
  %base_plus_24 = getelementptr i8, i8* %base_ptr.p, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.prelude ], [ %i.next, %skip_contains ]
  %rax.cur = phi i8* [ %base_plus_24, %loop.prelude ], [ %rax.next, %skip_contains ]
  %entry_baseaddr.ptr = bitcast i8* %rax.cur to i8**
  %entry_baseaddr = load i8*, i8** %entry_baseaddr.ptr, align 8
  %rbx.int = ptrtoint i8* %arg_rcx to i64
  %entry_base.int = ptrtoint i8* %entry_baseaddr to i64
  %rbx.lt.base = icmp ult i64 %rbx.int, %entry_base.int
  br i1 %rbx.lt.base, label %skip_contains, label %check_end

check_end:
  %p.ptr.ptr = getelementptr i8, i8* %rax.cur, i64 8
  %p.ptr = bitcast i8* %p.ptr.ptr to i8**
  %p = load i8*, i8** %p.ptr, align 8
  %p.plus8 = getelementptr i8, i8* %p, i64 8
  %size32.ptr = bitcast i8* %p.plus8 to i32*
  %size32 = load i32, i32* %size32.ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %entry_base.int, %size64
  %rbx.lt.end = icmp ult i64 %rbx.int, %end.int
  br i1 %rbx.lt.end, label %early_return, label %skip_contains

early_return:
  ret void

skip_contains:
  %i.next = add i32 %i, 1
  %rax.next = getelementptr i8, i8* %rax.cur, i64 40
  %cmp.i = icmp ne i32 %i.next, %count0
  br i1 %cmp.i, label %loop, label %after_loop

no_entries:
  br label %after_loop

after_loop:
  %idx = phi i32 [ 0, %no_entries ], [ %count0, %skip_contains ]
  %rdi = call i8* @sub_140002610(i8* %arg_rcx)
  %is.null = icmp eq i8* %rdi, null
  br i1 %is.null, label %print_no_image, label %have_image

print_no_image:
  %fmt.addrno = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.addrno, i8* %arg_rcx)
  ret void

have_image:
  %base_ptr.p2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx to i64
  %offset = mul i64 %idx64, 40
  %entry.ptr = getelementptr i8, i8* %base_ptr.p2, i64 %offset
  %entry.plus32 = getelementptr i8, i8* %entry.ptr, i64 32
  %ep32.ptr = bitcast i8* %entry.plus32 to i8**
  store i8* %rdi, i8** %ep32.ptr, align 8
  %entry.dw.ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.dw.ptr, align 4
  %ret2750 = call i8* @sub_140002750()
  %rdi.plus12 = getelementptr i8, i8* %rdi, i64 12
  %rdi.plus12.i32ptr = bitcast i8* %rdi.plus12 to i32*
  %offset32 = load i32, i32* %rdi.plus12.i32ptr, align 4
  %offset64 = zext i32 %offset32 to i64
  %lpAddress = getelementptr i8, i8* %ret2750, i64 %offset64
  %buf = alloca [48 x i8], align 16
  %buf.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %entry.plus24 = getelementptr i8, i8* %entry.ptr, i64 24
  %e24ptr = bitcast i8* %entry.plus24 to i8**
  store i8* %lpAddress, i8** %e24ptr, align 8
  %impVQ.p = load i8*, i8** @__imp_VirtualQuery, align 8
  %funcVQ = bitcast i8* %impVQ.p to i64 (i8*, i8*, i64)*
  %vq.ret = call i64 %funcVQ(i8* %lpAddress, i8* %buf.i8, i64 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %after_vq_success, label %after_vq_fail

after_vq_fail:
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %rdi.plus8 = getelementptr i8, i8* %rdi, i64 8
  %rdi.plus8.i32ptr = bitcast i8* %rdi.plus8 to i32*
  %numbytes = load i32, i32* %rdi.plus8.i32ptr, align 4
  %entry.plus24.2 = getelementptr i8, i8* %entry.ptr, i64 24
  %lpaddr.saved.ptr = bitcast i8* %entry.plus24.2 to i8**
  %lpaddr.saved = load i8*, i8** %lpaddr.saved.ptr, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %numbytes, i8* %lpaddr.saved)
  ret void

after_vq_success:
  %protect.ptr = getelementptr inbounds i8, i8* %buf.i8, i64 40
  %protect.i32ptr = bitcast i8* %protect.ptr to i32*
  %protect = load i32, i32* %protect.i32ptr, align 4
  %tmp.sub4 = add i32 %protect, -4
  %mask1 = and i32 %tmp.sub4, -5
  %is.zero1 = icmp eq i32 %mask1, 0
  br i1 %is.zero1, label %inc_and_ret, label %check_second

check_second:
  %tmp.sub64 = add i32 %protect, -64
  %mask2 = and i32 %tmp.sub64, -65
  %is.nonzero2 = icmp ne i32 %mask2, 0
  br i1 %is.nonzero2, label %need_protect, label %inc_and_ret

inc_and_ret:
  %oldcount = load i32, i32* @dword_1400070A4, align 4
  %newcount = add i32 %oldcount, 1
  store i32 %newcount, i32* @dword_1400070A4, align 4
  ret void

need_protect:
  %is.readonly = icmp eq i32 %protect, 2
  %newprot = select i1 %is.readonly, i32 4, i32 64
  %baseaddr.ptr = bitcast i8* %buf.i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr inbounds i8, i8* %buf.i8, i64 24
  %regionsize.i64ptr = bitcast i8* %regionsize.ptr to i64*
  %regionsize = load i64, i64* %regionsize.i64ptr, align 8
  %entry.plus8 = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.plus8.ptr = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr, i8** %entry.plus8.ptr, align 8
  %entry.plus16 = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.plus16.ptr = bitcast i8* %entry.plus16 to i64*
  store i64 %regionsize, i64* %entry.plus16.ptr, align 8
  %impVP.p = load i8*, i8** @__imp_VirtualProtect, align 8
  %funcVP = bitcast i8* %impVP.p to i32 (i8*, i64, i32, i8*)*
  %vp.res = call i32 %funcVP(i8* %baseaddr, i64 %regionsize, i32 %newprot, i8* %entry.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %impGLE.p = load i8*, i8** @__imp_GetLastError, align 8
  %funcGLE = bitcast i8* %impGLE.p to i32 ()*
  %err = call i32 %funcGLE()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  br label %inc_and_ret
}
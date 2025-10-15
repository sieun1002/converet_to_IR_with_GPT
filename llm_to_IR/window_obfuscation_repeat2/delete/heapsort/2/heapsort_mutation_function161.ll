; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.MBI = type { i8*, i8*, i32, i16, [2 x i8], i64, i32, i32, i32, i32 }

@qword_1400070A8 = external global i8*
@dword_1400070A4 = external global i32

@__imp_VirtualQuery = external dllimport global i64 (i8*, %struct.MBI*, i64)*
@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*
@__imp_GetLastError = external dllimport global i32 ()*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %rcx) {
entry:
  %buf = alloca %struct.MBI, align 8
  %addr_in = ptrtoint i8* %rcx to i64
  %count.ld = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count.ld, 0
  br i1 %gt0, label %loop.header, label %c60

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.cont ]
  %base.ptr.ptr = load i8*, i8** @qword_1400070A8, align 8
  %scan.start = getelementptr inbounds i8, i8* %base.ptr.ptr, i64 24
  %i64 = sext i32 %i to i64
  %offset.it = mul nsw i64 %i64, 40
  %ptr.it = getelementptr inbounds i8, i8* %scan.start, i64 %offset.it
  %field.base.ptr = bitcast i8* %ptr.it to i8***
  %base.field = load i8**, i8*** %field.base.ptr, align 8
  %base.val = load i8*, i8** %base.field, align 8
  %base.addr = ptrtoint i8* %base.val to i64
  %lt.base = icmp ult i64 %addr_in, %base.addr
  br i1 %lt.base, label %loop.cont, label %check.end

check.end:
  %ptr.plus8 = getelementptr inbounds i8, i8* %ptr.it, i64 8
  %field.ptr2 = bitcast i8* %ptr.plus8 to i8***
  %p2ptr = load i8**, i8*** %field.ptr2, align 8
  %p2 = load i8*, i8** %p2ptr, align 8
  %p2.plus8 = getelementptr inbounds i8, i8* %p2, i64 8
  %len.ptr = bitcast i8* %p2.plus8 to i32*
  %len32 = load i32, i32* %len.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.addr = add i64 %base.addr, %len64
  %in.range = icmp ult i64 %addr_in, %end.addr
  br i1 %in.range, label %c05.ret, label %loop.cont

loop.cont:
  %i.next = add nsw i32 %i, 1
  %loop.done = icmp slt i32 %i.next, %count.ld
  br i1 %loop.done, label %loop.header, label %b88

c60:
  br label %b88

c05.ret:
  ret void

b88:
  %idx.for.offset = phi i32 [ 0, %c60 ], [ %count.ld, %loop.cont ]
  %rdi.call = call i8* @sub_140002610(i8* %rcx)
  %isnull = icmp eq i8* %rdi.call, null
  br i1 %isnull, label %c82, label %alloc.path

c82:
  %fmt.c82 = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.c82, i8* %rcx)
  ret void

alloc.path:
  %base.ptr = load i8*, i8** @qword_1400070A8, align 8
  %idx.sext = sext i32 %idx.for.offset to i64
  %mul5 = mul nsw i64 %idx.sext, 5
  %offset40 = shl i64 %mul5, 3
  %entry.off = getelementptr inbounds i8, i8* %base.ptr, i64 %offset40
  %off.plus32 = getelementptr inbounds i8, i8* %entry.off, i64 32
  %off.plus32.ptr = bitcast i8* %off.plus32 to i8**
  store i8* %rdi.call, i8** %off.plus32.ptr, align 8
  %entry.i32ptr = bitcast i8* %entry.off to i32*
  store i32 0, i32* %entry.i32ptr, align 4
  %rax2 = call i8* @sub_140002750()
  %rdi.plus12 = getelementptr inbounds i8, i8* %rdi.call, i64 12
  %rdi.plus12.i32 = bitcast i8* %rdi.plus12 to i32*
  %edx12 = load i32, i32* %rdi.plus12.i32, align 4
  %edx12.z = zext i32 %edx12 to i64
  %rcx.ptr = getelementptr inbounds i8, i8* %rax2, i64 %edx12.z
  %off.plus24 = getelementptr inbounds i8, i8* %entry.off, i64 24
  %off.plus24.ptr = bitcast i8* %off.plus24 to i8**
  store i8* %rcx.ptr, i8** %off.plus24.ptr, align 8
  %impVQ = load i64 (i8*, %struct.MBI*, i64)*, i64 (i8*, %struct.MBI*, i64)** @__imp_VirtualQuery, align 8
  %vq.ret = call i64 %impVQ(i8* %rcx.ptr, %struct.MBI* %buf, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %c67, label %after.VQ

c67:
  %field18 = getelementptr inbounds i8, i8* %entry.off, i64 24
  %field18.ptr = bitcast i8* %field18 to i8**
  %stored.addr = load i8*, i8** %field18.ptr, align 8
  %rdi.plus8 = getelementptr inbounds i8, i8* %rdi.call, i64 8
  %rdi.plus8.i32 = bitcast i8* %rdi.plus8 to i32*
  %edx8 = load i32, i32* %rdi.plus8.i32, align 4
  %fmt.c67 = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.c67, i32 %edx8, i8* %stored.addr)
  br label %c82

after.VQ:
  %prot.ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %buf, i32 0, i32 7
  %prot = load i32, i32* %prot.ptr, align 4
  %t1 = add i32 %prot, -4
  %m1 = and i32 %t1, -5
  %z1 = icmp eq i32 %m1, 0
  br i1 %z1, label %bfe, label %cont.prot

cont.prot:
  %t2 = add i32 %prot, -64
  %m2 = and i32 %t2, -65
  %nz2 = icmp ne i32 %m2, 0
  br i1 %nz2, label %c10, label %bfe

bfe:
  %c.old = load i32, i32* @dword_1400070A4, align 4
  %c.inc = add i32 %c.old, 1
  store i32 %c.inc, i32* @dword_1400070A4, align 4
  br label %c05.ret

c10:
  %is.two = icmp eq i32 %prot, 2
  %newprot = select i1 %is.two, i32 4, i32 64
  %base.addr.ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %buf, i32 0, i32 0
  %lpAddress = load i8*, i8** %base.addr.ptr, align 8
  %size.ptr = getelementptr inbounds %struct.MBI, %struct.MBI* %buf, i32 0, i32 5
  %dwSize = load i64, i64* %size.ptr, align 8
  %entry.abs = getelementptr inbounds i8, i8* %base.ptr, i64 %offset40
  %entry.plus8 = getelementptr inbounds i8, i8* %entry.abs, i64 8
  %entry.plus8.ptr = bitcast i8* %entry.plus8 to i8**
  store i8* %lpAddress, i8** %entry.plus8.ptr, align 8
  %entry.plus16 = getelementptr inbounds i8, i8* %entry.abs, i64 16
  %entry.plus16.i64 = bitcast i8* %entry.plus16 to i64*
  store i64 %dwSize, i64* %entry.plus16.i64, align 8
  %impVP = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %oldprot.ptr = bitcast i8* %entry.abs to i32*
  %vp.ok = call i32 %impVP(i8* %lpAddress, i64 %dwSize, i32 %newprot, i32* %oldprot.ptr)
  %oknz = icmp ne i32 %vp.ok, 0
  br i1 %oknz, label %bfe, label %prot.fail

prot.fail:
  %impGLE = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  %err = call i32 %impGLE()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  br label %c60
}
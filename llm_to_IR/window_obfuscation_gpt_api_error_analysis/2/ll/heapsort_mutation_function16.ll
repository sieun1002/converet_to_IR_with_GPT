; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = private unnamed_addr constant [40 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [50 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare dllimport i64 @VirtualQuery(i8* nocapture, %struct.MEMORY_BASIC_INFORMATION* nocapture, i64)
declare dllimport i32 @VirtualProtect(i8* nocapture, i64, i32, i32* nocapture)
declare dllimport i32 @GetLastError()

declare i8* @sub_140002610(i8* nocapture)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %count.ptr = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count.ptr, 0
  br i1 %gt0, label %scan.init, label %create.path

scan.init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scan.start = getelementptr inbounds i8, i8* %base0, i64 24
  br label %scan.loop

scan.loop:
  %i.phi = phi i32 [ 0, %scan.init ], [ %i.next, %scan.next ]
  %ptr.phi = phi i8* [ %scan.start, %scan.init ], [ %ptr.next, %scan.next ]
  %i64.addr = ptrtoint i8* %addr to i64

  ; load entry base address at offset +0x18 within entry
  %ptr.as.ptr = bitcast i8* %ptr.phi to i8**
  %entry.base = load i8*, i8** %ptr.as.ptr, align 8
  %entry.base.i = ptrtoint i8* %entry.base to i64
  %is.below = icmp ult i64 %i64.addr, %entry.base.i
  br i1 %is.below, label %scan.next, label %cmp.upper

cmp.upper:
  ; load pointer at entry+0x20, then read 32-bit size at +8 from that pointer
  %ptr.plus8 = getelementptr inbounds i8, i8* %ptr.phi, i64 8
  %ptr.plus8.as.ptr = bitcast i8* %ptr.plus8 to i8**
  %struct.ptr = load i8*, i8** %ptr.plus8.as.ptr, align 8
  %size.field.ptr = getelementptr inbounds i8, i8* %struct.ptr, i64 8
  %size.field.i32p = bitcast i8* %size.field.ptr to i32*
  %size32 = load i32, i32* %size.field.i32p, align 4
  %size64 = zext i32 %size32 to i64
  %end.i = add i64 %entry.base.i, %size64
  %in.range = icmp ult i64 %i64.addr, %end.i
  br i1 %in.range, label %ret, label %scan.next

scan.next:
  %i.next = add i32 %i.phi, 1
  %ptr.next = getelementptr inbounds i8, i8* %ptr.phi, i64 40
  %cont = icmp ne i32 %i.next, %count.ptr
  br i1 %cont, label %scan.loop, label %create.path

create.path:
  ; choose index = max(count, 0)
  %idx.sel = select i1 %gt0, i32 %count.ptr, i32 0

  ; try to get section info for address
  %sect.info = call i8* @sub_140002610(i8* %addr)
  %sect.null = icmp eq i8* %sect.info, null
  br i1 %sect.null, label %no.image, label %have.image

have.image:
  ; compute entry pointer: base + (idx*40)
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %idx.sel to i64
  %mul5 = mul nsw i64 %idx64, 5
  %offset.bytes = shl i64 %mul5, 3
  %entry.ptr = getelementptr inbounds i8, i8* %base1, i64 %offset.bytes

  ; entry[0x20] = sect.info
  %entry.p20 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %entry.p20.as = bitcast i8* %entry.p20 to i8**
  store i8* %sect.info, i8** %entry.p20.as, align 8

  ; entry[0x00] = 0 (old protect placeholder)
  %entry.p00.as = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.p00.as, align 4

  ; compute address to query: sub_140002750() + [sect.info+0x0C]
  %img.base = call i8* @sub_140002750()
  %sect.ofs.ptr = getelementptr inbounds i8, i8* %sect.info, i64 12
  %sect.ofs.i32p = bitcast i8* %sect.ofs.ptr to i32*
  %sect.ofs = load i32, i32* %sect.ofs.i32p, align 4
  %sect.ofs64 = sext i32 %sect.ofs to i64
  %vq.addr = getelementptr inbounds i8, i8* %img.base, i64 %sect.ofs64

  ; entry[0x18] = vq.addr
  %entry.p18 = getelementptr inbounds i8, i8* %entry.ptr, i64 24
  %entry.p18.as = bitcast i8* %entry.p18 to i8**
  store i8* %vq.addr, i8** %entry.p18.as, align 8

  ; VirtualQuery(vq.addr, &buf, 0x30)
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vq.ret = call i64 @VirtualQuery(i8* %vq.addr, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %vq.okay, label %vq.fail

vq.okay:
  ; eax = Buffer.Protect
  %buf.protect.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 6
  %prot = load i32, i32* %buf.protect.ptr, align 4

  ; if (((prot - 4) & ~4) == 0) goto inc.count
  %sub4 = sub i32 %prot, 4
  %mask4 = and i32 %sub4, -5
  %is.ok1 = icmp eq i32 %mask4, 0
  br i1 %is.ok1, label %inc.count, label %check.exec

check.exec:
  ; if (((prot - 0x40) & ~0x40) != 0) => need VirtualProtect, else inc.count
  %sub40 = sub i32 %prot, 64
  %mask40 = and i32 %sub40, -65
  %need.vp = icmp ne i32 %mask40, 0
  br i1 %need.vp, label %do.vprotect, label %inc.count

do.vprotect:
  ; r8d = (prot == 2) ? 4 : 0x40
  %is.readonly = icmp eq i32 %prot, 2
  %np.sel = select i1 %is.readonly, i32 4, i32 64

  ; lpAddress = Buffer.BaseAddress
  %buf.base.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 0
  %lpAddress = load i8*, i8** %buf.base.ptr, align 8

  ; dwSize = Buffer.RegionSize
  %buf.size.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 4
  %dwSize = load i64, i64* %buf.size.ptr, align 8

  ; entry[0x08] = lpAddress
  %entry.p08 = getelementptr inbounds i8, i8* %entry.ptr, i64 8
  %entry.p08.as = bitcast i8* %entry.p08 to i8**
  store i8* %lpAddress, i8** %entry.p08.as, align 8

  ; entry[0x10] = dwSize
  %entry.p10 = getelementptr inbounds i8, i8* %entry.ptr, i64 16
  %entry.p10.as = bitcast i8* %entry.p10 to i64*
  store i64 %dwSize, i64* %entry.p10.as, align 8

  ; call VirtualProtect(lpAddress, dwSize, np.sel, &entry[0])
  %oldprot.ptr = bitcast i8* %entry.ptr to i32*
  %vp.ret = call i32 @VirtualProtect(i8* %lpAddress, i64 %dwSize, i32 %np.sel, i32* %oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %inc.count, label %vp.fail

vp.fail:
  %gle = call i32 @GetLastError()
  %fmt.vp.ptr = getelementptr inbounds [40 x i8], [40 x i8]* @aVirtualprotect, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt.vp.ptr, i32 %gle)
  br label %ret

vq.fail:
  ; edx = [sect.info + 8]
  %sect.bytes.ptr = getelementptr inbounds i8, i8* %sect.info, i64 8
  %sect.bytes.i32p = bitcast i8* %sect.bytes.ptr to i32*
  %sect.bytes = load i32, i32* %sect.bytes.i32p, align 4

  ; r8 = entry[0x18] (address that failed)
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %ent.addr.ptr = getelementptr inbounds i8, i8* %base2, i64 %offset.bytes
  %ent.addr.p18 = getelementptr inbounds i8, i8* %ent.addr.ptr, i64 24
  %ent.addr.p18.as = bitcast i8* %ent.addr.p18 to i8**
  %failed.addr = load i8*, i8** %ent.addr.p18.as, align 8

  %fmt.vq.ptr = getelementptr inbounds [50 x i8], [50 x i8]* @aVirtualqueryFa, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt.vq.ptr, i32 %sect.bytes, i8* %failed.addr)
  br label %ret

inc.count:
  %old = load i32, i32* @dword_1400070A4, align 4
  %new = add i32 %old, 1
  store i32 %new, i32* @dword_1400070A4, align 4
  br label %ret

no.image:
  %fmt.noimg.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i32 0, i32 0
  call void @sub_140001AD0(i8* %fmt.noimg.ptr, i8* %addr)
  br label %ret

ret:
  ret void
}
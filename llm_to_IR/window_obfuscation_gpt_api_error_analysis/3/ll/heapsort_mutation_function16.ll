; ModuleID = 'sub_140001B30'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

@.str_vprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@.str_vquery   = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@.str_noimg    = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare dllimport i64 @VirtualQuery(i8* noundef, %struct.MEMORY_BASIC_INFORMATION* noundef, i64 noundef)
declare dllimport i32 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)
declare dllimport i32 @GetLastError()

declare i8* @sub_140002610(i8* noundef)
declare i8* @sub_140002750()
declare i32 @sub_140001AD0(i8* noundef, ...)

define void @sub_140001B30(i8* noundef %addr) local_unnamed_addr {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %has_entries = icmp sgt i32 %count0, 0
  br i1 %has_entries, label %scan.init, label %process

scan.init:
  %base.scan = load i8*, i8** @qword_1400070A8, align 8
  br label %scan.loop

scan.loop:
  %i = phi i32 [ 0, %scan.init ], [ %i.next, %scan.cont ]
  %count.cur = phi i32 [ %count0, %scan.init ], [ %count0, %scan.cont ]
  %i.zext = zext i32 %i to i64
  %off.entries = mul i64 %i.zext, 40
  %off.start = add i64 %off.entries, 24
  %ptr.start.i8 = getelementptr inbounds i8, i8* %base.scan, i64 %off.start
  %ptr.start = bitcast i8* %ptr.start.i8 to i8**
  %start = load i8*, i8** %ptr.start, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start to i64
  %addr_ult_start = icmp ult i64 %addr.int, %start.int
  br i1 %addr_ult_start, label %scan.cont, label %scan.check_end

scan.check_end:
  %off.sechdr = add i64 %off.entries, 32
  %ptr.sechdr.i8 = getelementptr inbounds i8, i8* %base.scan, i64 %off.sechdr
  %ptr.sechdr = bitcast i8* %ptr.sechdr.i8 to i8**
  %sechdr = load i8*, i8** %ptr.sechdr, align 8
  %sechdr.vsize.ptr.i8 = getelementptr inbounds i8, i8* %sechdr, i64 8
  %sechdr.vsize.ptr = bitcast i8* %sechdr.vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %sechdr.vsize.ptr, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %end.int = add i64 %start.int, %vsize64
  %addr_ult_end = icmp ult i64 %addr.int, %end.int
  br i1 %addr_ult_end, label %ret, label %scan.cont

scan.cont:
  %i.next = add i32 %i, 1
  %cont = icmp slt i32 %i.next, %count.cur
  br i1 %cont, label %scan.loop, label %process

process:
  %sect = call i8* @sub_140002610(i8* noundef %addr)
  %sect.isnull = icmp eq i8* %sect, null
  br i1 %sect.isnull, label %no_image, label %have_section

have_section:
  %count1 = load i32, i32* @dword_1400070A4, align 4
  %base = load i8*, i8** @qword_1400070A8, align 8
  %count1.zext = zext i32 %count1 to i64
  %entry.off = mul i64 %count1.zext, 40
  %entry.ptr = getelementptr inbounds i8, i8* %base, i64 %entry.off
  %entry.oldprot.ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.oldprot.ptr, align 4
  %entry.sechdr.ptr.i8 = getelementptr inbounds i8, i8* %entry.ptr, i64 32
  %entry.sechdr.ptr = bitcast i8* %entry.sechdr.ptr.i8 to i8**
  store i8* %sect, i8** %entry.sechdr.ptr, align 8
  %modbase = call i8* @sub_140002750()
  %sect.vaddr.ptr.i8 = getelementptr inbounds i8, i8* %sect, i64 12
  %sect.vaddr.ptr = bitcast i8* %sect.vaddr.ptr.i8 to i32*
  %vaddr32 = load i32, i32* %sect.vaddr.ptr, align 4
  %vaddr64 = zext i32 %vaddr32 to i64
  %section.start.i8 = getelementptr inbounds i8, i8* %modbase, i64 %vaddr64
  %entry.start.ptr.i8 = getelementptr inbounds i8, i8* %entry.ptr, i64 24
  %entry.start.ptr = bitcast i8* %entry.start.ptr.i8 to i8**
  store i8* %section.start.i8, i8** %entry.start.ptr, align 8
  %mbi = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vq = call i64 @VirtualQuery(i8* noundef %section.start.i8, %struct.MEMORY_BASIC_INFORMATION* noundef %mbi, i64 noundef 48)
  %vq.ok = icmp ne i64 %vq, 0
  br i1 %vq.ok, label %vq_ok, label %vq_fail

vq_ok:
  %prot.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 6
  %prot = load i32, i32* %prot.ptr, align 4
  %is4 = icmp eq i32 %prot, 4
  %is8 = icmp eq i32 %prot, 8
  %is40 = icmp eq i32 %prot, 64
  %is80 = icmp eq i32 %prot, 128
  %cond48 = or i1 %is4, %is8
  %cond40 = or i1 %is40, %is80
  %cond_ok = or i1 %cond48, %cond40
  br i1 %cond_ok, label %inc_and_ret, label %do_vprotect

do_vprotect:
  %newprot.sel.cmp = icmp eq i32 %prot, 2
  %newprot.ifro = select i1 %newprot.sel.cmp, i32 4, i32 64
  %baseaddr.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %rsize.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 4
  %rsize = load i64, i64* %rsize.ptr, align 8
  %entry.addr.ptr.i8 = getelementptr inbounds i8, i8* %entry.ptr, i64 8
  %entry.addr.ptr = bitcast i8* %entry.addr.ptr.i8 to i8**
  store i8* %baseaddr, i8** %entry.addr.ptr, align 8
  %entry.size.ptr.i8 = getelementptr inbounds i8, i8* %entry.ptr, i64 16
  %entry.size.ptr = bitcast i8* %entry.size.ptr.i8 to i64*
  store i64 %rsize, i64* %entry.size.ptr, align 8
  %vp.ok.i32 = call i32 @VirtualProtect(i8* noundef %baseaddr, i64 noundef %rsize, i32 noundef %newprot.ifro, i32* noundef %entry.oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.ok.i32, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %err = call i32 @GetLastError()
  %fmt1.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @.str_vprotect, i64 0, i64 0
  %call_log1 = call i32 (i8*, ...) @sub_140001AD0(i8* noundef %fmt1.ptr, i32 noundef %err)
  br label %ret

vq_fail:
  %bytes.ptr.i8 = getelementptr inbounds i8, i8* %sect, i64 8
  %bytes.ptr = bitcast i8* %bytes.ptr.i8 to i32*
  %bytes = load i32, i32* %bytes.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @.str_vquery, i64 0, i64 0
  %call_log2 = call i32 (i8*, ...) @sub_140001AD0(i8* noundef %fmt2.ptr, i32 noundef %bytes, i8* noundef %section.start.i8)
  br label %ret

inc_and_ret:
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %ret

no_image:
  %fmt3.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @.str_noimg, i64 0, i64 0
  %call_log3 = call i32 (i8*, ...) @sub_140001AD0(i8* noundef %fmt3.ptr, i8* noundef %addr)
  br label %ret

ret:
  ret void
}
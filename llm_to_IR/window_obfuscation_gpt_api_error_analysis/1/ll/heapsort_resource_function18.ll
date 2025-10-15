; ModuleID = 'sub_140001B30.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i16, i16, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare dllimport i64 @VirtualQuery(i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
declare dllimport i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dllimport i32 @GetLastError()
declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i32 @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %cnt0 = load i32, i32* @dword_1400070A4
  %has_entries = icmp sgt i32 %cnt0, 0
  br i1 %has_entries, label %search.pre, label %prepare.idx0

search.pre:
  %tab.ptr0 = load i8*, i8** @qword_1400070A8
  %pptr.init = getelementptr i8, i8* %tab.ptr0, i64 24
  br label %search.loop

search.loop:
  %i.phi = phi i32 [ 0, %search.pre ], [ %i.next, %search.inc ]
  %pptr.phi = phi i8* [ %pptr.init, %search.pre ], [ %pptr.next, %search.inc ]
  %base.ptr.addr = bitcast i8* %pptr.phi to i8**
  %base.ptr = load i8*, i8** %base.ptr.addr
  %addr.i = ptrtoint i8* %addr to i64
  %base.i = ptrtoint i8* %base.ptr to i64
  %below = icmp ult i64 %addr.i, %base.i
  br i1 %below, label %search.inc, label %search.check.range

search.check.range:
  %desc.slot.addr.i8 = getelementptr i8, i8* %pptr.phi, i64 8
  %desc.slot = bitcast i8* %desc.slot.addr.i8 to i8**
  %desc.ptr = load i8*, i8** %desc.slot
  %desc.len.addr.i8 = getelementptr i8, i8* %desc.ptr, i64 8
  %desc.len.ptr = bitcast i8* %desc.len.addr.i8 to i32*
  %len32 = load i32, i32* %desc.len.ptr
  %len64 = zext i32 %len32 to i64
  %end.i = add i64 %base.i, %len64
  %in.range = icmp ult i64 %addr.i, %end.i
  br i1 %in.range, label %ret, label %search.inc

search.inc:
  %i.next = add i32 %i.phi, 1
  %pptr.next = getelementptr i8, i8* %pptr.phi, i64 40
  %cont = icmp ne i32 %i.next, %cnt0
  br i1 %cont, label %search.loop, label %prepare.idxN

prepare.idxN:
  br label %call_sub.prepare

prepare.idx0:
  br label %call_sub.prepare

call_sub.prepare:
  %idx.sel = phi i32 [ 0, %prepare.idx0 ], [ %cnt0, %prepare.idxN ], [ 0, %vp.retry ]
  %desc.call = call i8* @sub_140002610(i8* %addr)
  %desc.isnull = icmp eq i8* %desc.call, null
  br i1 %desc.isnull, label %no.image, label %setup.entry

setup.entry:
  %tab.ptr1 = load i8*, i8** @qword_1400070A8
  %idx64 = sext i32 %idx.sel to i64
  %off40 = mul i64 %idx64, 40
  %entry.base = getelementptr i8, i8* %tab.ptr1, i64 %off40
  %entry.oldprot.ptr = bitcast i8* %entry.base to i32*
  store i32 0, i32* %entry.oldprot.ptr
  %entry.desc.slot.addr = getelementptr i8, i8* %entry.base, i64 32
  %entry.desc.slot.ptr = bitcast i8* %entry.desc.slot.addr to i8**
  store i8* %desc.call, i8** %entry.desc.slot.ptr
  %mod.base = call i8* @sub_140002750()
  %desc.off.addr.i8 = getelementptr i8, i8* %desc.call, i64 12
  %desc.off.ptr = bitcast i8* %desc.off.addr.i8 to i32*
  %off32 = load i32, i32* %desc.off.ptr
  %off64 = sext i32 %off32 to i64
  %comp.addr = getelementptr i8, i8* %mod.base, i64 %off64
  %entry.comp.slot.addr = getelementptr i8, i8* %entry.base, i64 24
  %entry.comp.slot = bitcast i8* %entry.comp.slot.addr to i8**
  store i8* %comp.addr, i8** %entry.comp.slot
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vq.sz = call i64 @VirtualQuery(i8* %comp.addr, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vq.ok = icmp ne i64 %vq.sz, 0
  br i1 %vq.ok, label %protect.check, label %vq.fail

vq.fail:
  %desc.bytes.addr.i8 = getelementptr i8, i8* %desc.call, i64 8
  %desc.bytes.ptr = bitcast i8* %desc.bytes.addr.i8 to i32*
  %bytes = load i32, i32* %desc.bytes.ptr
  %comp.addr.reload = load i8*, i8** %entry.comp.slot
  %fmt.vq = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %call.vqlog = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %bytes, i8* %comp.addr.reload)
  br label %no.image

protect.check:
  %prot.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 7
  %prot = load i32, i32* %prot.ptr
  %tA = sub i32 %prot, 4
  %tB = and i32 %tA, -5
  %is.ok1 = icmp eq i32 %tB, 0
  br i1 %is.ok1, label %inc.ret, label %protect.check2

protect.check2:
  %tC = sub i32 %prot, 64
  %tD = and i32 %tC, -65
  %need.vp = icmp ne i32 %tD, 0
  br i1 %need.vp, label %do.vp, label %inc.ret

do.vp:
  %prot.is2 = icmp eq i32 %prot, 2
  %newProt.sel = select i1 %prot.is2, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr
  %rgnsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 5
  %rgnsize = load i64, i64* %rgnsize.ptr
  %entry.base.addr.slot = getelementptr i8, i8* %entry.base, i64 8
  %entry.base.ptr = bitcast i8* %entry.base.addr.slot to i8**
  store i8* %baseaddr, i8** %entry.base.ptr
  %entry.sz.addr = getelementptr i8, i8* %entry.base, i64 16
  %entry.sz.ptr = bitcast i8* %entry.sz.addr to i64*
  store i64 %rgnsize, i64* %entry.sz.ptr
  %vp.ok.i32 = call i32 @VirtualProtect(i8* %baseaddr, i64 %rgnsize, i32 %newProt.sel, i32* %entry.oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.ok.i32, 0
  br i1 %vp.ok, label %inc.ret, label %vp.fail

vp.fail:
  %err = call i32 @GetLastError()
  %fmt.vp = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %call.vplog = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  br label %vp.retry

vp.retry:
  br label %call_sub.prepare

inc.ret:
  %oldcnt = load i32, i32* @dword_1400070A4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4
  br label %ret

no.image:
  %fmt.noimg = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %call.noimg = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.noimg, i8* %addr)
  br label %ret

ret:
  ret void
}
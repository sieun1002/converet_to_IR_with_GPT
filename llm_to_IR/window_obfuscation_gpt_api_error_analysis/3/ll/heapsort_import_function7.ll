; target: Windows x86-64 (MSVC)
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.MBI = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@qword_140008260 = external dso_local global i32 ()*

@aVirtualprotect = external dso_local global i8
@aVirtualqueryFa = external dso_local global i8
@aAddressPHasNoI = external dso_local global i8

declare dso_local i8* @sub_140002610(i8*)
declare dso_local i8* @sub_140002750()
declare dso_local i64 @sub_14001FAD3(i8*, i8*, i32)
declare dso_local i32 @loc_14000EEBA(i8*, i64, i32, i8*)
declare dso_local void @sub_140001AD0(i8*, ...)

define dso_local void @sub_140001B30(i8* %addr) local_unnamed_addr {
entry:
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %count.pos = icmp sgt i32 %count.load, 0
  br i1 %count.pos, label %scan.prep, label %call_lookup

scan.prep:
  %tbl.base.ptr = load i8*, i8** @qword_1400070A8, align 8
  %tbl.base.plus18 = getelementptr i8, i8* %tbl.base.ptr, i64 24
  br label %scan.loop

scan.loop:
  %i = phi i32 [ 0, %scan.prep ], [ %i.next, %loop.cont ]
  %i.sext = sext i32 %i to i64
  %entry.off = mul i64 %i.sext, 40
  %entry.field18.addr = getelementptr i8, i8* %tbl.base.plus18, i64 %entry.off
  %entry.field18.ptrptr = bitcast i8* %entry.field18.addr to i8**
  %start.ptr = load i8*, i8** %entry.field18.ptrptr, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start.ptr to i64
  %addr.before.start = icmp ult i64 %addr.int, %start.int
  br i1 %addr.before.start, label %loop.cont, label %load.size

load.size:
  %entry.field20.addr = getelementptr i8, i8* %entry.field18.addr, i64 8
  %entry.field20.ptrptr = bitcast i8* %entry.field20.addr to i8**
  %module.ptr = load i8*, i8** %entry.field20.ptrptr, align 8
  %module.size.addr = getelementptr i8, i8* %module.ptr, i64 8
  %module.size.ptr = bitcast i8* %module.size.addr to i32*
  %module.size32 = load i32, i32* %module.size.ptr, align 4
  %module.size64 = zext i32 %module.size32 to i64
  %end.ptr = getelementptr i8, i8* %start.ptr, i64 %module.size64
  %end.int = ptrtoint i8* %end.ptr to i64
  %addr.before.end = icmp ult i64 %addr.int, %end.int
  br i1 %addr.before.end, label %ret, label %loop.cont

loop.cont:
  %i.next = add i32 %i, 1
  %cont.more = icmp slt i32 %i.next, %count.load
  br i1 %cont.more, label %scan.loop, label %call_lookup

call_lookup:
  %mod.lookup = call i8* @sub_140002610(i8* %addr)
  %mod.ok = icmp ne i8* %mod.lookup, null
  br i1 %mod.ok, label %have_mod, label %no_mod

no_mod:
  %fmt.nomod = bitcast i8* @aAddressPHasNoI to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.nomod, i8* %addr)
  br label %ret

have_mod:
  %tbl.base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %count.load to i64
  %new.entry.off = mul i64 %idx64, 40
  %entry.ptr = getelementptr i8, i8* %tbl.base2, i64 %new.entry.off
  %entry.field20.addr.new = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.field20.ptrptr.new = bitcast i8* %entry.field20.addr.new to i8**
  store i8* %mod.lookup, i8** %entry.field20.ptrptr.new, align 8
  %entry.field0.ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.field0.ptr, align 4
  %base3 = call i8* @sub_140002750()
  %mod.off.addr = getelementptr i8, i8* %mod.lookup, i64 12
  %mod.off.ptr = bitcast i8* %mod.off.addr to i32*
  %mod.off32 = load i32, i32* %mod.off.ptr, align 4
  %mod.off64 = zext i32 %mod.off32 to i64
  %mapped.addr = getelementptr i8, i8* %base3, i64 %mod.off64
  %entry.field18.addr.new = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.field18.ptrptr.new = bitcast i8* %entry.field18.addr.new to i8**
  store i8* %mapped.addr, i8** %entry.field18.ptrptr.new, align 8
  %mbi.alloca = alloca %struct.MBI, align 8
  %mbi.i8 = bitcast %struct.MBI* %mbi.alloca to i8*
  %vq.ret = call i64 @sub_14001FAD3(i8* %mapped.addr, i8* %mbi.i8, i32 48)
  %vq.ok = icmp ne i64 %vq.ret, 0
  br i1 %vq.ok, label %check.protect, label %vq.failed

vq.failed:
  %mod.size.addr2 = getelementptr i8, i8* %mod.lookup, i64 8
  %mod.size.ptr2 = bitcast i8* %mod.size.addr2 to i32*
  %mod.size32b = load i32, i32* %mod.size.ptr2, align 4
  %fmt.vq = bitcast i8* @aVirtualqueryFa to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %mod.size32b, i8* %mapped.addr)
  br label %ret

check.protect:
  %prot.ptr = getelementptr %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 6
  %prot.val = load i32, i32* %prot.ptr, align 4
  %sub4 = add i32 %prot.val, -4
  %mask1 = and i32 %sub4, -5
  %is.zero1 = icmp eq i32 %mask1, 0
  br i1 %is.zero1, label %increment, label %check.exec

check.exec:
  %sub64 = add i32 %prot.val, -64
  %mask2 = and i32 %sub64, -65
  %is.zero2 = icmp eq i32 %mask2, 0
  br i1 %is.zero2, label %increment, label %need.vprotect

need.vprotect:
  %is.readonly = icmp eq i32 %prot.val, 2
  %new.prot = select i1 %is.readonly, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regsize.ptr = getelementptr %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 4
  %regsize = load i64, i64* %regsize.ptr, align 8
  %entry.field08.addr = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.field08.ptrptr = bitcast i8* %entry.field08.addr to i8**
  store i8* %baseaddr, i8** %entry.field08.ptrptr, align 8
  %entry.field10.addr = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.field10.ptr = bitcast i8* %entry.field10.addr to i64*
  store i64 %regsize, i64* %entry.field10.ptr, align 8
  %vp.res = call i32 @loc_14000EEBA(i8* %baseaddr, i64 %regsize, i32 %new.prot, i8* %entry.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %increment, label %vp.fail

vp.fail:
  %getlasterror.fp = load i32 ()*, i32 ()** @qword_140008260, align 8
  %errcode = call i32 %getlasterror.fp()
  %fmt.vp = bitcast i8* @aVirtualprotect to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %errcode)
  br label %ret

increment:
  %old.count = load i32, i32* @dword_1400070A4, align 4
  %new.count = add i32 %old.count, 1
  store i32 %new.count, i32* @dword_1400070A4, align 4
  br label %ret

ret:
  ret void
}
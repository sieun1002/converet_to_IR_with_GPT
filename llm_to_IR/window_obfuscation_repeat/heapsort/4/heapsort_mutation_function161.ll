; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Entry = type { i32, i32, i8*, i64, i8*, i8* }
%struct.MBI = type { i8*, i8*, i32, i32, i64, i32, i32, i32, i32 }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global %struct.Entry*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

declare i64 @VirtualQuery(i8*, %struct.MBI*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %addr) {
entry:
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %has.entries = icmp sgt i32 %count.load, 0
  br i1 %has.entries, label %loop.entry, label %prepare

loop.entry:
  %base.ptr0 = load %struct.Entry*, %struct.Entry** @qword_1400070A8, align 8
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.entry ], [ %inc, %loop.inc ]
  %base.ptr = phi %struct.Entry* [ %base.ptr0, %loop.entry ], [ %base.ptr0, %loop.inc ]
  %i64 = sext i32 %i to i64
  %e.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %base.ptr, i64 %i64
  %addrq.gep = getelementptr inbounds %struct.Entry, %struct.Entry* %e.ptr, i32 0, i32 4
  %start.load = load i8*, i8** %addrq.gep, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start.load to i64
  %addr.before.start = icmp ult i64 %addr.int, %start.int
  br i1 %addr.before.start, label %loop.inc, label %check.end

check.end:
  %sectptr.gep = getelementptr inbounds %struct.Entry, %struct.Entry* %e.ptr, i32 0, i32 5
  %sect.ptr = load i8*, i8** %sectptr.gep, align 8
  %sect.plus8 = getelementptr inbounds i8, i8* %sect.ptr, i64 8
  %len32.ptr = bitcast i8* %sect.plus8 to i32*
  %len32 = load i32, i32* %len32.ptr, align 4
  %len64 = sext i32 %len32 to i64
  %end.int = add i64 %start.int, %len64
  %addr.before.end = icmp ult i64 %addr.int, %end.int
  br i1 %addr.before.end, label %found, label %loop.inc

found:
  br label %epilogue

loop.inc:
  %inc = add i32 %i, 1
  %more = icmp slt i32 %inc, %count.load
  br i1 %more, label %loop, label %prepare

prepare:
  %sect.new = call i8* @sub_140002610(i8* %addr)
  %sect.isnull = icmp eq i8* %sect.new, null
  br i1 %sect.isnull, label %no.section, label %have.section

no.section:
  %fmt.addr.no = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.addr.no, i8* %addr)
  br label %epilogue

have.section:
  %base.ptr1 = load %struct.Entry*, %struct.Entry** @qword_1400070A8, align 8
  %count64 = sext i32 %count.load to i64
  %entry.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %base.ptr1, i64 %count64
  %sect.field = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 5
  store i8* %sect.new, i8** %sect.field, align 8
  %oldprot.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 0
  store i32 0, i32* %oldprot.ptr, align 8
  %base.addr.call = call i8* @sub_140002750()
  %sect.plus0c = getelementptr inbounds i8, i8* %sect.new, i64 12
  %off32.ptr = bitcast i8* %sect.plus0c to i32*
  %off32 = load i32, i32* %off32.ptr, align 4
  %off64 = sext i32 %off32 to i64
  %lpAddress = getelementptr inbounds i8, i8* %base.addr.call, i64 %off64
  %addrq.field = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 4
  store i8* %lpAddress, i8** %addrq.field, align 8
  %mbi.alloca = alloca %struct.MBI, align 8
  %vq.ret = call i64 @VirtualQuery(i8* %lpAddress, %struct.MBI* %mbi.alloca, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %vq.fail, label %vq.ok

vq.ok:
  %prot.gep = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 6
  %prot.val = load i32, i32* %prot.gep, align 4
  %is4 = icmp eq i32 %prot.val, 4
  %is8 = icmp eq i32 %prot.val, 8
  %is64 = icmp eq i32 %prot.val, 64
  %is128 = icmp eq i32 %prot.val, 128
  %ok48 = or i1 %is4, %is8
  %ok64128 = or i1 %is64, %is128
  %ok.any = or i1 %ok48, %ok64128
  br i1 %ok.any, label %inc.count, label %do.vp

do.vp:
  %is2 = icmp eq i32 %prot.val, 2
  %flnew = select i1 %is2, i32 4, i32 64
  %baseaddr.gep = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 0
  %baseaddr.val = load i8*, i8** %baseaddr.gep, align 8
  %regionsize.gep = getelementptr inbounds %struct.MBI, %struct.MBI* %mbi.alloca, i32 0, i32 4
  %regionsize.val = load i64, i64* %regionsize.gep, align 8
  %entry.baseaddr = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 2
  store i8* %baseaddr.val, i8** %entry.baseaddr, align 8
  %entry.regsize = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 3
  store i64 %regionsize.val, i64* %entry.regsize, align 8
  %vp.ret = call i32 @VirtualProtect(i8* %baseaddr.val, i64 %regionsize.val, i32 %flnew, i32* %oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %inc.count, label %vp.fail

inc.count:
  %cnt.old = load i32, i32* @dword_1400070A4, align 4
  %cnt.new = add i32 %cnt.old, 1
  store i32 %cnt.new, i32* @dword_1400070A4, align 4
  br label %epilogue

vp.fail:
  %err = call i32 @GetLastError()
  %fmt.vp = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %err)
  br label %epilogue

vq.fail:
  %sect.plus8b = getelementptr inbounds i8, i8* %sect.new, i64 8
  %bytes.ptr = bitcast i8* %sect.plus8b to i32*
  %bytes.val = load i32, i32* %bytes.ptr, align 4
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %addrq.load = load i8*, i8** %addrq.field, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %bytes.val, i8* %addrq.load)
  br label %epilogue

epilogue:
  ret void
}
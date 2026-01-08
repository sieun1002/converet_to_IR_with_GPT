; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare i8* @sub_140002250(i8* noundef)
declare i8* @sub_140002390()
declare i32 @loc_140012A4E(i8* noundef, i8* noundef, i32 noundef)
declare i32 @loc_1400D1740(i8* noundef, i8* noundef, i32 noundef, i8* noundef)
declare i32 @sub_140001700(i8* noundef, ...)

define void @sub_140001760(i8* noundef %addr) local_unnamed_addr {
entry:
  %buf_var48 = alloca i64, align 8
  %buf_var30 = alloca i64, align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %count32, 0
  br i1 %pos, label %scan.init, label %no.count

scan.init:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  br label %scan.loop

scan.loop:
  %idx.ph = phi i32 [ 0, %scan.init ], [ %idx.next, %cont.loop ]
  %base.ph = phi i8* [ %base0, %scan.init ], [ %base1, %cont.loop ]
  %idx64 = zext i32 %idx.ph to i64
  %off.mul = mul i64 %idx64, 40
  %off.field = add i64 %off.mul, 24
  %cur.addr = getelementptr i8, i8* %base.ph, i64 %off.field
  %cur.ptrptr = bitcast i8* %cur.addr to i8**
  %start.ptr = load i8*, i8** %cur.ptrptr, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start.ptr to i64
  %lt.start = icmp ult i64 %addr.int, %start.int
  br i1 %lt.start, label %cont.loop, label %check.range

check.range:
  %p2.addr = getelementptr i8, i8* %cur.addr, i64 8
  %p2.ptrptr = bitcast i8* %p2.addr to i8**
  %p2 = load i8*, i8** %p2.ptrptr, align 8
  %len.addr = getelementptr i8, i8* %p2, i64 8
  %len.ptr = bitcast i8* %len.addr to i32*
  %len32 = load i32, i32* %len.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.ptr = getelementptr i8, i8* %start.ptr, i64 %len64
  %end.int = ptrtoint i8* %end.ptr to i64
  %in.range = icmp ult i64 %addr.int, %end.int
  br i1 %in.range, label %found.return, label %cont.loop

cont.loop:
  %idx.next = add i32 %idx.ph, 1
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %cmp.end = icmp ne i32 %idx.next, %count32
  br i1 %cmp.end, label %scan.loop, label %loop.done

found.return:
  ret void

loop.done:
  br label %new.entry

no.count:
  br label %new.entry

new.entry:
  %idx.sel = phi i32 [ 0, %no.count ], [ %count32, %loop.done ]
  %rdi = call i8* @sub_140002250(i8* noundef %addr)
  %rdi.null = icmp eq i8* %rdi, null
  br i1 %rdi.null, label %no.img.sec, label %have.img

no.img.sec:
  %str.addr.none = bitcast i8* @aAddressPHasNoI to i8*
  %call.log.none = call i32 (i8*, ...) @sub_140001700(i8* noundef %str.addr.none, i8* noundef %addr)
  ret void

have.img:
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64b = zext i32 %idx.sel to i64
  %elem.off = mul i64 %idx64b, 40
  %elem.addr = getelementptr i8, i8* %base2, i64 %elem.off
  %field20.addr = getelementptr i8, i8* %elem.addr, i64 32
  %field20.ptr = bitcast i8* %field20.addr to i8**
  store i8* %rdi, i8** %field20.ptr, align 8
  %field0.ptr = bitcast i8* %elem.addr to i32*
  store i32 0, i32* %field0.ptr, align 4
  %img.base = call i8* @sub_140002390()
  %rdi.off0c = getelementptr i8, i8* %rdi, i64 12
  %rdi.off0c.i32p = bitcast i8* %rdi.off0c to i32*
  %off32 = load i32, i32* %rdi.off0c.i32p, align 4
  %off64 = zext i32 %off32 to i64
  %target.rcx = getelementptr i8, i8* %img.base, i64 %off64
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %field18.addr = getelementptr i8, i8* %base3, i64 %elem.off
  %field18.addr2 = getelementptr i8, i8* %field18.addr, i64 24
  %field18.ptr = bitcast i8* %field18.addr2 to i8**
  store i8* %target.rcx, i8** %field18.ptr, align 8
  %buf.ptr = bitcast i64* %buf_var48 to i8*
  %ret.vq = call i32 @loc_140012A4E(i8* noundef %target.rcx, i8* noundef %buf.ptr, i32 noundef 48)
  %eq2 = icmp eq i32 %ret.vq, 2
  br i1 %eq2, label %do.protect, label %vq.fail

do.protect:
  %v48.load.i64 = load i64, i64* %buf_var48, align 8
  %v48.ptr = inttoptr i64 %v48.load.i64 to i8*
  %v30.load.i64 = load i64, i64* %buf_var30, align 8
  %v30.ptr = inttoptr i64 %v30.load.i64 to i8*
  %flag.sel = select i1 %eq2, i32 4, i32 64
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %elem.addr2 = getelementptr i8, i8* %base4, i64 %elem.off
  %field8.addr = getelementptr i8, i8* %elem.addr2, i64 8
  %field8.ptr = bitcast i8* %field8.addr to i8**
  store i8* %v48.ptr, i8** %field8.ptr, align 8
  %field10.addr = getelementptr i8, i8* %elem.addr2, i64 16
  %field10.ptr = bitcast i8* %field10.addr to i8**
  store i8* %v30.ptr, i8** %field10.ptr, align 8
  %r9.ptr = bitcast i8* %elem.addr2 to i8*
  %call.prot = call i32 @loc_1400D1740(i8* noundef %v48.ptr, i8* noundef %v30.ptr, i32 noundef %flag.sel, i8* noundef %r9.ptr)
  ret void

vq.fail:
  %base5 = load i8*, i8** @qword_1400070A8, align 8
  %elem.addr3 = getelementptr i8, i8* %base5, i64 %elem.off
  %field18.addr3 = getelementptr i8, i8* %elem.addr3, i64 24
  %field18.ptr3 = bitcast i8* %field18.addr3 to i8**
  %r8.load = load i8*, i8** %field18.ptr3, align 8
  %rdi.off08 = getelementptr i8, i8* %rdi, i64 8
  %rdi.off08.i32p = bitcast i8* %rdi.off08 to i32*
  %edx32 = load i32, i32* %rdi.off08.i32p, align 4
  %str.vq = bitcast i8* @aVirtualqueryFa to i8*
  %call.log.vq = call i32 (i8*, ...) @sub_140001700(i8* noundef %str.vq, i32 noundef %edx32, i8* noundef %r8.load)
  ret void
}
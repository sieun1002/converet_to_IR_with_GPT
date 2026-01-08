; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.entry = type { i32, i32, i8*, i64, i8*, i8* }

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@qword_140008298 = external global i64 (i8*, i8*, i64)*
@qword_140008290 = external global i32 (i8*, i64, i32, i32*)*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

define void @sub_140001760(i8* %p) {
entry:
  %buf = alloca [48 x i8], align 8
  br label %start

start:
  %count.ptr = load i32, i32* @dword_1400070A4
  %gt0 = icmp sgt i32 %count.ptr, 0
  br i1 %gt0, label %scan_loop.init, label %new_entry

scan_loop.init:
  br label %scan_loop

scan_loop:
  %idx = phi i32 [ 0, %scan_loop.init ], [ %idx.next, %scan_loop.next ]
  %count.now = phi i32 [ %count.ptr, %scan_loop.init ], [ %count.now, %scan_loop.next ]
  %cond = icmp slt i32 %idx, %count.now
  br i1 %cond, label %scan_body, label %not_found

scan_body:
  %base.load0 = load i8*, i8** @qword_1400070A8
  %entries0 = bitcast i8* %base.load0 to %struct.entry*
  %idx64 = sext i32 %idx to i64
  %entry.ptr = getelementptr inbounds %struct.entry, %struct.entry* %entries0, i64 %idx64
  %field4.ptr = getelementptr inbounds %struct.entry, %struct.entry* %entry.ptr, i32 0, i32 4
  %base.addr = load i8*, i8** %field4.ptr
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %base.addr to i64
  %below = icmp ult i64 %p.int, %base.int
  br i1 %below, label %scan_loop.next, label %scan_body.cont

scan_body.cont:
  %field5.ptr = getelementptr inbounds %struct.entry, %struct.entry* %entry.ptr, i32 0, i32 5
  %info.ptr = load i8*, i8** %field5.ptr
  %info.sz.ptr.i8 = getelementptr inbounds i8, i8* %info.ptr, i64 8
  %info.sz.ptr = bitcast i8* %info.sz.ptr.i8 to i32*
  %size32 = load i32, i32* %info.sz.ptr
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %base.int, %size64
  %lt.end = icmp ult i64 %p.int, %end.int
  br i1 %lt.end, label %ret, label %scan_loop.next

scan_loop.next:
  %idx.next = add i32 %idx, 1
  br label %scan_loop

not_found:
  br label %new_entry

new_entry:
  %new.idx = phi i32 [ 0, %start ], [ %count.ptr, %not_found ]
  %infoobj = call i8* @sub_140002250(i8* %p)
  %isnull = icmp eq i8* %infoobj, null
  br i1 %isnull, label %print_no_image, label %have_info

have_info:
  %base.load1 = load i8*, i8** @qword_1400070A8
  %entries1 = bitcast i8* %base.load1 to %struct.entry*
  %new.idx64 = sext i32 %new.idx to i64
  %entry.new = getelementptr inbounds %struct.entry, %struct.entry* %entries1, i64 %new.idx64
  %field5.new = getelementptr inbounds %struct.entry, %struct.entry* %entry.new, i32 0, i32 5
  store i8* %infoobj, i8** %field5.new, align 8
  %field0.new = getelementptr inbounds %struct.entry, %struct.entry* %entry.new, i32 0, i32 0
  store i32 0, i32* %field0.new, align 4
  %modbase = call i8* @sub_140002390()
  %info.offC.i8 = getelementptr inbounds i8, i8* %infoobj, i64 12
  %info.offC.p32 = bitcast i8* %info.offC.i8 to i32*
  %offC = load i32, i32* %info.offC.p32
  %offC64 = zext i32 %offC to i64
  %query.addr = getelementptr inbounds i8, i8* %modbase, i64 %offC64
  %field4.new = getelementptr inbounds %struct.entry, %struct.entry* %entry.new, i32 0, i32 4
  store i8* %query.addr, i8** %field4.new, align 8
  %buf.i8ptr = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %fptr.vq.ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298
  %vqret = call i64 %fptr.vq.ptr(i8* %query.addr, i8* %buf.i8ptr, i64 48)
  %vqok = icmp ne i64 %vqret, 0
  br i1 %vqok, label %after_vq_ok, label %vq_fail

after_vq_ok:
  %prot.ptr.i8 = getelementptr inbounds i8, i8* %buf.i8ptr, i64 36
  %prot.ptr = bitcast i8* %prot.ptr.i8 to i32*
  %prot = load i32, i32* %prot.ptr
  %is4 = icmp eq i32 %prot, 4
  %is8 = icmp eq i32 %prot, 8
  %is40 = icmp eq i32 %prot, 64
  %is80 = icmp eq i32 %prot, 128
  %ok48 = or i1 %is4, %is8
  %ok4080 = or i1 %is40, %is80
  %ok.final = or i1 %ok48, %ok4080
  br i1 %ok.final, label %inc_and_ret, label %do_vprotect

do_vprotect:
  %baseaddr.ptr = bitcast i8* %buf.i8ptr to i8**
  %baseaddr = load i8*, i8** %baseaddr.ptr
  %regionsize.ptr.i8 = getelementptr inbounds i8, i8* %buf.i8ptr, i64 24
  %regionsize.ptr = bitcast i8* %regionsize.ptr.i8 to i64*
  %regionsize = load i64, i64* %regionsize.ptr
  %newprot.sel = icmp eq i32 %prot, 2
  %newprot = select i1 %newprot.sel, i32 4, i32 64
  %field2.new = getelementptr inbounds %struct.entry, %struct.entry* %entry.new, i32 0, i32 2
  store i8* %baseaddr, i8** %field2.new, align 8
  %field3.new = getelementptr inbounds %struct.entry, %struct.entry* %entry.new, i32 0, i32 3
  store i64 %regionsize, i64* %field3.new, align 8
  %fptr.vp.ptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @qword_140008290
  %vp.ret = call i32 %fptr.vp.ptr(i8* %baseaddr, i64 %regionsize, i32 %newprot, i32* %field0.new)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:
  %fptr.gle.ptr = load i32 ()*, i32 ()** @qword_140008260
  %gle = call i32 %fptr.gle.ptr()
  %vp.msg = getelementptr inbounds i8, i8* @aVirtualprotect, i64 0
  call void (i8*, ...) @sub_140001700(i8* %vp.msg, i32 %gle)
  br label %retry_zero

retry_zero:
  br label %start

vq_fail:
  %base.load2 = load i8*, i8** @qword_1400070A8
  %entries2 = bitcast i8* %base.load2 to %struct.entry*
  %entry.reuse = getelementptr inbounds %struct.entry, %struct.entry* %entries2, i64 %new.idx64
  %field4.reuse = getelementptr inbounds %struct.entry, %struct.entry* %entry.reuse, i32 0, i32 4
  %addr.for.msg = load i8*, i8** %field4.reuse
  %bytes.ptr.i8 = getelementptr inbounds i8, i8* %infoobj, i64 8
  %bytes.ptr = bitcast i8* %bytes.ptr.i8 to i32*
  %bytes = load i32, i32* %bytes.ptr
  %vq.msg = getelementptr inbounds i8, i8* @aVirtualqueryFa, i64 0
  call void (i8*, ...) @sub_140001700(i8* %vq.msg, i32 %bytes, i8* %addr.for.msg)
  br label %print_no_image

inc_and_ret:
  %oldcnt = load i32, i32* @dword_1400070A4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4
  br label %ret

print_no_image:
  %noimg.msg = getelementptr inbounds i8, i8* @aAddressPHasNoI, i64 0
  call void (i8*, ...) @sub_140001700(i8* %noimg.msg, i8* %p)
  br label %ret

ret:
  ret void
}
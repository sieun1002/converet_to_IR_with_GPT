; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@qword_140008298 = external global i64 (i8*, i8*, i64)*
@qword_140008290 = external global i32 (i8*, i64, i32, i32*)*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = external global [0 x i8]
@aVirtualqueryFa = external global [0 x i8]
@aAddressPHasNoI = external global [0 x i8]

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %0) {
entry:
  %addr = ptrtoint i8* %0 to i64
  %cnt.load = load i32, i32* @dword_1400070A4
  %cnt.pos = icmp sgt i32 %cnt.load, 0
  br i1 %cnt.pos, label %scan.init, label %cnt.zero

cnt.zero:
  br label %callSub

scan.init:
  %base.load = load i8*, i8** @qword_1400070A8
  %base.plus18 = getelementptr i8, i8* %base.load, i64 24
  br label %loop

loop:
  %idx.phi = phi i32 [ 0, %scan.init ], [ %idx.next, %advance ]
  %cur.ptr.phi = phi i8* [ %base.plus18, %scan.init ], [ %cur.next, %advance ]
  %cur.ptr.as.ptrptr = bitcast i8* %cur.ptr.phi to i8**
  %start.load = load i8*, i8** %cur.ptr.as.ptrptr
  %start.int = ptrtoint i8* %start.load to i64
  %below = icmp ult i64 %addr, %start.int
  br i1 %below, label %advance, label %check.range

check.range:
  %plus8 = getelementptr i8, i8* %cur.ptr.phi, i64 8
  %plus8.as.ptrptr = bitcast i8* %plus8 to i8**
  %obj.ptr = load i8*, i8** %plus8.as.ptrptr
  %len.ptr.i8 = getelementptr i8, i8* %obj.ptr, i64 8
  %len.ptr = bitcast i8* %len.ptr.i8 to i32*
  %len32 = load i32, i32* %len.ptr
  %len64 = zext i32 %len32 to i64
  %end.int = add i64 %start.int, %len64
  %inrange = icmp ult i64 %addr, %end.int
  br i1 %inrange, label %found.ret, label %advance

advance:
  %idx.next = add i32 %idx.phi, 1
  %cnt.cmp = icmp ne i32 %idx.next, %cnt.load
  %cur.next = getelementptr i8, i8* %cur.ptr.phi, i64 40
  br i1 %cnt.cmp, label %loop, label %callSub

found.ret:
  ret void

callSub:
  %rsi.sel = phi i32 [ 0, %cnt.zero ], [ %cnt.load, %advance ], [ 0, %vp.retry ]
  %rbx.sel = phi i8* [ %0, %cnt.zero ], [ %0, %advance ], [ %entry.ptr, %vp.retry ]
  %rdi.call = call i8* @sub_140002250(i8* %rbx.sel)
  %cmp.null = icmp eq i8* %rdi.call, null
  br i1 %cmp.null, label %no.image, label %have.rdi

have.rdi:
  %base2 = load i8*, i8** @qword_1400070A8
  %rsi.sext = sext i32 %rsi.sel to i64
  %mul5 = mul i64 %rsi.sext, 5
  %off.bytes = shl i64 %mul5, 3
  %entry.ptr = getelementptr i8, i8* %base2, i64 %off.bytes
  %field20 = getelementptr i8, i8* %entry.ptr, i64 32
  %field20.as.ptrptr = bitcast i8* %field20 to i8**
  store i8* %rdi.call, i8** %field20.as.ptrptr
  %field0 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %field0
  %p.ret = call i8* @sub_140002390()
  %rdi.plus0Ch.i8 = getelementptr i8, i8* %rdi.call, i64 12
  %rdi.plus0Ch = bitcast i8* %rdi.plus0Ch.i8 to i32*
  %edx.val = load i32, i32* %rdi.plus0Ch
  %edx.zext = zext i32 %edx.val to i64
  %rcx.ptr = getelementptr i8, i8* %p.ret, i64 %edx.zext
  %field18 = getelementptr i8, i8* %entry.ptr, i64 24
  %field18.as.ptrptr = bitcast i8* %field18 to i8**
  store i8* %rcx.ptr, i8** %field18.as.ptrptr
  %buf = alloca [48 x i8], align 8
  %buf.as.i8 = bitcast [48 x i8]* %buf to i8*
  %vq.fnptr.ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298
  %vq.call = call i64 %vq.fnptr.ptr(i8* %rcx.ptr, i8* %buf.as.i8, i64 48)
  %vq.ok = icmp ne i64 %vq.call, 0
  br i1 %vq.ok, label %after.vq, label %vq.fail

after.vq:
  %protect.ptr.i8 = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 36
  %protect.ptr = bitcast i8* %protect.ptr.i8 to i32*
  %protect = load i32, i32* %protect.ptr
  %t1.sub = sub i32 %protect, 4
  %t1.and = and i32 %t1.sub, -5
  %t1.iszero = icmp eq i32 %t1.and, 0
  br i1 %t1.iszero, label %inc.count, label %t2.check

t2.check:
  %t2.sub = sub i32 %protect, 64
  %t2.and = and i32 %t2.sub, -65
  %t2.nonzero = icmp ne i32 %t2.and, 0
  br i1 %t2.nonzero, label %do.vp, label %inc.count

inc.count:
  %cnt.cur = load i32, i32* @dword_1400070A4
  %cnt.new = add i32 %cnt.cur, 1
  store i32 %cnt.new, i32* @dword_1400070A4
  ret void

do.vp:
  %baseaddr.ptr.i8 = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %baseaddr.ptr = bitcast i8* %baseaddr.ptr.i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr.ptr
  %regionsize.ptr.i8 = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 24
  %regionsize.ptr = bitcast i8* %regionsize.ptr.i8 to i64*
  %regionsize = load i64, i64* %regionsize.ptr
  %cmp.eq2 = icmp eq i32 %protect, 2
  %newprot.sel = select i1 %cmp.eq2, i32 4, i32 64
  %vp.fnptr.ptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @qword_140008290
  %entry.as.i32 = bitcast i8* %entry.ptr to i32*
  %vp.call = call i32 %vp.fnptr.ptr(i8* %baseaddr, i64 %regionsize, i32 %newprot.sel, i32* %entry.as.i32)
  %vp.ok = icmp ne i32 %vp.call, 0
  br i1 %vp.ok, label %inc.count, label %vp.fail

vp.fail:
  %gle.fnptr.ptr = load i32 ()*, i32 ()** @qword_140008260
  %gle.val = call i32 %gle.fnptr.ptr()
  %fmt.vp.ptr = getelementptr [0 x i8], [0 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt.vp.ptr, i32 %gle.val)
  br label %vp.retry

vp.retry:
  br label %callSub

vq.fail:
  %base3 = load i8*, i8** @qword_1400070A8
  %rdi.plus8.i8 = getelementptr i8, i8* %rdi.call, i64 8
  %rdi.plus8 = bitcast i8* %rdi.plus8.i8 to i32*
  %edx.vq = load i32, i32* %rdi.plus8
  %fmt.vq.ptr = getelementptr [0 x i8], [0 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %r8.load.ptrloc = getelementptr i8, i8* %base3, i64 %off.bytes
  %r8.field18 = getelementptr i8, i8* %r8.load.ptrloc, i64 24
  %r8.field18.as.ptrptr = bitcast i8* %r8.field18 to i8**
  %r8.arg = load i8*, i8** %r8.field18.as.ptrptr
  call void (i8*, ...) @sub_140001700(i8* %fmt.vq.ptr, i32 %edx.vq, i8* %r8.arg)
  br label %no.image

no.image:
  %rdx.arg = phi i8* [ %rbx.sel, %callSub ], [ null, %vq.fail ]
  %fmt.noimg.ptr = getelementptr [0 x i8], [0 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt.noimg.ptr, i8* %rdx.arg)
  ret void
}
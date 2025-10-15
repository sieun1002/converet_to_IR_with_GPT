; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002610(i8* %rcx)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8* %rcx, i8* %rdx, i64 %r8)
declare i32 @loc_14000EEBA(i8* %rcx, i64 %rdx, i32 %r8, i8* %r9)
declare i32 @sub_140001AD0(i8* %fmt, ...)

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@qword_140008260 = external global i8*

@aVirtualprotect = external global i8*
@aVirtualqueryFa = external global i8*
@aAddressPHasNoI = external global i8*

define void @sub_140001B30(i8* %rcx) {
entry:
  %p = alloca i8*, align 8
  store i8* %rcx, i8** %p, align 8
  %cnt.load = load i32, i32* @dword_1400070A4
  %have.entries = icmp sgt i32 %cnt.load, 0
  br i1 %have.entries, label %loop.setup, label %no_entries

loop.setup:
  %base.ptr.ptr = load i8*, i8** @qword_1400070A8
  %i.init = add i32 0, 0
  br label %loop

loop:
  %i = phi i32 [ %i.init, %loop.setup ], [ %i.next, %loop.next ]
  %p.val = load i8*, i8** %p
  %cnt.cur = load i32, i32* @dword_1400070A4
  %iv.cmp = icmp slt i32 %i, %cnt.cur
  br i1 %iv.cmp, label %loop.body, label %no_entries

loop.body:
  %iv64 = zext i32 %i to i64
  %off.entries = mul nuw nsw i64 %iv64, 40
  %entry.base = getelementptr i8, i8* %base.ptr.ptr, i64 %off.entries
  %entry.plus18 = getelementptr i8, i8* %entry.base, i64 24
  %entry.plus18.pp = bitcast i8* %entry.plus18 to i8**
  %r8.entry = load i8*, i8** %entry.plus18.pp
  %cmp.lo = icmp ult i8* %p.val, %r8.entry
  br i1 %cmp.lo, label %loop.next, label %range.check

range.check:
  %entry.plus20 = getelementptr i8, i8* %entry.base, i64 32
  %entry.plus20.pp = bitcast i8* %entry.plus20 to i8**
  %ptr.rdx = load i8*, i8** %entry.plus20.pp
  %ptr.rdx.plus8 = getelementptr i8, i8* %ptr.rdx, i64 8
  %size32.ptr = bitcast i8* %ptr.rdx.plus8 to i32*
  %size32 = load i32, i32* %size32.ptr
  %size64 = zext i32 %size32 to i64
  %r8.entry.int = ptrtoint i8* %r8.entry to i64
  %end.int = add i64 %r8.entry.int, %size64
  %p.int = ptrtoint i8* %p.val to i64
  %in.range = icmp ugt i64 %end.int, %p.int
  br i1 %in.range, label %early.ret, label %loop.next

loop.next:
  %i.next = add i32 %i, 1
  br label %loop

early.ret:
  ret void

no_entries:
  %p2 = load i8*, i8** %p
  %rdi = call i8* @sub_140002610(i8* %p2)
  %rdi.null = icmp eq i8* %rdi, null
  br i1 %rdi.null, label %no_image, label %have_rdi

no_image:
  %fmt.noimg.pp = load i8*, i8** @aAddressPHasNoI
  %p3 = load i8*, i8** %p
  %call.noimg = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.noimg.pp, i8* %p3)
  ret void

have_rdi:
  %base.ptr.ptr2 = load i8*, i8** @qword_1400070A8
  %cnt.for.idx = load i32, i32* @dword_1400070A4
  %cnt64 = sext i32 %cnt.for.idx to i64
  %mul5 = mul nsw i64 %cnt64, 5
  %entry.off = mul nsw i64 %mul5, 8
  %entry.ptr = getelementptr i8, i8* %base.ptr.ptr2, i64 %entry.off
  %entry.plus20.w = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.plus20.wpp = bitcast i8* %entry.plus20.w to i8**
  store i8* %rdi, i8** %entry.plus20.wpp, align 8
  %entry.dword0 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.dword0, align 4
  %vmem.base = call i8* @sub_140002750()
  %rdi.plusC = getelementptr i8, i8* %rdi, i64 12
  %rdi.plusC.ip = bitcast i8* %rdi.plusC to i32*
  %offC = load i32, i32* %rdi.plusC.ip
  %offC64 = zext i32 %offC to i64
  %rcx.addr = getelementptr i8, i8* %vmem.base, i64 %offC64
  %entry.plus18.w = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.plus18.wpp = bitcast i8* %entry.plus18.w to i8**
  store i8* %rcx.addr, i8** %entry.plus18.wpp, align 8
  %mbi.arr = alloca [48 x i8], align 8
  %mbi.ptr = getelementptr [48 x i8], [48 x i8]* %mbi.arr, i64 0, i64 0
  %len.vq = zext i32 48 to i64
  %vq.res = call i64 @sub_14001FAD3(i8* %rcx.addr, i8* %mbi.ptr, i64 %len.vq)
  %vq.zero = icmp eq i64 %vq.res, 0
  br i1 %vq.zero, label %virtquery_fail, label %after_vq

virtquery_fail:
  %rdi.plus8 = getelementptr i8, i8* %rdi, i64 8
  %rdi.plus8.ip = bitcast i8* %rdi.plus8 to i32*
  %bytes = load i32, i32* %rdi.plus8.ip
  %r8.addr.ptr = bitcast i8* %entry.plus18.w to i8**
  %r8.addr = load i8*, i8** %r8.addr.ptr
  %fmt.vq = load i8*, i8** @aVirtualqueryFa
  %call.vq = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %bytes, i8* %r8.addr)
  br label %no_image

after_vq:
  %var2c.i8p = getelementptr i8, i8* %mbi.ptr, i64 44
  %var2c.p = bitcast i8* %var2c.i8p to i32*
  %eax.val = load i32, i32* %var2c.p
  %sub4 = add i32 %eax.val, -4
  %mask4 = and i32 %sub4, -5
  %cond1 = icmp eq i32 %mask4, 0
  br i1 %cond1, label %success_inc, label %check2

check2:
  %sub64 = add i32 %eax.val, -64
  %mask64 = and i32 %sub64, -65
  %cond2 = icmp ne i32 %mask64, 0
  br i1 %cond2, label %do_virtualprotect, label %success_inc

success_inc:
  %cnt.old2 = load i32, i32* @dword_1400070A4
  %cnt.new2 = add i32 %cnt.old2, 1
  store i32 %cnt.new2, i32* @dword_1400070A4
  ret void

do_virtualprotect:
  %is.two = icmp eq i32 %eax.val, 2
  %fl.sel = select i1 %is.two, i32 4, i32 64
  %mbi.baseaddr.pp = bitcast i8* %mbi.ptr to i8**
  %baseaddr.val = load i8*, i8** %mbi.baseaddr.pp
  %entry.plus8.w = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.plus8.wpp = bitcast i8* %entry.plus8.w to i8**
  store i8* %baseaddr.val, i8** %entry.plus8.wpp, align 8
  %regionsize.i8p = getelementptr i8, i8* %mbi.ptr, i64 24
  %regionsize.p = bitcast i8* %regionsize.i8p to i64*
  %regionsize = load i64, i64* %regionsize.p
  %entry.plus10.w = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.plus10.wqp = bitcast i8* %entry.plus10.w to i64*
  store i64 %regionsize, i64* %entry.plus10.wqp, align 8
  %vp.res = call i32 @loc_14000EEBA(i8* %baseaddr.val, i64 %regionsize, i32 %fl.sel, i8* %entry.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %success_inc, label %vp_fail

vp_fail:
  %gle.fn.ptr.i8 = load i8*, i8** @qword_140008260
  %gle.fn = bitcast i8* %gle.fn.ptr.i8 to i32 ()*
  %gle = call i32 %gle.fn()
  %fmt.vp = load i8*, i8** @aVirtualprotect
  %call.vp = call i32 (i8*, ...) @sub_140001AD0(i8* %fmt.vp, i32 %gle)
  ret void
}
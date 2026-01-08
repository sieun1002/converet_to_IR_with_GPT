; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32, align 4
@qword_1400070A8 = external dso_local global i8*, align 8
@qword_140008260 = external dso_local global i32 ()*, align 8

@aVirtualprotect = external dso_local constant [0 x i8], align 1
@aVirtualqueryFa = external dso_local constant [0 x i8], align 1
@aAddressPHasNoI = external dso_local constant [0 x i8], align 1

declare dso_local i8* @sub_140002250(i8* %rcx)
declare dso_local i8* @sub_140002390()
declare dso_local i64 @loc_1403D6CC2(i8* %rcx, i8* %rdx, i32 %r8d)
declare dso_local i32 @sub_1400E9A25(i8* %rcx, i8* %rdx, i32 %r8d, i8* %r9, ...)
declare dso_local void @sub_140001700(i8* %fmt, ...)

define dso_local void @sub_140001760(i8* %rcx) {
entry:
  %addr = bitcast i8* %rcx to i8*
  %buf = alloca [48 x i8], align 8
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %count.le.zero = icmp sle i32 %count.load, 0
  br i1 %count.le.zero, label %set_esi_zero, label %loop.init

loop.init:
  br label %loop.header

loop.header:
  %i.phi = phi i32 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %base.load = load i8*, i8** @qword_1400070A8, align 8
  %base.plus18 = getelementptr inbounds i8, i8* %base.load, i64 24
  %i.zext = zext i32 %i.phi to i64
  %iter.off = mul i64 %i.zext, 40
  %entry.ptr = getelementptr inbounds i8, i8* %base.plus18, i64 %iter.off
  %entry.ptr.as.pp = bitcast i8* %entry.ptr to i8**
  %r8.base = load i8*, i8** %entry.ptr.as.pp, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %r8.int = ptrtoint i8* %r8.base to i64
  %cmp.addr.lt.base = icmp ult i64 %addr.int, %r8.int
  br i1 %cmp.addr.lt.base, label %loop.inc, label %loop.check.range

loop.check.range:
  %entry.ptr.plus8 = getelementptr inbounds i8, i8* %entry.ptr, i64 8
  %entry.ptr.plus8.pp = bitcast i8* %entry.ptr.plus8 to i8**
  %rdx.ptr = load i8*, i8** %entry.ptr.plus8.pp, align 8
  %rdx.plus8 = getelementptr inbounds i8, i8* %rdx.ptr, i64 8
  %rdx.plus8.i32p = bitcast i8* %rdx.plus8 to i32*
  %size32 = load i32, i32* %rdx.plus8.i32p, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %r8.int, %size64
  %cmp.addr.lt.end = icmp ult i64 %addr.int, %end.int
  br i1 %cmp.addr.lt.end, label %early.ret, label %loop.inc

loop.inc:
  %i.next = add i32 %i.phi, 1
  %i.cmp = icmp ne i32 %i.next, %count.load
  br i1 %i.cmp, label %loop.header, label %notfound

early.ret:
  ret void

set_esi_zero:
  br label %call_lookup

notfound:
  br label %call_lookup

call_lookup:
  %index.sel = phi i32 [ 0, %set_esi_zero ], [ %count.load, %notfound ], [ 0, %restart_zero ]
  %lookup.call = call i8* @sub_140002250(i8* %addr)
  %rdi.val = bitcast i8* %lookup.call to i8*
  %rdi.isnull = icmp eq i8* %rdi.val, null
  br i1 %rdi.isnull, label %print_no_image, label %have_section

have_section:
  %base2.load = load i8*, i8** @qword_1400070A8, align 8
  %idx.sext64 = sext i32 %index.sel to i64
  %idx.bytes = mul i64 %idx.sext64, 40
  %entry.base = getelementptr inbounds i8, i8* %base2.load, i64 %idx.bytes
  %entry.plus20 = getelementptr inbounds i8, i8* %entry.base, i64 32
  %entry.plus20.pp = bitcast i8* %entry.plus20 to i8**
  store i8* %rdi.val, i8** %entry.plus20.pp, align 8
  %entry.dword0 = bitcast i8* %entry.base to i32*
  store i32 0, i32* %entry.dword0, align 4
  %call_2390 = call i8* @sub_140002390()
  %rdi.plus0C = getelementptr inbounds i8, i8* %rdi.val, i64 12
  %rdi.plus0C.i32p = bitcast i8* %rdi.plus0C to i32*
  %edx.val = load i32, i32* %rdi.plus0C.i32p, align 4
  %edx.zext64 = zext i32 %edx.val to i64
  %rcx.q = getelementptr inbounds i8, i8* %call_2390, i64 %edx.zext64
  %base3.load = load i8*, i8** @qword_1400070A8, align 8
  %entry.base2 = getelementptr inbounds i8, i8* %base3.load, i64 %idx.bytes
  %entry.plus18 = getelementptr inbounds i8, i8* %entry.base2, i64 24
  %entry.plus18.pp = bitcast i8* %entry.plus18 to i8**
  store i8* %rcx.q, i8** %entry.plus18.pp, align 8
  %buf.i8p = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %vq.call = call i64 @loc_1403D6CC2(i8* %rcx.q, i8* %buf.i8p, i32 48)
  %vq.iszero = icmp eq i64 %vq.call, 0
  br i1 %vq.iszero, label %virtquery_fail, label %after_vq_ok

after_vq_ok:
  %prot.off = getelementptr inbounds i8, i8* %buf.i8p, i64 36
  %prot.i32p = bitcast i8* %prot.off to i32*
  %prot.val = load i32, i32* %prot.i32p, align 4
  %tmp1 = sub i32 %prot.val, 4
  %mask1 = and i32 %tmp1, -5
  %is.zero1 = icmp eq i32 %mask1, 0
  br i1 %is.zero1, label %inc_and_ret, label %check_second

check_second:
  %tmp2 = sub i32 %prot.val, 64
  %mask2 = and i32 %tmp2, -65
  %cond.jnz = icmp ne i32 %mask2, 0
  br i1 %cond.jnz, label %handle_protect, label %inc_and_ret

inc_and_ret:
  %old.count = load i32, i32* @dword_1400070A4, align 4
  %new.count = add i32 %old.count, 1
  store i32 %new.count, i32* @dword_1400070A4, align 4
  ret void

handle_protect:
  %cmp.eax.eq2 = icmp eq i32 %prot.val, 2
  %r8.init = add i32 64, 0
  %r8.alt = add i32 4, 0
  %r8.sel = select i1 %cmp.eax.eq2, i32 %r8.alt, i32 %r8.init
  %baseaddr.ptr = bitcast i8* %buf.i8p to i8**
  %rcx.frombuf = load i8*, i8** %baseaddr.ptr, align 8
  %field18.off = getelementptr inbounds i8, i8* %buf.i8p, i64 24
  %field18.pp = bitcast i8* %field18.off to i8**
  %rdx.frombuf = load i8*, i8** %field18.pp, align 8
  %base4.load = load i8*, i8** @qword_1400070A8, align 8
  %entry.base3 = getelementptr inbounds i8, i8* %base4.load, i64 %idx.bytes
  %entry.plus8 = getelementptr inbounds i8, i8* %entry.base3, i64 8
  %entry.plus8.pp = bitcast i8* %entry.plus8 to i8**
  store i8* %rcx.frombuf, i8** %entry.plus8.pp, align 8
  %entry.plus10 = getelementptr inbounds i8, i8* %entry.base3, i64 16
  %entry.plus10.pp = bitcast i8* %entry.plus10 to i8**
  store i8* %rdx.frombuf, i8** %entry.plus10.pp, align 8
  %call_protect = call i32 (i8*, i8*, i32, i8*, ...) @sub_1400E9A25(i8* %rcx.frombuf, i8* %rdx.frombuf, i32 %r8.sel, i8* %entry.base3, i8* %rdx.frombuf)
  %call_protect.nonzero = icmp ne i32 %call_protect, 0
  br i1 %call_protect.nonzero, label %inc_and_ret, label %protect_error

protect_error:
  %fp.get = load i32 ()*, i32 ()** @qword_140008260, align 8
  %err.code = call i32 %fp.get()
  %fmt1.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt1.ptr, i32 %err.code)
  br label %restart_zero

restart_zero:
  br label %call_lookup

virtquery_fail:
  %base5.load = load i8*, i8** @qword_1400070A8, align 8
  %entry.base4 = getelementptr inbounds i8, i8* %base5.load, i64 %idx.bytes
  %entry.plus18.2 = getelementptr inbounds i8, i8* %entry.base4, i64 24
  %entry.plus18.2.pp = bitcast i8* %entry.plus18.2 to i8**
  %r8.val = load i8*, i8** %entry.plus18.2.pp, align 8
  %rdi.plus8 = getelementptr inbounds i8, i8* %rdi.val, i64 8
  %rdi.plus8.i32p = bitcast i8* %rdi.plus8 to i32*
  %edx.vq = load i32, i32* %rdi.plus8.i32p, align 4
  %fmt2.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt2.ptr, i32 %edx.vq, i8* %r8.val)
  br label %print_no_image

print_no_image:
  %fmt3.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt3.ptr, i8* %addr)
  ret void
}
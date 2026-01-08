; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@aVirtualprotect = external dso_local global i8
@aVirtualqueryFa = external dso_local global i8
@aAddressPHasNoI = external dso_local global i8

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local i32 @loc_140012A4E(i8*, i8*, i32)
declare dso_local i32 @loc_1400D1740(i8*, i8*, i32, i8*)
declare dso_local i32 @sub_140001700(i8*, ...)

define dso_local void @sub_140001760(i8* %addr) {
entry:
  %buf = alloca [56 x i8], align 8
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %has_elems = icmp sgt i32 %count32, 0
  br i1 %has_elems, label %loop.prep, label %notfound.prepare

loop.prep:
  %basearr.loop = load i8*, i8** @qword_1400070A8, align 8
  %start.ptr = getelementptr i8, i8* %basearr.loop, i64 24
  br label %loop.head

loop.head:
  %i = phi i32 [ 0, %loop.prep ], [ %i.next, %loop.inc ]
  %ptr.cur = phi i8* [ %start.ptr, %loop.prep ], [ %ptr.next, %loop.inc ]
  %entry_base.ptrptr = bitcast i8* %ptr.cur to i8**
  %entry_base = load i8*, i8** %entry_base.ptrptr, align 8
  %addr_int0 = ptrtoint i8* %addr to i64
  %entry_base_int0 = ptrtoint i8* %entry_base to i64
  %addr_lt_base = icmp ult i64 %addr_int0, %entry_base_int0
  br i1 %addr_lt_base, label %loop.inc, label %check.in.range

check.in.range:
  %p.ptrloc = getelementptr i8, i8* %ptr.cur, i64 8
  %p.ptrptr = bitcast i8* %p.ptrloc to i8**
  %p = load i8*, i8** %p.ptrptr, align 8
  %p.plus8 = getelementptr i8, i8* %p, i64 8
  %size32ptr = bitcast i8* %p.plus8 to i32*
  %size32 = load i32, i32* %size32ptr, align 4
  %size64 = zext i32 %size32 to i64
  %entry_base.i64 = ptrtoint i8* %entry_base to i64
  %end.i64 = add i64 %entry_base.i64, %size64
  %addr.i64 = ptrtoint i8* %addr to i64
  %addr_lt_end = icmp ult i64 %addr.i64, %end.i64
  br i1 %addr_lt_end, label %ret, label %loop.inc

loop.inc:
  %i.next = add i32 %i, 1
  %ptr.next = getelementptr i8, i8* %ptr.cur, i64 40
  %cont = icmp ne i32 %i.next, %count32
  br i1 %cont, label %loop.head, label %notfound.prepare

notfound.prepare:
  %sel.count = select i1 %has_elems, i32 %count32, i32 0
  %rdi.cand = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %rdi.cand, null
  br i1 %isnull, label %no.image, label %alloc.slot

alloc.slot:
  %basearr = load i8*, i8** @qword_1400070A8, align 8
  %sel.count.sext = sext i32 %sel.count to i64
  %mul5 = mul nsw i64 %sel.count.sext, 5
  %off.bytes = shl i64 %mul5, 3
  %slot = getelementptr i8, i8* %basearr, i64 %off.bytes
  %slot_plus20 = getelementptr i8, i8* %slot, i64 32
  %slot_plus20.pp = bitcast i8* %slot_plus20 to i8**
  store i8* %rdi.cand, i8** %slot_plus20.pp, align 8
  %slot_i32ptr = bitcast i8* %slot to i32*
  store i32 0, i32* %slot_i32ptr, align 4
  %base2 = call i8* @sub_140002390()
  %rdi.plus0C = getelementptr i8, i8* %rdi.cand, i64 12
  %sizeA.ptr = bitcast i8* %rdi.plus0C to i32*
  %sizeA = load i32, i32* %sizeA.ptr, align 4
  %sizeA.z = zext i32 %sizeA to i64
  %region = getelementptr i8, i8* %base2, i64 %sizeA.z
  %basearr2 = load i8*, i8** @qword_1400070A8, align 8
  %slot2 = getelementptr i8, i8* %basearr2, i64 %off.bytes
  %slot_plus18 = getelementptr i8, i8* %slot2, i64 24
  %slot_plus18.pp = bitcast i8* %slot_plus18 to i8**
  store i8* %region, i8** %slot_plus18.pp, align 8
  %buf.ptr = getelementptr [56 x i8], [56 x i8]* %buf, i32 0, i32 0
  %call.vq = call i32 @loc_140012A4E(i8* %region, i8* %buf.ptr, i32 48)
  %vq.ok = icmp ne i32 %call.vq, 0
  br i1 %vq.ok, label %protect.prep, label %vq.failed

vq.failed:
  %basearr3 = load i8*, i8** @qword_1400070A8, align 8
  %slot3 = getelementptr i8, i8* %basearr3, i64 %off.bytes
  %slot3_plus18 = getelementptr i8, i8* %slot3, i64 24
  %slot3_plus18.pp = bitcast i8* %slot3_plus18 to i8**
  %region.load = load i8*, i8** %slot3_plus18.pp, align 8
  %rdi.plus08 = getelementptr i8, i8* %rdi.cand, i64 8
  %bytes.ptr = bitcast i8* %rdi.plus08 to i32*
  %bytes = load i32, i32* %bytes.ptr, align 4
  %fmt.vq.ptr = getelementptr i8, i8* @aVirtualqueryFa, i64 0
  %call.printf.vq = call i32 (i8*, ...) @sub_140001700(i8* %fmt.vq.ptr, i32 %bytes, i8* %region.load)
  br label %ret

protect.prep:
  %is.two = icmp eq i32 %call.vq, 2
  %prot.sel4 = select i1 %is.two, i32 4, i32 64
  %basearr4 = load i8*, i8** @qword_1400070A8, align 8
  %rbx.slot = getelementptr i8, i8* %basearr4, i64 %off.bytes
  %out.rcx.ptr = bitcast i8* %buf.ptr to i8**
  %out.rcx = load i8*, i8** %out.rcx.ptr, align 8
  %slot_plus08 = getelementptr i8, i8* %rbx.slot, i64 8
  %slot_plus08.pp = bitcast i8* %slot_plus08 to i8**
  store i8* %out.rcx, i8** %slot_plus08.pp, align 8
  %buf.plus18 = getelementptr i8, i8* %buf.ptr, i64 24
  %out.rdx.ptr = bitcast i8* %buf.plus18 to i8**
  %out.rdx = load i8*, i8** %out.rdx.ptr, align 8
  %slot_plus10 = getelementptr i8, i8* %rbx.slot, i64 16
  %slot_plus10.pp = bitcast i8* %slot_plus10 to i8**
  store i8* %out.rdx, i8** %slot_plus10.pp, align 8
  %call.vp = call i32 @loc_1400D1740(i8* %out.rcx, i8* %out.rdx, i32 %prot.sel4, i8* %rbx.slot)
  %vp.ok = icmp ne i32 %call.vp, 0
  br i1 %vp.ok, label %ret, label %vp.failed

vp.failed:
  %fmt.vp.ptr = getelementptr i8, i8* @aVirtualprotect, i64 0
  %call.printf.vp = call i32 (i8*, ...) @sub_140001700(i8* %fmt.vp.ptr, i32 %call.vp)
  br label %ret

no.image:
  %fmt.noimg.ptr = getelementptr i8, i8* @aAddressPHasNoI, i64 0
  %call.printf.noimg = call i32 (i8*, ...) @sub_140001700(i8* %fmt.noimg.ptr, i8* %addr)
  br label %ret

ret:
  ret void
}
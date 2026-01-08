; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64*, align 8

declare void @loc_140001420(i8*)
declare void @sub_140001450()

define void @sub_1400014A0() {
entry:
  %baseptr.ptr = load i64*, i64** @off_1400043B0, align 8
  %first.qword = load i64, i64* %baseptr.ptr, align 8
  %first.dword = trunc i64 %first.qword to i32
  %is.neg1 = icmp eq i32 %first.dword, -1
  br i1 %is.neg1, label %sentinel.entry, label %not.sentinel

not.sentinel:
  br label %b7.decide

sentinel.entry:
  %idx1.ptr = getelementptr inbounds i64, i64* %baseptr.ptr, i64 1
  %idx1.val = load i64, i64* %idx1.ptr, align 8
  %idx1.nz = icmp ne i64 %idx1.val, 0
  br i1 %idx1.nz, label %sentinel.loop, label %b7.from.sentinel

sentinel.loop:
  %rax.phi = phi i64 [ 1, %sentinel.entry ], [ %rax.next, %sentinel.loop ]
  %r8.next = add i64 %rax.phi, 1
  %eax.trunc = trunc i64 %rax.phi to i32
  %rax.next = add i64 %rax.phi, 1
  %ptr.next = getelementptr inbounds i64, i64* %baseptr.ptr, i64 %r8.next
  %val.next = load i64, i64* %ptr.next, align 8
  %nz.next = icmp ne i64 %val.next, 0
  br i1 %nz.next, label %sentinel.loop, label %b7.from.sentinel

b7.from.sentinel:
  %ecx.from.s = phi i32 [ 0, %sentinel.entry ], [ %eax.trunc, %sentinel.loop ]
  br label %b7.decide

b7.decide:
  %ecx.val = phi i32 [ %first.dword, %not.sentinel ], [ %ecx.from.s, %b7.from.sentinel ]
  %is.zero = icmp eq i32 %ecx.val, 0
  br i1 %is.zero, label %after.calls, label %callloop.prep

callloop.prep:
  %N64 = zext i32 %ecx.val to i64
  %rbx.init = getelementptr inbounds i64, i64* %baseptr.ptr, i64 %N64
  br label %callloop

callloop:
  %cur = phi i64* [ %rbx.init, %callloop.prep ], [ %prev, %callloop ]
  %qword.fn = load i64, i64* %cur, align 8
  %fn.ptr = inttoptr i64 %qword.fn to void ()*
  call void %fn.ptr()
  %prev = getelementptr inbounds i64, i64* %cur, i64 -1
  %cont = icmp ne i64* %prev, %baseptr.ptr
  br i1 %cont, label %callloop, label %after.calls

after.calls:
  %cb = bitcast void ()* @sub_140001450 to i8*
  tail call void @loc_140001420(i8* %cb)
  ret void
}
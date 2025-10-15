; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = external dso_local global i8*, align 8

@aVirtualprotect = internal constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = internal constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = internal constant [32 x i8] c"Address %p has no image-section\00", align 1

declare dso_local dllimport i64 @VirtualQuery(i8* readonly, i8*, i64)
declare dso_local dllimport i32 @VirtualProtect(i8*, i64, i32, i32*)
declare dso_local dllimport i32 @GetLastError()

declare dso_local i8* @sub_140002610(i8*)
declare dso_local i8* @sub_140002750()
declare dso_local void @sub_140001AD0(i8*, ...)

define dso_local void @sub_140001B30(i8* %addr) local_unnamed_addr {
entry:
  %count32 = load i32, i32* @dword_1400070A4, align 4
  %cmp_pos = icmp sgt i32 %count32, 0
  br i1 %cmp_pos, label %loop.prelude, label %after.loop.pre

loop.prelude:                                      ; preds = %entry
  %base0.ptr = load i8*, i8** @qword_1400070A8, align 8
  %count64 = sext i32 %count32 to i64
  br label %loop.header

loop.header:                                       ; preds = %loop.body, %loop.prelude
  %i = phi i64 [ 0, %loop.prelude ], [ %i.next, %loop.body ]
  %addr.int = ptrtoint i8* %addr to i64
  %cond = icmp slt i64 %i, %count64
  br i1 %cond, label %loop.body, label %after.loop

loop.body:                                         ; preds = %loop.header
  %mul.off = mul i64 %i, 40
  %entry.base = getelementptr i8, i8* %base0.ptr, i64 %mul.off
  %p.plus.24 = getelementptr i8, i8* %entry.base, i64 24
  %p.plus.24.pp = bitcast i8* %p.plus.24 to i8**
  %r8.base = load i8*, i8** %p.plus.24.pp, align 8
  %r8.int = ptrtoint i8* %r8.base to i64
  %addr.lt.start = icmp ult i64 %addr.int, %r8.int
  br i1 %addr.lt.start, label %iter.next, label %check.range

check.range:                                       ; preds = %loop.body
  %p.plus.32 = getelementptr i8, i8* %entry.base, i64 32
  %p.plus.32.pp = bitcast i8* %p.plus.32 to i8**
  %rdx.ptr = load i8*, i8** %p.plus.32.pp, align 8
  %rdx.plus.8 = getelementptr i8, i8* %rdx.ptr, i64 8
  %len32.ptr = bitcast i8* %rdx.plus.8 to i32*
  %len32 = load i32, i32* %len32.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.int = add i64 %r8.int, %len64
  %in.range = icmp ult i64 %addr.int, %end.int
  br i1 %in.range, label %early.ret, label %iter.next

iter.next:                                         ; preds = %check.range, %loop.body
  %i.next = add i64 %i, 1
  br label %loop.header

early.ret:                                         ; preds = %check.range
  ret void

after.loop:                                        ; preds = %loop.header
  br label %B88.init

after.loop.pre:                                    ; preds = %entry
  br label %B88.init

B88.init:                                          ; preds = %after.loop.pre, %after.loop, %C60.again
  %rsiVal = phi i64 [ 0, %after.loop.pre ], [ %count64, %after.loop ], [ 0, %C60.again ]
  %rdi.call = call i8* @sub_140002610(i8* %addr)
  %isnull = icmp eq i8* %rdi.call, null
  br i1 %isnull, label %C82, label %cont.after.find

cont.after.find:                                   ; preds = %B88.init
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %off.bytes = mul i64 %rsiVal, 40
  %entry.cur = getelementptr i8, i8* %base1, i64 %off.bytes
  %entry.cur.plus20 = getelementptr i8, i8* %entry.cur, i64 32
  %entry.cur.plus20.pp = bitcast i8* %entry.cur.plus20 to i8**
  store i8* %rdi.call, i8** %entry.cur.plus20.pp, align 8
  %entry.cur.i32 = bitcast i8* %entry.cur to i32*
  store i32 0, i32* %entry.cur.i32, align 4
  %ret.base = call i8* @sub_140002750()
  %rdi.plus12 = getelementptr i8, i8* %rdi.call, i64 12
  %rdi.plus12.i32 = bitcast i8* %rdi.plus12 to i32*
  %edx.val = load i32, i32* %rdi.plus12.i32, align 4
  %edx.z = zext i32 %edx.val to i64
  %rcx.addr = getelementptr i8, i8* %ret.base, i64 %edx.z
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.off2 = getelementptr i8, i8* %base2, i64 %off.bytes
  %entry.off2.plus18 = getelementptr i8, i8* %entry.off2, i64 24
  %entry.off2.plus18.pp = bitcast i8* %entry.off2.plus18 to i8**
  store i8* %rcx.addr, i8** %entry.off2.plus18.pp, align 8
  %buf = alloca [48 x i8], align 16
  %buf.i8 = bitcast [48 x i8]* %buf to i8*
  %vq.ret = call i64 @VirtualQuery(i8* %rcx.addr, i8* %buf.i8, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %C67, label %after.vq

after.vq:                                          ; preds = %cont.after.find
  %protect.i8 = getelementptr i8, i8* %buf.i8, i64 36
  %protect.p = bitcast i8* %protect.i8 to i32*
  %protect = load i32, i32* %protect.p, align 4
  %sub1 = add i32 %protect, -4
  %and1 = and i32 %sub1, 4294967291
  %isZero1 = icmp eq i32 %and1, 0
  br i1 %isZero1, label %BFE, label %cont2

cont2:                                             ; preds = %after.vq
  %sub2 = add i32 %protect, -64
  %and2 = and i32 %sub2, 4294967231
  %isZero2 = icmp eq i32 %and2, 0
  br i1 %isZero2, label %BFE, label %C10

BFE:                                               ; preds = %after.vq, %cont2, %C10.success
  %old.count = load i32, i32* @dword_1400070A4, align 4
  %inc.count = add i32 %old.count, 1
  store i32 %inc.count, i32* @dword_1400070A4, align 4
  ret void

C10:                                               ; preds = %cont2
  %cmp2 = icmp eq i32 %protect, 2
  %newProt = select i1 %cmp2, i32 4, i32 64
  %baseaddr.pp = bitcast i8* %buf.i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr.pp, align 8
  %regionsize.i8 = getelementptr i8, i8* %buf.i8, i64 24
  %regionsize.p = bitcast i8* %regionsize.i8 to i64*
  %regionsize = load i64, i64* %regionsize.p, align 8
  %entry.plus8 = getelementptr i8, i8* %entry.cur, i64 8
  %entry.plus8.pp = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr, i8** %entry.plus8.pp, align 8
  %entry.plus10h = getelementptr i8, i8* %entry.cur, i64 16
  %entry.plus10h.p = bitcast i8* %entry.plus10h to i64*
  store i64 %regionsize, i64* %entry.plus10h.p, align 8
  %oldProt.ptr = bitcast i8* %entry.cur to i32*
  %vp.ret = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newProt, i32* %oldProt.ptr)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %C10.success, label %VP.fail

C10.success:                                       ; preds = %C10
  br label %BFE

VP.fail:                                           ; preds = %C10
  %gle = call i32 @GetLastError()
  %fmtVP.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmtVP.ptr, i32 %gle)
  br label %C60.again

C60.again:                                         ; preds = %VP.fail
  br label %B88.init

C67:                                               ; preds = %cont.after.find
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %rdi.plus8 = getelementptr i8, i8* %rdi.call, i64 8
  %rdi.plus8.i32 = bitcast i8* %rdi.plus8 to i32*
  %edx.qfail = load i32, i32* %rdi.plus8.i32, align 4
  %entry.q.plus18 = getelementptr i8, i8* %base3, i64 %off.bytes
  %entry.q.plus18b = getelementptr i8, i8* %entry.q.plus18, i64 24
  %entry.q.plus18b.pp = bitcast i8* %entry.q.plus18b to i8**
  %r8.arg = load i8*, i8** %entry.q.plus18b.pp, align 8
  %fmtVQ.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmtVQ.ptr, i32 %edx.qfail, i8* %r8.arg)
  br label %C82

C82:                                               ; preds = %C67, %B88.init
  %fmtNoImg.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmtNoImg.ptr, i8* %addr)
  ret void
}
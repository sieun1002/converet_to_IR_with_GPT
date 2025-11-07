; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
b1080:
  %stack = alloca [48 x i8], align 16
  %base.p = getelementptr inbounds [48 x i8], [48 x i8]* %stack, i64 0, i64 0
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %canary.ptr.i8 = getelementptr inbounds i8, i8* %base.p, i64 40
  %canary.ptr = bitcast i8* %canary.ptr.i8 to i64*
  store i64 %guard.cur, i64* %canary.ptr, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %dst0 = bitcast i8* %base.p to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %dst0, align 16
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %dst1.i8 = getelementptr inbounds i8, i8* %base.p, i64 16
  %dst1 = bitcast i8* %dst1.i8 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %dst1, align 16
  %off20.i8 = getelementptr inbounds i8, i8* %base.p, i64 32
  %off20 = bitcast i8* %off20.i8 to i32*
  store i32 4, i32* %off20, align 4
  br label %b10D0

b10D0:
  %rdi.phi = phi i64 [ 10, %b1080 ], [ %rdi.new, %b1119 ]
  %i.init = add i64 0, 1
  %ptr.init = getelementptr inbounds i8, i8* %base.p, i64 0
  %last.init = add i64 0, 0
  br label %b10E0

b10E0:
  %i.phi = phi i64 [ %i.init, %b10D0 ], [ %i.next, %b1101 ]
  %ptr.phi = phi i8* [ %ptr.init, %b10D0 ], [ %ptr.next, %b1101 ]
  %last.phi = phi i64 [ %last.init, %b10D0 ], [ %last.from, %b1101 ]
  %pair.ptr = bitcast i8* %ptr.phi to i64*
  %pair = load i64, i64* %pair.ptr, align 1
  %low32 = trunc i64 %pair to i32
  %shr32 = lshr i64 %pair, 32
  %high32 = trunc i64 %shr32 to i32
  %cmp.le = icmp sle i32 %low32, %high32
  br i1 %cmp.le, label %b1101, label %b10F5

b10F5:
  %lz = zext i32 %low32 to i64
  %hz = zext i32 %high32 to i64
  %hi.part = shl i64 %lz, 32
  %swapped = or i64 %hi.part, %hz
  store i64 %swapped, i64* %pair.ptr, align 1
  br label %b1101

b1101:
  %last.from = phi i64 [ %last.phi, %b10E0 ], [ %i.phi, %b10F5 ]
  %i.next = add i64 %i.phi, 1
  %ptr.next = getelementptr inbounds i8, i8* %ptr.phi, i64 4
  %cont = icmp ne i64 %i.next, %rdi.phi
  br i1 %cont, label %b10E0, label %b110E

b110E:
  %is.zero = icmp eq i64 %last.from, 0
  br i1 %is.zero, label %b111E, label %b1113

b1113:
  %is.one = icmp eq i64 %last.from, 1
  br i1 %is.one, label %b111E, label %b1119

b1119:
  %rdi.new = add i64 %last.from, 0
  br label %b10D0

b111E:
  %end.ptr = getelementptr inbounds i8, i8* %base.p, i64 40
  %fmt1 = getelementptr inbounds i8, i8* @unk_2004, i64 0
  br label %b1130

b1130:
  %rbx.cur = phi i8* [ %base.p, %b111E ], [ %rbx.next, %b1130 ]
  %val.ptr = bitcast i8* %rbx.cur to i32*
  %val = load i32, i32* %val.ptr, align 4
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1, i32 %val)
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %more = icmp ne i8* %rbx.next, %end.ptr
  br i1 %more, label %b1130, label %b1148

b1148:
  %fmt2 = getelementptr inbounds i8, i8* @unk_2008, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %saved = load i64, i64* %canary.ptr, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.bad = icmp ne i64 %saved, %guard.now
  br i1 %canary.bad, label %b1178, label %b116D

b116D:
  ret i32 0

b1178:
  call void @___stack_chk_fail()
  unreachable
}
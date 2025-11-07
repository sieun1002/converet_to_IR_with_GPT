; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant [16 x i8], align 16
@xmmword_2020 = external constant [16 x i8], align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1
@__stack_chk_guard = external thread_local global i64

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
entry_1080:
  %arr = alloca [9 x i32], align 16
  %canary.slot = alloca i64, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr.end = getelementptr inbounds i32, i32* %arr.base, i64 9

  ; load stack canary and store to local slot
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8

  ; memcpy 16 bytes from xmmword_2010 into arr[0..3]
  %dst0.i8 = bitcast i32* %arr.base to i8*
  %src0.i8.p = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2010, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst0.i8, i8* align 16 %src0.i8.p, i64 16, i1 false)

  ; memcpy 16 bytes from xmmword_2020 into arr[4..7]
  %dst1.i8 = getelementptr inbounds i8, i8* %dst0.i8, i64 16
  %src1.i8.p = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst1.i8, i8* align 16 %src1.i8.p, i64 16, i1 false)

  ; arr[8] = 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4

  ; quick_sort(arr, 0, 9)
  call void @quick_sort(i32* %arr.base, i32 0, i32 9)

  br label %loc_10E0

loc_10E0: ; loop body at 0x10E0
  %rbx.cur = phi i32* [ %arr.base, %entry_1080 ], [ %rbx.next, %loc_10E0 ]
  %val.load = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %call.printf.loop = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val.load)
  %cmp.end = icmp ne i32* %rbx.next, %arr.end
  br i1 %cmp.end, label %loc_10E0, label %bb_10FA

bb_10FA: ; 0x10FA
  %call.printf.tail = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  %canary.stored = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.cmp = icmp ne i64 %canary.stored, %guard.now
  br i1 %guard.cmp, label %loc_1128, label %bb_111D

bb_111D: ; 0x111D
  ret i32 0

loc_1128: ; 0x1128
  call void @___stack_chk_fail()
  unreachable
}
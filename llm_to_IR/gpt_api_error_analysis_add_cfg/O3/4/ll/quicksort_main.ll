; ModuleID = 'recovered_main'
source_filename = "recovered_main.ll"
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external constant [16 x i8]
@xmmword_2020 = external constant [16 x i8]
@unk_2004 = external global i8
@unk_2008 = external global i8

declare void @quick_sort(i32* nocapture, i32, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
bb_1080:
  ; prologue and canary setup
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8

  ; initialize array from xmmword_2010 (first 16 bytes)
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %xmm2010.i8 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2010, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8, i8* align 16 %xmm2010.i8, i64 16, i1 false)

  ; initialize array from xmmword_2020 (next 16 bytes at offset 16)
  %arr.i8.plus16 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %xmm2020.i8 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8.plus16, i8* align 16 %xmm2020.i8, i64 16, i1 false)

  ; store the 9th element (index 8) = 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4

  ; ensure 10th element (index 9) is defined
  %arr.idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4

  ; rbx = &arr[0], r12 = &arr[10]
  %rbx.init = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %r12.end = getelementptr inbounds i32, i32* %rbx.init, i64 10

  ; call quick_sort(rbx, 0, 9)
  call void @quick_sort(i32* %rbx.init, i32 0, i32 9)

  br label %bb_10E0

bb_10E0:                                           ; loc_10E0
  %rbx.cur = phi i32* [ %rbx.init, %bb_1080 ], [ %rbx.next, %bb_10E0 ]
  %val.load = load i32, i32* %rbx.cur, align 4
  %call.printf.loop = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val.load)
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %cmp.rbx.r12 = icmp ne i32* %r12.end, %rbx.next
  br i1 %cmp.rbx.r12, label %bb_10E0, label %bb_10FA

bb_10FA:
  %call.printf.tail = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)

  ; epilogue canary check
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %canary.diff = icmp ne i64 %guard.saved, %guard.now
  br i1 %canary.diff, label %bb_1128, label %bb_111D

bb_111D:
  ret i32 0

bb_1128:                                           ; loc_1128
  call void @___stack_chk_fail()
  unreachable
}
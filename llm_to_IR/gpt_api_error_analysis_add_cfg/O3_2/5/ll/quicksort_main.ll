; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@unk_2004 = external dso_local global i8, align 1
@unk_2008 = external dso_local global i8, align 1
@xmmword_2010 = external dso_local constant [16 x i8], align 16
@xmmword_2020 = external dso_local constant [16 x i8], align 16
@__stack_chk_guard = external dso_local thread_local global i64

declare dso_local void @quick_sort(i32*, i64, i32)
declare dso_local i32 @___printf_chk(i32, i8*, ...)
declare dso_local void @___stack_chk_fail()
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define dso_local i32 @main() {
bb1080:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  ; initialize first 8 ints from two 16-byte constants
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %src0 = bitcast [16 x i8]* @xmmword_2010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %arr.i8, i8* align 16 %src0, i64 16, i1 false)
  %dst1 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %src1 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %dst1, i8* align 16 %src1, i64 16, i1 false)

  ; arr[8] = 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4

  ; quick_sort(arr, 0, 9)
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i64 0, i32 9)

  ; setup loop pointers
  %end = getelementptr inbounds i32, i32* %base, i64 10
  br label %bb10E0

bb10E0:                                             ; do-while body
  %pcur = phi i32* [ %base, %bb1080 ], [ %next, %bb10E0 ]
  %val = load i32, i32* %pcur, align 4
  %fmt0 = getelementptr inbounds i8, i8* @unk_2004, i64 0
  %call.print = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt0, i32 %val)
  %next = getelementptr inbounds i32, i32* %pcur, i64 1
  %cont = icmp ne i32* %next, %end
  br i1 %cont, label %bb10E0, label %bb_after

bb_after:
  %fmt1 = getelementptr inbounds i8, i8* @unk_2008, i64 0
  %call.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1)

  ; stack canary check
  %guard1 = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %cmpcan = icmp ne i64 %guard1, %guard.now
  br i1 %cmpcan, label %bb1128, label %bb_ret

bb_ret:
  ret i32 0

bb1128:
  call void @___stack_chk_fail()
  unreachable
}
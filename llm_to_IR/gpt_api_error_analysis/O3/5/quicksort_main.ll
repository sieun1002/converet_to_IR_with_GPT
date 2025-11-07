; ModuleID = 'qs_main'
source_filename = "qs_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external thread_local global i64

@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@xmmword_2010 = private unnamed_addr constant <4 x i32> <i32 9, i32 1, i32 8, i32 3>, align 16
@xmmword_2020 = private unnamed_addr constant <4 x i32> <i32 6, i32 2, i32 7, i32 5>, align 16

declare void @quick_sort(i32* noundef, i32 noundef, i32 noundef)
declare i32 @__printf_chk(i32 noundef, i8* nocapture noundef readonly, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %canary = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  %arr.vec0.ptr = bitcast [9 x i32]* %arr to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %arr.vec0.ptr, align 16

  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr.vec1.ptr = bitcast i32* %arr.idx4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %arr.vec1.ptr, align 16

  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* noundef %arr.base, i32 noundef 0, i32 noundef 9)

  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %bound.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 9
  br label %loop

loop:
  %it.ptr = phi i32* [ %arr.base, %entry ], [ %next.ptr, %loop.body ]
  %done = icmp eq i32* %it.ptr, %bound.ptr
  br i1 %done, label %after.loop, label %loop.body

loop.body:
  %val.load = load i32, i32* %it.ptr, align 4
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 noundef 2, i8* noundef %fmt.ptr, i32 noundef %val.load)
  %next.ptr = getelementptr inbounds i32, i32* %it.ptr, i64 1
  br label %loop

after.loop:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 noundef 2, i8* noundef %nl.ptr)
  %canary.load = load i64, i64* %canary, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %ssp.ok = icmp eq i64 %canary.load, %guard.cur
  br i1 %ssp.ok, label %ret.ok, label %ssp.fail

ssp.fail:
  call void @__stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}
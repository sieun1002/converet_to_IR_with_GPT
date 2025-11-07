; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external thread_local global i64
@unk_2004 = external constant [0 x i8]
@unk_2008 = external constant [0 x i8]
@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16

declare void @quick_sort(i8*, i32, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb1080:
  ; frame layout: { [10 x i32] array, i64 canary }
  %frame = alloca { [10 x i32], i64 }, align 16
  %arr = getelementptr inbounds { [10 x i32], i64 }, { [10 x i32], i64 }* %frame, i32 0, i32 0
  %canary.slot = getelementptr inbounds { [10 x i32], i64 }, { [10 x i32], i64 }* %frame, i32 0, i32 1
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  ; initialize 8 ints from two 16-byte constants
  %vec0dst = bitcast [10 x i32]* %arr to <4 x i32>*
  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %vec0, <4 x i32>* %vec0dst, align 16
  %idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %vec1dst = bitcast i32* %idx4 to <4 x i32>*
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vec1, <4 x i32>* %vec1dst, align 16

  ; store qword 4 at element 8, which sets arr[8]=4 and arr[9]=0
  %idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  %qptr = bitcast i32* %idx8 to i64*
  store i64 4, i64* %qptr, align 8

  ; quick_sort(base=rsp-array, left=0, right=9)
  %base.i8 = bitcast [10 x i32]* %arr to i8*
  call void @quick_sort(i8* %base.i8, i32 0, i32 9)

  ; loop setup
  %fmt_main = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  %endptr = bitcast i64* %canary.slot to i8*
  br label %bb10e0

bb10e0:
  %rbx.cur = phi i8* [ %base.i8, %bb1080 ], [ %next, %bb10e0 ]
  %val.ptr = bitcast i8* %rbx.cur to i32*
  %val = load i32, i32* %val.ptr, align 4
  %next = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  ; ___printf_chk(2, fmt, val)
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_main, i32 %val)
  %cmp = icmp ne i8* %next, %endptr
  br i1 %cmp, label %bb10e0, label %bb10fa

bb10fa:
  ; ___printf_chk(2, fmt2)
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  ; stack protector epilogue
  %saved = load i64, i64* %canary.slot, align 8
  %cur = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %bb111d, label %bb1128

bb111d:
  ret i32 0

bb1128:
  call void @___stack_chk_fail()
  unreachable
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external constant i8, align 1
@unk_2008 = external constant i8, align 1

declare void @quick_sort(i32*, i32, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
entry_1080:
  %arr = alloca [9 x i32], align 16
  %canary = alloca i64, align 8
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0

  %guard0 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %guard0, i64* %canary, align 8

  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %vecptr0 = bitcast i32* %arr.ptr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 16

  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr.plus4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  %vecptr1 = bitcast i32* %arr.plus4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 16

  %elem8 = getelementptr inbounds i32, i32* %arr.ptr, i64 8
  store i32 4, i32* %elem8, align 4

  call void @quick_sort(i32* %arr.ptr, i32 0, i32 9)

  %endptr = getelementptr inbounds i32, i32* %arr.ptr, i64 9
  br label %bb_10e0

bb_10e0:
  %curptr = phi i32* [ %arr.ptr, %entry_1080 ], [ %nextptr, %bb_10e0 ]
  %val = load i32, i32* %curptr, align 4
  %fmt1 = bitcast i8* @unk_2004 to i8*
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1, i32 %val)
  %nextptr = getelementptr inbounds i32, i32* %curptr, i64 1
  %cont = icmp ne i32* %nextptr, %endptr
  br i1 %cont, label %bb_10e0, label %bb_10fa

bb_10fa:
  %fmt2 = bitcast i8* @unk_2008 to i8*
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %guard1 = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %saved = load i64, i64* %canary, align 8
  %cmp = icmp ne i64 %saved, %guard1
  br i1 %cmp, label %bb_1128, label %bb_ret

bb_ret:
  ret i32 0

bb_1128:
  call void @___stack_chk_fail()
  unreachable
}
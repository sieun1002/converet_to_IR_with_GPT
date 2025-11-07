; ModuleID = 'recovered_from_asm'
target triple = "x86_64-unknown-linux-gnu"

@xmmword_2010 = internal constant <4 x i32> <i32 10, i32 9, i32 8, i32 7>, align 16
@xmmword_2020 = internal constant <4 x i32> <i32 6, i32 5, i32 4, i32 3>, align 16
@unk_2004 = internal constant [4 x i8] c"%d \00", align 1
@unk_2008 = internal constant [2 x i8] c"\0A\00", align 1

declare void @quick_sort(i32*, i32, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
block_1080:
  %arr = alloca [8 x i32], align 16
  %var28 = alloca i32, align 4
  %canary = alloca i64, align 8

  %arr.base.i32 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 0
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %vecptr0 = bitcast i32* %arr.base.i32 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 16
  %arr.base.i32.plus4 = getelementptr inbounds i32, i32* %arr.base.i32, i64 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %vecptr1 = bitcast i32* %arr.base.i32.plus4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 16

  store i32 4, i32* %var28, align 4

  %fs_canary.init = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %fs_canary.init, i64* %canary, align 8

  %base.i8 = bitcast i32* %arr.base.i32 to i8*
  %r12.limit = getelementptr inbounds i8, i8* %base.i8, i64 32

  call void @quick_sort(i32* %arr.base.i32, i32 0, i32 9)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i8* [ %base.i8, %block_1080 ], [ %rbx.next, %loc_10E0 ]
  %val.ptr.i32 = bitcast i8* %rbx.cur to i32*
  %val32 = load i32, i32* %val.ptr.i32, align 4
  %fmt1.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %call.printf.elem = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1.ptr, i32 %val32)
  %cmp.r12.rbx = icmp ne i8* %r12.limit, %rbx.next
  br i1 %cmp.r12.rbx, label %loc_10E0, label %bb10FA

bb10FA:
  %fmt2.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.printf.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  %saved.canary = load i64, i64* %canary, align 8
  %fs_canary.cur = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %canary.diff = icmp ne i64 %saved.canary, %fs_canary.cur
  br i1 %canary.diff, label %loc_1128, label %bb.ret

bb.ret:
  ret i32 0

loc_1128:
  call void @___stack_chk_fail()
  unreachable
}
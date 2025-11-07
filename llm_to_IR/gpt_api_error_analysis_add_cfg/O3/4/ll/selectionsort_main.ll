target triple = "x86_64-pc-linux-gnu"

@aD = private constant [4 x i8] c"%d \00"
@aSortedArray = private constant [15 x i8] c"Sorted array: \00"
@xmmword_2020 = external constant [16 x i8], align 16
@__stack_chk_guard = external global i64

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() {
L1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %end.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  %dst.i8 = bitcast [5 x i32]* %arr to i8*
  %src.i8 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst.i8, i8* %src.i8, i64 16, i1 false)
  %elem4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %elem4.ptr, align 4
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8
  call void @selection_sort(i32* %arr0.ptr, i32 5)
  %msg.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @aSortedArray, i64 0, i64 0
  %call.print.head = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %msg.ptr)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i32* [ %arr0.ptr, %L1080 ], [ %rbx.next, %loc_10E0 ]
  %val.load = load i32, i32* %rbx.cur, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.print.item = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val.load)
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %cmp.end = icmp ne i32* %rbx.next, %end.ptr
  br i1 %cmp.end, label %loc_10E0, label %L10FA

L10FA:
  %saved.guard = load i64, i64* %canary.slot, align 8
  %cur.guard = load i64, i64* @__stack_chk_guard, align 8
  %cmp.guard = icmp ne i64 %saved.guard, %cur.guard
  br i1 %cmp.guard, label %loc_1115, label %L110A

L110A:
  ret i32 0

loc_1115:
  call void @__stack_chk_fail()
  unreachable
}
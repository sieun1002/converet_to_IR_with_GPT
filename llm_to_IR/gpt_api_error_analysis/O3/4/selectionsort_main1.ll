; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.num = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@xmmword_2020 = external constant <4 x i32>, align 16

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.vec.ptr = bitcast [5 x i32]* %arr to <4 x i32>*
  %vecinit = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vecinit, <4 x i32>* %arr.vec.ptr, align 16
  %fifth = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %fifth, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arrdecay, i32 5)
  %sortedstr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call0 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %sortedstr)
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.num, i64 0, i64 0
  br label %loop.preheader

loop.preheader:
  br label %loop

loop:
  %i = phi i64 [ 0, %loop.preheader ], [ %i.next, %loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %val)
  %i.next = add i64 %i, 1
  %cmp = icmp eq i64 %i.next, 5
  br i1 %cmp, label %done, label %loop

done:
  ret i32 0
}
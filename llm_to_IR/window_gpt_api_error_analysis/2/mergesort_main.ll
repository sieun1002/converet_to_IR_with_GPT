; ModuleID = 'sorted_print'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  br label %outer

outer:                                            ; preds = %entry, %outer.end
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.end ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %ret

outer.body:                                       ; preds = %outer
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %j.init = add i64 %i, 0
  br label %inner

inner:                                            ; preds = %inner.move, %outer.body
  %j = phi i64 [ %j.init, %outer.body ], [ %j.dec, %inner.move ]
  %cond1 = icmp ugt i64 %j, 0
  br i1 %cond1, label %inner.check, label %inner.end

inner.check:                                      ; preds = %inner
  %jm1 = add i64 %j, -1
  %a.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a = load i32, i32* %a.ptr, align 4
  %cmp2 = icmp sgt i32 %a, %key
  br i1 %cmp2, label %inner.move, label %inner.end

inner.move:                                       ; preds = %inner.check
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner

inner.end:                                        ; preds = %inner, %inner.check
  %dest.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %dest.ptr2, align 4
  %i.next = add i64 %i, 1
  br label %outer.end

outer.end:                                        ; preds = %inner.end
  br label %outer

ret:                                              ; preds = %outer
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %arr.elem0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0, align 4
  %arr.elem1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2, align 4
  %arr.elem3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4, align 4
  %arr.elem5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5, align 4
  %arr.elem6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6, align 4
  %arr.elem7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7, align 4
  %arr.elem8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8, align 4
  %arr.elem9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9, align 4
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* %arr.ptr, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}
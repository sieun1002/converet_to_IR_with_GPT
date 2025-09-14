; ModuleID = 'min_index.ll'
source_filename = "min_index"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %A, i32* nocapture readonly %B, i32 %n) local_unnamed_addr {
entry:
  %minidx = alloca i32, align 4
  %minval = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 -1, i32* %minidx, align 4
  store i32 2147483647, i32* %minval, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop
  %i.ext = sext i32 %i.val to i64
  %b.ptr = getelementptr inbounds i32, i32* %B, i64 %i.ext
  %bval = load i32, i32* %b.ptr, align 4
  %bzero = icmp eq i32 %bval, 0
  br i1 %bzero, label %checkA, label %inc

checkA:                                           ; preds = %loop.body
  %a.ptr = getelementptr inbounds i32, i32* %A, i64 %i.ext
  %aval = load i32, i32* %a.ptr, align 4
  %curmin = load i32, i32* %minval, align 4
  %less = icmp slt i32 %aval, %curmin
  br i1 %less, label %upd, label %inc

upd:                                              ; preds = %checkA
  store i32 %aval, i32* %minval, align 4
  store i32 %i.val, i32* %minidx, align 4
  br label %inc

inc:                                              ; preds = %upd, %checkA, %loop.body
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

exit:                                             ; preds = %loop
  %ret = load i32, i32* %minidx, align 4
  ret i32 %ret
}
; ModuleID = 'qs'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() nounwind {
entry:
  ret void
}

define dso_local void @quick_sort(i32* %arr, i32 %low, i32 %high) {
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %part, label %ret

part:
  %high.sext = sext i32 %high to i64
  %piv.ptr = getelementptr inbounds i32, i32* %arr, i64 %high.sext
  %pivot = load i32, i32* %piv.ptr, align 4
  %low.minus1 = add nsw i32 %low, -1
  br label %for.cond

for.cond:
  %j = phi i32 [ %low, %part ], [ %j.next, %for.inc ]
  %i = phi i32 [ %low.minus1, %part ], [ %i.next, %for.inc ]
  %cmpj = icmp slt i32 %j, %high
  br i1 %cmpj, label %for.body, label %for.end

for.body:
  %j.sext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.sext
  %a.j = load i32, i32* %j.ptr, align 4
  %le = icmp sle i32 %a.j, %pivot
  br i1 %le, label %if.then, label %for.inc

if.then:
  %i.inc = add nsw i32 %i, 1
  %i.sext = sext i32 %i.inc to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.sext
  %a.i = load i32, i32* %i.ptr, align 4
  store i32 %a.i, i32* %j.ptr, align 4
  store i32 %a.j, i32* %i.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = phi i32 [ %i, %for.body ], [ %i.inc, %if.then ]
  %j.next = add nsw i32 %j, 1
  br label %for.cond

for.end:
  %i.plus1 = add nsw i32 %i, 1
  %ip1.sext = sext i32 %i.plus1 to i64
  %ip1.ptr = getelementptr inbounds i32, i32* %arr, i64 %ip1.sext
  %a.ip1 = load i32, i32* %ip1.ptr, align 4
  %high.sext.2 = sext i32 %high to i64
  %h.ptr = getelementptr inbounds i32, i32* %arr, i64 %high.sext.2
  %a.h = load i32, i32* %h.ptr, align 4
  store i32 %a.ip1, i32* %h.ptr, align 4
  store i32 %a.h, i32* %ip1.ptr, align 4
  %pi = add nsw i32 %i, 1
  %pi.minus1 = add nsw i32 %pi, -1
  %pi.plus1 = add nsw i32 %pi, 1
  call void @quick_sort(i32* %arr, i32 %low, i32 %pi.minus1)
  call void @quick_sort(i32* %arr, i32 %pi.plus1, i32 %high)
  br label %ret

ret:
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %base, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %idx9, align 4
  %n = add nuw nsw i32 0, 10
  %cmpn = icmp ugt i32 %n, 1
  br i1 %cmpn, label %do.sort, label %after.sort

do.sort:
  %n.minus1 = add nsw i32 %n, -1
  call void @quick_sort(i32* %base, i32 0, i32 %n.minus1)
  br label %after.sort

after.sort:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %after.sort ], [ %i.next, %loop.inc ]
  %cmpi = icmp ult i32 %i, %n
  br i1 %cmpi, label %loop.body, label %loop.end

loop.body:
  %i.sext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i.sext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %loop.inc

loop.inc:
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}
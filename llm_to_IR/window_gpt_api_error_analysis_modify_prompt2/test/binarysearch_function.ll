; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %check

check:
  %l = phi i64 [ 0, %entry ], [ %mid_plus1, %set_l ], [ %l, %set_r ]
  %r = phi i64 [ %n, %entry ], [ %r, %set_l ], [ %mid, %set_r ]
  %cmp.lr = icmp ult i64 %l, %r
  br i1 %cmp.lr, label %body, label %after_loop

body:
  %diff = sub i64 %r, %l
  %half = lshr i64 %diff, 1
  %mid = add i64 %l, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp.keyle = icmp sle i32 %key, %elem
  br i1 %cmp.keyle, label %set_r, label %set_l

set_l:
  %mid_plus1 = add i64 %mid, 1
  br label %check

set_r:
  br label %check

after_loop:
  %inrange = icmp ult i64 %l, %n
  br i1 %inrange, label %in_range, label %not_found

in_range:
  %elem2.ptr = getelementptr inbounds i32, i32* %arr, i64 %l
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %found, label %not_found

found:
  ret i64 %l

not_found:
  ret i64 4294967295
}
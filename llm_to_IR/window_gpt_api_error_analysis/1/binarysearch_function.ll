; ModuleID = 'binary_search_module'
source_filename = "binary_search.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %low.ph = phi i64 [ 0, %entry ], [ %low.next, %setlow ], [ %low.ph, %sethigh ]
  %high.ph = phi i64 [ %n, %entry ], [ %high.ph, %setlow ], [ %mid, %sethigh ]
  %cmp.lh = icmp ult i64 %low.ph, %high.ph
  br i1 %cmp.lh, label %body, label %after_loop

body:
  %diff = sub i64 %high.ph, %low.ph
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.ph, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %target, %elt
  br i1 %le, label %sethigh, label %setlow

setlow:
  %low.next = add i64 %mid, 1
  br label %loop

sethigh:
  br label %loop

after_loop:
  %low.final = phi i64 [ %low.ph, %loop ]
  %in.range = icmp ult i64 %low.final, %n
  br i1 %in.range, label %check_equal, label %ret_not_found

check_equal:
  %elt.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.final
  %elt2 = load i32, i32* %elt.ptr2, align 4
  %eq = icmp eq i32 %elt2, %target
  br i1 %eq, label %ret_found, label %ret_not_found

ret_found:
  ret i64 %low.final

ret_not_found:
  ret i64 4294967295
}
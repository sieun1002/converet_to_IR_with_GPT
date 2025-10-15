; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140002880(i64 %n) {
entry:
  %anchor = alloca i8, align 1
  %cond = icmp ult i64 %n, 4096
  br i1 %cond, label %tail, label %loop

loop:
  %p = phi i8* [ %anchor, %entry ], [ %p_next, %loop ]
  %n_loop = phi i64 [ %n, %entry ], [ %n_next, %loop ]
  %p_next = getelementptr i8, i8* %p, i64 -4096
  store volatile i8 0, i8* %p_next, align 1
  %n_next = sub i64 %n_loop, 4096
  %cmp = icmp ugt i64 %n_next, 4096
  br i1 %cmp, label %loop, label %tail

tail:
  %p_tail = phi i8* [ %anchor, %entry ], [ %p_next, %loop ]
  %n_tail = phi i64 [ %n, %entry ], [ %n_next, %loop ]
  %neg = sub i64 0, %n_tail
  %p_final = getelementptr i8, i8* %p_tail, i64 %neg
  store volatile i8 0, i8* %p_final, align 1
  ret void
}
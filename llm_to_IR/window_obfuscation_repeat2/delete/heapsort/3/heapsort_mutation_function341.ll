; ModuleID = 'chkstk_like'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i8* %base, i64 %size) {
entry:
  %cmp0 = icmp ult i64 %size, 4096
  br i1 %cmp0, label %tail, label %loop

loop:
  %p0 = phi i8* [ %base, %entry ], [ %p1, %loop ]
  %s0 = phi i64 [ %size, %entry ], [ %s1, %loop ]
  %p1 = getelementptr i8, i8* %p0, i64 -4096
  %p1_i64 = bitcast i8* %p1 to i64*
  %v1 = load volatile i64, i64* %p1_i64, align 1
  store volatile i64 %v1, i64* %p1_i64, align 1
  %s1 = sub i64 %s0, 4096
  %cond = icmp ugt i64 %s1, 4096
  br i1 %cond, label %loop, label %tail

tail:
  %ptail = phi i8* [ %base, %entry ], [ %p1, %loop ]
  %stail = phi i64 [ %size, %entry ], [ %s1, %loop ]
  %neg = sub i64 0, %stail
  %pfin = getelementptr i8, i8* %ptail, i64 %neg
  %pfin_i64 = bitcast i8* %pfin to i64*
  %v2 = load volatile i64, i64* %pfin_i64, align 1
  store volatile i64 %v2, i64* %pfin_i64, align 1
  ret void
}
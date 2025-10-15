; ModuleID = 'chkstk_probe'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i8* %base, i64 %size) nounwind {
entry:
  %cmp.init = icmp ult i64 %size, 4096
  br i1 %cmp.init, label %final, label %loop

loop:
  %bcur = phi i8* [ %base, %entry ], [ %bnext, %loop ]
  %scur = phi i64 [ %size, %entry ], [ %snext, %loop ]
  %bnext = getelementptr i8, i8* %bcur, i64 -4096
  %ptr64 = bitcast i8* %bnext to i64*
  %ld = load volatile i64, i64* %ptr64, align 1
  store volatile i64 %ld, i64* %ptr64, align 1
  %snext = sub i64 %scur, 4096
  %cond2 = icmp ugt i64 %snext, 4096
  br i1 %cond2, label %loop, label %final.pre

final.pre:
  br label %final

final:
  %fbase = phi i8* [ %base, %entry ], [ %bnext, %final.pre ]
  %fsize = phi i64 [ %size, %entry ], [ %snext, %final.pre ]
  %neg = sub i64 0, %fsize
  %endptr = getelementptr i8, i8* %fbase, i64 %neg
  %ptr64.end = bitcast i8* %endptr to i64*
  %ld2 = load volatile i64, i64* %ptr64.end, align 1
  store volatile i64 %ld2, i64* %ptr64.end, align 1
  ret void
}
; ModuleID: 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8**

define void @sub_140001820() {
entry:
  %p0 = load i8**, i8*** @off_140003000, align 8
  %fn0 = load i8*, i8** %p0, align 8
  %cond0 = icmp ne i8* %fn0, null
  br i1 %cond0, label %loop, label %ret

loop:
  %fnphi = phi i8* [ %fn0, %entry ], [ %nextfn, %loop ]
  %fncast = bitcast i8* %fnphi to void ()*
  call void %fncast()
  %p1 = load i8**, i8*** @off_140003000, align 8
  %newp = getelementptr i8*, i8** %p1, i64 1
  %nextfn = load i8*, i8** %newp, align 8
  store i8** %newp, i8*** @off_140003000, align 8
  %cond1 = icmp ne i8* %nextfn, null
  br i1 %cond1, label %loop, label %ret

ret:
  ret void
}
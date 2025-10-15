; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*

define void @sub_140001820() {
entry:
  %slot0 = load i8*, i8** @off_140003000, align 8
  br label %check

check:
  %slot.cur = phi i8* [ %slot0, %entry ], [ %nextslot, %body ]
  %slot.cur.pp = bitcast i8* %slot.cur to i8**
  %fnptr = load i8*, i8** %slot.cur.pp, align 8
  %has = icmp ne i8* %fnptr, null
  br i1 %has, label %body, label %ret

body:
  %f = bitcast i8* %fnptr to void (...)* 
  call void (...) %f()
  %nextslot = getelementptr i8, i8* %slot.cur, i64 8
  store i8* %nextslot, i8** @off_140003000, align 8
  br label %check

ret:
  ret void
}
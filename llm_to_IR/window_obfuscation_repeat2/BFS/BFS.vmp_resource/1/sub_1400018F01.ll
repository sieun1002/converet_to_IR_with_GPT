; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*, align 8

define dso_local void @sub_1400018F0() {
entry:
  %p = load i8*, i8** @off_140003000, align 8
  %p_cast = bitcast i8* %p to void ()**
  %fn0 = load void ()*, void ()** %p_cast, align 8
  %cmp0 = icmp eq void ()* %fn0, null
  br i1 %cmp0, label %exit, label %call

call:
  %cur = phi void ()* [ %fn0, %entry ], [ %next_fn, %update ]
  call void %cur()
  br label %update

update:
  %p2 = load i8*, i8** @off_140003000, align 8
  %p2_cast = bitcast i8* %p2 to void ()**
  %next_ptr = getelementptr inbounds void ()*, void ()** %p2_cast, i64 1
  %next_fn = load void ()*, void ()** %next_ptr, align 8
  %next_ptr_i8 = bitcast void ()** %next_ptr to i8*
  store i8* %next_ptr_i8, i8** @off_140003000, align 8
  %cond = icmp ne void ()* %next_fn, null
  br i1 %cond, label %call, label %exit

exit:
  ret void
}
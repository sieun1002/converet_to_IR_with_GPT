; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140003000 = global i8* null, align 8

define void @sub_140001820() local_unnamed_addr nounwind {
entry:
  %base = load i8*, i8** @off_140003000, align 8
  %slot = bitcast i8* %base to void ()**
  %first = load void ()*, void ()** %slot, align 8
  %isnull = icmp eq void ()* %first, null
  br i1 %isnull, label %exit, label %loop

loop:
  %cur_slot = phi void ()** [ %slot, %entry ], [ %next_slot, %loop ]
  %cur_fp = phi void ()* [ %first, %entry ], [ %next_fp, %loop ]
  call void %cur_fp()
  %next_slot = getelementptr inbounds void ()*, void ()** %cur_slot, i64 1
  %next_fp = load void ()*, void ()** %next_slot, align 8
  %next_slot_i8 = bitcast void ()** %next_slot to i8*
  store i8* %next_slot_i8, i8** @off_140003000, align 8
  %cond = icmp ne void ()* %next_fp, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}
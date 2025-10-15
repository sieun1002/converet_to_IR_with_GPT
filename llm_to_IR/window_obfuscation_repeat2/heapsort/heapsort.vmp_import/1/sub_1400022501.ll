; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

declare i8* @sub_140002B38(i32, i32)
declare void @sub_140308AC7(i8*) noreturn

define dso_local i32 @sub_140002250(i32 %arg0, i8* %arg1) local_unnamed_addr {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %g, 0
  br i1 %cmp0, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  %call = call i8* @sub_140002B38(i32 1, i32 24)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret0b, label %have

ret0b:
  ret i32 0

have:
  %mem_i32 = bitcast i8* %call to i32*
  store i32 %arg0, i32* %mem_i32, align 4
  %addr8 = getelementptr i8, i8* %call, i64 8
  %pp = bitcast i8* %addr8 to i8**
  store i8* %arg1, i8** %pp, align 8
  call void @sub_140308AC7(i8* @unk_140007100)
  unreachable
}
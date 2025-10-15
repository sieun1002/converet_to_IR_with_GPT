; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = internal global i32 0, align 4
@dword_1400070A4 = internal global i32 0, align 4
@qword_1400070A8 = internal global i8* null, align 8
@off_1400043B0 = internal global i8* null, align 8
@off_1400043C0 = internal global i8* null, align 8
@off_1400043A0 = internal global i8* null, align 8

define i32 @sub_140001CA0() local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c1 = call i64 @sub_140002690()
  %c2 = call i64 @sub_1400028E0()
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* null, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret i32 0
}

define i64 @sub_140002690() local_unnamed_addr {
entry:
  ret i64 0
}

define i64 @sub_1400028E0() local_unnamed_addr {
entry:
  ret i64 0
}

define void @sub_140001B30(i8* nocapture readnone %p) local_unnamed_addr {
entry:
  ret void
}

define void @sub_140002B78(i8* nocapture readnone %a, i8* nocapture readnone %b, i32 %n) local_unnamed_addr {
entry:
  ret void
}

define void @sub_140001AD0(i8* nocapture readnone %s) local_unnamed_addr {
entry:
  ret void
}
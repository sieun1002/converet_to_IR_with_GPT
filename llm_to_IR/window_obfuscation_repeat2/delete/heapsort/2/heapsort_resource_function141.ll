; ModuleID = 'reconstructed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*, align 8
@unk_140004BE0 = external global i8*, align 8

declare void @sub_1400023D0()

define dso_local void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %0 = load i32*, i32** @off_140004370, align 8
  %1 = load i32, i32* %0, align 4
  %2 = icmp eq i32 %1, 2
  br i1 %2, label %check_reason, label %set_two

set_two:
  store i32 2, i32* %0, align 4
  br label %check_reason

check_reason:
  %3 = icmp eq i32 %Reason, 2
  br i1 %3, label %reason_is_2, label %check_reason_is_1

check_reason_is_1:
  %4 = icmp eq i32 %Reason, 1
  br i1 %4, label %reason_is_1, label %ret

reason_is_1:
  tail call void @sub_1400023D0()
  br label %ret

reason_is_2:
  %startptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %endptr = getelementptr i8*, i8** @unk_140004BE0, i64 0
  %5 = icmp eq i8** %startptr, %endptr
  br i1 %5, label %ret, label %loop

loop:
  %rbx.cur = phi i8** [ %startptr, %reason_is_2 ], [ %rbx.next, %advance ]
  %6 = load i8*, i8** %rbx.cur, align 8
  %7 = icmp eq i8* %6, null
  br i1 %7, label %advance, label %do_call

do_call:
  %8 = bitcast i8* %6 to void ()*
  call void %8()
  br label %advance

advance:
  %rbx.next = getelementptr i8*, i8** %rbx.cur, i64 1
  %9 = icmp ne i8** %rbx.next, %endptr
  br i1 %9, label %loop, label %ret

ret:
  ret void
}
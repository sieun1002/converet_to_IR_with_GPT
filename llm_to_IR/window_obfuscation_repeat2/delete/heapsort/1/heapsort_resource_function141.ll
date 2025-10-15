; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global i8

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %0 = load i32*, i32** @off_140004370, align 8
  %1 = load i32, i32* %0, align 4
  %cmp = icmp eq i32 %1, 2
  br i1 %cmp, label %check_reason, label %set_two

set_two:                                          ; preds = %entry
  store i32 2, i32* %0, align 4
  br label %check_reason

check_reason:                                     ; preds = %set_two, %entry
  %is_two = icmp eq i32 %Reason, 2
  br i1 %is_two, label %on_attach, label %check_detach

check_detach:                                     ; preds = %check_reason
  %is_one = icmp eq i32 %Reason, 1
  br i1 %is_one, label %detach, label %ret

ret:                                              ; preds = %check_detach
  ret void

on_attach:                                        ; preds = %check_reason
  %startRaw = bitcast i8* @unk_140004BE0 to void (i8*, i32, i8*)**
  %endRaw = bitcast i8* @unk_140004BE0 to void (i8*, i32, i8*)**
  %same = icmp eq void (i8*, i32, i8*)** %startRaw, %endRaw
  br i1 %same, label %ret2, label %loop

loop:                                             ; preds = %loopcont, %on_attach
  %cur = phi void (i8*, i32, i8*)** [ %startRaw, %on_attach ], [ %next, %loopcont ]
  %fp = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %cur, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fp, null
  br i1 %isnull, label %loopcont, label %call

call:                                             ; preds = %loop
  call void %fp(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %loopcont

loopcont:                                         ; preds = %call, %loop
  %next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %cur, i64 1
  %done = icmp eq void (i8*, i32, i8*)** %next, %endRaw
  br i1 %done, label %ret2, label %loop

ret2:                                             ; preds = %loopcont, %on_attach
  ret void

detach:                                           ; preds = %check_detach
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}
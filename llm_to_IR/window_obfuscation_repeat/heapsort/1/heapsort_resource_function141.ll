; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@g_state = dso_local global i32 0, align 4
@off_140004370 = dso_local global i32* @g_state, align 8
@unk_140004BE0 = dso_local global [0 x void ()*] zeroinitializer, align 8

declare dso_local void @sub_1400023D0()

define dso_local void @TlsCallback_0(i8* %hModule, i32 %dwReason, i8* %lpReserved) {
entry:
  %state_ptr_ptr = load i32*, i32** @off_140004370, align 8
  %state_val = load i32, i32* %state_ptr_ptr, align 4
  %cmp_state = icmp eq i32 %state_val, 2
  br i1 %cmp_state, label %after_state, label %set_state

set_state:                                        ; preds = %entry
  store i32 2, i32* %state_ptr_ptr, align 4
  br label %after_state

after_state:                                      ; preds = %set_state, %entry
  %cmp_reason_detach = icmp eq i32 %dwReason, 2
  br i1 %cmp_reason_detach, label %do_loop_check, label %check_attach

check_attach:                                     ; preds = %after_state
  %cmp_reason_attach = icmp eq i32 %dwReason, 1
  br i1 %cmp_reason_attach, label %on_attach, label %ret

do_loop_check:                                    ; preds = %after_state
  %rbx = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %rsi = getelementptr inbounds [0 x void ()*], [0 x void ()*]* @unk_140004BE0, i64 0, i64 0
  %cmp_empty = icmp eq void ()** %rbx, %rsi
  br i1 %cmp_empty, label %ret, label %loop

loop:                                             ; preds = %loop_tail, %do_loop_check
  %cur = phi void ()** [ %rbx, %do_loop_check ], [ %next, %loop_tail ]
  %fp = load void ()*, void ()** %cur, align 8
  %isnull = icmp eq void ()* %fp, null
  br i1 %isnull, label %skip_call, label %do_call

do_call:                                          ; preds = %loop
  call void %fp()
  br label %loop_tail

skip_call:                                        ; preds = %loop
  br label %loop_tail

loop_tail:                                        ; preds = %skip_call, %do_call
  %next = getelementptr inbounds void ()*, void ()** %cur, i64 1
  %done = icmp eq void ()** %next, %rsi
  br i1 %done, label %ret, label %loop

on_attach:                                        ; preds = %check_attach
  call void @sub_1400023D0()
  br label %ret

ret:                                              ; preds = %loop_tail, %do_loop_check, %check_attach
  ret void
}
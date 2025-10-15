; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@global_state_value = global i32 0, align 4
@off_140004370 = global i32* @global_state_value, align 8

@tls_callbacks = constant [0 x void (i8*, i32, i8*)*] zeroinitializer, align 8
@__tls_cb_begin = alias void (i8*, i32, i8*)**, getelementptr inbounds ([0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @tls_callbacks, i64 0, i64 0)
@__tls_cb_end   = alias void (i8*, i32, i8*)**, getelementptr inbounds ([0 x void (i8*, i32, i8*)*], [0 x void (i8*, i32, i8*)*]* @tls_callbacks, i64 0, i64 0)

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_0(i8* %h, i32 %reason, i8* %reserved) {
entry:
  %pstateptr_load = load i32*, i32** @off_140004370, align 8
  %state_load = load i32, i32* %pstateptr_load, align 4
  %cmp2 = icmp eq i32 %state_load, 2
  br i1 %cmp2, label %state_after, label %state_set

state_set:
  store i32 2, i32* %pstateptr_load, align 4
  br label %state_after

state_after:
  %isAttach = icmp eq i32 %reason, 2
  br i1 %isAttach, label %case_attach, label %check_detach

check_detach:
  %isDetach = icmp eq i32 %reason, 1
  br i1 %isDetach, label %case_detach, label %return

case_attach:
  %begin_eq_end = icmp eq void (i8*, i32, i8*)** @__tls_cb_begin, @__tls_cb_end
  br i1 %begin_eq_end, label %return, label %loop

loop:
  %i_phi = phi void (i8*, i32, i8*)** [ @__tls_cb_begin, %case_attach ], [ %i_next, %loop_latch ]
  %fp_load = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %i_phi, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fp_load, null
  br i1 %isnull, label %incr, label %do_call

do_call:
  call void %fp_load(i8* %h, i32 %reason, i8* %reserved)
  br label %incr

incr:
  %i_next = getelementptr inbounds void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %i_phi, i64 1
  %cmp_cont = icmp ne void (i8*, i32, i8*)** %i_next, @__tls_cb_end
  br i1 %cmp_cont, label %loop_latch, label %return

loop_latch:
  br label %loop

case_detach:
  tail call void @sub_1400023D0(i8* %h, i32 %reason, i8* %reserved)
  ret void

return:
  ret void
}
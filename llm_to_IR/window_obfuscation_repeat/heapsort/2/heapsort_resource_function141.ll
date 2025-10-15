; ModuleID = 'tls_callback_module'
source_filename = "tls_callback_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004370 = external global i32*
@unk_140004BE0 = external global void (i8*, i32, i8*)*
@unk_140004BE0_end = external global void (i8*, i32, i8*)*

declare void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_0(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %p_i32_ptr = load i32*, i32** @off_140004370, align 8
  %v = load i32, i32* %p_i32_ptr, align 4
  %cmp = icmp eq i32 %v, 2
  br i1 %cmp, label %after_set, label %do_set

do_set:                                           ; preds = %entry
  store i32 2, i32* %p_i32_ptr, align 4
  br label %after_set

after_set:                                        ; preds = %do_set, %entry
  switch i32 %Reason, label %ret [
    i32 2, label %on_attach
    i32 1, label %on_detach
  ]

ret:                                              ; preds = %after_iter, %on_attach, %after_set
  ret void

on_attach:                                        ; preds = %after_set
  %start_ptr = bitcast void (i8*, i32, i8*)** @unk_140004BE0 to i8*
  %end_ptr = bitcast void (i8*, i32, i8*)** @unk_140004BE0_end to i8*
  %cmpse = icmp eq i8* %start_ptr, %end_ptr
  br i1 %cmpse, label %ret, label %loop

loop:                                             ; preds = %on_attach, %after_iter
  %cur = phi i8* [ %start_ptr, %on_attach ], [ %next, %after_iter ]
  %fnptrptr = bitcast i8* %cur to void (i8*, i32, i8*)**
  %fn = load void (i8*, i32, i8*)*, void (i8*, i32, i8*)** %fnptrptr, align 8
  %isnull = icmp eq void (i8*, i32, i8*)* %fn, null
  br i1 %isnull, label %after_iter, label %do_call

do_call:                                          ; preds = %loop
  call void %fn(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  br label %after_iter

after_iter:                                       ; preds = %do_call, %loop
  %next = getelementptr i8, i8* %cur, i64 8
  %cont = icmp ne i8* %next, %end_ptr
  br i1 %cont, label %loop, label %ret

on_detach:                                        ; preds = %after_set
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}
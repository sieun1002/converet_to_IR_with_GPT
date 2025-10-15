; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@CriticalSection = external global i8, align 8
@Block = external global %struct.Node*, align 8

@__imp_EnterCriticalSection = external dllimport global void (i8*)*, align 8
@__imp_LeaveCriticalSection = external dllimport global void (i8*)*, align 8
@__imp_TlsGetValue = external dllimport global i8* (i32)*, align 8
@__imp_GetLastError = external dllimport global i32 ()*, align 8

define void @sub_140002240() local_unnamed_addr {
entry:
  %imp_enter = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %imp_enter(i8* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop.check

loop.check:                                        ; preds = %after_call, %entry
  %cur = phi %struct.Node* [ %head, %entry ], [ %next, %after_call ]
  %isnull = icmp eq %struct.Node* %cur, null
  br i1 %isnull, label %release, label %loop.body

loop.body:                                         ; preds = %loop.check
  %idxptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %idx = load i32, i32* %idxptr, align 4
  %imp_tls = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue, align 8
  %val = call i8* %imp_tls(i32 %idx)
  %imp_gle = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  %gle = call i32 %imp_gle()
  %isnull_val = icmp eq i8* %val, null
  br i1 %isnull_val, label %after_call, label %check_gle

check_gle:                                         ; preds = %loop.body
  %gle_nz = icmp ne i32 %gle, 0
  br i1 %gle_nz, label %after_call, label %do_call

do_call:                                           ; preds = %check_gle
  %fpptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %fp = load void (i8*)*, void (i8*)** %fpptr, align 8
  call void %fp(i8* %val)
  br label %after_call

after_call:                                        ; preds = %do_call, %check_gle, %loop.body
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br label %loop.check

release:                                           ; preds = %loop.check
  %imp_leave = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  tail call void %imp_leave(i8* @CriticalSection)
  ret void
}
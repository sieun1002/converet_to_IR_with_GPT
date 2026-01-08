; ModuleID = 'sub_140001E80'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.BlockNode = type { i32, i32, void (i8*)*, %struct.BlockNode* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.BlockNode*

@__imp_EnterCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_TlsGetValue = external global i8* (i32)*
@__imp_GetLastError = external global i32 ()*

define dso_local void @sub_140001E80() local_unnamed_addr {
entry:
  %pEnterCS = load void (%struct._RTL_CRITICAL_SECTION*)*, ptr @__imp_EnterCriticalSection, align 8
  call void %pEnterCS(ptr @CriticalSection)
  %head = load ptr, ptr @Block, align 8
  %isnull = icmp eq ptr %head, null
  br i1 %isnull, label %release, label %preheader

preheader:
  %pTlsGet = load i8* (i32)*, ptr @__imp_TlsGetValue, align 8
  %pGetLastErr = load i32 ()*, ptr @__imp_GetLastError, align 8
  br label %loop

loop:
  %cur = phi ptr [ %head, %preheader ], [ %next, %cont ]
  %idxptr = getelementptr inbounds %struct.BlockNode, ptr %cur, i32 0, i32 0
  %dw = load i32, ptr %idxptr, align 4
  %tlsval = call i8* %pTlsGet(i32 %dw)
  %err = call i32 %pGetLastErr()
  %isnulltls = icmp eq i8* %tlsval, null
  %iserr = icmp ne i32 %err, 0
  %skipcb = or i1 %isnulltls, %iserr
  br i1 %skipcb, label %skip, label %docb

docb:
  %cbptrptr = getelementptr inbounds %struct.BlockNode, ptr %cur, i32 0, i32 2
  %cb = load void (i8*)*, ptr %cbptrptr, align 8
  call void %cb(i8* %tlsval)
  br label %skip

skip:
  %nextptr = getelementptr inbounds %struct.BlockNode, ptr %cur, i32 0, i32 3
  %next = load ptr, ptr %nextptr, align 8
  %hasnext = icmp ne ptr %next, null
  br i1 %hasnext, label %cont, label %release

cont:
  br label %loop

release:
  %pLeaveCS = load void (%struct._RTL_CRITICAL_SECTION*)*, ptr @__imp_LeaveCriticalSection, align 8
  tail call void %pLeaveCS(ptr @CriticalSection)
  ret void
}
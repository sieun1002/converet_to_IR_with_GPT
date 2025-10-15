; target: Windows x64 (MSVC)
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%RTL_CRITICAL_SECTION = type opaque
%struct.BlockNode = type { i32, i32, void (i8*)*, %struct.BlockNode* }

@CriticalSection = external dso_local global %RTL_CRITICAL_SECTION, align 8
@Block = external dso_local global %struct.BlockNode*, align 8

declare dso_local void @EnterCriticalSection(%RTL_CRITICAL_SECTION*)
declare dso_local void @LeaveCriticalSection(%RTL_CRITICAL_SECTION*)
declare dso_local i8* @TlsGetValue(i32)
declare dso_local i32 @GetLastError()

define dso_local void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%RTL_CRITICAL_SECTION* @CriticalSection)
  %head0 = load %struct.BlockNode*, %struct.BlockNode** @Block, align 8
  %isnull = icmp eq %struct.BlockNode* %head0, null
  br i1 %isnull, label %release, label %loop

loop:
  %cur = phi %struct.BlockNode* [ %head0, %entry ], [ %next, %loop_end ]
  %tls_index_ptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 0
  %tls_index = load i32, i32* %tls_index_ptr, align 4
  %tls_value = call i8* @TlsGetValue(i32 %tls_index)
  %gle = call i32 @GetLastError()
  %is_nonnull = icmp ne i8* %tls_value, null
  br i1 %is_nonnull, label %check_gle, label %skip_call

check_gle:
  %is_zero = icmp eq i32 %gle, 0
  br i1 %is_zero, label %do_call, label %skip_call

do_call:
  %funcp_ptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 2
  %funcp = load void (i8*)*, void (i8*)** %funcp_ptr, align 8
  call void %funcp(i8* %tls_value)
  br label %loop_end

skip_call:
  br label %loop_end

loop_end:
  %next_ptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 3
  %next = load %struct.BlockNode*, %struct.BlockNode** %next_ptr, align 8
  %hasnext = icmp ne %struct.BlockNode* %next, null
  br i1 %hasnext, label %loop, label %release

release:
  call void @LeaveCriticalSection(%RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}
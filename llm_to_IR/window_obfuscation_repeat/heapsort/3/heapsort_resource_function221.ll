; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.BlockNode = type { i32, i32, void (i8*)*, %struct.BlockNode* }

@CriticalSection = external global %struct.CRITICAL_SECTION, align 8
@Block = external global %struct.BlockNode*, align 8

declare dllimport void @EnterCriticalSection(%struct.CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct.CRITICAL_SECTION*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct.CRITICAL_SECTION* @CriticalSection)
  %blk0 = load %struct.BlockNode*, %struct.BlockNode** @Block, align 8
  %cmp0 = icmp eq %struct.BlockNode* %blk0, null
  br i1 %cmp0, label %release, label %loop

loop:                                             ; preds = %entry, %nextblock
  %blk = phi %struct.BlockNode* [ %blk0, %entry ], [ %next, %nextblock ]
  %idxptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %blk, i32 0, i32 0
  %idx = load i32, i32* %idxptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %idx)
  %lasterr = call i32 @GetLastError()
  %isnull = icmp eq i8* %tlsval, null
  br i1 %isnull, label %nextblock, label %checkerr

checkerr:                                         ; preds = %loop
  %iszero = icmp eq i32 %lasterr, 0
  br i1 %iszero, label %docall, label %nextblock

docall:                                           ; preds = %checkerr
  %cbptrptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %blk, i32 0, i32 2
  %cbptr = load void (i8*)*, void (i8*)** %cbptrptr, align 8
  call void %cbptr(i8* %tlsval)
  br label %nextblock

nextblock:                                        ; preds = %docall, %checkerr, %loop
  %nextptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %blk, i32 0, i32 3
  %next = load %struct.BlockNode*, %struct.BlockNode** %nextptr, align 8
  %cmp1 = icmp eq %struct.BlockNode* %next, null
  br i1 %cmp1, label %release, label %loop

release:                                          ; preds = %nextblock, %entry
  call void @LeaveCriticalSection(%struct.CRITICAL_SECTION* @CriticalSection)
  ret void
}
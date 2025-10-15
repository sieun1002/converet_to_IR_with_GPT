; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@__imp_EnterCriticalSection = external dllimport global void (i8*)*
@__imp_LeaveCriticalSection = external dllimport global void (i8*)*
@__imp_TlsGetValue = external dllimport global i8* (i32)*
@__imp_GetLastError = external dllimport global i32 ()*

@CriticalSection = external global i8
@Block = external global i8*

define void @sub_140002240() {
entry:
  %ecsptr = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection
  call void %ecsptr(i8* @CriticalSection)
  %head = load i8*, i8** @Block
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %leave, label %init

init:
  %tlsGetPtr = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue
  %glePtr = load i32 ()*, i32 ()** @__imp_GetLastError
  br label %loop

loop:
  %cur = phi i8* [ %head, %init ], [ %next, %cont ]
  %idxPtr = bitcast i8* %cur to i32*
  %tlsIndex = load i32, i32* %idxPtr, align 4
  %tlsVal = call i8* %tlsGetPtr(i32 %tlsIndex)
  %gle = call i32 %glePtr()
  %valNotNull = icmp ne i8* %tlsVal, null
  br i1 %valNotNull, label %checkError, label %cont

checkError:
  %errNonZero = icmp ne i32 %gle, 0
  br i1 %errNonZero, label %cont, label %doCall

doCall:
  %cbAddr_i8 = getelementptr i8, i8* %cur, i64 8
  %cbAddr = bitcast i8* %cbAddr_i8 to void (i8*)**
  %cb = load void (i8*)*, void (i8*)** %cbAddr
  call void %cb(i8* %tlsVal)
  br label %cont

cont:
  %nextPtr_i8 = getelementptr i8, i8* %cur, i64 16
  %nextPtr = bitcast i8* %nextPtr_i8 to i8**
  %next = load i8*, i8** %nextPtr
  %hasNext = icmp ne i8* %next, null
  br i1 %hasNext, label %loop, label %leave

leave:
  %lcsptr = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection
  tail call void %lcsptr(i8* @CriticalSection)
  ret void
}
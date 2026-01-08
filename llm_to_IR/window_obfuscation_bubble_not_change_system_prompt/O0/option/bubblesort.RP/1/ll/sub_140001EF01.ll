; ModuleID = 'sub_140001EF0.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, i8* }

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global i8*
@__imp_EnterCriticalSection = external global void (i8*)*
@__imp_LeaveCriticalSection = external global void (i8*)*

declare i8* @calloc(i64, i64)

define dso_local i32 @sub_140001EF0(i32 %ecx, i8* %rdx) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp eq i32 %0, 0
  br i1 %1, label %ret0, label %cont

cont:
  %2 = call i8* @calloc(i64 1, i64 24)
  %3 = icmp eq i8* %2, null
  br i1 %3, label %retm1, label %nonnull

nonnull:
  %4 = bitcast i8* %2 to %struct.Node*
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 0
  store i32 %ecx, i32* %5, align 4
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 2
  store i8* %rdx, i8** %6, align 8
  %7 = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %7(i8* @CriticalSection)
  %8 = load i8*, i8** @Block, align 8
  %9 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 3
  store i8* %8, i8** %9, align 8
  %10 = bitcast %struct.Node* %4 to i8*
  store i8* %10, i8** @Block, align 8
  %11 = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  call void %11(i8* @CriticalSection)
  br label %ret0

ret0:
  ret i32 0

retm1:
  ret i32 -1
}
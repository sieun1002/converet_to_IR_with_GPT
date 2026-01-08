; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global %struct.Node*
@__imp_EnterCriticalSection = external global void (i8*)*
@__imp_LeaveCriticalSection = external global void (i8*)*

declare i8* @calloc(i64, i64)

define dso_local i32 @sub_140001EF0(i32 %arg0, i8* %arg1) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %mem = call i8* @calloc(i64 1, i64 24)
  %null = icmp eq i8* %mem, null
  br i1 %null, label %fail, label %gotmem

fail:
  ret i32 -1

gotmem:
  %node = bitcast i8* %mem to %struct.Node*
  %field0ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %arg0, i32* %field0ptr, align 4
  %field2ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %arg1, i8** %field2ptr, align 8
  %fp = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %fp(i8* @CriticalSection)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %field3ptr = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %field3ptr, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  %fp2 = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  call void %fp2(i8* @CriticalSection)
  ret i32 0
}
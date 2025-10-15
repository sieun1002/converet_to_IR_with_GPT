; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i8*, %struct.Node* }

@dword_1400070E8 = external dso_local global i32
@Block = dso_local global %struct.Node* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare dso_local noalias i8* @calloc(i64 noundef, i64 noundef)
declare dso_local void @EnterCriticalSection(i8* noundef)
declare dso_local void @LeaveCriticalSection(i8* noundef)

define dso_local i32 @sub_1400022B0(i32 noundef %a, i8* noundef %p) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %active, label %ret_zero

ret_zero:                                          ; preds = %entry
  ret i32 0

active:                                            ; preds = %entry
  %mem = call noalias i8* @calloc(i64 1, i64 24)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %alloc_fail, label %alloc_ok

alloc_fail:                                        ; preds = %active
  ret i32 -1

alloc_ok:                                          ; preds = %active
  %node = bitcast i8* %mem to %struct.Node*
  %fld0 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  store i32 %a, i32* %fld0, align 4
  %fld2 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 2
  store i8* %p, i8** %fld2, align 8
  %cs.ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i32 0, i32 0
  call void @EnterCriticalSection(i8* %cs.ptr)
  %old = load %struct.Node*, %struct.Node** @Block, align 8
  %fld3 = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 3
  store %struct.Node* %old, %struct.Node** %fld3, align 8
  store %struct.Node* %node, %struct.Node** @Block, align 8
  call void @LeaveCriticalSection(i8* %cs.ptr)
  ret i32 0
}
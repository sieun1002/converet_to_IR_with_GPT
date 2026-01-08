; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, void (i8*)*, %struct.Node* }

@unk_140007100 = external global i8

declare void @sub_1400DC968(i8*)
declare void @loc_1403E33B2(i8*)

define dso_local void @sub_140001E80(%struct.Node* %arg_rbx, i32 ()* %arg_rdi, i8* (i32)* %arg_rbp) {
entry:
  call void @sub_1400DC968(i8* @unk_140007100)
  %cmp_null = icmp eq %struct.Node* %arg_rbx, null
  br i1 %cmp_null, label %end, label %loop

loop:                                             ; preds = %entry, %after_call
  %cur = phi %struct.Node* [ %arg_rbx, %entry ], [ %next, %after_call ]
  %key.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %key.ptr, align 4
  %rbp_res = call i8* %arg_rbp(i32 %key)
  %rsi_nz = icmp ne i8* %rbp_res, null
  %rdi_res = call i32 %arg_rdi()
  %rdi_zero = icmp eq i32 %rdi_res, 0
  %cond = and i1 %rsi_nz, %rdi_zero
  br i1 %cond, label %do_call, label %after_call

do_call:                                          ; preds = %loop
  %fn.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %fn = load void (i8*)*, void (i8*)** %fn.ptr, align 8
  call void %fn(i8* %rbp_res)
  br label %after_call

after_call:                                       ; preds = %do_call, %loop
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %has_next = icmp ne %struct.Node* %next, null
  br i1 %has_next, label %loop, label %end

end:                                              ; preds = %after_call, %entry
  call void @loc_1403E33B2(i8* @unk_140007100)
  ret void
}
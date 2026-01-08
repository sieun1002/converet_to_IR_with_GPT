; ModuleID = 'sub_140001E80'
target triple = "x86_64-pc-windows-msvc"

@qword_140008258 = external global i8*
@qword_1400070E0 = external global i8*
@qword_140008288 = external global i8*
@qword_140008260 = external global i8*
@qword_140008270 = external global i8*
@unk_140007100 = external global i8

define void @sub_140001E80() {
entry:
  %fp_acquire_p = load i8*, i8** @qword_140008258
  %fp_acquire = bitcast i8* %fp_acquire_p to void (i8*)*
  call void %fp_acquire(i8* @unk_140007100)

  %head = load i8*, i8** @qword_1400070E0
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %release, label %init

init:
  %fp_fnA_p = load i8*, i8** @qword_140008288
  %fp_fnA = bitcast i8* %fp_fnA_p to i8* (i32)*
  %fp_fnB_p = load i8*, i8** @qword_140008260
  %fp_fnB = bitcast i8* %fp_fnB_p to i32 ()*
  br label %loop

loop:
  %node = phi i8* [ %head, %init ], [ %next, %cont ]

  %node_i32p = bitcast i8* %node to i32*
  %val32 = load i32, i32* %node_i32p, align 4
  %rsi_val = call i8* %fp_fnA(i32 %val32)
  %eax_val = call i32 %fp_fnB()

  %rsi_nonnull = icmp ne i8* %rsi_val, null
  %eax_zero = icmp eq i32 %eax_val, 0
  %do_invoke = and i1 %rsi_nonnull, %eax_zero
  br i1 %do_invoke, label %invoke, label %after_invoke

invoke:
  %fp_node_call_loc = getelementptr i8, i8* %node, i64 8
  %fp_node_call_loc_pp = bitcast i8* %fp_node_call_loc to i8**
  %fp_node_call_p = load i8*, i8** %fp_node_call_loc_pp, align 8
  %fp_node_call = bitcast i8* %fp_node_call_p to void (i8*)*
  call void %fp_node_call(i8* %rsi_val)
  br label %after_invoke

after_invoke:
  %next_loc = getelementptr i8, i8* %node, i64 16
  %next_loc_pp = bitcast i8* %next_loc to i8**
  %next = load i8*, i8** %next_loc_pp, align 8
  %has_next = icmp ne i8* %next, null
  br i1 %has_next, label %cont, label %release

cont:
  br label %loop

release:
  %fp_release_p = load i8*, i8** @qword_140008270
  %fp_release = bitcast i8* %fp_release_p to void (i8*)*
  call void %fp_release(i8* @unk_140007100)
  ret void
}
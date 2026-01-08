; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external dso_local global i8
@qword_140008258 = external dso_local global void (i8*)*
@qword_1400070E0 = external dso_local global i8*
@qword_140008288 = external dso_local global i8* (i32)*
@qword_140008260 = external dso_local global i32 ()*
@qword_140008270 = external dso_local global void (i8*)*

define dso_local void @sub_140001E80() {
entry:
  %fp_enter = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %fp_enter(i8* @unk_140007100)

  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %exit, label %loop.prep

loop.prep:
  %fnA = load i8* (i32)*, i8* (i32)** @qword_140008288, align 8
  %fnB = load i32 ()*, i32 ()** @qword_140008260, align 8
  br label %loop

loop:
  %node = phi i8* [ %head, %loop.prep ], [ %next, %cont ]

  %val_ptr = bitcast i8* %node to i32*
  %val = load i32, i32* %val_ptr, align 4
  %res = call i8* %fnA(i32 %val)
  %bret = call i32 %fnB()

  %res_is_null = icmp eq i8* %res, null
  br i1 %res_is_null, label %cont, label %check_b

check_b:
  %b_notzero = icmp ne i32 %bret, 0
  br i1 %b_notzero, label %cont, label %do_call

do_call:
  %fp_field_i8 = getelementptr i8, i8* %node, i64 8
  %fp_field = bitcast i8* %fp_field_i8 to void (i8*)**
  %callee = load void (i8*)*, void (i8*)** %fp_field, align 8
  call void %callee(i8* %res)
  br label %cont

cont:
  %next_ptr_i8 = getelementptr i8, i8* %node, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  %next_null = icmp eq i8* %next, null
  br i1 %next_null, label %exit, label %loop

exit:
  %fp_leave = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  tail call void %fp_leave(i8* @unk_140007100)
  ret void
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_140008258 = external global i8*
@qword_1400070E0 = external global i8*
@qword_140008288 = external global i8*
@qword_140008260 = external global i8*
@qword_140008270 = external global i8*
@unk_140007100 = external global i8

define dso_local void @sub_140001E80() {
entry:
  %p258 = load i8*, i8** @qword_140008258, align 8
  %f258 = bitcast i8* %p258 to void (i8*)*
  call void %f258(i8* @unk_140007100)

  %head_ptr = load i8*, i8** @qword_1400070E0, align 8
  %head_isnull = icmp eq i8* %head_ptr, null
  br i1 %head_isnull, label %tailcall, label %loop.prep

loop.prep:
  %p288 = load i8*, i8** @qword_140008288, align 8
  %f288 = bitcast i8* %p288 to i8* (i32)*
  %p260 = load i8*, i8** @qword_140008260, align 8
  %f260 = bitcast i8* %p260 to i32 ()*
  br label %loop

loop:
  %rbx.cur = phi i8* [ %head_ptr, %loop.prep ], [ %nextptr, %advance ]
  %rbx_i32ptr = bitcast i8* %rbx.cur to i32*
  %v = load i32, i32* %rbx_i32ptr, align 4
  %obj = call i8* %f288(i32 %v)
  %retval = call i32 %f260()
  %obj_isnull = icmp eq i8* %obj, null
  br i1 %obj_isnull, label %advance, label %checkret

checkret:
  %ret_is_nonzero = icmp ne i32 %retval, 0
  br i1 %ret_is_nonzero, label %advance, label %docall

docall:
  %rbx_plus8 = getelementptr i8, i8* %rbx.cur, i64 8
  %fp_ptr_ptr = bitcast i8* %rbx_plus8 to i8**
  %fp_raw = load i8*, i8** %fp_ptr_ptr, align 8
  %fp = bitcast i8* %fp_raw to void (i8*)*
  call void %fp(i8* %obj)
  br label %advance

advance:
  %rbx_plus16 = getelementptr i8, i8* %rbx.cur, i64 16
  %next_ptr_ptr = bitcast i8* %rbx_plus16 to i8**
  %nextptr = load i8*, i8** %next_ptr_ptr, align 8
  %cond = icmp ne i8* %nextptr, null
  br i1 %cond, label %loop, label %tailcall

tailcall:
  %p270 = load i8*, i8** @qword_140008270, align 8
  %f270 = bitcast i8* %p270 to void (i8*)*
  tail call void %f270(i8* @unk_140007100)
  ret void
}
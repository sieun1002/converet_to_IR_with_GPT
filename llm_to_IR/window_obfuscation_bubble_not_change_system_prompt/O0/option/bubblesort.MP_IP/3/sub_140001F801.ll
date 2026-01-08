; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_14063991D(i8*)
declare i8* @sub_140016046(i8*)
declare void @loc_1400027ED()

define i32 @sub_140001F80(i32 %ecx, i32 %edx) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %nz, label %ret0

ret0:
  ret i32 0

nz:
  %cur0 = call i8* @sub_14063991D(i8* @unk_140007100)
  br label %fc0

fc0:
  %cur = phi i8* [ %cur0, %nz ], [ %next, %loop_cont ]
  %prev = phi i8* [ @unk_140007100, %nz ], [ %cur, %loop_cont ]
  %isnull = icmp eq i8* %cur, null
  br i1 %isnull, label %fe3, label %body

body:
  %cur_i32p = bitcast i8* %cur to i32*
  %val = load i32, i32* %cur_i32p, align 4
  %cmp = icmp eq i32 %val, %edx
  %next_ptr_i8 = getelementptr i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  br i1 %cmp, label %found, label %loop_cont

loop_cont:
  br label %fc0

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %loc2000, label %unlink

unlink:
  %prev_next_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next, align 8
  br label %callfde

fe3:
  %r_sub = call i8* @sub_140016046(i8* @unk_140007100)
  store i8* %r_sub, i8** @qword_1400070E0, align 8
  br label %callfde

loc2000:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %callfde

callfde:
  %p = ptrtoint void ()* @loc_1400027ED to i64
  %p3 = add i64 %p, 3
  %fn = inttoptr i64 %p3 to void ()*
  call void %fn()
  br label %fe3
}
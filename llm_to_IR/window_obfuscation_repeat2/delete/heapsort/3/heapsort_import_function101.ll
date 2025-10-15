; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare i8* @sub_140002BA8(i32, i32, i8*, i32)
declare { i8*, i8* } @sub_1400DA76B(i8*)
declare void @sub_1403CBAAE(i8*)

define i32 @sub_1400022B0(i32 %ecx0, i8* %rdx0, i8* %r80, i32 %r90) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %cond_true, label %ret_zero

ret_zero:                                         ; preds = %entry, %path
  ret i32 0

cond_true:                                        ; preds = %entry
  %call = call i8* @sub_140002BA8(i32 1, i32 24, i8* %r80, i32 %ecx0)
  %isnull = icmp eq i8* %call, null
  br i1 %isnull, label %ret_neg1, label %path

ret_neg1:                                         ; preds = %cond_true
  ret i32 -1

path:                                             ; preds = %cond_true
  %obj_i32ptr = bitcast i8* %call to i32*
  store i32 %ecx0, i32* %obj_i32ptr, align 4
  %obj_plus8 = getelementptr i8, i8* %call, i64 8
  %obj8ptr = bitcast i8* %obj_plus8 to i8**
  store i8* %rdx0, i8** %obj8ptr, align 8
  %pair = call { i8*, i8* } @sub_1400DA76B(i8* @unk_140007100)
  %ret0 = extractvalue { i8*, i8* } %pair, 0
  %ret1 = extractvalue { i8*, i8* } %pair, 1
  %delta = getelementptr i8, i8* %ret0, i64 -117
  %mem_i32ptr = bitcast i8* %delta to i32*
  %memval = load i32, i32* %mem_i32ptr, align 4
  %borrow = icmp ult i32 1, %memval
  %ret0_int = ptrtoint i8* %ret0 to i64
  %eax32 = trunc i64 %ret0_int to i32
  %cf = zext i1 %borrow to i32
  %sum = add i32 %eax32, 19912
  %sum2 = add i32 %sum, %cf
  %obj_plus16 = getelementptr i8, i8* %call, i64 16
  %obj16ptr = bitcast i8* %obj_plus16 to i8**
  store i8* %ret1, i8** %obj16ptr, align 8
  store i8* %call, i8** @qword_1400070E0, align 8
  call void @sub_1403CBAAE(i8* @unk_140007100)
  br label %ret_zero
}
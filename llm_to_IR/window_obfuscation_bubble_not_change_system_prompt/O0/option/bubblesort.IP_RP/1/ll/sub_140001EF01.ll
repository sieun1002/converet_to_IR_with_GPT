; target triple
target triple = "x86_64-pc-windows-msvc"

; external declarations
declare i8* @sub_1400027E8(i32 noundef, i32 noundef)
declare void @sub_1400D1A4D(i8* noundef)
declare void @sub_1400FEC0A(i8* noundef)

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

define i32 @sub_140001EF0(i32 noundef %ecx, i8* noundef %rdx) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %if.then, label %ret.zero

ret.zero:
  ret i32 0

if.then:
  %p = call i8* @sub_1400027E8(i32 noundef 1, i32 noundef 24)
  %isnull = icmp eq i8* %p, null
  br i1 %isnull, label %ret.neg1, label %cont

ret.neg1:
  ret i32 -1

cont:
  %p_i32 = bitcast i8* %p to i32*
  store i32 %ecx, i32* %p_i32, align 4
  %p_plus8 = getelementptr inbounds i8, i8* %p, i64 8
  %p_plus8_ptr = bitcast i8* %p_plus8 to i8**
  store i8* %rdx, i8** %p_plus8_ptr, align 8
  call void @sub_1400D1A4D(i8* noundef @unk_140007100)
  %old = load i8*, i8** @qword_1400070E0, align 8
  %p_plus16 = getelementptr inbounds i8, i8* %p, i64 16
  %p_plus16_ptr = bitcast i8* %p_plus16 to i8**
  store i8* %old, i8** %p_plus16_ptr, align 8
  store i8* %p, i8** @qword_1400070E0, align 8
  call void @sub_1400FEC0A(i8* noundef @unk_140007100)
  ret i32 0
}
; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140004000 = external global i8

declare void @sub_140001890()
declare void @sub_140001450(i32*, i64)
declare void @sub_140002900(i8*, i32)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  call void @sub_140001890()

  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 7, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %e8, align 4

  store i64 9, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  call void @sub_140001450(i32* %arr0, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_cur = load i64, i64* %i, align 8
  %n_cur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %i_cur, %n_cur
  br i1 %cond, label %body, label %end

body:
  %elem_ptr = getelementptr inbounds i32, i32* %arr0, i64 %i_cur
  %elem = load i32, i32* %elem_ptr, align 4
  call void @sub_140002900(i8* @unk_140004000, i32 %elem)
  %next = add i64 %i_cur, 1
  store i64 %next, i64* %i, align 8
  br label %loop

end:
  ret i32 0
}
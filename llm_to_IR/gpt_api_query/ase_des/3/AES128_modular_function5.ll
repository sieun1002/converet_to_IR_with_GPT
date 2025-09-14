; ModuleID = '_sub_bytes'
source_filename = "_sub_bytes.ll"

declare i8 @sbox_lookup(i32)

define void @_sub_bytes(i8* %buf) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx = sext i32 %iv to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %idx
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %res = call i8 @sbox_lookup(i32 %b32)
  store i8 %res, i8* %p, align 1
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

exit:
  ret void
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@aElementFoundAt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() {
loc_1060:
  call void asm sideeffect "endbr64", ""()
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 3)
  br label %loc_1080

loc_1080:
  ret i32 0
}
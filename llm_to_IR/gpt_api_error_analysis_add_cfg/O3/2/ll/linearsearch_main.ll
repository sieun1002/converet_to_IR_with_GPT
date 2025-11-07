; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@aElementFoundAt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
loc_1060:
  br label %loc_1064

loc_1064:
  br label %loc_1068

loc_1068:
  br label %loc_106d

loc_106d:
  br label %loc_1072

loc_1072:
  br label %loc_1074

loc_1074:
  br label %loc_107b

loc_107b:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmtptr, i32 3)
  br label %loc_1080

loc_1080:
  br label %loc_1082

loc_1082:
  br label %loc_1086

loc_1086:
  ret i32 0
}
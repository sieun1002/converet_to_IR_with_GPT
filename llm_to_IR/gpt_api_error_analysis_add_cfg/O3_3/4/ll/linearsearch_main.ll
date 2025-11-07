; ModuleID = 'recovered'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@aElementFoundAt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)

define i32 @main() {
bb_1060:
  ; endbr64
  br label %bb_1064

bb_1064:
  ; sub rsp, 8
  br label %bb_1068

bb_1068:
  ; mov edx, 3
  br label %bb_106d

bb_106d:
  ; mov edi, 2
  br label %bb_1072

bb_1072:
  ; xor eax, eax
  br label %bb_1074

bb_1074:
  ; lea rsi, aElementFoundAt
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  br label %bb_107b

bb_107b:
  ; call ___printf_chk
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmtptr, i32 3)
  br label %bb_1080

bb_1080:
  ; xor eax, eax
  br label %bb_1082

bb_1082:
  ; add rsp, 8
  br label %bb_1086

bb_1086:
  ; retn
  ret i32 0
}
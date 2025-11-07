; ModuleID = 'reconstructed'
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn
declare void @heap_sort(i32*, i64)

define i32 @main() {
"0x144b":
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %n = alloca i64, align 8
  %canary.save = alloca i64, align 8
  %canary.cur.0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary.cur.0, i64* %canary.save, align 8
  %arr.base0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.base0, align 4
  %arr.idx1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.idx8, align 4
  store i64 9, i64* %n, align 8
  store i64 0, i64* %i, align 8
  br label %"0x14da"

"0x14b7":                                            ; preds = %"0x14da"
  %i.val.1 = load i64, i64* %i, align 8
  %elem.ptr.1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val.1
  %elem.val.1 = load i32, i32* %elem.ptr.1, align 4
  %fmt.ptr.1 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call.printf.1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr.1, i32 %elem.val.1)
  %i.inc.1 = add i64 %i.val.1, 1
  store i64 %i.inc.1, i64* %i, align 8
  br label %"0x14da"

"0x14da":                                            ; preds = %"0x144b", %"0x14b7"
  %i.cur.0 = load i64, i64* %i, align 8
  %n.cur.0 = load i64, i64* %n, align 8
  %cmp.jb.0 = icmp ult i64 %i.cur.0, %n.cur.0
  br i1 %cmp.jb.0, label %"0x14b7", label %bb_14e4

bb_14e4:                                            ; preds = %"0x14da"
  %call.putchar.1 = call i32 @putchar(i32 10)
  %n.sort.0 = load i64, i64* %n, align 8
  %arr.ptr.0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.ptr.0, i64 %n.sort.0)
  store i64 0, i64* %j, align 8
  br label %"0x152e"

"0x150b":                                            ; preds = %"0x152e"
  %j.val.1 = load i64, i64* %j, align 8
  %elem.ptr.2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val.1
  %elem.val.2 = load i32, i32* %elem.ptr.2, align 4
  %fmt.ptr.2 = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call.printf.2 = call i32 (i8*, ...) @printf(i8* %fmt.ptr.2, i32 %elem.val.2)
  %j.inc.1 = add i64 %j.val.1, 1
  store i64 %j.inc.1, i64* %j, align 8
  br label %"0x152e"

"0x152e":                                            ; preds = %bb_14e4, %"0x150b"
  %j.cur.0 = load i64, i64* %j, align 8
  %n.cur.1 = load i64, i64* %n, align 8
  %cmp.jb.1 = icmp ult i64 %j.cur.0, %n.cur.1
  br i1 %cmp.jb.1, label %"0x150b", label %bb_1538

bb_1538:                                            ; preds = %"0x152e"
  %call.putchar.2 = call i32 @putchar(i32 10)
  %canary.saved.1 = load i64, i64* %canary.save, align 8
  %canary.cur.1 = load i64, i64* @__stack_chk_guard, align 8
  %canary.eq = icmp eq i64 %canary.saved.1, %canary.cur.1
  br i1 %canary.eq, label %"0x155b", label %bb_1556

bb_1556:                                            ; preds = %bb_1538
  call void @__stack_chk_fail()
  unreachable

"0x155b":                                           ; preds = %bb_1538
  ret i32 0
}
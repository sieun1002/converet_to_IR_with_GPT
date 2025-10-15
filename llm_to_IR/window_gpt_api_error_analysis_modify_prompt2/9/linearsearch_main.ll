; ModuleID = 'recovered_main'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer  = internal unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p1, i64 1
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p2, i64 1
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p3, i64 1
  store i32 2, i32* %p4, align 4
  %idx = call i32 @linear_search(i32* %p0, i32 5, i32 4)
  %isneg1 = icmp eq i32 %idx, -1
  br i1 %isneg1, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %pcall = call i32 (i8*, ...) @printf(i8* %fmt, i32 %idx)
  br label %done

notfound:
  %buf = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %scall = call i32 @puts(i8* %buf)
  br label %done

done:
  ret i32 0
}
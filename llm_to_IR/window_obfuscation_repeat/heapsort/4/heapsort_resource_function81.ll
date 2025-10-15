; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"

@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@Format = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@byte_14000400D = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @sub_1400018F0() {
entry:
  ret void
}

define dso_local void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %half = lshr i64 %n, 1
  %i.addr = alloca i64, align 8
  store i64 0, i64* %i.addr, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = load i64, i64* %i.addr, align 8
  %cmp = icmp ult i64 %i, %half
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %endidx = sub i64 %n, 1
  %opp = sub i64 %endidx, %i
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %i
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %opp
  %v1 = load i32, i32* %p1, align 4
  %v2 = load i32, i32* %p2, align 4
  store i32 %v2, i32* %p1, align 4
  store i32 %v1, i32* %p2, align 4
  %inc = add i64 %i, 1
  store i64 %inc, i64* %i.addr, align 8
  br label %loop

done:                                             ; preds = %loop
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %n = add i64 0, 9
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %fmt_d_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %fmt_before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %fmt_after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  call void @sub_1400018F0()
  %p0 = getelementptr inbounds i32, i32* %arrptr, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrptr, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrptr, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrptr, i64 8
  store i32 5, i32* %p8, align 4
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_before_ptr)
  store i64 0, i64* %idx1, align 8
  br label %L1

L1:                                               ; preds = %L1.body, %entry
  %iv1 = load i64, i64* %idx1, align 8
  %cmp1 = icmp ult i64 %iv1, %n
  br i1 %cmp1, label %L1.body, label %L1.end

L1.body:                                          ; preds = %L1
  %elem_ptr = getelementptr inbounds i32, i32* %arrptr, i64 %iv1
  %elem = load i32, i32* %elem_ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_d_ptr, i32 %elem)
  %iv1.next = add i64 %iv1, 1
  store i64 %iv1.next, i64* %idx1, align 8
  br label %L1

L1.end:                                           ; preds = %L1
  %newline1 = call i32 @putchar(i32 10)
  call void @sub_140001450(i32* %arrptr, i64 %n)
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_after_ptr)
  store i64 0, i64* %idx2, align 8
  br label %L2

L2:                                               ; preds = %L2.body, %L1.end
  %iv2 = load i64, i64* %idx2, align 8
  %cmp2 = icmp ult i64 %iv2, %n
  br i1 %cmp2, label %L2.body, label %L2.end

L2.body:                                          ; preds = %L2
  %elem2_ptr = getelementptr inbounds i32, i32* %arrptr, i64 %iv2
  %elem2 = load i32, i32* %elem2_ptr, align 4
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_d_ptr, i32 %elem2)
  %iv2.next = add i64 %iv2, 1
  store i64 %iv2.next, i64* %idx2, align 8
  br label %L2

L2.end:                                           ; preds = %L2
  %newline2 = call i32 @putchar(i32 10)
  ret i32 0
}
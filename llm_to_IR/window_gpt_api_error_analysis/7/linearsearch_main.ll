; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define void @__main() {
entry:
  ret void
}

define i32 @linear_search(i32* %arr, i32 %size, i32 %target) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %size
  br i1 %cmp, label %body, label %end

body:
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %inc

found:
  ret i32 %i.val

inc:
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

end:
  ret i32 -1
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %size = alloca i32, align 4
  %target = alloca i32, align 4
  %result = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 4
  store i32 5, i32* %size, align 4
  store i32 4, i32* %target, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %sizeval = load i32, i32* %size, align 4
  %targetval = load i32, i32* %target, align 4
  %call = call i32 @linear_search(i32* %arrdecay, i32 %sizeval, i32 %targetval)
  store i32 %call, i32* %result, align 4
  %resval = load i32, i32* %result, align 4
  %isneg1 = icmp eq i32 %resval, -1
  br i1 %isneg1, label %notfound, label %foundlbl

foundlbl:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %resval2 = load i32, i32* %result, align 4
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %resval2)
  br label %end

notfound:
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %end

end:
  ret i32 0
}
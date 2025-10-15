; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"

@.str_fmt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)
define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %key) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %ret_minus1

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i32 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %found, label %cont

found:
  ret i32 %i

cont:
  %inc = add nsw i32 %i, 1
  br label %loop

ret_minus1:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 4
  store i32 2, i32* %p4, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %idx = call i32 @linear_search(i32* %arrdecay, i32 5, i32 4)
  %isneg1 = icmp eq i32 %idx, -1
  br i1 %isneg1, label %notfound, label %found_print

found_print:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_fmt, i32 0, i32 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %ret

notfound:
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_notfound, i32 0, i32 0
  %callputs = call i32 @puts(i8* %nfptr)
  br label %ret

ret:
  ret i32 0
}
; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer  = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @puts(i8*)

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %target, i32 %n) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.load = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.load, %n
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idxprom = sext i32 %i.load to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %inc

found:                                            ; preds = %body
  ret i32 %i.load

inc:                                              ; preds = %body
  %i.next = add nsw i32 %i.load, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

done:                                             ; preds = %loop
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %arr0p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  store i32 5, i32* %arr0p, align 4
  %arr1p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 1
  store i32 3, i32* %arr1p, align 4
  %arr2p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 2
  store i32 8, i32* %arr2p, align 4
  %arr3p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 3
  store i32 4, i32* %arr3p, align 4
  %arr4p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 4
  store i32 2, i32* %arr4p, align 4
  store i32 5, i32* %var4, align 4
  store i32 4, i32* %var8, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %t = load i32, i32* %var4, align 4
  %n = load i32, i32* %var8, align 4
  %ret = call i32 @linear_search(i32* %arrdecay, i32 %t, i32 %n)
  store i32 %ret, i32* %varC, align 4
  %retload = load i32, i32* %varC, align 4
  %cmp = icmp eq i32 %retload, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i32 0, i32 0
  %idx = load i32, i32* %varC, align 4
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %end

notfound:                                         ; preds = %entry
  %bufptr = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i32 0, i32 0
  %callputs = call i32 @puts(i8* %bufptr)
  br label %end

end:                                              ; preds = %notfound, %found
  ret i32 0
}
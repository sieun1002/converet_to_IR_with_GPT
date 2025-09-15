; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/linearsearch.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr.elem0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr.elem0, align 16
  %arr.elem1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.elem1, align 4
  %arr.elem2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr.elem2, align 8
  %arr.elem3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr.elem3, align 4
  %arr.elem4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.elem4, align 16
  %call.search = call i32 @linear_search(i32* noundef nonnull %arr.elem0, i32 noundef 5, i32 noundef 4)
  %cmp.m1 = icmp eq i32 %call.search, -1
  br i1 %cmp.m1, label %notfound, label %found

found:                                            ; preds = %entry
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([27 x i8], [27 x i8]* @.str.found, i64 0, i64 0), i32 noundef %call.search)
  br label %done

notfound:                                         ; preds = %entry
  %call.puts = call i32 @puts(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0))
  br label %done

done:                                             ; preds = %notfound, %found
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @puts(i8* noundef)

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i.addr.0 = phi i32 [ 0, %entry ], [ %next, %inc ]
  %cmp.len = icmp slt i32 %i.addr.0, %len
  br i1 %cmp.len, label %body, label %common.ret

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i.addr.0 to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %common.ret, label %inc

inc:                                              ; preds = %body
  %next = add nuw nsw i32 %i.addr.0, 1
  br label %loop

common.ret:                                       ; preds = %loop, %body
  %common.ret.op = phi i32 [ %i.addr.0, %body ], [ -1, %loop ]
  ret i32 %common.ret.op
}

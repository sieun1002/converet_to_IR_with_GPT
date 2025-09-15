; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/bubblesort.ll'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.gep0, align 16
  %arr.gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.gep2, align 8
  %arr.gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.gep4, align 16
  %arr.gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.gep6, align 8
  %arr.gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.gep8, align 16
  %arr.gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.gep9, align 4
  call void @bubble_sort(i32* nonnull %arr.gep0, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %small = icmp ult i64 %n, 2
  br i1 %small, label %ret, label %outer_test

outer_test:                                       ; preds = %after_inner, %entry
  %bound = phi i64 [ %n, %entry ], [ %last, %after_inner ]
  %cond = icmp ugt i64 %bound, 1
  br i1 %cond, label %inner_header, label %ret

inner_header:                                     ; preds = %outer_test, %after_compare
  %i = phi i64 [ %i_next, %after_compare ], [ 1, %outer_test ]
  %last = phi i64 [ %last_next, %after_compare ], [ 0, %outer_test ]
  %cmpi = icmp ult i64 %i, %bound
  br i1 %cmpi, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_header
  %im1 = add i64 %i, -1
  %ptrL = getelementptr inbounds i32, i32* %arr, i64 %im1
  %ptrR = getelementptr inbounds i32, i32* %arr, i64 %i
  %valL = load i32, i32* %ptrL, align 4
  %valR = load i32, i32* %ptrR, align 4
  %gt = icmp sgt i32 %valL, %valR
  br i1 %gt, label %do_swap, label %after_compare

do_swap:                                          ; preds = %inner_body
  store i32 %valR, i32* %ptrL, align 4
  store i32 %valL, i32* %ptrR, align 4
  br label %after_compare

after_compare:                                    ; preds = %inner_body, %do_swap
  %last_next = phi i64 [ %i, %do_swap ], [ %last, %inner_body ]
  %i_next = add i64 %i, 1
  br label %inner_header

after_inner:                                      ; preds = %inner_header
  %zero = icmp eq i64 %last, 0
  br i1 %zero, label %ret, label %outer_test

ret:                                              ; preds = %after_inner, %outer_test, %entry
  ret void
}

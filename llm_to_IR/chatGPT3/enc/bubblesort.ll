; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10A0
; Intent: Perform a bubblesort on an array and output each element (confidence=0.85). Evidence: loop with element swapping, formatted printing
; Preconditions: The array `argv` contains integers. `argc` is the count of these integers.
; Postconditions: The array is sorted in non-decreasing order.

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %rsp = alloca i8*

  ; Load the initial state and prepare variables.
  %zero = icmp eq i32 %argc, 0
  br i1 %zero, label %end, label %init_loop

init_loop:
  %array_ptr = getelementptr inbounds i8*, i8** %argv, i32 0
  %cmp_idx = alloca i32
  store i32 0, i32* %cmp_idx
  br label %loop_cond

loop_cond:
  %i = load i32, i32* %cmp_idx
  %exceed = icmp sge i32 %i, %argc
  br i1 %exceed, label %print_sorted, label %inner_loop

inner_loop:
  %j_ptr = getelementptr inbounds i8*, i8** %argv, i32 %i
  %ai = load i8*, i8** %j_ptr
  %ai_int = ptrtoint i8* %ai to i64
  %j_next_ptr = getelementptr inbounds i8*, i8** %argv, i32 %i, i32 1
  %aj = load i8*, i8** %j_next_ptr
  %aj_int = ptrtoint i8* %aj to i64
  ; Compare ai and aj
  %cmp = icmp slt i64 %ai_int, %aj_int
  br i1 %cmp, label %check_next, label %swap

swap:
  ; Perform swap
  store i8* %aj, i8** %j_ptr
  store i8* %ai, i8** %j_next_ptr
  br label %check_next

check_next:
  ; Move to the next element
  %new_i = add i32 %i, 1
  store i32 %new_i, i32* %cmp_idx
  br label %loop_cond

print_sorted:
  ; Output sorted array
  %fmt = alloca i8*
  store i8* bitcast ([4 x i8]* @.str to i8*), i8** %fmt
  %i_ptr = alloca i32
  store i32 0, i32* %i_ptr
  br label %print_loop

print_loop:
  %i_val = load i32, i32* %i_ptr
  %end = icmp sge i32 %i_val, %argc
  br i1 %end, label %return, label %output_element

output_element:
  %ptr = getelementptr inbounds i8*, i8** %argv, i32 %i_val
  %val_i8 = load i8*, i8** %ptr
  %val_int = ptrtoint i8* %val_i8 to i32
  %formatted = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val_int)
  %next_i = add i32 %i_val, 1
  store i32 %next_i, i32* %i_ptr
  br label %print_loop

return:
  %ret_val = add i32 %argc, 0
  call i32 @putchar(i32 10) ; Newline
  ret i32 %ret_val

end:
  ret i32 0
}

@.str = private unnamed_addr constant [4 x i8] c"%d \00"
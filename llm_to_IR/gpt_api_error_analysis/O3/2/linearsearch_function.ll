; ModuleID = 'linear_search_module'
source_filename = "linear_search.c"

define i32 @linear_search(i32* %arr, i32 %n, i32 %key) {
entry:
  %cmp_n_le_zero = icmp sle i32 %n, 0
  br i1 %cmp_n_le_zero, label %not_found, label %loop_prep

loop_prep:
  %n64 = sext i32 %n to i64
  br label %loop_cmp

loop_cmp:
  %i = phi i64 [ 0, %loop_prep ], [ %i_next, %loop_inc ]
  %elem_ptr = getelementptr i32, i32* %arr, i64 %i
  %elem = load i32, i32* %elem_ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %found, label %loop_inc

loop_inc:
  %i_next = add i64 %i, 1
  %end_reached = icmp eq i64 %i_next, %n64
  br i1 %end_reached, label %not_found, label %loop_cmp

found:
  %ret_index = trunc i64 %i to i32
  ret i32 %ret_index

not_found:
  ret i32 -1
}
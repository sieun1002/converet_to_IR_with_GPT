; ModuleID = 'add_edge'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %flag) local_unnamed_addr nounwind {
entry:
  %cmp_i = icmp slt i32 %i, 0
  br i1 %cmp_i, label %ret, label %check_j

check_j:
  %cmp_j = icmp slt i32 %j, 0
  br i1 %cmp_j, label %ret, label %do_store

do_store:
  %base_i8 = bitcast i32* %base to i8*
  %i64 = sext i32 %i to i64
  %row_off = mul nsw i64 %i64, 400
  %row_ptr_i8 = getelementptr inbounds i8, i8* %base_i8, i64 %row_off
  %row_ptr_i32 = bitcast i8* %row_ptr_i8 to i32*
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr_i32, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %ret, label %do_sym

do_sym:
  %base2_i8 = bitcast i32* %base to i8*
  %j64_2 = sext i32 %j to i64
  %row_off2 = mul nsw i64 %j64_2, 400
  %row_ptr2_i8 = getelementptr inbounds i8, i8* %base2_i8, i64 %row_off2
  %row_ptr2_i32 = bitcast i8* %row_ptr2_i8 to i32*
  %i64_2 = sext i32 %i to i64
  %elem_ptr2 = getelementptr inbounds i32, i32* %row_ptr2_i32, i64 %i64_2
  store i32 %val, i32* %elem_ptr2, align 4
  br label %ret

ret:
  ret void
}
; ModuleID = 'add_edge'
source_filename = "add_edge.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @add_edge(i32* %base, i32 %i, i32 %j, i32 %w, i32 %flag) {
entry:
  %i.neg = icmp slt i32 %i, 0
  %j.neg = icmp slt i32 %j, 0
  %any.neg = or i1 %i.neg, %j.neg
  br i1 %any.neg, label %ret, label %store

store:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %base.i8 = bitcast i32* %base to i8*
  %row.off = mul i64 %i64, 400
  %row.ptr.i8 = getelementptr i8, i8* %base.i8, i64 %row.off
  %row.ptr = bitcast i8* %row.ptr.i8 to i32*
  %cell.ptr = getelementptr i32, i32* %row.ptr, i64 %j64
  store i32 %w, i32* %cell.ptr, align 4
  %flag.zero = icmp eq i32 %flag, 0
  br i1 %flag.zero, label %ret, label %sym

sym:
  %row.off2 = mul i64 %j64, 400
  %row.ptr.i8.2 = getelementptr i8, i8* %base.i8, i64 %row.off2
  %row.ptr2 = bitcast i8* %row.ptr.i8.2 to i32*
  %cell.ptr2 = getelementptr i32, i32* %row.ptr2, i64 %i64
  store i32 %w, i32* %cell.ptr2, align 4
  br label %ret

ret:
  ret void
}
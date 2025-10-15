; ModuleID = 'insertion_sort_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @insertion_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp0 = icmp sle i64 %n, 1
  br i1 %cmp0, label %ret, label %for.i

for.i:                                            ; preds = %entry, %inner.done
  %i0 = phi i64 [ 1, %entry ], [ %i.next, %inner.done ]
  br label %inner.start

inner.start:                                      ; preds = %for.i
  %gep_i = getelementptr inbounds i32, i32* %arr, i64 %i0
  %key = load i32, i32* %gep_i, align 4
  %j0 = add i64 %i0, -1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %inner.start
  %j.phi = phi i64 [ %j0, %inner.start ], [ %j.dec, %while.body ]
  %cond1 = icmp sge i64 %j.phi, 0
  br i1 %cond1, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %gep_j = getelementptr inbounds i32, i32* %arr, i64 %j.phi
  %aj = load i32, i32* %gep_j, align 4
  %cmp = icmp sgt i32 %aj, %key
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %jp1 = add i64 %j.phi, 1
  %gep_jp1 = getelementptr inbounds i32, i32* %arr, i64 %jp1
  store i32 %aj, i32* %gep_jp1, align 4
  %j.dec = add i64 %j.phi, -1
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.end = phi i64 [ %j.phi, %while.cond ], [ %j.phi, %while.check ]
  %jp1.end = add i64 %j.end, 1
  %gep_jp1.end = getelementptr inbounds i32, i32* %arr, i64 %jp1.end
  store i32 %key, i32* %gep_jp1.end, align 4
  br label %inner.done

inner.done:                                       ; preds = %while.end
  %i.next = add i64 %i0, 1
  %i.cont = icmp slt i64 %i.next, %n
  br i1 %i.cont, label %for.i, label %ret

ret:                                              ; preds = %inner.done, %entry
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  call void @__main()
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %idx9, align 4
  store i64 10, i64* %len, align 8
  %nload0 = load i64, i64* %len, align 8
  call void @insertion_sort(i32* %arr0, i64 %nload0)
  br label %loop

loop:                                             ; preds = %entry, %loop.inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %ncur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %ncur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  br label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add i64 %i, 1
  br label %loop

loop.end:                                         ; preds = %loop
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}
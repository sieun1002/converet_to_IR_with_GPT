; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global [16 x i8]
@xmmword_140004020 = external global [16 x i8]
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

define void @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  %limit = alloca i32, align 4
  %last = alloca i32, align 4
  %i = alloca i32, align 4

  call void @sub_140001520()

  %arr_vec0_ptr = bitcast [10 x i32]* %arr to <4 x i32>*
  %g1_vec_ptr = bitcast [16 x i8]* @xmmword_140004010 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* %g1_vec_ptr, align 1
  store <4 x i32> %v1, <4 x i32>* %arr_vec0_ptr, align 1

  %arr_4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr_vec1_ptr = bitcast i32* %arr_4 to <4 x i32>*
  %g2_vec_ptr = bitcast [16 x i8]* @xmmword_140004020 to <4 x i32>*
  %v2 = load <4 x i32>, <4 x i32>* %g2_vec_ptr, align 1
  store <4 x i32> %v2, <4 x i32>* %arr_vec1_ptr, align 1

  %arr_8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr_8, align 4

  store i32 10, i32* %limit, align 4
  br label %outer.loop

outer.loop:                                      ; preds = %update.limit, %entry
  store i32 0, i32* %last, align 4
  store i32 1, i32* %i, align 4
  br label %inner.cond

inner.cond:                                      ; preds = %inc.i, %outer.loop
  %i.val = load i32, i32* %i, align 4
  %lim.val = load i32, i32* %limit, align 4
  %cmp.ne = icmp ne i32 %i.val, %lim.val
  br i1 %cmp.ne, label %inner.body, label %inner.end

inner.body:                                      ; preds = %inner.cond
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %i.m1 = add i32 %i.val, -1
  %i.m1.i64 = sext i32 %i.m1 to i64
  %a.ptr = getelementptr inbounds i32, i32* %base, i64 %i.m1.i64
  %a = load i32, i32* %a.ptr, align 4
  %i.i64 = sext i32 %i.val to i64
  %b.ptr = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %b = load i32, i32* %b.ptr, align 4
  %b.lt.a = icmp slt i32 %b, %a
  br i1 %b.lt.a, label %do.swap, label %no.swap

do.swap:                                         ; preds = %inner.body
  store i32 %b, i32* %a.ptr, align 4
  store i32 %a, i32* %b.ptr, align 4
  store i32 %i.val, i32* %last, align 4
  br label %inc.i

no.swap:                                         ; preds = %inner.body
  br label %inc.i

inc.i:                                           ; preds = %no.swap, %do.swap
  %i.cur = load i32, i32* %i, align 4
  %i.next = add i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %inner.cond

inner.end:                                       ; preds = %inner.cond
  %last.val = load i32, i32* %last, align 4
  %le.one = icmp sle i32 %last.val, 1
  br i1 %le.one, label %after.sort, label %update.limit

update.limit:                                    ; preds = %inner.end
  store i32 %last.val, i32* %limit, align 4
  br label %outer.loop

after.sort:                                      ; preds = %inner.end
  %base2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %first = load i32, i32* %base2, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %first)
  ret void
}
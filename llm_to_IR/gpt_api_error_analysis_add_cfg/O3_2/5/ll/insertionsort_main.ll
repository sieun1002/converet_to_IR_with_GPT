; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external constant [4 x i8], align 1
@unk_2008 = external constant [2 x i8], align 1
@__stack_chk_guard = external local_unnamed_addr global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
entry:
  %arr = alloca [8 x i32], align 16

  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16

  %p0 = bitcast [8 x i32]* %arr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %p0, align 16

  %p1.i32 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 4
  %p1 = bitcast i32* %p1.i32 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %p1, align 16

  br label %outer

outer:
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp slt i32 %i, 8
  br i1 %cmp, label %outer.body, label %print

outer.body:
  %i64 = zext i32 %i to i64
  %idxptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %i64
  %key = load i32, i32* %idxptr, align 4
  %j.init = add i32 %i, -1
  br label %inner

inner:
  %j = phi i32 [ %j.init, %outer.body ], [ %j2, %shift ]
  %j.ge0 = icmp sge i32 %j, 0
  br i1 %j.ge0, label %inner.load, label %insert

inner.load:
  %j64 = zext i32 %j to i64
  %jptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %j64
  %aj = load i32, i32* %jptr, align 4
  %gt = icmp sgt i32 %aj, %key
  br i1 %gt, label %shift, label %insert

shift:
  %jp1 = add i32 %j, 1
  %jp1.64 = zext i32 %jp1 to i64
  %jp1ptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %jp1.64
  store i32 %aj, i32* %jp1ptr, align 4
  %j2 = add i32 %j, -1
  br label %inner

insert:
  %j1 = phi i32 [ %j, %inner ], [ %j, %inner.load ]
  %j1p1 = add i32 %j1, 1
  %j1p1.64 = zext i32 %j1p1 to i64
  %j1ptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %j1p1.64
  store i32 %key, i32* %j1ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  br label %outer

print:
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  br label %ploop

ploop:
  %k = phi i32 [ 0, %print ], [ %k.next, %ploop.inc ]
  %k.cmp = icmp slt i32 %k, 8
  br i1 %k.cmp, label %ploop.body, label %done

ploop.body:
  %k64 = zext i32 %k to i64
  %eptr = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 %k64
  %eval = load i32, i32* %eptr, align 4
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %eval)
  br label %ploop.inc

ploop.inc:
  %k.next = add i32 %k, 1
  br label %ploop

done:
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0
}
; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@.str.Address_p_has_no_image_section = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8* %rcx)
declare i8* @sub_140002390()
declare void @sub_140612B3A(i8* %rcx, i8* %rdx, i32 %r8d)
declare void @sub_140001700(i8* %rcx, i8* %rdx)

define void @sub_140001760(i8* %rcx) local_unnamed_addr {
entry:
  %var48 = alloca [48 x i8], align 8
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %cmp.sgt = icmp sgt i32 %count.load, 0
  br i1 %cmp.sgt, label %loop.init, label %create.with.count0

loop.init:
  %base.load = load i8*, i8** @qword_1400070A8, align 8
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %i.sext = sext i32 %i to i64
  %offset.bytes = mul nsw i64 %i.sext, 40
  %entry.base = getelementptr inbounds i8, i8* %base.load, i64 %offset.bytes
  %field.18.addr.i8 = getelementptr inbounds i8, i8* %entry.base, i64 24
  %field.18.addr = bitcast i8* %field.18.addr.i8 to i8**
  %start.ptr = load i8*, i8** %field.18.addr, align 8
  %cmp.lo = icmp ult i8* %rcx, %start.ptr
  br i1 %cmp.lo, label %loop.inc, label %check.end

check.end:
  %field.20.addr.i8 = getelementptr inbounds i8, i8* %entry.base, i64 32
  %field.20.addr = bitcast i8* %field.20.addr.i8 to i8**
  %desc.ptr = load i8*, i8** %field.20.addr, align 8
  %len.addr.i8 = getelementptr inbounds i8, i8* %desc.ptr, i64 8
  %len.addr = bitcast i8* %len.addr.i8 to i32*
  %len32 = load i32, i32* %len.addr, align 4
  %len64 = zext i32 %len32 to i64
  %end.ptr = getelementptr inbounds i8, i8* %start.ptr, i64 %len64
  %cmp.inrange = icmp ult i8* %rcx, %end.ptr
  br i1 %cmp.inrange, label %return, label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i, 1
  %cmp.cont = icmp slt i32 %i.next, %count.load
  br i1 %cmp.cont, label %loop, label %create

create.with.count0:
  br label %create

create:
  %count.phi = phi i32 [ 0, %create.with.count0 ], [ %count.load, %loop.inc ]
  %call.sub_140002250 = call i8* @sub_140002250(i8* %rcx)
  %notnull = icmp ne i8* %call.sub_140002250, null
  br i1 %notnull, label %create.cont, label %error

error:
  %str.gep = getelementptr inbounds [32 x i8], [32 x i8]* @.str.Address_p_has_no_image_section, i64 0, i64 0
  call void @sub_140001700(i8* %str.gep, i8* %rcx)
  br label %return

create.cont:
  %base.reload1 = load i8*, i8** @qword_1400070A8, align 8
  %count.phi.sext = sext i32 %count.phi to i64
  %mul5 = mul nsw i64 %count.phi.sext, 5
  %offset.bytes.40 = shl i64 %mul5, 3
  %entry.base.store = getelementptr inbounds i8, i8* %base.reload1, i64 %offset.bytes.40
  %field.20.addr.store.i8 = getelementptr inbounds i8, i8* %entry.base.store, i64 32
  %field.20.addr.store = bitcast i8* %field.20.addr.store.i8 to i8**
  store i8* %call.sub_140002250, i8** %field.20.addr.store, align 8
  %field.00.addr = bitcast i8* %entry.base.store to i32*
  store i32 0, i32* %field.00.addr, align 4
  %call.sub_140002390 = call i8* @sub_140002390()
  %len.addr2.i8 = getelementptr inbounds i8, i8* %call.sub_140002250, i64 12
  %len.addr2 = bitcast i8* %len.addr2.i8 to i32*
  %len32b = load i32, i32* %len.addr2, align 4
  %len64b = zext i32 %len32b to i64
  %rcx.arg = getelementptr inbounds i8, i8* %call.sub_140002390, i64 %len64b
  %base.reload2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.base.store2 = getelementptr inbounds i8, i8* %base.reload2, i64 %offset.bytes.40
  %field.18.addr.store.i8 = getelementptr inbounds i8, i8* %entry.base.store2, i64 24
  %field.18.addr.store = bitcast i8* %field.18.addr.store.i8 to i8**
  store i8* %rcx.arg, i8** %field.18.addr.store, align 8
  %var48.gep = getelementptr inbounds [48 x i8], [48 x i8]* %var48, i64 0, i64 0
  call void @sub_140612B3A(i8* %rcx.arg, i8* %var48.gep, i32 48)
  br label %return

return:
  ret void
}
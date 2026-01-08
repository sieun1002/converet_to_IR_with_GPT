; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32, align 4
@qword_1400070E0 = external dso_local global i8*, align 8
@unk_140007100 = external dso_local global i8, align 1

declare dso_local void @sub_140001E80()
declare dso_local void @sub_140002120()
declare dso_local void @loc_1400027F0(i8* noundef)
declare dso_local i32 @sub_1400FEC71(i8* noundef)
declare dso_local void @loc_1400E441D(i8* noundef)

define dso_local i32 @sub_140002010(i32 %arg1, i32 %arg2) local_unnamed_addr {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %arg2, 2
  br i1 %cmp2, label %block_d8, label %after_cmp2

after_cmp2:
  %ugt2 = icmp ugt i32 %arg2, 2
  br i1 %ugt2, label %block_048, label %block_01f

block_01f:
  %iszero = icmp eq i32 %arg2, 0
  br i1 %iszero, label %block_060, label %block_023

block_023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1zero = icmp eq i32 %g1, 0
  br i1 %g1zero, label %block_100, label %block_031

block_031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

block_048:
  %neq3 = icmp ne i32 %arg2, 3
  br i1 %neq3, label %ret1, label %block_04d

block_04d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2zero = icmp eq i32 %g2, 0
  br i1 %g2zero, label %ret1, label %block_057

block_057:
  call void @sub_140001E80()
  br label %block_060

block_060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3nonzero = icmp ne i32 %g3, 0
  br i1 %g3nonzero, label %block_0f0, label %block_06e

block_06e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %eq1 = icmp eq i32 %g4, 1
  br i1 %eq1, label %block_079, label %ret1

block_079:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %isnullh = icmp eq i8* %head, null
  br i1 %isnullh, label %block_0ab, label %loop_090

loop_090:
  %cur = phi i8* [ %head, %block_079 ], [ %next_reload, %loop_090 ]
  %next_ptr = getelementptr i8, i8* %cur, i64 16
  %next_ptr_ptr = bitcast i8* %next_ptr to i8**
  %next = load i8*, i8** %next_ptr_ptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @loc_1400027F0(i8* %cur)
  %next_reload = load i8*, i8** %var10, align 8
  %cond = icmp ne i8* %next_reload, null
  br i1 %cond, label %loop_090, label %block_0ab

block_0ab:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call i32 @sub_1400FEC71(i8* @unk_140007100)
  br label %block_d8

block_0f0:
  call void @sub_140001E80()
  br label %block_100

block_100:
  call void @loc_1400E441D(i8* @unk_140007100)
  br label %block_031

block_d8:
  call void @sub_140002120()
  br label %ret1

ret1:
  ret i32 1
}
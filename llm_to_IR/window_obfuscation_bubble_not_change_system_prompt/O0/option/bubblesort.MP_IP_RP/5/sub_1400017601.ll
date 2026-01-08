; ModuleID = 'sub_140001760'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8* noundef)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8* noundef, i8* noundef, i32 noundef)
declare void @sub_140001700(i8* noundef, i8* noundef)

define void @sub_140001760(i8* %arg) {
entry:
  %buf = alloca [48 x i8], align 16
  %count32 = load i32, i32* @dword_1400070A4
  %count_pos = icmp sgt i32 %count32, 0
  br i1 %count_pos, label %loop.init, label %createCase

loop.init:
  %base0 = load i8*, i8** @qword_1400070A8
  %startFieldBase = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %nexti, %loop.inc ]
  %mul40 = mul i32 %i, 40
  %mul40_64 = sext i32 %mul40 to i64
  %entryStartFieldPtr_i8 = getelementptr i8, i8* %startFieldBase, i64 %mul40_64
  %entryStartFieldPtr = bitcast i8* %entryStartFieldPtr_i8 to i8**
  %startPtr = load i8*, i8** %entryStartFieldPtr, align 8
  %argInt = ptrtoint i8* %arg to i64
  %startInt = ptrtoint i8* %startPtr to i64
  %arg_lt_start = icmp ult i64 %argInt, %startInt
  br i1 %arg_lt_start, label %loop.inc, label %checkEnd

checkEnd:
  %ptrFieldAddr_i8 = getelementptr i8, i8* %entryStartFieldPtr_i8, i64 8
  %ptrFieldAddr = bitcast i8* %ptrFieldAddr_i8 to i8**
  %objPtr = load i8*, i8** %ptrFieldAddr, align 8
  %lenAddr_i8 = getelementptr i8, i8* %objPtr, i64 8
  %lenAddr = bitcast i8* %lenAddr_i8 to i32*
  %len32 = load i32, i32* %lenAddr, align 4
  %len64 = zext i32 %len32 to i64
  %endInt = add i64 %startInt, %len64
  %inRange = icmp ult i64 %argInt, %endInt
  br i1 %inRange, label %return, label %loop.inc

loop.inc:
  %nexti = add i32 %i, 1
  %cont = icmp ne i32 %nexti, %count32
  br i1 %cont, label %loop, label %createCase

createCase:
  %info = call i8* @sub_140002250(i8* noundef %arg)
  %isnull = icmp eq i8* %info, null
  br i1 %isnull, label %error, label %fill

fill:
  %base1 = load i8*, i8** @qword_1400070A8
  %idxsel = select i1 %count_pos, i32 %count32, i32 0
  %idxsel64 = sext i32 %idxsel to i64
  %off_bytes = mul i64 %idxsel64, 40
  %entryPtr_i8 = getelementptr i8, i8* %base1, i64 %off_bytes
  %entry_ptr20_i8 = getelementptr i8, i8* %entryPtr_i8, i64 32
  %entry_ptr20 = bitcast i8* %entry_ptr20_i8 to i8**
  store i8* %info, i8** %entry_ptr20, align 8
  %entry0_i32 = bitcast i8* %entryPtr_i8 to i32*
  store i32 0, i32* %entry0_i32, align 4
  %baseRax = call i8* @sub_140002390()
  %info_plus_c_i8 = getelementptr i8, i8* %info, i64 12
  %info_plus_c = bitcast i8* %info_plus_c_i8 to i32*
  %off_c32 = load i32, i32* %info_plus_c, align 4
  %off_c64 = zext i32 %off_c32 to i64
  %rcx_ptr = getelementptr i8, i8* %baseRax, i64 %off_c64
  %entry_ptr18_i8 = getelementptr i8, i8* %entryPtr_i8, i64 24
  %entry_ptr18 = bitcast i8* %entry_ptr18_i8 to i8**
  store i8* %rcx_ptr, i8** %entry_ptr18, align 8
  %buf0 = getelementptr [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  call void @sub_14000CFBC(i8* noundef %rcx_ptr, i8* noundef %buf0, i32 noundef 48)
  ret void

error:
  %str = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* noundef %str, i8* noundef %arg)
  ret void

return:
  ret void
}
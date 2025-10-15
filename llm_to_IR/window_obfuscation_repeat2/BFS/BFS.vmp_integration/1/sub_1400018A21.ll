; ModuleID = 'module'
source_filename = "sub_1400018A2"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1403D73E2()
declare void @loc_1400E50BF()
declare void @loc_140042893()
declare void @loc_140128A2C()

define void @sub_1400018A2(i8* %rsi) {
entry:
  %arg_8 = alloca i32, align 4
  %shadow = alloca [4 x i64], align 16
  store i32 1655291705, i32* %arg_8, align 4
  %arg8_byte = bitcast i32* %arg_8 to i8*
  store i8 0, i8* %arg8_byte, align 1
  %v1 = load i32, i32* %arg_8, align 4
  %andv = and i32 %v1, 1570603275
  %cmpz = icmp eq i32 %andv, 0
  call void @sub_1403D73E2()
  call void @loc_1400E50BF()
  call void @loc_140042893()
  %shadow_gep0 = getelementptr inbounds [4 x i64], [4 x i64]* %shadow, i64 0, i64 0
  store i64 1329160658, i64* %shadow_gep0, align 8
  call void @loc_140128A2C()
  %ptr = getelementptr i8, i8* %rsi, i64 -652316784
  %ld = load volatile i8, i8* %ptr, align 1
  %ebp = alloca i32, align 4
  store i32 0, i32* %ebp, align 4
  %ebp_val = load i32, i32* %ebp, align 4
  %cmp = icmp eq i32 %ebp_val, %ebp_val
  ret void
}
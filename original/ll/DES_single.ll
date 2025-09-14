; ModuleID = 'DES_single_func.c'
source_filename = "DES_single_func.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@des_encrypt.IP = internal constant [64 x i32] [i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2, i32 60, i32 52, i32 44, i32 36, i32 28, i32 20, i32 12, i32 4, i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6, i32 64, i32 56, i32 48, i32 40, i32 32, i32 24, i32 16, i32 8, i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9, i32 1, i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3, i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5, i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7], align 16, !dbg !0
@des_encrypt.FP = internal constant [64 x i32] [i32 40, i32 8, i32 48, i32 16, i32 56, i32 24, i32 64, i32 32, i32 39, i32 7, i32 47, i32 15, i32 55, i32 23, i32 63, i32 31, i32 38, i32 6, i32 46, i32 14, i32 54, i32 22, i32 62, i32 30, i32 37, i32 5, i32 45, i32 13, i32 53, i32 21, i32 61, i32 29, i32 36, i32 4, i32 44, i32 12, i32 52, i32 20, i32 60, i32 28, i32 35, i32 3, i32 43, i32 11, i32 51, i32 19, i32 59, i32 27, i32 34, i32 2, i32 42, i32 10, i32 50, i32 18, i32 58, i32 26, i32 33, i32 1, i32 41, i32 9, i32 49, i32 17, i32 57, i32 25], align 16, !dbg !18
@des_encrypt.E = internal constant [48 x i32] [i32 32, i32 1, i32 2, i32 3, i32 4, i32 5, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 28, i32 29, i32 30, i32 31, i32 32, i32 1], align 16, !dbg !25
@des_encrypt.P = internal constant [32 x i32] [i32 16, i32 7, i32 20, i32 21, i32 29, i32 12, i32 28, i32 17, i32 1, i32 15, i32 23, i32 26, i32 5, i32 18, i32 31, i32 10, i32 2, i32 8, i32 24, i32 14, i32 32, i32 27, i32 3, i32 9, i32 19, i32 13, i32 30, i32 6, i32 22, i32 11, i32 4, i32 25], align 16, !dbg !30
@des_encrypt.PC1 = internal constant [56 x i32] [i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9, i32 1, i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2, i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3, i32 60, i32 52, i32 44, i32 36, i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7, i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6, i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5, i32 28, i32 20, i32 12, i32 4], align 16, !dbg !35
@des_encrypt.PC2 = internal constant [48 x i32] [i32 14, i32 17, i32 11, i32 24, i32 1, i32 5, i32 3, i32 28, i32 15, i32 6, i32 21, i32 10, i32 23, i32 19, i32 12, i32 4, i32 26, i32 8, i32 16, i32 7, i32 27, i32 20, i32 13, i32 2, i32 41, i32 52, i32 31, i32 37, i32 47, i32 55, i32 30, i32 40, i32 51, i32 45, i32 33, i32 48, i32 44, i32 49, i32 39, i32 56, i32 34, i32 53, i32 46, i32 42, i32 50, i32 36, i32 29, i32 32], align 16, !dbg !40
@des_encrypt.SHIFTS = internal constant [16 x i32] [i32 1, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1], align 16, !dbg !42
@des_encrypt.SBOX = internal constant [8 x [64 x i8]] [[64 x i8] c"\0E\04\0D\01\02\0F\0B\08\03\0A\06\0C\05\09\00\07\00\0F\07\04\0E\02\0D\01\0A\06\0C\0B\09\05\03\08\04\01\0E\08\0D\06\02\0B\0F\0C\09\07\03\0A\05\00\0F\0C\08\02\04\09\01\07\05\0B\03\0E\0A\00\06\0D", [64 x i8] c"\0F\01\08\0E\06\0B\03\04\09\07\02\0D\0C\00\05\0A\03\0D\04\07\0F\02\08\0E\0C\00\01\0A\06\09\0B\05\00\0E\07\0B\0A\04\0D\01\05\08\0C\06\09\03\02\0F\0D\08\0A\01\03\0F\04\02\0B\06\07\0C\00\05\0E\09", [64 x i8] c"\0A\00\09\0E\06\03\0F\05\01\0D\0C\07\0B\04\02\08\0D\07\00\09\03\04\06\0A\02\08\05\0E\0C\0B\0F\01\0D\06\04\09\08\0F\03\00\0B\01\02\0C\05\0A\0E\07\01\0A\0D\00\06\09\08\07\04\0F\0E\03\0B\05\02\0C", [64 x i8] c"\07\0D\0E\03\00\06\09\0A\01\02\08\05\0B\0C\04\0F\0D\08\0B\05\06\0F\00\03\04\07\02\0C\01\0A\0E\09\0A\06\09\00\0C\0B\07\0D\0F\01\03\0E\05\02\08\04\03\0F\00\06\0A\01\0D\08\09\04\05\0B\0C\07\02\0E", [64 x i8] c"\02\0C\04\01\07\0A\0B\06\08\05\03\0F\0D\00\0E\09\0E\0B\02\0C\04\07\0D\01\05\00\0F\0A\03\09\08\06\04\02\01\0B\0A\0D\07\08\0F\09\0C\05\06\03\00\0E\0B\08\0C\07\01\0E\02\0D\06\0F\00\09\0A\04\05\03", [64 x i8] c"\0C\01\0A\0F\09\02\06\08\00\0D\03\04\0E\07\05\0B\0A\0F\04\02\07\0C\09\05\06\01\0D\0E\00\0B\03\08\09\0E\0F\05\02\08\0C\03\07\00\04\0A\01\0D\0B\06\04\03\02\0C\09\05\0F\0A\0B\0E\01\07\06\00\08\0D", [64 x i8] c"\04\0B\02\0E\0F\00\08\0D\03\0C\09\07\05\0A\06\01\0D\00\0B\07\04\09\01\0A\0E\03\05\0C\02\0F\08\06\01\04\0B\0D\0C\03\07\0E\0A\0F\06\08\00\05\09\02\06\0B\0D\08\01\04\0A\07\09\05\00\0F\0E\02\03\0C", [64 x i8] c"\0D\02\08\04\06\0F\0B\01\0A\09\03\0E\05\00\0C\07\01\0F\0D\08\0A\03\07\04\0C\05\06\0B\00\0E\09\02\07\0B\04\01\09\0C\0E\02\00\06\0A\0D\0F\03\05\08\02\01\0E\07\04\0A\08\0D\0F\0C\09\00\03\05\06\0B"], align 16, !dbg !47
@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"Ciphertext: 85E813540F0AB405\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @des_encrypt(i64 noundef %plaintext, i64 noundef %key64) #0 !dbg !2 {
entry:
  %plaintext.addr = alloca i64, align 8
  %key64.addr = alloca i64, align 8
  %k56 = alloca i64, align 8
  %i = alloca i32, align 4
  %src = alloca i32, align 4
  %C = alloca i32, align 4
  %D = alloca i32, align 4
  %subkeys = alloca [16 x i64], align 16
  %r = alloca i32, align 4
  %s = alloca i32, align 4
  %CD = alloca i64, align 8
  %k48 = alloca i64, align 8
  %i25 = alloca i32, align 4
  %src30 = alloca i32, align 4
  %ip = alloca i64, align 8
  %i47 = alloca i32, align 4
  %src52 = alloca i32, align 4
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  %r68 = alloca i32, align 4
  %ER = alloca i64, align 8
  %i73 = alloca i32, align 4
  %src78 = alloca i32, align 4
  %X = alloca i64, align 8
  %SOUT = alloca i32, align 4
  %b = alloca i32, align 4
  %shift = alloca i32, align 4
  %chunk = alloca i8, align 1
  %row = alloca i32, align 4
  %col = alloca i32, align 4
  %s110 = alloca i8, align 1
  %F = alloca i32, align 4
  %i122 = alloca i32, align 4
  %src127 = alloca i32, align 4
  %newL = alloca i32, align 4
  %newR = alloca i32, align 4
  %preout = alloca i64, align 8
  %ct = alloca i64, align 8
  %i146 = alloca i32, align 4
  %src151 = alloca i32, align 4
  store i64 %plaintext, i64* %plaintext.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %plaintext.addr, metadata !65, metadata !DIExpression()), !dbg !66
  store i64 %key64, i64* %key64.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %key64.addr, metadata !67, metadata !DIExpression()), !dbg !68
  call void @llvm.dbg.declare(metadata i64* %k56, metadata !69, metadata !DIExpression()), !dbg !70
  store i64 0, i64* %k56, align 8, !dbg !70
  call void @llvm.dbg.declare(metadata i32* %i, metadata !71, metadata !DIExpression()), !dbg !73
  store i32 0, i32* %i, align 4, !dbg !73
  br label %for.cond, !dbg !74

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !75
  %cmp = icmp slt i32 %0, 56, !dbg !77
  br i1 %cmp, label %for.body, label %for.end, !dbg !78

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %src, metadata !79, metadata !DIExpression()), !dbg !81
  %1 = load i32, i32* %i, align 4, !dbg !82
  %idxprom = sext i32 %1 to i64, !dbg !83
  %arrayidx = getelementptr inbounds [56 x i32], [56 x i32]* @des_encrypt.PC1, i64 0, i64 %idxprom, !dbg !83
  %2 = load i32, i32* %arrayidx, align 4, !dbg !83
  store i32 %2, i32* %src, align 4, !dbg !81
  %3 = load i64, i64* %k56, align 8, !dbg !84
  %shl = shl i64 %3, 1, !dbg !85
  %4 = load i64, i64* %key64.addr, align 8, !dbg !86
  %5 = load i32, i32* %src, align 4, !dbg !87
  %sub = sub nsw i32 64, %5, !dbg !88
  %sh_prom = zext i32 %sub to i64, !dbg !89
  %shr = lshr i64 %4, %sh_prom, !dbg !89
  %and = and i64 %shr, 1, !dbg !90
  %or = or i64 %shl, %and, !dbg !91
  store i64 %or, i64* %k56, align 8, !dbg !92
  br label %for.inc, !dbg !93

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !94
  %inc = add nsw i32 %6, 1, !dbg !94
  store i32 %inc, i32* %i, align 4, !dbg !94
  br label %for.cond, !dbg !95, !llvm.loop !96

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %C, metadata !99, metadata !DIExpression()), !dbg !100
  %7 = load i64, i64* %k56, align 8, !dbg !101
  %shr1 = lshr i64 %7, 28, !dbg !102
  %and2 = and i64 %shr1, 268435455, !dbg !103
  %conv = trunc i64 %and2 to i32, !dbg !104
  store i32 %conv, i32* %C, align 4, !dbg !100
  call void @llvm.dbg.declare(metadata i32* %D, metadata !105, metadata !DIExpression()), !dbg !106
  %8 = load i64, i64* %k56, align 8, !dbg !107
  %and3 = and i64 %8, 268435455, !dbg !108
  %conv4 = trunc i64 %and3 to i32, !dbg !109
  store i32 %conv4, i32* %D, align 4, !dbg !106
  call void @llvm.dbg.declare(metadata [16 x i64]* %subkeys, metadata !110, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.declare(metadata i32* %r, metadata !113, metadata !DIExpression()), !dbg !115
  store i32 0, i32* %r, align 4, !dbg !115
  br label %for.cond5, !dbg !116

for.cond5:                                        ; preds = %for.inc44, %for.end
  %9 = load i32, i32* %r, align 4, !dbg !117
  %cmp6 = icmp slt i32 %9, 16, !dbg !119
  br i1 %cmp6, label %for.body8, label %for.end46, !dbg !120

for.body8:                                        ; preds = %for.cond5
  call void @llvm.dbg.declare(metadata i32* %s, metadata !121, metadata !DIExpression()), !dbg !123
  %10 = load i32, i32* %r, align 4, !dbg !124
  %idxprom9 = sext i32 %10 to i64, !dbg !125
  %arrayidx10 = getelementptr inbounds [16 x i32], [16 x i32]* @des_encrypt.SHIFTS, i64 0, i64 %idxprom9, !dbg !125
  %11 = load i32, i32* %arrayidx10, align 4, !dbg !125
  store i32 %11, i32* %s, align 4, !dbg !123
  %12 = load i32, i32* %C, align 4, !dbg !126
  %13 = load i32, i32* %s, align 4, !dbg !127
  %shl11 = shl i32 %12, %13, !dbg !128
  %14 = load i32, i32* %C, align 4, !dbg !129
  %15 = load i32, i32* %s, align 4, !dbg !130
  %sub12 = sub nsw i32 28, %15, !dbg !131
  %shr13 = lshr i32 %14, %sub12, !dbg !132
  %or14 = or i32 %shl11, %shr13, !dbg !133
  %and15 = and i32 %or14, 268435455, !dbg !134
  store i32 %and15, i32* %C, align 4, !dbg !135
  %16 = load i32, i32* %D, align 4, !dbg !136
  %17 = load i32, i32* %s, align 4, !dbg !137
  %shl16 = shl i32 %16, %17, !dbg !138
  %18 = load i32, i32* %D, align 4, !dbg !139
  %19 = load i32, i32* %s, align 4, !dbg !140
  %sub17 = sub nsw i32 28, %19, !dbg !141
  %shr18 = lshr i32 %18, %sub17, !dbg !142
  %or19 = or i32 %shl16, %shr18, !dbg !143
  %and20 = and i32 %or19, 268435455, !dbg !144
  store i32 %and20, i32* %D, align 4, !dbg !145
  call void @llvm.dbg.declare(metadata i64* %CD, metadata !146, metadata !DIExpression()), !dbg !147
  %20 = load i32, i32* %C, align 4, !dbg !148
  %conv21 = zext i32 %20 to i64, !dbg !149
  %shl22 = shl i64 %conv21, 28, !dbg !150
  %21 = load i32, i32* %D, align 4, !dbg !151
  %conv23 = zext i32 %21 to i64, !dbg !152
  %or24 = or i64 %shl22, %conv23, !dbg !153
  store i64 %or24, i64* %CD, align 8, !dbg !147
  call void @llvm.dbg.declare(metadata i64* %k48, metadata !154, metadata !DIExpression()), !dbg !155
  store i64 0, i64* %k48, align 8, !dbg !155
  call void @llvm.dbg.declare(metadata i32* %i25, metadata !156, metadata !DIExpression()), !dbg !158
  store i32 0, i32* %i25, align 4, !dbg !158
  br label %for.cond26, !dbg !159

for.cond26:                                       ; preds = %for.inc39, %for.body8
  %22 = load i32, i32* %i25, align 4, !dbg !160
  %cmp27 = icmp slt i32 %22, 48, !dbg !162
  br i1 %cmp27, label %for.body29, label %for.end41, !dbg !163

for.body29:                                       ; preds = %for.cond26
  call void @llvm.dbg.declare(metadata i32* %src30, metadata !164, metadata !DIExpression()), !dbg !166
  %23 = load i32, i32* %i25, align 4, !dbg !167
  %idxprom31 = sext i32 %23 to i64, !dbg !168
  %arrayidx32 = getelementptr inbounds [48 x i32], [48 x i32]* @des_encrypt.PC2, i64 0, i64 %idxprom31, !dbg !168
  %24 = load i32, i32* %arrayidx32, align 4, !dbg !168
  store i32 %24, i32* %src30, align 4, !dbg !166
  %25 = load i64, i64* %k48, align 8, !dbg !169
  %shl33 = shl i64 %25, 1, !dbg !170
  %26 = load i64, i64* %CD, align 8, !dbg !171
  %27 = load i32, i32* %src30, align 4, !dbg !172
  %sub34 = sub nsw i32 56, %27, !dbg !173
  %sh_prom35 = zext i32 %sub34 to i64, !dbg !174
  %shr36 = lshr i64 %26, %sh_prom35, !dbg !174
  %and37 = and i64 %shr36, 1, !dbg !175
  %or38 = or i64 %shl33, %and37, !dbg !176
  store i64 %or38, i64* %k48, align 8, !dbg !177
  br label %for.inc39, !dbg !178

for.inc39:                                        ; preds = %for.body29
  %28 = load i32, i32* %i25, align 4, !dbg !179
  %inc40 = add nsw i32 %28, 1, !dbg !179
  store i32 %inc40, i32* %i25, align 4, !dbg !179
  br label %for.cond26, !dbg !180, !llvm.loop !181

for.end41:                                        ; preds = %for.cond26
  %29 = load i64, i64* %k48, align 8, !dbg !183
  %30 = load i32, i32* %r, align 4, !dbg !184
  %idxprom42 = sext i32 %30 to i64, !dbg !185
  %arrayidx43 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idxprom42, !dbg !185
  store i64 %29, i64* %arrayidx43, align 8, !dbg !186
  br label %for.inc44, !dbg !187

for.inc44:                                        ; preds = %for.end41
  %31 = load i32, i32* %r, align 4, !dbg !188
  %inc45 = add nsw i32 %31, 1, !dbg !188
  store i32 %inc45, i32* %r, align 4, !dbg !188
  br label %for.cond5, !dbg !189, !llvm.loop !190

for.end46:                                        ; preds = %for.cond5
  call void @llvm.dbg.declare(metadata i64* %ip, metadata !192, metadata !DIExpression()), !dbg !193
  store i64 0, i64* %ip, align 8, !dbg !193
  call void @llvm.dbg.declare(metadata i32* %i47, metadata !194, metadata !DIExpression()), !dbg !196
  store i32 0, i32* %i47, align 4, !dbg !196
  br label %for.cond48, !dbg !197

for.cond48:                                       ; preds = %for.inc61, %for.end46
  %32 = load i32, i32* %i47, align 4, !dbg !198
  %cmp49 = icmp slt i32 %32, 64, !dbg !200
  br i1 %cmp49, label %for.body51, label %for.end63, !dbg !201

for.body51:                                       ; preds = %for.cond48
  call void @llvm.dbg.declare(metadata i32* %src52, metadata !202, metadata !DIExpression()), !dbg !204
  %33 = load i32, i32* %i47, align 4, !dbg !205
  %idxprom53 = sext i32 %33 to i64, !dbg !206
  %arrayidx54 = getelementptr inbounds [64 x i32], [64 x i32]* @des_encrypt.IP, i64 0, i64 %idxprom53, !dbg !206
  %34 = load i32, i32* %arrayidx54, align 4, !dbg !206
  store i32 %34, i32* %src52, align 4, !dbg !204
  %35 = load i64, i64* %ip, align 8, !dbg !207
  %shl55 = shl i64 %35, 1, !dbg !208
  %36 = load i64, i64* %plaintext.addr, align 8, !dbg !209
  %37 = load i32, i32* %src52, align 4, !dbg !210
  %sub56 = sub nsw i32 64, %37, !dbg !211
  %sh_prom57 = zext i32 %sub56 to i64, !dbg !212
  %shr58 = lshr i64 %36, %sh_prom57, !dbg !212
  %and59 = and i64 %shr58, 1, !dbg !213
  %or60 = or i64 %shl55, %and59, !dbg !214
  store i64 %or60, i64* %ip, align 8, !dbg !215
  br label %for.inc61, !dbg !216

for.inc61:                                        ; preds = %for.body51
  %38 = load i32, i32* %i47, align 4, !dbg !217
  %inc62 = add nsw i32 %38, 1, !dbg !217
  store i32 %inc62, i32* %i47, align 4, !dbg !217
  br label %for.cond48, !dbg !218, !llvm.loop !219

for.end63:                                        ; preds = %for.cond48
  call void @llvm.dbg.declare(metadata i32* %L, metadata !221, metadata !DIExpression()), !dbg !222
  %39 = load i64, i64* %ip, align 8, !dbg !223
  %shr64 = lshr i64 %39, 32, !dbg !224
  %conv65 = trunc i64 %shr64 to i32, !dbg !225
  store i32 %conv65, i32* %L, align 4, !dbg !222
  call void @llvm.dbg.declare(metadata i32* %R, metadata !226, metadata !DIExpression()), !dbg !227
  %40 = load i64, i64* %ip, align 8, !dbg !228
  %and66 = and i64 %40, 4294967295, !dbg !229
  %conv67 = trunc i64 %and66 to i32, !dbg !230
  store i32 %conv67, i32* %R, align 4, !dbg !227
  call void @llvm.dbg.declare(metadata i32* %r68, metadata !231, metadata !DIExpression()), !dbg !233
  store i32 0, i32* %r68, align 4, !dbg !233
  br label %for.cond69, !dbg !234

for.cond69:                                       ; preds = %for.inc139, %for.end63
  %41 = load i32, i32* %r68, align 4, !dbg !235
  %cmp70 = icmp slt i32 %41, 16, !dbg !237
  br i1 %cmp70, label %for.body72, label %for.end141, !dbg !238

for.body72:                                       ; preds = %for.cond69
  call void @llvm.dbg.declare(metadata i64* %ER, metadata !239, metadata !DIExpression()), !dbg !241
  store i64 0, i64* %ER, align 8, !dbg !241
  call void @llvm.dbg.declare(metadata i32* %i73, metadata !242, metadata !DIExpression()), !dbg !244
  store i32 0, i32* %i73, align 4, !dbg !244
  br label %for.cond74, !dbg !245

for.cond74:                                       ; preds = %for.inc87, %for.body72
  %42 = load i32, i32* %i73, align 4, !dbg !246
  %cmp75 = icmp slt i32 %42, 48, !dbg !248
  br i1 %cmp75, label %for.body77, label %for.end89, !dbg !249

for.body77:                                       ; preds = %for.cond74
  call void @llvm.dbg.declare(metadata i32* %src78, metadata !250, metadata !DIExpression()), !dbg !252
  %43 = load i32, i32* %i73, align 4, !dbg !253
  %idxprom79 = sext i32 %43 to i64, !dbg !254
  %arrayidx80 = getelementptr inbounds [48 x i32], [48 x i32]* @des_encrypt.E, i64 0, i64 %idxprom79, !dbg !254
  %44 = load i32, i32* %arrayidx80, align 4, !dbg !254
  store i32 %44, i32* %src78, align 4, !dbg !252
  %45 = load i64, i64* %ER, align 8, !dbg !255
  %shl81 = shl i64 %45, 1, !dbg !256
  %46 = load i32, i32* %R, align 4, !dbg !257
  %47 = load i32, i32* %src78, align 4, !dbg !258
  %sub82 = sub nsw i32 32, %47, !dbg !259
  %shr83 = lshr i32 %46, %sub82, !dbg !260
  %and84 = and i32 %shr83, 1, !dbg !261
  %conv85 = zext i32 %and84 to i64, !dbg !262
  %or86 = or i64 %shl81, %conv85, !dbg !263
  store i64 %or86, i64* %ER, align 8, !dbg !264
  br label %for.inc87, !dbg !265

for.inc87:                                        ; preds = %for.body77
  %48 = load i32, i32* %i73, align 4, !dbg !266
  %inc88 = add nsw i32 %48, 1, !dbg !266
  store i32 %inc88, i32* %i73, align 4, !dbg !266
  br label %for.cond74, !dbg !267, !llvm.loop !268

for.end89:                                        ; preds = %for.cond74
  call void @llvm.dbg.declare(metadata i64* %X, metadata !270, metadata !DIExpression()), !dbg !271
  %49 = load i64, i64* %ER, align 8, !dbg !272
  %50 = load i32, i32* %r68, align 4, !dbg !273
  %idxprom90 = sext i32 %50 to i64, !dbg !274
  %arrayidx91 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idxprom90, !dbg !274
  %51 = load i64, i64* %arrayidx91, align 8, !dbg !274
  %xor = xor i64 %49, %51, !dbg !275
  store i64 %xor, i64* %X, align 8, !dbg !271
  call void @llvm.dbg.declare(metadata i32* %SOUT, metadata !276, metadata !DIExpression()), !dbg !277
  store i32 0, i32* %SOUT, align 4, !dbg !277
  call void @llvm.dbg.declare(metadata i32* %b, metadata !278, metadata !DIExpression()), !dbg !280
  store i32 0, i32* %b, align 4, !dbg !280
  br label %for.cond92, !dbg !281

for.cond92:                                       ; preds = %for.inc119, %for.end89
  %52 = load i32, i32* %b, align 4, !dbg !282
  %cmp93 = icmp slt i32 %52, 8, !dbg !284
  br i1 %cmp93, label %for.body95, label %for.end121, !dbg !285

for.body95:                                       ; preds = %for.cond92
  call void @llvm.dbg.declare(metadata i32* %shift, metadata !286, metadata !DIExpression()), !dbg !288
  %53 = load i32, i32* %b, align 4, !dbg !289
  %mul = mul nsw i32 6, %53, !dbg !290
  %sub96 = sub nsw i32 42, %mul, !dbg !291
  store i32 %sub96, i32* %shift, align 4, !dbg !288
  call void @llvm.dbg.declare(metadata i8* %chunk, metadata !292, metadata !DIExpression()), !dbg !293
  %54 = load i64, i64* %X, align 8, !dbg !294
  %55 = load i32, i32* %shift, align 4, !dbg !295
  %sh_prom97 = zext i32 %55 to i64, !dbg !296
  %shr98 = lshr i64 %54, %sh_prom97, !dbg !296
  %and99 = and i64 %shr98, 63, !dbg !297
  %conv100 = trunc i64 %and99 to i8, !dbg !298
  store i8 %conv100, i8* %chunk, align 1, !dbg !293
  call void @llvm.dbg.declare(metadata i32* %row, metadata !299, metadata !DIExpression()), !dbg !300
  %56 = load i8, i8* %chunk, align 1, !dbg !301
  %conv101 = zext i8 %56 to i32, !dbg !301
  %and102 = and i32 %conv101, 32, !dbg !302
  %shr103 = ashr i32 %and102, 4, !dbg !303
  %57 = load i8, i8* %chunk, align 1, !dbg !304
  %conv104 = zext i8 %57 to i32, !dbg !304
  %and105 = and i32 %conv104, 1, !dbg !305
  %or106 = or i32 %shr103, %and105, !dbg !306
  store i32 %or106, i32* %row, align 4, !dbg !300
  call void @llvm.dbg.declare(metadata i32* %col, metadata !307, metadata !DIExpression()), !dbg !308
  %58 = load i8, i8* %chunk, align 1, !dbg !309
  %conv107 = zext i8 %58 to i32, !dbg !309
  %shr108 = ashr i32 %conv107, 1, !dbg !310
  %and109 = and i32 %shr108, 15, !dbg !311
  store i32 %and109, i32* %col, align 4, !dbg !308
  call void @llvm.dbg.declare(metadata i8* %s110, metadata !312, metadata !DIExpression()), !dbg !313
  %59 = load i32, i32* %b, align 4, !dbg !314
  %idxprom111 = sext i32 %59 to i64, !dbg !315
  %arrayidx112 = getelementptr inbounds [8 x [64 x i8]], [8 x [64 x i8]]* @des_encrypt.SBOX, i64 0, i64 %idxprom111, !dbg !315
  %60 = load i32, i32* %row, align 4, !dbg !316
  %mul113 = mul nsw i32 %60, 16, !dbg !317
  %61 = load i32, i32* %col, align 4, !dbg !318
  %add = add nsw i32 %mul113, %61, !dbg !319
  %idxprom114 = sext i32 %add to i64, !dbg !315
  %arrayidx115 = getelementptr inbounds [64 x i8], [64 x i8]* %arrayidx112, i64 0, i64 %idxprom114, !dbg !315
  %62 = load i8, i8* %arrayidx115, align 1, !dbg !315
  store i8 %62, i8* %s110, align 1, !dbg !313
  %63 = load i32, i32* %SOUT, align 4, !dbg !320
  %shl116 = shl i32 %63, 4, !dbg !321
  %64 = load i8, i8* %s110, align 1, !dbg !322
  %conv117 = zext i8 %64 to i32, !dbg !322
  %or118 = or i32 %shl116, %conv117, !dbg !323
  store i32 %or118, i32* %SOUT, align 4, !dbg !324
  br label %for.inc119, !dbg !325

for.inc119:                                       ; preds = %for.body95
  %65 = load i32, i32* %b, align 4, !dbg !326
  %inc120 = add nsw i32 %65, 1, !dbg !326
  store i32 %inc120, i32* %b, align 4, !dbg !326
  br label %for.cond92, !dbg !327, !llvm.loop !328

for.end121:                                       ; preds = %for.cond92
  call void @llvm.dbg.declare(metadata i32* %F, metadata !330, metadata !DIExpression()), !dbg !331
  store i32 0, i32* %F, align 4, !dbg !331
  call void @llvm.dbg.declare(metadata i32* %i122, metadata !332, metadata !DIExpression()), !dbg !334
  store i32 0, i32* %i122, align 4, !dbg !334
  br label %for.cond123, !dbg !335

for.cond123:                                      ; preds = %for.inc135, %for.end121
  %66 = load i32, i32* %i122, align 4, !dbg !336
  %cmp124 = icmp slt i32 %66, 32, !dbg !338
  br i1 %cmp124, label %for.body126, label %for.end137, !dbg !339

for.body126:                                      ; preds = %for.cond123
  call void @llvm.dbg.declare(metadata i32* %src127, metadata !340, metadata !DIExpression()), !dbg !342
  %67 = load i32, i32* %i122, align 4, !dbg !343
  %idxprom128 = sext i32 %67 to i64, !dbg !344
  %arrayidx129 = getelementptr inbounds [32 x i32], [32 x i32]* @des_encrypt.P, i64 0, i64 %idxprom128, !dbg !344
  %68 = load i32, i32* %arrayidx129, align 4, !dbg !344
  store i32 %68, i32* %src127, align 4, !dbg !342
  %69 = load i32, i32* %F, align 4, !dbg !345
  %shl130 = shl i32 %69, 1, !dbg !346
  %70 = load i32, i32* %SOUT, align 4, !dbg !347
  %71 = load i32, i32* %src127, align 4, !dbg !348
  %sub131 = sub nsw i32 32, %71, !dbg !349
  %shr132 = lshr i32 %70, %sub131, !dbg !350
  %and133 = and i32 %shr132, 1, !dbg !351
  %or134 = or i32 %shl130, %and133, !dbg !352
  store i32 %or134, i32* %F, align 4, !dbg !353
  br label %for.inc135, !dbg !354

for.inc135:                                       ; preds = %for.body126
  %72 = load i32, i32* %i122, align 4, !dbg !355
  %inc136 = add nsw i32 %72, 1, !dbg !355
  store i32 %inc136, i32* %i122, align 4, !dbg !355
  br label %for.cond123, !dbg !356, !llvm.loop !357

for.end137:                                       ; preds = %for.cond123
  call void @llvm.dbg.declare(metadata i32* %newL, metadata !359, metadata !DIExpression()), !dbg !360
  %73 = load i32, i32* %R, align 4, !dbg !361
  store i32 %73, i32* %newL, align 4, !dbg !360
  call void @llvm.dbg.declare(metadata i32* %newR, metadata !362, metadata !DIExpression()), !dbg !363
  %74 = load i32, i32* %L, align 4, !dbg !364
  %75 = load i32, i32* %F, align 4, !dbg !365
  %xor138 = xor i32 %74, %75, !dbg !366
  store i32 %xor138, i32* %newR, align 4, !dbg !363
  %76 = load i32, i32* %newL, align 4, !dbg !367
  store i32 %76, i32* %L, align 4, !dbg !368
  %77 = load i32, i32* %newR, align 4, !dbg !369
  store i32 %77, i32* %R, align 4, !dbg !370
  br label %for.inc139, !dbg !371

for.inc139:                                       ; preds = %for.end137
  %78 = load i32, i32* %r68, align 4, !dbg !372
  %inc140 = add nsw i32 %78, 1, !dbg !372
  store i32 %inc140, i32* %r68, align 4, !dbg !372
  br label %for.cond69, !dbg !373, !llvm.loop !374

for.end141:                                       ; preds = %for.cond69
  call void @llvm.dbg.declare(metadata i64* %preout, metadata !376, metadata !DIExpression()), !dbg !377
  %79 = load i32, i32* %R, align 4, !dbg !378
  %conv142 = zext i32 %79 to i64, !dbg !379
  %shl143 = shl i64 %conv142, 32, !dbg !380
  %80 = load i32, i32* %L, align 4, !dbg !381
  %conv144 = zext i32 %80 to i64, !dbg !382
  %or145 = or i64 %shl143, %conv144, !dbg !383
  store i64 %or145, i64* %preout, align 8, !dbg !377
  call void @llvm.dbg.declare(metadata i64* %ct, metadata !384, metadata !DIExpression()), !dbg !385
  store i64 0, i64* %ct, align 8, !dbg !385
  call void @llvm.dbg.declare(metadata i32* %i146, metadata !386, metadata !DIExpression()), !dbg !388
  store i32 0, i32* %i146, align 4, !dbg !388
  br label %for.cond147, !dbg !389

for.cond147:                                      ; preds = %for.inc160, %for.end141
  %81 = load i32, i32* %i146, align 4, !dbg !390
  %cmp148 = icmp slt i32 %81, 64, !dbg !392
  br i1 %cmp148, label %for.body150, label %for.end162, !dbg !393

for.body150:                                      ; preds = %for.cond147
  call void @llvm.dbg.declare(metadata i32* %src151, metadata !394, metadata !DIExpression()), !dbg !396
  %82 = load i32, i32* %i146, align 4, !dbg !397
  %idxprom152 = sext i32 %82 to i64, !dbg !398
  %arrayidx153 = getelementptr inbounds [64 x i32], [64 x i32]* @des_encrypt.FP, i64 0, i64 %idxprom152, !dbg !398
  %83 = load i32, i32* %arrayidx153, align 4, !dbg !398
  store i32 %83, i32* %src151, align 4, !dbg !396
  %84 = load i64, i64* %ct, align 8, !dbg !399
  %shl154 = shl i64 %84, 1, !dbg !400
  %85 = load i64, i64* %preout, align 8, !dbg !401
  %86 = load i32, i32* %src151, align 4, !dbg !402
  %sub155 = sub nsw i32 64, %86, !dbg !403
  %sh_prom156 = zext i32 %sub155 to i64, !dbg !404
  %shr157 = lshr i64 %85, %sh_prom156, !dbg !404
  %and158 = and i64 %shr157, 1, !dbg !405
  %or159 = or i64 %shl154, %and158, !dbg !406
  store i64 %or159, i64* %ct, align 8, !dbg !407
  br label %for.inc160, !dbg !408

for.inc160:                                       ; preds = %for.body150
  %87 = load i32, i32* %i146, align 4, !dbg !409
  %inc161 = add nsw i32 %87, 1, !dbg !409
  store i32 %inc161, i32* %i146, align 4, !dbg !409
  br label %for.cond147, !dbg !410, !llvm.loop !411

for.end162:                                       ; preds = %for.cond147
  %88 = load i64, i64* %ct, align 8, !dbg !413
  ret i64 %88, !dbg !414
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !415 {
entry:
  %retval = alloca i32, align 4
  %key = alloca i64, align 8
  %plain = alloca i64, align 8
  %c = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i64* %key, metadata !418, metadata !DIExpression()), !dbg !419
  store i64 1383827165325090801, i64* %key, align 8, !dbg !419
  call void @llvm.dbg.declare(metadata i64* %plain, metadata !420, metadata !DIExpression()), !dbg !421
  store i64 81985529216486895, i64* %plain, align 8, !dbg !421
  call void @llvm.dbg.declare(metadata i64* %c, metadata !422, metadata !DIExpression()), !dbg !423
  %0 = load i64, i64* %plain, align 8, !dbg !424
  %1 = load i64, i64* %key, align 8, !dbg !425
  %call = call i64 @des_encrypt(i64 noundef %0, i64 noundef %1), !dbg !426
  store i64 %call, i64* %c, align 8, !dbg !423
  %2 = load i64, i64* %c, align 8, !dbg !427
  %call1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef %2), !dbg !428
  %call2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0)), !dbg !429
  ret i32 0, !dbg !430
}

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!57, !58, !59, !60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "IP", scope: !2, file: !3, line: 5, type: !20, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "des_encrypt", scope: !3, file: !3, line: 4, type: !4, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !56)
!3 = !DIFile(filename: "DES_single_func.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/original/src", checksumkind: CSK_MD5, checksum: "fb11a914cbc5cdd8d063541471ded005")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !7, line: 27, baseType: !8)
!7 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !9, line: 45, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !12, globals: !17, splitDebugInlining: false, nameTableKind: None)
!12 = !{!13, !6, !16}
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !7, line: 26, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !9, line: 42, baseType: !15)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!17 = !{!0, !18, !25, !30, !35, !40, !42, !47}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "FP", scope: !2, file: !3, line: 11, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 2048, elements: !23)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !{!24}
!24 = !DISubrange(count: 64)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "E", scope: !2, file: !3, line: 17, type: !27, isLocal: true, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 1536, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 48)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "P", scope: !2, file: !3, line: 23, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 1024, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 32)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "PC1", scope: !2, file: !3, line: 27, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 1792, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 56)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "PC2", scope: !2, file: !3, line: 33, type: !27, isLocal: true, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "SHIFTS", scope: !2, file: !3, line: 39, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 512, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 16)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "SBOX", scope: !2, file: !3, line: 41, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 4096, elements: !54)
!50 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !7, line: 24, baseType: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !9, line: 38, baseType: !53)
!53 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!54 = !{!55, !24}
!55 = !DISubrange(count: 8)
!56 = !{}
!57 = !{i32 7, !"Dwarf Version", i32 5}
!58 = !{i32 2, !"Debug Info Version", i32 3}
!59 = !{i32 1, !"wchar_size", i32 4}
!60 = !{i32 7, !"PIC Level", i32 2}
!61 = !{i32 7, !"PIE Level", i32 2}
!62 = !{i32 7, !"uwtable", i32 1}
!63 = !{i32 7, !"frame-pointer", i32 2}
!64 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!65 = !DILocalVariable(name: "plaintext", arg: 1, scope: !2, file: !3, line: 4, type: !6)
!66 = !DILocation(line: 4, column: 31, scope: !2)
!67 = !DILocalVariable(name: "key64", arg: 2, scope: !2, file: !3, line: 4, type: !6)
!68 = !DILocation(line: 4, column: 51, scope: !2)
!69 = !DILocalVariable(name: "k56", scope: !2, file: !3, line: 84, type: !6)
!70 = !DILocation(line: 84, column: 14, scope: !2)
!71 = !DILocalVariable(name: "i", scope: !72, file: !3, line: 85, type: !22)
!72 = distinct !DILexicalBlock(scope: !2, file: !3, line: 85, column: 5)
!73 = !DILocation(line: 85, column: 14, scope: !72)
!74 = !DILocation(line: 85, column: 10, scope: !72)
!75 = !DILocation(line: 85, column: 21, scope: !76)
!76 = distinct !DILexicalBlock(scope: !72, file: !3, line: 85, column: 5)
!77 = !DILocation(line: 85, column: 23, scope: !76)
!78 = !DILocation(line: 85, column: 5, scope: !72)
!79 = !DILocalVariable(name: "src", scope: !80, file: !3, line: 86, type: !22)
!80 = distinct !DILexicalBlock(scope: !76, file: !3, line: 85, column: 34)
!81 = !DILocation(line: 86, column: 13, scope: !80)
!82 = !DILocation(line: 86, column: 23, scope: !80)
!83 = !DILocation(line: 86, column: 19, scope: !80)
!84 = !DILocation(line: 87, column: 16, scope: !80)
!85 = !DILocation(line: 87, column: 20, scope: !80)
!86 = !DILocation(line: 87, column: 30, scope: !80)
!87 = !DILocation(line: 87, column: 45, scope: !80)
!88 = !DILocation(line: 87, column: 43, scope: !80)
!89 = !DILocation(line: 87, column: 36, scope: !80)
!90 = !DILocation(line: 87, column: 51, scope: !80)
!91 = !DILocation(line: 87, column: 26, scope: !80)
!92 = !DILocation(line: 87, column: 13, scope: !80)
!93 = !DILocation(line: 88, column: 5, scope: !80)
!94 = !DILocation(line: 85, column: 29, scope: !76)
!95 = !DILocation(line: 85, column: 5, scope: !76)
!96 = distinct !{!96, !78, !97, !98}
!97 = !DILocation(line: 88, column: 5, scope: !72)
!98 = !{!"llvm.loop.mustprogress"}
!99 = !DILocalVariable(name: "C", scope: !2, file: !3, line: 89, type: !13)
!100 = !DILocation(line: 89, column: 14, scope: !2)
!101 = !DILocation(line: 89, column: 30, scope: !2)
!102 = !DILocation(line: 89, column: 34, scope: !2)
!103 = !DILocation(line: 89, column: 41, scope: !2)
!104 = !DILocation(line: 89, column: 18, scope: !2)
!105 = !DILocalVariable(name: "D", scope: !2, file: !3, line: 90, type: !13)
!106 = !DILocation(line: 90, column: 14, scope: !2)
!107 = !DILocation(line: 90, column: 30, scope: !2)
!108 = !DILocation(line: 90, column: 41, scope: !2)
!109 = !DILocation(line: 90, column: 18, scope: !2)
!110 = !DILocalVariable(name: "subkeys", scope: !2, file: !3, line: 92, type: !111)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 1024, elements: !45)
!112 = !DILocation(line: 92, column: 14, scope: !2)
!113 = !DILocalVariable(name: "r", scope: !114, file: !3, line: 93, type: !22)
!114 = distinct !DILexicalBlock(scope: !2, file: !3, line: 93, column: 5)
!115 = !DILocation(line: 93, column: 14, scope: !114)
!116 = !DILocation(line: 93, column: 10, scope: !114)
!117 = !DILocation(line: 93, column: 21, scope: !118)
!118 = distinct !DILexicalBlock(scope: !114, file: !3, line: 93, column: 5)
!119 = !DILocation(line: 93, column: 23, scope: !118)
!120 = !DILocation(line: 93, column: 5, scope: !114)
!121 = !DILocalVariable(name: "s", scope: !122, file: !3, line: 94, type: !22)
!122 = distinct !DILexicalBlock(scope: !118, file: !3, line: 93, column: 34)
!123 = !DILocation(line: 94, column: 13, scope: !122)
!124 = !DILocation(line: 94, column: 24, scope: !122)
!125 = !DILocation(line: 94, column: 17, scope: !122)
!126 = !DILocation(line: 95, column: 15, scope: !122)
!127 = !DILocation(line: 95, column: 20, scope: !122)
!128 = !DILocation(line: 95, column: 17, scope: !122)
!129 = !DILocation(line: 95, column: 26, scope: !122)
!130 = !DILocation(line: 95, column: 37, scope: !122)
!131 = !DILocation(line: 95, column: 35, scope: !122)
!132 = !DILocation(line: 95, column: 28, scope: !122)
!133 = !DILocation(line: 95, column: 23, scope: !122)
!134 = !DILocation(line: 95, column: 42, scope: !122)
!135 = !DILocation(line: 95, column: 11, scope: !122)
!136 = !DILocation(line: 96, column: 15, scope: !122)
!137 = !DILocation(line: 96, column: 20, scope: !122)
!138 = !DILocation(line: 96, column: 17, scope: !122)
!139 = !DILocation(line: 96, column: 26, scope: !122)
!140 = !DILocation(line: 96, column: 37, scope: !122)
!141 = !DILocation(line: 96, column: 35, scope: !122)
!142 = !DILocation(line: 96, column: 28, scope: !122)
!143 = !DILocation(line: 96, column: 23, scope: !122)
!144 = !DILocation(line: 96, column: 42, scope: !122)
!145 = !DILocation(line: 96, column: 11, scope: !122)
!146 = !DILocalVariable(name: "CD", scope: !122, file: !3, line: 97, type: !6)
!147 = !DILocation(line: 97, column: 18, scope: !122)
!148 = !DILocation(line: 97, column: 35, scope: !122)
!149 = !DILocation(line: 97, column: 25, scope: !122)
!150 = !DILocation(line: 97, column: 38, scope: !122)
!151 = !DILocation(line: 97, column: 57, scope: !122)
!152 = !DILocation(line: 97, column: 47, scope: !122)
!153 = !DILocation(line: 97, column: 45, scope: !122)
!154 = !DILocalVariable(name: "k48", scope: !122, file: !3, line: 99, type: !6)
!155 = !DILocation(line: 99, column: 18, scope: !122)
!156 = !DILocalVariable(name: "i", scope: !157, file: !3, line: 100, type: !22)
!157 = distinct !DILexicalBlock(scope: !122, file: !3, line: 100, column: 9)
!158 = !DILocation(line: 100, column: 18, scope: !157)
!159 = !DILocation(line: 100, column: 14, scope: !157)
!160 = !DILocation(line: 100, column: 25, scope: !161)
!161 = distinct !DILexicalBlock(scope: !157, file: !3, line: 100, column: 9)
!162 = !DILocation(line: 100, column: 27, scope: !161)
!163 = !DILocation(line: 100, column: 9, scope: !157)
!164 = !DILocalVariable(name: "src", scope: !165, file: !3, line: 101, type: !22)
!165 = distinct !DILexicalBlock(scope: !161, file: !3, line: 100, column: 38)
!166 = !DILocation(line: 101, column: 17, scope: !165)
!167 = !DILocation(line: 101, column: 27, scope: !165)
!168 = !DILocation(line: 101, column: 23, scope: !165)
!169 = !DILocation(line: 102, column: 20, scope: !165)
!170 = !DILocation(line: 102, column: 24, scope: !165)
!171 = !DILocation(line: 102, column: 34, scope: !165)
!172 = !DILocation(line: 102, column: 46, scope: !165)
!173 = !DILocation(line: 102, column: 44, scope: !165)
!174 = !DILocation(line: 102, column: 37, scope: !165)
!175 = !DILocation(line: 102, column: 52, scope: !165)
!176 = !DILocation(line: 102, column: 30, scope: !165)
!177 = !DILocation(line: 102, column: 17, scope: !165)
!178 = !DILocation(line: 103, column: 9, scope: !165)
!179 = !DILocation(line: 100, column: 33, scope: !161)
!180 = !DILocation(line: 100, column: 9, scope: !161)
!181 = distinct !{!181, !163, !182, !98}
!182 = !DILocation(line: 103, column: 9, scope: !157)
!183 = !DILocation(line: 104, column: 22, scope: !122)
!184 = !DILocation(line: 104, column: 17, scope: !122)
!185 = !DILocation(line: 104, column: 9, scope: !122)
!186 = !DILocation(line: 104, column: 20, scope: !122)
!187 = !DILocation(line: 105, column: 5, scope: !122)
!188 = !DILocation(line: 93, column: 29, scope: !118)
!189 = !DILocation(line: 93, column: 5, scope: !118)
!190 = distinct !{!190, !120, !191, !98}
!191 = !DILocation(line: 105, column: 5, scope: !114)
!192 = !DILocalVariable(name: "ip", scope: !2, file: !3, line: 107, type: !6)
!193 = !DILocation(line: 107, column: 14, scope: !2)
!194 = !DILocalVariable(name: "i", scope: !195, file: !3, line: 108, type: !22)
!195 = distinct !DILexicalBlock(scope: !2, file: !3, line: 108, column: 5)
!196 = !DILocation(line: 108, column: 14, scope: !195)
!197 = !DILocation(line: 108, column: 10, scope: !195)
!198 = !DILocation(line: 108, column: 21, scope: !199)
!199 = distinct !DILexicalBlock(scope: !195, file: !3, line: 108, column: 5)
!200 = !DILocation(line: 108, column: 23, scope: !199)
!201 = !DILocation(line: 108, column: 5, scope: !195)
!202 = !DILocalVariable(name: "src", scope: !203, file: !3, line: 109, type: !22)
!203 = distinct !DILexicalBlock(scope: !199, file: !3, line: 108, column: 34)
!204 = !DILocation(line: 109, column: 13, scope: !203)
!205 = !DILocation(line: 109, column: 22, scope: !203)
!206 = !DILocation(line: 109, column: 19, scope: !203)
!207 = !DILocation(line: 110, column: 15, scope: !203)
!208 = !DILocation(line: 110, column: 18, scope: !203)
!209 = !DILocation(line: 110, column: 28, scope: !203)
!210 = !DILocation(line: 110, column: 47, scope: !203)
!211 = !DILocation(line: 110, column: 45, scope: !203)
!212 = !DILocation(line: 110, column: 38, scope: !203)
!213 = !DILocation(line: 110, column: 53, scope: !203)
!214 = !DILocation(line: 110, column: 24, scope: !203)
!215 = !DILocation(line: 110, column: 12, scope: !203)
!216 = !DILocation(line: 111, column: 5, scope: !203)
!217 = !DILocation(line: 108, column: 29, scope: !199)
!218 = !DILocation(line: 108, column: 5, scope: !199)
!219 = distinct !{!219, !201, !220, !98}
!220 = !DILocation(line: 111, column: 5, scope: !195)
!221 = !DILocalVariable(name: "L", scope: !2, file: !3, line: 112, type: !13)
!222 = !DILocation(line: 112, column: 14, scope: !2)
!223 = !DILocation(line: 112, column: 29, scope: !2)
!224 = !DILocation(line: 112, column: 32, scope: !2)
!225 = !DILocation(line: 112, column: 18, scope: !2)
!226 = !DILocalVariable(name: "R", scope: !2, file: !3, line: 113, type: !13)
!227 = !DILocation(line: 113, column: 14, scope: !2)
!228 = !DILocation(line: 113, column: 29, scope: !2)
!229 = !DILocation(line: 113, column: 32, scope: !2)
!230 = !DILocation(line: 113, column: 18, scope: !2)
!231 = !DILocalVariable(name: "r", scope: !232, file: !3, line: 115, type: !22)
!232 = distinct !DILexicalBlock(scope: !2, file: !3, line: 115, column: 5)
!233 = !DILocation(line: 115, column: 14, scope: !232)
!234 = !DILocation(line: 115, column: 10, scope: !232)
!235 = !DILocation(line: 115, column: 21, scope: !236)
!236 = distinct !DILexicalBlock(scope: !232, file: !3, line: 115, column: 5)
!237 = !DILocation(line: 115, column: 23, scope: !236)
!238 = !DILocation(line: 115, column: 5, scope: !232)
!239 = !DILocalVariable(name: "ER", scope: !240, file: !3, line: 116, type: !6)
!240 = distinct !DILexicalBlock(scope: !236, file: !3, line: 115, column: 34)
!241 = !DILocation(line: 116, column: 18, scope: !240)
!242 = !DILocalVariable(name: "i", scope: !243, file: !3, line: 117, type: !22)
!243 = distinct !DILexicalBlock(scope: !240, file: !3, line: 117, column: 9)
!244 = !DILocation(line: 117, column: 18, scope: !243)
!245 = !DILocation(line: 117, column: 14, scope: !243)
!246 = !DILocation(line: 117, column: 25, scope: !247)
!247 = distinct !DILexicalBlock(scope: !243, file: !3, line: 117, column: 9)
!248 = !DILocation(line: 117, column: 27, scope: !247)
!249 = !DILocation(line: 117, column: 9, scope: !243)
!250 = !DILocalVariable(name: "src", scope: !251, file: !3, line: 118, type: !22)
!251 = distinct !DILexicalBlock(scope: !247, file: !3, line: 117, column: 38)
!252 = !DILocation(line: 118, column: 17, scope: !251)
!253 = !DILocation(line: 118, column: 25, scope: !251)
!254 = !DILocation(line: 118, column: 23, scope: !251)
!255 = !DILocation(line: 119, column: 19, scope: !251)
!256 = !DILocation(line: 119, column: 22, scope: !251)
!257 = !DILocation(line: 119, column: 43, scope: !251)
!258 = !DILocation(line: 119, column: 54, scope: !251)
!259 = !DILocation(line: 119, column: 52, scope: !251)
!260 = !DILocation(line: 119, column: 45, scope: !251)
!261 = !DILocation(line: 119, column: 60, scope: !251)
!262 = !DILocation(line: 119, column: 31, scope: !251)
!263 = !DILocation(line: 119, column: 28, scope: !251)
!264 = !DILocation(line: 119, column: 16, scope: !251)
!265 = !DILocation(line: 120, column: 9, scope: !251)
!266 = !DILocation(line: 117, column: 33, scope: !247)
!267 = !DILocation(line: 117, column: 9, scope: !247)
!268 = distinct !{!268, !249, !269, !98}
!269 = !DILocation(line: 120, column: 9, scope: !243)
!270 = !DILocalVariable(name: "X", scope: !240, file: !3, line: 122, type: !6)
!271 = !DILocation(line: 122, column: 18, scope: !240)
!272 = !DILocation(line: 122, column: 22, scope: !240)
!273 = !DILocation(line: 122, column: 35, scope: !240)
!274 = !DILocation(line: 122, column: 27, scope: !240)
!275 = !DILocation(line: 122, column: 25, scope: !240)
!276 = !DILocalVariable(name: "SOUT", scope: !240, file: !3, line: 124, type: !13)
!277 = !DILocation(line: 124, column: 18, scope: !240)
!278 = !DILocalVariable(name: "b", scope: !279, file: !3, line: 125, type: !22)
!279 = distinct !DILexicalBlock(scope: !240, file: !3, line: 125, column: 9)
!280 = !DILocation(line: 125, column: 18, scope: !279)
!281 = !DILocation(line: 125, column: 14, scope: !279)
!282 = !DILocation(line: 125, column: 25, scope: !283)
!283 = distinct !DILexicalBlock(scope: !279, file: !3, line: 125, column: 9)
!284 = !DILocation(line: 125, column: 27, scope: !283)
!285 = !DILocation(line: 125, column: 9, scope: !279)
!286 = !DILocalVariable(name: "shift", scope: !287, file: !3, line: 126, type: !22)
!287 = distinct !DILexicalBlock(scope: !283, file: !3, line: 125, column: 37)
!288 = !DILocation(line: 126, column: 17, scope: !287)
!289 = !DILocation(line: 126, column: 32, scope: !287)
!290 = !DILocation(line: 126, column: 31, scope: !287)
!291 = !DILocation(line: 126, column: 28, scope: !287)
!292 = !DILocalVariable(name: "chunk", scope: !287, file: !3, line: 127, type: !51)
!293 = !DILocation(line: 127, column: 21, scope: !287)
!294 = !DILocation(line: 127, column: 30, scope: !287)
!295 = !DILocation(line: 127, column: 35, scope: !287)
!296 = !DILocation(line: 127, column: 32, scope: !287)
!297 = !DILocation(line: 127, column: 42, scope: !287)
!298 = !DILocation(line: 127, column: 29, scope: !287)
!299 = !DILocalVariable(name: "row", scope: !287, file: !3, line: 128, type: !22)
!300 = !DILocation(line: 128, column: 17, scope: !287)
!301 = !DILocation(line: 128, column: 25, scope: !287)
!302 = !DILocation(line: 128, column: 31, scope: !287)
!303 = !DILocation(line: 128, column: 39, scope: !287)
!304 = !DILocation(line: 128, column: 48, scope: !287)
!305 = !DILocation(line: 128, column: 54, scope: !287)
!306 = !DILocation(line: 128, column: 45, scope: !287)
!307 = !DILocalVariable(name: "col", scope: !287, file: !3, line: 129, type: !22)
!308 = !DILocation(line: 129, column: 17, scope: !287)
!309 = !DILocation(line: 129, column: 24, scope: !287)
!310 = !DILocation(line: 129, column: 30, scope: !287)
!311 = !DILocation(line: 129, column: 36, scope: !287)
!312 = !DILocalVariable(name: "s", scope: !287, file: !3, line: 130, type: !51)
!313 = !DILocation(line: 130, column: 21, scope: !287)
!314 = !DILocation(line: 130, column: 30, scope: !287)
!315 = !DILocation(line: 130, column: 25, scope: !287)
!316 = !DILocation(line: 130, column: 33, scope: !287)
!317 = !DILocation(line: 130, column: 36, scope: !287)
!318 = !DILocation(line: 130, column: 42, scope: !287)
!319 = !DILocation(line: 130, column: 40, scope: !287)
!320 = !DILocation(line: 131, column: 21, scope: !287)
!321 = !DILocation(line: 131, column: 26, scope: !287)
!322 = !DILocation(line: 131, column: 34, scope: !287)
!323 = !DILocation(line: 131, column: 32, scope: !287)
!324 = !DILocation(line: 131, column: 18, scope: !287)
!325 = !DILocation(line: 132, column: 9, scope: !287)
!326 = !DILocation(line: 125, column: 32, scope: !283)
!327 = !DILocation(line: 125, column: 9, scope: !283)
!328 = distinct !{!328, !285, !329, !98}
!329 = !DILocation(line: 132, column: 9, scope: !279)
!330 = !DILocalVariable(name: "F", scope: !240, file: !3, line: 134, type: !13)
!331 = !DILocation(line: 134, column: 18, scope: !240)
!332 = !DILocalVariable(name: "i", scope: !333, file: !3, line: 135, type: !22)
!333 = distinct !DILexicalBlock(scope: !240, file: !3, line: 135, column: 9)
!334 = !DILocation(line: 135, column: 18, scope: !333)
!335 = !DILocation(line: 135, column: 14, scope: !333)
!336 = !DILocation(line: 135, column: 25, scope: !337)
!337 = distinct !DILexicalBlock(scope: !333, file: !3, line: 135, column: 9)
!338 = !DILocation(line: 135, column: 27, scope: !337)
!339 = !DILocation(line: 135, column: 9, scope: !333)
!340 = !DILocalVariable(name: "src", scope: !341, file: !3, line: 136, type: !22)
!341 = distinct !DILexicalBlock(scope: !337, file: !3, line: 135, column: 38)
!342 = !DILocation(line: 136, column: 17, scope: !341)
!343 = !DILocation(line: 136, column: 25, scope: !341)
!344 = !DILocation(line: 136, column: 23, scope: !341)
!345 = !DILocation(line: 137, column: 18, scope: !341)
!346 = !DILocation(line: 137, column: 20, scope: !341)
!347 = !DILocation(line: 137, column: 30, scope: !341)
!348 = !DILocation(line: 137, column: 44, scope: !341)
!349 = !DILocation(line: 137, column: 42, scope: !341)
!350 = !DILocation(line: 137, column: 35, scope: !341)
!351 = !DILocation(line: 137, column: 50, scope: !341)
!352 = !DILocation(line: 137, column: 26, scope: !341)
!353 = !DILocation(line: 137, column: 15, scope: !341)
!354 = !DILocation(line: 138, column: 9, scope: !341)
!355 = !DILocation(line: 135, column: 33, scope: !337)
!356 = !DILocation(line: 135, column: 9, scope: !337)
!357 = distinct !{!357, !339, !358, !98}
!358 = !DILocation(line: 138, column: 9, scope: !333)
!359 = !DILocalVariable(name: "newL", scope: !240, file: !3, line: 140, type: !13)
!360 = !DILocation(line: 140, column: 18, scope: !240)
!361 = !DILocation(line: 140, column: 25, scope: !240)
!362 = !DILocalVariable(name: "newR", scope: !240, file: !3, line: 141, type: !13)
!363 = !DILocation(line: 141, column: 18, scope: !240)
!364 = !DILocation(line: 141, column: 25, scope: !240)
!365 = !DILocation(line: 141, column: 29, scope: !240)
!366 = !DILocation(line: 141, column: 27, scope: !240)
!367 = !DILocation(line: 142, column: 13, scope: !240)
!368 = !DILocation(line: 142, column: 11, scope: !240)
!369 = !DILocation(line: 142, column: 23, scope: !240)
!370 = !DILocation(line: 142, column: 21, scope: !240)
!371 = !DILocation(line: 143, column: 5, scope: !240)
!372 = !DILocation(line: 115, column: 29, scope: !236)
!373 = !DILocation(line: 115, column: 5, scope: !236)
!374 = distinct !{!374, !238, !375, !98}
!375 = !DILocation(line: 143, column: 5, scope: !232)
!376 = !DILocalVariable(name: "preout", scope: !2, file: !3, line: 145, type: !6)
!377 = !DILocation(line: 145, column: 14, scope: !2)
!378 = !DILocation(line: 145, column: 35, scope: !2)
!379 = !DILocation(line: 145, column: 25, scope: !2)
!380 = !DILocation(line: 145, column: 38, scope: !2)
!381 = !DILocation(line: 145, column: 57, scope: !2)
!382 = !DILocation(line: 145, column: 47, scope: !2)
!383 = !DILocation(line: 145, column: 45, scope: !2)
!384 = !DILocalVariable(name: "ct", scope: !2, file: !3, line: 146, type: !6)
!385 = !DILocation(line: 146, column: 14, scope: !2)
!386 = !DILocalVariable(name: "i", scope: !387, file: !3, line: 147, type: !22)
!387 = distinct !DILexicalBlock(scope: !2, file: !3, line: 147, column: 5)
!388 = !DILocation(line: 147, column: 14, scope: !387)
!389 = !DILocation(line: 147, column: 10, scope: !387)
!390 = !DILocation(line: 147, column: 21, scope: !391)
!391 = distinct !DILexicalBlock(scope: !387, file: !3, line: 147, column: 5)
!392 = !DILocation(line: 147, column: 23, scope: !391)
!393 = !DILocation(line: 147, column: 5, scope: !387)
!394 = !DILocalVariable(name: "src", scope: !395, file: !3, line: 148, type: !22)
!395 = distinct !DILexicalBlock(scope: !391, file: !3, line: 147, column: 34)
!396 = !DILocation(line: 148, column: 13, scope: !395)
!397 = !DILocation(line: 148, column: 22, scope: !395)
!398 = !DILocation(line: 148, column: 19, scope: !395)
!399 = !DILocation(line: 149, column: 15, scope: !395)
!400 = !DILocation(line: 149, column: 18, scope: !395)
!401 = !DILocation(line: 149, column: 28, scope: !395)
!402 = !DILocation(line: 149, column: 44, scope: !395)
!403 = !DILocation(line: 149, column: 42, scope: !395)
!404 = !DILocation(line: 149, column: 35, scope: !395)
!405 = !DILocation(line: 149, column: 50, scope: !395)
!406 = !DILocation(line: 149, column: 24, scope: !395)
!407 = !DILocation(line: 149, column: 12, scope: !395)
!408 = !DILocation(line: 150, column: 5, scope: !395)
!409 = !DILocation(line: 147, column: 29, scope: !391)
!410 = !DILocation(line: 147, column: 5, scope: !391)
!411 = distinct !{!411, !393, !412, !98}
!412 = !DILocation(line: 150, column: 5, scope: !387)
!413 = !DILocation(line: 151, column: 12, scope: !2)
!414 = !DILocation(line: 151, column: 5, scope: !2)
!415 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 154, type: !416, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !56)
!416 = !DISubroutineType(types: !417)
!417 = !{!22}
!418 = !DILocalVariable(name: "key", scope: !415, file: !3, line: 155, type: !6)
!419 = !DILocation(line: 155, column: 14, scope: !415)
!420 = !DILocalVariable(name: "plain", scope: !415, file: !3, line: 156, type: !6)
!421 = !DILocation(line: 156, column: 14, scope: !415)
!422 = !DILocalVariable(name: "c", scope: !415, file: !3, line: 157, type: !6)
!423 = !DILocation(line: 157, column: 14, scope: !415)
!424 = !DILocation(line: 157, column: 30, scope: !415)
!425 = !DILocation(line: 157, column: 37, scope: !415)
!426 = !DILocation(line: 157, column: 18, scope: !415)
!427 = !DILocation(line: 158, column: 57, scope: !415)
!428 = !DILocation(line: 158, column: 5, scope: !415)
!429 = !DILocation(line: 159, column: 5, scope: !415)
!430 = !DILocation(line: 160, column: 5, scope: !415)

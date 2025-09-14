; ModuleID = 'DES_modular.c'
source_filename = "DES_modular.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@IP = internal constant [64 x i32] [i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2, i32 60, i32 52, i32 44, i32 36, i32 28, i32 20, i32 12, i32 4, i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6, i32 64, i32 56, i32 48, i32 40, i32 32, i32 24, i32 16, i32 8, i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9, i32 1, i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3, i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5, i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7], align 16, !dbg !0
@FP = internal constant [64 x i32] [i32 40, i32 8, i32 48, i32 16, i32 56, i32 24, i32 64, i32 32, i32 39, i32 7, i32 47, i32 15, i32 55, i32 23, i32 63, i32 31, i32 38, i32 6, i32 46, i32 14, i32 54, i32 22, i32 62, i32 30, i32 37, i32 5, i32 45, i32 13, i32 53, i32 21, i32 61, i32 29, i32 36, i32 4, i32 44, i32 12, i32 52, i32 20, i32 60, i32 28, i32 35, i32 3, i32 43, i32 11, i32 51, i32 19, i32 59, i32 27, i32 34, i32 2, i32 42, i32 10, i32 50, i32 18, i32 58, i32 26, i32 33, i32 1, i32 41, i32 9, i32 49, i32 17, i32 57, i32 25], align 16, !dbg !49
@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"Ciphertext: 85E813540F0AB405\0A\00", align 1
@PC1 = internal constant [56 x i32] [i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9, i32 1, i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2, i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3, i32 60, i32 52, i32 44, i32 36, i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7, i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6, i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5, i32 28, i32 20, i32 12, i32 4], align 16, !dbg !15
@SHIFTS = internal constant [16 x i32] [i32 1, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1], align 16, !dbg !22
@PC2 = internal constant [48 x i32] [i32 14, i32 17, i32 11, i32 24, i32 1, i32 5, i32 3, i32 28, i32 15, i32 6, i32 21, i32 10, i32 23, i32 19, i32 12, i32 4, i32 26, i32 8, i32 16, i32 7, i32 27, i32 20, i32 13, i32 2, i32 41, i32 52, i32 31, i32 37, i32 47, i32 55, i32 30, i32 40, i32 51, i32 45, i32 33, i32 48, i32 44, i32 49, i32 39, i32 56, i32 34, i32 53, i32 46, i32 42, i32 50, i32 36, i32 29, i32 32], align 16, !dbg !27
@E = internal constant [48 x i32] [i32 32, i32 1, i32 2, i32 3, i32 4, i32 5, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 28, i32 29, i32 30, i32 31, i32 32, i32 1], align 16, !dbg !32
@SBOX = internal constant [8 x [64 x i8]] [[64 x i8] c"\0E\04\0D\01\02\0F\0B\08\03\0A\06\0C\05\09\00\07\00\0F\07\04\0E\02\0D\01\0A\06\0C\0B\09\05\03\08\04\01\0E\08\0D\06\02\0B\0F\0C\09\07\03\0A\05\00\0F\0C\08\02\04\09\01\07\05\0B\03\0E\0A\00\06\0D", [64 x i8] c"\0F\01\08\0E\06\0B\03\04\09\07\02\0D\0C\00\05\0A\03\0D\04\07\0F\02\08\0E\0C\00\01\0A\06\09\0B\05\00\0E\07\0B\0A\04\0D\01\05\08\0C\06\09\03\02\0F\0D\08\0A\01\03\0F\04\02\0B\06\07\0C\00\05\0E\09", [64 x i8] c"\0A\00\09\0E\06\03\0F\05\01\0D\0C\07\0B\04\02\08\0D\07\00\09\03\04\06\0A\02\08\05\0E\0C\0B\0F\01\0D\06\04\09\08\0F\03\00\0B\01\02\0C\05\0A\0E\07\01\0A\0D\00\06\09\08\07\04\0F\0E\03\0B\05\02\0C", [64 x i8] c"\07\0D\0E\03\00\06\09\0A\01\02\08\05\0B\0C\04\0F\0D\08\0B\05\06\0F\00\03\04\07\02\0C\01\0A\0E\09\0A\06\09\00\0C\0B\07\0D\0F\01\03\0E\05\02\08\04\03\0F\00\06\0A\01\0D\08\09\04\05\0B\0C\07\02\0E", [64 x i8] c"\02\0C\04\01\07\0A\0B\06\08\05\03\0F\0D\00\0E\09\0E\0B\02\0C\04\07\0D\01\05\00\0F\0A\03\09\08\06\04\02\01\0B\0A\0D\07\08\0F\09\0C\05\06\03\00\0E\0B\08\0C\07\01\0E\02\0D\06\0F\00\09\0A\04\05\03", [64 x i8] c"\0C\01\0A\0F\09\02\06\08\00\0D\03\04\0E\07\05\0B\0A\0F\04\02\07\0C\09\05\06\01\0D\0E\00\0B\03\08\09\0E\0F\05\02\08\0C\03\07\00\04\0A\01\0D\0B\06\04\03\02\0C\09\05\0F\0A\0B\0E\01\07\06\00\08\0D", [64 x i8] c"\04\0B\02\0E\0F\00\08\0D\03\0C\09\07\05\0A\06\01\0D\00\0B\07\04\09\01\0A\0E\03\05\0C\02\0F\08\06\01\04\0B\0D\0C\03\07\0E\0A\0F\06\08\00\05\09\02\06\0B\0D\08\01\04\0A\07\09\05\00\0F\0E\02\03\0C", [64 x i8] c"\0D\02\08\04\06\0F\0B\01\0A\09\03\0E\05\00\0C\07\01\0F\0D\08\0A\03\07\04\0C\05\06\0B\00\0E\09\02\07\0B\04\01\09\0C\0E\02\00\06\0A\0D\0F\03\05\08\02\01\0E\07\04\0A\08\0D\0F\0C\09\00\03\05\06\0B"], align 16, !dbg !34
@P = internal constant [32 x i32] [i32 16, i32 7, i32 20, i32 21, i32 29, i32 12, i32 28, i32 17, i32 1, i32 15, i32 23, i32 26, i32 5, i32 18, i32 31, i32 10, i32 2, i32 8, i32 24, i32 14, i32 32, i32 27, i32 3, i32 9, i32 19, i32 13, i32 30, i32 6, i32 22, i32 11, i32 4, i32 25], align 16, !dbg !44

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @des_encrypt(i64 noundef %plaintext, i64 noundef %key64) #0 !dbg !61 {
entry:
  %plaintext.addr = alloca i64, align 8
  %key64.addr = alloca i64, align 8
  %subkeys = alloca [16 x i64], align 16
  %ip = alloca i64, align 8
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  %r = alloca i32, align 4
  %f = alloca i32, align 4
  %newL = alloca i32, align 4
  %newR = alloca i32, align 4
  %preout = alloca i64, align 8
  %ct = alloca i64, align 8
  store i64 %plaintext, i64* %plaintext.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %plaintext.addr, metadata !65, metadata !DIExpression()), !dbg !66
  store i64 %key64, i64* %key64.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %key64.addr, metadata !67, metadata !DIExpression()), !dbg !68
  call void @llvm.dbg.declare(metadata [16 x i64]* %subkeys, metadata !69, metadata !DIExpression()), !dbg !71
  %0 = load i64, i64* %key64.addr, align 8, !dbg !72
  %arraydecay = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0, !dbg !73
  call void @key_schedule(i64 noundef %0, i64* noundef %arraydecay), !dbg !74
  call void @llvm.dbg.declare(metadata i64* %ip, metadata !75, metadata !DIExpression()), !dbg !76
  %1 = load i64, i64* %plaintext.addr, align 8, !dbg !77
  %call = call i64 @permute(i64 noundef %1, i32* noundef getelementptr inbounds ([64 x i32], [64 x i32]* @IP, i64 0, i64 0), i32 noundef 64, i32 noundef 64), !dbg !78
  store i64 %call, i64* %ip, align 8, !dbg !76
  call void @llvm.dbg.declare(metadata i32* %L, metadata !79, metadata !DIExpression()), !dbg !80
  %2 = load i64, i64* %ip, align 8, !dbg !81
  %shr = lshr i64 %2, 32, !dbg !82
  %conv = trunc i64 %shr to i32, !dbg !83
  store i32 %conv, i32* %L, align 4, !dbg !80
  call void @llvm.dbg.declare(metadata i32* %R, metadata !84, metadata !DIExpression()), !dbg !85
  %3 = load i64, i64* %ip, align 8, !dbg !86
  %and = and i64 %3, 4294967295, !dbg !87
  %conv1 = trunc i64 %and to i32, !dbg !88
  store i32 %conv1, i32* %R, align 4, !dbg !85
  call void @llvm.dbg.declare(metadata i32* %r, metadata !89, metadata !DIExpression()), !dbg !91
  store i32 0, i32* %r, align 4, !dbg !91
  br label %for.cond, !dbg !92

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i32, i32* %r, align 4, !dbg !93
  %cmp = icmp slt i32 %4, 16, !dbg !95
  br i1 %cmp, label %for.body, label %for.end, !dbg !96

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %f, metadata !97, metadata !DIExpression()), !dbg !99
  %5 = load i32, i32* %R, align 4, !dbg !100
  %6 = load i32, i32* %r, align 4, !dbg !101
  %idxprom = sext i32 %6 to i64, !dbg !102
  %arrayidx = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idxprom, !dbg !102
  %7 = load i64, i64* %arrayidx, align 8, !dbg !102
  %call3 = call i32 @feistel(i32 noundef %5, i64 noundef %7), !dbg !103
  store i32 %call3, i32* %f, align 4, !dbg !99
  call void @llvm.dbg.declare(metadata i32* %newL, metadata !104, metadata !DIExpression()), !dbg !105
  %8 = load i32, i32* %R, align 4, !dbg !106
  store i32 %8, i32* %newL, align 4, !dbg !105
  call void @llvm.dbg.declare(metadata i32* %newR, metadata !107, metadata !DIExpression()), !dbg !108
  %9 = load i32, i32* %L, align 4, !dbg !109
  %10 = load i32, i32* %f, align 4, !dbg !110
  %xor = xor i32 %9, %10, !dbg !111
  store i32 %xor, i32* %newR, align 4, !dbg !108
  %11 = load i32, i32* %newL, align 4, !dbg !112
  store i32 %11, i32* %L, align 4, !dbg !113
  %12 = load i32, i32* %newR, align 4, !dbg !114
  store i32 %12, i32* %R, align 4, !dbg !115
  br label %for.inc, !dbg !116

for.inc:                                          ; preds = %for.body
  %13 = load i32, i32* %r, align 4, !dbg !117
  %inc = add nsw i32 %13, 1, !dbg !117
  store i32 %inc, i32* %r, align 4, !dbg !117
  br label %for.cond, !dbg !118, !llvm.loop !119

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i64* %preout, metadata !122, metadata !DIExpression()), !dbg !123
  %14 = load i32, i32* %R, align 4, !dbg !124
  %conv4 = zext i32 %14 to i64, !dbg !125
  %shl = shl i64 %conv4, 32, !dbg !126
  %15 = load i32, i32* %L, align 4, !dbg !127
  %conv5 = zext i32 %15 to i64, !dbg !128
  %or = or i64 %shl, %conv5, !dbg !129
  store i64 %or, i64* %preout, align 8, !dbg !123
  call void @llvm.dbg.declare(metadata i64* %ct, metadata !130, metadata !DIExpression()), !dbg !131
  %16 = load i64, i64* %preout, align 8, !dbg !132
  %call6 = call i64 @permute(i64 noundef %16, i32* noundef getelementptr inbounds ([64 x i32], [64 x i32]* @FP, i64 0, i64 0), i32 noundef 64, i32 noundef 64), !dbg !133
  store i64 %call6, i64* %ct, align 8, !dbg !131
  %17 = load i64, i64* %ct, align 8, !dbg !134
  ret i64 %17, !dbg !135
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @key_schedule(i64 noundef %key64, i64* noundef %subkeys) #0 !dbg !136 {
entry:
  %key64.addr = alloca i64, align 8
  %subkeys.addr = alloca i64*, align 8
  %k56 = alloca i64, align 8
  %C = alloca i32, align 4
  %D = alloca i32, align 4
  %r = alloca i32, align 4
  %CD = alloca i64, align 8
  store i64 %key64, i64* %key64.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %key64.addr, metadata !140, metadata !DIExpression()), !dbg !141
  store i64* %subkeys, i64** %subkeys.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %subkeys.addr, metadata !142, metadata !DIExpression()), !dbg !143
  call void @llvm.dbg.declare(metadata i64* %k56, metadata !144, metadata !DIExpression()), !dbg !145
  %0 = load i64, i64* %key64.addr, align 8, !dbg !146
  %call = call i64 @permute(i64 noundef %0, i32* noundef getelementptr inbounds ([56 x i32], [56 x i32]* @PC1, i64 0, i64 0), i32 noundef 56, i32 noundef 64), !dbg !147
  store i64 %call, i64* %k56, align 8, !dbg !145
  call void @llvm.dbg.declare(metadata i32* %C, metadata !148, metadata !DIExpression()), !dbg !149
  %1 = load i64, i64* %k56, align 8, !dbg !150
  %shr = lshr i64 %1, 28, !dbg !151
  %and = and i64 %shr, 268435455, !dbg !152
  %conv = trunc i64 %and to i32, !dbg !153
  store i32 %conv, i32* %C, align 4, !dbg !149
  call void @llvm.dbg.declare(metadata i32* %D, metadata !154, metadata !DIExpression()), !dbg !155
  %2 = load i64, i64* %k56, align 8, !dbg !156
  %and1 = and i64 %2, 268435455, !dbg !157
  %conv2 = trunc i64 %and1 to i32, !dbg !158
  store i32 %conv2, i32* %D, align 4, !dbg !155
  call void @llvm.dbg.declare(metadata i32* %r, metadata !159, metadata !DIExpression()), !dbg !161
  store i32 0, i32* %r, align 4, !dbg !161
  br label %for.cond, !dbg !162

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32, i32* %r, align 4, !dbg !163
  %cmp = icmp slt i32 %3, 16, !dbg !165
  br i1 %cmp, label %for.body, label %for.end, !dbg !166

for.body:                                         ; preds = %for.cond
  %4 = load i32, i32* %C, align 4, !dbg !167
  %5 = load i32, i32* %r, align 4, !dbg !169
  %idxprom = sext i32 %5 to i64, !dbg !170
  %arrayidx = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idxprom, !dbg !170
  %6 = load i32, i32* %arrayidx, align 4, !dbg !170
  %call4 = call i32 @rotl28(i32 noundef %4, i32 noundef %6), !dbg !171
  store i32 %call4, i32* %C, align 4, !dbg !172
  %7 = load i32, i32* %D, align 4, !dbg !173
  %8 = load i32, i32* %r, align 4, !dbg !174
  %idxprom5 = sext i32 %8 to i64, !dbg !175
  %arrayidx6 = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idxprom5, !dbg !175
  %9 = load i32, i32* %arrayidx6, align 4, !dbg !175
  %call7 = call i32 @rotl28(i32 noundef %7, i32 noundef %9), !dbg !176
  store i32 %call7, i32* %D, align 4, !dbg !177
  call void @llvm.dbg.declare(metadata i64* %CD, metadata !178, metadata !DIExpression()), !dbg !179
  %10 = load i32, i32* %C, align 4, !dbg !180
  %conv8 = zext i32 %10 to i64, !dbg !181
  %shl = shl i64 %conv8, 28, !dbg !182
  %11 = load i32, i32* %D, align 4, !dbg !183
  %conv9 = zext i32 %11 to i64, !dbg !184
  %or = or i64 %shl, %conv9, !dbg !185
  store i64 %or, i64* %CD, align 8, !dbg !179
  %12 = load i64, i64* %CD, align 8, !dbg !186
  %call10 = call i64 @permute(i64 noundef %12, i32* noundef getelementptr inbounds ([48 x i32], [48 x i32]* @PC2, i64 0, i64 0), i32 noundef 48, i32 noundef 56), !dbg !187
  %13 = load i64*, i64** %subkeys.addr, align 8, !dbg !188
  %14 = load i32, i32* %r, align 4, !dbg !189
  %idxprom11 = sext i32 %14 to i64, !dbg !188
  %arrayidx12 = getelementptr inbounds i64, i64* %13, i64 %idxprom11, !dbg !188
  store i64 %call10, i64* %arrayidx12, align 8, !dbg !190
  br label %for.inc, !dbg !191

for.inc:                                          ; preds = %for.body
  %15 = load i32, i32* %r, align 4, !dbg !192
  %inc = add nsw i32 %15, 1, !dbg !192
  store i32 %inc, i32* %r, align 4, !dbg !192
  br label %for.cond, !dbg !193, !llvm.loop !194

for.end:                                          ; preds = %for.cond
  ret void, !dbg !196
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @permute(i64 noundef %in, i32* noundef %tbl, i32 noundef %outbits, i32 noundef %inbits) #0 !dbg !197 {
entry:
  %in.addr = alloca i64, align 8
  %tbl.addr = alloca i32*, align 8
  %outbits.addr = alloca i32, align 4
  %inbits.addr = alloca i32, align 4
  %out = alloca i64, align 8
  %i = alloca i32, align 4
  %src = alloca i32, align 4
  %shift = alloca i32, align 4
  %bit = alloca i64, align 8
  store i64 %in, i64* %in.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %in.addr, metadata !201, metadata !DIExpression()), !dbg !202
  store i32* %tbl, i32** %tbl.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %tbl.addr, metadata !203, metadata !DIExpression()), !dbg !204
  store i32 %outbits, i32* %outbits.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %outbits.addr, metadata !205, metadata !DIExpression()), !dbg !206
  store i32 %inbits, i32* %inbits.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %inbits.addr, metadata !207, metadata !DIExpression()), !dbg !208
  call void @llvm.dbg.declare(metadata i64* %out, metadata !209, metadata !DIExpression()), !dbg !210
  store i64 0, i64* %out, align 8, !dbg !210
  call void @llvm.dbg.declare(metadata i32* %i, metadata !211, metadata !DIExpression()), !dbg !213
  store i32 0, i32* %i, align 4, !dbg !213
  br label %for.cond, !dbg !214

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !215
  %1 = load i32, i32* %outbits.addr, align 4, !dbg !217
  %cmp = icmp slt i32 %0, %1, !dbg !218
  br i1 %cmp, label %for.body, label %for.end, !dbg !219

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %src, metadata !220, metadata !DIExpression()), !dbg !222
  %2 = load i32*, i32** %tbl.addr, align 8, !dbg !223
  %3 = load i32, i32* %i, align 4, !dbg !224
  %idxprom = sext i32 %3 to i64, !dbg !223
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %idxprom, !dbg !223
  %4 = load i32, i32* %arrayidx, align 4, !dbg !223
  store i32 %4, i32* %src, align 4, !dbg !222
  call void @llvm.dbg.declare(metadata i32* %shift, metadata !225, metadata !DIExpression()), !dbg !226
  %5 = load i32, i32* %inbits.addr, align 4, !dbg !227
  %6 = load i32, i32* %src, align 4, !dbg !228
  %sub = sub nsw i32 %5, %6, !dbg !229
  store i32 %sub, i32* %shift, align 4, !dbg !226
  call void @llvm.dbg.declare(metadata i64* %bit, metadata !230, metadata !DIExpression()), !dbg !231
  %7 = load i64, i64* %in.addr, align 8, !dbg !232
  %8 = load i32, i32* %shift, align 4, !dbg !233
  %sh_prom = zext i32 %8 to i64, !dbg !234
  %shr = lshr i64 %7, %sh_prom, !dbg !234
  %and = and i64 %shr, 1, !dbg !235
  store i64 %and, i64* %bit, align 8, !dbg !231
  %9 = load i64, i64* %out, align 8, !dbg !236
  %shl = shl i64 %9, 1, !dbg !237
  %10 = load i64, i64* %bit, align 8, !dbg !238
  %or = or i64 %shl, %10, !dbg !239
  store i64 %or, i64* %out, align 8, !dbg !240
  br label %for.inc, !dbg !241

for.inc:                                          ; preds = %for.body
  %11 = load i32, i32* %i, align 4, !dbg !242
  %inc = add nsw i32 %11, 1, !dbg !242
  store i32 %inc, i32* %i, align 4, !dbg !242
  br label %for.cond, !dbg !243, !llvm.loop !244

for.end:                                          ; preds = %for.cond
  %12 = load i64, i64* %out, align 8, !dbg !246
  ret i64 %12, !dbg !247
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @feistel(i32 noundef %R, i64 noundef %subkey48) #0 !dbg !248 {
entry:
  %R.addr = alloca i32, align 4
  %subkey48.addr = alloca i64, align 8
  %ER = alloca i64, align 8
  %x = alloca i64, align 8
  store i32 %R, i32* %R.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %R.addr, metadata !251, metadata !DIExpression()), !dbg !252
  store i64 %subkey48, i64* %subkey48.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %subkey48.addr, metadata !253, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.declare(metadata i64* %ER, metadata !255, metadata !DIExpression()), !dbg !256
  %0 = load i32, i32* %R.addr, align 4, !dbg !257
  %conv = zext i32 %0 to i64, !dbg !258
  %call = call i64 @permute(i64 noundef %conv, i32* noundef getelementptr inbounds ([48 x i32], [48 x i32]* @E, i64 0, i64 0), i32 noundef 48, i32 noundef 32), !dbg !259
  store i64 %call, i64* %ER, align 8, !dbg !256
  call void @llvm.dbg.declare(metadata i64* %x, metadata !260, metadata !DIExpression()), !dbg !261
  %1 = load i64, i64* %ER, align 8, !dbg !262
  %2 = load i64, i64* %subkey48.addr, align 8, !dbg !263
  %xor = xor i64 %1, %2, !dbg !264
  store i64 %xor, i64* %x, align 8, !dbg !261
  %3 = load i64, i64* %x, align 8, !dbg !265
  %call1 = call i32 @sboxes_p(i64 noundef %3), !dbg !266
  ret i32 %call1, !dbg !267
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !268 {
entry:
  %retval = alloca i32, align 4
  %key = alloca i64, align 8
  %plain = alloca i64, align 8
  %cipher = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i64* %key, metadata !271, metadata !DIExpression()), !dbg !272
  store i64 1383827165325090801, i64* %key, align 8, !dbg !272
  call void @llvm.dbg.declare(metadata i64* %plain, metadata !273, metadata !DIExpression()), !dbg !274
  store i64 81985529216486895, i64* %plain, align 8, !dbg !274
  call void @llvm.dbg.declare(metadata i64* %cipher, metadata !275, metadata !DIExpression()), !dbg !276
  %0 = load i64, i64* %plain, align 8, !dbg !277
  %1 = load i64, i64* %key, align 8, !dbg !278
  %call = call i64 @des_encrypt(i64 noundef %0, i64 noundef %1), !dbg !279
  store i64 %call, i64* %cipher, align 8, !dbg !276
  %2 = load i64, i64* %cipher, align 8, !dbg !280
  %call1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef %2), !dbg !281
  %call2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0)), !dbg !282
  ret i32 0, !dbg !283
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @rotl28(i32 noundef %v, i32 noundef %s) #0 !dbg !284 {
entry:
  %v.addr = alloca i32, align 4
  %s.addr = alloca i32, align 4
  store i32 %v, i32* %v.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %v.addr, metadata !287, metadata !DIExpression()), !dbg !288
  store i32 %s, i32* %s.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %s.addr, metadata !289, metadata !DIExpression()), !dbg !290
  %0 = load i32, i32* %v.addr, align 4, !dbg !291
  %and = and i32 %0, 268435455, !dbg !291
  store i32 %and, i32* %v.addr, align 4, !dbg !291
  %1 = load i32, i32* %v.addr, align 4, !dbg !292
  %2 = load i32, i32* %s.addr, align 4, !dbg !293
  %shl = shl i32 %1, %2, !dbg !294
  %3 = load i32, i32* %v.addr, align 4, !dbg !295
  %4 = load i32, i32* %s.addr, align 4, !dbg !296
  %sub = sub nsw i32 28, %4, !dbg !297
  %shr = lshr i32 %3, %sub, !dbg !298
  %or = or i32 %shl, %shr, !dbg !299
  %and1 = and i32 %or, 268435455, !dbg !300
  ret i32 %and1, !dbg !301
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @sboxes_p(i64 noundef %x48) #0 !dbg !302 {
entry:
  %x48.addr = alloca i64, align 8
  %out32 = alloca i32, align 4
  %b = alloca i32, align 4
  %shift = alloca i32, align 4
  %chunk = alloca i8, align 1
  %row = alloca i32, align 4
  %col = alloca i32, align 4
  %s = alloca i8, align 1
  store i64 %x48, i64* %x48.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %x48.addr, metadata !305, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.declare(metadata i32* %out32, metadata !307, metadata !DIExpression()), !dbg !308
  store i32 0, i32* %out32, align 4, !dbg !308
  call void @llvm.dbg.declare(metadata i32* %b, metadata !309, metadata !DIExpression()), !dbg !311
  store i32 0, i32* %b, align 4, !dbg !311
  br label %for.cond, !dbg !312

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %b, align 4, !dbg !313
  %cmp = icmp slt i32 %0, 8, !dbg !315
  br i1 %cmp, label %for.body, label %for.end, !dbg !316

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %shift, metadata !317, metadata !DIExpression()), !dbg !319
  %1 = load i32, i32* %b, align 4, !dbg !320
  %mul = mul nsw i32 6, %1, !dbg !321
  %sub = sub nsw i32 42, %mul, !dbg !322
  store i32 %sub, i32* %shift, align 4, !dbg !319
  call void @llvm.dbg.declare(metadata i8* %chunk, metadata !323, metadata !DIExpression()), !dbg !324
  %2 = load i64, i64* %x48.addr, align 8, !dbg !325
  %3 = load i32, i32* %shift, align 4, !dbg !326
  %sh_prom = zext i32 %3 to i64, !dbg !327
  %shr = lshr i64 %2, %sh_prom, !dbg !327
  %and = and i64 %shr, 63, !dbg !328
  %conv = trunc i64 %and to i8, !dbg !329
  store i8 %conv, i8* %chunk, align 1, !dbg !324
  call void @llvm.dbg.declare(metadata i32* %row, metadata !330, metadata !DIExpression()), !dbg !331
  %4 = load i8, i8* %chunk, align 1, !dbg !332
  %conv1 = zext i8 %4 to i32, !dbg !332
  %and2 = and i32 %conv1, 32, !dbg !333
  %shr3 = ashr i32 %and2, 4, !dbg !334
  %5 = load i8, i8* %chunk, align 1, !dbg !335
  %conv4 = zext i8 %5 to i32, !dbg !335
  %and5 = and i32 %conv4, 1, !dbg !336
  %or = or i32 %shr3, %and5, !dbg !337
  store i32 %or, i32* %row, align 4, !dbg !331
  call void @llvm.dbg.declare(metadata i32* %col, metadata !338, metadata !DIExpression()), !dbg !339
  %6 = load i8, i8* %chunk, align 1, !dbg !340
  %conv6 = zext i8 %6 to i32, !dbg !340
  %shr7 = ashr i32 %conv6, 1, !dbg !341
  %and8 = and i32 %shr7, 15, !dbg !342
  store i32 %and8, i32* %col, align 4, !dbg !339
  call void @llvm.dbg.declare(metadata i8* %s, metadata !343, metadata !DIExpression()), !dbg !344
  %7 = load i32, i32* %b, align 4, !dbg !345
  %idxprom = sext i32 %7 to i64, !dbg !346
  %arrayidx = getelementptr inbounds [8 x [64 x i8]], [8 x [64 x i8]]* @SBOX, i64 0, i64 %idxprom, !dbg !346
  %8 = load i32, i32* %row, align 4, !dbg !347
  %mul9 = mul nsw i32 %8, 16, !dbg !348
  %9 = load i32, i32* %col, align 4, !dbg !349
  %add = add nsw i32 %mul9, %9, !dbg !350
  %idxprom10 = sext i32 %add to i64, !dbg !346
  %arrayidx11 = getelementptr inbounds [64 x i8], [64 x i8]* %arrayidx, i64 0, i64 %idxprom10, !dbg !346
  %10 = load i8, i8* %arrayidx11, align 1, !dbg !346
  store i8 %10, i8* %s, align 1, !dbg !344
  %11 = load i32, i32* %out32, align 4, !dbg !351
  %shl = shl i32 %11, 4, !dbg !352
  %12 = load i8, i8* %s, align 1, !dbg !353
  %conv12 = zext i8 %12 to i32, !dbg !353
  %or13 = or i32 %shl, %conv12, !dbg !354
  store i32 %or13, i32* %out32, align 4, !dbg !355
  br label %for.inc, !dbg !356

for.inc:                                          ; preds = %for.body
  %13 = load i32, i32* %b, align 4, !dbg !357
  %inc = add nsw i32 %13, 1, !dbg !357
  store i32 %inc, i32* %b, align 4, !dbg !357
  br label %for.cond, !dbg !358, !llvm.loop !359

for.end:                                          ; preds = %for.cond
  %14 = load i32, i32* %out32, align 4, !dbg !361
  %conv14 = zext i32 %14 to i64, !dbg !361
  %call = call i64 @permute(i64 noundef %conv14, i32* noundef getelementptr inbounds ([32 x i32], [32 x i32]* @P, i64 0, i64 0), i32 noundef 32, i32 noundef 32), !dbg !362
  %conv15 = trunc i64 %call to i32, !dbg !363
  ret i32 %conv15, !dbg !364
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "IP", scope: !2, file: !3, line: 4, type: !51, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "DES_modular.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/original/src", checksumkind: CSK_MD5, checksum: "6033abe4be3b56e79330164c2b87a32d")
!4 = !{!5, !10, !13}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !6, line: 26, baseType: !7)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !8, line: 42, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!9 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !6, line: 27, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !8, line: 45, baseType: !12)
!12 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!13 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!14 = !{!15, !22, !27, !0, !32, !34, !44, !49}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "PC1", scope: !2, file: !3, line: 30, type: !17, isLocal: true, isDefinition: true)
!17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 1792, elements: !20)
!18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !{!21}
!21 = !DISubrange(count: 56)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "SHIFTS", scope: !2, file: !3, line: 44, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 512, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 16)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "PC2", scope: !2, file: !3, line: 37, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 1536, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 48)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "E", scope: !2, file: !3, line: 18, type: !29, isLocal: true, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "SBOX", scope: !2, file: !3, line: 47, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 4096, elements: !41)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !6, line: 24, baseType: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !8, line: 38, baseType: !40)
!40 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!41 = !{!42, !43}
!42 = !DISubrange(count: 8)
!43 = !DISubrange(count: 64)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "P", scope: !2, file: !3, line: 25, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 1024, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 32)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "FP", scope: !2, file: !3, line: 11, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 2048, elements: !52)
!52 = !{!43}
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 7, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 1}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!61 = distinct !DISubprogram(name: "des_encrypt", scope: !3, file: !3, line: 146, type: !62, scopeLine: 146, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{!10, !10, !10}
!64 = !{}
!65 = !DILocalVariable(name: "plaintext", arg: 1, scope: !61, file: !3, line: 146, type: !10)
!66 = !DILocation(line: 146, column: 31, scope: !61)
!67 = !DILocalVariable(name: "key64", arg: 2, scope: !61, file: !3, line: 146, type: !10)
!68 = !DILocation(line: 146, column: 51, scope: !61)
!69 = !DILocalVariable(name: "subkeys", scope: !61, file: !3, line: 147, type: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 1024, elements: !25)
!71 = !DILocation(line: 147, column: 14, scope: !61)
!72 = !DILocation(line: 148, column: 18, scope: !61)
!73 = !DILocation(line: 148, column: 25, scope: !61)
!74 = !DILocation(line: 148, column: 5, scope: !61)
!75 = !DILocalVariable(name: "ip", scope: !61, file: !3, line: 150, type: !10)
!76 = !DILocation(line: 150, column: 14, scope: !61)
!77 = !DILocation(line: 150, column: 27, scope: !61)
!78 = !DILocation(line: 150, column: 19, scope: !61)
!79 = !DILocalVariable(name: "L", scope: !61, file: !3, line: 151, type: !5)
!80 = !DILocation(line: 151, column: 14, scope: !61)
!81 = !DILocation(line: 151, column: 29, scope: !61)
!82 = !DILocation(line: 151, column: 32, scope: !61)
!83 = !DILocation(line: 151, column: 18, scope: !61)
!84 = !DILocalVariable(name: "R", scope: !61, file: !3, line: 152, type: !5)
!85 = !DILocation(line: 152, column: 14, scope: !61)
!86 = !DILocation(line: 152, column: 29, scope: !61)
!87 = !DILocation(line: 152, column: 32, scope: !61)
!88 = !DILocation(line: 152, column: 18, scope: !61)
!89 = !DILocalVariable(name: "r", scope: !90, file: !3, line: 154, type: !19)
!90 = distinct !DILexicalBlock(scope: !61, file: !3, line: 154, column: 5)
!91 = !DILocation(line: 154, column: 14, scope: !90)
!92 = !DILocation(line: 154, column: 10, scope: !90)
!93 = !DILocation(line: 154, column: 21, scope: !94)
!94 = distinct !DILexicalBlock(scope: !90, file: !3, line: 154, column: 5)
!95 = !DILocation(line: 154, column: 23, scope: !94)
!96 = !DILocation(line: 154, column: 5, scope: !90)
!97 = !DILocalVariable(name: "f", scope: !98, file: !3, line: 155, type: !5)
!98 = distinct !DILexicalBlock(scope: !94, file: !3, line: 154, column: 34)
!99 = !DILocation(line: 155, column: 18, scope: !98)
!100 = !DILocation(line: 155, column: 30, scope: !98)
!101 = !DILocation(line: 155, column: 41, scope: !98)
!102 = !DILocation(line: 155, column: 33, scope: !98)
!103 = !DILocation(line: 155, column: 22, scope: !98)
!104 = !DILocalVariable(name: "newL", scope: !98, file: !3, line: 156, type: !5)
!105 = !DILocation(line: 156, column: 18, scope: !98)
!106 = !DILocation(line: 156, column: 25, scope: !98)
!107 = !DILocalVariable(name: "newR", scope: !98, file: !3, line: 157, type: !5)
!108 = !DILocation(line: 157, column: 18, scope: !98)
!109 = !DILocation(line: 157, column: 25, scope: !98)
!110 = !DILocation(line: 157, column: 29, scope: !98)
!111 = !DILocation(line: 157, column: 27, scope: !98)
!112 = !DILocation(line: 158, column: 13, scope: !98)
!113 = !DILocation(line: 158, column: 11, scope: !98)
!114 = !DILocation(line: 158, column: 23, scope: !98)
!115 = !DILocation(line: 158, column: 21, scope: !98)
!116 = !DILocation(line: 159, column: 5, scope: !98)
!117 = !DILocation(line: 154, column: 29, scope: !94)
!118 = !DILocation(line: 154, column: 5, scope: !94)
!119 = distinct !{!119, !96, !120, !121}
!120 = !DILocation(line: 159, column: 5, scope: !90)
!121 = !{!"llvm.loop.mustprogress"}
!122 = !DILocalVariable(name: "preout", scope: !61, file: !3, line: 161, type: !10)
!123 = !DILocation(line: 161, column: 14, scope: !61)
!124 = !DILocation(line: 161, column: 35, scope: !61)
!125 = !DILocation(line: 161, column: 25, scope: !61)
!126 = !DILocation(line: 161, column: 38, scope: !61)
!127 = !DILocation(line: 161, column: 57, scope: !61)
!128 = !DILocation(line: 161, column: 47, scope: !61)
!129 = !DILocation(line: 161, column: 45, scope: !61)
!130 = !DILocalVariable(name: "ct", scope: !61, file: !3, line: 162, type: !10)
!131 = !DILocation(line: 162, column: 14, scope: !61)
!132 = !DILocation(line: 162, column: 27, scope: !61)
!133 = !DILocation(line: 162, column: 19, scope: !61)
!134 = !DILocation(line: 163, column: 12, scope: !61)
!135 = !DILocation(line: 163, column: 5, scope: !61)
!136 = distinct !DISubprogram(name: "key_schedule", scope: !3, file: !3, line: 133, type: !137, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !64)
!137 = !DISubroutineType(types: !138)
!138 = !{null, !10, !139}
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!140 = !DILocalVariable(name: "key64", arg: 1, scope: !136, file: !3, line: 133, type: !10)
!141 = !DILocation(line: 133, column: 35, scope: !136)
!142 = !DILocalVariable(name: "subkeys", arg: 2, scope: !136, file: !3, line: 133, type: !139)
!143 = !DILocation(line: 133, column: 51, scope: !136)
!144 = !DILocalVariable(name: "k56", scope: !136, file: !3, line: 134, type: !10)
!145 = !DILocation(line: 134, column: 14, scope: !136)
!146 = !DILocation(line: 134, column: 28, scope: !136)
!147 = !DILocation(line: 134, column: 20, scope: !136)
!148 = !DILocalVariable(name: "C", scope: !136, file: !3, line: 135, type: !5)
!149 = !DILocation(line: 135, column: 14, scope: !136)
!150 = !DILocation(line: 135, column: 30, scope: !136)
!151 = !DILocation(line: 135, column: 34, scope: !136)
!152 = !DILocation(line: 135, column: 41, scope: !136)
!153 = !DILocation(line: 135, column: 18, scope: !136)
!154 = !DILocalVariable(name: "D", scope: !136, file: !3, line: 136, type: !5)
!155 = !DILocation(line: 136, column: 14, scope: !136)
!156 = !DILocation(line: 136, column: 30, scope: !136)
!157 = !DILocation(line: 136, column: 41, scope: !136)
!158 = !DILocation(line: 136, column: 18, scope: !136)
!159 = !DILocalVariable(name: "r", scope: !160, file: !3, line: 138, type: !19)
!160 = distinct !DILexicalBlock(scope: !136, file: !3, line: 138, column: 5)
!161 = !DILocation(line: 138, column: 14, scope: !160)
!162 = !DILocation(line: 138, column: 10, scope: !160)
!163 = !DILocation(line: 138, column: 21, scope: !164)
!164 = distinct !DILexicalBlock(scope: !160, file: !3, line: 138, column: 5)
!165 = !DILocation(line: 138, column: 23, scope: !164)
!166 = !DILocation(line: 138, column: 5, scope: !160)
!167 = !DILocation(line: 139, column: 20, scope: !168)
!168 = distinct !DILexicalBlock(scope: !164, file: !3, line: 138, column: 34)
!169 = !DILocation(line: 139, column: 30, scope: !168)
!170 = !DILocation(line: 139, column: 23, scope: !168)
!171 = !DILocation(line: 139, column: 13, scope: !168)
!172 = !DILocation(line: 139, column: 11, scope: !168)
!173 = !DILocation(line: 140, column: 20, scope: !168)
!174 = !DILocation(line: 140, column: 30, scope: !168)
!175 = !DILocation(line: 140, column: 23, scope: !168)
!176 = !DILocation(line: 140, column: 13, scope: !168)
!177 = !DILocation(line: 140, column: 11, scope: !168)
!178 = !DILocalVariable(name: "CD", scope: !168, file: !3, line: 141, type: !10)
!179 = !DILocation(line: 141, column: 18, scope: !168)
!180 = !DILocation(line: 141, column: 35, scope: !168)
!181 = !DILocation(line: 141, column: 25, scope: !168)
!182 = !DILocation(line: 141, column: 38, scope: !168)
!183 = !DILocation(line: 141, column: 57, scope: !168)
!184 = !DILocation(line: 141, column: 47, scope: !168)
!185 = !DILocation(line: 141, column: 45, scope: !168)
!186 = !DILocation(line: 142, column: 30, scope: !168)
!187 = !DILocation(line: 142, column: 22, scope: !168)
!188 = !DILocation(line: 142, column: 9, scope: !168)
!189 = !DILocation(line: 142, column: 17, scope: !168)
!190 = !DILocation(line: 142, column: 20, scope: !168)
!191 = !DILocation(line: 143, column: 5, scope: !168)
!192 = !DILocation(line: 138, column: 29, scope: !164)
!193 = !DILocation(line: 138, column: 5, scope: !164)
!194 = distinct !{!194, !166, !195, !121}
!195 = !DILocation(line: 143, column: 5, scope: !160)
!196 = !DILocation(line: 144, column: 1, scope: !136)
!197 = distinct !DISubprogram(name: "permute", scope: !3, file: !3, line: 98, type: !198, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !64)
!198 = !DISubroutineType(types: !199)
!199 = !{!10, !10, !200, !19, !19}
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!201 = !DILocalVariable(name: "in", arg: 1, scope: !197, file: !3, line: 98, type: !10)
!202 = !DILocation(line: 98, column: 41, scope: !197)
!203 = !DILocalVariable(name: "tbl", arg: 2, scope: !197, file: !3, line: 98, type: !200)
!204 = !DILocation(line: 98, column: 56, scope: !197)
!205 = !DILocalVariable(name: "outbits", arg: 3, scope: !197, file: !3, line: 98, type: !19)
!206 = !DILocation(line: 98, column: 65, scope: !197)
!207 = !DILocalVariable(name: "inbits", arg: 4, scope: !197, file: !3, line: 98, type: !19)
!208 = !DILocation(line: 98, column: 78, scope: !197)
!209 = !DILocalVariable(name: "out", scope: !197, file: !3, line: 99, type: !10)
!210 = !DILocation(line: 99, column: 14, scope: !197)
!211 = !DILocalVariable(name: "i", scope: !212, file: !3, line: 100, type: !19)
!212 = distinct !DILexicalBlock(scope: !197, file: !3, line: 100, column: 5)
!213 = !DILocation(line: 100, column: 14, scope: !212)
!214 = !DILocation(line: 100, column: 10, scope: !212)
!215 = !DILocation(line: 100, column: 21, scope: !216)
!216 = distinct !DILexicalBlock(scope: !212, file: !3, line: 100, column: 5)
!217 = !DILocation(line: 100, column: 25, scope: !216)
!218 = !DILocation(line: 100, column: 23, scope: !216)
!219 = !DILocation(line: 100, column: 5, scope: !212)
!220 = !DILocalVariable(name: "src", scope: !221, file: !3, line: 101, type: !19)
!221 = distinct !DILexicalBlock(scope: !216, file: !3, line: 100, column: 39)
!222 = !DILocation(line: 101, column: 13, scope: !221)
!223 = !DILocation(line: 101, column: 19, scope: !221)
!224 = !DILocation(line: 101, column: 23, scope: !221)
!225 = !DILocalVariable(name: "shift", scope: !221, file: !3, line: 102, type: !19)
!226 = !DILocation(line: 102, column: 13, scope: !221)
!227 = !DILocation(line: 102, column: 21, scope: !221)
!228 = !DILocation(line: 102, column: 30, scope: !221)
!229 = !DILocation(line: 102, column: 28, scope: !221)
!230 = !DILocalVariable(name: "bit", scope: !221, file: !3, line: 103, type: !10)
!231 = !DILocation(line: 103, column: 18, scope: !221)
!232 = !DILocation(line: 103, column: 25, scope: !221)
!233 = !DILocation(line: 103, column: 31, scope: !221)
!234 = !DILocation(line: 103, column: 28, scope: !221)
!235 = !DILocation(line: 103, column: 38, scope: !221)
!236 = !DILocation(line: 104, column: 16, scope: !221)
!237 = !DILocation(line: 104, column: 20, scope: !221)
!238 = !DILocation(line: 104, column: 28, scope: !221)
!239 = !DILocation(line: 104, column: 26, scope: !221)
!240 = !DILocation(line: 104, column: 13, scope: !221)
!241 = !DILocation(line: 105, column: 5, scope: !221)
!242 = !DILocation(line: 100, column: 34, scope: !216)
!243 = !DILocation(line: 100, column: 5, scope: !216)
!244 = distinct !{!244, !219, !245, !121}
!245 = !DILocation(line: 105, column: 5, scope: !212)
!246 = !DILocation(line: 106, column: 12, scope: !197)
!247 = !DILocation(line: 106, column: 5, scope: !197)
!248 = distinct !DISubprogram(name: "feistel", scope: !3, file: !3, line: 127, type: !249, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !64)
!249 = !DISubroutineType(types: !250)
!250 = !{!5, !5, !10}
!251 = !DILocalVariable(name: "R", arg: 1, scope: !248, file: !3, line: 127, type: !5)
!252 = !DILocation(line: 127, column: 41, scope: !248)
!253 = !DILocalVariable(name: "subkey48", arg: 2, scope: !248, file: !3, line: 127, type: !10)
!254 = !DILocation(line: 127, column: 53, scope: !248)
!255 = !DILocalVariable(name: "ER", scope: !248, file: !3, line: 128, type: !10)
!256 = !DILocation(line: 128, column: 14, scope: !248)
!257 = !DILocation(line: 128, column: 37, scope: !248)
!258 = !DILocation(line: 128, column: 27, scope: !248)
!259 = !DILocation(line: 128, column: 19, scope: !248)
!260 = !DILocalVariable(name: "x", scope: !248, file: !3, line: 129, type: !10)
!261 = !DILocation(line: 129, column: 14, scope: !248)
!262 = !DILocation(line: 129, column: 18, scope: !248)
!263 = !DILocation(line: 129, column: 23, scope: !248)
!264 = !DILocation(line: 129, column: 21, scope: !248)
!265 = !DILocation(line: 130, column: 21, scope: !248)
!266 = !DILocation(line: 130, column: 12, scope: !248)
!267 = !DILocation(line: 130, column: 5, scope: !248)
!268 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 166, type: !269, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!269 = !DISubroutineType(types: !270)
!270 = !{!19}
!271 = !DILocalVariable(name: "key", scope: !268, file: !3, line: 167, type: !10)
!272 = !DILocation(line: 167, column: 14, scope: !268)
!273 = !DILocalVariable(name: "plain", scope: !268, file: !3, line: 168, type: !10)
!274 = !DILocation(line: 168, column: 14, scope: !268)
!275 = !DILocalVariable(name: "cipher", scope: !268, file: !3, line: 170, type: !10)
!276 = !DILocation(line: 170, column: 14, scope: !268)
!277 = !DILocation(line: 170, column: 35, scope: !268)
!278 = !DILocation(line: 170, column: 42, scope: !268)
!279 = !DILocation(line: 170, column: 23, scope: !268)
!280 = !DILocation(line: 172, column: 57, scope: !268)
!281 = !DILocation(line: 172, column: 5, scope: !268)
!282 = !DILocation(line: 174, column: 5, scope: !268)
!283 = !DILocation(line: 175, column: 5, scope: !268)
!284 = distinct !DISubprogram(name: "rotl28", scope: !3, file: !3, line: 109, type: !285, scopeLine: 109, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !64)
!285 = !DISubroutineType(types: !286)
!286 = !{!5, !5, !19}
!287 = !DILocalVariable(name: "v", arg: 1, scope: !284, file: !3, line: 109, type: !5)
!288 = !DILocation(line: 109, column: 40, scope: !284)
!289 = !DILocalVariable(name: "s", arg: 2, scope: !284, file: !3, line: 109, type: !19)
!290 = !DILocation(line: 109, column: 47, scope: !284)
!291 = !DILocation(line: 110, column: 7, scope: !284)
!292 = !DILocation(line: 111, column: 14, scope: !284)
!293 = !DILocation(line: 111, column: 19, scope: !284)
!294 = !DILocation(line: 111, column: 16, scope: !284)
!295 = !DILocation(line: 111, column: 25, scope: !284)
!296 = !DILocation(line: 111, column: 36, scope: !284)
!297 = !DILocation(line: 111, column: 34, scope: !284)
!298 = !DILocation(line: 111, column: 27, scope: !284)
!299 = !DILocation(line: 111, column: 22, scope: !284)
!300 = !DILocation(line: 111, column: 41, scope: !284)
!301 = !DILocation(line: 111, column: 5, scope: !284)
!302 = distinct !DISubprogram(name: "sboxes_p", scope: !3, file: !3, line: 114, type: !303, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !64)
!303 = !DISubroutineType(types: !304)
!304 = !{!5, !10}
!305 = !DILocalVariable(name: "x48", arg: 1, scope: !302, file: !3, line: 114, type: !10)
!306 = !DILocation(line: 114, column: 35, scope: !302)
!307 = !DILocalVariable(name: "out32", scope: !302, file: !3, line: 115, type: !5)
!308 = !DILocation(line: 115, column: 14, scope: !302)
!309 = !DILocalVariable(name: "b", scope: !310, file: !3, line: 116, type: !19)
!310 = distinct !DILexicalBlock(scope: !302, file: !3, line: 116, column: 5)
!311 = !DILocation(line: 116, column: 14, scope: !310)
!312 = !DILocation(line: 116, column: 10, scope: !310)
!313 = !DILocation(line: 116, column: 21, scope: !314)
!314 = distinct !DILexicalBlock(scope: !310, file: !3, line: 116, column: 5)
!315 = !DILocation(line: 116, column: 23, scope: !314)
!316 = !DILocation(line: 116, column: 5, scope: !310)
!317 = !DILocalVariable(name: "shift", scope: !318, file: !3, line: 117, type: !19)
!318 = distinct !DILexicalBlock(scope: !314, file: !3, line: 116, column: 33)
!319 = !DILocation(line: 117, column: 13, scope: !318)
!320 = !DILocation(line: 117, column: 28, scope: !318)
!321 = !DILocation(line: 117, column: 27, scope: !318)
!322 = !DILocation(line: 117, column: 24, scope: !318)
!323 = !DILocalVariable(name: "chunk", scope: !318, file: !3, line: 118, type: !38)
!324 = !DILocation(line: 118, column: 17, scope: !318)
!325 = !DILocation(line: 118, column: 26, scope: !318)
!326 = !DILocation(line: 118, column: 33, scope: !318)
!327 = !DILocation(line: 118, column: 30, scope: !318)
!328 = !DILocation(line: 118, column: 40, scope: !318)
!329 = !DILocation(line: 118, column: 25, scope: !318)
!330 = !DILocalVariable(name: "row", scope: !318, file: !3, line: 119, type: !19)
!331 = !DILocation(line: 119, column: 13, scope: !318)
!332 = !DILocation(line: 119, column: 21, scope: !318)
!333 = !DILocation(line: 119, column: 27, scope: !318)
!334 = !DILocation(line: 119, column: 35, scope: !318)
!335 = !DILocation(line: 119, column: 44, scope: !318)
!336 = !DILocation(line: 119, column: 50, scope: !318)
!337 = !DILocation(line: 119, column: 41, scope: !318)
!338 = !DILocalVariable(name: "col", scope: !318, file: !3, line: 120, type: !19)
!339 = !DILocation(line: 120, column: 13, scope: !318)
!340 = !DILocation(line: 120, column: 20, scope: !318)
!341 = !DILocation(line: 120, column: 26, scope: !318)
!342 = !DILocation(line: 120, column: 32, scope: !318)
!343 = !DILocalVariable(name: "s", scope: !318, file: !3, line: 121, type: !38)
!344 = !DILocation(line: 121, column: 17, scope: !318)
!345 = !DILocation(line: 121, column: 26, scope: !318)
!346 = !DILocation(line: 121, column: 21, scope: !318)
!347 = !DILocation(line: 121, column: 29, scope: !318)
!348 = !DILocation(line: 121, column: 32, scope: !318)
!349 = !DILocation(line: 121, column: 38, scope: !318)
!350 = !DILocation(line: 121, column: 36, scope: !318)
!351 = !DILocation(line: 122, column: 18, scope: !318)
!352 = !DILocation(line: 122, column: 24, scope: !318)
!353 = !DILocation(line: 122, column: 32, scope: !318)
!354 = !DILocation(line: 122, column: 30, scope: !318)
!355 = !DILocation(line: 122, column: 15, scope: !318)
!356 = !DILocation(line: 123, column: 5, scope: !318)
!357 = !DILocation(line: 116, column: 28, scope: !314)
!358 = !DILocation(line: 116, column: 5, scope: !314)
!359 = distinct !{!359, !316, !360, !121}
!360 = !DILocation(line: 123, column: 5, scope: !310)
!361 = !DILocation(line: 124, column: 30, scope: !302)
!362 = !DILocation(line: 124, column: 22, scope: !302)
!363 = !DILocation(line: 124, column: 12, scope: !302)
!364 = !DILocation(line: 124, column: 5, scope: !302)

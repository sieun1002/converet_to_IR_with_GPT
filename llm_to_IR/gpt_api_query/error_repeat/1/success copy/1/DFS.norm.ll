; ModuleID = '../..//original/ll/DFS.ll'
source_filename = "../original/src/DFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !17 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i64, align 8
  %g = alloca [49 x i32], align 16
  %s = alloca i64, align 8
  %order = alloca [7 x i64], align 16
  %ord_len = alloca i64, align 8
  %i = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i64* %n, metadata !21, metadata !DIExpression()), !dbg !22
  store i64 7, i64* %n, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata [49 x i32]* %g, metadata !23, metadata !DIExpression()), !dbg !27
  %0 = bitcast [49 x i32]* %g to i8*, !dbg !27
  call void @llvm.memset.p0i8.i64(i8* align 16 %0, i8 0, i64 196, i1 false), !dbg !27
  br label %do.body, !dbg !28

do.body:                                          ; preds = %entry
  %1 = load i64, i64* %n, align 8, !dbg !29
  %mul = mul i64 0, %1, !dbg !29
  %add = add i64 %mul, 1, !dbg !29
  %arrayidx = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add, !dbg !29
  store i32 1, i32* %arrayidx, align 4, !dbg !29
  %2 = load i64, i64* %n, align 8, !dbg !29
  %mul1 = mul i64 1, %2, !dbg !29
  %add2 = add i64 %mul1, 0, !dbg !29
  %arrayidx3 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add2, !dbg !29
  store i32 1, i32* %arrayidx3, align 4, !dbg !29
  br label %do.end, !dbg !29

do.end:                                           ; preds = %do.body
  br label %do.body4, !dbg !31

do.body4:                                         ; preds = %do.end
  %3 = load i64, i64* %n, align 8, !dbg !32
  %mul5 = mul i64 0, %3, !dbg !32
  %add6 = add i64 %mul5, 2, !dbg !32
  %arrayidx7 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add6, !dbg !32
  store i32 1, i32* %arrayidx7, align 4, !dbg !32
  %4 = load i64, i64* %n, align 8, !dbg !32
  %mul8 = mul i64 2, %4, !dbg !32
  %add9 = add i64 %mul8, 0, !dbg !32
  %arrayidx10 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add9, !dbg !32
  store i32 1, i32* %arrayidx10, align 4, !dbg !32
  br label %do.end11, !dbg !32

do.end11:                                         ; preds = %do.body4
  br label %do.body12, !dbg !34

do.body12:                                        ; preds = %do.end11
  %5 = load i64, i64* %n, align 8, !dbg !35
  %mul13 = mul i64 1, %5, !dbg !35
  %add14 = add i64 %mul13, 3, !dbg !35
  %arrayidx15 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add14, !dbg !35
  store i32 1, i32* %arrayidx15, align 4, !dbg !35
  %6 = load i64, i64* %n, align 8, !dbg !35
  %mul16 = mul i64 3, %6, !dbg !35
  %add17 = add i64 %mul16, 1, !dbg !35
  %arrayidx18 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add17, !dbg !35
  store i32 1, i32* %arrayidx18, align 4, !dbg !35
  br label %do.end19, !dbg !35

do.end19:                                         ; preds = %do.body12
  br label %do.body20, !dbg !37

do.body20:                                        ; preds = %do.end19
  %7 = load i64, i64* %n, align 8, !dbg !38
  %mul21 = mul i64 1, %7, !dbg !38
  %add22 = add i64 %mul21, 4, !dbg !38
  %arrayidx23 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add22, !dbg !38
  store i32 1, i32* %arrayidx23, align 4, !dbg !38
  %8 = load i64, i64* %n, align 8, !dbg !38
  %mul24 = mul i64 4, %8, !dbg !38
  %add25 = add i64 %mul24, 1, !dbg !38
  %arrayidx26 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add25, !dbg !38
  store i32 1, i32* %arrayidx26, align 4, !dbg !38
  br label %do.end27, !dbg !38

do.end27:                                         ; preds = %do.body20
  br label %do.body28, !dbg !40

do.body28:                                        ; preds = %do.end27
  %9 = load i64, i64* %n, align 8, !dbg !41
  %mul29 = mul i64 2, %9, !dbg !41
  %add30 = add i64 %mul29, 5, !dbg !41
  %arrayidx31 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add30, !dbg !41
  store i32 1, i32* %arrayidx31, align 4, !dbg !41
  %10 = load i64, i64* %n, align 8, !dbg !41
  %mul32 = mul i64 5, %10, !dbg !41
  %add33 = add i64 %mul32, 2, !dbg !41
  %arrayidx34 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add33, !dbg !41
  store i32 1, i32* %arrayidx34, align 4, !dbg !41
  br label %do.end35, !dbg !41

do.end35:                                         ; preds = %do.body28
  br label %do.body36, !dbg !43

do.body36:                                        ; preds = %do.end35
  %11 = load i64, i64* %n, align 8, !dbg !44
  %mul37 = mul i64 4, %11, !dbg !44
  %add38 = add i64 %mul37, 5, !dbg !44
  %arrayidx39 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add38, !dbg !44
  store i32 1, i32* %arrayidx39, align 4, !dbg !44
  %12 = load i64, i64* %n, align 8, !dbg !44
  %mul40 = mul i64 5, %12, !dbg !44
  %add41 = add i64 %mul40, 4, !dbg !44
  %arrayidx42 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add41, !dbg !44
  store i32 1, i32* %arrayidx42, align 4, !dbg !44
  br label %do.end43, !dbg !44

do.end43:                                         ; preds = %do.body36
  br label %do.body44, !dbg !46

do.body44:                                        ; preds = %do.end43
  %13 = load i64, i64* %n, align 8, !dbg !47
  %mul45 = mul i64 5, %13, !dbg !47
  %add46 = add i64 %mul45, 6, !dbg !47
  %arrayidx47 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add46, !dbg !47
  store i32 1, i32* %arrayidx47, align 4, !dbg !47
  %14 = load i64, i64* %n, align 8, !dbg !47
  %mul48 = mul i64 6, %14, !dbg !47
  %add49 = add i64 %mul48, 5, !dbg !47
  %arrayidx50 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add49, !dbg !47
  store i32 1, i32* %arrayidx50, align 4, !dbg !47
  br label %do.end51, !dbg !47

do.end51:                                         ; preds = %do.body44
  call void @llvm.dbg.declare(metadata i64* %s, metadata !49, metadata !DIExpression()), !dbg !50
  store i64 0, i64* %s, align 8, !dbg !50
  call void @llvm.dbg.declare(metadata [7 x i64]* %order, metadata !51, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.declare(metadata i64* %ord_len, metadata !56, metadata !DIExpression()), !dbg !57
  store i64 0, i64* %ord_len, align 8, !dbg !57
  %arraydecay = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 0, !dbg !58
  %15 = load i64, i64* %n, align 8, !dbg !59
  %16 = load i64, i64* %s, align 8, !dbg !60
  %arraydecay52 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0, !dbg !61
  call void @dfs(i32* noundef %arraydecay, i64 noundef %15, i64 noundef %16, i64* noundef %arraydecay52, i64* noundef %ord_len), !dbg !62
  %17 = load i64, i64* %s, align 8, !dbg !63
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef %17), !dbg !64
  call void @llvm.dbg.declare(metadata i64* %i, metadata !65, metadata !DIExpression()), !dbg !67
  store i64 0, i64* %i, align 8, !dbg !67
  br label %for.cond, !dbg !68

for.cond:                                         ; preds = %for.inc, %do.end51
  %18 = load i64, i64* %i, align 8, !dbg !69
  %19 = load i64, i64* %ord_len, align 8, !dbg !71
  %cmp = icmp ult i64 %18, %19, !dbg !72
  br i1 %cmp, label %for.body, label %for.end, !dbg !73

for.body:                                         ; preds = %for.cond
  %20 = load i64, i64* %i, align 8, !dbg !74
  %arrayidx53 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %20, !dbg !76
  %21 = load i64, i64* %arrayidx53, align 8, !dbg !76
  %22 = load i64, i64* %i, align 8, !dbg !77
  %add54 = add i64 %22, 1, !dbg !78
  %23 = load i64, i64* %ord_len, align 8, !dbg !79
  %cmp55 = icmp ult i64 %add54, %23, !dbg !80
  %24 = zext i1 %cmp55 to i64, !dbg !81
  %cond = select i1 %cmp55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0), !dbg !81
  %call56 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %21, i8* noundef %cond), !dbg !82
  br label %for.inc, !dbg !83

for.inc:                                          ; preds = %for.body
  %25 = load i64, i64* %i, align 8, !dbg !84
  %inc = add i64 %25, 1, !dbg !84
  store i64 %inc, i64* %i, align 8, !dbg !84
  br label %for.cond, !dbg !85, !llvm.loop !86

for.end:                                          ; preds = %for.cond
  %call57 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0)), !dbg !89
  ret i32 0, !dbg !90
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @dfs(i32* noundef %g, i64 noundef %n, i64 noundef %s, i64* noundef %order, i64* noundef %ord_len) #0 !dbg !91 {
entry:
  %g.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %s.addr = alloca i64, align 8
  %order.addr = alloca i64*, align 8
  %ord_len.addr = alloca i64*, align 8
  %visited = alloca i32*, align 8
  %idx = alloca i64*, align 8
  %st = alloca i64*, align 8
  %i = alloca i64, align 8
  %top = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8
  store i32* %g, i32** %g.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %g.addr, metadata !96, metadata !DIExpression()), !dbg !97
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !98, metadata !DIExpression()), !dbg !99
  store i64 %s, i64* %s.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %s.addr, metadata !100, metadata !DIExpression()), !dbg !101
  store i64* %order, i64** %order.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %order.addr, metadata !102, metadata !DIExpression()), !dbg !103
  store i64* %ord_len, i64** %ord_len.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %ord_len.addr, metadata !104, metadata !DIExpression()), !dbg !105
  %0 = load i64, i64* %n.addr, align 8, !dbg !106
  %cmp = icmp eq i64 %0, 0, !dbg !108
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !109

lor.lhs.false:                                    ; preds = %entry
  %1 = load i64, i64* %s.addr, align 8, !dbg !110
  %2 = load i64, i64* %n.addr, align 8, !dbg !111
  %cmp1 = icmp uge i64 %1, %2, !dbg !112
  br i1 %cmp1, label %if.then, label %if.end, !dbg !113

if.then:                                          ; preds = %lor.lhs.false, %entry
  %3 = load i64*, i64** %ord_len.addr, align 8, !dbg !114
  store i64 0, i64* %3, align 8, !dbg !116
  br label %return, !dbg !117

if.end:                                           ; preds = %lor.lhs.false
  call void @llvm.dbg.declare(metadata i32** %visited, metadata !118, metadata !DIExpression()), !dbg !119
  %4 = load i64, i64* %n.addr, align 8, !dbg !120
  %mul = mul i64 %4, 4, !dbg !121
  %call = call noalias i8* @malloc(i64 noundef %mul) #5, !dbg !122
  %5 = bitcast i8* %call to i32*, !dbg !123
  store i32* %5, i32** %visited, align 8, !dbg !119
  call void @llvm.dbg.declare(metadata i64** %idx, metadata !124, metadata !DIExpression()), !dbg !125
  %6 = load i64, i64* %n.addr, align 8, !dbg !126
  %mul2 = mul i64 %6, 8, !dbg !127
  %call3 = call noalias i8* @malloc(i64 noundef %mul2) #5, !dbg !128
  %7 = bitcast i8* %call3 to i64*, !dbg !129
  store i64* %7, i64** %idx, align 8, !dbg !125
  call void @llvm.dbg.declare(metadata i64** %st, metadata !130, metadata !DIExpression()), !dbg !131
  %8 = load i64, i64* %n.addr, align 8, !dbg !132
  %mul4 = mul i64 %8, 8, !dbg !133
  %call5 = call noalias i8* @malloc(i64 noundef %mul4) #5, !dbg !134
  %9 = bitcast i8* %call5 to i64*, !dbg !135
  store i64* %9, i64** %st, align 8, !dbg !131
  %10 = load i32*, i32** %visited, align 8, !dbg !136
  %tobool = icmp ne i32* %10, null, !dbg !136
  br i1 %tobool, label %lor.lhs.false6, label %if.then10, !dbg !138

lor.lhs.false6:                                   ; preds = %if.end
  %11 = load i64*, i64** %idx, align 8, !dbg !139
  %tobool7 = icmp ne i64* %11, null, !dbg !139
  br i1 %tobool7, label %lor.lhs.false8, label %if.then10, !dbg !140

lor.lhs.false8:                                   ; preds = %lor.lhs.false6
  %12 = load i64*, i64** %st, align 8, !dbg !141
  %tobool9 = icmp ne i64* %12, null, !dbg !141
  br i1 %tobool9, label %if.end11, label %if.then10, !dbg !142

if.then10:                                        ; preds = %lor.lhs.false8, %lor.lhs.false6, %if.end
  %13 = load i32*, i32** %visited, align 8, !dbg !143
  %14 = bitcast i32* %13 to i8*, !dbg !143
  call void @free(i8* noundef %14) #5, !dbg !145
  %15 = load i64*, i64** %idx, align 8, !dbg !146
  %16 = bitcast i64* %15 to i8*, !dbg !146
  call void @free(i8* noundef %16) #5, !dbg !147
  %17 = load i64*, i64** %st, align 8, !dbg !148
  %18 = bitcast i64* %17 to i8*, !dbg !148
  call void @free(i8* noundef %18) #5, !dbg !149
  %19 = load i64*, i64** %ord_len.addr, align 8, !dbg !150
  store i64 0, i64* %19, align 8, !dbg !151
  br label %return, !dbg !152

if.end11:                                         ; preds = %lor.lhs.false8
  call void @llvm.dbg.declare(metadata i64* %i, metadata !153, metadata !DIExpression()), !dbg !155
  store i64 0, i64* %i, align 8, !dbg !155
  br label %for.cond, !dbg !156

for.cond:                                         ; preds = %for.inc, %if.end11
  %20 = load i64, i64* %i, align 8, !dbg !157
  %21 = load i64, i64* %n.addr, align 8, !dbg !159
  %cmp12 = icmp ult i64 %20, %21, !dbg !160
  br i1 %cmp12, label %for.body, label %for.end, !dbg !161

for.body:                                         ; preds = %for.cond
  %22 = load i32*, i32** %visited, align 8, !dbg !162
  %23 = load i64, i64* %i, align 8, !dbg !164
  %arrayidx = getelementptr inbounds i32, i32* %22, i64 %23, !dbg !162
  store i32 0, i32* %arrayidx, align 4, !dbg !165
  %24 = load i64*, i64** %idx, align 8, !dbg !166
  %25 = load i64, i64* %i, align 8, !dbg !167
  %arrayidx13 = getelementptr inbounds i64, i64* %24, i64 %25, !dbg !166
  store i64 0, i64* %arrayidx13, align 8, !dbg !168
  br label %for.inc, !dbg !169

for.inc:                                          ; preds = %for.body
  %26 = load i64, i64* %i, align 8, !dbg !170
  %inc = add i64 %26, 1, !dbg !170
  store i64 %inc, i64* %i, align 8, !dbg !170
  br label %for.cond, !dbg !171, !llvm.loop !172

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i64* %top, metadata !174, metadata !DIExpression()), !dbg !175
  store i64 0, i64* %top, align 8, !dbg !175
  %27 = load i64*, i64** %ord_len.addr, align 8, !dbg !176
  store i64 0, i64* %27, align 8, !dbg !177
  %28 = load i64, i64* %s.addr, align 8, !dbg !178
  %29 = load i64*, i64** %st, align 8, !dbg !179
  %30 = load i64, i64* %top, align 8, !dbg !180
  %inc14 = add i64 %30, 1, !dbg !180
  store i64 %inc14, i64* %top, align 8, !dbg !180
  %arrayidx15 = getelementptr inbounds i64, i64* %29, i64 %30, !dbg !179
  store i64 %28, i64* %arrayidx15, align 8, !dbg !181
  %31 = load i32*, i32** %visited, align 8, !dbg !182
  %32 = load i64, i64* %s.addr, align 8, !dbg !183
  %arrayidx16 = getelementptr inbounds i32, i32* %31, i64 %32, !dbg !182
  store i32 1, i32* %arrayidx16, align 4, !dbg !184
  %33 = load i64, i64* %s.addr, align 8, !dbg !185
  %34 = load i64*, i64** %order.addr, align 8, !dbg !186
  %35 = load i64*, i64** %ord_len.addr, align 8, !dbg !187
  %36 = load i64, i64* %35, align 8, !dbg !188
  %inc17 = add i64 %36, 1, !dbg !188
  store i64 %inc17, i64* %35, align 8, !dbg !188
  %arrayidx18 = getelementptr inbounds i64, i64* %34, i64 %36, !dbg !186
  store i64 %33, i64* %arrayidx18, align 8, !dbg !189
  br label %while.cond, !dbg !190

while.cond:                                       ; preds = %if.end44, %for.end
  %37 = load i64, i64* %top, align 8, !dbg !191
  %cmp19 = icmp ugt i64 %37, 0, !dbg !192
  br i1 %cmp19, label %while.body, label %while.end, !dbg !190

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %u, metadata !193, metadata !DIExpression()), !dbg !195
  %38 = load i64*, i64** %st, align 8, !dbg !196
  %39 = load i64, i64* %top, align 8, !dbg !197
  %sub = sub i64 %39, 1, !dbg !198
  %arrayidx20 = getelementptr inbounds i64, i64* %38, i64 %sub, !dbg !196
  %40 = load i64, i64* %arrayidx20, align 8, !dbg !196
  store i64 %40, i64* %u, align 8, !dbg !195
  call void @llvm.dbg.declare(metadata i64* %v, metadata !199, metadata !DIExpression()), !dbg !200
  %41 = load i64*, i64** %idx, align 8, !dbg !201
  %42 = load i64, i64* %u, align 8, !dbg !203
  %arrayidx21 = getelementptr inbounds i64, i64* %41, i64 %42, !dbg !201
  %43 = load i64, i64* %arrayidx21, align 8, !dbg !201
  store i64 %43, i64* %v, align 8, !dbg !204
  br label %for.cond22, !dbg !205

for.cond22:                                       ; preds = %for.inc39, %while.body
  %44 = load i64, i64* %v, align 8, !dbg !206
  %45 = load i64, i64* %n.addr, align 8, !dbg !208
  %cmp23 = icmp ult i64 %44, %45, !dbg !209
  br i1 %cmp23, label %for.body24, label %for.end41, !dbg !210

for.body24:                                       ; preds = %for.cond22
  %46 = load i32*, i32** %g.addr, align 8, !dbg !211
  %47 = load i64, i64* %u, align 8, !dbg !214
  %48 = load i64, i64* %n.addr, align 8, !dbg !215
  %mul25 = mul i64 %47, %48, !dbg !216
  %49 = load i64, i64* %v, align 8, !dbg !217
  %add = add i64 %mul25, %49, !dbg !218
  %arrayidx26 = getelementptr inbounds i32, i32* %46, i64 %add, !dbg !211
  %50 = load i32, i32* %arrayidx26, align 4, !dbg !211
  %tobool27 = icmp ne i32 %50, 0, !dbg !211
  br i1 %tobool27, label %land.lhs.true, label %if.end38, !dbg !219

land.lhs.true:                                    ; preds = %for.body24
  %51 = load i32*, i32** %visited, align 8, !dbg !220
  %52 = load i64, i64* %v, align 8, !dbg !221
  %arrayidx28 = getelementptr inbounds i32, i32* %51, i64 %52, !dbg !220
  %53 = load i32, i32* %arrayidx28, align 4, !dbg !220
  %tobool29 = icmp ne i32 %53, 0, !dbg !220
  br i1 %tobool29, label %if.end38, label %if.then30, !dbg !222

if.then30:                                        ; preds = %land.lhs.true
  %54 = load i64, i64* %v, align 8, !dbg !223
  %add31 = add i64 %54, 1, !dbg !225
  %55 = load i64*, i64** %idx, align 8, !dbg !226
  %56 = load i64, i64* %u, align 8, !dbg !227
  %arrayidx32 = getelementptr inbounds i64, i64* %55, i64 %56, !dbg !226
  store i64 %add31, i64* %arrayidx32, align 8, !dbg !228
  %57 = load i32*, i32** %visited, align 8, !dbg !229
  %58 = load i64, i64* %v, align 8, !dbg !230
  %arrayidx33 = getelementptr inbounds i32, i32* %57, i64 %58, !dbg !229
  store i32 1, i32* %arrayidx33, align 4, !dbg !231
  %59 = load i64, i64* %v, align 8, !dbg !232
  %60 = load i64*, i64** %order.addr, align 8, !dbg !233
  %61 = load i64*, i64** %ord_len.addr, align 8, !dbg !234
  %62 = load i64, i64* %61, align 8, !dbg !235
  %inc34 = add i64 %62, 1, !dbg !235
  store i64 %inc34, i64* %61, align 8, !dbg !235
  %arrayidx35 = getelementptr inbounds i64, i64* %60, i64 %62, !dbg !233
  store i64 %59, i64* %arrayidx35, align 8, !dbg !236
  %63 = load i64, i64* %v, align 8, !dbg !237
  %64 = load i64*, i64** %st, align 8, !dbg !238
  %65 = load i64, i64* %top, align 8, !dbg !239
  %inc36 = add i64 %65, 1, !dbg !239
  store i64 %inc36, i64* %top, align 8, !dbg !239
  %arrayidx37 = getelementptr inbounds i64, i64* %64, i64 %65, !dbg !238
  store i64 %63, i64* %arrayidx37, align 8, !dbg !240
  br label %for.end41, !dbg !241

if.end38:                                         ; preds = %land.lhs.true, %for.body24
  br label %for.inc39, !dbg !242

for.inc39:                                        ; preds = %if.end38
  %66 = load i64, i64* %v, align 8, !dbg !243
  %inc40 = add i64 %66, 1, !dbg !243
  store i64 %inc40, i64* %v, align 8, !dbg !243
  br label %for.cond22, !dbg !244, !llvm.loop !245

for.end41:                                        ; preds = %if.then30, %for.cond22
  %67 = load i64, i64* %v, align 8, !dbg !247
  %68 = load i64, i64* %n.addr, align 8, !dbg !249
  %cmp42 = icmp eq i64 %67, %68, !dbg !250
  br i1 %cmp42, label %if.then43, label %if.end44, !dbg !251

if.then43:                                        ; preds = %for.end41
  %69 = load i64, i64* %top, align 8, !dbg !252
  %dec = add i64 %69, -1, !dbg !252
  store i64 %dec, i64* %top, align 8, !dbg !252
  br label %if.end44, !dbg !254

if.end44:                                         ; preds = %if.then43, %for.end41
  br label %while.cond, !dbg !190, !llvm.loop !255

while.end:                                        ; preds = %while.cond
  %70 = load i32*, i32** %visited, align 8, !dbg !257
  %71 = bitcast i32* %70 to i8*, !dbg !257
  call void @free(i8* noundef %71) #5, !dbg !258
  %72 = load i64*, i64** %idx, align 8, !dbg !259
  %73 = bitcast i64* %72 to i8*, !dbg !259
  call void @free(i8* noundef %73) #5, !dbg !260
  %74 = load i64*, i64** %st, align 8, !dbg !261
  %75 = bitcast i64* %74 to i8*, !dbg !261
  call void @free(i8* noundef %75) #5, !dbg !262
  br label %return, !dbg !263

return:                                           ; preds = %while.end, %if.then10, %if.then
  ret void, !dbg !263
}

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #4

; Function Attrs: nounwind
declare void @free(i8* noundef) #4

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/DFS.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "0cff5236e125c0a127adcaed33b60657")
!2 = !{!3, !5}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !7, line: 46, baseType: !8)
!7 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!8 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!17 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 50, type: !18, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{!4}
!20 = !{}
!21 = !DILocalVariable(name: "n", scope: !17, file: !1, line: 51, type: !6)
!22 = !DILocation(line: 51, column: 12, scope: !17)
!23 = !DILocalVariable(name: "g", scope: !17, file: !1, line: 52, type: !24)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 1568, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 49)
!27 = !DILocation(line: 52, column: 9, scope: !17)
!28 = !DILocation(line: 55, column: 5, scope: !17)
!29 = !DILocation(line: 55, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 5)
!31 = !DILocation(line: 55, column: 15, scope: !17)
!32 = !DILocation(line: 55, column: 15, scope: !33)
!33 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 15)
!34 = !DILocation(line: 55, column: 25, scope: !17)
!35 = !DILocation(line: 55, column: 25, scope: !36)
!36 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 25)
!37 = !DILocation(line: 55, column: 35, scope: !17)
!38 = !DILocation(line: 55, column: 35, scope: !39)
!39 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 35)
!40 = !DILocation(line: 55, column: 45, scope: !17)
!41 = !DILocation(line: 55, column: 45, scope: !42)
!42 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 45)
!43 = !DILocation(line: 55, column: 55, scope: !17)
!44 = !DILocation(line: 55, column: 55, scope: !45)
!45 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 55)
!46 = !DILocation(line: 55, column: 65, scope: !17)
!47 = !DILocation(line: 55, column: 65, scope: !48)
!48 = distinct !DILexicalBlock(scope: !17, file: !1, line: 55, column: 65)
!49 = !DILocalVariable(name: "s", scope: !17, file: !1, line: 58, type: !6)
!50 = !DILocation(line: 58, column: 12, scope: !17)
!51 = !DILocalVariable(name: "order", scope: !17, file: !1, line: 59, type: !52)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 448, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 7)
!55 = !DILocation(line: 59, column: 12, scope: !17)
!56 = !DILocalVariable(name: "ord_len", scope: !17, file: !1, line: 60, type: !6)
!57 = !DILocation(line: 60, column: 12, scope: !17)
!58 = !DILocation(line: 62, column: 9, scope: !17)
!59 = !DILocation(line: 62, column: 12, scope: !17)
!60 = !DILocation(line: 62, column: 15, scope: !17)
!61 = !DILocation(line: 62, column: 18, scope: !17)
!62 = !DILocation(line: 62, column: 5, scope: !17)
!63 = !DILocation(line: 64, column: 39, scope: !17)
!64 = !DILocation(line: 64, column: 5, scope: !17)
!65 = !DILocalVariable(name: "i", scope: !66, file: !1, line: 65, type: !6)
!66 = distinct !DILexicalBlock(scope: !17, file: !1, line: 65, column: 5)
!67 = !DILocation(line: 65, column: 17, scope: !66)
!68 = !DILocation(line: 65, column: 10, scope: !66)
!69 = !DILocation(line: 65, column: 24, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !1, line: 65, column: 5)
!71 = !DILocation(line: 65, column: 28, scope: !70)
!72 = !DILocation(line: 65, column: 26, scope: !70)
!73 = !DILocation(line: 65, column: 5, scope: !66)
!74 = !DILocation(line: 66, column: 31, scope: !75)
!75 = distinct !DILexicalBlock(scope: !70, file: !1, line: 65, column: 42)
!76 = !DILocation(line: 66, column: 25, scope: !75)
!77 = !DILocation(line: 66, column: 36, scope: !75)
!78 = !DILocation(line: 66, column: 38, scope: !75)
!79 = !DILocation(line: 66, column: 44, scope: !75)
!80 = !DILocation(line: 66, column: 42, scope: !75)
!81 = !DILocation(line: 66, column: 35, scope: !75)
!82 = !DILocation(line: 66, column: 9, scope: !75)
!83 = !DILocation(line: 67, column: 5, scope: !75)
!84 = !DILocation(line: 65, column: 37, scope: !70)
!85 = !DILocation(line: 65, column: 5, scope: !70)
!86 = distinct !{!86, !73, !87, !88}
!87 = !DILocation(line: 67, column: 5, scope: !66)
!88 = !{!"llvm.loop.mustprogress"}
!89 = !DILocation(line: 68, column: 5, scope: !17)
!90 = !DILocation(line: 69, column: 5, scope: !17)
!91 = distinct !DISubprogram(name: "dfs", scope: !1, file: !1, line: 5, type: !92, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !20)
!92 = !DISubroutineType(types: !93)
!93 = !{null, !94, !6, !6, !5, !5}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!96 = !DILocalVariable(name: "g", arg: 1, scope: !91, file: !1, line: 5, type: !94)
!97 = !DILocation(line: 5, column: 28, scope: !91)
!98 = !DILocalVariable(name: "n", arg: 2, scope: !91, file: !1, line: 5, type: !6)
!99 = !DILocation(line: 5, column: 38, scope: !91)
!100 = !DILocalVariable(name: "s", arg: 3, scope: !91, file: !1, line: 5, type: !6)
!101 = !DILocation(line: 5, column: 48, scope: !91)
!102 = !DILocalVariable(name: "order", arg: 4, scope: !91, file: !1, line: 5, type: !5)
!103 = !DILocation(line: 5, column: 59, scope: !91)
!104 = !DILocalVariable(name: "ord_len", arg: 5, scope: !91, file: !1, line: 5, type: !5)
!105 = !DILocation(line: 5, column: 74, scope: !91)
!106 = !DILocation(line: 6, column: 9, scope: !107)
!107 = distinct !DILexicalBlock(scope: !91, file: !1, line: 6, column: 9)
!108 = !DILocation(line: 6, column: 11, scope: !107)
!109 = !DILocation(line: 6, column: 16, scope: !107)
!110 = !DILocation(line: 6, column: 19, scope: !107)
!111 = !DILocation(line: 6, column: 24, scope: !107)
!112 = !DILocation(line: 6, column: 21, scope: !107)
!113 = !DILocation(line: 6, column: 9, scope: !91)
!114 = !DILocation(line: 6, column: 30, scope: !115)
!115 = distinct !DILexicalBlock(scope: !107, file: !1, line: 6, column: 27)
!116 = !DILocation(line: 6, column: 38, scope: !115)
!117 = !DILocation(line: 6, column: 43, scope: !115)
!118 = !DILocalVariable(name: "visited", scope: !91, file: !1, line: 8, type: !3)
!119 = !DILocation(line: 8, column: 10, scope: !91)
!120 = !DILocation(line: 8, column: 34, scope: !91)
!121 = !DILocation(line: 8, column: 36, scope: !91)
!122 = !DILocation(line: 8, column: 27, scope: !91)
!123 = !DILocation(line: 8, column: 20, scope: !91)
!124 = !DILocalVariable(name: "idx", scope: !91, file: !1, line: 9, type: !5)
!125 = !DILocation(line: 9, column: 13, scope: !91)
!126 = !DILocation(line: 9, column: 38, scope: !91)
!127 = !DILocation(line: 9, column: 40, scope: !91)
!128 = !DILocation(line: 9, column: 31, scope: !91)
!129 = !DILocation(line: 9, column: 21, scope: !91)
!130 = !DILocalVariable(name: "st", scope: !91, file: !1, line: 10, type: !5)
!131 = !DILocation(line: 10, column: 13, scope: !91)
!132 = !DILocation(line: 10, column: 38, scope: !91)
!133 = !DILocation(line: 10, column: 40, scope: !91)
!134 = !DILocation(line: 10, column: 31, scope: !91)
!135 = !DILocation(line: 10, column: 21, scope: !91)
!136 = !DILocation(line: 12, column: 10, scope: !137)
!137 = distinct !DILexicalBlock(scope: !91, file: !1, line: 12, column: 9)
!138 = !DILocation(line: 12, column: 18, scope: !137)
!139 = !DILocation(line: 12, column: 22, scope: !137)
!140 = !DILocation(line: 12, column: 26, scope: !137)
!141 = !DILocation(line: 12, column: 30, scope: !137)
!142 = !DILocation(line: 12, column: 9, scope: !91)
!143 = !DILocation(line: 13, column: 14, scope: !144)
!144 = distinct !DILexicalBlock(scope: !137, file: !1, line: 12, column: 34)
!145 = !DILocation(line: 13, column: 9, scope: !144)
!146 = !DILocation(line: 13, column: 29, scope: !144)
!147 = !DILocation(line: 13, column: 24, scope: !144)
!148 = !DILocation(line: 13, column: 40, scope: !144)
!149 = !DILocation(line: 13, column: 35, scope: !144)
!150 = !DILocation(line: 14, column: 10, scope: !144)
!151 = !DILocation(line: 14, column: 18, scope: !144)
!152 = !DILocation(line: 14, column: 23, scope: !144)
!153 = !DILocalVariable(name: "i", scope: !154, file: !1, line: 17, type: !6)
!154 = distinct !DILexicalBlock(scope: !91, file: !1, line: 17, column: 5)
!155 = !DILocation(line: 17, column: 17, scope: !154)
!156 = !DILocation(line: 17, column: 10, scope: !154)
!157 = !DILocation(line: 17, column: 24, scope: !158)
!158 = distinct !DILexicalBlock(scope: !154, file: !1, line: 17, column: 5)
!159 = !DILocation(line: 17, column: 28, scope: !158)
!160 = !DILocation(line: 17, column: 26, scope: !158)
!161 = !DILocation(line: 17, column: 5, scope: !154)
!162 = !DILocation(line: 17, column: 38, scope: !163)
!163 = distinct !DILexicalBlock(scope: !158, file: !1, line: 17, column: 36)
!164 = !DILocation(line: 17, column: 46, scope: !163)
!165 = !DILocation(line: 17, column: 49, scope: !163)
!166 = !DILocation(line: 17, column: 54, scope: !163)
!167 = !DILocation(line: 17, column: 58, scope: !163)
!168 = !DILocation(line: 17, column: 61, scope: !163)
!169 = !DILocation(line: 17, column: 66, scope: !163)
!170 = !DILocation(line: 17, column: 31, scope: !158)
!171 = !DILocation(line: 17, column: 5, scope: !158)
!172 = distinct !{!172, !161, !173, !88}
!173 = !DILocation(line: 17, column: 66, scope: !154)
!174 = !DILocalVariable(name: "top", scope: !91, file: !1, line: 19, type: !6)
!175 = !DILocation(line: 19, column: 12, scope: !91)
!176 = !DILocation(line: 20, column: 6, scope: !91)
!177 = !DILocation(line: 20, column: 14, scope: !91)
!178 = !DILocation(line: 22, column: 17, scope: !91)
!179 = !DILocation(line: 22, column: 5, scope: !91)
!180 = !DILocation(line: 22, column: 11, scope: !91)
!181 = !DILocation(line: 22, column: 15, scope: !91)
!182 = !DILocation(line: 23, column: 5, scope: !91)
!183 = !DILocation(line: 23, column: 13, scope: !91)
!184 = !DILocation(line: 23, column: 16, scope: !91)
!185 = !DILocation(line: 24, column: 27, scope: !91)
!186 = !DILocation(line: 24, column: 5, scope: !91)
!187 = !DILocation(line: 24, column: 13, scope: !91)
!188 = !DILocation(line: 24, column: 21, scope: !91)
!189 = !DILocation(line: 24, column: 25, scope: !91)
!190 = !DILocation(line: 26, column: 5, scope: !91)
!191 = !DILocation(line: 26, column: 12, scope: !91)
!192 = !DILocation(line: 26, column: 16, scope: !91)
!193 = !DILocalVariable(name: "u", scope: !194, file: !1, line: 27, type: !6)
!194 = distinct !DILexicalBlock(scope: !91, file: !1, line: 26, column: 21)
!195 = !DILocation(line: 27, column: 16, scope: !194)
!196 = !DILocation(line: 27, column: 20, scope: !194)
!197 = !DILocation(line: 27, column: 23, scope: !194)
!198 = !DILocation(line: 27, column: 27, scope: !194)
!199 = !DILocalVariable(name: "v", scope: !194, file: !1, line: 28, type: !6)
!200 = !DILocation(line: 28, column: 16, scope: !194)
!201 = !DILocation(line: 30, column: 18, scope: !202)
!202 = distinct !DILexicalBlock(scope: !194, file: !1, line: 30, column: 9)
!203 = !DILocation(line: 30, column: 22, scope: !202)
!204 = !DILocation(line: 30, column: 16, scope: !202)
!205 = !DILocation(line: 30, column: 14, scope: !202)
!206 = !DILocation(line: 30, column: 26, scope: !207)
!207 = distinct !DILexicalBlock(scope: !202, file: !1, line: 30, column: 9)
!208 = !DILocation(line: 30, column: 30, scope: !207)
!209 = !DILocation(line: 30, column: 28, scope: !207)
!210 = !DILocation(line: 30, column: 9, scope: !202)
!211 = !DILocation(line: 31, column: 17, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !1, line: 31, column: 17)
!213 = distinct !DILexicalBlock(scope: !207, file: !1, line: 30, column: 38)
!214 = !DILocation(line: 31, column: 19, scope: !212)
!215 = !DILocation(line: 31, column: 21, scope: !212)
!216 = !DILocation(line: 31, column: 20, scope: !212)
!217 = !DILocation(line: 31, column: 25, scope: !212)
!218 = !DILocation(line: 31, column: 23, scope: !212)
!219 = !DILocation(line: 31, column: 28, scope: !212)
!220 = !DILocation(line: 31, column: 32, scope: !212)
!221 = !DILocation(line: 31, column: 40, scope: !212)
!222 = !DILocation(line: 31, column: 17, scope: !213)
!223 = !DILocation(line: 32, column: 26, scope: !224)
!224 = distinct !DILexicalBlock(scope: !212, file: !1, line: 31, column: 44)
!225 = !DILocation(line: 32, column: 28, scope: !224)
!226 = !DILocation(line: 32, column: 17, scope: !224)
!227 = !DILocation(line: 32, column: 21, scope: !224)
!228 = !DILocation(line: 32, column: 24, scope: !224)
!229 = !DILocation(line: 33, column: 17, scope: !224)
!230 = !DILocation(line: 33, column: 25, scope: !224)
!231 = !DILocation(line: 33, column: 28, scope: !224)
!232 = !DILocation(line: 34, column: 39, scope: !224)
!233 = !DILocation(line: 34, column: 17, scope: !224)
!234 = !DILocation(line: 34, column: 25, scope: !224)
!235 = !DILocation(line: 34, column: 33, scope: !224)
!236 = !DILocation(line: 34, column: 37, scope: !224)
!237 = !DILocation(line: 35, column: 29, scope: !224)
!238 = !DILocation(line: 35, column: 17, scope: !224)
!239 = !DILocation(line: 35, column: 23, scope: !224)
!240 = !DILocation(line: 35, column: 27, scope: !224)
!241 = !DILocation(line: 36, column: 17, scope: !224)
!242 = !DILocation(line: 38, column: 9, scope: !213)
!243 = !DILocation(line: 30, column: 33, scope: !207)
!244 = !DILocation(line: 30, column: 9, scope: !207)
!245 = distinct !{!245, !210, !246, !88}
!246 = !DILocation(line: 38, column: 9, scope: !202)
!247 = !DILocation(line: 40, column: 13, scope: !248)
!248 = distinct !DILexicalBlock(scope: !194, file: !1, line: 40, column: 13)
!249 = !DILocation(line: 40, column: 18, scope: !248)
!250 = !DILocation(line: 40, column: 15, scope: !248)
!251 = !DILocation(line: 40, column: 13, scope: !194)
!252 = !DILocation(line: 41, column: 16, scope: !253)
!253 = distinct !DILexicalBlock(scope: !248, file: !1, line: 40, column: 21)
!254 = !DILocation(line: 42, column: 9, scope: !253)
!255 = distinct !{!255, !190, !256, !88}
!256 = !DILocation(line: 43, column: 5, scope: !91)
!257 = !DILocation(line: 45, column: 10, scope: !91)
!258 = !DILocation(line: 45, column: 5, scope: !91)
!259 = !DILocation(line: 46, column: 10, scope: !91)
!260 = !DILocation(line: 46, column: 5, scope: !91)
!261 = !DILocation(line: 47, column: 10, scope: !91)
!262 = !DILocation(line: 47, column: 5, scope: !91)
!263 = !DILocation(line: 48, column: 1, scope: !91)

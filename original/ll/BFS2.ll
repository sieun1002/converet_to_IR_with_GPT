; ModuleID = 'BFS.ll'
source_filename = "../original/src/BFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = external hidden unnamed_addr constant [21 x i8], align 1
@.str.1 = external hidden unnamed_addr constant [6 x i8], align 1
@.str.2 = external hidden unnamed_addr constant [2 x i8], align 1
@.str.3 = external hidden unnamed_addr constant [1 x i8], align 1
@.str.4 = external hidden unnamed_addr constant [2 x i8], align 1
@.str.5 = external hidden unnamed_addr constant [23 x i8], align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !15 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i64, align 8
  %g = alloca [49 x i32], align 16
  %s = alloca i64, align 8
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %ord_len = alloca i64, align 8
  %i = alloca i64, align 8
  %i59 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i64* %n, metadata !20, metadata !DIExpression()), !dbg !21
  store i64 7, i64* %n, align 8, !dbg !21
  call void @llvm.dbg.declare(metadata [49 x i32]* %g, metadata !22, metadata !DIExpression()), !dbg !26
  %0 = bitcast [49 x i32]* %g to i8*, !dbg !26
  call void @llvm.memset.p0i8.i64(i8* align 16 %0, i8 0, i64 196, i1 false), !dbg !26
  br label %do.body, !dbg !27

do.body:                                          ; preds = %entry
  %1 = load i64, i64* %n, align 8, !dbg !28
  %mul = mul i64 0, %1, !dbg !28
  %add = add i64 %mul, 1, !dbg !28
  %arrayidx = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add, !dbg !28
  store i32 1, i32* %arrayidx, align 4, !dbg !28
  %2 = load i64, i64* %n, align 8, !dbg !28
  %mul1 = mul i64 1, %2, !dbg !28
  %add2 = add i64 %mul1, 0, !dbg !28
  %arrayidx3 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add2, !dbg !28
  store i32 1, i32* %arrayidx3, align 4, !dbg !28
  br label %do.end, !dbg !28

do.end:                                           ; preds = %do.body
  br label %do.body4, !dbg !30

do.body4:                                         ; preds = %do.end
  %3 = load i64, i64* %n, align 8, !dbg !31
  %mul5 = mul i64 0, %3, !dbg !31
  %add6 = add i64 %mul5, 2, !dbg !31
  %arrayidx7 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add6, !dbg !31
  store i32 1, i32* %arrayidx7, align 4, !dbg !31
  %4 = load i64, i64* %n, align 8, !dbg !31
  %mul8 = mul i64 2, %4, !dbg !31
  %add9 = add i64 %mul8, 0, !dbg !31
  %arrayidx10 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add9, !dbg !31
  store i32 1, i32* %arrayidx10, align 4, !dbg !31
  br label %do.end11, !dbg !31

do.end11:                                         ; preds = %do.body4
  br label %do.body12, !dbg !33

do.body12:                                        ; preds = %do.end11
  %5 = load i64, i64* %n, align 8, !dbg !34
  %mul13 = mul i64 1, %5, !dbg !34
  %add14 = add i64 %mul13, 3, !dbg !34
  %arrayidx15 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add14, !dbg !34
  store i32 1, i32* %arrayidx15, align 4, !dbg !34
  %6 = load i64, i64* %n, align 8, !dbg !34
  %mul16 = mul i64 3, %6, !dbg !34
  %add17 = add i64 %mul16, 1, !dbg !34
  %arrayidx18 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add17, !dbg !34
  store i32 1, i32* %arrayidx18, align 4, !dbg !34
  br label %do.end19, !dbg !34

do.end19:                                         ; preds = %do.body12
  br label %do.body20, !dbg !36

do.body20:                                        ; preds = %do.end19
  %7 = load i64, i64* %n, align 8, !dbg !37
  %mul21 = mul i64 1, %7, !dbg !37
  %add22 = add i64 %mul21, 4, !dbg !37
  %arrayidx23 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add22, !dbg !37
  store i32 1, i32* %arrayidx23, align 4, !dbg !37
  %8 = load i64, i64* %n, align 8, !dbg !37
  %mul24 = mul i64 4, %8, !dbg !37
  %add25 = add i64 %mul24, 1, !dbg !37
  %arrayidx26 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add25, !dbg !37
  store i32 1, i32* %arrayidx26, align 4, !dbg !37
  br label %do.end27, !dbg !37

do.end27:                                         ; preds = %do.body20
  br label %do.body28, !dbg !39

do.body28:                                        ; preds = %do.end27
  %9 = load i64, i64* %n, align 8, !dbg !40
  %mul29 = mul i64 2, %9, !dbg !40
  %add30 = add i64 %mul29, 5, !dbg !40
  %arrayidx31 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add30, !dbg !40
  store i32 1, i32* %arrayidx31, align 4, !dbg !40
  %10 = load i64, i64* %n, align 8, !dbg !40
  %mul32 = mul i64 5, %10, !dbg !40
  %add33 = add i64 %mul32, 2, !dbg !40
  %arrayidx34 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add33, !dbg !40
  store i32 1, i32* %arrayidx34, align 4, !dbg !40
  br label %do.end35, !dbg !40

do.end35:                                         ; preds = %do.body28
  br label %do.body36, !dbg !42

do.body36:                                        ; preds = %do.end35
  %11 = load i64, i64* %n, align 8, !dbg !43
  %mul37 = mul i64 4, %11, !dbg !43
  %add38 = add i64 %mul37, 5, !dbg !43
  %arrayidx39 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add38, !dbg !43
  store i32 1, i32* %arrayidx39, align 4, !dbg !43
  %12 = load i64, i64* %n, align 8, !dbg !43
  %mul40 = mul i64 5, %12, !dbg !43
  %add41 = add i64 %mul40, 4, !dbg !43
  %arrayidx42 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add41, !dbg !43
  store i32 1, i32* %arrayidx42, align 4, !dbg !43
  br label %do.end43, !dbg !43

do.end43:                                         ; preds = %do.body36
  br label %do.body44, !dbg !45

do.body44:                                        ; preds = %do.end43
  %13 = load i64, i64* %n, align 8, !dbg !46
  %mul45 = mul i64 5, %13, !dbg !46
  %add46 = add i64 %mul45, 6, !dbg !46
  %arrayidx47 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add46, !dbg !46
  store i32 1, i32* %arrayidx47, align 4, !dbg !46
  %14 = load i64, i64* %n, align 8, !dbg !46
  %mul48 = mul i64 6, %14, !dbg !46
  %add49 = add i64 %mul48, 5, !dbg !46
  %arrayidx50 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 %add49, !dbg !46
  store i32 1, i32* %arrayidx50, align 4, !dbg !46
  br label %do.end51, !dbg !46

do.end51:                                         ; preds = %do.body44
  call void @llvm.dbg.declare(metadata i64* %s, metadata !48, metadata !DIExpression()), !dbg !49
  store i64 0, i64* %s, align 8, !dbg !49
  call void @llvm.dbg.declare(metadata [7 x i32]* %dist, metadata !50, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata [7 x i64]* %order, metadata !55, metadata !DIExpression()), !dbg !57
  call void @llvm.dbg.declare(metadata i64* %ord_len, metadata !58, metadata !DIExpression()), !dbg !59
  store i64 0, i64* %ord_len, align 8, !dbg !59
  %arraydecay = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 0, !dbg !60
  %15 = load i64, i64* %n, align 8, !dbg !61
  %16 = load i64, i64* %s, align 8, !dbg !62
  %arraydecay52 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0, !dbg !63
  %arraydecay53 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0, !dbg !64
  call void @bfs(i32* noundef %arraydecay, i64 noundef %15, i64 noundef %16, i32* noundef %arraydecay52, i64* noundef %arraydecay53, i64* noundef %ord_len), !dbg !65
  %17 = load i64, i64* %s, align 8, !dbg !66
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef %17), !dbg !67
  call void @llvm.dbg.declare(metadata i64* %i, metadata !68, metadata !DIExpression()), !dbg !70
  store i64 0, i64* %i, align 8, !dbg !70
  br label %for.cond, !dbg !71

for.cond:                                         ; preds = %for.inc, %do.end51
  %18 = load i64, i64* %i, align 8, !dbg !72
  %19 = load i64, i64* %ord_len, align 8, !dbg !74
  %cmp = icmp ult i64 %18, %19, !dbg !75
  br i1 %cmp, label %for.body, label %for.end, !dbg !76

for.body:                                         ; preds = %for.cond
  %20 = load i64, i64* %i, align 8, !dbg !77
  %arrayidx54 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %20, !dbg !79
  %21 = load i64, i64* %arrayidx54, align 8, !dbg !79
  %22 = load i64, i64* %i, align 8, !dbg !80
  %add55 = add i64 %22, 1, !dbg !81
  %23 = load i64, i64* %ord_len, align 8, !dbg !82
  %cmp56 = icmp ult i64 %add55, %23, !dbg !83
  %24 = zext i1 %cmp56 to i64, !dbg !84
  %cond = select i1 %cmp56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0), !dbg !84
  %call57 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %21, i8* noundef %cond), !dbg !85
  br label %for.inc, !dbg !86

for.inc:                                          ; preds = %for.body
  %25 = load i64, i64* %i, align 8, !dbg !87
  %inc = add i64 %25, 1, !dbg !87
  store i64 %inc, i64* %i, align 8, !dbg !87
  br label %for.cond, !dbg !88, !llvm.loop !89

for.end:                                          ; preds = %for.cond
  %call58 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0)), !dbg !92
  call void @llvm.dbg.declare(metadata i64* %i59, metadata !93, metadata !DIExpression()), !dbg !95
  store i64 0, i64* %i59, align 8, !dbg !95
  br label %for.cond60, !dbg !96

for.cond60:                                       ; preds = %for.inc65, %for.end
  %26 = load i64, i64* %i59, align 8, !dbg !97
  %27 = load i64, i64* %n, align 8, !dbg !99
  %cmp61 = icmp ult i64 %26, %27, !dbg !100
  br i1 %cmp61, label %for.body62, label %for.end67, !dbg !101

for.body62:                                       ; preds = %for.cond60
  %28 = load i64, i64* %s, align 8, !dbg !102
  %29 = load i64, i64* %i59, align 8, !dbg !104
  %30 = load i64, i64* %i59, align 8, !dbg !105
  %arrayidx63 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %30, !dbg !106
  %31 = load i32, i32* %arrayidx63, align 4, !dbg !106
  %call64 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef %28, i64 noundef %29, i32 noundef %31), !dbg !107
  br label %for.inc65, !dbg !108

for.inc65:                                        ; preds = %for.body62
  %32 = load i64, i64* %i59, align 8, !dbg !109
  %inc66 = add i64 %32, 1, !dbg !109
  store i64 %inc66, i64* %i59, align 8, !dbg !109
  br label %for.cond60, !dbg !110, !llvm.loop !111

for.end67:                                        ; preds = %for.cond60
  ret i32 0, !dbg !113
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define hidden void @bfs(i32* noundef %g, i64 noundef %n, i64 noundef %s, i32* noundef %dist, i64* noundef %order, i64* noundef %ord_len) #0 !dbg !114 {
entry:
  %g.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %s.addr = alloca i64, align 8
  %dist.addr = alloca i32*, align 8
  %order.addr = alloca i64*, align 8
  %ord_len.addr = alloca i64*, align 8
  %i = alloca i64, align 8
  %q = alloca i64*, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8
  store i32* %g, i32** %g.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %g.addr, metadata !120, metadata !DIExpression()), !dbg !121
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !122, metadata !DIExpression()), !dbg !123
  store i64 %s, i64* %s.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %s.addr, metadata !124, metadata !DIExpression()), !dbg !125
  store i32* %dist, i32** %dist.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %dist.addr, metadata !126, metadata !DIExpression()), !dbg !127
  store i64* %order, i64** %order.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %order.addr, metadata !128, metadata !DIExpression()), !dbg !129
  store i64* %ord_len, i64** %ord_len.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %ord_len.addr, metadata !130, metadata !DIExpression()), !dbg !131
  %0 = load i64, i64* %n.addr, align 8, !dbg !132
  %cmp = icmp eq i64 %0, 0, !dbg !134
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !135

lor.lhs.false:                                    ; preds = %entry
  %1 = load i64, i64* %s.addr, align 8, !dbg !136
  %2 = load i64, i64* %n.addr, align 8, !dbg !137
  %cmp1 = icmp uge i64 %1, %2, !dbg !138
  br i1 %cmp1, label %if.then, label %if.end, !dbg !139

if.then:                                          ; preds = %lor.lhs.false, %entry
  %3 = load i64*, i64** %ord_len.addr, align 8, !dbg !140
  store i64 0, i64* %3, align 8, !dbg !142
  br label %return, !dbg !143

if.end:                                           ; preds = %lor.lhs.false
  call void @llvm.dbg.declare(metadata i64* %i, metadata !144, metadata !DIExpression()), !dbg !146
  store i64 0, i64* %i, align 8, !dbg !146
  br label %for.cond, !dbg !147

for.cond:                                         ; preds = %for.inc, %if.end
  %4 = load i64, i64* %i, align 8, !dbg !148
  %5 = load i64, i64* %n.addr, align 8, !dbg !150
  %cmp2 = icmp ult i64 %4, %5, !dbg !151
  br i1 %cmp2, label %for.body, label %for.end, !dbg !152

for.body:                                         ; preds = %for.cond
  %6 = load i32*, i32** %dist.addr, align 8, !dbg !153
  %7 = load i64, i64* %i, align 8, !dbg !154
  %arrayidx = getelementptr inbounds i32, i32* %6, i64 %7, !dbg !153
  store i32 -1, i32* %arrayidx, align 4, !dbg !155
  br label %for.inc, !dbg !153

for.inc:                                          ; preds = %for.body
  %8 = load i64, i64* %i, align 8, !dbg !156
  %inc = add i64 %8, 1, !dbg !156
  store i64 %inc, i64* %i, align 8, !dbg !156
  br label %for.cond, !dbg !157, !llvm.loop !158

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i64** %q, metadata !160, metadata !DIExpression()), !dbg !161
  %9 = load i64, i64* %n.addr, align 8, !dbg !162
  %mul = mul i64 %9, 8, !dbg !163
  %call = call noalias i8* @malloc(i64 noundef %mul) #5, !dbg !164
  %10 = bitcast i8* %call to i64*, !dbg !165
  store i64* %10, i64** %q, align 8, !dbg !161
  %11 = load i64*, i64** %q, align 8, !dbg !166
  %tobool = icmp ne i64* %11, null, !dbg !166
  br i1 %tobool, label %if.end4, label %if.then3, !dbg !168

if.then3:                                         ; preds = %for.end
  %12 = load i64*, i64** %ord_len.addr, align 8, !dbg !169
  store i64 0, i64* %12, align 8, !dbg !171
  br label %return, !dbg !172

if.end4:                                          ; preds = %for.end
  call void @llvm.dbg.declare(metadata i64* %head, metadata !173, metadata !DIExpression()), !dbg !174
  store i64 0, i64* %head, align 8, !dbg !174
  call void @llvm.dbg.declare(metadata i64* %tail, metadata !175, metadata !DIExpression()), !dbg !176
  store i64 0, i64* %tail, align 8, !dbg !176
  %13 = load i32*, i32** %dist.addr, align 8, !dbg !177
  %14 = load i64, i64* %s.addr, align 8, !dbg !178
  %arrayidx5 = getelementptr inbounds i32, i32* %13, i64 %14, !dbg !177
  store i32 0, i32* %arrayidx5, align 4, !dbg !179
  %15 = load i64, i64* %s.addr, align 8, !dbg !180
  %16 = load i64*, i64** %q, align 8, !dbg !181
  %17 = load i64, i64* %tail, align 8, !dbg !182
  %inc6 = add i64 %17, 1, !dbg !182
  store i64 %inc6, i64* %tail, align 8, !dbg !182
  %arrayidx7 = getelementptr inbounds i64, i64* %16, i64 %17, !dbg !181
  store i64 %15, i64* %arrayidx7, align 8, !dbg !183
  %18 = load i64*, i64** %ord_len.addr, align 8, !dbg !184
  store i64 0, i64* %18, align 8, !dbg !185
  br label %while.cond, !dbg !186

while.cond:                                       ; preds = %for.end30, %if.end4
  %19 = load i64, i64* %head, align 8, !dbg !187
  %20 = load i64, i64* %tail, align 8, !dbg !188
  %cmp8 = icmp ult i64 %19, %20, !dbg !189
  br i1 %cmp8, label %while.body, label %while.end, !dbg !186

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %u, metadata !190, metadata !DIExpression()), !dbg !192
  %21 = load i64*, i64** %q, align 8, !dbg !193
  %22 = load i64, i64* %head, align 8, !dbg !194
  %inc9 = add i64 %22, 1, !dbg !194
  store i64 %inc9, i64* %head, align 8, !dbg !194
  %arrayidx10 = getelementptr inbounds i64, i64* %21, i64 %22, !dbg !193
  %23 = load i64, i64* %arrayidx10, align 8, !dbg !193
  store i64 %23, i64* %u, align 8, !dbg !192
  %24 = load i64, i64* %u, align 8, !dbg !195
  %25 = load i64*, i64** %order.addr, align 8, !dbg !196
  %26 = load i64*, i64** %ord_len.addr, align 8, !dbg !197
  %27 = load i64, i64* %26, align 8, !dbg !198
  %inc11 = add i64 %27, 1, !dbg !198
  store i64 %inc11, i64* %26, align 8, !dbg !198
  %arrayidx12 = getelementptr inbounds i64, i64* %25, i64 %27, !dbg !196
  store i64 %24, i64* %arrayidx12, align 8, !dbg !199
  call void @llvm.dbg.declare(metadata i64* %v, metadata !200, metadata !DIExpression()), !dbg !202
  store i64 0, i64* %v, align 8, !dbg !202
  br label %for.cond13, !dbg !203

for.cond13:                                       ; preds = %for.inc28, %while.body
  %28 = load i64, i64* %v, align 8, !dbg !204
  %29 = load i64, i64* %n.addr, align 8, !dbg !206
  %cmp14 = icmp ult i64 %28, %29, !dbg !207
  br i1 %cmp14, label %for.body15, label %for.end30, !dbg !208

for.body15:                                       ; preds = %for.cond13
  %30 = load i32*, i32** %g.addr, align 8, !dbg !209
  %31 = load i64, i64* %u, align 8, !dbg !212
  %32 = load i64, i64* %n.addr, align 8, !dbg !213
  %mul16 = mul i64 %31, %32, !dbg !214
  %33 = load i64, i64* %v, align 8, !dbg !215
  %add = add i64 %mul16, %33, !dbg !216
  %arrayidx17 = getelementptr inbounds i32, i32* %30, i64 %add, !dbg !209
  %34 = load i32, i32* %arrayidx17, align 4, !dbg !209
  %tobool18 = icmp ne i32 %34, 0, !dbg !209
  br i1 %tobool18, label %land.lhs.true, label %if.end27, !dbg !217

land.lhs.true:                                    ; preds = %for.body15
  %35 = load i32*, i32** %dist.addr, align 8, !dbg !218
  %36 = load i64, i64* %v, align 8, !dbg !219
  %arrayidx19 = getelementptr inbounds i32, i32* %35, i64 %36, !dbg !218
  %37 = load i32, i32* %arrayidx19, align 4, !dbg !218
  %cmp20 = icmp eq i32 %37, -1, !dbg !220
  br i1 %cmp20, label %if.then21, label %if.end27, !dbg !221

if.then21:                                        ; preds = %land.lhs.true
  %38 = load i32*, i32** %dist.addr, align 8, !dbg !222
  %39 = load i64, i64* %u, align 8, !dbg !224
  %arrayidx22 = getelementptr inbounds i32, i32* %38, i64 %39, !dbg !222
  %40 = load i32, i32* %arrayidx22, align 4, !dbg !222
  %add23 = add nsw i32 %40, 1, !dbg !225
  %41 = load i32*, i32** %dist.addr, align 8, !dbg !226
  %42 = load i64, i64* %v, align 8, !dbg !227
  %arrayidx24 = getelementptr inbounds i32, i32* %41, i64 %42, !dbg !226
  store i32 %add23, i32* %arrayidx24, align 4, !dbg !228
  %43 = load i64, i64* %v, align 8, !dbg !229
  %44 = load i64*, i64** %q, align 8, !dbg !230
  %45 = load i64, i64* %tail, align 8, !dbg !231
  %inc25 = add i64 %45, 1, !dbg !231
  store i64 %inc25, i64* %tail, align 8, !dbg !231
  %arrayidx26 = getelementptr inbounds i64, i64* %44, i64 %45, !dbg !230
  store i64 %43, i64* %arrayidx26, align 8, !dbg !232
  br label %if.end27, !dbg !233

if.end27:                                         ; preds = %if.then21, %land.lhs.true, %for.body15
  br label %for.inc28, !dbg !234

for.inc28:                                        ; preds = %if.end27
  %46 = load i64, i64* %v, align 8, !dbg !235
  %inc29 = add i64 %46, 1, !dbg !235
  store i64 %inc29, i64* %v, align 8, !dbg !235
  br label %for.cond13, !dbg !236, !llvm.loop !237

for.end30:                                        ; preds = %for.cond13
  br label %while.cond, !dbg !186, !llvm.loop !239

while.end:                                        ; preds = %while.cond
  %47 = load i64*, i64** %q, align 8, !dbg !241
  %48 = bitcast i64* %47 to i8*, !dbg !241
  call void @free(i8* noundef %48) #5, !dbg !242
  br label %return, !dbg !243

return:                                           ; preds = %while.end, %if.then3, %if.then
  ret void, !dbg !243
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
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/BFS.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "4b96fd8fb8cbef06e0e928edea17e086")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !5, line: 46, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!6 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!15 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 33, type: !16, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!16 = !DISubroutineType(types: !17)
!17 = !{!18}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !{}
!20 = !DILocalVariable(name: "n", scope: !15, file: !1, line: 34, type: !4)
!21 = !DILocation(line: 34, column: 12, scope: !15)
!22 = !DILocalVariable(name: "g", scope: !15, file: !1, line: 35, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 1568, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 49)
!26 = !DILocation(line: 35, column: 9, scope: !15)
!27 = !DILocation(line: 38, column: 5, scope: !15)
!28 = !DILocation(line: 38, column: 5, scope: !29)
!29 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 5)
!30 = !DILocation(line: 38, column: 15, scope: !15)
!31 = !DILocation(line: 38, column: 15, scope: !32)
!32 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 15)
!33 = !DILocation(line: 38, column: 25, scope: !15)
!34 = !DILocation(line: 38, column: 25, scope: !35)
!35 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 25)
!36 = !DILocation(line: 38, column: 35, scope: !15)
!37 = !DILocation(line: 38, column: 35, scope: !38)
!38 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 35)
!39 = !DILocation(line: 38, column: 45, scope: !15)
!40 = !DILocation(line: 38, column: 45, scope: !41)
!41 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 45)
!42 = !DILocation(line: 38, column: 55, scope: !15)
!43 = !DILocation(line: 38, column: 55, scope: !44)
!44 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 55)
!45 = !DILocation(line: 38, column: 65, scope: !15)
!46 = !DILocation(line: 38, column: 65, scope: !47)
!47 = distinct !DILexicalBlock(scope: !15, file: !1, line: 38, column: 65)
!48 = !DILocalVariable(name: "s", scope: !15, file: !1, line: 41, type: !4)
!49 = !DILocation(line: 41, column: 12, scope: !15)
!50 = !DILocalVariable(name: "dist", scope: !15, file: !1, line: 42, type: !51)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 224, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 7)
!54 = !DILocation(line: 42, column: 9, scope: !15)
!55 = !DILocalVariable(name: "order", scope: !15, file: !1, line: 43, type: !56)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !52)
!57 = !DILocation(line: 43, column: 12, scope: !15)
!58 = !DILocalVariable(name: "ord_len", scope: !15, file: !1, line: 44, type: !4)
!59 = !DILocation(line: 44, column: 12, scope: !15)
!60 = !DILocation(line: 46, column: 9, scope: !15)
!61 = !DILocation(line: 46, column: 12, scope: !15)
!62 = !DILocation(line: 46, column: 15, scope: !15)
!63 = !DILocation(line: 46, column: 18, scope: !15)
!64 = !DILocation(line: 46, column: 24, scope: !15)
!65 = !DILocation(line: 46, column: 5, scope: !15)
!66 = !DILocation(line: 48, column: 36, scope: !15)
!67 = !DILocation(line: 48, column: 5, scope: !15)
!68 = !DILocalVariable(name: "i", scope: !69, file: !1, line: 49, type: !4)
!69 = distinct !DILexicalBlock(scope: !15, file: !1, line: 49, column: 5)
!70 = !DILocation(line: 49, column: 17, scope: !69)
!71 = !DILocation(line: 49, column: 10, scope: !69)
!72 = !DILocation(line: 49, column: 24, scope: !73)
!73 = distinct !DILexicalBlock(scope: !69, file: !1, line: 49, column: 5)
!74 = !DILocation(line: 49, column: 28, scope: !73)
!75 = !DILocation(line: 49, column: 26, scope: !73)
!76 = !DILocation(line: 49, column: 5, scope: !69)
!77 = !DILocation(line: 50, column: 31, scope: !78)
!78 = distinct !DILexicalBlock(scope: !73, file: !1, line: 49, column: 42)
!79 = !DILocation(line: 50, column: 25, scope: !78)
!80 = !DILocation(line: 50, column: 36, scope: !78)
!81 = !DILocation(line: 50, column: 38, scope: !78)
!82 = !DILocation(line: 50, column: 44, scope: !78)
!83 = !DILocation(line: 50, column: 42, scope: !78)
!84 = !DILocation(line: 50, column: 35, scope: !78)
!85 = !DILocation(line: 50, column: 9, scope: !78)
!86 = !DILocation(line: 51, column: 5, scope: !78)
!87 = !DILocation(line: 49, column: 37, scope: !73)
!88 = !DILocation(line: 49, column: 5, scope: !73)
!89 = distinct !{!89, !76, !90, !91}
!90 = !DILocation(line: 51, column: 5, scope: !69)
!91 = !{!"llvm.loop.mustprogress"}
!92 = !DILocation(line: 52, column: 5, scope: !15)
!93 = !DILocalVariable(name: "i", scope: !94, file: !1, line: 54, type: !4)
!94 = distinct !DILexicalBlock(scope: !15, file: !1, line: 54, column: 5)
!95 = !DILocation(line: 54, column: 17, scope: !94)
!96 = !DILocation(line: 54, column: 10, scope: !94)
!97 = !DILocation(line: 54, column: 24, scope: !98)
!98 = distinct !DILexicalBlock(scope: !94, file: !1, line: 54, column: 5)
!99 = !DILocation(line: 54, column: 28, scope: !98)
!100 = !DILocation(line: 54, column: 26, scope: !98)
!101 = !DILocation(line: 54, column: 5, scope: !94)
!102 = !DILocation(line: 55, column: 43, scope: !103)
!103 = distinct !DILexicalBlock(scope: !98, file: !1, line: 54, column: 36)
!104 = !DILocation(line: 55, column: 46, scope: !103)
!105 = !DILocation(line: 55, column: 54, scope: !103)
!106 = !DILocation(line: 55, column: 49, scope: !103)
!107 = !DILocation(line: 55, column: 9, scope: !103)
!108 = !DILocation(line: 56, column: 5, scope: !103)
!109 = !DILocation(line: 54, column: 31, scope: !98)
!110 = !DILocation(line: 54, column: 5, scope: !98)
!111 = distinct !{!111, !101, !112, !91}
!112 = !DILocation(line: 56, column: 5, scope: !94)
!113 = !DILocation(line: 57, column: 5, scope: !15)
!114 = distinct !DISubprogram(name: "bfs", scope: !1, file: !1, line: 5, type: !115, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !19)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !117, !4, !4, !119, !3, !3}
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !18)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!120 = !DILocalVariable(name: "g", arg: 1, scope: !114, file: !1, line: 5, type: !117)
!121 = !DILocation(line: 5, column: 28, scope: !114)
!122 = !DILocalVariable(name: "n", arg: 2, scope: !114, file: !1, line: 5, type: !4)
!123 = !DILocation(line: 5, column: 38, scope: !114)
!124 = !DILocalVariable(name: "s", arg: 3, scope: !114, file: !1, line: 5, type: !4)
!125 = !DILocation(line: 5, column: 48, scope: !114)
!126 = !DILocalVariable(name: "dist", arg: 4, scope: !114, file: !1, line: 5, type: !119)
!127 = !DILocation(line: 5, column: 56, scope: !114)
!128 = !DILocalVariable(name: "order", arg: 5, scope: !114, file: !1, line: 5, type: !3)
!129 = !DILocation(line: 5, column: 70, scope: !114)
!130 = !DILocalVariable(name: "ord_len", arg: 6, scope: !114, file: !1, line: 5, type: !3)
!131 = !DILocation(line: 5, column: 85, scope: !114)
!132 = !DILocation(line: 6, column: 9, scope: !133)
!133 = distinct !DILexicalBlock(scope: !114, file: !1, line: 6, column: 9)
!134 = !DILocation(line: 6, column: 11, scope: !133)
!135 = !DILocation(line: 6, column: 16, scope: !133)
!136 = !DILocation(line: 6, column: 19, scope: !133)
!137 = !DILocation(line: 6, column: 24, scope: !133)
!138 = !DILocation(line: 6, column: 21, scope: !133)
!139 = !DILocation(line: 6, column: 9, scope: !114)
!140 = !DILocation(line: 6, column: 30, scope: !141)
!141 = distinct !DILexicalBlock(scope: !133, file: !1, line: 6, column: 27)
!142 = !DILocation(line: 6, column: 38, scope: !141)
!143 = !DILocation(line: 6, column: 43, scope: !141)
!144 = !DILocalVariable(name: "i", scope: !145, file: !1, line: 8, type: !4)
!145 = distinct !DILexicalBlock(scope: !114, file: !1, line: 8, column: 5)
!146 = !DILocation(line: 8, column: 17, scope: !145)
!147 = !DILocation(line: 8, column: 10, scope: !145)
!148 = !DILocation(line: 8, column: 24, scope: !149)
!149 = distinct !DILexicalBlock(scope: !145, file: !1, line: 8, column: 5)
!150 = !DILocation(line: 8, column: 28, scope: !149)
!151 = !DILocation(line: 8, column: 26, scope: !149)
!152 = !DILocation(line: 8, column: 5, scope: !145)
!153 = !DILocation(line: 8, column: 36, scope: !149)
!154 = !DILocation(line: 8, column: 41, scope: !149)
!155 = !DILocation(line: 8, column: 44, scope: !149)
!156 = !DILocation(line: 8, column: 31, scope: !149)
!157 = !DILocation(line: 8, column: 5, scope: !149)
!158 = distinct !{!158, !152, !159, !91}
!159 = !DILocation(line: 8, column: 47, scope: !145)
!160 = !DILocalVariable(name: "q", scope: !114, file: !1, line: 10, type: !3)
!161 = !DILocation(line: 10, column: 13, scope: !114)
!162 = !DILocation(line: 10, column: 34, scope: !114)
!163 = !DILocation(line: 10, column: 36, scope: !114)
!164 = !DILocation(line: 10, column: 27, scope: !114)
!165 = !DILocation(line: 10, column: 17, scope: !114)
!166 = !DILocation(line: 11, column: 10, scope: !167)
!167 = distinct !DILexicalBlock(scope: !114, file: !1, line: 11, column: 9)
!168 = !DILocation(line: 11, column: 9, scope: !114)
!169 = !DILocation(line: 11, column: 16, scope: !170)
!170 = distinct !DILexicalBlock(scope: !167, file: !1, line: 11, column: 13)
!171 = !DILocation(line: 11, column: 24, scope: !170)
!172 = !DILocation(line: 11, column: 29, scope: !170)
!173 = !DILocalVariable(name: "head", scope: !114, file: !1, line: 13, type: !4)
!174 = !DILocation(line: 13, column: 12, scope: !114)
!175 = !DILocalVariable(name: "tail", scope: !114, file: !1, line: 13, type: !4)
!176 = !DILocation(line: 13, column: 22, scope: !114)
!177 = !DILocation(line: 14, column: 5, scope: !114)
!178 = !DILocation(line: 14, column: 10, scope: !114)
!179 = !DILocation(line: 14, column: 13, scope: !114)
!180 = !DILocation(line: 15, column: 17, scope: !114)
!181 = !DILocation(line: 15, column: 5, scope: !114)
!182 = !DILocation(line: 15, column: 11, scope: !114)
!183 = !DILocation(line: 15, column: 15, scope: !114)
!184 = !DILocation(line: 17, column: 6, scope: !114)
!185 = !DILocation(line: 17, column: 14, scope: !114)
!186 = !DILocation(line: 18, column: 5, scope: !114)
!187 = !DILocation(line: 18, column: 12, scope: !114)
!188 = !DILocation(line: 18, column: 19, scope: !114)
!189 = !DILocation(line: 18, column: 17, scope: !114)
!190 = !DILocalVariable(name: "u", scope: !191, file: !1, line: 19, type: !4)
!191 = distinct !DILexicalBlock(scope: !114, file: !1, line: 18, column: 25)
!192 = !DILocation(line: 19, column: 16, scope: !191)
!193 = !DILocation(line: 19, column: 20, scope: !191)
!194 = !DILocation(line: 19, column: 26, scope: !191)
!195 = !DILocation(line: 20, column: 31, scope: !191)
!196 = !DILocation(line: 20, column: 9, scope: !191)
!197 = !DILocation(line: 20, column: 17, scope: !191)
!198 = !DILocation(line: 20, column: 25, scope: !191)
!199 = !DILocation(line: 20, column: 29, scope: !191)
!200 = !DILocalVariable(name: "v", scope: !201, file: !1, line: 22, type: !4)
!201 = distinct !DILexicalBlock(scope: !191, file: !1, line: 22, column: 9)
!202 = !DILocation(line: 22, column: 21, scope: !201)
!203 = !DILocation(line: 22, column: 14, scope: !201)
!204 = !DILocation(line: 22, column: 28, scope: !205)
!205 = distinct !DILexicalBlock(scope: !201, file: !1, line: 22, column: 9)
!206 = !DILocation(line: 22, column: 32, scope: !205)
!207 = !DILocation(line: 22, column: 30, scope: !205)
!208 = !DILocation(line: 22, column: 9, scope: !201)
!209 = !DILocation(line: 23, column: 17, scope: !210)
!210 = distinct !DILexicalBlock(scope: !211, file: !1, line: 23, column: 17)
!211 = distinct !DILexicalBlock(scope: !205, file: !1, line: 22, column: 40)
!212 = !DILocation(line: 23, column: 19, scope: !210)
!213 = !DILocation(line: 23, column: 21, scope: !210)
!214 = !DILocation(line: 23, column: 20, scope: !210)
!215 = !DILocation(line: 23, column: 25, scope: !210)
!216 = !DILocation(line: 23, column: 23, scope: !210)
!217 = !DILocation(line: 23, column: 28, scope: !210)
!218 = !DILocation(line: 23, column: 31, scope: !210)
!219 = !DILocation(line: 23, column: 36, scope: !210)
!220 = !DILocation(line: 23, column: 39, scope: !210)
!221 = !DILocation(line: 23, column: 17, scope: !211)
!222 = !DILocation(line: 24, column: 27, scope: !223)
!223 = distinct !DILexicalBlock(scope: !210, file: !1, line: 23, column: 46)
!224 = !DILocation(line: 24, column: 32, scope: !223)
!225 = !DILocation(line: 24, column: 35, scope: !223)
!226 = !DILocation(line: 24, column: 17, scope: !223)
!227 = !DILocation(line: 24, column: 22, scope: !223)
!228 = !DILocation(line: 24, column: 25, scope: !223)
!229 = !DILocation(line: 25, column: 29, scope: !223)
!230 = !DILocation(line: 25, column: 17, scope: !223)
!231 = !DILocation(line: 25, column: 23, scope: !223)
!232 = !DILocation(line: 25, column: 27, scope: !223)
!233 = !DILocation(line: 26, column: 13, scope: !223)
!234 = !DILocation(line: 27, column: 9, scope: !211)
!235 = !DILocation(line: 22, column: 35, scope: !205)
!236 = !DILocation(line: 22, column: 9, scope: !205)
!237 = distinct !{!237, !208, !238, !91}
!238 = !DILocation(line: 27, column: 9, scope: !201)
!239 = distinct !{!239, !186, !240, !91}
!240 = !DILocation(line: 28, column: 5, scope: !114)
!241 = !DILocation(line: 30, column: 10, scope: !114)
!242 = !DILocation(line: 30, column: 5, scope: !114)
!243 = !DILocation(line: 31, column: 1, scope: !114)

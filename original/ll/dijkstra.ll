; ModuleID = '../original/src/dijkstra.c'
source_filename = "../original/src/dijkstra.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@.str.1 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@.str.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i64, align 8
  %g = alloca [36 x i32], align 16
  %i = alloca i64, align 8
  %i1 = alloca i64, align 8
  %s = alloca i64, align 8
  %dist = alloca [6 x i32], align 16
  %prev = alloca [6 x i32], align 16
  %i66 = alloca i64, align 8
  %t = alloca i64, align 8
  %path = alloca [6 x i64], align 16
  %k = alloca i64, align 8
  %v = alloca i32, align 4
  %i93 = alloca i64, align 8
  %v98 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i64* %n, metadata !20, metadata !DIExpression()), !dbg !21
  store i64 6, i64* %n, align 8, !dbg !21
  call void @llvm.dbg.declare(metadata [36 x i32]* %g, metadata !22, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %i, metadata !27, metadata !DIExpression()), !dbg !29
  store i64 0, i64* %i, align 8, !dbg !29
  br label %for.cond, !dbg !30

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64, i64* %i, align 8, !dbg !31
  %1 = load i64, i64* %n, align 8, !dbg !33
  %2 = load i64, i64* %n, align 8, !dbg !34
  %mul = mul i64 %1, %2, !dbg !35
  %cmp = icmp ult i64 %0, %mul, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %3 = load i64, i64* %i, align 8, !dbg !38
  %arrayidx = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %3, !dbg !39
  store i32 -1, i32* %arrayidx, align 4, !dbg !40
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %4 = load i64, i64* %i, align 8, !dbg !41
  %inc = add i64 %4, 1, !dbg !41
  store i64 %inc, i64* %i, align 8, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i64* %i1, metadata !46, metadata !DIExpression()), !dbg !48
  store i64 0, i64* %i1, align 8, !dbg !48
  br label %for.cond2, !dbg !49

for.cond2:                                        ; preds = %for.inc7, %for.end
  %5 = load i64, i64* %i1, align 8, !dbg !50
  %6 = load i64, i64* %n, align 8, !dbg !52
  %cmp3 = icmp ult i64 %5, %6, !dbg !53
  br i1 %cmp3, label %for.body4, label %for.end9, !dbg !54

for.body4:                                        ; preds = %for.cond2
  %7 = load i64, i64* %i1, align 8, !dbg !55
  %8 = load i64, i64* %n, align 8, !dbg !56
  %mul5 = mul i64 %7, %8, !dbg !57
  %9 = load i64, i64* %i1, align 8, !dbg !58
  %add = add i64 %mul5, %9, !dbg !59
  %arrayidx6 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add, !dbg !60
  store i32 0, i32* %arrayidx6, align 4, !dbg !61
  br label %for.inc7, !dbg !60

for.inc7:                                         ; preds = %for.body4
  %10 = load i64, i64* %i1, align 8, !dbg !62
  %inc8 = add i64 %10, 1, !dbg !62
  store i64 %inc8, i64* %i1, align 8, !dbg !62
  br label %for.cond2, !dbg !63, !llvm.loop !64

for.end9:                                         ; preds = %for.cond2
  br label %do.body, !dbg !66

do.body:                                          ; preds = %for.end9
  %11 = load i64, i64* %n, align 8, !dbg !67
  %mul10 = mul i64 0, %11, !dbg !67
  %add11 = add i64 %mul10, 1, !dbg !67
  %arrayidx12 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add11, !dbg !67
  store i32 7, i32* %arrayidx12, align 4, !dbg !67
  %12 = load i64, i64* %n, align 8, !dbg !67
  %mul13 = mul i64 1, %12, !dbg !67
  %add14 = add i64 %mul13, 0, !dbg !67
  %arrayidx15 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add14, !dbg !67
  store i32 7, i32* %arrayidx15, align 4, !dbg !67
  br label %do.end, !dbg !67

do.end:                                           ; preds = %do.body
  br label %do.body16, !dbg !69

do.body16:                                        ; preds = %do.end
  %13 = load i64, i64* %n, align 8, !dbg !70
  %mul17 = mul i64 0, %13, !dbg !70
  %add18 = add i64 %mul17, 2, !dbg !70
  %arrayidx19 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add18, !dbg !70
  store i32 9, i32* %arrayidx19, align 4, !dbg !70
  %14 = load i64, i64* %n, align 8, !dbg !70
  %mul20 = mul i64 2, %14, !dbg !70
  %add21 = add i64 %mul20, 0, !dbg !70
  %arrayidx22 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add21, !dbg !70
  store i32 9, i32* %arrayidx22, align 4, !dbg !70
  br label %do.end23, !dbg !70

do.end23:                                         ; preds = %do.body16
  br label %do.body24, !dbg !72

do.body24:                                        ; preds = %do.end23
  %15 = load i64, i64* %n, align 8, !dbg !73
  %mul25 = mul i64 0, %15, !dbg !73
  %add26 = add i64 %mul25, 3, !dbg !73
  %arrayidx27 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add26, !dbg !73
  store i32 10, i32* %arrayidx27, align 4, !dbg !73
  %16 = load i64, i64* %n, align 8, !dbg !73
  %mul28 = mul i64 3, %16, !dbg !73
  %add29 = add i64 %mul28, 0, !dbg !73
  %arrayidx30 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add29, !dbg !73
  store i32 10, i32* %arrayidx30, align 4, !dbg !73
  br label %do.end31, !dbg !73

do.end31:                                         ; preds = %do.body24
  br label %do.body32, !dbg !75

do.body32:                                        ; preds = %do.end31
  %17 = load i64, i64* %n, align 8, !dbg !76
  %mul33 = mul i64 1, %17, !dbg !76
  %add34 = add i64 %mul33, 3, !dbg !76
  %arrayidx35 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add34, !dbg !76
  store i32 15, i32* %arrayidx35, align 4, !dbg !76
  %18 = load i64, i64* %n, align 8, !dbg !76
  %mul36 = mul i64 3, %18, !dbg !76
  %add37 = add i64 %mul36, 1, !dbg !76
  %arrayidx38 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add37, !dbg !76
  store i32 15, i32* %arrayidx38, align 4, !dbg !76
  br label %do.end39, !dbg !76

do.end39:                                         ; preds = %do.body32
  br label %do.body40, !dbg !78

do.body40:                                        ; preds = %do.end39
  %19 = load i64, i64* %n, align 8, !dbg !79
  %mul41 = mul i64 2, %19, !dbg !79
  %add42 = add i64 %mul41, 3, !dbg !79
  %arrayidx43 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add42, !dbg !79
  store i32 11, i32* %arrayidx43, align 4, !dbg !79
  %20 = load i64, i64* %n, align 8, !dbg !79
  %mul44 = mul i64 3, %20, !dbg !79
  %add45 = add i64 %mul44, 2, !dbg !79
  %arrayidx46 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add45, !dbg !79
  store i32 11, i32* %arrayidx46, align 4, !dbg !79
  br label %do.end47, !dbg !79

do.end47:                                         ; preds = %do.body40
  br label %do.body48, !dbg !81

do.body48:                                        ; preds = %do.end47
  %21 = load i64, i64* %n, align 8, !dbg !82
  %mul49 = mul i64 3, %21, !dbg !82
  %add50 = add i64 %mul49, 4, !dbg !82
  %arrayidx51 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add50, !dbg !82
  store i32 6, i32* %arrayidx51, align 4, !dbg !82
  %22 = load i64, i64* %n, align 8, !dbg !82
  %mul52 = mul i64 4, %22, !dbg !82
  %add53 = add i64 %mul52, 3, !dbg !82
  %arrayidx54 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add53, !dbg !82
  store i32 6, i32* %arrayidx54, align 4, !dbg !82
  br label %do.end55, !dbg !82

do.end55:                                         ; preds = %do.body48
  br label %do.body56, !dbg !84

do.body56:                                        ; preds = %do.end55
  %23 = load i64, i64* %n, align 8, !dbg !85
  %mul57 = mul i64 4, %23, !dbg !85
  %add58 = add i64 %mul57, 5, !dbg !85
  %arrayidx59 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add58, !dbg !85
  store i32 9, i32* %arrayidx59, align 4, !dbg !85
  %24 = load i64, i64* %n, align 8, !dbg !85
  %mul60 = mul i64 5, %24, !dbg !85
  %add61 = add i64 %mul60, 4, !dbg !85
  %arrayidx62 = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 %add61, !dbg !85
  store i32 9, i32* %arrayidx62, align 4, !dbg !85
  br label %do.end63, !dbg !85

do.end63:                                         ; preds = %do.body56
  call void @llvm.dbg.declare(metadata i64* %s, metadata !87, metadata !DIExpression()), !dbg !88
  store i64 0, i64* %s, align 8, !dbg !88
  call void @llvm.dbg.declare(metadata [6 x i32]* %dist, metadata !89, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.declare(metadata [6 x i32]* %prev, metadata !94, metadata !DIExpression()), !dbg !95
  %arraydecay = getelementptr inbounds [36 x i32], [36 x i32]* %g, i64 0, i64 0, !dbg !96
  %25 = load i64, i64* %n, align 8, !dbg !97
  %26 = load i64, i64* %s, align 8, !dbg !98
  %arraydecay64 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0, !dbg !99
  %arraydecay65 = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 0, !dbg !100
  call void @dijkstra(i32* noundef %arraydecay, i64 noundef %25, i64 noundef %26, i32* noundef %arraydecay64, i32* noundef %arraydecay65), !dbg !101
  call void @llvm.dbg.declare(metadata i64* %i66, metadata !102, metadata !DIExpression()), !dbg !104
  store i64 0, i64* %i66, align 8, !dbg !104
  br label %for.cond67, !dbg !105

for.cond67:                                       ; preds = %for.inc74, %do.end63
  %27 = load i64, i64* %i66, align 8, !dbg !106
  %28 = load i64, i64* %n, align 8, !dbg !108
  %cmp68 = icmp ult i64 %27, %28, !dbg !109
  br i1 %cmp68, label %for.body69, label %for.end76, !dbg !110

for.body69:                                       ; preds = %for.cond67
  %29 = load i64, i64* %i66, align 8, !dbg !111
  %arrayidx70 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %29, !dbg !114
  %30 = load i32, i32* %arrayidx70, align 4, !dbg !114
  %cmp71 = icmp sge i32 %30, 1061109567, !dbg !115
  br i1 %cmp71, label %if.then, label %if.else, !dbg !116

if.then:                                          ; preds = %for.body69
  %31 = load i64, i64* %s, align 8, !dbg !117
  %32 = load i64, i64* %i66, align 8, !dbg !118
  %call = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef %31, i64 noundef %32), !dbg !119
  br label %if.end, !dbg !119

if.else:                                          ; preds = %for.body69
  %33 = load i64, i64* %s, align 8, !dbg !120
  %34 = load i64, i64* %i66, align 8, !dbg !121
  %35 = load i64, i64* %i66, align 8, !dbg !122
  %arrayidx72 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %35, !dbg !123
  %36 = load i32, i32* %arrayidx72, align 4, !dbg !123
  %call73 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 noundef %33, i64 noundef %34, i32 noundef %36), !dbg !124
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc74, !dbg !125

for.inc74:                                        ; preds = %if.end
  %37 = load i64, i64* %i66, align 8, !dbg !126
  %inc75 = add i64 %37, 1, !dbg !126
  store i64 %inc75, i64* %i66, align 8, !dbg !126
  br label %for.cond67, !dbg !127, !llvm.loop !128

for.end76:                                        ; preds = %for.cond67
  call void @llvm.dbg.declare(metadata i64* %t, metadata !130, metadata !DIExpression()), !dbg !131
  store i64 5, i64* %t, align 8, !dbg !131
  %38 = load i64, i64* %t, align 8, !dbg !132
  %arrayidx77 = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %38, !dbg !134
  %39 = load i32, i32* %arrayidx77, align 4, !dbg !134
  %cmp78 = icmp sge i32 %39, 1061109567, !dbg !135
  br i1 %cmp78, label %if.then79, label %if.else81, !dbg !136

if.then79:                                        ; preds = %for.end76
  %40 = load i64, i64* %s, align 8, !dbg !137
  %41 = load i64, i64* %t, align 8, !dbg !139
  %call80 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0), i64 noundef %40, i64 noundef %41), !dbg !140
  br label %if.end109, !dbg !141

if.else81:                                        ; preds = %for.end76
  call void @llvm.dbg.declare(metadata [6 x i64]* %path, metadata !142, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.declare(metadata i64* %k, metadata !146, metadata !DIExpression()), !dbg !147
  store i64 0, i64* %k, align 8, !dbg !147
  call void @llvm.dbg.declare(metadata i32* %v, metadata !148, metadata !DIExpression()), !dbg !150
  %42 = load i64, i64* %t, align 8, !dbg !151
  %conv = trunc i64 %42 to i32, !dbg !152
  store i32 %conv, i32* %v, align 4, !dbg !150
  br label %for.cond82, !dbg !153

for.cond82:                                       ; preds = %for.inc89, %if.else81
  %43 = load i32, i32* %v, align 4, !dbg !154
  %cmp83 = icmp ne i32 %43, -1, !dbg !156
  br i1 %cmp83, label %for.body85, label %for.end91, !dbg !157

for.body85:                                       ; preds = %for.cond82
  %44 = load i32, i32* %v, align 4, !dbg !158
  %conv86 = sext i32 %44 to i64, !dbg !159
  %45 = load i64, i64* %k, align 8, !dbg !160
  %inc87 = add i64 %45, 1, !dbg !160
  store i64 %inc87, i64* %k, align 8, !dbg !160
  %arrayidx88 = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %45, !dbg !161
  store i64 %conv86, i64* %arrayidx88, align 8, !dbg !162
  br label %for.inc89, !dbg !161

for.inc89:                                        ; preds = %for.body85
  %46 = load i32, i32* %v, align 4, !dbg !163
  %idxprom = sext i32 %46 to i64, !dbg !164
  %arrayidx90 = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %idxprom, !dbg !164
  %47 = load i32, i32* %arrayidx90, align 4, !dbg !164
  store i32 %47, i32* %v, align 4, !dbg !165
  br label %for.cond82, !dbg !166, !llvm.loop !167

for.end91:                                        ; preds = %for.cond82
  %48 = load i64, i64* %s, align 8, !dbg !169
  %49 = load i64, i64* %t, align 8, !dbg !170
  %call92 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i64 noundef %48, i64 noundef %49), !dbg !171
  call void @llvm.dbg.declare(metadata i64* %i93, metadata !172, metadata !DIExpression()), !dbg !174
  store i64 0, i64* %i93, align 8, !dbg !174
  br label %for.cond94, !dbg !175

for.cond94:                                       ; preds = %for.inc105, %for.end91
  %50 = load i64, i64* %i93, align 8, !dbg !176
  %51 = load i64, i64* %k, align 8, !dbg !178
  %cmp95 = icmp ult i64 %50, %51, !dbg !179
  br i1 %cmp95, label %for.body97, label %for.end107, !dbg !180

for.body97:                                       ; preds = %for.cond94
  call void @llvm.dbg.declare(metadata i64* %v98, metadata !181, metadata !DIExpression()), !dbg !183
  %52 = load i64, i64* %k, align 8, !dbg !184
  %sub = sub i64 %52, 1, !dbg !185
  %53 = load i64, i64* %i93, align 8, !dbg !186
  %sub99 = sub i64 %sub, %53, !dbg !187
  %arrayidx100 = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %sub99, !dbg !188
  %54 = load i64, i64* %arrayidx100, align 8, !dbg !188
  store i64 %54, i64* %v98, align 8, !dbg !183
  %55 = load i64, i64* %v98, align 8, !dbg !189
  %56 = load i64, i64* %i93, align 8, !dbg !190
  %add101 = add i64 %56, 1, !dbg !191
  %57 = load i64, i64* %k, align 8, !dbg !192
  %cmp102 = icmp ult i64 %add101, %57, !dbg !193
  %58 = zext i1 %cmp102 to i64, !dbg !194
  %cond = select i1 %cmp102, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.6, i64 0, i64 0), !dbg !194
  %call104 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i64 noundef %55, i8* noundef %cond), !dbg !195
  br label %for.inc105, !dbg !196

for.inc105:                                       ; preds = %for.body97
  %59 = load i64, i64* %i93, align 8, !dbg !197
  %inc106 = add i64 %59, 1, !dbg !197
  store i64 %inc106, i64* %i93, align 8, !dbg !197
  br label %for.cond94, !dbg !198, !llvm.loop !199

for.end107:                                       ; preds = %for.cond94
  %call108 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i64 0, i64 0)), !dbg !201
  br label %if.end109

if.end109:                                        ; preds = %for.end107, %if.then79
  ret i32 0, !dbg !202
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @dijkstra(i32* noundef %w, i64 noundef %n, i64 noundef %s, i32* noundef %dist, i32* noundef %prev) #0 !dbg !203 {
entry:
  %w.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %s.addr = alloca i64, align 8
  %dist.addr = alloca i32*, align 8
  %prev.addr = alloca i32*, align 8
  %used = alloca i32*, align 8
  %i = alloca i64, align 8
  %it = alloca i64, align 8
  %u = alloca i64, align 8
  %best = alloca i32, align 4
  %i11 = alloca i64, align 8
  %v = alloca i64, align 8
  %w_uv = alloca i32, align 4
  store i32* %w, i32** %w.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %w.addr, metadata !208, metadata !DIExpression()), !dbg !209
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !210, metadata !DIExpression()), !dbg !211
  store i64 %s, i64* %s.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %s.addr, metadata !212, metadata !DIExpression()), !dbg !213
  store i32* %dist, i32** %dist.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %dist.addr, metadata !214, metadata !DIExpression()), !dbg !215
  store i32* %prev, i32** %prev.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %prev.addr, metadata !216, metadata !DIExpression()), !dbg !217
  %0 = load i64, i64* %n.addr, align 8, !dbg !218
  %cmp = icmp eq i64 %0, 0, !dbg !220
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !221

lor.lhs.false:                                    ; preds = %entry
  %1 = load i64, i64* %s.addr, align 8, !dbg !222
  %2 = load i64, i64* %n.addr, align 8, !dbg !223
  %cmp1 = icmp uge i64 %1, %2, !dbg !224
  br i1 %cmp1, label %if.then, label %if.end, !dbg !225

if.then:                                          ; preds = %lor.lhs.false, %entry
  br label %return, !dbg !226

if.end:                                           ; preds = %lor.lhs.false
  call void @llvm.dbg.declare(metadata i32** %used, metadata !227, metadata !DIExpression()), !dbg !228
  %3 = load i64, i64* %n.addr, align 8, !dbg !229
  %mul = mul i64 %3, 4, !dbg !230
  %call = call noalias i8* @malloc(i64 noundef %mul) #4, !dbg !231
  %4 = bitcast i8* %call to i32*, !dbg !232
  store i32* %4, i32** %used, align 8, !dbg !228
  %5 = load i32*, i32** %used, align 8, !dbg !233
  %tobool = icmp ne i32* %5, null, !dbg !233
  br i1 %tobool, label %if.end3, label %if.then2, !dbg !235

if.then2:                                         ; preds = %if.end
  br label %return, !dbg !236

if.end3:                                          ; preds = %if.end
  call void @llvm.dbg.declare(metadata i64* %i, metadata !237, metadata !DIExpression()), !dbg !239
  store i64 0, i64* %i, align 8, !dbg !239
  br label %for.cond, !dbg !240

for.cond:                                         ; preds = %for.inc, %if.end3
  %6 = load i64, i64* %i, align 8, !dbg !241
  %7 = load i64, i64* %n.addr, align 8, !dbg !243
  %cmp4 = icmp ult i64 %6, %7, !dbg !244
  br i1 %cmp4, label %for.body, label %for.end, !dbg !245

for.body:                                         ; preds = %for.cond
  %8 = load i32*, i32** %dist.addr, align 8, !dbg !246
  %9 = load i64, i64* %i, align 8, !dbg !248
  %arrayidx = getelementptr inbounds i32, i32* %8, i64 %9, !dbg !246
  store i32 1061109567, i32* %arrayidx, align 4, !dbg !249
  %10 = load i32*, i32** %prev.addr, align 8, !dbg !250
  %11 = load i64, i64* %i, align 8, !dbg !251
  %arrayidx5 = getelementptr inbounds i32, i32* %10, i64 %11, !dbg !250
  store i32 -1, i32* %arrayidx5, align 4, !dbg !252
  %12 = load i32*, i32** %used, align 8, !dbg !253
  %13 = load i64, i64* %i, align 8, !dbg !254
  %arrayidx6 = getelementptr inbounds i32, i32* %12, i64 %13, !dbg !253
  store i32 0, i32* %arrayidx6, align 4, !dbg !255
  br label %for.inc, !dbg !256

for.inc:                                          ; preds = %for.body
  %14 = load i64, i64* %i, align 8, !dbg !257
  %inc = add i64 %14, 1, !dbg !257
  store i64 %inc, i64* %i, align 8, !dbg !257
  br label %for.cond, !dbg !258, !llvm.loop !259

for.end:                                          ; preds = %for.cond
  %15 = load i32*, i32** %dist.addr, align 8, !dbg !261
  %16 = load i64, i64* %s.addr, align 8, !dbg !262
  %arrayidx7 = getelementptr inbounds i32, i32* %15, i64 %16, !dbg !261
  store i32 0, i32* %arrayidx7, align 4, !dbg !263
  call void @llvm.dbg.declare(metadata i64* %it, metadata !264, metadata !DIExpression()), !dbg !266
  store i64 0, i64* %it, align 8, !dbg !266
  br label %for.cond8, !dbg !267

for.cond8:                                        ; preds = %for.inc56, %for.end
  %17 = load i64, i64* %it, align 8, !dbg !268
  %18 = load i64, i64* %n.addr, align 8, !dbg !270
  %cmp9 = icmp ult i64 %17, %18, !dbg !271
  br i1 %cmp9, label %for.body10, label %for.end58, !dbg !272

for.body10:                                       ; preds = %for.cond8
  call void @llvm.dbg.declare(metadata i64* %u, metadata !273, metadata !DIExpression()), !dbg !275
  %19 = load i64, i64* %n.addr, align 8, !dbg !276
  store i64 %19, i64* %u, align 8, !dbg !275
  call void @llvm.dbg.declare(metadata i32* %best, metadata !277, metadata !DIExpression()), !dbg !278
  store i32 1061109567, i32* %best, align 4, !dbg !278
  call void @llvm.dbg.declare(metadata i64* %i11, metadata !279, metadata !DIExpression()), !dbg !281
  store i64 0, i64* %i11, align 8, !dbg !281
  br label %for.cond12, !dbg !282

for.cond12:                                       ; preds = %for.inc22, %for.body10
  %20 = load i64, i64* %i11, align 8, !dbg !283
  %21 = load i64, i64* %n.addr, align 8, !dbg !285
  %cmp13 = icmp ult i64 %20, %21, !dbg !286
  br i1 %cmp13, label %for.body14, label %for.end24, !dbg !287

for.body14:                                       ; preds = %for.cond12
  %22 = load i32*, i32** %used, align 8, !dbg !288
  %23 = load i64, i64* %i11, align 8, !dbg !291
  %arrayidx15 = getelementptr inbounds i32, i32* %22, i64 %23, !dbg !288
  %24 = load i32, i32* %arrayidx15, align 4, !dbg !288
  %tobool16 = icmp ne i32 %24, 0, !dbg !288
  br i1 %tobool16, label %if.end21, label %land.lhs.true, !dbg !292

land.lhs.true:                                    ; preds = %for.body14
  %25 = load i32*, i32** %dist.addr, align 8, !dbg !293
  %26 = load i64, i64* %i11, align 8, !dbg !294
  %arrayidx17 = getelementptr inbounds i32, i32* %25, i64 %26, !dbg !293
  %27 = load i32, i32* %arrayidx17, align 4, !dbg !293
  %28 = load i32, i32* %best, align 4, !dbg !295
  %cmp18 = icmp slt i32 %27, %28, !dbg !296
  br i1 %cmp18, label %if.then19, label %if.end21, !dbg !297

if.then19:                                        ; preds = %land.lhs.true
  %29 = load i32*, i32** %dist.addr, align 8, !dbg !298
  %30 = load i64, i64* %i11, align 8, !dbg !300
  %arrayidx20 = getelementptr inbounds i32, i32* %29, i64 %30, !dbg !298
  %31 = load i32, i32* %arrayidx20, align 4, !dbg !298
  store i32 %31, i32* %best, align 4, !dbg !301
  %32 = load i64, i64* %i11, align 8, !dbg !302
  store i64 %32, i64* %u, align 8, !dbg !303
  br label %if.end21, !dbg !304

if.end21:                                         ; preds = %if.then19, %land.lhs.true, %for.body14
  br label %for.inc22, !dbg !305

for.inc22:                                        ; preds = %if.end21
  %33 = load i64, i64* %i11, align 8, !dbg !306
  %inc23 = add i64 %33, 1, !dbg !306
  store i64 %inc23, i64* %i11, align 8, !dbg !306
  br label %for.cond12, !dbg !307, !llvm.loop !308

for.end24:                                        ; preds = %for.cond12
  %34 = load i64, i64* %u, align 8, !dbg !310
  %35 = load i64, i64* %n.addr, align 8, !dbg !312
  %cmp25 = icmp eq i64 %34, %35, !dbg !313
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !314

if.then26:                                        ; preds = %for.end24
  br label %for.end58, !dbg !315

if.end27:                                         ; preds = %for.end24
  %36 = load i32*, i32** %used, align 8, !dbg !316
  %37 = load i64, i64* %u, align 8, !dbg !317
  %arrayidx28 = getelementptr inbounds i32, i32* %36, i64 %37, !dbg !316
  store i32 1, i32* %arrayidx28, align 4, !dbg !318
  call void @llvm.dbg.declare(metadata i64* %v, metadata !319, metadata !DIExpression()), !dbg !321
  store i64 0, i64* %v, align 8, !dbg !321
  br label %for.cond29, !dbg !322

for.cond29:                                       ; preds = %for.inc53, %if.end27
  %38 = load i64, i64* %v, align 8, !dbg !323
  %39 = load i64, i64* %n.addr, align 8, !dbg !325
  %cmp30 = icmp ult i64 %38, %39, !dbg !326
  br i1 %cmp30, label %for.body31, label %for.end55, !dbg !327

for.body31:                                       ; preds = %for.cond29
  call void @llvm.dbg.declare(metadata i32* %w_uv, metadata !328, metadata !DIExpression()), !dbg !330
  %40 = load i32*, i32** %w.addr, align 8, !dbg !331
  %41 = load i64, i64* %u, align 8, !dbg !332
  %42 = load i64, i64* %n.addr, align 8, !dbg !333
  %mul32 = mul i64 %41, %42, !dbg !334
  %43 = load i64, i64* %v, align 8, !dbg !335
  %add = add i64 %mul32, %43, !dbg !336
  %arrayidx33 = getelementptr inbounds i32, i32* %40, i64 %add, !dbg !331
  %44 = load i32, i32* %arrayidx33, align 4, !dbg !331
  store i32 %44, i32* %w_uv, align 4, !dbg !330
  %45 = load i32, i32* %w_uv, align 4, !dbg !337
  %cmp34 = icmp sge i32 %45, 0, !dbg !339
  br i1 %cmp34, label %land.lhs.true35, label %if.end52, !dbg !340

land.lhs.true35:                                  ; preds = %for.body31
  %46 = load i32*, i32** %used, align 8, !dbg !341
  %47 = load i64, i64* %v, align 8, !dbg !342
  %arrayidx36 = getelementptr inbounds i32, i32* %46, i64 %47, !dbg !341
  %48 = load i32, i32* %arrayidx36, align 4, !dbg !341
  %tobool37 = icmp ne i32 %48, 0, !dbg !341
  br i1 %tobool37, label %if.end52, label %if.then38, !dbg !343

if.then38:                                        ; preds = %land.lhs.true35
  %49 = load i32*, i32** %dist.addr, align 8, !dbg !344
  %50 = load i64, i64* %u, align 8, !dbg !347
  %arrayidx39 = getelementptr inbounds i32, i32* %49, i64 %50, !dbg !344
  %51 = load i32, i32* %arrayidx39, align 4, !dbg !344
  %cmp40 = icmp ne i32 %51, 1061109567, !dbg !348
  br i1 %cmp40, label %land.lhs.true41, label %if.end51, !dbg !349

land.lhs.true41:                                  ; preds = %if.then38
  %52 = load i32*, i32** %dist.addr, align 8, !dbg !350
  %53 = load i64, i64* %u, align 8, !dbg !351
  %arrayidx42 = getelementptr inbounds i32, i32* %52, i64 %53, !dbg !350
  %54 = load i32, i32* %arrayidx42, align 4, !dbg !350
  %55 = load i32, i32* %w_uv, align 4, !dbg !352
  %add43 = add nsw i32 %54, %55, !dbg !353
  %56 = load i32*, i32** %dist.addr, align 8, !dbg !354
  %57 = load i64, i64* %v, align 8, !dbg !355
  %arrayidx44 = getelementptr inbounds i32, i32* %56, i64 %57, !dbg !354
  %58 = load i32, i32* %arrayidx44, align 4, !dbg !354
  %cmp45 = icmp slt i32 %add43, %58, !dbg !356
  br i1 %cmp45, label %if.then46, label %if.end51, !dbg !357

if.then46:                                        ; preds = %land.lhs.true41
  %59 = load i32*, i32** %dist.addr, align 8, !dbg !358
  %60 = load i64, i64* %u, align 8, !dbg !360
  %arrayidx47 = getelementptr inbounds i32, i32* %59, i64 %60, !dbg !358
  %61 = load i32, i32* %arrayidx47, align 4, !dbg !358
  %62 = load i32, i32* %w_uv, align 4, !dbg !361
  %add48 = add nsw i32 %61, %62, !dbg !362
  %63 = load i32*, i32** %dist.addr, align 8, !dbg !363
  %64 = load i64, i64* %v, align 8, !dbg !364
  %arrayidx49 = getelementptr inbounds i32, i32* %63, i64 %64, !dbg !363
  store i32 %add48, i32* %arrayidx49, align 4, !dbg !365
  %65 = load i64, i64* %u, align 8, !dbg !366
  %conv = trunc i64 %65 to i32, !dbg !367
  %66 = load i32*, i32** %prev.addr, align 8, !dbg !368
  %67 = load i64, i64* %v, align 8, !dbg !369
  %arrayidx50 = getelementptr inbounds i32, i32* %66, i64 %67, !dbg !368
  store i32 %conv, i32* %arrayidx50, align 4, !dbg !370
  br label %if.end51, !dbg !371

if.end51:                                         ; preds = %if.then46, %land.lhs.true41, %if.then38
  br label %if.end52, !dbg !372

if.end52:                                         ; preds = %if.end51, %land.lhs.true35, %for.body31
  br label %for.inc53, !dbg !373

for.inc53:                                        ; preds = %if.end52
  %68 = load i64, i64* %v, align 8, !dbg !374
  %inc54 = add i64 %68, 1, !dbg !374
  store i64 %inc54, i64* %v, align 8, !dbg !374
  br label %for.cond29, !dbg !375, !llvm.loop !376

for.end55:                                        ; preds = %for.cond29
  br label %for.inc56, !dbg !378

for.inc56:                                        ; preds = %for.end55
  %69 = load i64, i64* %it, align 8, !dbg !379
  %inc57 = add i64 %69, 1, !dbg !379
  store i64 %inc57, i64* %it, align 8, !dbg !379
  br label %for.cond8, !dbg !380, !llvm.loop !381

for.end58:                                        ; preds = %if.then26, %for.cond8
  %70 = load i32*, i32** %used, align 8, !dbg !383
  %71 = bitcast i32* %70 to i8*, !dbg !383
  call void @free(i8* noundef %71) #4, !dbg !384
  br label %return, !dbg !385

return:                                           ; preds = %for.end58, %if.then2, %if.then
  ret void, !dbg !385
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/dijkstra.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "50c00f90496298f582db49908e99519f")
!2 = !{!3, !4, !7}
!3 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !5, line: 46, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!6 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !3, size: 64)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 1}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!16 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 47, type: !17, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!3}
!19 = !{}
!20 = !DILocalVariable(name: "n", scope: !16, file: !1, line: 48, type: !4)
!21 = !DILocation(line: 48, column: 12, scope: !16)
!22 = !DILocalVariable(name: "g", scope: !16, file: !1, line: 49, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !3, size: 1152, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 36)
!26 = !DILocation(line: 49, column: 9, scope: !16)
!27 = !DILocalVariable(name: "i", scope: !28, file: !1, line: 50, type: !4)
!28 = distinct !DILexicalBlock(scope: !16, file: !1, line: 50, column: 5)
!29 = !DILocation(line: 50, column: 17, scope: !28)
!30 = !DILocation(line: 50, column: 10, scope: !28)
!31 = !DILocation(line: 50, column: 24, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !1, line: 50, column: 5)
!33 = !DILocation(line: 50, column: 28, scope: !32)
!34 = !DILocation(line: 50, column: 30, scope: !32)
!35 = !DILocation(line: 50, column: 29, scope: !32)
!36 = !DILocation(line: 50, column: 26, scope: !32)
!37 = !DILocation(line: 50, column: 5, scope: !28)
!38 = !DILocation(line: 50, column: 40, scope: !32)
!39 = !DILocation(line: 50, column: 38, scope: !32)
!40 = !DILocation(line: 50, column: 43, scope: !32)
!41 = !DILocation(line: 50, column: 33, scope: !32)
!42 = !DILocation(line: 50, column: 5, scope: !32)
!43 = distinct !{!43, !37, !44, !45}
!44 = !DILocation(line: 50, column: 46, scope: !28)
!45 = !{!"llvm.loop.mustprogress"}
!46 = !DILocalVariable(name: "i", scope: !47, file: !1, line: 51, type: !4)
!47 = distinct !DILexicalBlock(scope: !16, file: !1, line: 51, column: 5)
!48 = !DILocation(line: 51, column: 17, scope: !47)
!49 = !DILocation(line: 51, column: 10, scope: !47)
!50 = !DILocation(line: 51, column: 24, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !1, line: 51, column: 5)
!52 = !DILocation(line: 51, column: 28, scope: !51)
!53 = !DILocation(line: 51, column: 26, scope: !51)
!54 = !DILocation(line: 51, column: 5, scope: !47)
!55 = !DILocation(line: 51, column: 38, scope: !51)
!56 = !DILocation(line: 51, column: 40, scope: !51)
!57 = !DILocation(line: 51, column: 39, scope: !51)
!58 = !DILocation(line: 51, column: 44, scope: !51)
!59 = !DILocation(line: 51, column: 42, scope: !51)
!60 = !DILocation(line: 51, column: 36, scope: !51)
!61 = !DILocation(line: 51, column: 47, scope: !51)
!62 = !DILocation(line: 51, column: 31, scope: !51)
!63 = !DILocation(line: 51, column: 5, scope: !51)
!64 = distinct !{!64, !54, !65, !45}
!65 = !DILocation(line: 51, column: 49, scope: !47)
!66 = !DILocation(line: 54, column: 5, scope: !16)
!67 = !DILocation(line: 54, column: 5, scope: !68)
!68 = distinct !DILexicalBlock(scope: !16, file: !1, line: 54, column: 5)
!69 = !DILocation(line: 54, column: 18, scope: !16)
!70 = !DILocation(line: 54, column: 18, scope: !71)
!71 = distinct !DILexicalBlock(scope: !16, file: !1, line: 54, column: 18)
!72 = !DILocation(line: 54, column: 31, scope: !16)
!73 = !DILocation(line: 54, column: 31, scope: !74)
!74 = distinct !DILexicalBlock(scope: !16, file: !1, line: 54, column: 31)
!75 = !DILocation(line: 55, column: 5, scope: !16)
!76 = !DILocation(line: 55, column: 5, scope: !77)
!77 = distinct !DILexicalBlock(scope: !16, file: !1, line: 55, column: 5)
!78 = !DILocation(line: 55, column: 18, scope: !16)
!79 = !DILocation(line: 55, column: 18, scope: !80)
!80 = distinct !DILexicalBlock(scope: !16, file: !1, line: 55, column: 18)
!81 = !DILocation(line: 55, column: 31, scope: !16)
!82 = !DILocation(line: 55, column: 31, scope: !83)
!83 = distinct !DILexicalBlock(scope: !16, file: !1, line: 55, column: 31)
!84 = !DILocation(line: 55, column: 43, scope: !16)
!85 = !DILocation(line: 55, column: 43, scope: !86)
!86 = distinct !DILexicalBlock(scope: !16, file: !1, line: 55, column: 43)
!87 = !DILocalVariable(name: "s", scope: !16, file: !1, line: 58, type: !4)
!88 = !DILocation(line: 58, column: 12, scope: !16)
!89 = !DILocalVariable(name: "dist", scope: !16, file: !1, line: 59, type: !90)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !3, size: 192, elements: !91)
!91 = !{!92}
!92 = !DISubrange(count: 6)
!93 = !DILocation(line: 59, column: 9, scope: !16)
!94 = !DILocalVariable(name: "prev", scope: !16, file: !1, line: 59, type: !90)
!95 = !DILocation(line: 59, column: 18, scope: !16)
!96 = !DILocation(line: 61, column: 14, scope: !16)
!97 = !DILocation(line: 61, column: 17, scope: !16)
!98 = !DILocation(line: 61, column: 20, scope: !16)
!99 = !DILocation(line: 61, column: 23, scope: !16)
!100 = !DILocation(line: 61, column: 29, scope: !16)
!101 = !DILocation(line: 61, column: 5, scope: !16)
!102 = !DILocalVariable(name: "i", scope: !103, file: !1, line: 63, type: !4)
!103 = distinct !DILexicalBlock(scope: !16, file: !1, line: 63, column: 5)
!104 = !DILocation(line: 63, column: 17, scope: !103)
!105 = !DILocation(line: 63, column: 10, scope: !103)
!106 = !DILocation(line: 63, column: 24, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !1, line: 63, column: 5)
!108 = !DILocation(line: 63, column: 28, scope: !107)
!109 = !DILocation(line: 63, column: 26, scope: !107)
!110 = !DILocation(line: 63, column: 5, scope: !103)
!111 = !DILocation(line: 64, column: 18, scope: !112)
!112 = distinct !DILexicalBlock(scope: !113, file: !1, line: 64, column: 13)
!113 = distinct !DILexicalBlock(scope: !107, file: !1, line: 63, column: 36)
!114 = !DILocation(line: 64, column: 13, scope: !112)
!115 = !DILocation(line: 64, column: 21, scope: !112)
!116 = !DILocation(line: 64, column: 13, scope: !113)
!117 = !DILocation(line: 64, column: 64, scope: !112)
!118 = !DILocation(line: 64, column: 67, scope: !112)
!119 = !DILocation(line: 64, column: 29, scope: !112)
!120 = !DILocation(line: 65, column: 64, scope: !112)
!121 = !DILocation(line: 65, column: 67, scope: !112)
!122 = !DILocation(line: 65, column: 75, scope: !112)
!123 = !DILocation(line: 65, column: 70, scope: !112)
!124 = !DILocation(line: 65, column: 29, scope: !112)
!125 = !DILocation(line: 66, column: 5, scope: !113)
!126 = !DILocation(line: 63, column: 31, scope: !107)
!127 = !DILocation(line: 63, column: 5, scope: !107)
!128 = distinct !{!128, !110, !129, !45}
!129 = !DILocation(line: 66, column: 5, scope: !103)
!130 = !DILocalVariable(name: "t", scope: !16, file: !1, line: 68, type: !4)
!131 = !DILocation(line: 68, column: 12, scope: !16)
!132 = !DILocation(line: 69, column: 14, scope: !133)
!133 = distinct !DILexicalBlock(scope: !16, file: !1, line: 69, column: 9)
!134 = !DILocation(line: 69, column: 9, scope: !133)
!135 = !DILocation(line: 69, column: 17, scope: !133)
!136 = !DILocation(line: 69, column: 9, scope: !16)
!137 = !DILocation(line: 70, column: 45, scope: !138)
!138 = distinct !DILexicalBlock(scope: !133, file: !1, line: 69, column: 25)
!139 = !DILocation(line: 70, column: 48, scope: !138)
!140 = !DILocation(line: 70, column: 9, scope: !138)
!141 = !DILocation(line: 71, column: 5, scope: !138)
!142 = !DILocalVariable(name: "path", scope: !143, file: !1, line: 72, type: !144)
!143 = distinct !DILexicalBlock(scope: !133, file: !1, line: 71, column: 12)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 384, elements: !91)
!145 = !DILocation(line: 72, column: 16, scope: !143)
!146 = !DILocalVariable(name: "k", scope: !143, file: !1, line: 72, type: !4)
!147 = !DILocation(line: 72, column: 32, scope: !143)
!148 = !DILocalVariable(name: "v", scope: !149, file: !1, line: 73, type: !3)
!149 = distinct !DILexicalBlock(scope: !143, file: !1, line: 73, column: 9)
!150 = !DILocation(line: 73, column: 18, scope: !149)
!151 = !DILocation(line: 73, column: 27, scope: !149)
!152 = !DILocation(line: 73, column: 22, scope: !149)
!153 = !DILocation(line: 73, column: 14, scope: !149)
!154 = !DILocation(line: 73, column: 30, scope: !155)
!155 = distinct !DILexicalBlock(scope: !149, file: !1, line: 73, column: 9)
!156 = !DILocation(line: 73, column: 32, scope: !155)
!157 = !DILocation(line: 73, column: 9, scope: !149)
!158 = !DILocation(line: 73, column: 72, scope: !155)
!159 = !DILocation(line: 73, column: 64, scope: !155)
!160 = !DILocation(line: 73, column: 58, scope: !155)
!161 = !DILocation(line: 73, column: 52, scope: !155)
!162 = !DILocation(line: 73, column: 62, scope: !155)
!163 = !DILocation(line: 73, column: 48, scope: !155)
!164 = !DILocation(line: 73, column: 43, scope: !155)
!165 = !DILocation(line: 73, column: 41, scope: !155)
!166 = !DILocation(line: 73, column: 9, scope: !155)
!167 = distinct !{!167, !157, !168, !45}
!168 = !DILocation(line: 73, column: 72, scope: !149)
!169 = !DILocation(line: 74, column: 36, scope: !143)
!170 = !DILocation(line: 74, column: 39, scope: !143)
!171 = !DILocation(line: 74, column: 9, scope: !143)
!172 = !DILocalVariable(name: "i", scope: !173, file: !1, line: 75, type: !4)
!173 = distinct !DILexicalBlock(scope: !143, file: !1, line: 75, column: 9)
!174 = !DILocation(line: 75, column: 21, scope: !173)
!175 = !DILocation(line: 75, column: 14, scope: !173)
!176 = !DILocation(line: 75, column: 28, scope: !177)
!177 = distinct !DILexicalBlock(scope: !173, file: !1, line: 75, column: 9)
!178 = !DILocation(line: 75, column: 32, scope: !177)
!179 = !DILocation(line: 75, column: 30, scope: !177)
!180 = !DILocation(line: 75, column: 9, scope: !173)
!181 = !DILocalVariable(name: "v", scope: !182, file: !1, line: 76, type: !4)
!182 = distinct !DILexicalBlock(scope: !177, file: !1, line: 75, column: 40)
!183 = !DILocation(line: 76, column: 20, scope: !182)
!184 = !DILocation(line: 76, column: 29, scope: !182)
!185 = !DILocation(line: 76, column: 31, scope: !182)
!186 = !DILocation(line: 76, column: 37, scope: !182)
!187 = !DILocation(line: 76, column: 35, scope: !182)
!188 = !DILocation(line: 76, column: 24, scope: !182)
!189 = !DILocation(line: 77, column: 30, scope: !182)
!190 = !DILocation(line: 77, column: 34, scope: !182)
!191 = !DILocation(line: 77, column: 36, scope: !182)
!192 = !DILocation(line: 77, column: 42, scope: !182)
!193 = !DILocation(line: 77, column: 40, scope: !182)
!194 = !DILocation(line: 77, column: 33, scope: !182)
!195 = !DILocation(line: 77, column: 13, scope: !182)
!196 = !DILocation(line: 78, column: 9, scope: !182)
!197 = !DILocation(line: 75, column: 35, scope: !177)
!198 = !DILocation(line: 75, column: 9, scope: !177)
!199 = distinct !{!199, !180, !200, !45}
!200 = !DILocation(line: 78, column: 9, scope: !173)
!201 = !DILocation(line: 79, column: 9, scope: !143)
!202 = !DILocation(line: 81, column: 5, scope: !16)
!203 = distinct !DISubprogram(name: "dijkstra", scope: !1, file: !1, line: 8, type: !204, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !19)
!204 = !DISubroutineType(types: !205)
!205 = !{null, !206, !4, !4, !7, !7}
!206 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !207, size: 64)
!207 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !3)
!208 = !DILocalVariable(name: "w", arg: 1, scope: !203, file: !1, line: 8, type: !206)
!209 = !DILocation(line: 8, column: 33, scope: !203)
!210 = !DILocalVariable(name: "n", arg: 2, scope: !203, file: !1, line: 8, type: !4)
!211 = !DILocation(line: 8, column: 43, scope: !203)
!212 = !DILocalVariable(name: "s", arg: 3, scope: !203, file: !1, line: 8, type: !4)
!213 = !DILocation(line: 8, column: 53, scope: !203)
!214 = !DILocalVariable(name: "dist", arg: 4, scope: !203, file: !1, line: 8, type: !7)
!215 = !DILocation(line: 8, column: 61, scope: !203)
!216 = !DILocalVariable(name: "prev", arg: 5, scope: !203, file: !1, line: 8, type: !7)
!217 = !DILocation(line: 8, column: 72, scope: !203)
!218 = !DILocation(line: 9, column: 9, scope: !219)
!219 = distinct !DILexicalBlock(scope: !203, file: !1, line: 9, column: 9)
!220 = !DILocation(line: 9, column: 11, scope: !219)
!221 = !DILocation(line: 9, column: 16, scope: !219)
!222 = !DILocation(line: 9, column: 19, scope: !219)
!223 = !DILocation(line: 9, column: 24, scope: !219)
!224 = !DILocation(line: 9, column: 21, scope: !219)
!225 = !DILocation(line: 9, column: 9, scope: !203)
!226 = !DILocation(line: 9, column: 27, scope: !219)
!227 = !DILocalVariable(name: "used", scope: !203, file: !1, line: 11, type: !7)
!228 = !DILocation(line: 11, column: 10, scope: !203)
!229 = !DILocation(line: 11, column: 31, scope: !203)
!230 = !DILocation(line: 11, column: 33, scope: !203)
!231 = !DILocation(line: 11, column: 24, scope: !203)
!232 = !DILocation(line: 11, column: 17, scope: !203)
!233 = !DILocation(line: 12, column: 10, scope: !234)
!234 = distinct !DILexicalBlock(scope: !203, file: !1, line: 12, column: 9)
!235 = !DILocation(line: 12, column: 9, scope: !203)
!236 = !DILocation(line: 12, column: 16, scope: !234)
!237 = !DILocalVariable(name: "i", scope: !238, file: !1, line: 14, type: !4)
!238 = distinct !DILexicalBlock(scope: !203, file: !1, line: 14, column: 5)
!239 = !DILocation(line: 14, column: 17, scope: !238)
!240 = !DILocation(line: 14, column: 10, scope: !238)
!241 = !DILocation(line: 14, column: 24, scope: !242)
!242 = distinct !DILexicalBlock(scope: !238, file: !1, line: 14, column: 5)
!243 = !DILocation(line: 14, column: 28, scope: !242)
!244 = !DILocation(line: 14, column: 26, scope: !242)
!245 = !DILocation(line: 14, column: 5, scope: !238)
!246 = !DILocation(line: 15, column: 9, scope: !247)
!247 = distinct !DILexicalBlock(scope: !242, file: !1, line: 14, column: 36)
!248 = !DILocation(line: 15, column: 14, scope: !247)
!249 = !DILocation(line: 15, column: 17, scope: !247)
!250 = !DILocation(line: 16, column: 9, scope: !247)
!251 = !DILocation(line: 16, column: 14, scope: !247)
!252 = !DILocation(line: 16, column: 17, scope: !247)
!253 = !DILocation(line: 17, column: 9, scope: !247)
!254 = !DILocation(line: 17, column: 14, scope: !247)
!255 = !DILocation(line: 17, column: 17, scope: !247)
!256 = !DILocation(line: 18, column: 5, scope: !247)
!257 = !DILocation(line: 14, column: 31, scope: !242)
!258 = !DILocation(line: 14, column: 5, scope: !242)
!259 = distinct !{!259, !245, !260, !45}
!260 = !DILocation(line: 18, column: 5, scope: !238)
!261 = !DILocation(line: 19, column: 5, scope: !203)
!262 = !DILocation(line: 19, column: 10, scope: !203)
!263 = !DILocation(line: 19, column: 13, scope: !203)
!264 = !DILocalVariable(name: "it", scope: !265, file: !1, line: 21, type: !4)
!265 = distinct !DILexicalBlock(scope: !203, file: !1, line: 21, column: 5)
!266 = !DILocation(line: 21, column: 17, scope: !265)
!267 = !DILocation(line: 21, column: 10, scope: !265)
!268 = !DILocation(line: 21, column: 25, scope: !269)
!269 = distinct !DILexicalBlock(scope: !265, file: !1, line: 21, column: 5)
!270 = !DILocation(line: 21, column: 30, scope: !269)
!271 = !DILocation(line: 21, column: 28, scope: !269)
!272 = !DILocation(line: 21, column: 5, scope: !265)
!273 = !DILocalVariable(name: "u", scope: !274, file: !1, line: 22, type: !4)
!274 = distinct !DILexicalBlock(scope: !269, file: !1, line: 21, column: 39)
!275 = !DILocation(line: 22, column: 16, scope: !274)
!276 = !DILocation(line: 22, column: 20, scope: !274)
!277 = !DILocalVariable(name: "best", scope: !274, file: !1, line: 23, type: !3)
!278 = !DILocation(line: 23, column: 13, scope: !274)
!279 = !DILocalVariable(name: "i", scope: !280, file: !1, line: 24, type: !4)
!280 = distinct !DILexicalBlock(scope: !274, file: !1, line: 24, column: 9)
!281 = !DILocation(line: 24, column: 21, scope: !280)
!282 = !DILocation(line: 24, column: 14, scope: !280)
!283 = !DILocation(line: 24, column: 28, scope: !284)
!284 = distinct !DILexicalBlock(scope: !280, file: !1, line: 24, column: 9)
!285 = !DILocation(line: 24, column: 32, scope: !284)
!286 = !DILocation(line: 24, column: 30, scope: !284)
!287 = !DILocation(line: 24, column: 9, scope: !280)
!288 = !DILocation(line: 25, column: 18, scope: !289)
!289 = distinct !DILexicalBlock(scope: !290, file: !1, line: 25, column: 17)
!290 = distinct !DILexicalBlock(scope: !284, file: !1, line: 24, column: 40)
!291 = !DILocation(line: 25, column: 23, scope: !289)
!292 = !DILocation(line: 25, column: 26, scope: !289)
!293 = !DILocation(line: 25, column: 29, scope: !289)
!294 = !DILocation(line: 25, column: 34, scope: !289)
!295 = !DILocation(line: 25, column: 39, scope: !289)
!296 = !DILocation(line: 25, column: 37, scope: !289)
!297 = !DILocation(line: 25, column: 17, scope: !290)
!298 = !DILocation(line: 26, column: 24, scope: !299)
!299 = distinct !DILexicalBlock(scope: !289, file: !1, line: 25, column: 45)
!300 = !DILocation(line: 26, column: 29, scope: !299)
!301 = !DILocation(line: 26, column: 22, scope: !299)
!302 = !DILocation(line: 27, column: 21, scope: !299)
!303 = !DILocation(line: 27, column: 19, scope: !299)
!304 = !DILocation(line: 28, column: 13, scope: !299)
!305 = !DILocation(line: 29, column: 9, scope: !290)
!306 = !DILocation(line: 24, column: 35, scope: !284)
!307 = !DILocation(line: 24, column: 9, scope: !284)
!308 = distinct !{!308, !287, !309, !45}
!309 = !DILocation(line: 29, column: 9, scope: !280)
!310 = !DILocation(line: 30, column: 13, scope: !311)
!311 = distinct !DILexicalBlock(scope: !274, file: !1, line: 30, column: 13)
!312 = !DILocation(line: 30, column: 18, scope: !311)
!313 = !DILocation(line: 30, column: 15, scope: !311)
!314 = !DILocation(line: 30, column: 13, scope: !274)
!315 = !DILocation(line: 30, column: 21, scope: !311)
!316 = !DILocation(line: 31, column: 9, scope: !274)
!317 = !DILocation(line: 31, column: 14, scope: !274)
!318 = !DILocation(line: 31, column: 17, scope: !274)
!319 = !DILocalVariable(name: "v", scope: !320, file: !1, line: 33, type: !4)
!320 = distinct !DILexicalBlock(scope: !274, file: !1, line: 33, column: 9)
!321 = !DILocation(line: 33, column: 21, scope: !320)
!322 = !DILocation(line: 33, column: 14, scope: !320)
!323 = !DILocation(line: 33, column: 28, scope: !324)
!324 = distinct !DILexicalBlock(scope: !320, file: !1, line: 33, column: 9)
!325 = !DILocation(line: 33, column: 32, scope: !324)
!326 = !DILocation(line: 33, column: 30, scope: !324)
!327 = !DILocation(line: 33, column: 9, scope: !320)
!328 = !DILocalVariable(name: "w_uv", scope: !329, file: !1, line: 34, type: !3)
!329 = distinct !DILexicalBlock(scope: !324, file: !1, line: 33, column: 40)
!330 = !DILocation(line: 34, column: 17, scope: !329)
!331 = !DILocation(line: 34, column: 24, scope: !329)
!332 = !DILocation(line: 34, column: 26, scope: !329)
!333 = !DILocation(line: 34, column: 28, scope: !329)
!334 = !DILocation(line: 34, column: 27, scope: !329)
!335 = !DILocation(line: 34, column: 32, scope: !329)
!336 = !DILocation(line: 34, column: 30, scope: !329)
!337 = !DILocation(line: 35, column: 17, scope: !338)
!338 = distinct !DILexicalBlock(scope: !329, file: !1, line: 35, column: 17)
!339 = !DILocation(line: 35, column: 22, scope: !338)
!340 = !DILocation(line: 35, column: 27, scope: !338)
!341 = !DILocation(line: 35, column: 31, scope: !338)
!342 = !DILocation(line: 35, column: 36, scope: !338)
!343 = !DILocation(line: 35, column: 17, scope: !329)
!344 = !DILocation(line: 36, column: 21, scope: !345)
!345 = distinct !DILexicalBlock(scope: !346, file: !1, line: 36, column: 21)
!346 = distinct !DILexicalBlock(scope: !338, file: !1, line: 35, column: 40)
!347 = !DILocation(line: 36, column: 26, scope: !345)
!348 = !DILocation(line: 36, column: 29, scope: !345)
!349 = !DILocation(line: 36, column: 36, scope: !345)
!350 = !DILocation(line: 36, column: 39, scope: !345)
!351 = !DILocation(line: 36, column: 44, scope: !345)
!352 = !DILocation(line: 36, column: 49, scope: !345)
!353 = !DILocation(line: 36, column: 47, scope: !345)
!354 = !DILocation(line: 36, column: 56, scope: !345)
!355 = !DILocation(line: 36, column: 61, scope: !345)
!356 = !DILocation(line: 36, column: 54, scope: !345)
!357 = !DILocation(line: 36, column: 21, scope: !346)
!358 = !DILocation(line: 37, column: 31, scope: !359)
!359 = distinct !DILexicalBlock(scope: !345, file: !1, line: 36, column: 65)
!360 = !DILocation(line: 37, column: 36, scope: !359)
!361 = !DILocation(line: 37, column: 41, scope: !359)
!362 = !DILocation(line: 37, column: 39, scope: !359)
!363 = !DILocation(line: 37, column: 21, scope: !359)
!364 = !DILocation(line: 37, column: 26, scope: !359)
!365 = !DILocation(line: 37, column: 29, scope: !359)
!366 = !DILocation(line: 38, column: 36, scope: !359)
!367 = !DILocation(line: 38, column: 31, scope: !359)
!368 = !DILocation(line: 38, column: 21, scope: !359)
!369 = !DILocation(line: 38, column: 26, scope: !359)
!370 = !DILocation(line: 38, column: 29, scope: !359)
!371 = !DILocation(line: 39, column: 17, scope: !359)
!372 = !DILocation(line: 40, column: 13, scope: !346)
!373 = !DILocation(line: 41, column: 9, scope: !329)
!374 = !DILocation(line: 33, column: 35, scope: !324)
!375 = !DILocation(line: 33, column: 9, scope: !324)
!376 = distinct !{!376, !327, !377, !45}
!377 = !DILocation(line: 41, column: 9, scope: !320)
!378 = !DILocation(line: 42, column: 5, scope: !274)
!379 = !DILocation(line: 21, column: 33, scope: !269)
!380 = !DILocation(line: 21, column: 5, scope: !269)
!381 = distinct !{!381, !272, !382, !45}
!382 = !DILocation(line: 42, column: 5, scope: !265)
!383 = !DILocation(line: 44, column: 10, scope: !203)
!384 = !DILocation(line: 44, column: 5, scope: !203)
!385 = !DILocation(line: 45, column: 1, scope: !203)

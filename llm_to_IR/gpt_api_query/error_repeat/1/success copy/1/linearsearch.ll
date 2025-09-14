; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.arr = private unnamed_addr constant [5 x i32] [i32 5, i32 3, i32 8, i32 4, i32 2], align 16
@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"Element not found\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %n, i32 noundef %target) #0 !dbg !10 {
entry:
  %retval = alloca i32, align 4
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %target.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %arr.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 %target, i32* %target.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %target.addr, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !24
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %1 = load i32, i32* %n.addr, align 4, !dbg !28
  %cmp = icmp slt i32 %0, %1, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %2 = load i32*, i32** %arr.addr, align 8, !dbg !31
  %3 = load i32, i32* %i, align 4, !dbg !34
  %idxprom = sext i32 %3 to i64, !dbg !31
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %idxprom, !dbg !31
  %4 = load i32, i32* %arrayidx, align 4, !dbg !31
  %5 = load i32, i32* %target.addr, align 4, !dbg !35
  %cmp1 = icmp eq i32 %4, %5, !dbg !36
  br i1 %cmp1, label %if.then, label %if.end, !dbg !37

if.then:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !38
  store i32 %6, i32* %retval, align 4, !dbg !39
  br label %return, !dbg !39

if.end:                                           ; preds = %for.body
  br label %for.inc, !dbg !40

for.inc:                                          ; preds = %if.end
  %7 = load i32, i32* %i, align 4, !dbg !41
  %inc = add nsw i32 %7, 1, !dbg !41
  store i32 %inc, i32* %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  store i32 -1, i32* %retval, align 4, !dbg !46
  br label %return, !dbg !46

return:                                           ; preds = %for.end, %if.then
  %8 = load i32, i32* %retval, align 4, !dbg !47
  ret i32 %8, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !48 {
entry:
  %retval = alloca i32, align 4
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %target = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [5 x i32]* %arr, metadata !51, metadata !DIExpression()), !dbg !55
  %0 = bitcast [5 x i32]* %arr to i8*, !dbg !55
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast ([5 x i32]* @__const.main.arr to i8*), i64 20, i1 false), !dbg !55
  call void @llvm.dbg.declare(metadata i32* %n, metadata !56, metadata !DIExpression()), !dbg !57
  store i32 5, i32* %n, align 4, !dbg !57
  call void @llvm.dbg.declare(metadata i32* %target, metadata !58, metadata !DIExpression()), !dbg !59
  store i32 4, i32* %target, align 4, !dbg !59
  call void @llvm.dbg.declare(metadata i32* %result, metadata !60, metadata !DIExpression()), !dbg !61
  %arraydecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0, !dbg !62
  %1 = load i32, i32* %n, align 4, !dbg !63
  %2 = load i32, i32* %target, align 4, !dbg !64
  %call = call i32 @linear_search(i32* noundef %arraydecay, i32 noundef %1, i32 noundef %2), !dbg !65
  store i32 %call, i32* %result, align 4, !dbg !61
  %3 = load i32, i32* %result, align 4, !dbg !66
  %cmp = icmp ne i32 %3, -1, !dbg !68
  br i1 %cmp, label %if.then, label %if.else, !dbg !69

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %result, align 4, !dbg !70
  %call1 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str, i64 0, i64 0), i32 noundef %4), !dbg !71
  br label %if.end, !dbg !71

if.else:                                          ; preds = %entry
  %call2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1, i64 0, i64 0)), !dbg !72
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret i32 0, !dbg !73
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

declare i32 @printf(i8* noundef, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/linearsearch.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "b82228440e1fc68a5f0ccb5f1cd642bd")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "linear_search", scope: !1, file: !1, line: 3, type: !11, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !14, !13, !13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!15 = !{}
!16 = !DILocalVariable(name: "arr", arg: 1, scope: !10, file: !1, line: 3, type: !14)
!17 = !DILocation(line: 3, column: 23, scope: !10)
!18 = !DILocalVariable(name: "n", arg: 2, scope: !10, file: !1, line: 3, type: !13)
!19 = !DILocation(line: 3, column: 34, scope: !10)
!20 = !DILocalVariable(name: "target", arg: 3, scope: !10, file: !1, line: 3, type: !13)
!21 = !DILocation(line: 3, column: 41, scope: !10)
!22 = !DILocalVariable(name: "i", scope: !23, file: !1, line: 4, type: !13)
!23 = distinct !DILexicalBlock(scope: !10, file: !1, line: 4, column: 5)
!24 = !DILocation(line: 4, column: 14, scope: !23)
!25 = !DILocation(line: 4, column: 10, scope: !23)
!26 = !DILocation(line: 4, column: 21, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !1, line: 4, column: 5)
!28 = !DILocation(line: 4, column: 25, scope: !27)
!29 = !DILocation(line: 4, column: 23, scope: !27)
!30 = !DILocation(line: 4, column: 5, scope: !23)
!31 = !DILocation(line: 5, column: 13, scope: !32)
!32 = distinct !DILexicalBlock(scope: !33, file: !1, line: 5, column: 13)
!33 = distinct !DILexicalBlock(scope: !27, file: !1, line: 4, column: 33)
!34 = !DILocation(line: 5, column: 17, scope: !32)
!35 = !DILocation(line: 5, column: 23, scope: !32)
!36 = !DILocation(line: 5, column: 20, scope: !32)
!37 = !DILocation(line: 5, column: 13, scope: !33)
!38 = !DILocation(line: 6, column: 20, scope: !32)
!39 = !DILocation(line: 6, column: 13, scope: !32)
!40 = !DILocation(line: 7, column: 5, scope: !33)
!41 = !DILocation(line: 4, column: 29, scope: !27)
!42 = !DILocation(line: 4, column: 5, scope: !27)
!43 = distinct !{!43, !30, !44, !45}
!44 = !DILocation(line: 7, column: 5, scope: !23)
!45 = !{!"llvm.loop.mustprogress"}
!46 = !DILocation(line: 8, column: 5, scope: !10)
!47 = !DILocation(line: 9, column: 1, scope: !10)
!48 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 11, type: !49, scopeLine: 11, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!49 = !DISubroutineType(types: !50)
!50 = !{!13}
!51 = !DILocalVariable(name: "arr", scope: !48, file: !1, line: 12, type: !52)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 160, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 5)
!55 = !DILocation(line: 12, column: 9, scope: !48)
!56 = !DILocalVariable(name: "n", scope: !48, file: !1, line: 13, type: !13)
!57 = !DILocation(line: 13, column: 9, scope: !48)
!58 = !DILocalVariable(name: "target", scope: !48, file: !1, line: 14, type: !13)
!59 = !DILocation(line: 14, column: 9, scope: !48)
!60 = !DILocalVariable(name: "result", scope: !48, file: !1, line: 16, type: !13)
!61 = !DILocation(line: 16, column: 9, scope: !48)
!62 = !DILocation(line: 16, column: 32, scope: !48)
!63 = !DILocation(line: 16, column: 37, scope: !48)
!64 = !DILocation(line: 16, column: 40, scope: !48)
!65 = !DILocation(line: 16, column: 18, scope: !48)
!66 = !DILocation(line: 18, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !48, file: !1, line: 18, column: 9)
!68 = !DILocation(line: 18, column: 16, scope: !67)
!69 = !DILocation(line: 18, column: 9, scope: !48)
!70 = !DILocation(line: 19, column: 47, scope: !67)
!71 = !DILocation(line: 19, column: 9, scope: !67)
!72 = !DILocation(line: 21, column: 9, scope: !67)
!73 = !DILocation(line: 23, column: 5, scope: !48)

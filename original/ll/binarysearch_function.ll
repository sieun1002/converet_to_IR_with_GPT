; ModuleID = 'binarysearch.ll'
source_filename = "../original/src/binarysearch.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; Function Attrs: noinline nounwind optnone uwtable
define hidden i64 @binary_search(i32* noundef %a, i64 noundef %n, i32 noundef %key) #1 !dbg !12 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %key.addr = alloca i32, align 4
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %mid = alloca i64, align 8
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !22, metadata !DIExpression()), !dbg !23
  store i64 %n, i64* %n.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %n.addr, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 %key, i32* %key.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %key.addr, metadata !26, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata i64* %lo, metadata !28, metadata !DIExpression()), !dbg !29
  store i64 0, i64* %lo, align 8, !dbg !29
  call void @llvm.dbg.declare(metadata i64* %hi, metadata !30, metadata !DIExpression()), !dbg !31
  %0 = load i64, i64* %n.addr, align 8, !dbg !32
  store i64 %0, i64* %hi, align 8, !dbg !31
  br label %while.cond, !dbg !33

while.cond:                                       ; preds = %if.end, %entry
  %1 = load i64, i64* %lo, align 8, !dbg !34
  %2 = load i64, i64* %hi, align 8, !dbg !35
  %cmp = icmp ult i64 %1, %2, !dbg !36
  br i1 %cmp, label %while.body, label %while.end, !dbg !33

while.body:                                       ; preds = %while.cond
  call void @llvm.dbg.declare(metadata i64* %mid, metadata !37, metadata !DIExpression()), !dbg !39
  %3 = load i64, i64* %lo, align 8, !dbg !40
  %4 = load i64, i64* %hi, align 8, !dbg !41
  %5 = load i64, i64* %lo, align 8, !dbg !42
  %sub = sub i64 %4, %5, !dbg !43
  %div = udiv i64 %sub, 2, !dbg !44
  %add = add i64 %3, %div, !dbg !45
  store i64 %add, i64* %mid, align 8, !dbg !39
  %6 = load i32*, i32** %a.addr, align 8, !dbg !46
  %7 = load i64, i64* %mid, align 8, !dbg !48
  %arrayidx = getelementptr inbounds i32, i32* %6, i64 %7, !dbg !46
  %8 = load i32, i32* %arrayidx, align 4, !dbg !46
  %9 = load i32, i32* %key.addr, align 4, !dbg !49
  %cmp1 = icmp slt i32 %8, %9, !dbg !50
  br i1 %cmp1, label %if.then, label %if.else, !dbg !51

if.then:                                          ; preds = %while.body
  %10 = load i64, i64* %mid, align 8, !dbg !52
  %add2 = add i64 %10, 1, !dbg !53
  store i64 %add2, i64* %lo, align 8, !dbg !54
  br label %if.end, !dbg !55

if.else:                                          ; preds = %while.body
  %11 = load i64, i64* %mid, align 8, !dbg !56
  store i64 %11, i64* %hi, align 8, !dbg !57
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond, !dbg !33, !llvm.loop !58

while.end:                                        ; preds = %while.cond
  %12 = load i64, i64* %lo, align 8, !dbg !61
  %13 = load i64, i64* %n.addr, align 8, !dbg !63
  %cmp3 = icmp ult i64 %12, %13, !dbg !64
  br i1 %cmp3, label %land.lhs.true, label %if.end7, !dbg !65

land.lhs.true:                                    ; preds = %while.end
  %14 = load i32*, i32** %a.addr, align 8, !dbg !66
  %15 = load i64, i64* %lo, align 8, !dbg !67
  %arrayidx4 = getelementptr inbounds i32, i32* %14, i64 %15, !dbg !66
  %16 = load i32, i32* %arrayidx4, align 4, !dbg !66
  %17 = load i32, i32* %key.addr, align 4, !dbg !68
  %cmp5 = icmp eq i32 %16, %17, !dbg !69
  br i1 %cmp5, label %if.then6, label %if.end7, !dbg !70

if.then6:                                         ; preds = %land.lhs.true
  %18 = load i64, i64* %lo, align 8, !dbg !71
  store i64 %18, i64* %retval, align 8, !dbg !72
  br label %return, !dbg !72

if.end7:                                          ; preds = %land.lhs.true, %while.end
  store i64 -1, i64* %retval, align 8, !dbg !73
  br label %return, !dbg !73

return:                                           ; preds = %if.end7, %if.then6
  %19 = load i64, i64* %retval, align 8, !dbg !74
  ret i64 %19, !dbg !74
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../original/src/binarysearch.c", directory: "/home/nata20034/workspace/convert_to_IR_with_LLM/IR_Test", checksumkind: CSK_MD5, checksum: "08f90fb2bdfb727335b70b6850a46ad9")
!2 = !{!3}
!3 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 7, !"PIC Level", i32 2}
!8 = !{i32 7, !"PIE Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 1}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!12 = distinct !DISubprogram(name: "binary_search", scope: !1, file: !1, line: 4, type: !13, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !21)
!13 = !DISubroutineType(types: !14)
!14 = !{!3, !15, !18, !17}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 46, baseType: !20)
!19 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!20 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!21 = !{}
!22 = !DILocalVariable(name: "a", arg: 1, scope: !12, file: !1, line: 4, type: !15)
!23 = !DILocation(line: 4, column: 38, scope: !12)
!24 = !DILocalVariable(name: "n", arg: 2, scope: !12, file: !1, line: 4, type: !18)
!25 = !DILocation(line: 4, column: 48, scope: !12)
!26 = !DILocalVariable(name: "key", arg: 3, scope: !12, file: !1, line: 4, type: !17)
!27 = !DILocation(line: 4, column: 55, scope: !12)
!28 = !DILocalVariable(name: "lo", scope: !12, file: !1, line: 5, type: !18)
!29 = !DILocation(line: 5, column: 12, scope: !12)
!30 = !DILocalVariable(name: "hi", scope: !12, file: !1, line: 5, type: !18)
!31 = !DILocation(line: 5, column: 20, scope: !12)
!32 = !DILocation(line: 5, column: 25, scope: !12)
!33 = !DILocation(line: 6, column: 5, scope: !12)
!34 = !DILocation(line: 6, column: 12, scope: !12)
!35 = !DILocation(line: 6, column: 17, scope: !12)
!36 = !DILocation(line: 6, column: 15, scope: !12)
!37 = !DILocalVariable(name: "mid", scope: !38, file: !1, line: 7, type: !18)
!38 = distinct !DILexicalBlock(scope: !12, file: !1, line: 6, column: 21)
!39 = !DILocation(line: 7, column: 16, scope: !38)
!40 = !DILocation(line: 7, column: 22, scope: !38)
!41 = !DILocation(line: 7, column: 28, scope: !38)
!42 = !DILocation(line: 7, column: 33, scope: !38)
!43 = !DILocation(line: 7, column: 31, scope: !38)
!44 = !DILocation(line: 7, column: 37, scope: !38)
!45 = !DILocation(line: 7, column: 25, scope: !38)
!46 = !DILocation(line: 8, column: 13, scope: !47)
!47 = distinct !DILexicalBlock(scope: !38, file: !1, line: 8, column: 13)
!48 = !DILocation(line: 8, column: 15, scope: !47)
!49 = !DILocation(line: 8, column: 22, scope: !47)
!50 = !DILocation(line: 8, column: 20, scope: !47)
!51 = !DILocation(line: 8, column: 13, scope: !38)
!52 = !DILocation(line: 8, column: 32, scope: !47)
!53 = !DILocation(line: 8, column: 36, scope: !47)
!54 = !DILocation(line: 8, column: 30, scope: !47)
!55 = !DILocation(line: 8, column: 27, scope: !47)
!56 = !DILocation(line: 9, column: 19, scope: !47)
!57 = !DILocation(line: 9, column: 17, scope: !47)
!58 = distinct !{!58, !33, !59, !60}
!59 = !DILocation(line: 10, column: 5, scope: !12)
!60 = !{!"llvm.loop.mustprogress"}
!61 = !DILocation(line: 11, column: 9, scope: !62)
!62 = distinct !DILexicalBlock(scope: !12, file: !1, line: 11, column: 9)
!63 = !DILocation(line: 11, column: 14, scope: !62)
!64 = !DILocation(line: 11, column: 12, scope: !62)
!65 = !DILocation(line: 11, column: 16, scope: !62)
!66 = !DILocation(line: 11, column: 19, scope: !62)
!67 = !DILocation(line: 11, column: 21, scope: !62)
!68 = !DILocation(line: 11, column: 28, scope: !62)
!69 = !DILocation(line: 11, column: 25, scope: !62)
!70 = !DILocation(line: 11, column: 9, scope: !12)
!71 = !DILocation(line: 11, column: 46, scope: !62)
!72 = !DILocation(line: 11, column: 33, scope: !62)
!73 = !DILocation(line: 12, column: 5, scope: !12)
!74 = !DILocation(line: 13, column: 1, scope: !12)

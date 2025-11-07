; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/mergesort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/mergesort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %2) #6
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  %4 = tail call noalias dereferenceable_or_null(40) i8* @malloc(i64 noundef 40) #6
  %5 = icmp eq i8* %4, null
  br i1 %5, label %201, label %6

6:                                                ; preds = %0
  %7 = bitcast i8* %4 to i32*
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  %9 = getelementptr inbounds i32, i32* %7, i64 1
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 2
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  %12 = getelementptr inbounds i32, i32* %7, i64 2
  %13 = getelementptr inbounds i32, i32* %7, i64 3
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %16 = getelementptr inbounds i32, i32* %7, i64 4
  %17 = getelementptr inbounds i32, i32* %7, i64 5
  %18 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %19 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %20 = getelementptr inbounds i32, i32* %7, i64 6
  %21 = bitcast i32* %13 to <4 x i32>*
  store <4 x i32> <i32 5, i32 2, i32 7, i32 6>, <4 x i32>* %21, align 4, !tbaa !5
  %22 = getelementptr inbounds i32, i32* %7, i64 7
  store i32 8, i32* %22, align 4, !tbaa !5
  %23 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %24 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %25 = getelementptr inbounds i32, i32* %7, i64 8
  store i32 0, i32* %25, align 4, !tbaa !5
  %26 = getelementptr inbounds i32, i32* %7, i64 9
  store i32 4, i32* %26, align 4, !tbaa !5
  %27 = bitcast [10 x i32]* %1 to <4 x i32>*
  store <4 x i32> <i32 1, i32 3, i32 5, i32 9>, <4 x i32>* %27, align 16, !tbaa !5
  %28 = bitcast i32* %14 to <4 x i32>*
  store <4 x i32> <i32 2, i32 6, i32 7, i32 8>, <4 x i32>* %28, align 16, !tbaa !5
  store i32 0, i32* %23, align 16, !tbaa !5
  store i32 4, i32* %24, align 4, !tbaa !5
  store i32 1, i32* %7, align 4, !tbaa !5
  store i32 2, i32* %9, align 4, !tbaa !5
  %29 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  %30 = load i32, i32* %29, align 4, !tbaa !5
  %31 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %32 = load i32, i32* %31, align 4, !tbaa !5
  %33 = icmp sgt i32 %30, %32
  %34 = select i1 %33, i32 %32, i32 %30
  %35 = select i1 %33, i64 1, i64 2
  %36 = select i1 %33, i64 6, i64 5
  store i32 %34, i32* %12, align 4, !tbaa !5
  %37 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %35
  %38 = load i32, i32* %37, align 4, !tbaa !5
  %39 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %36
  %40 = load i32, i32* %39, align 4, !tbaa !5
  %41 = icmp sgt i32 %38, %40
  br i1 %41, label %46, label %42

42:                                               ; preds = %6
  %43 = add nuw nsw i64 %35, 1
  store i32 %38, i32* %13, align 4, !tbaa !5
  %44 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %43
  %45 = load i32, i32* %44, align 4, !tbaa !5
  br label %50

46:                                               ; preds = %6
  %47 = add nuw nsw i64 %36, 1
  store i32 %40, i32* %13, align 4, !tbaa !5
  %48 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %47
  %49 = load i32, i32* %48, align 4, !tbaa !5
  br label %50

50:                                               ; preds = %46, %42
  %51 = phi i32 [ %49, %46 ], [ %40, %42 ]
  %52 = phi i32 [ %38, %46 ], [ %45, %42 ]
  %53 = phi i64 [ %35, %46 ], [ %43, %42 ]
  %54 = phi i64 [ %47, %46 ], [ %36, %42 ]
  %55 = icmp sgt i32 %52, %51
  br i1 %55, label %65, label %56

56:                                               ; preds = %50
  %57 = add nuw nsw i64 %53, 1
  store i32 %52, i32* %16, align 4, !tbaa !5
  %58 = icmp ult i64 %53, 3
  br i1 %58, label %59, label %62

59:                                               ; preds = %56
  %60 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %57
  %61 = load i32, i32* %60, align 4, !tbaa !5
  br label %70

62:                                               ; preds = %56
  %63 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %54
  %64 = load i32, i32* %63, align 4, !tbaa !5
  br label %82

65:                                               ; preds = %50
  %66 = add nuw nsw i64 %54, 1
  store i32 %51, i32* %16, align 4, !tbaa !5
  %67 = icmp ult i64 %54, 7
  %68 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %53
  %69 = load i32, i32* %68, align 4, !tbaa !5
  br i1 %67, label %70, label %77

70:                                               ; preds = %59, %65
  %71 = phi i32 [ %61, %59 ], [ %69, %65 ]
  %72 = phi i64 [ %57, %59 ], [ %53, %65 ]
  %73 = phi i64 [ %54, %59 ], [ %66, %65 ]
  %74 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %73
  %75 = load i32, i32* %74, align 4, !tbaa !5
  %76 = icmp sgt i32 %71, %75
  br i1 %76, label %82, label %77

77:                                               ; preds = %70, %65
  %78 = phi i32 [ %71, %70 ], [ %69, %65 ]
  %79 = phi i64 [ %72, %70 ], [ %53, %65 ]
  %80 = phi i64 [ %73, %70 ], [ 8, %65 ]
  %81 = add nuw nsw i64 %79, 1
  br label %87

82:                                               ; preds = %70, %62
  %83 = phi i64 [ %54, %62 ], [ %73, %70 ]
  %84 = phi i64 [ 4, %62 ], [ %72, %70 ]
  %85 = phi i32 [ %64, %62 ], [ %75, %70 ]
  %86 = add nuw nsw i64 %83, 1
  br label %87

87:                                               ; preds = %82, %77
  %88 = phi i32 [ %85, %82 ], [ %78, %77 ]
  %89 = phi i64 [ %84, %82 ], [ %81, %77 ]
  %90 = phi i64 [ %86, %82 ], [ %80, %77 ]
  store i32 %88, i32* %17, align 4, !tbaa !5
  %91 = icmp ult i64 %89, 4
  br i1 %91, label %95, label %92

92:                                               ; preds = %87
  %93 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %90
  %94 = load i32, i32* %93, align 4, !tbaa !5
  br label %105

95:                                               ; preds = %87
  %96 = icmp ult i64 %90, 8
  %97 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %89
  %98 = load i32, i32* %97, align 4, !tbaa !5
  br i1 %96, label %99, label %103

99:                                               ; preds = %95
  %100 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %90
  %101 = load i32, i32* %100, align 4, !tbaa !5
  %102 = icmp sgt i32 %98, %101
  br i1 %102, label %105, label %103

103:                                              ; preds = %99, %95
  %104 = add nuw nsw i64 %89, 1
  br label %108

105:                                              ; preds = %99, %92
  %106 = phi i32 [ %94, %92 ], [ %101, %99 ]
  %107 = add nuw nsw i64 %90, 1
  br label %108

108:                                              ; preds = %105, %103
  %109 = phi i32 [ %106, %105 ], [ %98, %103 ]
  %110 = phi i64 [ %89, %105 ], [ %104, %103 ]
  %111 = phi i64 [ %107, %105 ], [ %90, %103 ]
  store i32 %109, i32* %20, align 4, !tbaa !5
  %112 = icmp ult i64 %110, 4
  br i1 %112, label %116, label %113

113:                                              ; preds = %108
  %114 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %111
  %115 = load i32, i32* %114, align 4, !tbaa !5
  br label %124

116:                                              ; preds = %108
  %117 = icmp ult i64 %111, 8
  %118 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %110
  %119 = load i32, i32* %118, align 4, !tbaa !5
  br i1 %117, label %120, label %126

120:                                              ; preds = %116
  %121 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %111
  %122 = load i32, i32* %121, align 4, !tbaa !5
  %123 = icmp sgt i32 %119, %122
  br i1 %123, label %124, label %126

124:                                              ; preds = %120, %113
  %125 = phi i32 [ %115, %113 ], [ %122, %120 ]
  br label %126

126:                                              ; preds = %124, %120, %116
  %127 = phi i32 [ %125, %124 ], [ %119, %120 ], [ %119, %116 ]
  store i32 %127, i32* %22, align 4, !tbaa !5
  store i32 0, i32* %25, align 4, !tbaa !5
  store i32 4, i32* %26, align 4, !tbaa !5
  store i32 0, i32* %3, align 16, !tbaa !5
  store i32 1, i32* %8, align 4, !tbaa !5
  store i32 2, i32* %10, align 8, !tbaa !5
  %128 = icmp sgt i32 %34, 4
  br i1 %128, label %135, label %129

129:                                              ; preds = %126
  store i32 %34, i32* %11, align 4, !tbaa !5
  %130 = getelementptr inbounds i32, i32* %7, i64 3
  %131 = load i32, i32* %130, align 4, !tbaa !5
  %132 = getelementptr inbounds i32, i32* %7, i64 9
  %133 = load i32, i32* %132, align 4, !tbaa !5
  %134 = icmp sgt i32 %131, %133
  br i1 %134, label %144, label %138

135:                                              ; preds = %126
  store i32 4, i32* %11, align 4, !tbaa !5
  %136 = getelementptr inbounds i32, i32* %7, i64 2
  %137 = load i32, i32* %136, align 4, !tbaa !5
  br label %144

138:                                              ; preds = %129
  store i32 %131, i32* %14, align 16, !tbaa !5
  %139 = getelementptr inbounds i32, i32* %7, i64 4
  %140 = load i32, i32* %139, align 4, !tbaa !5
  %141 = getelementptr inbounds i32, i32* %7, i64 9
  %142 = load i32, i32* %141, align 4, !tbaa !5
  %143 = icmp sgt i32 %140, %142
  br i1 %143, label %155, label %149

144:                                              ; preds = %129, %135
  %145 = phi i32 [ %137, %135 ], [ %133, %129 ]
  %146 = phi i32 [ 4, %135 ], [ %34, %129 ]
  store i32 %145, i32* %14, align 16, !tbaa !5
  %147 = getelementptr inbounds i32, i32* %7, i64 3
  %148 = load i32, i32* %147, align 4, !tbaa !5
  br label %155

149:                                              ; preds = %138
  store i32 %140, i32* %15, align 4, !tbaa !5
  %150 = getelementptr inbounds i32, i32* %7, i64 5
  %151 = load i32, i32* %150, align 4, !tbaa !5
  %152 = getelementptr inbounds i32, i32* %7, i64 9
  %153 = load i32, i32* %152, align 4, !tbaa !5
  %154 = icmp sgt i32 %151, %153
  br i1 %154, label %168, label %161

155:                                              ; preds = %138, %144
  %156 = phi i32 [ %148, %144 ], [ %142, %138 ]
  %157 = phi i32 [ %146, %144 ], [ %34, %138 ]
  %158 = phi i32 [ %145, %144 ], [ %131, %138 ]
  store i32 %156, i32* %15, align 4, !tbaa !5
  %159 = getelementptr inbounds i32, i32* %7, i64 4
  %160 = load i32, i32* %159, align 4, !tbaa !5
  br label %168

161:                                              ; preds = %149
  %162 = getelementptr inbounds i32, i32* %7, i64 6
  %163 = load i32, i32* %162, align 4, !tbaa !5
  %164 = getelementptr inbounds i32, i32* %7, i64 9
  %165 = load i32, i32* %164, align 4, !tbaa !5
  %166 = icmp sgt i32 %163, %165
  br i1 %166, label %167, label %175

167:                                              ; preds = %161
  store i32 %165, i32* %19, align 4, !tbaa !5
  br label %183

168:                                              ; preds = %149, %155
  %169 = phi i32 [ %160, %155 ], [ %153, %149 ]
  %170 = phi i32 [ %158, %155 ], [ %131, %149 ]
  %171 = phi i32 [ %157, %155 ], [ %34, %149 ]
  %172 = phi i32 [ %156, %155 ], [ %140, %149 ]
  store i32 %169, i32* %18, align 8, !tbaa !5
  %173 = getelementptr inbounds i32, i32* %7, i64 5
  %174 = load i32, i32* %173, align 4, !tbaa !5
  br label %183

175:                                              ; preds = %161
  %176 = getelementptr inbounds i32, i32* %7, i64 7
  %177 = load i32, i32* %176, align 4, !tbaa !5
  %178 = getelementptr inbounds i32, i32* %7, i64 9
  %179 = load i32, i32* %178, align 4, !tbaa !5
  %180 = icmp sgt i32 %177, %179
  %181 = select i1 %180, i64 7, i64 9
  %182 = select i1 %180, i32 %179, i32 %177
  br label %191

183:                                              ; preds = %167, %168
  %184 = phi i32 [ %174, %168 ], [ %165, %167 ]
  %185 = phi i32 [ %172, %168 ], [ %140, %167 ]
  %186 = phi i32 [ %171, %168 ], [ %34, %167 ]
  %187 = phi i32 [ %170, %168 ], [ %131, %167 ]
  %188 = phi i32 [ %169, %168 ], [ %151, %167 ]
  %189 = getelementptr inbounds i32, i32* %7, i64 6
  %190 = load i32, i32* %189, align 4, !tbaa !5
  br label %191

191:                                              ; preds = %175, %183
  %192 = phi i64 [ 7, %183 ], [ %181, %175 ]
  %193 = phi i32 [ %190, %183 ], [ %182, %175 ]
  %194 = phi i32 [ %188, %183 ], [ %151, %175 ]
  %195 = phi i32 [ %187, %183 ], [ %131, %175 ]
  %196 = phi i32 [ %186, %183 ], [ %34, %175 ]
  %197 = phi i32 [ %185, %183 ], [ %140, %175 ]
  %198 = phi i32 [ %184, %183 ], [ %163, %175 ]
  %199 = getelementptr inbounds i32, i32* %7, i64 %192
  %200 = load i32, i32* %199, align 4, !tbaa !5
  tail call void @free(i8* noundef nonnull %4) #6
  br label %201

201:                                              ; preds = %0, %191
  %202 = phi i32 [ 0, %0 ], [ %200, %191 ]
  %203 = phi i32 [ 4, %0 ], [ %193, %191 ]
  %204 = phi i32 [ 6, %0 ], [ %198, %191 ]
  %205 = phi i32 [ 8, %0 ], [ %194, %191 ]
  %206 = phi i32 [ 2, %0 ], [ %197, %191 ]
  %207 = phi i32 [ 7, %0 ], [ %195, %191 ]
  %208 = phi i32 [ 3, %0 ], [ %196, %191 ]
  %209 = phi i32 [ 5, %0 ], [ 2, %191 ]
  %210 = phi i32 [ 9, %0 ], [ 0, %191 ]
  %211 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %210)
  %212 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 1)
  %213 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %209)
  %214 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %208)
  %215 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %207)
  %216 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %206)
  %217 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %205)
  %218 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %204)
  %219 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %203)
  %220 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %202)
  %221 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %2) #6
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}

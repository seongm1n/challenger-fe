import SwiftUI

// MARK: - 회고 작성 화면
struct CompletionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: CompletionViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - 초기화
    init(challenge: Challenge) {
        _viewModel = StateObject(wrappedValue: CompletionViewModel(challenge: challenge))
    }
    
    // MARK: - 뷰 본문
    var body: some View {
        ZStack {
            StarryBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView(title: "완료하기", onBackTap: {
                    presentationMode.wrappedValue.dismiss()
                })
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ChallengeInfoSection(challenge: challenge)
                        
                        RetrospectionSection(
                            text: $viewModel.retrospectionText,
                            isTextFieldFocused: $isTextFieldFocused,
                            errorMessage: viewModel.errorMessage
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            
            BottomCompleteButton(
                isSaving: viewModel.isSaving,
                action: {
                    isTextFieldFocused = false
                    viewModel.saveRetrospection()
                }
            )
            
            // 로딩 화면
            if viewModel.isSaving {
                LoadingOverlay()
            }
            
            // 성공 화면
            if viewModel.showSuccessView {
                SuccessView(assessment: viewModel.assessment, onComplete: {
                    viewModel.completeSuccessView()
                })
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .onChange(of: viewModel.isCompleted) { _, isCompleted in
            if isCompleted {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - 헤더 뷰
private struct HeaderView: View {
    let title: String
    let onBackTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: onBackTap) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 10)
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 30)
    }
}

// MARK: - 챌린지 정보 섹션
private struct ChallengeInfoSection: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoField(
                label: "도전 제목",
                content: challenge.title,
                fontSize: 22,
                fontWeight: .bold
            )
            
            InfoField(
                label: "도전 내용",
                content: challenge.description,
                fontSize: 16,
                opacity: 0.8,
                lineSpacing: 5
            )
            
            InfoField(
                label: "진행 기간",
                content: "총 \(challenge.duration)일",
                fontSize: 16,
                opacity: 0.8
            )
        }
    }
}

// MARK: - 정보 필드
private struct InfoField: View {
    let label: String
    let content: String
    let fontSize: CGFloat
    var fontWeight: Font.Weight = .regular
    var opacity: Double = 1.0
    var lineSpacing: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(content)
                .font(.system(size: fontSize, weight: fontWeight))
                .foregroundColor(.white.opacity(opacity))
                .lineSpacing(lineSpacing)
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                .cornerRadius(10)
        }
    }
}

// MARK: - 회고 작성 섹션
private struct RetrospectionSection: View {
    @Binding var text: String
    @FocusState.Binding var isTextFieldFocused: Bool
    var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("회고 작성")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text("이곳에 도전에 대한 회고를 작성해주세요.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 5)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .focused($isTextFieldFocused)
                    .padding(10)
                    .frame(minHeight: 200)
                    .background(Color(UIColor(red: 0.18, green: 0.18, blue: 0.28, alpha: 1.0)))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                    )
                
                if text.isEmpty && !isTextFieldFocused {
                    Text("도전을 진행하면서 느낀 점, 어려웠던 점, 배운 점 등을 자유롭게 적어주세요.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding(.top, 5)
            }
        }
    }
}

// MARK: - 텍스트 에디터 (플레이스홀더 포함)
private struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    @Binding var isTextFieldFocused: Bool
    let placeholderText: String
    let hasError: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(10)
                .frame(minHeight: 200)
                .background(Color(UIColor(red: 0.18, green: 0.18, blue: 0.28, alpha: 1.0)))
                .foregroundColor(.white)
                .cornerRadius(10)
                .scrollContentBackground(.hidden)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(hasError ? Color.red : Color.clear, lineWidth: 1)
                )
            
            if text.isEmpty && !isTextFieldFocused {
                Text(placeholderText)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 18)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - 하단 완료 버튼
private struct BottomCompleteButton: View {
    let isSaving: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: action) {
                HStack(spacing: 10) {
                    if isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Text("도전 완료하기")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(UIColor(red: 0.35, green: 0.55, blue: 0.85, alpha: 1.0)),
                            Color(UIColor(red: 0.25, green: 0.45, blue: 0.75, alpha: 0.95))
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                .cornerRadius(10)
                .shadow(color: Color(UIColor(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.3)), radius: 8, x: 0, y: 4)
            }
            .disabled(isSaving)
            .opacity(isSaving ? 0.7 : 1.0)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .background(
                Rectangle()
                    .fill(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 0.95)))
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}

// MARK: - 챌린지 접근 확장
extension CompletionView {
    var challenge: Challenge {
        let mirror = Mirror(reflecting: viewModel)
        return mirror.children.first(where: { $0.label == "challenge" })?.value as! Challenge
    }
}

// MARK: - 미리보기
struct CompletionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleChallenge = Challenge(
            id: 1,
            title: "매일 30분 조깅하기",
            description: "매일 아침 30분씩 조깅을 하면서 건강한 하루를 시작하기 위한 도전입니다. 꾸준히 실천하여 건강 습관을 만들어보세요.",
            duration: 30,
            progress: 0.7
        )
        
        CompletionView(challenge: sampleChallenge)
    }
}

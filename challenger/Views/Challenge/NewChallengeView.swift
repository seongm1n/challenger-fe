import SwiftUI

// MARK: - 새 도전 생성 화면
struct NewChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = NewChallengeViewModel()
    
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case title, description, period
    }

    // MARK: - 뷰 본문
    var body: some View {
        ZStack {
            StarryBackgroundView()
            
            VStack(alignment: .leading, spacing: 25) {
                HeaderView()
                
                TitleInputField(
                    title: $viewModel.challengeTitle,
                    focusedField: $focusedField
                )

                DescriptionInputField(
                    description: $viewModel.challengeDescription,
                    focusedField: $focusedField
                )

                PeriodInputField(
                    period: $viewModel.targetPeriod,
                    focusedField: $focusedField
                )

                StartDateField(formattedDate: viewModel.formattedDate)

                Spacer()

                StartChallengeButton(
                    isFormValid: viewModel.isFormValid,
                    action: {
                        viewModel.createChallenge()
                        focusedField = nil
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
        }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                ChallengesViewModel.shared.refreshChallenges()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - 헤더 뷰
private struct HeaderView: View {
    var body: some View {
        Text("새 도전 만들기")
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(.white)
            .padding(.bottom, 15)
    }
}

// MARK: - 제목 입력 필드
private struct TitleInputField: View {
    @Binding var title: String
    @FocusState.Binding var focusedField: NewChallengeView.Field?
    
    var body: some View {
        InputField(
            label: "도전 제목",
            placeholder: "도전 제목을 입력하세요",
            text: $title,
            fieldType: .title,
            focusedField: $focusedField
        )
    }
}

// MARK: - 설명 입력 필드
private struct DescriptionInputField: View {
    @Binding var description: String
    @FocusState.Binding var focusedField: NewChallengeView.Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("도전 내용")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.8))
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                    .focused($focusedField, equals: .description)
                    .frame(height: 150)
                    .padding(10)
                    .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedField == .description ? Color.blue : Color.clear, lineWidth: 1)
                    )
                    .tint(.blue)
                    .scrollContentBackground(.hidden)
                    .lineSpacing(5)

                if description.isEmpty {
                    Text("도전에 대한 설명을 입력하세요")
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

// MARK: - 기간 입력 필드
private struct PeriodInputField: View {
    @Binding var period: String
    @FocusState.Binding var focusedField: NewChallengeView.Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("목표 기간")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.8))
            
            HStack(spacing: 10) {
                ZStack(alignment: .center) {
                    TextField("", text: $period)
                        .focused($focusedField, equals: .period)
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                        .padding(15)
                        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedField == .period ? Color.blue : Color.clear, lineWidth: 1)
                        )
                        .tint(.blue)
                        .multilineTextAlignment(.center)
                    
                    if period.isEmpty {
                        Text("30")
                            .foregroundColor(Color.white.opacity(0.4))
                            .allowsHitTesting(false)
                    }
                }
                
                Text("일")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.8))
                
                Spacer()
            }
        }
    }
}

// MARK: - 시작일 필드
private struct StartDateField: View {
    let formattedDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("도전 시작일")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.8))
            
            Text(formattedDate)
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                .foregroundColor(Color.white.opacity(0.8))
                .cornerRadius(10)
        }
    }
}

// MARK: - 입력 필드 공통 컴포넌트
private struct InputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let fieldType: NewChallengeView.Field
    @FocusState.Binding var focusedField: NewChallengeView.Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.8))
            
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .focused($focusedField, equals: fieldType)
                    .padding(15)
                    .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedField == fieldType ? Color.blue : Color.clear, lineWidth: 1)
                    )
                    .tint(.blue)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(.leading, 15)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

// MARK: - 도전 시작 버튼
private struct StartChallengeButton: View {
    let isFormValid: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "flag.fill")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("도전 시작하기")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.5)
    }
}

// MARK: - 미리보기
struct NewChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        NewChallengeView()
    }
}

import SwiftUI

struct CompletionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: CompletionViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init(challenge: Challenge) {
        _viewModel = StateObject(wrappedValue: CompletionViewModel(challenge: challenge))
    }
    
    var body: some View {
        ZStack {
            StarryBackgroundView()
            
            VStack(spacing: 0) {
                Text("회고하기")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("도전 제목")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(challenge.title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("도전 내용")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(challenge.description)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(5)
                                .padding(15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("진행 기간")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("총 \(challenge.duration)일")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회고 작성")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("이곳에 도전에 대한 회고를 작성해주세요.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.bottom, 5)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $viewModel.retrospectionText)
                                    .focused($isTextFieldFocused)
                                    .padding(10)
                                    .frame(minHeight: 200)
                                    .background(Color(UIColor(red: 0.18, green: 0.18, blue: 0.28, alpha: 1.0)))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .scrollContentBackground(.hidden)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                                    )
                                
                                if viewModel.retrospectionText.isEmpty && !isTextFieldFocused {
                                    Text("도전을 진행하면서 느낀 점, 어려웠던 점, 배운 점 등을 자유롭게 적어주세요.")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.4))
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 18)
                                        .allowsHitTesting(false)
                                }
                            }
                            
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    isTextFieldFocused = false
                    viewModel.saveRetrospection()
                }) {
                    HStack(spacing: 10) {
                        if viewModel.isSaving {
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
                .disabled(viewModel.isSaving)
                .opacity(viewModel.isSaving ? 0.7 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .background(
                    Rectangle()
                        .fill(Color(UIColor(red: 0.11, green: 0.11, blue: 0.2, alpha: 0.95)))
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: 
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        )
        .onChange(of: viewModel.isCompleted) { _, isCompleted in
            if isCompleted {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension CompletionView {
    var challenge: Challenge {
        let mirror = Mirror(reflecting: viewModel)
        return mirror.children.first(where: { $0.label == "challenge" })?.value as! Challenge
    }
}

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

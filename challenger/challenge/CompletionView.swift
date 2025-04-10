import SwiftUI

struct CompletionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let challengeTitle = "매일 30분 조깅하기"
    let challengeDescription = "매일 아침 30분씩 조깅을 하면서 건강한 하루를 시작하기 위한 도전입니다. 꾸준히 실천하여 건강 습관을 만들어보세요."
    
    @State private var reflectionText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // 별이 반짝이는 배경 추가
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
                            
                            Text(challengeTitle)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                                .cornerRadius(10)
                        }
                        
                        // 도전 내용 섹션
                        VStack(alignment: .leading, spacing: 5) {
                            Text("도전 내용")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(challengeDescription)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(5)
                                .padding(15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                                .cornerRadius(10)
                        }
                        
                        // 회고 작성 섹션
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회고 작성")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("이곳에 도전에 대한 회고를 작성해주세요.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.bottom, 5)
                            
                            Text("도전을 진행하면서 느낀 점, 어려웠던 점, 배운 점 등을 자유롭게 적어주세요.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.bottom, 10)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $reflectionText)
                                    .focused($isTextFieldFocused)
                                    .padding(10)
                                    .frame(minHeight: 200)
                                    .background(Color(UIColor(red: 0.18, green: 0.18, blue: 0.28, alpha: 1.0)))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .scrollContentBackground(.hidden)
                                
                                if reflectionText.isEmpty && !isTextFieldFocused {
                                    Text("도전을 진행하면서 느낀 점, 어려웠던 점, 배운 점 등을 자유롭게 적어주세요.")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.4))
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 18)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // 하단 버튼 공간 확보
                }
                
                Spacer()
            }
            
            // 하단 회고 저장 버튼
            VStack {
                Spacer()
                
                Button(action: {
                    // 회고 저장 로직
                    saveReflection()
                }) {
                    Text("회고 저장하기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(UIColor(red: 0.25, green: 0.5, blue: 0.85, alpha: 1.0)))
                        .cornerRadius(10)
                }
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
            // 화면 탭 시 키보드 내리기
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
    }
    
    // 회고 저장 함수
    private func saveReflection() {
        // 회고 저장 로직 구현
        // 저장 완료 후 화면 닫기
        presentationMode.wrappedValue.dismiss()
    }
}

struct CompletionView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionView()
    }
}

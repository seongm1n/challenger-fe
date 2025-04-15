import SwiftUI

// MARK: - 로그인 화면
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    // MARK: - 뷰 본문
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer().frame(height: 150)
                
                WelcomeHeaderView()
                
                Spacer().frame(height: 100)

                NicknameInputField(nickname: $viewModel.nickname)
                
                LoginButton(
                    isEnabled: viewModel.isButtonEnabled,
                    action: viewModel.login
                )
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $viewModel.isLoginComplete) {
                MainView()
            }
        }
    }
}

// MARK: - 환영 헤더 뷰
private struct WelcomeHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("환영합니다!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text("닉네임을 입력하고 시작하세요")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - 닉네임 입력 필드
private struct NicknameInputField: View {
    @Binding var nickname: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("닉네임을 입력해주세요", text: $nickname)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

// MARK: - 로그인 버튼
private struct LoginButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("시작하기")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
        .padding(.bottom, 70)
    }
}

// MARK: - 메인 뷰
struct MainView: View {
    var body: some View {
        ContentView()
    }
}

// MARK: - 미리보기
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

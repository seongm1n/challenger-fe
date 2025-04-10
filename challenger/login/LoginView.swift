import SwiftUI

struct LoginView: View {
    @State private var nickname = ""
    @State private var isLoginComplete = false
    @AppStorage("userNickname") private var storedNickname = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer().frame(height: 150)
                
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
                
                Spacer().frame(height: 100)

                VStack(alignment: .leading, spacing: 8) {
                    TextField("닉네임을 입력해주세요", text: $nickname)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Button(action: {
                    if !nickname.isEmpty {
                        storedNickname = nickname
                        isLoginComplete = true
                    }
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(nickname.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(nickname.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 70)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isLoginComplete) {
                MainView()
            }
        }
    }
}

struct MainView: View {
    var body: some View {
        ContentView()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

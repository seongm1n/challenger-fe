import SwiftUI

struct NewChallengeView: View {
    @State private var challengeTitle: String = ""
    @State private var challengeDescription: String = ""
    @State private var targetPeriod: String = ""
    @State private var startDate: Date = Date()
    
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case title, description, period
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }

    var body: some View {
        ZStack {
            StarryBackgroundView()
            VStack(alignment: .leading, spacing: 25) {
                Text("새 도전 만들기")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("도전 제목")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    ZStack(alignment: .leading) {
                        TextField("", text: $challengeTitle)
                            .focused($focusedField, equals: .title)
                            .padding(15)
                            .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .title ? Color.blue : Color.clear, lineWidth: 1)
                            )
                            .tint(.blue)
                        
                        if challengeTitle.isEmpty {
                            Text("도전 제목을 입력하세요")
                                .foregroundColor(Color.white.opacity(0.4))
                                .padding(.leading, 15)
                                .allowsHitTesting(false)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("도전 내용")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $challengeDescription)
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

                        if challengeDescription.isEmpty {
                            Text("도전에 대한 설명을 입력하세요")
                                .foregroundColor(Color.white.opacity(0.4))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 18)
                                .allowsHitTesting(false)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("목표 기간")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    HStack(spacing: 10) {
                        ZStack(alignment: .center) {
                            TextField("", text: $targetPeriod)
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
                            
                            if targetPeriod.isEmpty {
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("도전 시작일")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    Text(dateFormatter.string(from: startDate))
                        .padding(15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)))
                        .foregroundColor(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    print("새 도전 만들기:")
                    print("제목: \(challengeTitle)")
                    print("내용: \(challengeDescription)")
                    print("기간: \(targetPeriod) 일")
                    print("시작일: \(dateFormatter.string(from: startDate))")
                    focusedField = nil
                }) {
                    Text("도전 시작하기")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)))
                        .cornerRadius(10)
                }
                .disabled(challengeTitle.isEmpty || challengeDescription.isEmpty || targetPeriod.isEmpty)
                .opacity((challengeTitle.isEmpty || challengeDescription.isEmpty || targetPeriod.isEmpty) ? 0.5 : 1.0)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
        }
    }
}

struct NewChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        NewChallengeView()
    }
}

//
//  ContentView.swift
//  LittleGenius
//
//  Created by Lem Euro on 20/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var table = 0
    @State private var questions = 5
    @State private var gameActive = false
    
    @State private var round = 0
    @State private var score = 0
    
    @State private var secondNumber = 0
    @State private var answer = 0
    @State private var answers = [Int]()
    @State private var answerStatus = ""
    @State private var selectedAnswer = -1
    
    @State private var animateGradient = false
    @State private var answerColorAnimation = 0
    @State private var animationScale = 1.0
    @State private var blurAnim = false
    @State private var scoreAnimation = 1.0
    @State private var scoreScale = 1.0
    @State private var rotationAnim = 0.0
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    @State private var dragAmountButton = CGSize.zero
    @State private var isShowingSmile = false
    
    @State private var disableAnswers = false
    
    let columns = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.purple, .pink, .red, .orange, .yellow, .green, .cyan, .mint, .blue, .indigo]), center: .topLeading, startAngle: .zero, endAngle: animateGradient ? .degrees(190) : .degrees(90))
                .ignoresSafeArea()
                
            if gameActive {
                ZStack {
                    VStack {
                        Text("\(table)x")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        VStack {
                            Text("What is \(table) * \(secondNumber) ?")
                                .font(.largeTitle.bold())
                            Divider()
                            Text("Question \(round) / \(questions)")
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 15)
                        
                        Text(answerStatus)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 15)
                            .font(.title3)
                            .foregroundColor(answerColorAnimation == 0 ? .primary : answerColorAnimation == 1 ? .green : .red)
                        
                        HStack {
                            ForEach(0..<answers.count, id: \.self) { number in
                                Button(String(answers[number])) {
                                    checkAnswer(number: answers[number])
                                    withAnimation {
                                        rotationAnim += 360
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .background(enabled ? .cyan : .indigo)
                                .clipShape(Circle())
                                .shadow(radius: 15)
                                .disabled(disableAnswers)
                                .scaleEffect(selectedAnswer == answers[number] ? animationScale : 1.0)
                                .blur(radius: selectedAnswer == answers[number] && blurAnim ? 2 : 0)
                                .animation(.default, value: blurAnim)
                                .rotation3DEffect(.degrees(selectedAnswer == answers[number] && answerColorAnimation == 1 ? rotationAnim : 0), axis: (x: 0, y: 1, z: 0))
                                .offset(dragAmountButton)
                                .animation(
                                    .default.delay(Double(number) / 20),
                                    value: dragAmountButton)
                            }
                        }
                        .padding()
                        .gesture(
                            DragGesture()
                                .onChanged { dragAmountButton = $0.translation}
                                .onEnded { _ in
                                    dragAmountButton = .zero
                                    enabled.toggle()
                                }
                        )
                        
                        Spacer()
                        
                        Text("Scores \(score)")
                            .padding(40)
                            .background(.thinMaterial)
                            .foregroundStyle(.primary)
                            .shadow(radius: 15)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .stroke(.thinMaterial)
                                .scaleEffect(scoreAnimation)
                                .opacity(1.5 - scoreAnimation)
                                .animation(
                                    .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false),
                                    value: scoreAnimation
                                )
                            )
                            .onAppear {
                                scoreAnimation = 1.5
                            }
                            .scaleEffect(scoreScale)
                            .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: scoreScale)
                            .offset(dragAmount)
                            .gesture(
                                DragGesture()
                                    .onChanged { dragAmount = $0.translation}
                                    .onEnded { _ in
                                        withAnimation {
                                            dragAmount = .zero
                                        }
                                    }
                            )
                        
                        Spacer()
                        
                        if round == questions {
                            
                            Button("Start New Game!") {
                                withAnimation {
                                    animateGradient.toggle()
                                    gameActive.toggle()
                                }
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(.indigo)
                            .clipShape(Capsule())
                            
                        } else {
                            Button("Next Question") {
                                nextRound()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(answerColorAnimation == 0 ? .gray : .indigo)
                            .clipShape(Capsule())
                            .disabled(answerColorAnimation == 0 ? true : false)
                        }
                    }
                    
                    VStack {
                        if isShowingSmile {
                            Text("🥳")
                                .font(.system(size: 80))
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        }
                    }
                    .offset(x: 130, y: 230)
                    
                }
                .padding()
                .preferredColorScheme(.dark)
            } else {
                VStack {
                    Spacer()
                    
                    Text("Choose table for practice")
                        .font(.title).bold()
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(2..<14) { num in
                            Button {
                                table = num
                            } label: {
                                Text(String(num))
                                    .frame(width: 60, height: 60)
                                    .background(table == num ? .indigo : . white)
                                    .font(.headline).bold()
                                    .foregroundColor(table == num ? .white : .primary)
                                    .clipShape(Circle())
                                    .shadow(radius: 15)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Number of questions")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    VStack {
                        Text("\(questions)")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        Stepper("Number of questions", value: $questions, in: 3...20)
                            .labelsHidden()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    Button {
                        newGame()
                    } label: {
                        Text("Start Game")
                            .padding()
                            .foregroundColor(.white)
                            .background(.indigo)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .preferredColorScheme(.light)
            }
        }
    }
    
    func newGame() {
        round = 0
        score = 0
        scoreScale = 1.0
        
        withAnimation {
            animateGradient.toggle()
            gameActive.toggle()
        }
        
        nextRound()
    }
    
    func nextRound() {
        withAnimation {
            isShowingSmile = false
        }
        round += 1
        animationScale = 1.0
        disableAnswers = false
        blurAnim = false
        answers.removeAll()
        answerStatus = "Choose the correct answer:"
        answerColorAnimation = 0
        
        secondNumber = Int.random(in: 2...13)
        
        answer = table * secondNumber
        answers.append(answer)
        
        for _ in 0...2 {
            withAnimation {
                answers.append(Int.random(in: 2...13) * Int.random(in: 2...13))
            }
        }
        answers.shuffle()
    }
    
    func checkAnswer(number: Int) {
        selectedAnswer = number
        animationScale = 1.0
        disableAnswers = true
        
        if number == answer {
            withAnimation {
                answerStatus = "Correct! You're Amazing!"
                answerColorAnimation = 1
                animationScale = 1.2
                isShowingSmile = true
            }
            
            score += 1
            if scoreScale < 2.0 {
                scoreScale += 0.2
            }
        } else {
            withAnimation {
                answerStatus = "Wrong, puppy!"
                answerColorAnimation = 2
                animationScale = 0.8
            }
            
            if score > 0 {
                score -= 1
            }
            if scoreScale > 1.0 {
                scoreScale -= 0.2
            }

            
            blurAnim = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

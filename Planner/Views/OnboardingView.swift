//
//  OnboardingView.swift
//  Planner
//
//  Created by Topi on 25/04/26.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            Color.daynestBackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Daynest")
                    .dynaPuffFont(size: 40)
                    .bold()
                    .foregroundStyle(.daynestAccent)
                
            
                Image("illustration_hero")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text("Start")
                        .dynaPuffFont(size: 18)
                        .bold()
                        .foregroundStyle(.daynestAccent)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.daynestAccent, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    OnboardingView()
}




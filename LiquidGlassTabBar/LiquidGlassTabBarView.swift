//
//  LiquidGlassTabBarView.swift
//  LiquidGlassTabBar
//
//  Created by Tilak Shakya on 11/06/25.
//

import SwiftUI

struct LiquidGlassTabBarView: View {
    @State private var selected: Tab = .home
    @Namespace private var animation

    // Bubble Animation State
    @State private var jumpOffset: CGFloat = 0
    @State private var bubbleScaleX: CGFloat = 1.0
    @State private var bubbleScaleY: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Dynamic Background
            Color.black.ignoresSafeArea()

            // Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()

                    Button {
                        // Step 1: Pre-Jump Expansion
                        withAnimation(.easeOut(duration: 0.1)) {
                            bubbleScaleX = 1.1
                            bubbleScaleY = 1.1
                        }

                        // Step 2: Jump + Tab Change
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            jumpOffset = -18
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selected = tab
                            }

                            // Step 3: Land + Squish
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeOut(duration: 0.12)) {
                                    jumpOffset = 10
                                    bubbleScaleX = 1.1
                                    bubbleScaleY = 0.8
                                }

                                // Step 4: Return to Normal
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                                        jumpOffset = 0
                                        bubbleScaleX = 1.0
                                        bubbleScaleY = 1.0
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            if selected == tab {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.08)
                                    .background(
                                        Capsule()
                                            .fill(
                                                AngularGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0.2),
                                                        Color.white.opacity(0.05),
                                                        Color.clear,
                                                        Color.white.opacity(0.1)
                                                    ]),
                                                    center: .center
                                                )
                                            )
                                            .blur(radius: 25)
                                    )
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.4),
                                                        Color.white.opacity(0.1)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.2
                                            )
                                            .blur(radius: 0.5)
                                    )
                                    .overlay(
                                        Capsule()
                                            .fill(
                                                RadialGradient(
                                                    colors: [
                                                        Color.white.opacity(0.05),
                                                        Color.clear
                                                    ],
                                                    center: .center,
                                                    startRadius: 2,
                                                    endRadius: 30
                                                )
                                            )
                                            .blur(radius: 10)
                                    )
                                    .shadow(color: Color.white.opacity(0.1), radius: 3, x: 0, y: 1)
                                    .shadow(color: Color.white.opacity(0.05), radius: 10, x: 0, y: 5)
                                    .scaleEffect(x: bubbleScaleX, y: bubbleScaleY)
                                    .offset(y: jumpOffset)
                                    .matchedGeometryEffect(id: "liquidGlass", in: animation)
                            }

                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(
                                    selected == tab
                                    ? Color.white
                                    : Color.white.opacity(0.6)
                                )
                                .scaleEffect(selected == tab ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: selected)
                        }
                        .frame(width: 60, height: 38)
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 35, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: 20)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 35, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.1),
                                        Color.clear,
                                        Color.white.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.white.opacity(0.1), radius: 15, x: 0, y: -5)
                    .shadow(color: Color.black.opacity(0.4), radius: 25, x: 0, y: 15)
            )
            .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

enum Tab: CaseIterable {
    case home, explore, favorites, settings

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "safari.fill"
        case .favorites: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

#Preview {
    LiquidGlassTabBarView()
}

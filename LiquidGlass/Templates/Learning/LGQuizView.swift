// LGQuizView.swift
// LiquidGlass Framework
// © 2026 — Private Library

import SwiftUI

// MARK: - LGQuizContent

/// Content slot protocol for ``LGQuizView``.
public protocol LGQuizContent {
    associatedtype QuestionView: View
    associatedtype AnswerOptionsView: View
    associatedtype FeedbackView: View

    @ViewBuilder var questionView: QuestionView { get }
    @ViewBuilder var answerOptionsView: AnswerOptionsView { get }
    @ViewBuilder var feedbackView: FeedbackView { get }

    var quizTitle: LocalizedStringKey { get }
    var currentQuestion: Int { get }
    var totalQuestions: Int { get }
    var hasAnswered: Bool { get }
    var onNext: () -> Void { get }
}

// MARK: - LGQuizView

/// A quiz/assessment template: progress header, question card, answer options, and feedback.
public struct LGQuizView<Content: LGQuizContent>: View {

    @Environment(\.lgTheme) private var theme
    @Environment(\.lgReduceTransparency) private var lgOverrideTransparency
    @Environment(\.accessibilityReduceTransparency) private var sysReduceTransparency
    private var reduceTransparency: Bool { sysReduceTransparency || lgOverrideTransparency }
    @Environment(\.lgReduceMotion) private var lgOverrideMotion
    @Environment(\.accessibilityReduceMotion) private var sysReduceMotion
    private var reduceMotion: Bool { sysReduceMotion || lgOverrideMotion }

    private let content: Content

    public init(content: Content) { self.content = content }

    public var body: some View {
        NavigationStack {
            VStack(spacing: LGSpacing.lg) {
                // Header progress
                VStack(spacing: LGSpacing.sm) {
                    HStack {
                        Text("Question \(content.currentQuestion) of \(content.totalQuestions)")
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.secondary)
                        Spacer()
                        LGProgressRing(
                            value: Double(content.currentQuestion) / Double(content.totalQuestions),
                            size: 36,
                            lineWidth: 3
                        )
                    }
                    LGProgressBar(
                        value: Double(content.currentQuestion) / Double(content.totalQuestions),
                        label: "lg.progress.label"
                    )
                }
                .padding(.horizontal, LGSpacing.md)

                // Question
                GlassEffectContainer(spacing: LGSpacing.md) {
                    content.questionView
                        .padding(.horizontal, LGSpacing.lg)
                        .padding(.vertical, LGSpacing.md)
                }
                .padding(.horizontal, LGSpacing.md)

                // Answer options
                content.answerOptionsView
                    .padding(.horizontal, LGSpacing.md)

                // Feedback (shown after answering)
                if content.hasAnswered {
                    content.feedbackView
                        .padding(.horizontal, LGSpacing.md)
                        .transition(reduceMotion ? .identity : LGTransitions.slideUp)
                }

                Spacer()

                if content.hasAnswered {
                    LGButton("Next Question", style: .glassProminent, action: content.onNext)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, LGSpacing.lg)
                        .padding(.bottom, LGSpacing.md)
                        .transition(reduceMotion ? .identity : LGTransitions.scaleIn)
                }
            }
            .animation(reduceMotion ? .default : LGAnimations.snappy, value: content.hasAnswered)
            .navigationTitle(content.quizTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

private struct QuizPreviewContent: LGQuizContent {
    @State var answered = false

    var questionView: some View {
        VStack(alignment: .leading, spacing: LGSpacing.sm) {
            LGTag("Swift", style: .surface)
            Text("Which keyword is used to define an asynchronous function?")
                .font(.headline)
        }
    }

    var answerOptionsView: some View {
        GlassEffectContainer(spacing: LGSpacing.sm) {
            VStack(spacing: LGSpacing.sm) {
                ForEach(["async", "await", "defer", "throws"], id: \.self) { option in
                    Button {
                        withAnimation(LGAnimations.snappy) { answered = true }
                    } label: {
                        Text(option)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, LGSpacing.md)
                            .padding(.vertical, LGSpacing.sm)
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }

    var feedbackView: some View {
        LGCard(.compact) {
            HStack(spacing: LGSpacing.sm) {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green).accessibilityHidden(true)
                Text("Correct! `async` marks a function as asynchronous.")
                    .font(.body)
            }
        }
    }

    var quizTitle: LocalizedStringKey { "Swift Quiz" }
    var currentQuestion: Int { 3 }
    var totalQuestions: Int { 10 }
    var hasAnswered: Bool { answered }
    var onNext: () -> Void { {} }
}

#Preview("Quiz") {
    LGQuizView(content: QuizPreviewContent())
}

#Preview("Quiz — Reduce Transparency") {
    LGQuizView(content: QuizPreviewContent())
        .lgPreviewReduceTransparency()
}

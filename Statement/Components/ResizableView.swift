//
//  ResizableView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI
import Foundation

public extension Comparable {
    func clamp(_ minValue: Self, _ maxValue: Self) -> Self {
        return min(max(self, minValue), maxValue)
    }
}

struct ResizingView<ClippedContent: View>: View {
    let clippedContent: () -> ClippedContent
    let geo: GeometryProxy

    private let minWidth: CGFloat = 50

    @GestureState private var dragWidth = CGFloat.zero
    @State private var widthPosition = CGFloat.zero

    var maxWidth: CGFloat {
        (geo.size.width - 50).clamp(minWidth, geo.size.width)
    }

    private var width: CGFloat {
        return abs((dragWidth + widthPosition)).clamp(minWidth, maxWidth)
    }

    private var clampedPosition: CGFloat {
        widthPosition.clamp(minWidth, maxWidth)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            clippedContent()
                .mask(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .task {
                            widthPosition = geo.size.width/2
                        }
                }

            Resizer()
                .position(x: clampedPosition, y: geo.size.height/2)
                .offset(x: dragWidth, y: 0)
                .gesture(
                    DragGesture()
                        .updating($dragWidth) { value, state, transaction in
                            let newWith = value.translation.width
                            if (newWith + widthPosition) > maxWidth {
                                return
                            }

                            if (newWith + widthPosition) < minWidth {
                                return
                            }

                            state = newWith
                        }
                        .onEnded({ value in
                            widthPosition = value.location.x.clamp(minWidth, maxWidth)
                        })
                )
        }
    }
}



struct ResizableView<FullContent: View, ClippedContent: View>: View {
    let fullContent: () -> FullContent
    let clippedContent: () -> ClippedContent

    private let minWidth: CGFloat = 50

    @GestureState private var dragWidth = CGFloat.zero
    @State private var widthPosition = CGFloat.zero
    @State private var maxWidth: CGFloat = 400

    private var width: CGFloat {
        return abs((dragWidth + widthPosition)).clamp(minWidth, maxWidth)
    }

    private var clampedPosition: CGFloat {
        widthPosition.clamp(minWidth, maxWidth)
    }

    var body: some View {
        fullContent()
            .overlay {
                GeometryReader { geo in
                    ResizingView(clippedContent: { clippedContent() }, geo: geo)
                }
            }
            .mask(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
            }
    }
}

struct Resizer: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.primary)
                .frame(width: 2)

            Rectangle()
                .fill(.clear)
                .overlay(content: {
                    HStack(spacing: 4) {
                        Capsule()
                            .fill(.secondary)
                            .frame(width: 2)
                        Capsule()
                            .fill(.secondary)
                            .frame(width: 2)
                        Capsule()
                            .fill(.secondary)
                            .frame(width: 2)
                    }
                    .padding(2)
                })
                .regularButtonStyle()
                .frame(width: 26, height: 60)
        }
    }
}

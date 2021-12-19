//
//  GameScreen.swift
//  TheGameOfLife
//
//  Created by Nguyen Tran Duy Khang on 11/30/21.
//

import SwiftUI

struct GameScreen: View {
    @ObservedObject var gridViewModel = GridViewModel()
    
    var gridLineWidth: CGFloat = 3
    var body: some View {
        Canvas { context, size in
            gridViewModel.recalibrateScreenSize(size: size)
            for height in 0..<gridViewModel.height {
                for width in 0..<gridViewModel.width {
                    context.stroke(gridViewModel.getSquarePathAtIndex(x: width,
                                                                      y: height,
                                                                      screenSize: size),
                                   with: .color(.red))
                    
                    //                    print(gridViewModel.grid)
                    if gridViewModel.grid[width][height].state == .on {
                        fillASquare(context: context,
                                    outerPath: gridViewModel.getSquarePathAtIndex(x: width,
                                                                                  y: height,
                                                                                  screenSize: size))


//                        let outerPath = gridViewModel.getSquarePathAtIndex(x: width,
//                                                                           y: height,
//                                                                           screenSize: size)

                    }
                }
            }
            
        }
        .onTapGesture {
            gridViewModel.nextIteration()
        }
//        SparkleSwing()
    }
    
    func fillASquare(context: GraphicsContext, outerPath: Path) {
        let outerRect = outerPath.boundingRect
        let origin = outerRect.origin
        let numOfStroke = gridViewModel.oneSquareLength / (Int(gridLineWidth)) //
//        for i in 1...numOfStroke {
//            let rectSize = CGSize(width: gridViewModel.oneSquareLength - i * Int(gridLineWidth),
//                                  height: gridViewModel.oneSquareLength - i * Int(gridLineWidth))
//            let newOrigin = CGPoint(x: Int(origin.x) + i * Int(gridLineWidth),
//                                    y: Int(origin.y) + i * Int(gridLineWidth))
//            context.stroke(Path(CGRect(origin: newOrigin,
//                                         size: rectSize)),
//                           with: .color(.blue))
//        }
        
        for i in 1...numOfStroke {
            let rectSize = CGSize(width: gridViewModel.oneSquareLength - i * Int(gridLineWidth),
                                  height: gridViewModel.oneSquareLength - i * Int(gridLineWidth))
            let newOrigin = CGPoint(x: (origin.x) + CGFloat(i) * (gridLineWidth)*0.5,
                                    y: (origin.y) + CGFloat(i) * (gridLineWidth)*0.5)
            context.stroke(Path(CGRect(origin: newOrigin,
                                         size: rectSize)),
                           with: .color(.blue),
                           lineWidth: gridLineWidth)
        }
    }
    
}

//struct SparkleSwing: View {
//
//    @State var sparkCount = 4
//    var body: some View {
//        TimelineView(.animation) { timeline in
//            Canvas { context, size in
//                let now = timeline.date.timeIntervalSinceReferenceDate
//                let angle = Angle.degrees(now.remainder(dividingBy: 3) * 120)
//                let x = cos(angle.radians)
//
//                var image = context.resolve(Image(systemName: "sparkle"))
//                image.shading = .color(.blue)
//                let imageSize = image.size
//
//                context.blendMode = .screen
//                for i in 0..<sparkCount {
//                    let frame = CGRect(
//                        x: 0.5 * size.width + Double(i) * imageSize.width * x,
//                        y: 0.5 * size.height,
//                        width: imageSize.width,
//                        height: imageSize.height
//                    )
//                    var innerContext = context
//                    innerContext.opacity = 0.5
//                    innerContext.fill(Ellipse().path(in: frame), with: .color(.cyan))
//                    context.draw(image, in: frame)
//                }
//            }
//        }
//        .onTapGesture {
//            sparkCount += 1
//        }
//        .accessibilityLabel("A particle visualizer")
//    }
//}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
            .preferredColorScheme(.dark)
    }
}

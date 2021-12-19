//
//  GameScreen.swift
//  TheGameOfLife
//
//  Created by Nguyen Tran Duy Khang on 11/30/21.
//

import SwiftUI

struct GameScreen: View {
    @ObservedObject var gridViewModel = GridViewModel()
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
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
                    
                    if gridViewModel.grid[width][height].state == .on {
                        fillASquare(context: context,
                                    outerPath: gridViewModel.getSquarePathAtIndex(x: width,
                                                                                  y: height,
                                                                                  screenSize: size))


                    }
                }
            }
            
        }
        .onTapGesture {
            gridViewModel.nextIteration()
        }
        .onReceive(timer) { _ in
            gridViewModel.nextIteration()
        }
//        SparkleSwing()
    }
    
    func fillASquare(context: GraphicsContext, outerPath: Path) {
        let outerRect = outerPath.boundingRect
        let origin = outerRect.origin
        let numOfStroke = gridViewModel.oneSquareLength / (Int(gridLineWidth)) //
        
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


struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
            .preferredColorScheme(.dark)
    }
}
